Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYAXQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYAXQ5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYAXQxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:22 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64227 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYAXQxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:05 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/17] [MIPS] Malta: else should follow close brace in malta_int.c
Date: Thu, 24 Jan 2008 19:52:51 +0300
Message-Id: <1201193577-4261-12-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two errors reported by checkpatch.pl.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index a268912..2473a77 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -329,8 +329,7 @@ void __init arch_init_irq(void)
 		set_vi_handler(MSC01E_INT_COREHI, corehi_irqdispatch);
 		setup_irq(MSC01E_INT_BASE+MSC01E_INT_I8259A, &i8259irq);
 		setup_irq(MSC01E_INT_BASE+MSC01E_INT_COREHI, &corehi_irqaction);
-	}
-	else if (cpu_has_vint) {
+	} else if (cpu_has_vint) {
 		set_vi_handler(MIPSCPU_INT_I8259A, malta_hw0_irqdispatch);
 		set_vi_handler(MIPSCPU_INT_COREHI, corehi_irqdispatch);
 #ifdef CONFIG_MIPS_MT_SMTC
@@ -355,8 +354,7 @@ void __init arch_init_irq(void)
 		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_COREHI,
 						&corehi_irqaction);
 #endif /* CONFIG_MIPS_MT_SMTC */
-	}
-	else {
+	} else {
 		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_I8259A, &i8259irq);
 		setup_irq(MIPS_CPU_IRQ_BASE+MIPSCPU_INT_COREHI,
 						&corehi_irqaction);
-- 
1.5.3

