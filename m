Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYGHMRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYGHMRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbYGHMPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:15:05 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27350 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759627AbYGHMPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:15:02 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 23/58] microblaze_v5: asm-offsets
Date: Tue,  8 Jul 2008 13:59:23 +0200
Message-Id: <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |  115 ++++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/asm-offsets.c

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
new file mode 100644
index 0000000..10c07bc
--- /dev/null
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/stddef.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/ptrace.h>
+#include <linux/hardirq.h>
+#include <linux/thread_info.h>
+#include <linux/kbuild.h>
+
+int main(int argc, char *argv[])
+{
+	/* struct pt_regs */
+	DEFINE(PT_SIZE, sizeof(struct pt_regs));
+	DEFINE(PT_MSR, offsetof(struct pt_regs, msr));
+	DEFINE(PT_EAR, offsetof(struct pt_regs, ear));
+	DEFINE(PT_ESR, offsetof(struct pt_regs, esr));
+	DEFINE(PT_FSR, offsetof(struct pt_regs, fsr));
+	DEFINE(PT_PC, offsetof(struct pt_regs, pc));
+	DEFINE(PT_R0, offsetof(struct pt_regs, r0));
+	DEFINE(PT_R1, offsetof(struct pt_regs, r1));
+	DEFINE(PT_R2, offsetof(struct pt_regs, r2));
+	DEFINE(PT_R3, offsetof(struct pt_regs, r3));
+	DEFINE(PT_R4, offsetof(struct pt_regs, r4));
+	DEFINE(PT_R5, offsetof(struct pt_regs, r5));
+	DEFINE(PT_R6, offsetof(struct pt_regs, r6));
+	DEFINE(PT_R7, offsetof(struct pt_regs, r7));
+	DEFINE(PT_R8, offsetof(struct pt_regs, r8));
+	DEFINE(PT_R9, offsetof(struct pt_regs, r9));
+	DEFINE(PT_R10, offsetof(struct pt_regs, r10));
+	DEFINE(PT_R11, offsetof(struct pt_regs, r11));
+	DEFINE(PT_R12, offsetof(struct pt_regs, r12));
+	DEFINE(PT_R13, offsetof(struct pt_regs, r13));
+	DEFINE(PT_R14, offsetof(struct pt_regs, r14));
+	DEFINE(PT_R15, offsetof(struct pt_regs, r15));
+	DEFINE(PT_R16, offsetof(struct pt_regs, r16));
+	DEFINE(PT_R17, offsetof(struct pt_regs, r17));
+	DEFINE(PT_R18, offsetof(struct pt_regs, r18));
+	DEFINE(PT_R19, offsetof(struct pt_regs, r19));
+	DEFINE(PT_R20, offsetof(struct pt_regs, r20));
+	DEFINE(PT_R21, offsetof(struct pt_regs, r21));
+	DEFINE(PT_R22, offsetof(struct pt_regs, r22));
+	DEFINE(PT_R23, offsetof(struct pt_regs, r23));
+	DEFINE(PT_R24, offsetof(struct pt_regs, r24));
+	DEFINE(PT_R25, offsetof(struct pt_regs, r25));
+	DEFINE(PT_R26, offsetof(struct pt_regs, r26));
+	DEFINE(PT_R27, offsetof(struct pt_regs, r27));
+	DEFINE(PT_R28, offsetof(struct pt_regs, r28));
+	DEFINE(PT_R29, offsetof(struct pt_regs, r29));
+	DEFINE(PT_R30, offsetof(struct pt_regs, r30));
+	DEFINE(PT_R31, offsetof(struct pt_regs, r31));
+	DEFINE(PT_MODE, offsetof(struct pt_regs, kernel_mode));
+	BLANK();
+
+	/* Magic offsets for PTRACE PEEK/POKE etc */
+	DEFINE(PT_TEXT_ADDR, sizeof(struct pt_regs) + 1);
+	DEFINE(PT_TEXT_LEN, sizeof(struct pt_regs) + 2);
+	DEFINE(PT_DATA_ADDR, sizeof(struct pt_regs) + 3);
+	BLANK();
+
+	/* struct task_struct */
+	DEFINE(TS_THREAD_INFO, offsetof(struct task_struct, stack));
+
+	/* struct thread_info */
+	DEFINE(TI_TASK, offsetof(struct thread_info, task));
+	DEFINE(TI_EXEC_DOMAIN, offsetof(struct thread_info, exec_domain));
+	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
+	DEFINE(TI_STATUS, offsetof(struct thread_info, status));
+	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
+	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
+	DEFINE(TI_ADDR_LIMIT, offsetof(struct thread_info, addr_limit));
+	DEFINE(TI_RESTART_BLOCK, offsetof(struct thread_info, restart_block));
+	DEFINE(TI_CPU_CONTEXT, offsetof(struct thread_info, cpu_context));
+	BLANK();
+
+	/* struct cpu_context */
+	DEFINE(CC_SP, offsetof(struct cpu_context, r1)); /* r1 */
+	DEFINE(CC_R2, offsetof(struct cpu_context, r2));
+	/* dedicated registers */
+	DEFINE(CC_R13, offsetof(struct cpu_context, r13));
+	DEFINE(CC_R14, offsetof(struct cpu_context, r14));
+	DEFINE(CC_R15, offsetof(struct cpu_context, r15));
+	DEFINE(CC_R16, offsetof(struct cpu_context, r16));
+	DEFINE(CC_R17, offsetof(struct cpu_context, r17));
+	DEFINE(CC_R18, offsetof(struct cpu_context, r18));
+	/* non-volatile registers */
+	DEFINE(CC_R19, offsetof(struct cpu_context, r19));
+	DEFINE(CC_R20, offsetof(struct cpu_context, r20));
+	DEFINE(CC_R21, offsetof(struct cpu_context, r21));
+	DEFINE(CC_R22, offsetof(struct cpu_context, r22));
+	DEFINE(CC_R23, offsetof(struct cpu_context, r23));
+	DEFINE(CC_R24, offsetof(struct cpu_context, r24));
+	DEFINE(CC_R25, offsetof(struct cpu_context, r25));
+	DEFINE(CC_R26, offsetof(struct cpu_context, r26));
+	DEFINE(CC_R27, offsetof(struct cpu_context, r27));
+	DEFINE(CC_R28, offsetof(struct cpu_context, r28));
+	DEFINE(CC_R29, offsetof(struct cpu_context, r29));
+	DEFINE(CC_R30, offsetof(struct cpu_context, r30));
+	/* special purpose registers */
+	DEFINE(CC_MSR, offsetof(struct cpu_context, msr));
+	DEFINE(CC_EAR, offsetof(struct cpu_context, ear));
+	DEFINE(CC_ESR, offsetof(struct cpu_context, esr));
+	DEFINE(CC_FSR, offsetof(struct cpu_context, fsr));
+	BLANK();
+
+	return 0;
+}
-- 
1.5.4.GIT

