Return-Path: <linux-kernel-owner+w=401wt.eu-S1946219AbXBCPN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946219AbXBCPN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946319AbXBCPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:13:26 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:53651 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946219AbXBCPNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:13:25 -0500
Message-id: <2106930977152662464@wsc.cz>
Subject: [PATCH 1/2] Char: add __devinitdata to pci_device_ids
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Cyclades team <async@cyclades.com>
Cc: <airlied@linux.ie>, <dri-devel@lists.sourceforge.net>
Cc: <nils@kernelconcepts.de>, <wim@iguana.be>
Cc: <R.E.Wolff@BitWizard.nl>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Date: Sat,  3 Feb 2007 16:13:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

add __devinitdata to pci_device_ids

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 6518489059ea5f8eca8d1ae6de51a6452b46eb52
tree 241f514f7cd903b7815b4ffb10fa650f1e34ba26
parent 1647618e3fba255fc77181e9e2e4eeb09e214680
author Jiri Slaby <jirislaby@gmail.com> Sat, 03 Feb 2007 15:47:33 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 03 Feb 2007 15:47:33 +0100

 drivers/char/agp/ali-agp.c           |    2 +-
 drivers/char/agp/amd-k7-agp.c        |    2 +-
 drivers/char/agp/amd64-agp.c         |    2 +-
 drivers/char/agp/ati-agp.c           |    2 +-
 drivers/char/agp/efficeon-agp.c      |    2 +-
 drivers/char/agp/i460-agp.c          |    2 +-
 drivers/char/agp/intel-agp.c         |    2 +-
 drivers/char/agp/nvidia-agp.c        |    2 +-
 drivers/char/agp/sis-agp.c           |    2 +-
 drivers/char/agp/sworks-agp.c        |    2 +-
 drivers/char/agp/uninorth-agp.c      |    2 +-
 drivers/char/agp/via-agp.c           |    2 +-
 drivers/char/applicom.c              |    2 +-
 drivers/char/cs5535_gpio.c           |    2 +-
 drivers/char/drm/i810_drv.c          |    2 +-
 drivers/char/drm/i830_drv.c          |    2 +-
 drivers/char/drm/i915_drv.c          |    2 +-
 drivers/char/drm/mga_drv.c           |    2 +-
 drivers/char/drm/r128_drv.c          |    2 +-
 drivers/char/drm/radeon_drv.c        |    2 +-
 drivers/char/drm/savage_drv.c        |    2 +-
 drivers/char/drm/sis_drv.c           |    2 +-
 drivers/char/drm/tdfx_drv.c          |    2 +-
 drivers/char/drm/via_drv.c           |    2 +-
 drivers/char/epca.c                  |    2 +-
 drivers/char/hw_random/amd-rng.c     |    2 +-
 drivers/char/hw_random/geode-rng.c   |    2 +-
 drivers/char/hw_random/intel-rng.c   |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c     |    2 +-
 drivers/char/isicom.c                |    2 +-
 drivers/char/istallion.c             |    2 +-
 drivers/char/moxa.c                  |    2 +-
 drivers/char/mxser.c                 |    2 +-
 drivers/char/mxser_new.c             |    2 +-
 drivers/char/nozomi.c                |    2 +-
 drivers/char/stallion.c              |    2 +-
 drivers/char/sx.c                    |    2 +-
 drivers/char/synclink.c              |    2 +-
 drivers/char/synclink_gt.c           |    2 +-
 drivers/char/synclinkmp.c            |    2 +-
 drivers/char/watchdog/alim1535_wdt.c |    2 +-
 drivers/char/watchdog/i6300esb.c     |    2 +-
 drivers/char/watchdog/i8xx_tco.c     |    2 +-
 drivers/char/watchdog/pcwd_pci.c     |    2 +-
 drivers/char/watchdog/wdt_pci.c      |    2 +-
 45 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index 98177a9..2862a24 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -376,7 +376,7 @@ static void __devexit agp_ali_remove(struct pci_dev *pdev)
 	agp_put_bridge(bridge);
 }
 
-static struct pci_device_id agp_ali_pci_table[] = {
+static struct pci_device_id agp_ali_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index 3d8d448..30b4407 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -490,7 +490,7 @@ static void __devexit agp_amdk7_remove(struct pci_dev *pdev)
 }
 
 /* must be the same order as name table above */
-static struct pci_device_id agp_amdk7_pci_table[] = {
+static struct pci_device_id agp_amdk7_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 636d984..058b420 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -612,7 +612,7 @@ static int agp_amd64_resume(struct pci_dev *pdev)
 
 #endif /* CONFIG_PM */
 
-static struct pci_device_id agp_amd64_pci_table[] = {
+static struct pci_device_id agp_amd64_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 77c9ad6..e96f380 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -528,7 +528,7 @@ static void __devexit agp_ati_remove(struct pci_dev *pdev)
 	agp_put_bridge(bridge);
 }
 
-static struct pci_device_id agp_ati_pci_table[] = {
+static struct pci_device_id agp_ati_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 658cb1a..ced8104 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -421,7 +421,7 @@ static int agp_efficeon_resume(struct pci_dev *pdev)
 }
 #endif
 
-static struct pci_device_id agp_efficeon_pci_table[] = {
+static struct pci_device_id agp_efficeon_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 3e76186..d9ab377 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -614,7 +614,7 @@ static void __devexit agp_intel_i460_remove(struct pci_dev *pdev)
 	agp_put_bridge(bridge);
 }
 
-static struct pci_device_id agp_intel_i460_pci_table[] = {
+static struct pci_device_id agp_intel_i460_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 4e455f0..96b93de 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2039,7 +2039,7 @@ static int agp_intel_resume(struct pci_dev *pdev)
 }
 #endif
 
-static struct pci_device_id agp_intel_pci_table[] = {
+static struct pci_device_id agp_intel_pci_table[] __devinitdata = {
 #define ID(x)						\
 	{						\
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),	\
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 2563286..ed8f7e5 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -400,7 +400,7 @@ static int agp_nvidia_resume(struct pci_dev *pdev)
 #endif
 
 
-static struct pci_device_id agp_nvidia_pci_table[] = {
+static struct pci_device_id agp_nvidia_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index a00fd48..2333d79 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -317,7 +317,7 @@ static void __devexit agp_sis_remove(struct pci_dev *pdev)
 	agp_put_bridge(bridge);
 }
 
-static struct pci_device_id agp_sis_pci_table[] = {
+static struct pci_device_id agp_sis_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 9f5ae77..14790e3 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -529,7 +529,7 @@ static void __devexit agp_serverworks_remove(struct pci_dev *pdev)
 	agp_put_bridge(bridge);
 }
 
-static struct pci_device_id agp_serverworks_pci_table[] = {
+static struct pci_device_id agp_serverworks_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index 6c45702..a8cd750 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -659,7 +659,7 @@ static void __devexit agp_uninorth_remove(struct pci_dev *pdev)
 	agp_put_bridge(bridge);
 }
 
-static struct pci_device_id agp_uninorth_pci_table[] = {
+static struct pci_device_id agp_uninorth_pci_table[] __devinitdata = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 	.class_mask	= ~0,
diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 2e7c043..0a03826 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -501,7 +501,7 @@ static int agp_via_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 /* must be the same order as name table above */
-static const struct pci_device_id agp_via_pci_table[] = {
+static const struct pci_device_id agp_via_pci_table[] __devinitdata = {
 #define ID(x) \
 	{						\
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),	\
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 1f0b752..b44bb02 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -65,7 +65,7 @@ static char *applicom_pci_devnames[] = {
 	"PCI2000PFB"
 };
 
-static struct pci_device_id applicom_pci_tbl[] = {
+static struct pci_device_id applicom_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index c02d9e9..8b84efc 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -39,7 +39,7 @@ MODULE_PARM_DESC(mask, "GPIO channel mask");
 
 static u32 gpio_base;
 
-static struct pci_device_id divil_pci[] = {
+static struct pci_device_id divil_pci[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
 	{ } /* NULL entry */
diff --git a/drivers/char/drm/i810_drv.c b/drivers/char/drm/i810_drv.c
index fabb9a8..1e74cca 100644
--- a/drivers/char/drm/i810_drv.c
+++ b/drivers/char/drm/i810_drv.c
@@ -37,7 +37,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	i810_PCI_IDS
 };
 
diff --git a/drivers/char/drm/i830_drv.c b/drivers/char/drm/i830_drv.c
index 389597e..8b06a71 100644
--- a/drivers/char/drm/i830_drv.c
+++ b/drivers/char/drm/i830_drv.c
@@ -39,7 +39,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	i830_PCI_IDS
 };
 
diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index 85bcc27..c8c0691 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -34,7 +34,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	i915_PCI_IDS
 };
 
diff --git a/drivers/char/drm/mga_drv.c b/drivers/char/drm/mga_drv.c
index be49dbb..76c4d21 100644
--- a/drivers/char/drm/mga_drv.c
+++ b/drivers/char/drm/mga_drv.c
@@ -38,7 +38,7 @@
 
 static int mga_driver_device_is_agp(drm_device_t * dev);
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	mga_PCI_IDS
 };
 
diff --git a/drivers/char/drm/r128_drv.c b/drivers/char/drm/r128_drv.c
index 6108e75..fe87d40 100644
--- a/drivers/char/drm/r128_drv.c
+++ b/drivers/char/drm/r128_drv.c
@@ -36,7 +36,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	r128_PCI_IDS
 };
 
diff --git a/drivers/char/drm/radeon_drv.c b/drivers/char/drm/radeon_drv.c
index 2eb652e..a6deb5a 100644
--- a/drivers/char/drm/radeon_drv.c
+++ b/drivers/char/drm/radeon_drv.c
@@ -52,7 +52,7 @@ static int dri_library_name(struct drm_device *dev, char *buf)
 		        "r300"));
 }
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	radeon_PCI_IDS
 };
 
diff --git a/drivers/char/drm/savage_drv.c b/drivers/char/drm/savage_drv.c
index eee52aa..79a0dfa 100644
--- a/drivers/char/drm/savage_drv.c
+++ b/drivers/char/drm/savage_drv.c
@@ -29,7 +29,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	savage_PCI_IDS
 };
 
diff --git a/drivers/char/drm/sis_drv.c b/drivers/char/drm/sis_drv.c
index 3d5b321..ce69896 100644
--- a/drivers/char/drm/sis_drv.c
+++ b/drivers/char/drm/sis_drv.c
@@ -31,7 +31,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	sisdrv_PCI_IDS
 };
 
diff --git a/drivers/char/drm/tdfx_drv.c b/drivers/char/drm/tdfx_drv.c
index 012ff2e..d1f7d86 100644
--- a/drivers/char/drm/tdfx_drv.c
+++ b/drivers/char/drm/tdfx_drv.c
@@ -35,7 +35,7 @@
 
 #include "drm_pciids.h"
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	tdfx_PCI_IDS
 };
 
diff --git a/drivers/char/drm/via_drv.c b/drivers/char/drm/via_drv.c
index bb9dde8..10b9745 100644
--- a/drivers/char/drm/via_drv.c
+++ b/drivers/char/drm/via_drv.c
@@ -33,7 +33,7 @@ static int dri_library_name(struct drm_device *dev, char *buf)
 	return snprintf(buf, PAGE_SIZE, "unichrome");
 }
 
-static struct pci_device_id pciidlist[] = {
+static struct pci_device_id pciidlist[] __devinitdata = {
 	viadrv_PCI_IDS
 };
 
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 88fc24f..7490445 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -3092,7 +3092,7 @@ err_out:
 }
 
 
-static struct pci_device_id epca_pci_tbl[] = {
+static struct pci_device_id epca_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_DIGI, PCI_DEVICE_XR, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xr },
 	{ PCI_VENDOR_DIGI, PCI_DEVICE_XEM, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xem },
 	{ PCI_VENDOR_DIGI, PCI_DEVICE_CX, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_cx },
diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 556fd81..b2d8cee 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -42,7 +42,7 @@
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static const struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] __devinitdata = {
 	{ 0x1022, 0x7443, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
 	{ 0x1022, 0x746b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
 	{ 0, },	/* terminate list */
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 8e8658d..ce02982 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -44,7 +44,7 @@
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static const struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
 	{ 0, },	/* terminate list */
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index f22e78e..83046bf 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -94,7 +94,7 @@
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static const struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] __devinitdata = {
 /* AA
 	{ 0x8086, 0x2418, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
 	{ 0x8086, 0x2410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* AA */
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index a7b33d2..3c381d9 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2153,7 +2153,7 @@ static int ipmi_pci_resume(struct pci_dev *pdev)
 }
 #endif
 
-static struct pci_device_id ipmi_pci_devices[] = {
+static struct pci_device_id ipmi_pci_devices[] __devinitdata = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
 	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
 };
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 43ab9ed..6a2a04f 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -148,7 +148,7 @@
 static int isicom_probe(struct pci_dev *, const struct pci_device_id *);
 static void __devexit isicom_remove(struct pci_dev *);
 
-static struct pci_device_id isicom_pci_tbl[] = {
+static struct pci_device_id isicom_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(VENDOR_ID, 0x2028) },
 	{ PCI_DEVICE(VENDOR_ID, 0x2051) },
 	{ PCI_DEVICE(VENDOR_ID, 0x2052) },
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7b279d1..396ed7a 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -384,7 +384,7 @@ static int	stli_eisamempsize = ARRAY_SIZE(stli_eisamemprobeaddrs);
 #define	PCI_DEVICE_ID_ECRA		0x0004
 #endif
 
-static struct pci_device_id istallion_pci_tbl[] = {
+static struct pci_device_id istallion_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECRA), },
 	{ 0 }
 };
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 7dbaee8..430cadc 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -79,7 +79,7 @@ static char *moxa_brdname[] =
 };
 
 #ifdef CONFIG_PCI
-static struct pci_device_id moxa_pcibrds[] = {
+static struct pci_device_id moxa_pcibrds[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C218),
 		.driver_data = MOXA_BOARD_C218_PCI },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C320),
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index a61fb6d..6da6891 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -204,7 +204,7 @@ static const struct mxpciuart_info Gpci_uart_info[UART_INFO_NUM] = {
 
 #ifdef CONFIG_PCI
 
-static struct pci_device_id mxser_pcibrds[] = {
+static struct pci_device_id mxser_pcibrds[] __devinitdata = {
 	{PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C168, PCI_ANY_ID, PCI_ANY_ID, 0, 0, MXSER_BOARD_C168_PCI},
 	{PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C104, PCI_ANY_ID, PCI_ANY_ID, 0, 0, MXSER_BOARD_C104_PCI},
 	{PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP132, PCI_ANY_ID, PCI_ANY_ID, 0, 0, MXSER_BOARD_CP132},
diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 9af07e4..aaf3bcf 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -138,7 +138,7 @@ static const struct mxser_cardinfo mxser_cards[] = {
 
 /* driver_data correspond to the lines in the structure above
    see also ISA probe function before you change something */
-static struct pci_device_id mxser_pcibrds[] = {
+static struct pci_device_id mxser_pcibrds[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C168),
 		.driver_data = 3 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C104),
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 6dc5dd7..e970ea1 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -465,7 +465,7 @@ struct buffer {
 static int ntty_tty_init(struct nozomi * dc);
 
 /*    Global variables */
-static struct pci_device_id nozomi_pci_tbl[] = {
+static struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
 	{PCI_DEVICE(VENDOR1, DEVICE1)},
 	{0,}
 };
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index e45113a..08e1b93 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -367,7 +367,7 @@ static spinlock_t stallion_lock;	/* Guard the tty driver */
  *	Define structure to hold all Stallion PCI boards.
  */
 
-static struct pci_device_id stl_pcibrds[] = {
+static struct pci_device_id stl_pcibrds[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECHPCI864),
 		.driver_data = BRD_ECH64PCI },
 	{ PCI_DEVICE(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_EIOPCI),
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 1da92a6..7d832dc 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2719,7 +2719,7 @@ static void __devexit sx_pci_remove(struct pci_dev *pdev)
 
 /* Specialix has a whole bunch of cards with 0x2000 as the device ID. They say
    its because the standard requires it. So check for SUBVENDOR_ID. */
-static struct pci_device_id sx_pci_tbl[] = {
+static struct pci_device_id sx_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
 		.subvendor = 0x0200,.subdevice = PCI_ANY_ID },
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index bf76db1..d9db31c 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -905,7 +905,7 @@ static int synclink_init_one (struct pci_dev *dev,
 				     const struct pci_device_id *ent);
 static void synclink_remove_one (struct pci_dev *dev);
 
-static struct pci_device_id synclink_pci_tbl[] = {
+static struct pci_device_id synclink_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_MICROGATE, PCI_DEVICE_ID_MICROGATE_USC, PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_MICROGATE, 0x0210, PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0, }, /* terminate list */
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 54af763..52e3f69 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -100,7 +100,7 @@ MODULE_LICENSE("GPL");
 #define MGSL_MAGIC 0x5401
 #define MAX_DEVICES 32
 
-static struct pci_device_id pci_table[] = {
+static struct pci_device_id pci_table[] __devinitdata = {
 	{PCI_VENDOR_ID_MICROGATE, SYNCLINK_GT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{PCI_VENDOR_ID_MICROGATE, SYNCLINK_GT2_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{PCI_VENDOR_ID_MICROGATE, SYNCLINK_GT4_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index ebde4e5..c5ebfc0 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -492,7 +492,7 @@ static char *driver_version = "$Revision: 4.38 $";
 static int synclinkmp_init_one(struct pci_dev *dev,const struct pci_device_id *ent);
 static void synclinkmp_remove_one(struct pci_dev *dev);
 
-static struct pci_device_id synclinkmp_pci_tbl[] = {
+static struct pci_device_id synclinkmp_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_MICROGATE, PCI_DEVICE_ID_MICROGATE_SCA, PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0, }, /* terminate list */
 };
diff --git a/drivers/char/watchdog/alim1535_wdt.c b/drivers/char/watchdog/alim1535_wdt.c
index e3f6a7d..7168569 100644
--- a/drivers/char/watchdog/alim1535_wdt.c
+++ b/drivers/char/watchdog/alim1535_wdt.c
@@ -311,7 +311,7 @@ static int ali_notify_sys(struct notifier_block *this, unsigned long code, void
  *	want to register another driver on the same PCI id.
  */
 
-static struct pci_device_id ali_pci_tbl[] = {
+static struct pci_device_id ali_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
diff --git a/drivers/char/watchdog/i6300esb.c b/drivers/char/watchdog/i6300esb.c
index c598250..74a4cec 100644
--- a/drivers/char/watchdog/i6300esb.c
+++ b/drivers/char/watchdog/i6300esb.c
@@ -364,7 +364,7 @@ static struct notifier_block esb_notifier = {
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static struct pci_device_id esb_pci_tbl[] = {
+static struct pci_device_id esb_pci_tbl[] __devinitdata = {
         { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
         { 0, },                 /* End of list */
 };
diff --git a/drivers/char/watchdog/i8xx_tco.c b/drivers/char/watchdog/i8xx_tco.c
index a62ef48..a4acc9b 100644
--- a/drivers/char/watchdog/i8xx_tco.c
+++ b/drivers/char/watchdog/i8xx_tco.c
@@ -405,7 +405,7 @@ static struct notifier_block i8xx_tco_notifier = {
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static struct pci_device_id i8xx_tco_pci_tbl[] = {
+static struct pci_device_id i8xx_tco_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_0) },
diff --git a/drivers/char/watchdog/pcwd_pci.c b/drivers/char/watchdog/pcwd_pci.c
index 61a89e9..a805813 100644
--- a/drivers/char/watchdog/pcwd_pci.c
+++ b/drivers/char/watchdog/pcwd_pci.c
@@ -794,7 +794,7 @@ static void __devexit pcipcwd_card_exit(struct pci_dev *pdev)
 	cards_found--;
 }
 
-static struct pci_device_id pcipcwd_pci_tbl[] = {
+static struct pci_device_id pcipcwd_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_QUICKLOGIC, PCI_DEVICE_ID_WATCHDOG_PCIPCWD,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 },			/* End of list */
diff --git a/drivers/char/watchdog/wdt_pci.c b/drivers/char/watchdog/wdt_pci.c
index 6baf4ae..84ef6e3 100644
--- a/drivers/char/watchdog/wdt_pci.c
+++ b/drivers/char/watchdog/wdt_pci.c
@@ -696,7 +696,7 @@ static void __devexit wdtpci_remove_one (struct pci_dev *pdev)
 }
 
 
-static struct pci_device_id wdtpci_pci_tbl[] = {
+static struct pci_device_id wdtpci_pci_tbl[] __devinitdata = {
 	{
 		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
 		.device	   = PCI_DEVICE_ID_WDG_CSM,
