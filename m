Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYIQJnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYIQJnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYIQJnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:43:01 -0400
Received: from web26203.mail.ukl.yahoo.com ([217.12.10.240]:28928 "HELO
	web26203.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751432AbYIQJnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:43:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=rc677wFxujzqrPLoE0HeGIzwzuywSyCavs81RD3aaJC4gBI6V/rET0zV+/q3ZaR7h8SjvqkPtMTGmMs+4HHRf5K46RX5SYICwCEV1M8M9+bZj4ZtFLqE0OnkqE64epSwpezRtL6HSpJ7xUU4Wmdq1BqryPrtefHSvHyYBayR4JY=;
X-YMail-OSG: ZLI_EOkVM1mP7yrgporWGksbogxtjBF0TVqvXhIxbsNbdda577QekHPS4S0R_c1s3Q--
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Wed, 17 Sep 2008 09:42:58 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH] Hangcheck-timer TSC source is stable?
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-78978892-1221644578=:81345"
Message-ID: <157995.81345.qm@web26203.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-78978892-1221644578=:81345
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,=0A=0AThis patch checks the TSC source before initialization.=0A=0ARegar=
ds Michael=0A=0A__________________________________________________=0ADo You=
 Yahoo!?=0APoco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e t=
i da tanto spazio gratuito per i tuoi file e i messaggi =0Ahttp://mail.yaho=
o.it 
--0-78978892-1221644578=:81345
Content-Type: application/octet-stream; name="hangcheck-timer-tsc-unstable.pach"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="hangcheck-timer-tsc-unstable.pach"

Q2hlY2sgaWYgdGhlIFRTQyBzb3VyY2UgaXMgc3RhYmxlIG90aGVyd2lzZSBm
YWlsIHJlZ2lzdHJhdGlvbi4KClNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgVHJp
bWFyY2hpIDx0cmltYXJjaGltaWNoYWVsQHlhaG9vLml0PgoKLS0tCiBkcml2
ZXJzL2NoYXIvaGFuZ2NoZWNrLXRpbWVyLmMgfCAgIDE1ICsrKysrKysrKysr
LS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCA0IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9oYW5nY2hl
Y2stdGltZXIuYyBiL2RyaXZlcnMvY2hhci9oYW5nY2hlY2stdGltZXIuYwpp
bmRleCA3MTJkOWYyLi42YjYxMzg5IDEwMDY0NAotLS0gYS9kcml2ZXJzL2No
YXIvaGFuZ2NoZWNrLXRpbWVyLmMKKysrIGIvZHJpdmVycy9jaGFyL2hhbmdj
aGVjay10aW1lci5jCkBAIC0xNzUsMTIgKzE3NSwxOSBAQCBzdGF0aWMgdm9p
ZCBoYW5nY2hlY2tfZmlyZSh1bnNpZ25lZCBsb25nIGRhdGEpCiAKIHN0YXRp
YyBpbnQgX19pbml0IGhhbmdjaGVja19pbml0KHZvaWQpCiB7Ci0JcHJpbnRr
KCJIYW5nY2hlY2s6IHN0YXJ0aW5nIGhhbmdjaGVjayB0aW1lciAlcyAodGlj
ayBpcyAlZCBzZWNvbmRzLCBtYXJnaW4gaXMgJWQgc2Vjb25kcykuXG4iLAor
CXByaW50ayhLRVJOX0lORk8gIkhhbmdjaGVjazogc3RhcnRpbmcgaGFuZ2No
ZWNrIHRpbWVyICVzIgorCQkJICIgKHRpY2sgaXMgJWQgc2Vjb25kcywgbWFy
Z2luIGlzICVkIHNlY29uZHMpLlxuIiwKIAkgICAgICAgVkVSU0lPTl9TVFIs
IGhhbmdjaGVja190aWNrLCBoYW5nY2hlY2tfbWFyZ2luKTsKICNpZiBkZWZp
bmVkIChIQVZFX01PTk9UT05JQykKLQlwcmludGsoIkhhbmdjaGVjazogVXNp
bmcgbW9ub3RvbmljX2Nsb2NrKCkuXG4iKTsKKwlwcmludGsoS0VSTl9JTkZP
ICJIYW5nY2hlY2s6IFVzaW5nIG1vbm90b25pY19jbG9jaygpLlxuIik7CiAj
ZWxzZQotCXByaW50aygiSGFuZ2NoZWNrOiBVc2luZyBnZXRfY3ljbGVzKCku
XG4iKTsKKwlpZiAoIWNoZWNrX3RzY191bnN0YWJsZSgpKQorCQlwcmludGso
S0VSTl9JTkZPICJIYW5nY2hlY2s6IFVzaW5nIGdldF9jeWNsZXMoKS5cbiIp
OworCWVsc2UgeworCQlwcmludGsoS0VSTl9FUlIgIkhhbmRjaGVjazogRmFp
bGVkIHRvIHJlZ2lzdGVyIgorCQkgICAgICAgIiAoVW5zdGFibGUgVFNDKS5c
biIpOworCQlyZXR1cm4gLUVOT0RFVjsKKwl9CiAjZW5kaWYgIC8qIEhBVkVf
TU9OT1RPTklDICovCiAJaGFuZ2NoZWNrX3RzY19tYXJnaW4gPQogCQkodW5z
aWduZWQgbG9uZyBsb25nKShoYW5nY2hlY2tfbWFyZ2luICsgaGFuZ2NoZWNr
X3RpY2spOwpAQCAtMTk2LDcgKzIwMyw3IEBAIHN0YXRpYyBpbnQgX19pbml0
IGhhbmdjaGVja19pbml0KHZvaWQpCiBzdGF0aWMgdm9pZCBfX2V4aXQgaGFu
Z2NoZWNrX2V4aXQodm9pZCkKIHsKIAlkZWxfdGltZXJfc3luYygmaGFuZ2No
ZWNrX3RpY2t0b2NrKTsKLSAgICAgICAgcHJpbnRrKCJIYW5nY2hlY2s6IFN0
b3BwZWQgaGFuZ2NoZWNrIHRpbWVyLlxuIik7CisJcHJpbnRrKEtFUk5fSU5G
TyAiSGFuZ2NoZWNrOiBTdG9wcGVkIGhhbmdjaGVjayB0aW1lci5cbiIpOwog
fQogCiBtb2R1bGVfaW5pdChoYW5nY2hlY2tfaW5pdCk7Ci0tIAoxLjUuNC4z
Cgo=

--0-78978892-1221644578=:81345--
