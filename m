Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZG1RSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZG1RSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZG1RSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:44 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36130 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbZG1RSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:15 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DM-03-BLT-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/26] x86/oprofile: Whitespaces changes only
Date: Tue, 28 Jul 2009 19:07:02 +0200
Message-ID: <1248800846-25422-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0619 (UTC) FILETIME=[53F7E330:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes whitespace changes of code that will be touched in
follow-on patches.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |   12 ++++++------
 arch/x86/oprofile/op_model_amd.c  |   12 ++++++------
 arch/x86/oprofile/op_model_p4.c   |    8 ++++----
 arch/x86/oprofile/op_model_ppro.c |    8 ++++----
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 25da1e1..fca8dc9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -516,12 +516,12 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	/* default values, can be overwritten by model */
-	ops->create_files = nmi_create_files;
-	ops->setup = nmi_setup;
-	ops->shutdown = nmi_shutdown;
-	ops->start = nmi_start;
-	ops->stop = nmi_stop;
-	ops->cpu_type = cpu_type;
+	ops->create_files	= nmi_create_files;
+	ops->setup		= nmi_setup;
+	ops->shutdown		= nmi_shutdown;
+	ops->start		= nmi_start;
+	ops->stop		= nmi_stop;
+	ops->cpu_type		= cpu_type;
 
 	if (model->init)
 		ret = model->init(ops);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 7ca8306..f676f88 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -91,7 +91,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	int i;
 
 	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
+	for (i = 0; i < NUM_CONTROLS; ++i) {
 		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -229,7 +229,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
@@ -250,7 +250,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 {
 	u64 val;
 	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
 			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -270,7 +270,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	 * Subtle: stop on all counters to avoid race with setting our
 	 * pm callback
 	 */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -285,11 +285,11 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
+	for (i = 0; i < NUM_CONTROLS; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 9db9e36..5921b7f 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -558,7 +558,7 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* clear the cccrs we will use */
-	for (i = 0 ; i < num_counters ; i++) {
+	for (i = 0; i < num_counters; i++) {
 		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
@@ -575,7 +575,7 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* setup all counters */
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (counter_config[i].enabled && msrs->controls[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
@@ -678,7 +678,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(msrs->counters[i].addr);
 	}
@@ -687,7 +687,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	 * conjunction with the counter registers (hence the starting offset).
 	 * This saves a few bits.
 	 */
-	for (i = num_counters ; i < num_controls ; ++i) {
+	for (i = num_counters; i < num_controls; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(msrs->controls[i].addr);
 	}
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index cd72d5c..570d717 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -81,7 +81,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* clear all counters */
-	for (i = 0 ; i < num_counters; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -125,7 +125,7 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	if (unlikely(!reset_value))
 		goto out;
 
-	for (i = 0 ; i < num_counters; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
@@ -188,11 +188,11 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
-- 
1.6.3.3


