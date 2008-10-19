Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbYJSSRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbYJSSRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 14:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYJSSRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 14:17:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55792 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJSSRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 14:17:32 -0400
X-Sasl-enc: mofASdpmycyvWJtBBoqrt97hk04CfV3PeiynU/BtPIN2 1224440251
Message-ID: <48FB79AE.3060006@imap.cc>
Date: Sun, 19 Oct 2008 20:17:18 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.27-git8 compile error in drivers/mfd/wm8350-core.c
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6E2ECDDA1307E549ECF53627"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E2ECDDA1307E549ECF53627
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

When trying to build 2.6.27-git8 on x86 with CONFIG_MFD_WM8350_I2C=3Dm,
make aborts with:

  CHECK   drivers/mfd/wm8350-core.c
drivers/mfd/wm8350-core.c:1220:13: error: undefined identifier 'NO_IRQ'
  CC [M]  drivers/mfd/wm8350-core.o
drivers/mfd/wm8350-core.c: In function 'wm8350_device_init':
drivers/mfd/wm8350-core.c:1220: error: 'NO_IRQ' undeclared (first use in =
this function)
drivers/mfd/wm8350-core.c:1220: error: (Each undeclared identifier is rep=
orted only once
drivers/mfd/wm8350-core.c:1220: error: for each function it appears in.)
make[2]: *** [drivers/mfd/wm8350-core.o] Error 1

After deselecting CONFIG_MFD_WM8350_I2C, make completes fine.

HTH
T.


--------------enig6E2ECDDA1307E549ECF53627
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFI+3m4Q3+did9BuFsRAoRVAJ9cnnQgsjsB36FdSCOOz02Bzry6jQCgkhY/
Ud0Xtmdwt0OlrWC5m0VuVZM=
=HfID
-----END PGP SIGNATURE-----

--------------enig6E2ECDDA1307E549ECF53627--
