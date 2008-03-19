Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbYCSWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbYCSWE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761114AbYCSU23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:28:29 -0400
Received: from pilet.ens-lyon.fr ([140.77.167.16]:40273 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbYCSU2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:28:25 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 16:28:24 EDT
Date: Wed, 19 Mar 2008 21:28:18 +0100
From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] [TRIVIAL] spelling fix in various files: preferred ->
	preferred
Message-ID: <20080319202818.GE6935@ens-lyon.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fix: prefered -> preferred

Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>

diff -r 2202c155b8c3 -r ef957e3033e5 Documentation/i2c/busses/i2c-parport-light
--- a/Documentation/i2c/busses/i2c-parport-light	Tue Mar 18 21:34:48 2008 -0700
+++ b/Documentation/i2c/busses/i2c-parport-light	Wed Mar 19 21:01:45 2008 +0100
@@ -4,7 +4,7 @@
 
 This driver is a light version of i2c-parport. It doesn't depend        
 on the parport driver, and uses direct I/O access instead. This might be
-prefered on embedded systems where wasting memory for the clean but heavy
+preferred on embedded systems where wasting memory for the clean but heavy
 parport handling is not an option. The drawback is a reduced portability
 and the impossibility to daisy-chain other parallel port devices.                 
   
diff -r 2202c155b8c3 -r ef957e3033e5 arch/m68knommu/platform/coldfire/head.S
--- a/arch/m68knommu/platform/coldfire/head.S	Tue Mar 18 21:34:48 2008 -0700
+++ b/arch/m68knommu/platform/coldfire/head.S	Wed Mar 19 21:01:45 2008 +0100
@@ -19,7 +19,7 @@
 
 /*
  *	If we don't have a fixed memory size, then lets build in code
- *	to auto detect the DRAM size. Obviously this is the prefered
+ *	to auto detect the DRAM size. Obviously this is the preferred
  *	method, and should work for most boards. It won't work for those
  *	that do not have their RAM starting at address 0, and it only
  *	works on SDRAM (not boards fitted with SRAM).
diff -r 2202c155b8c3 -r ef957e3033e5 arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/arch/s390/kernel/time.c	Wed Mar 19 21:01:45 2008 +0100
@@ -1038,7 +1038,7 @@
 		eacr = etr_handle_update(&aib, eacr);
 
 	/*
-	 * Select ports to enable. The prefered synchronization mode is PPS.
+	 * Select ports to enable. The preferred synchronization mode is PPS.
 	 * If a port can be enabled depends on a number of things:
 	 * 1) The port needs to be online and uptodate. A port is not
 	 *    disabled just because it is not uptodate, but it is only
diff -r 2202c155b8c3 -r ef957e3033e5 drivers/media/video/cx25840/cx25840-core.c
--- a/drivers/media/video/cx25840/cx25840-core.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/drivers/media/video/cx25840/cx25840-core.c	Wed Mar 19 21:01:45 2008 +0100
@@ -245,7 +245,7 @@
 	cx25840_write(client, 0x918, 0xa0);
 	cx25840_write(client, 0x919, 0x01);
 
-	/* stereo prefered */
+	/* stereo preferred */
 	cx25840_write(client, 0x809, 0x04);
 	/* AC97 shift */
 	cx25840_write(client, 0x8cf, 0x0f);
diff -r 2202c155b8c3 -r ef957e3033e5 drivers/net/enc28j60_hw.h
--- a/drivers/net/enc28j60_hw.h	Tue Mar 18 21:34:48 2008 -0700
+++ b/drivers/net/enc28j60_hw.h	Wed Mar 19 21:01:45 2008 +0100
@@ -303,7 +303,7 @@
 /* maximum ethernet frame length */
 #define MAX_FRAMELEN		1518
 
-/* Prefered half duplex: LEDA: Link status LEDB: Rx/Tx activity */
+/* Preferred half duplex: LEDA: Link status LEDB: Rx/Tx activity */
 #define ENC28J60_LAMPS_MODE	0x3476
 
 #endif
diff -r 2202c155b8c3 -r ef957e3033e5 drivers/net/sk98lin/skrlmt.c
--- a/drivers/net/sk98lin/skrlmt.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/drivers/net/sk98lin/skrlmt.c	Wed Mar 19 21:01:45 2008 +0100
@@ -1627,7 +1627,7 @@
 	PortFound = SK_FALSE;
 	pAC->Rlmt.CheckSwitch = SK_FALSE;
 
-#if 0	/* RW 2001/10/18 - active port becomes always prefered one */
+#if 0	/* RW 2001/10/18 - active port becomes always preferred one */
 	if (pAC->Rlmt.Net[NetIdx].Preference == 0xFFFFFFFF) { /* Automatic */
 		/* disable auto-fail back */
 		PrefPort = Active;
diff -r 2202c155b8c3 -r ef957e3033e5 drivers/net/tokenring/madgemc.c
--- a/drivers/net/tokenring/madgemc.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/drivers/net/tokenring/madgemc.c	Wed Mar 19 21:01:45 2008 +0100
@@ -459,7 +459,7 @@
 }
 
 /*
- * Set the card to the prefered ring speed.
+ * Set the card to the preferred ring speed.
  *
  * Unlike newer cards, the MC16/32 have their speed selection
  * circuit connected to the Madge ASICs and not to the TMS380
diff -r 2202c155b8c3 -r ef957e3033e5 include/acpi/actbl.h
--- a/include/acpi/actbl.h	Tue Mar 18 21:34:48 2008 -0700
+++ b/include/acpi/actbl.h	Wed Mar 19 21:01:45 2008 +0100
@@ -260,9 +260,9 @@
 #define ACPI_FADT_APIC_PHYSICAL     (1<<19)	/* 19: All local x_aPICs must use physical dest mode (ACPI 3.0) */
 
 /*
- * FADT Prefered Power Management Profiles
+ * FADT Preferred Power Management Profiles
  */
-enum acpi_prefered_pm_profiles {
+enum acpi_preferred_pm_profiles {
 	PM_UNSPECIFIED = 0,
 	PM_DESKTOP = 1,
 	PM_MOBILE = 2,
diff -r 2202c155b8c3 -r ef957e3033e5 include/asm-blackfin/cplbinit.h
--- a/include/asm-blackfin/cplbinit.h	Tue Mar 18 21:34:48 2008 -0700
+++ b/include/asm-blackfin/cplbinit.h	Wed Mar 19 21:01:45 2008 +0100
@@ -52,7 +52,7 @@
 struct cplb_desc {
 	u32 start; /* start address */
 	u32 end; /* end address */
-	u32 psize; /* prefered size if any otherwise 1MB or 4MB*/
+	u32 psize; /* preferred size if any otherwise 1MB or 4MB*/
 	u16 attr;/* attributes */
 	u16 i_conf;/* I-CPLB DATA */
 	u16 d_conf;/* D-CPLB DATA */
diff -r 2202c155b8c3 -r ef957e3033e5 include/asm-ia64/sn/bte.h
--- a/include/asm-ia64/sn/bte.h	Tue Mar 18 21:34:48 2008 -0700
+++ b/include/asm-ia64/sn/bte.h	Wed Mar 19 21:01:45 2008 +0100
@@ -216,7 +216,7 @@
 	bte_copy(0, dest, len, ((mode) | BTE_ZERO_FILL), notification)
 
 /*
- * The following is the prefered way of calling bte_unaligned_copy
+ * The following is the preferred way of calling bte_unaligned_copy
  * If the copy is fully cache line aligned, then bte_copy is
  * used instead.  Since bte_copy is inlined, this saves a call
  * stack.  NOTE: bte_copy is called synchronously and does block
diff -r 2202c155b8c3 -r ef957e3033e5 include/linux/prefetch.h
--- a/include/linux/prefetch.h	Tue Mar 18 21:34:48 2008 -0700
+++ b/include/linux/prefetch.h	Wed Mar 19 21:01:45 2008 +0100
@@ -29,7 +29,7 @@
 	prefetchw(x)	- prefetches the cacheline at "x" for write
 	spin_lock_prefetch(x) - prefetches the spinlock *x for taking
 	
-	there is also PREFETCH_STRIDE which is the architecure-prefered 
+	there is also PREFETCH_STRIDE which is the architecure-preferred 
 	"lookahead" size for prefetching streamed operations.
 	
 */
diff -r 2202c155b8c3 -r ef957e3033e5 include/net/iw_handler.h
--- a/include/net/iw_handler.h	Tue Mar 18 21:34:48 2008 -0700
+++ b/include/net/iw_handler.h	Wed Mar 19 21:01:45 2008 +0100
@@ -129,7 +129,7 @@
  *
  * Functions prototype uses union iwreq_data
  * -----------------------------------------
- * Some would have prefered functions defined this way :
+ * Some would have preferred functions defined this way :
  *	static int mydriver_ioctl_setrate(struct net_device *dev, 
  *					  long rate, int auto)
  * 1) The kernel code doesn't "validate" the content of iwreq_data, and
diff -r 2202c155b8c3 -r ef957e3033e5 sound/pci/ice1712/ice1712.c
--- a/sound/pci/ice1712/ice1712.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/sound/pci/ice1712/ice1712.c	Wed Mar 19 21:01:45 2008 +0100
@@ -2712,7 +2712,7 @@
 			return err;
 		}
 		if (c->mpu401_1_name)
-			/*  Prefered name available in card_info */
+			/*  Preferred name available in card_info */
 			snprintf(ice->rmidi[0]->name,
 				 sizeof(ice->rmidi[0]->name),
 				 "%s %d", c->mpu401_1_name, card->number);
@@ -2729,7 +2729,7 @@
 				return err;
 			}
 			if (c->mpu401_2_name)
-				/*  Prefered name available in card_info */
+				/*  Preferred name available in card_info */
 				snprintf(ice->rmidi[1]->name,
 					 sizeof(ice->rmidi[1]->name),
 					 "%s %d", c->mpu401_2_name,

-- 
:wq
