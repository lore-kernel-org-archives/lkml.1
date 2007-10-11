Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbXJKXkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbXJKXkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXJKXkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:40:13 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:46183 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbXJKXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:40:11 -0400
Date: Thu, 11 Oct 2007 16:40:10 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [patch] modpost problem when symbols move from one module to another
Message-ID: <Pine.LNX.4.58.0710111631350.13556@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="289736052-1504327650-1192146010=:13556"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--289736052-1504327650-1192146010=:13556
Content-Type: TEXT/PLAIN; charset=US-ASCII

The v4l-dvb tree recently renamed a module and this caused some problems
with modpost creating incorrect module dependencies.  This patch fixes that
problem.  It should be explained thoroughly in the patch description.
--289736052-1504327650-1192146010=:13556
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="modpost.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0710111640100.13556@shell4.speakeasy.net>
Content-Description: 
Content-Disposition: attachment; filename="modpost.patch"

bW9kcG9zdDogRml4IHByb2JsZW0gd2l0aCBvdXQgb2YgZGF0ZSBNb2R1bGUu
c3ltdmVycw0KDQpXaGVuIHBhcnQgb2YgYnVpbGQgYW4gZXh0ZXJuYWwgbW9k
dWxlIHRyZWUsIG1vZHBvc3QgZmlyc3QgcmVhZHMgaW4gdGhlDQprZXJuZWwn
cyBhbmQgdGhlbiB0aGUgZXh0ZXJuYWwgdHJlZSdzIE1vZHVsZS5zeW12ZXJz
IGZpbGVzLiAgRnJvbSB0aGVzZSBmaWxlcw0KaXQgZXN0YWJsaXNoZXMgYSBz
eW1ib2wgPT4gbW9kdWxlIG1hcHBpbmcuICBXaGVuIGl0IGxhdGVyIHJlYWRz
IGluIGVhY2ggbW9kdWxlDQpidWlsdCBhbmQgcHJvY2Vzc2VzIHRoZSBzeW1i
b2xzIGl0IGZpbmRzLCBpdCBkaXNjb3ZlcnMgdGhlIHN5bWJvbD0+bW9kdWxl
DQptYXBwaW5nIGZyb20gTW9kdWxlLnN5bXZlcnMgYW5kIGxlYXZlcyBpdCBh
cyBpdCBpcy4NCg0KVGhlIHByb2JsZW0gY29tZXMgd2l0aCBhIG1vZHVsZSBo
YXMgYmVlbiByZS1uYW1lZCBvciBhIHN5bWJvbCBoYXMgbW92ZWQgZnJvbQ0K
b25lIG1vZHVsZSB0byBhbm90aGVyLCBzaW5jZSB0aGUgTW9kdWxlLnN5bXZl
cnMgZmlsZSB3YXMgZ2VuZXJhdGVkLiAgbW9kcG9zdA0KZG9lcyBub3QgdXBk
YXRlIHRoZSBzeW1ib2w9Pm1vZHVsZSBtYXBwaW5nIHdoZW4gaXQgZmluZHMg
dGhlIG5ldyBsb2NhdGlvbiBvZg0KdGhlIHN5bWJvbCB3aGVuIHNjYW5uaW5n
IHRoZSBuZXdseSBidWlsdCBtb2R1bGVzLiAgVGhpcyByZXN1bHRzIGluIHRo
ZSBtb2R1bGUNCmNvbnRhaW5pbmcgaW5jb3JyZWN0IGRlcGVuZGVuY3kgaW5m
b3JtYXRpb24gYW5kIHRoZSBuZXcgTW9kdWxlLnN5bXZlcnMgZmlsZQ0Kd3Jp
dHRlbiBieSBtb2Rwb3N0IHdpbGwgYWxzbyBjb250YWluIHRoZSBpbmNvcnJl
Y3QgbWFwcGluZ3MsIHBlcnBldHVhdGluZyB0aGUNCnByb2JsZW0gdG8gdGhl
IG5leHQgYnVpbGQsIGFuZCBzbyBvbi4NCg0KV2hlbiBidWlsZGluZyB0aGUg
b3V0IG9mIGtlcm5lbCBkZXZlbG9wbWVudCB0cmVlIGZvciBrZXJuZWwgc3Vi
c3lzdGVtLCBsaWtlDQp2NGwtZHZiIG9yIEFMU0EsIGRlbGV0aW5nIHRoZSBl
eHRlcm5hbCBNb2R1bGUuc3ltdmVycyBmaWxlIGJlZm9yZSBidWlsZGluZw0K
KHdoaWNoIHRoZSBrZXJuZWwgYnVpbGQgc3lzdGVtIGRvZXNuJ3QgZG8gYW5k
IHNob3VsZG4ndCBiZSBuZWNlc3NhcnkgYW55d2F5KSwNCndvbid0IGZpeCB0
aGUgcHJvYmxlbS4gIG1vZHBvc3Qgc3RpbGwgcmVhZHMgdGhlIGtlcm5lbCdz
IE1vZHVsZS5zeW12ZXJzLCBhbmQNCnNpbmNlIHdlIGEgYnVpbGRpbmcgYSBr
ZXJuZWwgc3Vic3lzdGVtLCBpdCB3aWxsIGRlZmluZSB0aGUgc2FtZSBzeW1i
b2xzIGFzIHRoZQ0KZXh0ZXJuYWwgbW9kdWxlcy4NCg0KU2lnbmVkLW9mZi1i
eTogVHJlbnQgUGllcGhvIDx4eXp6eUBzcGVha2Vhc3kub3JnPg0KDQpkaWZm
IC1yIDc5ZjBlYTFlMGU3MCBzY3JpcHRzL21vZC9tb2Rwb3N0LmMNCi0tLSBh
L3NjcmlwdHMvbW9kL21vZHBvc3QuYwlUdWUgT2N0IDA5IDIxOjAwOjQwIDIw
MDcgKzAwMDANCisrKyBiL3NjcmlwdHMvbW9kL21vZHBvc3QuYwlUaHUgT2N0
IDExIDE1OjIwOjAxIDIwMDcgLTA3MDANCkBAIC0yNjgsNiArMjY4LDkgQEAg
c3RhdGljIHN0cnVjdCBzeW1ib2wgKnN5bV9hZGRfZXhwb3J0ZWQoYw0KIAkJ
CSAgICAgIndhcyBpbiAlcyVzXG4iLCBtb2QtPm5hbWUsIG5hbWUsDQogCQkJ
ICAgICBzLT5tb2R1bGUtPm5hbWUsDQogCQkJICAgICBpc192bWxpbnV4KHMt
Pm1vZHVsZS0+bmFtZSkgPyIiOiIua28iKTsNCisJCX0gZWxzZSB7DQorCQkJ
LyogSW4gY2FzZSBNb2R1bGVzLnN5bXZlcnMgd2FzIG91dCBvZiBkYXRlICov
DQorCQkJcy0+bW9kdWxlID0gbW9kOw0KIAkJfQ0KIAl9DQogCXMtPnByZWxv
YWRlZCA9IDA7DQo=

--289736052-1504327650-1192146010=:13556--
