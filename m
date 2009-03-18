Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZCRVuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZCRVuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZCRVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:08 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757767AbZCRVnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:06 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 38/57] microblaze_v7: headers for irq
Date: Wed, 18 Mar 2009 21:31:05 +0100
Message-Id: <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
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
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
 <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/hardirq.h  |   29 ++++++++
 arch/microblaze/include/asm/irq_regs.h |    1 +
 arch/microblaze/include/asm/irqflags.h |  123 ++++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/hardirq.h
 create mode 100644 arch/microblaze/include/asm/hw_irq.h
 create mode 100644 arch/microblaze/include/asm/irq_regs.h
 create mode 100644 arch/microblaze/include/asm/irqflags.h

diff --git a/arch/microblaze/include/asm/hardirq.h b/arch/microblaze/include/asm/hardirq.h
new file mode 100644
index 0000000..0f2d6b0
--- /dev/null
+++ b/arch/microblaze/include/asm/hardirq.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_HARDIRQ_H
+#define _ASM_MICROBLAZE_HARDIRQ_H
+
+#include <linux/cache.h>
+#include <linux/irq.h>
+#include <asm/irq.h>
+#include <asm/current.h>
+#include <linux/ptrace.h>
+
+/* should be defined in each interrupt controller driver */
+extern unsigned int get_irq(struct pt_regs *regs);
+
+typedef struct {
+	unsigned int __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
+
+void ack_bad_irq(unsigned int irq);
+
+#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
+
+#endif /* _ASM_MICROBLAZE_HARDIRQ_H */
diff --git a/arch/microblaze/include/asm/hw_irq.h b/arch/microblaze/include/asm/hw_irq.h
new file mode 100644
index 0000000..e69de29
diff --git a/arch/microblaze/include/asm/irq_regs.h b/arch/microblaze/include/asm/irq_regs.h
new file mode 100644
index 0000000..3dd9c0b
--- /dev/null
+++ b/arch/microblaze/include/asm/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff --git a/arch/microblaze/include/asm/irqflags.h b/arch/microblaze/include/asm/irqflags.h
new file mode 100644
index 0000000..dea6564
--- /dev/null
+++ b/arch/microblaze/include/asm/irqflags.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_IRQFLAGS_H
+#define _ASM_MICROBLAZE_IRQFLAGS_H
+
+#include <linux/irqflags.h>
+
+# if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+
+# define local_irq_save(flags)				\
+	do {						\
+		asm volatile ("# local_irq_save	\n\t"	\
+				"msrclr %0, %1	\n\t"	\
+				"nop	\n\t"		\
+				: "=r"(flags)		\
+				: "i"(MSR_IE)		\
+				: "memory");		\
+	} while (0)
+
+# define local_irq_disable()					\
+	do {							\
+		asm volatile ("# local_irq_disable \n\t"	\
+				"msrclr r0, %0 \n\t"		\
+				"nop	\n\t"			\
+				:				\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+# define local_irq_enable()					\
+	do {							\
+		asm volatile ("# local_irq_enable \n\t"		\
+				"msrset	r0, %0 \n\t"		\
+				"nop	\n\t"			\
+				:				\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+# else /* CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR == 0 */
+
+# define local_irq_save(flags)					\
+	do {							\
+		register unsigned tmp;				\
+		asm volatile ("# local_irq_save	\n\t"		\
+				"mfs	%0, rmsr \n\t"		\
+				"nop \n\t"			\
+				"andi	%1, %0, %2 \n\t"	\
+				"mts	rmsr, %1 \n\t"		\
+				"nop \n\t"			\
+				: "=r"(flags), "=r" (tmp)	\
+				: "i"(~MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+# define local_irq_disable()					\
+	do {							\
+		register unsigned tmp;				\
+		asm volatile ("# local_irq_disable \n\t"	\
+				"mfs	%0, rmsr \n\t"		\
+				"nop \n\t"			\
+				"andi	%0, %0, %1 \n\t"	\
+				"mts	rmsr, %0 \n\t"		\
+				"nop \n\t"			\
+				: "=r"(tmp)			\
+				: "i"(~MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+# define local_irq_enable()					\
+	do {							\
+		register unsigned tmp;				\
+		asm volatile ("# local_irq_enable \n\t"		\
+				"mfs	%0, rmsr \n\t"		\
+				"nop \n\t"			\
+				"ori	%0, %0, %1 \n\t"	\
+				"mts	rmsr, %0 \n\t"		\
+				"nop \n\t"			\
+				: "=r"(tmp)			\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+# endif /* CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR */
+
+#define local_save_flags(flags)					\
+	do {							\
+		asm volatile ("# local_save_flags \n\t"		\
+				"mfs	%0, rmsr \n\t"		\
+				"nop	\n\t"			\
+				: "=r"(flags)			\
+				:				\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_restore(flags)			\
+	do {						\
+		asm volatile ("# local_irq_restore \n\t"\
+				"mts	rmsr, %0 \n\t"	\
+				"nop	\n\t"		\
+				:			\
+				: "r"(flags)		\
+				: "memory");		\
+	} while (0)
+
+static inline int irqs_disabled(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+	return ((flags & MSR_IE) == 0);
+}
+
+#define raw_irqs_disabled irqs_disabled
+#define raw_irqs_disabled_flags(flags)	((flags) == 0)
+
+#endif /* _ASM_MICROBLAZE_IRQFLAGS_H */
-- 
1.5.5.1

