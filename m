Return-Path: <linux-kernel-owner+w=401wt.eu-S936528AbXLQT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936528AbXLQT7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934080AbXLQTlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:39 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3210 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837AbXLQTlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Dan Williams <dan.j.williams@intel.com>,
       Len Brown <len.brown@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Shannon Nelson <shannon.nelson@intel.com>,
       linux-fsdevel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [PATCH] include/linux/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:24 -0800
Message-Id: <1197920439-5455-18-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/chio.h            |    2 +-
 include/linux/cyclades.h        |    2 +-
 include/linux/cycx_x25.h        |    2 +-
 include/linux/dmaengine.h       |    2 +-
 include/linux/ethtool.h         |    2 +-
 include/linux/fs.h              |    2 +-
 include/linux/hdreg.h           |    2 +-
 include/linux/llc.h             |    4 ++--
 include/linux/pm.h              |    2 +-
 include/linux/pnp.h             |    2 +-
 include/linux/reiserfs_fs_sb.h  |    2 +-
 include/linux/sm501-regs.h      |    2 +-
 include/linux/spinlock_api_up.h |    2 +-
 include/linux/wireless.h        |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/chio.h b/include/linux/chio.h
index a404c11..519248d 100644
--- a/include/linux/chio.h
+++ b/include/linux/chio.h
@@ -108,7 +108,7 @@ struct changer_element_status {
 
 /*
  * CHIOGELEM
- *    get more detailed status informtion for a single element
+ *    get more detailed status information for a single element
  */
 struct changer_get_element {
 	int	cge_type;	 /* type/unit */
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index 8f3dcd3..504cb2c 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -177,7 +177,7 @@ struct	CUSTOM_REG {
 	__u32	fpga_version;		/* FPGA Version Number Register */
 	__u32	cpu_start;		/* CPU start Register (write) */
 	__u32	cpu_stop;		/* CPU stop Register (write) */
-	__u32	misc_reg;		/* Miscelaneous Register */
+	__u32	misc_reg;		/* Miscellaneous Register */
 	__u32	idt_mode;		/* IDT mode Register */
 	__u32	uart_irq_status;	/* UART IRQ status Register */
 	__u32	clear_timer0_irq;	/* Clear timer interrupt Register */
diff --git a/include/linux/cycx_x25.h b/include/linux/cycx_x25.h
index f7a9065..362bf19 100644
--- a/include/linux/cycx_x25.h
+++ b/include/linux/cycx_x25.h
@@ -81,7 +81,7 @@ struct cycx_x25_cmd {
  *	@n2win - level 2 window (values: 1 thru 7)
  *	@n3win - level 3 window (values: 1 thru 7)
  *	@nvc - # of logical channels (values: 1 thru 64)
- *	@pktlen - level 3 packet lenght - log base 2 of size
+ *	@pktlen - level 3 packet length - log base 2 of size
  *	@locaddr - my address
  *	@remaddr - remote address
  *	@t1 - time, in seconds
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index a3b6035..608a731 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -29,7 +29,7 @@
 #include <linux/dma-mapping.h>
 
 /**
- * enum dma_state - resource PNP/power managment state
+ * enum dma_state - resource PNP/power management state
  * @DMA_RESOURCE_SUSPEND: DMA device going into low power state
  * @DMA_RESOURCE_RESUME: DMA device returning to full power
  * @DMA_RESOURCE_AVAILABLE: DMA device available to the system
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 71d4ada..fcbe8b6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -309,7 +309,7 @@ int ethtool_op_set_flags(struct net_device *dev, u32 data);
  * get_ringparam: Report ring sizes
  * set_ringparam: Set ring sizes
  * get_pauseparam: Report pause parameters
- * set_pauseparam: Set pause paramters
+ * set_pauseparam: Set pause parameters
  * get_rx_csum: Report whether receive checksums are turned on or off
  * set_rx_csum: Turn receive checksum on or off
  * get_tx_csum: Report whether transmit checksums are turned on or off
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..d8e2ebb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1305,7 +1305,7 @@ struct super_operations {
  *			being set.  find_inode() uses this to prevent returning
  *			nearly-dead inodes.
  * I_SYNC		Similar to I_LOCK, but limited in scope to writeback
- *			of inode dirty data.  Having a seperate lock for this
+ *			of inode dirty data.  Having a separate lock for this
  *			purpose reduces latency and prevents some filesystem-
  *			specific deadlocks.
  *
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index 818c6af..88d753f 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -358,7 +358,7 @@ typedef struct hd_drive_hob_hdr {
 #define SETFEATURES_EN_RLA	0xAA	/* Enable read look-ahead feature */
 #define SETFEATURES_PREFETCH	0xAB	/* Sets drive prefetch value */
 #define SETFEATURES_EN_REST	0xAC	/* ATA-1 */
-#define SETFEATURES_4B_RW_LONG	0xBB	/* Set Lenght of 4 bytes */
+#define SETFEATURES_4B_RW_LONG	0xBB	/* Set Length of 4 bytes */
 #define SETFEATURES_DIS_AAM	0xC2	/* Disable Automatic Acoustic Management */
 #define SETFEATURES_EN_RPOD	0xCC	/* Enable reverting to power on defaults */
 #define SETFEATURES_DIS_RI	0xDD	/* Disable release interrupt ATAPI */
diff --git a/include/linux/llc.h b/include/linux/llc.h
index 09f2e6d..7733585 100644
--- a/include/linux/llc.h
+++ b/include/linux/llc.h
@@ -49,9 +49,9 @@ enum llc_sockopts {
 
 /* LLC SAP types. */
 #define LLC_SAP_NULL	0x00		/* NULL SAP. 			*/
-#define LLC_SAP_LLC	0x02		/* LLC Sublayer Managment. 	*/
+#define LLC_SAP_LLC	0x02		/* LLC Sublayer Management. 	*/
 #define LLC_SAP_SNA	0x04		/* SNA Path Control. 		*/
-#define LLC_SAP_PNM	0x0E		/* Proway Network Managment.	*/	
+#define LLC_SAP_PNM	0x0E		/* Proway Network Management.	*/	
 #define LLC_SAP_IP	0x06		/* TCP/IP. 			*/
 #define LLC_SAP_BSPAN	0x42		/* Bridge Spanning Tree Proto	*/
 #define LLC_SAP_MMS	0x4E		/* Manufacturing Message Srv.	*/
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 09a309b..2dbba10 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -95,7 +95,7 @@ struct pm_dev
 };
 
 /* Functions above this comment are list-based old-style power
- * managment. Please avoid using them.  */
+ * management. Please avoid using them.  */
 
 /*
  * Callbacks for platform drivers to implement.
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 0a0426c..3c648a0 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -126,7 +126,7 @@ struct pnp_resource_table {
 };
 
 /*
- * Device Managemnt
+ * Device Management
  */
 
 struct pnp_card {
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 10fa0c8..db5ef9b 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -185,7 +185,7 @@ struct reiserfs_journal {
 	unsigned long j_trans_id;
 	unsigned long j_mount_id;
 	unsigned long j_start;	/* start of current waiting commit (index into j_ap_blocks) */
-	unsigned long j_len;	/* lenght of current waiting commit */
+	unsigned long j_len;	/* length of current waiting commit */
 	unsigned long j_len_alloc;	/* number of buffers requested by journal_begin() */
 	atomic_t j_wcount;	/* count of writers for current commit */
 	unsigned long j_bcount;	/* batch count. allows turning X transactions into 1 */
diff --git a/include/linux/sm501-regs.h b/include/linux/sm501-regs.h
index df7620d..64236b7 100644
--- a/include/linux/sm501-regs.h
+++ b/include/linux/sm501-regs.h
@@ -171,7 +171,7 @@
 /* USB slave/gadget data port base */
 #define SM501_USB_GADGET_DATA		(0x070000)
 
-/* Display contoller/video engine base */
+/* Display controller/video engine base */
 #define SM501_DC			(0x080000)
 
 /* common defines for the SM501 address registers */
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index 67faa04..04e1d31 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -21,7 +21,7 @@
 /*
  * In the UP-nondebug case there's no real locking going on, so the
  * only thing we have to do is to keep the preempt counts and irq
- * flags straight, to supress compiler warnings of unused lock
+ * flags straight, to suppress compiler warnings of unused lock
  * variables, and to add the proper checker annotations:
  */
 #define __LOCK(lock) \
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 0987aa7..f1bb36a 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -1066,7 +1066,7 @@ struct	iw_priv_args
  */
 struct iw_event
 {
-	__u16		len;			/* Real lenght of this stuff */
+	__u16		len;			/* Real length of this stuff */
 	__u16		cmd;			/* Wireless IOCTL */
 	union iwreq_data	u;		/* IOCTL fixed payload */
 };
-- 
1.5.3.7.949.g2221a6

