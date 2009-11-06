Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZKFNta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZKFNta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbZKFNt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:49:29 -0500
Received: from sedf.de ([212.83.34.151]:58000 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbZKFNt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:49:29 -0500
Date: Fri, 6 Nov 2009 14:49:28 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 2/3 v2] staging: rt2860: remove superfluous newlines
Message-ID: <20091106134928.GC27210@sedf.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>

This patch is based on next-20091106.
This tiny patch removes a few quite unnecessary extra newlines from
DBGPRINT() and printk() strings.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt28=
60/common/rtmp_init.c
--- a/drivers/staging/rt2860/common/rtmp_init.c	2009-11-06 08:03:10.0000000=
00 +0100
+++ b/drivers/staging/rt2860/common/rtmp_init.c	2009-11-06 11:38:21.4727060=
92 +0100
@@ -181,7 +181,7 @@
 		}
 		pAd->BeaconBuf =3D pBeaconBuf;
 		DBGPRINT(RT_DEBUG_OFF,
-			 ("\n\n=3D=3D=3D pAd =3D %p, size =3D %d =3D=3D=3D\n\n", pAd,
+			 ("=3D=3D=3D pAd =3D %p, size =3D %d =3D=3D=3D\n", pAd,
 			  (u32)sizeof(struct rt_rtmp_adapter)));
=20
 		/* Init spin locks */
diff -ru a/drivers/staging/rt2860/common/rtmp_mcu.c b/drivers/staging/rt286=
0/common/rtmp_mcu.c
--- a/drivers/staging/rt2860/common/rtmp_mcu.c	2009-11-06 08:03:10.00000000=
0 +0100
+++ b/drivers/staging/rt2860/common/rtmp_mcu.c	2009-11-06 11:38:49.12182875=
4 +0100
@@ -163,7 +163,7 @@
=20
 	if (Index > 1000) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("NICLoadFirmware: MCU is not ready\n\n\n"));
+			 ("NICLoadFirmware: MCU is not ready\n"));
 		Status =3D NDIS_STATUS_FAILURE;
 	}
=20
diff -ru a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_li=
nux.c
--- a/drivers/staging/rt2860/rt_linux.c	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/rt_linux.c	2009-11-06 11:39:31.972697405 +0100
@@ -340,7 +340,7 @@
 	if (pPacket =3D=3D NULL) {
 		*ppPacket =3D NULL;
 #ifdef DEBUG
-		printk("RTMPAllocateNdisPacket Fail\n\n");
+		printk("RTMPAllocateNdisPacket Fail\n");
 #endif
 		return NDIS_STATUS_FAILURE;
 	}


--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr0KWgACgkQQfdJUNXnsjq86QCcCYezRrAMAo2S03LUb89L1VjE
ls0AnRnIY3Xycti+NXb6QAUOTS08vrV/
=TZ/O
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
