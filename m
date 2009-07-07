Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZGGOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZGGOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbZGGOdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:33:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:42661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214AbZGGOdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:33:50 -0400
Subject: [PATCH 5/22] trivial: fix typo "be be" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:40:13 +0530
Message-Id: <1246975813.3613.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "be be" with "be" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/filesystems/caching/operations.txt |    2 +-
 Documentation/scsi/advansys.txt                  |    2 +-
 arch/frv/kernel/sleep.S                          |    2 +-
 arch/x86/math-emu/reg_u_sub.S                    |    2 +-
 drivers/pci/hotplug/ibmphp.h                     |    2 +-
 drivers/staging/frontier/alphatrack.c            |    2 +-
 drivers/staging/frontier/tranzport.c             |    2 +-
 drivers/video/aty/mach64_cursor.c                |    2 +-
 include/sound/soc-dai.h                          |    2 +-
 sound/isa/es18xx.c                               |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/caching/operations.txt b/Documentation/filesystems/caching/operations.txt
index b6b070c..18f3f98 100644
--- a/Documentation/filesystems/caching/operations.txt
+++ b/Documentation/filesystems/caching/operations.txt
@@ -26,7 +26,7 @@ data storage and retrieval routines.  Its operations are represented by
 fscache_operation structs, though these are usually embedded into some other
 structure.
 
-This facility is available to and expected to be be used by the cache backends,
+This facility is available to and expected to be used by the cache backends,
 and FS-Cache will create operations and pass them off to the appropriate cache
 backend for completion.
 
diff --git a/Documentation/scsi/advansys.txt b/Documentation/scsi/advansys.txt
index 4a3db62..a80067f 100644
--- a/Documentation/scsi/advansys.txt
+++ b/Documentation/scsi/advansys.txt
@@ -114,7 +114,7 @@ The following constants can be defined in the source file.
    c. klogd is started with the appropriate -c parameter
       (e.g. klogd -c 8)
 
-   This will cause printk() messages to be be displayed on the
+   This will cause printk() messages to be displayed on the
    current console. Refer to the klogd(8) and syslogd(8) man pages
    for details.
 
diff --git a/arch/frv/kernel/sleep.S b/arch/frv/kernel/sleep.S
index f67bf73..0fae422 100644
--- a/arch/frv/kernel/sleep.S
+++ b/arch/frv/kernel/sleep.S
@@ -123,7 +123,7 @@ frv_cpu_suspend:
 
 #
 # the final part of the sleep sequence...
-# - we want it to be be cacheline aligned so we can lock it into the icache easily
+# - we want it to be cacheline aligned so we can lock it into the icache easily
 #  On entry:	gr7 holds desired hsr0 sleep value
 #               gr8 holds desired psr sleep value
 #
diff --git a/arch/x86/math-emu/reg_u_sub.S b/arch/x86/math-emu/reg_u_sub.S
index 1b6c248..5c55c8a 100644
--- a/arch/x86/math-emu/reg_u_sub.S
+++ b/arch/x86/math-emu/reg_u_sub.S
@@ -49,7 +49,7 @@ ENTRY(FPU_u_sub)
 	/* source 2 is always smaller than source 1 */
 	js	L_bugged_1
 
-	testl	$0x80000000,SIGH(%edi)	/* The args are assumed to be be normalized */
+	testl	$0x80000000,SIGH(%edi)	/* The args are assumed to be normalized */
 	je	L_bugged_2
 
 	testl	$0x80000000,SIGH(%esi)
diff --git a/drivers/pci/hotplug/ibmphp.h b/drivers/pci/hotplug/ibmphp.h
index a8d391a..f964979 100644
--- a/drivers/pci/hotplug/ibmphp.h
+++ b/drivers/pci/hotplug/ibmphp.h
@@ -751,7 +751,7 @@ struct controller {
 
 extern int ibmphp_init_devno (struct slot **);	/* This function is called from EBDA, so we need it not be static */
 extern int ibmphp_do_disable_slot (struct slot *slot_cur);
-extern int ibmphp_update_slot_info (struct slot *);	/* This function is called from HPC, so we need it to not be be static */
+extern int ibmphp_update_slot_info (struct slot *);	/* This function is called from HPC, so we need it to not be static */
 extern int ibmphp_configure_card (struct pci_func *, u8);
 extern int ibmphp_unconfigure_card (struct slot **, int);
 extern struct hotplug_slot_ops ibmphp_hotplug_slot_ops;
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 15aed87..1e8d0ad 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -599,7 +599,7 @@ static ssize_t usb_alphatrack_write(struct file *file,
 	}
 
 	if (dev->interrupt_out_endpoint == NULL) {
-		err("Endpoint should not be be null! \n");
+		err("Endpoint should not be null! \n");
 		goto unlock_exit;
 	}
 
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index ef8fcc8..fda8fff 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -724,7 +724,7 @@ static ssize_t usb_tranzport_write(struct file *file,
 	}
 
 	if (dev->interrupt_out_endpoint == NULL) {
-		err("Endpoint should not be be null! \n");
+		err("Endpoint should not be null! \n");
 		goto unlock_exit;
 	}
 
diff --git a/drivers/video/aty/mach64_cursor.c b/drivers/video/aty/mach64_cursor.c
index 04c7108..959e03b 100644
--- a/drivers/video/aty/mach64_cursor.c
+++ b/drivers/video/aty/mach64_cursor.c
@@ -45,7 +45,7 @@
  * The Screen position of the top left corner of the displayed
  * cursor is specificed by CURS_HORZ_VERT_POSN. Care must be taken
  * when the cursor hot spot is not the top left corner and the
- * physical cursor position becomes negative. It will be be displayed
+ * physical cursor position becomes negative. It will be displayed
  * if either the horizontal or vertical cursor position is negative
  *
  * If x becomes negative the cursor manager must adjust the CURS_HORZ_OFFSET
diff --git a/include/sound/soc-dai.h b/include/sound/soc-dai.h
index 352d7ee..e391533 100644
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -38,7 +38,7 @@ struct snd_pcm_substream;
 /*
  * DAI Clock gating.
  *
- * DAI bit clocks can be be gated (disabled) when not the DAI is not
+ * DAI bit clocks can be gated (disabled) when not the DAI is not
  * sending or receiving PCM data in a frame. This can be used to save power.
  */
 #define SND_SOC_DAIFMT_CONT		(0 << 4) /* continuous clock */
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 8cfbff7..be99fc7 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1003,7 +1003,7 @@ static int snd_es18xx_info_mux(struct snd_kcontrol *kcontrol, struct snd_ctl_ele
 			uinfo->value.enumerated.item = 4;
 		strcpy(uinfo->value.enumerated.name, texts5Source[uinfo->value.enumerated.item]);
 		break;
-	case 0x1869: /* DS somewhat contradictory for 1869: could be be 5 or 8 */
+	case 0x1869: /* DS somewhat contradictory for 1869: could be 5 or 8 */
 	case 0x1879:
 		uinfo->value.enumerated.items = 8;
 		if (uinfo->value.enumerated.item > 7)
-- 
1.6.0.6



