Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXDUVzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXDUVzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDUVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:55:23 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:50728 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753256AbXDUVzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:55:21 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: dsd@gentoo.org
Subject: [PATCH] Add missing  USRobotics Wireless Adapter (Model 5423) id  into zd1211rw
User-Agent: KMail/1.9.6
Cc: kune@deine-taler.d, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Date: Sun, 22 Apr 2007 00:52:48 +0300
Content-Type: multipart/signed;
  boundary="nextPart3109827.kkhZ4Yo26z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704220052.48637.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3109827.kkhZ4Yo26z
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[Forgot to CC LKML, Sorry!]

Hi;

USRobotics Wireless Adapter (Model 5423) works well with current zd1211rw=20
driver also (i have tested 2.6.18, 2.6.20 and 2.6.21-rc7). I know -mm/and=20
Daniel's tree has new version (i think with more features like rate estimat=
or=20
etc.) of this driver but maybe you should consider that one as a .21 materi=
al=20
instead of waiting full wireless-dev merge?=20

I'm not sure "Signed-off-by" cause -mm one already has that id but in case =
of=20
need, here it is.

Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c=20
b/drivers/net/wireless/zd1211rw/zd_usb.c
index aac8a1c..edaaad2 100644
=2D-- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -62,6 +62,7 @@ static struct usb_device_id usb_ids[] =3D {
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info =3D DEVICE_ZD1211B },
 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info =3D DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340f), .driver_info =3D DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0baf, 0x0121), .driver_info =3D DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info =3D DEVICE_INSTALLER },
 	{}


Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3109827.kkhZ4Yo26z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGKoewy7E6i0LKo6YRAmOOAJ9ta+/Ez50QaH6Ya5KVg7kcNEwOaACfefdN
oQooC4QMKIoWOFYP2FOKKAg=
=1KW1
-----END PGP SIGNATURE-----

--nextPart3109827.kkhZ4Yo26z--
