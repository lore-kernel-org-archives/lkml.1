Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDMWwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDMWwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYDMWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:51:55 -0400
Received: from web26213.mail.ukl.yahoo.com ([217.12.10.209]:41803 "HELO
	web26213.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752367AbYDMWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:51:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=0JVpn9VvCamAc01omKoU3YVBfKIlazcV2s2XyuUDAIPoPVimJq0vdbH3+S8x9J0jO6rjylVp1Jo02dWnC7bCArhiaaakhdjhESJSxWlNP6StUAWy2dyIZedZ1L2pMgGWJnEqxZ4/i9/9/+Vrb6oWORcWN6jcXQGz29Llk+FmfZI=;
X-YMail-OSG: 1XCQQ6UVM1ljhnKgPpxsPjl1qWFlvIeHI.dEBX9bCQwFtArDrAVhMtFib3QXYBm2YRz3AKFAA8nysCN57DN1gztxkYRmLGSYO_GftwGTLQ9LqoMrsLSqIgx7chk-
X-Mailer: YahooMailWebService/0.7.185
Date: Sun, 13 Apr 2008 22:51:53 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH] atmel_serial remove duplicated macro definition
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Marc Pignat <marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-383829064-1208127113=:4572"
Message-ID: <370563.4572.qm@web26213.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-383829064-1208127113=:4572
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

After commit 39d4c922b596633da86878b1a5cc881785b8e5fa (atmel_serial: fix
uart/console concurrent access) the UART_GET_TCR macro got redefined. This
patch removes the duplicated definition.

Michael
=0A=0A=0A      Inviato da Yahoo! Mail. =0ALa casella di posta intelligente.=
=0Ahttp://it.docs.yahoo.com/mail/overview/index.html
--0-383829064-1208127113=:4572
Content-Type: text/x-patch; name="atmel_serial-remove-duplicated-macro-definition.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="atmel_serial-remove-duplicated-macro-definition.patch"

QWZ0ZXIgY29tbWl0IDM5ZDRjOTIyYjU5NjYzM2RhODY4NzhiMWE1Y2M4ODE3
ODViOGU1ZmEgKGF0bWVsX3NlcmlhbDogZml4CnVhcnQvY29uc29sZSBjb25j
dXJyZW50IGFjY2VzcykgdGhlIFVBUlRfR0VUX1RDUiBtYWNybyBnb3QgcmVk
ZWZpbmVkLiBUaGlzCnBhdGNoIHJlbW92ZXMgdGhlIGR1cGxpY2F0ZWQgZGVm
aW5pdGlvbi4KClNpZ25lZC1vZmYtYnk6IG1pY2hhZWwgdHJpbWFyY2hpIDx0
cmltYXJjaGltaWNoYWVsQGV2aWRlbmNlLmV1LmNvbT4KLS0tCiBkcml2ZXJz
L3NlcmlhbC9hdG1lbF9zZXJpYWwuYyB8ICAgIDEgLQogMSBmaWxlcyBjaGFu
Z2VkLCAwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zZXJpYWwvYXRtZWxfc2VyaWFsLmMgYi9kcml2ZXJz
L3NlcmlhbC9hdG1lbF9zZXJpYWwuYwppbmRleCA0MzA5OTdlLi4zYTVmNDRj
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3NlcmlhbC9hdG1lbF9zZXJpYWwuYwor
KysgYi9kcml2ZXJzL3NlcmlhbC9hdG1lbF9zZXJpYWwuYwpAQCAtOTYsNyAr
OTYsNiBAQAogCiAgLyogUERDIHJlZ2lzdGVycyAqLwogI2RlZmluZSBVQVJU
X1BVVF9QVENSKHBvcnQsdikJX19yYXdfd3JpdGVsKHYsIChwb3J0KS0+bWVt
YmFzZSArIEFUTUVMX1BEQ19QVENSKQotI2RlZmluZSBVQVJUX0dFVF9UQ1Io
cG9ydCkgICAgICBfX3Jhd19yZWFkbCgocG9ydCktPm1lbWJhc2UgKyBBVE1F
TF9QRENfVENSKQogI2RlZmluZSBVQVJUX0dFVF9QVFNSKHBvcnQpCV9fcmF3
X3JlYWRsKChwb3J0KS0+bWVtYmFzZSArIEFUTUVMX1BEQ19QVFNSKQogCiAj
ZGVmaW5lIFVBUlRfUFVUX1JQUihwb3J0LHYpCV9fcmF3X3dyaXRlbCh2LCAo
cG9ydCktPm1lbWJhc2UgKyBBVE1FTF9QRENfUlBSKQotLSAKMS41LjMuMQoK


--0-383829064-1208127113=:4572--
