Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbXF2D2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbXF2D2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765329AbXF2D2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:28:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60117 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765167AbXF2D2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:28:13 -0400
Message-ID: <46847C38.7000104@soft.fujitsu.com>
Date: Fri, 29 Jun 2007 12:27:52 +0900
From: izumi <izumi2005@soft.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BUG] Fix the graphic corruption issue on IA64 machines
References: <4670A759.7090206@soft.fujitsu.com>
In-Reply-To: <4670A759.7090206@soft.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------050003020800060803070806"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050003020800060803070806
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

HI,

As a result of the discussion with Pete Zaitcev(zaitcev@redhat.com),
I re-create a patch. This attached patch is revised version.

He pointed out that the former patch may violate the assumptions and
was not safe. Concretely speaking, he concerned that an unexpected
problem may arise somewhere if "blank_state", which is intended to
reflect the state of timer, was shuffled arround.

This revised patch reflects his pointed out. I confirmed this also fixed
the problem.

Regards,
Taku Izumi <izumi.taku@jp.fujitsu.com>

--------------050003020800060803070806
Content-Type: text/plain;
 name="vt-blank-rev2.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="vt-blank-rev2.patch"

Rml4IHRoZSBncmFwaGljIGNvcnJ1cHRpb24gaXNzdWUgb24gSUE2NCBtYWNoaW5lcy4NClZH
QSBjb25zb2xlIGRyaXZlciBjYW4gbWlzdW5kZXJzdGFuZCB0aGUgY3VycmVudCBtb2RlKFRl
eHQvR3JhcGhpYykgdW5kZXIgDQoiZGlzYWJsZSBjb25zb2xlIGJsYW5raW5nIiBzZXR0aW5n
LiBXaGVuICJkaXNhYmxlIGNvbnNvbGUgYmxhbmsiIGlzIHNldCAoYmxhbmtpbnRlcnZhbD0w
KSwgDQoiZG9fdW5ibGFua19zY3JlZW4oKSIgZnVuY3Rpb24gcmV0dXJucyB3aXRob3V0IGNo
YW5naW5nICJibGFua19zdGF0ZSIsIGFuZCB3aGVuIA0KImJsYW5rX3N0YXRlIiBpcyAiYmxh
bmtfb2ZmIiwgImRvX2JsYW5rX3NjcmVlbigpIGZ1bmN0aW9uIHJldHVybnMgd2l0aG91dCAN
Cmludm9raW5nIHN3LT5jb25fYmxhbmsoKSBmdW5jdGlvbi4gVGhhdCdzIHdoeSBWR0EgY29u
c29sZSBkcml2ZXIgY2FuIG1pc3VuZGVyc3RhbmQgDQp0aGUgY3VycmVudCBtb2RlLg0KDQpT
aWduZWQtb2ZmLWJ5OiBOb2J1aGlybyBUYWNoaW5vIDx0YWNoaW5vQGpwLmZ1aml0c3UuY29t
Pg0KU2lnbmVkLW9mZi1ieTogUGV0ZSBaYWl0Y2V2IDx6YWl0Y2V2QHJlZGhhdC5jb20+DQpT
aWduZWQtb2ZmLWJ5OiBUYWt1IEl6dW1pIDxpenVtaS50YWt1QGpwLmZ1aml0c3UuY29tPg0K
LS0tDQogZHJpdmVycy9jaGFyL3Z0LmMgfCAgICA4ICsrKysrLS0tDQogMSBmaWxlcyBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCg0KSW5kZXg6IGxpbnV4
LTIuNi4yMi9kcml2ZXJzL2NoYXIvdnQuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0t
LSBsaW51eC0yLjYuMjIub3JnL2RyaXZlcnMvY2hhci92dC5jCTIwMDctMDYtMjcgMTE6NDA6
MDMuMDAwMDAwMDAwIC0wNDAwDQorKysgbGludXgtMi42LjIyL2RyaXZlcnMvY2hhci92dC5j
CTIwMDctMDYtMjcgMTE6MjQ6MzIuMDAwMDAwMDAwIC0wNDAwDQpAQCAtMzQ5MSw5ICszNDkx
LDYgQEAgdm9pZCBkb19ibGFua19zY3JlZW4oaW50IGVudGVyaW5nX2dmeCkNCiAJCX0NCiAJ
CXJldHVybjsNCiAJfQ0KLQlpZiAoYmxhbmtfc3RhdGUgIT0gYmxhbmtfbm9ybWFsX3dhaXQp
DQotCQlyZXR1cm47DQotCWJsYW5rX3N0YXRlID0gYmxhbmtfb2ZmOw0KIA0KIAkvKiBlbnRl
cmluZyBncmFwaGljcyBtb2RlPyAqLw0KIAlpZiAoZW50ZXJpbmdfZ2Z4KSB7DQpAQCAtMzUw
MSwxMCArMzQ5OCwxNSBAQCB2b2lkIGRvX2JsYW5rX3NjcmVlbihpbnQgZW50ZXJpbmdfZ2Z4
KQ0KIAkJc2F2ZV9zY3JlZW4odmMpOw0KIAkJdmMtPnZjX3N3LT5jb25fYmxhbmsodmMsIC0x
LCAxKTsNCiAJCWNvbnNvbGVfYmxhbmtlZCA9IGZnX2NvbnNvbGUgKyAxOw0KKwkJYmxhbmtf
c3RhdGUgPSBibGFua19vZmY7DQogCQlzZXRfb3JpZ2luKHZjKTsNCiAJCXJldHVybjsNCiAJ
fQ0KIA0KKwlpZiAoYmxhbmtfc3RhdGUgIT0gYmxhbmtfbm9ybWFsX3dhaXQpDQorCQlyZXR1
cm47DQorCWJsYW5rX3N0YXRlID0gYmxhbmtfb2ZmOw0KKw0KIAkvKiBkb24ndCBibGFuayBn
cmFwaGljcyAqLw0KIAlpZiAodmMtPnZjX21vZGUgIT0gS0RfVEVYVCkgew0KIAkJY29uc29s
ZV9ibGFua2VkID0gZmdfY29uc29sZSArIDE7DQo=
--------------050003020800060803070806--

