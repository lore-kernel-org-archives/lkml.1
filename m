Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbYDYOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbYDYOHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYDYOHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:07:45 -0400
Received: from tur.go2.pl ([193.17.41.50]:53684 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYDYOHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:07:44 -0400
Subject: =?UTF-8?Q?[PATCH]_mmc_fix_for_clock-off_PXA255/270?=
From: =?UTF-8?Q?rifx?= <rifx@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <33e8c656.65b829f0.4811e570.57193@o2.pl>
Date: Fri, 25 Apr 2008 16:06:40 +0200
X-Originator: 62.225.75.172
Content-Type: multipart/mixed;
	boundary="==o2.pl-WebMail-16355b64.35ad7227.571a3=="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--==o2.pl-WebMail-16355b64.35ad7227.571a3==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It=20solves=20the=20problems=20with=20clock-off=20in=20the=20PXA255/270=20=
MMC/SD=20hardware.
This=20solution=20was=20testes=20with=20our=20devices=20and=20works=20goo=
d.
Kernel=202.6.24.4=20(but=20should=20work=20with=20>=3D2.6.19).
--==o2.pl-WebMail-16355b64.35ad7227.571a3==
Content-Type: text/x-patch;
	name="=?UTF-8?Q?pxamci.c.diff?="
Content-Disposition: attachment;
	filename="=?UTF-8?Q?pxamci.c.diff?="
Content-Transfer-Encoding: base64

ZGlmZiAtTnVhckJiIC94L3dvcmsvbmF2aV9vcy9tbWMvaG9zdC9weGFtY2kuYyBtbWMvaG9z
dC9weGFtY2kuYwotLS0gL3gvd29yay9uYXZpX29zL21tYy9ob3N0L3B4YW1jaS5jCTIwMDgt
MDMtMjQgMTk6NDk6MTguMDAwMDAwMDAwICswMTAwCisrKyBtbWMvaG9zdC9weGFtY2kuYwky
MDA4LTA0LTI1IDEyOjE0OjAwLjAwMDAwMDAwMCArMDIwMApAQCAtMjYsNiArMjYsNyBAQAog
I2luY2x1ZGUgPGxpbnV4L2Nsay5oPgogI2luY2x1ZGUgPGxpbnV4L2Vyci5oPgogI2luY2x1
ZGUgPGxpbnV4L21tYy9ob3N0Lmg+CisjaW5jbHVkZSA8bGludXgvbW1jL21tYy5oPgogCiAj
aW5jbHVkZSA8YXNtL2RtYS5oPgogI2luY2x1ZGUgPGFzbS9pby5oPgpAQCAtNjcsNiArNjgs
OCBAQAogCXVuc2lnbmVkIGludAkJZG1hX2RpcjsKIH07CiAKK3N0YXRpYyBpbnQgbG9jYWxf
Y21kID0gLTE7CisKIHN0YXRpYyB2b2lkIHB4YW1jaV9zdG9wX2Nsb2NrKHN0cnVjdCBweGFt
Y2lfaG9zdCAqaG9zdCkKIHsKIAlpZiAocmVhZGwoaG9zdC0+YmFzZSArIE1NQ19TVEFUKSAm
IFNUQVRfQ0xLX0VOKSB7CkBAIC04NCw2ICs4Nyw3IEBACiAKIAkJaWYgKHYgJiBTVEFUX0NM
S19FTikKIAkJCWRldl9lcnIobW1jX2Rldihob3N0LT5tbWMpLCAidW5hYmxlIHRvIHN0b3Ag
Y2xvY2tcbiIpOworCQlsb2NhbF9jbWQgPSAtMTsKIAl9CiB9CiAKQEAgLTIzMiw2ICsyMzUs
MTQgQEAKIAkJdiA9IHcyOwogCX0KIAorCWxvY2FsX2NtZCA9IGNtZC0+b3Bjb2RlOworCWlm
ICgobG9jYWxfY21kID09IE1NQ19HT19JRExFX1NUQVRFKSB8fAorCSAgICAobG9jYWxfY21k
ID09IE1NQ19HT19JTkFDVElWRV9TVEFURSkgfHwKKwkgICAgKGxvY2FsX2NtZCA9PSBNTUNf
U0VORF9TVEFUVVMpIHx8CisJICAgIChsb2NhbF9jbWQgPT0gTU1DX1NUT1BfVFJBTlNNSVNT
SU9OKSB8fAorCSAgICAobG9jYWxfY21kID09IE1NQ19TRVRfQkxPQ0tMRU4pCisJICAgICkg
cHhhbWNpX3N0b3BfY2xvY2soaG9zdCk7CisKIAlpZiAoc3RhdCAmIFNUQVRfVElNRV9PVVRf
UkVTUE9OU0UpIHsKIAkJY21kLT5lcnJvciA9IC1FVElNRURPVVQ7CiAJfSBlbHNlIGlmIChz
dGF0ICYgU1RBVF9SRVNfQ1JDX0VSUiAmJiBjbWQtPmZsYWdzICYgTU1DX1JTUF9DUkMpIHsK
QEAgLTI5MCw3ICszMDEsNyBAQAogCiAJaG9zdC0+ZGF0YSA9IE5VTEw7CiAJaWYgKGhvc3Qt
Pm1ycS0+c3RvcCkgewotCQlweGFtY2lfc3RvcF9jbG9jayhob3N0KTsKKwkJLy9weGFtY2lf
c3RvcF9jbG9jayhob3N0KTsKIAkJcHhhbWNpX3N0YXJ0X2NtZChob3N0LCBob3N0LT5tcnEt
PnN0b3AsIGhvc3QtPmNtZGF0KTsKIAl9IGVsc2UgewogCQlweGFtY2lfZmluaXNoX3JlcXVl
c3QoaG9zdCwgaG9zdC0+bXJxKTsK

--==o2.pl-WebMail-16355b64.35ad7227.571a3==--

