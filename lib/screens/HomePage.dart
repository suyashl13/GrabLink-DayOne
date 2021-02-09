import 'package:Grab_Link/db/DatabaseHelper.dart';
import 'package:Grab_Link/screens/AddLinkPage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List savedLinks = [];
  bool isLoading = true;
  TextEditingController _editingController = TextEditingController();

  _setpage() async {
    List temp = await DatabaseHelper().getCustomLinks();
    setState(() {
      savedLinks = temp;
      isLoading = false;
    });
  }

  _searchLinks(String searchString) {
    List filteredList = [];
    if (searchString.isNotEmpty) {
      for (var e in savedLinks) {
        if ("${e['title']}${e['category']}${e['link']}${e['dateAdded']}"
            .contains(searchString)) {
          filteredList.add(e);
        }
      }
      setState(() {
        this.savedLinks = filteredList;
      });
    } else {
      setState(() {
        _setpage();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setpage();
  }

  @override
  Widget build(BuildContext context) {
    _linkDetails(String title, int id, String link) {
      return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0.5,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      title.toString().toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Manrope"),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: FlatButton(
                      minWidth: double.maxFinite,
                      onPressed: () {
                        try {
                          launch(link);
                        } catch (e) {
                          Navigator.of(context).pop();
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Visit Link",
                        style: TextStyle(
                            color: Color.fromRGBO(150, 115, 200, 1),
                            fontSize: 16,
                            fontFamily: "Manrope"),
                      )),
                ),
                Container(
                  width: double.maxFinite,
                  child: FlatButton(
                      minWidth: double.maxFinite,
                      onPressed: () {
                        DatabaseHelper().deleteLink(id);
                        _setpage();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontFamily: "Manrope"),
                      )),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 54, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Saved\nLinks",
                style: TextStyle(
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.bold,
                    fontSize: 32),
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: TextFormField(
                          controller: _editingController,
                          onChanged: (newValue) {
                            _searchLinks(newValue);
                          },
                          style: TextStyle(fontSize: 14.5),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(fontSize: 14.5)),
                        ),
                      ),
                      margin: EdgeInsets.only(top: 12),
                      width: double.maxFinite,
                      height: 36,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: IconButton(
                        icon: Icon(Icons.clear_all),
                        onPressed: () {
                          _editingController.clear();
                          _searchLinks("");
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...savedLinks.map((e) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              onTap: () {
                                _linkDetails(e['title'], e['id'], e['link']);
                              },
                              title: Text(
                                e['title'] + " / " + e['category'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "\n" + e['link'] + " \n" + e['dateAdded'],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Color.fromRGBO(150, 115, 200, 1),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddLinkPage())),
      ),
    );
  }
}
