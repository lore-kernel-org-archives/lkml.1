Return-Path: <linux-kernel-owner+w=401wt.eu-S1761221AbYG1VL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221AbYG1VL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYG1VJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:38 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYG1VJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:37 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 07/24] x86: kernel/io_apic_32.c cleanup
Date: Mon, 28 Jul 2008 18:09:14 -0300
Message-Id: <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/io_apic_32.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index de9aa0e..5801233 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -389,7 +389,7 @@ static struct irq_cpu_info {
 
 #define CPU_IRQ(cpu)		(irq_cpu_data[cpu].irq)
 #define LAST_CPU_IRQ(cpu, irq)   (irq_cpu_data[cpu].last_irq[irq])
-#define IRQ_DELTA(cpu, irq) 	(irq_cpu_data[cpu].irq_delta[irq])
+#define IRQ_DELTA(cpu, irq)		(irq_cpu_data[cpu].irq_delta[irq])
 
 #define IDLE_ENOUGH(cpu,now) \
 	(idle_cpu(cpu) && ((now) - per_cpu(irq_stat, (cpu)).idle_timestamp > 1))
@@ -1972,14 +1972,14 @@ static int ioapic_retrigger_irq(unsigned int irq)
 }
 
 static struct irq_chip ioapic_chip __read_mostly = {
-	.name 		= "IO-APIC",
-	.startup 	= startup_ioapic_irq,
-	.mask	 	= mask_IO_APIC_irq,
-	.unmask	 	= unmask_IO_APIC_irq,
-	.ack 		= ack_ioapic_irq,
-	.eoi 		= ack_ioapic_quirk_irq,
+	.name		= "IO-APIC",
+	.startup	= startup_ioapic_irq,
+	.mask		= mask_IO_APIC_irq,
+	.unmask		= unmask_IO_APIC_irq,
+	.ack		= ack_ioapic_irq,
+	.eoi		= ack_ioapic_quirk_irq,
 #ifdef CONFIG_SMP
-	.set_affinity 	= set_ioapic_affinity_irq,
+	.set_affinity	= set_ioapic_affinity_irq,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
 };
-- 
1.5.4.5

