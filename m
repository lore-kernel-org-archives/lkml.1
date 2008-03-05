Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYCETIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYCETIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYCETH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:07:58 -0500
Received: from web26212.mail.ukl.yahoo.com ([217.12.10.208]:24504 "HELO
	web26212.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751355AbYCETH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:07:57 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 14:07:56 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=NO/DRza6MH6WJ0Cd3tpLencVLKiSHHxXsa6J3IAq8YIR8E7xyptxSylyNpxbNk1LRtgKiYpncQkvQ/MR2A8PQsTmp8A38EDLSbF5gLkh/KuXOkF8VRG/H9TPlmMk8ASjhniKEHRLz89RjhP9eT0exx2zTIpTZjL6lXtytCNwRCk=;
X-YMail-OSG: CjYi0DoVM1nUlsd0_cm.agzTYXDqapkbKSGBAjOBfMUFjFKdFGdlUKc0PFCwCBMQUCgUvEeP.vS4Wm5FL0RvhTLLNSV8S.LTNXain0xjfsd9.ddhiau2G08-
X-Mailer: YahooMailRC/902.35 YahooMailWebService/0.7.162
Date: Wed, 5 Mar 2008 19:01:14 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH]  atmel_serial
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1245108951-1204743674=:61467"
Message-ID: <457098.61467.qm@web26212.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1245108951-1204743674=:61467
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,=0AI find a problem related to loosing data during pdc trasmission in th=
e atmel_serial. For now this patch seems to work for me, =0Abut I think tha=
t is not the better solution. I do this test:=0A=0A- connect ttyS1 with tty=
S2 using a loopback cable, send 30 byte of packet from one to the other and=
 waiting for 30 byte. On=0Athe other side just read and echo the data recei=
ved.=0A=0ARegards Michael=0A=0A=0A=0A=0A=0A      __________________________=
_________ =0AL'email della prossima generazione? Puoi averla con la nuova Y=
ahoo! Mail: http://it.docs.yahoo.com/nowyoucan.html
--0-1245108951-1204743674=:61467
Content-Type: text/x-patch; name="0001-Don-t-disable-pdc-during-trasmission.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="0001-Don-t-disable-pdc-during-trasmission.patch"

QXZvaWQgc3RvcHBpbmcgcGRjIGR1cmluZyB0cmFzbWlzc2lvbi4KClNpZ25l
ZC1vZmYtYnk6IG1pY2hhZWwgPHRyaW1hcmNoaUBnYW5kYWxmLnNzc3VwLml0
PgotLS0KIGRyaXZlcnMvc2VyaWFsL2F0bWVsX3NlcmlhbC5jIHwgICAxOCAr
KysrKysrKystLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRp
b25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2VyaWFsL2F0bWVsX3NlcmlhbC5jIGIvZHJpdmVycy9zZXJpYWwvYXRtZWxf
c2VyaWFsLmMKaW5kZXggZDU3YmYzZS4uNzEwNzE1OCAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zZXJpYWwvYXRtZWxfc2VyaWFsLmMKKysrIGIvZHJpdmVycy9z
ZXJpYWwvYXRtZWxfc2VyaWFsLmMKQEAgLTU2OCwxMSArNTY4LDE2IEBAIHN0
YXRpYyB2b2lkIGF0bWVsX3R4X2RtYShzdHJ1Y3QgdWFydF9wb3J0ICpwb3J0
KQogCXBvcnQtPmljb3VudC50eCArPSBwZGMtPm9mczsKIAlwZGMtPm9mcyA9
IDA7CiAKLQlpZiAoIXVhcnRfY2lyY19lbXB0eSh4bWl0KSkgewotCQkvKiBt
b3JlIHRvIHRyYW5zbWl0IC0gc2V0dXAgbmV4dCB0cmFuc2ZlciAqLworCS8q
IG1vcmUgdG8gdHJhbnNtaXQgLSBzZXR1cCBuZXh0IHRyYW5zZmVyICovCiAK
LQkJLyogZGlzYWJsZSBQREMgdHJhbnNtaXQgKi8KLQkJVUFSVF9QVVRfUFRD
Uihwb3J0LCBBVE1FTF9QRENfVFhURElTKTsKKwkvKiBub3RoaW5nIGxlZnQg
dG8gdHJhbnNtaXQ/ICovCisJd2hpbGUgKFVBUlRfR0VUX1RDUihwb3J0KSkK
KwkJY3B1X3JlbGF4KCk7CisKKwkvKiBkaXNhYmxlIFBEQyB0cmFuc21pdCAq
LworCVVBUlRfUFVUX1BUQ1IocG9ydCwgQVRNRUxfUERDX1RYVERJUyk7CisK
KwlpZiAoIXVhcnRfY2lyY19lbXB0eSh4bWl0KSkgewogCQlkbWFfc3luY19z
aW5nbGVfZm9yX2RldmljZShwb3J0LT5kZXYsCiAJCQkJCSAgIHBkYy0+ZG1h
X2FkZHIsCiAJCQkJCSAgIHBkYy0+ZG1hX3NpemUsCkBAIC01ODYsMTEgKzU5
MSw2IEBAIHN0YXRpYyB2b2lkIGF0bWVsX3R4X2RtYShzdHJ1Y3QgdWFydF9w
b3J0ICpwb3J0KQogCQkvKiByZS1lbmFibGUgUERDIHRyYW5zbWl0IGFuZCBp
bnRlcnJ1cHRzICovCiAJCVVBUlRfUFVUX1BUQ1IocG9ydCwgQVRNRUxfUERD
X1RYVEVOKTsKIAkJVUFSVF9QVVRfSUVSKHBvcnQsIEFUTUVMX1VTX0VORFRY
IHwgQVRNRUxfVVNfVFhCVUZFKTsKLQl9IGVsc2UgewotCQkvKiBub3RoaW5n
IGxlZnQgdG8gdHJhbnNtaXQgLSBkaXNhYmxlIHRoZSB0cmFuc21pdHRlciAq
LwotCi0JCS8qIGRpc2FibGUgUERDIHRyYW5zbWl0ICovCi0JCVVBUlRfUFVU
X1BUQ1IocG9ydCwgQVRNRUxfUERDX1RYVERJUyk7CiAJfQogCiAJaWYgKHVh
cnRfY2lyY19jaGFyc19wZW5kaW5nKHhtaXQpIDwgV0FLRVVQX0NIQVJTKQot
LSAKMS41LjIuMS4xNzQuZ2NkMDMtZGlydHkKCg==

--0-1245108951-1204743674=:61467--
