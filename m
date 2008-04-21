Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbYDUQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbYDUQb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbYDUQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:31:39 -0400
Received: from web26206.mail.ukl.yahoo.com ([217.12.10.243]:27621 "HELO
	web26206.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761748AbYDUQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:31:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=sXDUNaUmSIjURz753TWKJkc5FHKs3Bd2Ma4FE9THQmAq+NIhAR937EbzxDU87rF97XfPw27A1h8FWFSwmKofGJNOAXgBKw1mzlLbI6HeaHDMX+7Yz8L1fV9bxr0CUtcZ8IIPri4et4sDYKyyPRZDhXenojajUxP3jF3//9afze4=;
X-YMail-OSG: QeWhDNEVM1mh.4lMgmQNp0JLd5wwbkCW1YAliotZhbRptfBIeDqRNSg_UxUaDpnnrQX0jymjvBBGrBcUcJV9QkuHlKT.3TE-
X-Mailer: YahooMailWebService/0.7.185
Date: Mon, 21 Apr 2008 16:31:35 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH] Force remount read-only of jffs2 when the garbage collector dies
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1929020582-1208795495=:91220"
Message-ID: <831534.91220.qm@web26206.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1929020582-1208795495=:91220
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=0A=0A=0A      Inviato da Yahoo! Mail. =0ALa casella di posta intelligente.=
=0Ahttp://it.docs.yahoo.com/mail/overview/index.html
--0-1929020582-1208795495=:91220
Content-Type: text/x-patch; name="force-remount-readonly-jffs2.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="force-remount-readonly-jffs2.patch"

W1BBVENIXSBGb3JjZSByZW1vdW50IHJlYWQtb25seSBvZiBqZmZzMiB3aGVu
IHRoZSBnYXJiYWdlIGNvbGxlY3RvciBkaWVzCgpTaWduZWQtb2ZmLWJ5OiBN
aWNoYWVsIFRyaW1hcmNoaSA8bWljaGFlbEBldmlkZW5jZS5ldS5jb20+Cgot
LS0KIGZzL2pmZnMyL2JhY2tncm91bmQuYyB8ICAgMjEgKysrKysrKysrKysr
KysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyks
IDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvamZmczIvYmFja2dy
b3VuZC5jIGIvZnMvamZmczIvYmFja2dyb3VuZC5jCmluZGV4IDhhZGViZDMu
LjY2OWIzNWUgMTAwNjQ0Ci0tLSBhL2ZzL2pmZnMyL2JhY2tncm91bmQuYwor
KysgYi9mcy9qZmZzMi9iYWNrZ3JvdW5kLmMKQEAgLTcwLDYgKzcwLDcgQEAg
dm9pZCBqZmZzMl9zdG9wX2dhcmJhZ2VfY29sbGVjdF90aHJlYWQoc3RydWN0
IGpmZnMyX3NiX2luZm8gKmMpCiBzdGF0aWMgaW50IGpmZnMyX2dhcmJhZ2Vf
Y29sbGVjdF90aHJlYWQodm9pZCAqX2MpCiB7CiAJc3RydWN0IGpmZnMyX3Ni
X2luZm8gKmMgPSBfYzsKKwlzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiOwogCiAJ
ZGFlbW9uaXplKCJqZmZzMl9nY2RfbXRkJWQiLCBjLT5tdGQtPmluZGV4KTsK
IAlhbGxvd19zaWduYWwoU0lHS0lMTCk7CkBAIC0xNDUsNSArMTQ2LDI1IEBA
IHN0YXRpYyBpbnQgamZmczJfZ2FyYmFnZV9jb2xsZWN0X3RocmVhZCh2b2lk
ICpfYykKIAlzcGluX2xvY2soJmMtPmVyYXNlX2NvbXBsZXRpb25fbG9jayk7
CiAJYy0+Z2NfdGFzayA9IE5VTEw7CiAJc3Bpbl91bmxvY2soJmMtPmVyYXNl
X2NvbXBsZXRpb25fbG9jayk7CisKKwlzYiA9IGMtPm9zX3ByaXY7CisJQlVH
X09OKHNiID09IE5VTEwpOworCisJLyogVGhlIGdhcmJhZ2UgY29sbGVjdCBp
cyBkaWVkLiBUcnkgdG8gcmVtb3VudCB0aGUgZnMKKwkgKiByZWFkLW9ubHkK
KwkgKi8KKwlkb3duX3JlYWQoJnNiLT5zX3Vtb3VudCk7CisJaWYgKHNiLT5z
X3Jvb3QgJiYgc2ItPnNfbXRkICYmICEoc2ItPnNfZmxhZ3MgJiBNU19SRE9O
TFkpKSB7CisJCS8qCisJCSAqIC0+cmVtb3VudF9mcyBuZWVkcyBsb2NrX2tl
cm5lbCgpLgorCQkgKgorCQkgKiBXaGF0IGxvY2sgcHJvdGVjdHMgc2ItPnNf
ZmxhZ3M/PworCQkgKi8KKwkJbG9ja19rZXJuZWwoKTsKKwkJZG9fcmVtb3Vu
dF9zYihzYiwgTVNfUkRPTkxZLCBOVUxMLCAxKTsKKwkJdW5sb2NrX2tlcm5l
bCgpOworCX0KKwlkcm9wX3N1cGVyKHNiKTsKKwogCWNvbXBsZXRlX2FuZF9l
eGl0KCZjLT5nY190aHJlYWRfZXhpdCwgMCk7CiB9Ci0tIAoxLjUuMy42Cgo=


--0-1929020582-1208795495=:91220--
