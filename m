Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYD2Ujz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYD2Ujz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYD2Ujo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:39:44 -0400
Received: from email.gcom.com ([12.193.232.146]:37282 "EHLO email.gcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbYD2Ujl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:39:41 -0400
Message-Id: <7.0.1.0.2.20080429153715.04a109b0@gcom.com>
Message-Id: <7.0.1.0.2.20080429142001.046b6c08@gcom.com>
X-Mailer: QUALCOMM Windows Eudora Version 7.0.1.0
Date: Tue, 29 Apr 2008 15:39:41 -0500
To: linux-kernel@vger.kernel.org
From: Dave Grothe <dave@gcom.com>
Subject: profile_pc oops in 2.6.18
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=====================_1908950890==_"; x-avg-checked=avg-ok-52272057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=====================_1908950890==_
Content-Type: text/plain; charset=us-ascii; format=flowed; x-avg-checked=avg-ok-52272057

I have had a problem with a kernel oops in 2.6.18 with the kernel
compiled with stack frame pointers and a loadable module compiled
without stack frame pointers.

I have a patch that fixes the problem for 2.6.18.  It is attached to 
this email.

-- Dave  
--=====================_1908950890==_
Content-Type: application/octet-stream; name=patch-time.c; x-avg-checked=avg-ok-52272057
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch-time.c"

VGhpcyBwYXRjaCBmaXhlcyBhIHByb2JsZW0gaW52b2x2aW5nIGEga2VybmVsIGNyYXNoLgoKSWYg
dGhlIGtlcm5lbCBpcyBjb21waWxlZCB3aXRoIGZyYW1lIHBvaW50ZXJzIGFuZCBhIG1vZHVsZSB0
aGF0IHdhcwpjb21waWxlZCB3aXRob3V0IGZyYW1lIHBvaW50ZXJzIGlzIGxvYWRlZCBhbmQgcnVu
OyBhbmQgaWYgdGhlIAprZXJuZWwgcHJvZmlsZV9wYyByb3V0aW5lIGdldHMgY2FsbGVkIHdoaWxl
IHRoYXQgbW9kdWxlIGlzIGluIGEKc3BpbiBsb2NrLCB0aGVuIHJlZ3MtPmVicCBkb2VzIG5vdCBj
b250YWluIGEgdmFsaWQgZnJhbWUgcG9pbnRlcgphbmQgdGhlIGFjY2VzcyB0byAqKHJlZ3MtPmVi
cCs0KSBwcm9kdWNlcyAodXN1YWxseSkgYW4gYWNjZXNzIHRvCmFuIGludmFsaWQgYWRkcmVzcy4K
ClRoaXMgcGF0Y2ggaW1wbGVtZW50cyBhIGNoZWNrIHRvIHNlZSB0aGF0IHRoZSByZWdzLT5lYnAg
dmFsdWUgbGllcwp3aXRoaW4gdGhlIHRocmVhZF9pbmZvIHJlZ2lvbiBmb3IgdGhlIGN1cnJlbnQg
cHJvY2Vzcy4KClRoZSBwYXRjaCBpcyBmb3IgMi42LjE4LCBhcyBJIGFtIHRlc3Rpbmcgb24gQ2Vu
dE9TLTUuICBIb3dldmVyLApsb29raW5nIGF0IDIuNi4yNSBpdCBzZWVtcyB0aGF0IGl0IHdvdWxk
IGVhc2lseSBhcHBseSB0byB0aGF0Cmtlcm5lbCB2ZXJzaW9uIGFzIHdlbGwsIHdpdGgganVzdCBh
IGxpdHRsZSBtYW51YWwgZml0dGluZy4KCkRhdmUgR3JvdGhlIDI5QXByMjAwOAoKLS0tIGFyY2gv
aTM4Ni9rZXJuZWwvdGltZS5jLm9yaWcJMjAwOC0wNC0yOSAxMTowMjowMi4wMDAwMDAwMDAgLTA1
MDAKKysrIGFyY2gvaTM4Ni9rZXJuZWwvdGltZS5jCTIwMDgtMDQtMjkgMTM6Mjg6MzUuMDAwMDAw
MDAwIC0wNTAwCkBAIC0xMzYsNyArMTM2LDE0IEBACiAJdW5zaWduZWQgbG9uZyBwYyA9IGluc3Ry
dWN0aW9uX3BvaW50ZXIocmVncyk7CiAKIAlpZiAoIXVzZXJfbW9kZV92bShyZWdzKSAmJiBpbl9s
b2NrX2Z1bmN0aW9ucyhwYykpCi0JCXJldHVybiAqKHVuc2lnbmVkIGxvbmcgKikocmVncy0+ZWJw
ICsgNCk7CisJewkJCS8qIGlzIGJwIGEgdmFsaWQgc3RhY2sgYWRkcmVzcz8gICAqLworCSAgICB1
aW50MzJfdCB0aV9iYXNlID0gKHVpbnQzMl90KWN1cnJlbnRfdGhyZWFkX2luZm8oKSA7CisKKwkg
ICAgaWYgKHJlZ3MtPmVicCA+PSB0aV9iYXNlICYmIHJlZ3MtPmVicCA8IHRpX2Jhc2UgKyBUSFJF
QURfU0laRSkKKwkJcmV0dXJuICoodW5zaWduZWQgbG9uZyAqKShyZWdzLT5lYnAgKyA0KTsJLyog
eWVzLCB1c2UgaXQqLworCSAgICBlbHNlCisJCXJldHVybiBwYyA7CisJfQogCiAJcmV0dXJuIHBj
OwogfQo=
--=====================_1908950890==_
Content-Type: text/plain; charset=us-ascii; format=flowed; x-avg-checked=avg-ok-52272057


--=====================_1908950890==_--

