Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbZF1REj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbZF1REj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZF1RDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:03:21 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60067 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZF1RDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:03:19 -0400
Date: Sun, 28 Jun 2009 13:03:22 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Woody Suwalski <woodys@xandros.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] vt6656: replace call to info with printk call.
Message-ID: <20090628170322.GJ9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O0IT7rLmWuveAsNR"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O0IT7rLmWuveAsNR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Greg: This patch series does not differ from that which you already have.]

vt6656: replace call to info with printk call.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6656/main_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/mai=
n_usb.c
index 228b3ec..722b739 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -2392,7 +2392,7 @@ static struct usb_driver vntwusb_driver =3D {
=20
 static int __init vntwusb_init_module(void)
 {
-	info(DEVICE_FULL_DRV_NAM " " DEVICE_VERSION);
+    printk(KERN_NOTICE DEVICE_FULL_DRV_NAM " " DEVICE_VERSION);
     return usb_register(&vntwusb_driver);
 }
=20
--=20
1.5.6.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--O0IT7rLmWuveAsNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR6JaRO4fQQdv5AwRAkZiAJ9GYN6jlDIEsTV2PphAXo5MD/qEJgCg2S6h
kHwoslP2zgHZRq93nsLIMs8=
=cGxn
-----END PGP SIGNATURE-----

--O0IT7rLmWuveAsNR--
