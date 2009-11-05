Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZKEGkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZKEGkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZKEGka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:40:30 -0500
Received: from sedf.de ([212.83.34.151]:37876 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbZKEGk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:40:29 -0500
Date: Thu, 5 Nov 2009 07:07:25 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 2/3] staging: rt2860: remove superfluous newlines
Message-ID: <20091105060725.GB8664@sedf.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>
Subject: [Patch 2/3] staging: rt2860: remove superfluous newlines

This patch is based on 2.6.32-rc6

This tiny patch removes a few quite unnecessary extra newlines from
DBGPRINT() and printk() strings.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru b/drivers/staging/rt2860/common/dfs.c c/drivers/staging/rt2860/com=
mon/dfs.c
--- b/drivers/staging/rt2860/common/dfs.c	2009-11-04 23:32:24.000000000 +01=
00
+++ c/drivers/staging/rt2860/common/dfs.c	2009-11-05 00:06:25.872076137 +01=
00
@@ -367,7 +367,7 @@
 	// channel availability check time is 60sec, use 65 for assurance
 	if (pAd->CommonCfg.RadarDetect.RDCount++ > pAd->CommonCfg.RadarDetect.ChM=
ovingTime)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("Not found radar signal, start send beacon and=
 radar detection in service monitor\n\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("Not found radar signal, start send beacon and=
 radar detection in service monitor\n"));
 			BbpRadarDetectionStop(pAd);
 		AsicEnableBssSync(pAd);
 		pAd->CommonCfg.RadarDetect.RDMode =3D RD_NORMAL_MODE;
diff -ru b/drivers/staging/rt2860/common/rtmp_init.c c/drivers/staging/rt28=
60/common/rtmp_init.c
--- b/drivers/staging/rt2860/common/rtmp_init.c	2009-11-04 23:32:24.0000000=
00 +0100
+++ c/drivers/staging/rt2860/common/rtmp_init.c	2009-11-05 00:05:45.3120780=
83 +0100
@@ -244,7 +244,7 @@
 			break;
 		}
 		pAd->BeaconBuf =3D pBeaconBuf;
-		printk("\n\n=3D=3D=3D pAd =3D %p, size =3D %d =3D=3D=3D\n\n", pAd, (UINT=
32)sizeof(RTMP_ADAPTER));
+		printk("=3D=3D=3D pAd =3D %p, size =3D %d =3D=3D=3D\n", pAd, (UINT32)siz=
eof(RTMP_ADAPTER));
=20
=20
 		// Init spin locks
@@ -3031,7 +3031,7 @@
     if (Index > 1000)
 	{
 		Status =3D NDIS_STATUS_FAILURE;
-		DBGPRINT(RT_DEBUG_ERROR, ("NICLoadFirmware: MCU is not ready\n\n\n"));
+		DBGPRINT(RT_DEBUG_ERROR, ("NICLoadFirmware: MCU is not ready\n"));
 	} /* End of if */
=20
     DBGPRINT(RT_DEBUG_TRACE,
diff -ru b/drivers/staging/rt2860/rt_linux.c c/drivers/staging/rt2860/rt_li=
nux.c
--- b/drivers/staging/rt2860/rt_linux.c	2009-11-04 23:32:24.000000000 +0100
+++ c/drivers/staging/rt2860/rt_linux.c	2009-11-05 00:07:10.402917865 +0100
@@ -384,7 +384,7 @@
  	{
 		*ppPacket =3D NULL;
 #ifdef DEBUG
-		printk("RTMPAllocateNdisPacket Fail\n\n");
+		printk("RTMPAllocateNdisPacket Fail\n");
 #endif
 		return NDIS_STATUS_FAILURE;
 	}

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrya50ACgkQQfdJUNXnsjoIdACgpW9kWNqimntC3ryYVWK0KkbU
nRkAn3G57LiJeAJyI/lFzi4/22GSvOeP
=F/ke
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
