Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYAXQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYAXQ6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbYAXQxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:25 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64223 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYAXQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:04 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/17] [MIPS] Malta: fix oversized lines in malta_int.c
Date: Thu, 24 Jan 2008 19:52:47 +0300
Message-Id: <1201193577-4261-8-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all "line over 80 characters" warnings found
in arch/mips/mips-boards/malta/malta_int.c by the checkpatch.pl
script.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index 6d371f4..1b4b9c5 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -304,17 +304,25 @@ void __init arch_init_irq(void)
 	case MIPS_REVISION_SCON_SOCIT:
 	case MIPS_REVISION_SCON_ROCIT:
 		if (cpu_has_veic)
-			init_msc_irqs(MIPS_MSC01_IC_REG_BASE, MSC01E_INT_BASE, msc_eicirqmap, msc_nr_eicirqs);
+			init_msc_irqs(MIPS_MSC01_IC_REG_BASE,
+					MSC01E_INT_BASE, msc_eicirqmap,
+					msc_nr_eicirqs);
 		else
-			init_msc_irqs(MIPS_MSC01_IC_REG_BASE, MSC01C_INT_BASE, msc_irqmap, msc_nr_irqs);
+			init_msc_irqs(MIPS_MSC01_IC_REG_BASE,
+					MSC01C_INT_BASE, msc_irqmap,
+					msc_nr_irqs);
 		break;
 
 	case MIPS_REVISION_SCON_SOCITSC:
 	case MIPS_REVISION_SCON_SOCITSCP:
 		if (cpu_has_veic)
-			init_msc_irqs(MIPS_SOCITSC_IC_REG_BASE, MSC01E_INT_BASE, msc_eicirqmap, msc_nr_eicirqs);
+			init_msc_irqs(MIPS_SOCITSC_IC_REG_BASE,
+					MSC01E_INT_BASE, msc_eicirqmap,
+					msc_nr_eicirqs);
 		else
-			init_msc_irqs(MIPS_SOCITSC_IC_REG_BASE, MSC01C_INT_BASE, msc_irqmap, msc_nr_irqs);
+			init_msc_irqs(MIPS_SOCITSC_IC_REG_BASE,
+					MSC01C_INT_BASE, msc_irqmap,
+					msc_nr_irqs);
 	}
 
 	if (cpu_has_veic) {
@@ -345,11 +353,13 @@ void __init arch_init_irq(void)
 		}
 #else /* Not SMTC */
 		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_I8259A, &i8259irq);
-		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_COREHI, &corehi_irqaction);
+		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_COREHI,
+						&corehi_irqaction);
 #endif /* CONFIG_MIPS_MT_SMTC */
 	}
 	else {
 		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_I8259A, &i8259irq);
-		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_COREHI, &corehi_irqaction);
+		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_COREHI,
+						&corehi_irqaction);
 	}
 }
-- 
1.5.3

