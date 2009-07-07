Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbZGGOjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbZGGOjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbZGGOhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:37:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:43371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743AbZGGOhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:37:07 -0400
Subject: [PATCH 21/22] trivial: fix typo "with with" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:56:20 +0530
Message-Id: <1246976780.3613.38.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "with with" with "with" in multiple files ;-)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/fb/viafb.txt              |    2 +-
 Documentation/sysfs-rules.txt           |    2 +-
 drivers/media/dvb/ttpci/av7110.c        |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c     |    2 +-
 drivers/staging/android/binder.c        |    2 +-
 include/linux/usb/gadget.h              |    2 +-
 kernel/perf_counter.c                   |    2 +-
 net/atm/lec.c                           |    2 +-
 scripts/namespace.pl                    |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/fb/viafb.txt b/Documentation/fb/viafb.txt
index 67dbf44..de3bc87 100644
--- a/Documentation/fb/viafb.txt
+++ b/Documentation/fb/viafb.txt
@@ -32,7 +32,7 @@
     Start viafb with default settings:
         #modprobe viafb
 
-    Start viafb with with user options:
+    Start viafb with user options:
         #modprobe viafb viafb_mode=800x600 viafb_bpp=16 viafb_refresh=60
                   viafb_active_dev=CRT+DVI viafb_dvi_port=DVP1
                   viafb_mode1=1024x768 viafb_bpp=16 viafb_refresh1=60
diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index 5d8bc2c..aefd8fa 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -47,7 +47,7 @@ versions of the sysfs interface.
         at device creation and removal
       - the unique key to the device at that point in time
       - the kernel's path to the device directory without the leading
-        /sys, and always starting with with a slash
+        /sys, and always starting with a slash
       - all elements of a devpath must be real directories. Symlinks
         pointing to /sys/devices must always be resolved to their real
         target and the target path must be used to access the device.
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index d1d959e..926aee0 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2372,7 +2372,7 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 		budgetpatch = 0;
 		/* autodetect the presence of budget patch
 		 * this only works if saa7146 has been recently
-		 * reset with with MASK_31 to MC1
+		 * reset with MASK_31 to MC1
 		 *
 		 * will wait for VBI_B event (vertical blank at port B)
 		 * and will reset GPIO3 after VBI_B is detected.
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index ccd47f5..f30dc20 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -361,7 +361,7 @@ static int hdpvr_open(struct file *file)
 
 	dev = (struct hdpvr_device *)video_get_drvdata(video_devdata(file));
 	if (!dev) {
-		v4l2_err(&dev->v4l2_dev, "open failing with with ENODEV\n");
+		v4l2_err(&dev->v4l2_dev, "open failing with ENODEV\n");
 		retval = -ENODEV;
 		goto err;
 	}
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 905577f..c3c2bb3 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3609,7 +3609,7 @@ static void sym_sir_task_recovery(struct sym_hcb *np, int num)
 }
 
 /*
- *  Gerard's alchemy:) that deals with with the data 
+ *  Gerard's alchemy:) that deals with the data 
  *  pointer for both MDP and the residual calculation.
  *
  *  I didn't want to bloat the code by more than 200 
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 17d89a8..67bf227 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -820,7 +820,7 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 	if (free_page_start || free_page_end) {
 		if (binder_debug_mask & BINDER_DEBUG_BUFFER_ALLOC)
 			printk(KERN_INFO "binder: %d: merge free, buffer %p do "
-			       "not share page%s%s with with %p or %p\n",
+			       "not share page%s%s with %p or %p\n",
 			       proc->pid, buffer, free_page_start ? "" : " end",
 			       free_page_end ? "" : " start", prev, next);
 		binder_update_page_range(proc, 0, free_page_start ?
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index bbf45d5..de63729 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -195,7 +195,7 @@ static inline int usb_ep_disable(struct usb_ep *ep)
 
 /**
  * usb_ep_alloc_request - allocate a request object to use with this endpoint
- * @ep:the endpoint to be used with with the request
+ * @ep:the endpoint to be used with the request
  * @gfp_flags:GFP_* flags to use
  *
  * Request objects must be allocated with this call, since they normally
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a641eb7..4528a47 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -148,7 +148,7 @@ static void put_ctx(struct perf_counter_context *ctx)
 
 /*
  * Get the perf_counter_context for a task and lock it.
- * This has to cope with with the fact that until it is locked,
+ * This has to cope with the fact that until it is locked,
  * the context could get moved to another task.
  */
 static struct perf_counter_context *
diff --git a/net/atm/lec.c b/net/atm/lec.c
index ff2e594..5132947 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1241,7 +1241,7 @@ module_exit(lane_module_cleanup);
 /*
  * LANE2: 3.1.3, LE_RESOLVE.request
  * Non force allocates memory and fills in *tlvs, fills in *sizeoftlvs.
- * If sizeoftlvs == NULL the default TLVs associated with with this
+ * If sizeoftlvs == NULL the default TLVs associated with this
  * lec will be used.
  * If dst_mac == NULL, targetless LE_ARP will be sent
  */
diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index c6e88c6..8aaf2b8 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -58,7 +58,7 @@
 #	  for no good reason, which is frustrating for embedded systems.
 #	* Wrap config sensitive symbols in #ifdef CONFIG_foo, as long as the
 #	  code does not get too ugly.
-#	* Repeat the name space analysis until you can live with with the
+#	* Repeat the name space analysis until you can live with the
 #	  result.
 #
 
-- 
1.6.0.6



