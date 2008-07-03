Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbYGCHGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbYGCHGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYGCG5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:2925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYGCCaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:30:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="asc'?scan'208";a="302169881"
Date: Thu, 3 Jul 2008 10:20:34 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [AGP] intel_agp: official name for GM45 chipset
Message-ID: <20080703022034.GA1569@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


[AGP] intel_agp: official name for GM45 chipset

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index df70264..6e5816d 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -32,8 +32,8 @@
 #define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
 #define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
-#define PCI_DEVICE_ID_INTEL_IGD_HB          0x2A40
-#define PCI_DEVICE_ID_INTEL_IGD_IG          0x2A42
+#define PCI_DEVICE_ID_INTEL_GM45_HB         0x2A40
+#define PCI_DEVICE_ID_INTEL_GM45_IG         0x2A42
 #define PCI_DEVICE_ID_INTEL_IGD_E_HB        0x2E00
 #define PCI_DEVICE_ID_INTEL_IGD_E_IG        0x2E02
 #define PCI_DEVICE_ID_INTEL_Q45_HB          0x2E10
@@ -55,7 +55,7 @@
 		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82965G_HB || \
 		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82965GM_HB || \
 		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82965GME_HB || \
-		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_IGD_HB)
+		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_GM45_HB)
=20
 #define IS_G33 (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_G33_HB =
|| \
 		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -1182,7 +1182,7 @@ static unsigned long intel_i965_mask_memory(struct ag=
p_bridge_data *bridge,
 static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
 {
 	switch (agp_bridge->dev->device) {
-	case PCI_DEVICE_ID_INTEL_IGD_HB:
+	case PCI_DEVICE_ID_INTEL_GM45_HB:
 	case PCI_DEVICE_ID_INTEL_IGD_E_HB:
 	case PCI_DEVICE_ID_INTEL_Q45_HB:
 	case PCI_DEVICE_ID_INTEL_G45_HB:
@@ -2117,8 +2117,8 @@ static const struct intel_driver_description {
 		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
 		NULL, &intel_g33_driver },
-	{ PCI_DEVICE_ID_INTEL_IGD_HB, PCI_DEVICE_ID_INTEL_IGD_IG, 0,
-	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_GM45_HB, PCI_DEVICE_ID_INTEL_GM45_IG, 0,
+	    "Mobile Intel=AE GM45 Express", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_IGD_E_HB, PCI_DEVICE_ID_INTEL_IGD_E_IG, 0,
 	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_Q45_HB, PCI_DEVICE_ID_INTEL_Q45_IG, 0,
@@ -2315,7 +2315,7 @@ static struct pci_device_id agp_intel_pci_table[] =3D=
 {
 	ID(PCI_DEVICE_ID_INTEL_G33_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
-	ID(PCI_DEVICE_ID_INTEL_IGD_HB),
+	ID(PCI_DEVICE_ID_INTEL_GM45_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGD_E_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
--=20
1.5.3.1

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhsN3IACgkQsQQaM014GCcL/wCfZAozihAkuBmLs9kt+5+7xDrz
1b4An21yypxD5V5UH9N78efQAm8eDjnq
=Jazi
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
