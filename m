Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZGGJzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZGGJzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZGGJz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:55:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52855 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZGGJz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:55:28 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "trivial@kernel.org" <trivial@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jul 2009 15:24:23 +0530
Subject: [PATCH v2 1/2] trivial: fix typo "for for" in multiple files
Thread-Topic: [PATCH v2 1/2] trivial: fix typo "for for" in multiple files
Thread-Index: Acn+6OfqL8yiQLRkQsWxg764hOizkg==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11451@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Gadiyar <gadiyar@ti.com>

trivial: fix typo "for for" in multiple files

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
---
- Previous version was at [1] and [2]
  - Now folded together
- Rebased on current mainline git

[1] http://patchwork.kernel.org/patch/34236/
[2] http://patchwork.kernel.org/patch/34237/

 Documentation/filesystems/nfsroot.txt            |    2 +-
 Documentation/powerpc/dts-bindings/marvell.txt   |    2 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h |    2 +-
 arch/powerpc/kernel/udbg_16550.c                 |    2 +-
 arch/powerpc/platforms/powermac/udbg_scc.c       |    2 +-
 drivers/edac/edac_core.h                         |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c      |    2 +-
 drivers/isdn/i4l/isdn_common.c                   |    4 ++--
 drivers/md/md.h                                  |    2 +-
 drivers/net/bnx2x_reg.h                          |    2 +-
 drivers/net/rionet.c                             |    2 +-
 drivers/usb/host/ehci-pci.c                      |    2 +-
 drivers/usb/host/ehci.h                          |    2 +-
 fs/xfs/xfs_fs.h                                  |    2 +-
 include/linux/usb.h                              |    2 +-
 15 files changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/usb/host/ehci-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-pci.c
+++ linux-2.6/drivers/usb/host/ehci-pci.c
@@ -242,7 +242,7 @@ static int ehci_pci_setup(struct usb_hcd
 	 * System suspend currently expects to be able to suspend the entire
 	 * device tree, device-at-a-time.  If we failed selective suspend
 	 * reports, system suspend would fail; so the root hub code must claim
-	 * success.  That's lying to usbcore, and it matters for for runtime
+	 * success.  That's lying to usbcore, and it matters for runtime
 	 * PM scenarios with selective suspend and remote wakeup...
 	 */
 	if (ehci->no_selective_suspend && device_can_wakeup(&pdev->dev))
Index: linux-2.6/drivers/usb/host/ehci.h
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci.h
+++ linux-2.6/drivers/usb/host/ehci.h
@@ -37,7 +37,7 @@ typedef __u16 __bitwise __hc16;
 #define __hc16	__le16
 #endif
 
-/* statistics can be kept for for tuning/monitoring */
+/* statistics can be kept for tuning/monitoring */
 struct ehci_stats {
 	/* irq usage */
 	unsigned long		normal;
Index: linux-2.6/Documentation/filesystems/nfsroot.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/nfsroot.txt
+++ linux-2.6/Documentation/filesystems/nfsroot.txt
@@ -105,7 +105,7 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netm
 		the client address and this parameter is NOT empty only
 		replies from the specified server are accepted.
 
-		Only required for for NFS root. That is autoconfiguration
+		Only required for NFS root. That is autoconfiguration
 		will not be triggered if it is missing and NFS root is not
 		in operation.
 
Index: linux-2.6/Documentation/powerpc/dts-bindings/marvell.txt
===================================================================
--- linux-2.6.orig/Documentation/powerpc/dts-bindings/marvell.txt
+++ linux-2.6/Documentation/powerpc/dts-bindings/marvell.txt
@@ -32,7 +32,7 @@ prefixed with the string "marvell,", for
       devices.  This field represents the number of cells needed to
       represent the address of the memory-mapped registers of devices
       within the system controller chip.
-    - #size-cells : Size representation for for the memory-mapped
+    - #size-cells : Size representation for the memory-mapped
       registers within the system controller chip.
     - #interrupt-cells : Defines the width of cells used to represent
       interrupts.
Index: linux-2.6/arch/blackfin/mach-bf538/include/mach/defBF539.h
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf538/include/mach/defBF539.h
+++ linux-2.6/arch/blackfin/mach-bf538/include/mach/defBF539.h
@@ -2325,7 +2325,7 @@
 #define	AMBEN_B0_B1	0x0004	/* Enable Asynchronous Memory Banks 0 &	1 only */
 #define	AMBEN_B0_B1_B2	0x0006	/* Enable Asynchronous Memory Banks 0, 1, and 2 */
 #define	AMBEN_ALL	0x0008	/* Enable Asynchronous Memory Banks (all) 0, 1,	2, and 3 */
-#define	CDPRIO		0x0100	/* DMA has priority over core for for external accesses */
+#define	CDPRIO		0x0100	/* DMA has priority over core for external accesses */
 
 /* EBIU_AMGCTL Bit Positions */
 #define	AMCKEN_P		0x0000	/* Enable CLKOUT */
Index: linux-2.6/arch/powerpc/kernel/udbg_16550.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/udbg_16550.c
+++ linux-2.6/arch/powerpc/kernel/udbg_16550.c
@@ -1,5 +1,5 @@
 /*
- * udbg for for NS16550 compatable serial ports
+ * udbg for NS16550 compatable serial ports
  *
  * Copyright (C) 2001-2005 PPC 64 Team, IBM Corp
  *
Index: linux-2.6/arch/powerpc/platforms/powermac/udbg_scc.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/udbg_scc.c
+++ linux-2.6/arch/powerpc/platforms/powermac/udbg_scc.c
@@ -1,5 +1,5 @@
 /*
- * udbg for for zilog scc ports as found on Apple PowerMacs
+ * udbg for zilog scc ports as found on Apple PowerMacs
  *
  * Copyright (C) 2001-2005 PPC 64 Team, IBM Corp
  *
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_iba6110.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -809,7 +809,7 @@ static int ipath_setup_ht_reset(struct i
  * errors.  We only bother to do this at load time, because it's OK if
  * it happened before we were loaded (first time after boot/reset),
  * but any time after that, it's fatal anyway.  Also need to not check
- * for for upper byte errors if we are in 8 bit mode, so figure out
+ * for upper byte errors if we are in 8 bit mode, so figure out
  * our width.  For now, at least, also complain if it's 8 bit.
  */
 static void slave_or_pri_blk(struct ipath_devdata *dd, struct pci_dev *pdev,
Index: linux-2.6/drivers/isdn/i4l/isdn_common.c
===================================================================
--- linux-2.6.orig/drivers/isdn/i4l/isdn_common.c
+++ linux-2.6/drivers/isdn/i4l/isdn_common.c
@@ -761,7 +761,7 @@ isdn_getnum(char **p)
  * Be aware that this is not an atomic operation when sleep != 0, even though 
  * interrupts are turned off! Well, like that we are currently only called
  * on behalf of a read system call on raw device files (which are documented
- * to be dangerous and for for debugging purpose only). The inode semaphore
+ * to be dangerous and for debugging purpose only). The inode semaphore
  * takes care that this is not called for the same minor device number while
  * we are sleeping, but access is not serialized against simultaneous read()
  * from the corresponding ttyI device. Can other ugly events, like changes
@@ -873,7 +873,7 @@ isdn_readbchan(int di, int channel, u_ch
  * Be aware that this is not an atomic operation when sleep != 0, even though
  * interrupts are turned off! Well, like that we are currently only called
  * on behalf of a read system call on raw device files (which are documented
- * to be dangerous and for for debugging purpose only). The inode semaphore
+ * to be dangerous and for debugging purpose only). The inode semaphore
  * takes care that this is not called for the same minor device number while
  * we are sleeping, but access is not serialized against simultaneous read()
  * from the corresponding ttyI device. Can other ugly events, like changes
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -201,7 +201,7 @@ struct mddev_s
 	 * INTR:     resync needs to be aborted for some reason
 	 * DONE:     thread is done and is waiting to be reaped
 	 * REQUEST:  user-space has requested a sync (used with SYNC)
-	 * CHECK:    user-space request for for check-only, no repair
+	 * CHECK:    user-space request for check-only, no repair
 	 * RESHAPE:  A reshape is happening
 	 *
 	 * If neither SYNC or RESHAPE are set, then it is a recovery.
Index: linux-2.6/drivers/net/bnx2x_reg.h
===================================================================
--- linux-2.6.orig/drivers/net/bnx2x_reg.h
+++ linux-2.6/drivers/net/bnx2x_reg.h
@@ -3788,7 +3788,7 @@
    The fields are:[4:0] - tail pointer; [10:5] - Link List size; 15:11] -
    header pointer. */
 #define TCM_REG_XX_TABLE					 0x50240
-/* [RW 4] Load value for for cfc ac credit cnt. */
+/* [RW 4] Load value for cfc ac credit cnt. */
 #define TM_REG_CFC_AC_CRDCNT_VAL				 0x164208
 /* [RW 4] Load value for cfc cld credit cnt. */
 #define TM_REG_CFC_CLD_CRDCNT_VAL				 0x164210
Index: linux-2.6/drivers/net/rionet.c
===================================================================
--- linux-2.6.orig/drivers/net/rionet.c
+++ linux-2.6/drivers/net/rionet.c
@@ -72,7 +72,7 @@ static int rionet_check = 0;
 static int rionet_capable = 1;
 
 /*
- * This is a fast lookup table for for translating TX
+ * This is a fast lookup table for translating TX
  * Ethernet packets into a destination RIO device. It
  * could be made into a hash table to save memory depending
  * on system trade-offs.
Index: linux-2.6/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fs.h
+++ linux-2.6/fs/xfs/xfs_fs.h
@@ -117,7 +117,7 @@ struct getbmapx {
 #define BMV_IF_VALID	\
 	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
 
-/*	bmv_oflags values - returned for for each non-header segment */
+/*	bmv_oflags values - returned for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
 #define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
 #define BMV_OF_LAST		0x4	/* segment is the last in the file */
Index: linux-2.6/include/linux/usb.h
===================================================================
--- linux-2.6.orig/include/linux/usb.h
+++ linux-2.6/include/linux/usb.h
@@ -1069,7 +1069,7 @@ typedef void (*usb_complete_t)(struct ur
  * @start_frame: Returns the initial frame for isochronous transfers.
  * @number_of_packets: Lists the number of ISO transfer buffers.
  * @interval: Specifies the polling interval for interrupt or isochronous
- *	transfers.  The units are frames (milliseconds) for for full and low
+ *	transfers.  The units are frames (milliseconds) for full and low
  *	speed devices, and microframes (1/8 millisecond) for highspeed ones.
  * @error_count: Returns the number of ISO transfers that reported errors.
  * @context: For use in completion functions.  This normally points to
Index: linux-2.6/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.orig/drivers/edac/edac_core.h
+++ linux-2.6/drivers/edac/edac_core.h
@@ -286,7 +286,7 @@ enum scrub_type {
  *			is irrespective of the memory devices being mounted
  *			on both sides of the memory stick.
  *
- * Socket set:		All of the memory sticks that are required for for
+ * Socket set:		All of the memory sticks that are required for
  *			a single memory access or all of the memory sticks
  *			spanned by a chip-select row.  A single socket set
  *			has two chip-select rows and if double-sided sticks
