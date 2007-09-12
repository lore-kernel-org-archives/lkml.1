Return-Path: <linux-kernel-owner+w=401wt.eu-S968607AbXILOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968607AbXILOJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968517AbXILOI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:08:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53691 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968503AbXILOI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:08:57 -0400
Date: Wed, 12 Sep 2007 15:08:55 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Michael Haas <laga@laga.ath.cx>
cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: screen partially garbled in i830m (regression)
In-Reply-To: <46E7D5AD.7040605@laga.ath.cx>
Message-ID: <Pine.LNX.4.64.0709121508240.12658@skynet.skynet.ie>
References: <46E7D5AD.7040605@laga.ath.cx>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-775962402-1189606135=:12658"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-775962402-1189606135=:12658
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

> reply so far, that's why I'm posting to LKML this time.  Short summary:
> 874808c6dd429f7431b906a32c7f78a68e7636af broke intel_agp.ko for me, I'm
> getting a garbled screen.

Can you try the attached patch?

Dave.
--29444707-775962402-1189606135=:12658
Content-Type: TEXT/x-diff; charset=US-ASCII; name=0001-intel-agp-Fix-i830-mask-variable-that-changed-with.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0709121508550.12658@skynet.skynet.ie>
Content-Description: 
Content-Disposition: attachment; filename=0001-intel-agp-Fix-i830-mask-variable-that-changed-with.patch

RnJvbSA1NmU1YjIyNmRlMTQwNjgxMmJiZTczOWNhYWQwZDJhOTNmOGM1OTZk
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogRGF2ZSBBaXJsaWUg
PGFpcmxpZWRAbGludXguaWU+DQpEYXRlOiBUaHUsIDEzIFNlcCAyMDA3IDAw
OjA4OjAxICsxMDAwDQpTdWJqZWN0OiBbUEFUQ0hdIGludGVsLWFncDogRml4
IGk4MzAgbWFzayB2YXJpYWJsZSB0aGF0IGNoYW5nZWQgd2l0aCBHMzMgc3Vw
cG9ydA0KDQpUaGUgbWFzayBvbiBpODMwIHNob3VsZCBiZSAweDcwIGFsd2F5
cywgbGF0ZXIgY2hpcHMgMHhGMCBzaG91bGQgYmUgb2theS4NCg0KU2lnbmVk
LW9mZi1ieTogRGF2ZSBBaXJsaWUgPGFpcmxpZWRAbGludXguaWU+DQotLS0N
CiBkcml2ZXJzL2NoYXIvYWdwL2FncC5oICAgICAgIHwgICAgMyArKy0NCiBk
cml2ZXJzL2NoYXIvYWdwL2ludGVsLWFncC5jIHwgICAgMiArLQ0KIDIgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2FncC9hZ3AuaCBiL2RyaXZl
cnMvY2hhci9hZ3AvYWdwLmgNCmluZGV4IDM1YWIxYTkuLjg5NTVlN2YgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvYWdwL2FncC5oDQorKysgYi9kcml2
ZXJzL2NoYXIvYWdwL2FncC5oDQpAQCAtMTc2LDcgKzE3Niw3IEBAIHN0cnVj
dCBhZ3BfYnJpZGdlX2RhdGEgew0KICNkZWZpbmUgSTgzMF9HTUNIX01FTV9N
QVNLCQkweDENCiAjZGVmaW5lIEk4MzBfR01DSF9NRU1fNjRNCQkweDENCiAj
ZGVmaW5lIEk4MzBfR01DSF9NRU1fMTI4TQkJMA0KLSNkZWZpbmUgSTgzMF9H
TUNIX0dNU19NQVNLCQkweEYwDQorI2RlZmluZSBJODMwX0dNQ0hfR01TX01B
U0sJCTB4NzANCiAjZGVmaW5lIEk4MzBfR01DSF9HTVNfRElTQUJMRUQJCTB4
MDANCiAjZGVmaW5lIEk4MzBfR01DSF9HTVNfTE9DQUwJCTB4MTANCiAjZGVm
aW5lIEk4MzBfR01DSF9HTVNfU1RPTEVOXzUxMgkweDIwDQpAQCAtMTkwLDYg
KzE5MCw3IEBAIHN0cnVjdCBhZ3BfYnJpZGdlX2RhdGEgew0KICNkZWZpbmUg
SU5URUxfSTgzMF9FUlJTVFMJMHg5Mg0KIA0KIC8qIEludGVsIDg1NUdNLzg1
MkdNIHJlZ2lzdGVycyAqLw0KKyNkZWZpbmUgSTg1NV9HTUNIX0dNU19NQVNL
CQkweEYwDQogI2RlZmluZSBJODU1X0dNQ0hfR01TX1NUT0xFTl8wTQkJMHgw
DQogI2RlZmluZSBJODU1X0dNQ0hfR01TX1NUT0xFTl8xTQkJKDB4MSA8PCA0
KQ0KICNkZWZpbmUgSTg1NV9HTUNIX0dNU19TVE9MRU5fNE0JCSgweDIgPDwg
NCkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvYWdwL2ludGVsLWFncC5j
IGIvZHJpdmVycy9jaGFyL2FncC9pbnRlbC1hZ3AuYw0KaW5kZXggMmM5Y2Ey
Yy4uYzE1ZjVkMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY2hhci9hZ3AvaW50
ZWwtYWdwLmMNCisrKyBiL2RyaXZlcnMvY2hhci9hZ3AvaW50ZWwtYWdwLmMN
CkBAIC01MDYsNyArNTA2LDcgQEAgc3RhdGljIHZvaWQgaW50ZWxfaTgzMF9p
bml0X2d0dF9lbnRyaWVzKHZvaWQpDQogCQkJYnJlYWs7DQogCQl9DQogCX0g
ZWxzZSB7DQotCQlzd2l0Y2ggKGdtY2hfY3RybCAmIEk4MzBfR01DSF9HTVNf
TUFTSykgew0KKwkJc3dpdGNoIChnbWNoX2N0cmwgJiBJODU1X0dNQ0hfR01T
X01BU0spIHsNCiAJCWNhc2UgSTg1NV9HTUNIX0dNU19TVE9MRU5fMU06DQog
CQkJZ3R0X2VudHJpZXMgPSBNQigxKSAtIEtCKHNpemUpOw0KIAkJCWJyZWFr
Ow0KLS0gDQoxLjUuMi41DQoNCg==

--29444707-775962402-1189606135=:12658--
