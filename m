Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZCRVtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZCRVtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbZCRVnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:00 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756799AbZCRVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:42:59 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 23/57] microblaze_v7: asm-offsets
Date: Wed, 18 Mar 2009 21:30:50 +0100
Message-Id: <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |  115 ++++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/asm-offsets.c

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
new file mode 100644
index 0000000..799283a
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
+	DEFINE(CC_R1, offsetof(struct cpu_context, r1)); /* r1 */
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
1.5.5.1

