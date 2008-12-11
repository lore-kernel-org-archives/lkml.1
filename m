Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYLKQuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYLKQuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbYLKQso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:44 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:18619 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbYLKQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:43 -0500
X-BigFish: VPS1(zzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBQ1CS-01-7O4-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/10] oprofile: whitspace changes only
Date: Thu, 11 Dec 2008 16:04:39 +0100
Message-ID: <1229007886-14362-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0948 (UTC) FILETIME=[49EE1040:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    4 ++--
 drivers/oprofile/cpu_buffer.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index fb67e19..f71bd21 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -70,8 +70,8 @@ static unsigned long reset_value[NUM_COUNTERS];
  * data. Should then be added to linux/oprofile.h.
  */
 extern void
-oprofile_add_ibs_sample(struct pt_regs *const regs,
-			unsigned int *const ibs_sample, int ibs_code);
+oprofile_add_ibs_sample(struct pt_regs * const regs,
+			unsigned int * const ibs_sample, int ibs_code);
 
 struct ibs_fetch_sample {
 	/* MSRC001_1031 IBS Fetch Linear Address Register */
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 3958107..2c4d541 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -277,8 +277,8 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 
 #define MAX_IBS_SAMPLE_SIZE 14
 
-void oprofile_add_ibs_sample(struct pt_regs *const regs,
-			     unsigned int *const ibs_sample, int ibs_code)
+void oprofile_add_ibs_sample(struct pt_regs * const regs,
+			     unsigned int * const ibs_sample, int ibs_code)
 {
 	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-- 
1.6.0.1


