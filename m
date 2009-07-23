Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZGWOfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZGWOfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZGWOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:35:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZGWOfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:35:32 -0400
Date: Thu, 23 Jul 2009 16:35:27 +0200
From: John Kacur <jkacur@redhat.com>
To: linux-kernel@vger.kernel.org, jcm@redhat.com
Cc: linux-rt-users@vger.kernel.org, williams@redhat.com
Subject: [PATCH] A little spellchecking of the hwlat_detector.c file
Message-ID: <20090723143527.GA4521@tycho.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 9f51d93ba6d35f048fae1e7b902d1ca99e7a172c Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Thu, 23 Jul 2009 16:05:39 +0200
Subject: [PATCH] A little spellchecking of the hwlat_detector.c file.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/misc/hwlat_detector.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index 9059b5d..575a8b5 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -159,7 +159,7 @@ static struct data {
 
 	atomic_t sample_open;		/* whether the sample file is open */
 
-	wait_queue_head_t wq;		/* waitqeue for new sample values */
+	wait_queue_head_t wq;		/* waitqueue for new sample values */
 
 } data;
 
@@ -270,13 +270,13 @@ out:
  * @unused: A required part of the kthread API.
  *
  * Used to periodically sample the CPU TSC via a call to get_sample. We
- * use stop_machine, whith does (intentionally) introduce latency since we
+ * use stop_machine, which does (intentionally) introduce latency since we
  * need to ensure nothing else might be running (and thus pre-empting).
  * Obviously this should never be used in production environments.
  *
  * stop_machine will schedule us typically only on CPU0 which is fine for
  * almost every real-world hardware latency situation - but we might later
- * generalize this if we find there are any actualy systems with alternate
+ * generalize this if we find there are any actual systems with alternate
  * SMI delivery or other non CPU0 hardware latencies.
  */
 static int kthread_fn(void *unused)
@@ -332,7 +332,7 @@ static int start_kthread(void)
 }
 
 /**
- * stop_kthread - Inform the hardware latency samping/detector kthread to stop
+ * stop_kthread - Inform the hardware latency sampling/detector kthread to stop
  *
  * This kicks the running hardware latency sampling/detector kernel thread and
  * tells it to stop sampling now. Use this on unload and at system shutdown.
@@ -752,7 +752,7 @@ out:
 
 /**
  * debug_sample_release - Release function for "sample" debugfs interface
- * @inode: The in-kernel inode represenation of the debugfs "file"
+ * @inode: The in-kernel inode representation of the debugfs "file"
  * @filp: The active open file structure for the debugfs "file"
  *
  * This function completes the close of the debugfs interface "sample" file.
@@ -846,7 +846,7 @@ static int debug_width_fopen(struct inode *inode, struct file *filp)
  * This function provides a read implementation for the "width" debugfs
  * interface to the hardware latency detector. It can be used to determine
  * for how many us of the total window us we will actively sample for any
- * hardware-induced latecy periods. Obviously, it is not possible to
+ * hardware-induced latency periods. Obviously, it is not possible to
  * sample constantly and have the system respond to a sample reader, or,
  * worse, without having the system appear to have gone out to lunch.
  */
@@ -947,12 +947,12 @@ static ssize_t debug_window_fread(struct file *filp, char __user *ubuf,
  * @cnt: The maximum number of bytes to write to "file"
  * @ppos: The current position in the debugfs "file"
  *
- * This function provides a write implementation for the "window" debufds
- * interface to the hardware latency detetector. The window is the total time
+ * This function provides a write implementation for the "window" debugfs
+ * interface to the hardware latency detector. The window is the total time
  * in us that will be considered one sample period. Conceptually, windows
  * occur back-to-back and contain a sample width period during which
  * actual sampling occurs. Can be used to write a new total window size. It
- * is enfoced that any value written must be greater than the sample width
+ * is enforced that any value written must be greater than the sample width
  * size, or an error results.
  */
 static ssize_t  debug_window_fwrite(struct file *filp,
@@ -1062,7 +1062,7 @@ static const struct file_operations window_fops = {
  * This function creates entries in debugfs for "hwlat_detector", including
  * files to read values from the detector, current samples, and the
  * maximum sample that has been captured since the hardware latency
- * dectector was started.
+ * detector was started.
  */
 static int init_debugfs(void)
 {
-- 
1.6.0.6

