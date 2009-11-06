Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZKFNtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZKFNtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZKFNtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:49:01 -0500
Received: from sedf.de ([212.83.34.151]:57970 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbZKFNtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:49:00 -0500
Date: Fri, 6 Nov 2009 14:49:00 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/3 v2] staging: rt2860: remove remainders of /etc reading
 stuff
Message-ID: <20091106134900.GB27210@sedf.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>

This patch is based on next-20091106.
The stuff that tries to read a file from /etc is already removed, so=20
this patch just removes the last remainders.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_li=
nux.h
--- a/drivers/staging/rt2860/rt_linux.h	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/rt_linux.h	2009-11-06 11:32:56.846053670 +0100
@@ -80,11 +80,9 @@
  *************************************************************************=
**********/
=20
 #ifdef RTMP_MAC_PCI
-#define STA_PROFILE_PATH			"/etc/Wireless/RT2860STA/RT2860STA.dat"
 #define STA_DRIVER_VERSION			"2.1.0.0"
 #endif /* RTMP_MAC_PCI // */
 #ifdef RTMP_MAC_USB
-#define STA_PROFILE_PATH			"/etc/Wireless/RT2870STA/RT2870STA.dat"
 #define STA_DRIVER_VERSION			"2.1.0.0"
 /* RT3070 version: 2.1.1.0 */
 #endif /* RTMP_MAC_USB // */
diff -ru a/drivers/staging/rt2860/TODO b/drivers/staging/rt2860/TODO
--- a/drivers/staging/rt2860/TODO	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/TODO	2009-11-06 11:33:10.181861732 +0100
@@ -9,7 +9,6 @@
 	- checkpatch.pl clean
 	- sparse clean
 	- port to in-kernel 80211 stack and common rt2x00 infrastructure
-	- remove reading from /etc/ config files
 	- review by the wireless developer community
=20
 Please send any patches or complaints about this driver to Greg


--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr0KUwACgkQQfdJUNXnsjp8/QCgrpSpJkh5cZcir9sEfFN0DvZ3
gHwAoI9VmsELWFOQLSbPyOQ22QVsMR0b
=As6b
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
