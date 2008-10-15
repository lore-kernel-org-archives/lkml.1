Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYJOVEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYJOVEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYJOVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:03:05 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34337 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYJOVC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:59 -0400
X-BigFish: VPS1(zzzzzzz32i)
X-WSS-ID: 0K8ST4B-01-4GF-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/8] oprofile: whitespace fixes
Date: Wed, 15 Oct 2008 22:09:06 +0200
Message-ID: <1224101350-12877-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0878 (UTC) FILETIME=[5B3E23E0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   20 ++++++++++----------
 arch/x86/oprofile/op_model_p4.c   |   32 ++++++++++++++++----------------
 arch/x86/oprofile/op_model_ppro.c |   16 ++++++++--------
 drivers/oprofile/buffer_sync.c    |    1 -
 drivers/oprofile/oprof.c          |   24 ++++++++++++------------
 5 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 23ce63f..b9a810b 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -530,14 +530,14 @@ static void op_amd_exit(void)
 #endif
 
 struct op_x86_model_spec const op_amd_spec = {
-	.init = op_amd_init,
-	.exit = op_amd_exit,
-	.num_counters = NUM_COUNTERS,
-	.num_controls = NUM_CONTROLS,
-	.fill_in_addresses = &op_amd_fill_in_addresses,
-	.setup_ctrs = &op_amd_setup_ctrs,
-	.check_ctrs = &op_amd_check_ctrs,
-	.start = &op_amd_start,
-	.stop = &op_amd_stop,
-	.shutdown = &op_amd_shutdown
+	.init			= op_amd_init,
+	.exit			= op_amd_exit,
+	.num_counters		= NUM_COUNTERS,
+	.num_controls		= NUM_CONTROLS,
+	.fill_in_addresses	= &op_amd_fill_in_addresses,
+	.setup_ctrs		= &op_amd_setup_ctrs,
+	.check_ctrs		= &op_amd_check_ctrs,
+	.start			= &op_amd_start,
+	.stop			= &op_amd_stop,
+	.shutdown		= &op_amd_shutdown
 };
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 43ac5af..4c4a51c 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -698,24 +698,24 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 
 #ifdef CONFIG_SMP
 struct op_x86_model_spec const op_p4_ht2_spec = {
-	.num_counters = NUM_COUNTERS_HT2,
-	.num_controls = NUM_CONTROLS_HT2,
-	.fill_in_addresses = &p4_fill_in_addresses,
-	.setup_ctrs = &p4_setup_ctrs,
-	.check_ctrs = &p4_check_ctrs,
-	.start = &p4_start,
-	.stop = &p4_stop,
-	.shutdown = &p4_shutdown
+	.num_counters		= NUM_COUNTERS_HT2,
+	.num_controls		= NUM_CONTROLS_HT2,
+	.fill_in_addresses	= &p4_fill_in_addresses,
+	.setup_ctrs		= &p4_setup_ctrs,
+	.check_ctrs		= &p4_check_ctrs,
+	.start			= &p4_start,
+	.stop			= &p4_stop,
+	.shutdown		= &p4_shutdown
 };
 #endif
 
 struct op_x86_model_spec const op_p4_spec = {
-	.num_counters = NUM_COUNTERS_NON_HT,
-	.num_controls = NUM_CONTROLS_NON_HT,
-	.fill_in_addresses = &p4_fill_in_addresses,
-	.setup_ctrs = &p4_setup_ctrs,
-	.check_ctrs = &p4_check_ctrs,
-	.start = &p4_start,
-	.stop = &p4_stop,
-	.shutdown = &p4_shutdown
+	.num_counters		= NUM_COUNTERS_NON_HT,
+	.num_controls		= NUM_CONTROLS_NON_HT,
+	.fill_in_addresses	= &p4_fill_in_addresses,
+	.setup_ctrs		= &p4_setup_ctrs,
+	.check_ctrs		= &p4_check_ctrs,
+	.start			= &p4_start,
+	.stop			= &p4_stop,
+	.shutdown		= &p4_shutdown
 };
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index eff431f..c665bac 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -181,12 +181,12 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 
 
 struct op_x86_model_spec const op_ppro_spec = {
-	.num_counters = NUM_COUNTERS,
-	.num_controls = NUM_CONTROLS,
-	.fill_in_addresses = &ppro_fill_in_addresses,
-	.setup_ctrs = &ppro_setup_ctrs,
-	.check_ctrs = &ppro_check_ctrs,
-	.start = &ppro_start,
-	.stop = &ppro_stop,
-	.shutdown = &ppro_shutdown
+	.num_counters		= NUM_COUNTERS,
+	.num_controls		= NUM_CONTROLS,
+	.fill_in_addresses	= &ppro_fill_in_addresses,
+	.setup_ctrs		= &ppro_setup_ctrs,
+	.check_ctrs		= &ppro_check_ctrs,
+	.start			= &ppro_start,
+	.stop			= &ppro_stop,
+	.shutdown		= &ppro_shutdown
 };
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index ed98227..5645773 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -41,7 +41,6 @@ static cpumask_t marked_cpus = CPU_MASK_NONE;
 static DEFINE_SPINLOCK(task_mortuary);
 static void process_task_mortuary(void);
 
-
 /* Take ownership of the task struct and place it on the
  * list for processing. Only after two full buffer syncs
  * does the task eventually get freed, because by then
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 2c64517..50062ce 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -19,7 +19,7 @@
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
 #include "oprofile_stats.h"
- 
+
 struct oprofile_operations oprofile_ops;
 
 unsigned long oprofile_started;
@@ -36,7 +36,7 @@ static int timer = 0;
 int oprofile_setup(void)
 {
 	int err;
- 
+
 	mutex_lock(&start_mutex);
 
 	if ((err = alloc_cpu_buffers()))
@@ -44,10 +44,10 @@ int oprofile_setup(void)
 
 	if ((err = alloc_event_buffer()))
 		goto out1;
- 
+
 	if (oprofile_ops.setup && (err = oprofile_ops.setup()))
 		goto out2;
- 
+
 	/* Note even though this starts part of the
 	 * profiling overhead, it's necessary to prevent
 	 * us missing task deaths and eventually oopsing
@@ -74,7 +74,7 @@ post_sync:
 	is_setup = 1;
 	mutex_unlock(&start_mutex);
 	return 0;
- 
+
 out3:
 	if (oprofile_ops.shutdown)
 		oprofile_ops.shutdown();
@@ -92,17 +92,17 @@ out:
 int oprofile_start(void)
 {
 	int err = -EINVAL;
- 
+
 	mutex_lock(&start_mutex);
  
 	if (!is_setup)
 		goto out;
 
-	err = 0; 
- 
+	err = 0;
+
 	if (oprofile_started)
 		goto out;
- 
+
 	oprofile_reset_stats();
 
 	if ((err = oprofile_ops.start()))
@@ -114,7 +114,7 @@ out:
 	return err;
 }
 
- 
+
 /* echo 0>/dev/oprofile/enable */
 void oprofile_stop(void)
 {
@@ -204,13 +204,13 @@ static void __exit oprofile_exit(void)
 	oprofile_arch_exit();
 }
 
- 
+
 module_init(oprofile_init);
 module_exit(oprofile_exit);
 
 module_param_named(timer, timer, int, 0644);
 MODULE_PARM_DESC(timer, "force use of timer interrupt");
- 
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("John Levon <levon@movementarian.org>");
 MODULE_DESCRIPTION("OProfile system profiler");
-- 
1.6.0.1


