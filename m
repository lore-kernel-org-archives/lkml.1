Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZGGOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZGGOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbZGGOdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:33:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbZGGOdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:33:04 -0400
Subject: [PATCH 1/22] trivial: fix typo "a a" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:35:27 +0530
Message-Id: <1246975527.3613.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced "a a" with "a" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    2 +-
 drivers/mtd/ubi/vmt.c                     |    4 ++--
 drivers/net/fs_enet/fs_enet.h             |    2 +-
 drivers/net/s2io.c                        |    2 +-
 drivers/net/sky2.c                        |    2 +-
 drivers/net/wireless/libertas/scan.c      |    2 +-
 drivers/video/riva/fbdev.c                |    2 +-
 include/linux/exportfs.h                  |    2 +-
 include/linux/wimax/debug.h               |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c          |    2 +-
 net/netfilter/nf_conntrack_pptp.c         |    2 +-
 net/sctp/sm_make_chunk.c                  |    2 +-
 net/sunrpc/svcsock.c                      |    2 +-
 scripts/Kbuild.include                    |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index cbc3887..e6cf09f 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -5068,7 +5068,7 @@ void pvr2_hdw_status_poll(struct pvr2_hdw *hdw)
 	/* Note: There apparently is no replacement for VIDIOC_CROPCAP
 	   using v4l2-subdev - therefore we can't support that AT ALL right
 	   now.  (Of course, no sub-drivers seem to implement it either.
-	   But now it's a a chicken and egg problem...) */
+	   But now it's a chicken and egg problem...) */
 	v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, g_tuner,
 			     &hdw->tuner_signal_info);
 	pvr2_trace(PVR2_TRACE_CHIPS, "subdev status poll"
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index ab64cb5..f409a7e 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -711,7 +711,7 @@ void ubi_free_volume(struct ubi_device *ubi, struct ubi_volume *vol)
  * @ubi: UBI device description object
  * @vol_id: volume ID
  *
- * Returns zero if volume is all right and a a negative error code if not.
+ * Returns zero if volume is all right and a negative error code if not.
  */
 static int paranoid_check_volume(struct ubi_device *ubi, int vol_id)
 {
@@ -863,7 +863,7 @@ fail:
  * paranoid_check_volumes - check information about all volumes.
  * @ubi: UBI device description object
  *
- * Returns zero if volumes are all right and a a negative error code if not.
+ * Returns zero if volumes are all right and a negative error code if not.
  */
 static int paranoid_check_volumes(struct ubi_device *ubi)
 {
diff --git a/drivers/net/fs_enet/fs_enet.h b/drivers/net/fs_enet/fs_enet.h
index ef01e09..8034d7b 100644
--- a/drivers/net/fs_enet/fs_enet.h
+++ b/drivers/net/fs_enet/fs_enet.h
@@ -157,7 +157,7 @@ void fs_enet_platform_cleanup(void);
 
 /* access macros */
 #if defined(CONFIG_CPM1)
-/* for a a CPM1 __raw_xxx's are sufficient */
+/* for a CPM1 __raw_xxx's are sufficient */
 #define __cbd_out32(addr, x)	__raw_writel(x, addr)
 #define __cbd_out16(addr, x)	__raw_writew(x, addr)
 #define __cbd_in32(addr)	__raw_readl(addr)
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 458daa0..aeacc74 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3897,7 +3897,7 @@ static irqreturn_t s2io_test_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Test interrupt path by forcing a a software IRQ */
+/* Test interrupt path by forcing a software IRQ */
 static int s2io_test_msi(struct s2io_nic *sp)
 {
 	struct pci_dev *pdev = sp->pdev;
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index daf961a..aba800c 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -4342,7 +4342,7 @@ static irqreturn_t __devinit sky2_test_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Test interrupt path by forcing a a software IRQ */
+/* Test interrupt path by forcing a software IRQ */
 static int __devinit sky2_test_msi(struct sky2_hw *hw)
 {
 	struct pci_dev *pdev = hw->pdev;
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 601b542..d0e2615 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -502,7 +502,7 @@ void lbs_scan_worker(struct work_struct *work)
 /**
  *  @brief Interpret a BSS scan response returned from the firmware
  *
- *  Parse the various fixed fields and IEs passed back for a a BSS probe
+ *  Parse the various fixed fields and IEs passed back for a BSS probe
  *  response or beacon from the scan command.  Record information as needed
  *  in the scan table struct bss_descriptor for that entry.
  *
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index d94c57f..e4879cc 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -1494,7 +1494,7 @@ static inline void convert_bgcolor_16(u32 *col)
  * @image: pointer to fb_image structure
  *
  * DESCRIPTION:
- * If the source is a monochrome bitmap, the function fills up a a region
+ * If the source is a monochrome bitmap, the function fills up a region
  * of framebuffer memory with pixels whose color is determined by the bit
  * setting of the bitmap, 1 - foreground, 0 - background.
  *
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 27e772c..82db618 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -128,7 +128,7 @@ struct fid {
  * get_name:
  *    @get_name should find a name for the given @child in the given @parent
  *    directory.  The name should be stored in the @name (with the
- *    understanding that it is already pointing to a a %NAME_MAX+1 sized
+ *    understanding that it is already pointing to a %NAME_MAX+1 sized
  *    buffer.   get_name() should return %0 on success, a negative error code
  *    or error.  @get_name will be called without @parent->i_mutex held.
  *
diff --git a/include/linux/wimax/debug.h b/include/linux/wimax/debug.h
index c703e03..999e3c8 100644
--- a/include/linux/wimax/debug.h
+++ b/include/linux/wimax/debug.h
@@ -207,7 +207,7 @@ do {									\
 
 /*
  * CPP sintatic sugar to generate A_B like symbol names when one of
- * the arguments is a a preprocessor #define.
+ * the arguments is a preprocessor #define.
  */
 #define __D_PASTE__(varname, modulename) varname##_##modulename
 #define __D_PASTE(varname, modulename) (__D_PASTE__(varname, modulename))
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 9eb1710..371ff2e 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -2,7 +2,7 @@
  * nf_nat_pptp.c
  *
  * NAT support for PPTP (Point to Point Tunneling Protocol).
- * PPTP is a a protocol for creating virtual private networks.
+ * PPTP is a protocol for creating virtual private networks.
  * It is a specification defined by Microsoft and some vendors
  * working with Microsoft.  PPTP is built on top of a modified
  * version of the Internet Generic Routing Encapsulation Protocol.
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 3807ac7..dabbc19 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -1,6 +1,6 @@
 /*
  * Connection tracking support for PPTP (Point to Point Tunneling Protocol).
- * PPTP is a a protocol for creating virtual private networks.
+ * PPTP is a protocol for creating virtual private networks.
  * It is a specification defined by Microsoft and some vendors
  * working with Microsoft.  PPTP is built on top of a modified
  * version of the Internet Generic Routing Encapsulation Protocol.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 61cc607..de69e3f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2202,7 +2202,7 @@ int sctp_process_init(struct sctp_association *asoc, sctp_cid_t cid,
 
 	/* This implementation defaults to making the first transport
 	 * added as the primary transport.  The source address seems to
-	 * be a a better choice than any of the embedded addresses.
+	 * be a better choice than any of the embedded addresses.
 	 */
 	if (peer_addr) {
 		if(!sctp_assoc_add_peer(asoc, peer_addr, gfp, SCTP_ACTIVE))
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 23128ee..91e5c92 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -853,7 +853,7 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 		 *
 		 * rcvbuf just needs to be able to hold a few requests.
 		 * Normally they will be removed from the queue
-		 * as soon a a complete request arrives.
+		 * as soon as a complete request arrives.
 		 */
 		svc_sock_setbufsize(svsk->sk_sock,
 				    (serv->sv_nrthreads+3) * serv->sv_max_mesg,
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index c29be8f..cc45112 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -210,7 +210,7 @@ if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
 	$(rule_$(1)))
 
 ###
-# why - tell why a a target got build
+# why - tell why a target got build
 #       enabled by make V=2
 #       Output (listed in the order they are checked):
 #          (1) - due to target is PHONY
-- 
1.6.0.6



