Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbYDUQ10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbYDUQ10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762053AbYDUQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:27:11 -0400
Received: from web26207.mail.ukl.yahoo.com ([217.12.10.244]:47772 "HELO
	web26207.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762034AbYDUQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:27:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=sIffjXRcqiYWChDCbQ1lnxJDybd0tbtaSREvLH7RCM7ojjPDJZIrSXPQS/N6uEAj2AGtk1XXNzgDOWMISw2+LELuUPYbDMgv+i13bEIfVgDQ6TyubHDxx+Eo4wPoEJ5nG10A7cdwsp6hkpUviOZauFkU+p0xP54RQQpvzlJyKvQ=;
X-YMail-OSG: GCzSBZgVM1lfHea5od0fF6n5D4bvkCj0GnxrHqTzy9ZT3FNTaNFQmQUmzkDqhrK7CZc4vUV0xWUmNcFcyBvKz6v80js-
X-Mailer: YahooMailWebService/0.7.185
Date: Mon, 21 Apr 2008 16:27:05 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH] Check the mtd device in do_emergency_remount()
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Trimarchi <michael@evidence.eu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-106454265-1208795225=:43514"
Message-ID: <561772.43514.qm@web26207.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-106454265-1208795225=:43514
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Allow superblocks managed by the mtd layer to be remounted.

=0A=0A=0A      Inviato da Yahoo! Mail. =0ALa casella di posta intelligente.=
=0Ahttp://it.docs.yahoo.com/mail/overview/index.html
--0-106454265-1208795225=:43514
Content-Type: text/x-patch; name="check-mtd-device-emergency-remount.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="check-mtd-device-emergency-remount.patch"

W1BBVENIXSBDaGVjayB0aGUgbXRkIGRldmljZSBpbiBkb19lbWVyZ2VuY3lf
cmVtb3VudCgpLgoKQWxsb3cgc3VwZXJibG9ja3MgbWFuYWdlZCBieSB0aGUg
bXRkIGxheWVyIHRvIGJlIHJlbW91bnRlZC4KClNpZ25lZC1vZmYtYnk6IE1p
Y2hhZWwgVHJpbWFyY2hpIDxtaWNoYWVsQGV2aWRlbmNlLmV1LmNvbT4KCi0t
LQogZnMvc3VwZXIuYyB8ICAgIDMgKystCiAxIGZpbGVzIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9zdXBlci5jIGIvZnMvc3VwZXIuYwppbmRleCAwOTAwOGRiLi4yZjhmOTI0
IDEwMDY0NAotLS0gYS9mcy9zdXBlci5jCisrKyBiL2ZzL3N1cGVyLmMKQEAg
LTYyNyw3ICs2MjcsOCBAQCBzdGF0aWMgdm9pZCBkb19lbWVyZ2VuY3lfcmVt
b3VudCh1bnNpZ25lZCBsb25nIGZvbykKIAkJc2ItPnNfY291bnQrKzsKIAkJ
c3Bpbl91bmxvY2soJnNiX2xvY2spOwogCQlkb3duX3JlYWQoJnNiLT5zX3Vt
b3VudCk7Ci0JCWlmIChzYi0+c19yb290ICYmIHNiLT5zX2JkZXYgJiYgIShz
Yi0+c19mbGFncyAmIE1TX1JET05MWSkpIHsKKwkJaWYgKHNiLT5zX3Jvb3Qg
JiYgKHNiLT5zX2JkZXYgfHwgc2ItPnNfbXRkKQorCQkgICAmJiAhKHNiLT5z
X2ZsYWdzICYgTVNfUkRPTkxZKSkgewogCQkJLyoKIAkJCSAqIC0+cmVtb3Vu
dF9mcyBuZWVkcyBsb2NrX2tlcm5lbCgpLgogCQkJICoKLS0gCjEuNS4zLjYK
Cg==

--0-106454265-1208795225=:43514--
