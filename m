Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZDYLsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZDYLsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 07:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZDYLsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 07:48:15 -0400
Received: from b186.blue.fastwebserver.de ([62.141.42.186]:53991 "EHLO
	mail.gw90.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZDYLsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 07:48:12 -0400
X-Greylist: delayed 9562 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Apr 2009 07:48:12 EDT
Subject: [PATCH] Add video modes for resolutions and timings of PAL RGB.
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Hilber <sparkie@lowbyte.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qwQDfBj1zwCeMAdIbEY2"
Date: Sat, 25 Apr 2009 11:08:31 +0200
Message-Id: <1240650511.6916.19.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qwQDfBj1zwCeMAdIbEY2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch was taken from vga-sync-field version 0.0.3 [1][2].

[1] http://lowbyte.de/vga-sync-fields/vga-sync-fields-0.0.3.tgz
[2] http://git.hellersdorfer-jugendchor.de/?p=3Dvga2scart.git;a=3Dcommit;h=
=3Dc5c8ed6c51fc9879dbf38d8b91d5db6f4300ea03

Signed-off-by: Thomas Hilber <sparkie@lowbyte.de>
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
 drivers/video/modedb.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 1618624..6175882 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -264,6 +264,14 @@ static const struct fb_videomode modedb[] =3D {
 	/* 1280x800, 60 Hz, 47.403 kHz hsync, WXGA 16:10 aspect ratio */
 	NULL, 60, 1280, 800, 12048, 200, 64, 24, 1, 136, 3,
 	0, FB_VMODE_NONINTERLACED
+    }, {
+       /* 720x576i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
+       NULL, 50, 720, 576, 74074, 64, 16, 39, 5, 64, 5,=20
+       0, FB_VMODE_INTERLACED
+    }, {
+       /* 800x520i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
+       NULL, 50, 800, 520, 58823, 144, 64, 72, 28, 80, 5,=20
+       0, FB_VMODE_INTERLACED
     },
 };
=20
--=20
1.6.2.4

--=-qwQDfBj1zwCeMAdIbEY2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkny0w8ACgkQPX1aK2wOHVgaFgCdGm5pXwntnBK4Q/jI9KoVckCG
iXAAn1UV2v3apy0mcosekRWBspzud2+3
=JHit
-----END PGP SIGNATURE-----

--=-qwQDfBj1zwCeMAdIbEY2--

