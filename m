Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbYG1VMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbYG1VMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYG1VJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:38 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYG1VJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:37 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 08/24] x86: kernel/io_apic_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:15 -0300
Message-Id: <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/io_apic_64.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 8269434..f2f1825 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1510,14 +1510,14 @@ static void ack_apic_level(unsigned int irq)
 }
 
 static struct irq_chip ioapic_chip __read_mostly = {
-	.name 		= "IO-APIC",
-	.startup 	= startup_ioapic_irq,
-	.mask	 	= mask_IO_APIC_irq,
-	.unmask	 	= unmask_IO_APIC_irq,
-	.ack 		= ack_apic_edge,
-	.eoi 		= ack_apic_level,
+	.name		= "IO-APIC",
+	.startup	= startup_ioapic_irq,
+	.mask		= mask_IO_APIC_irq,
+	.unmask		= unmask_IO_APIC_irq,
+	.ack		= ack_apic_edge,
+	.eoi		= ack_apic_level,
 #ifdef CONFIG_SMP
-	.set_affinity 	= set_ioapic_affinity_irq,
+	.set_affinity	= set_ioapic_affinity_irq,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
 };
@@ -1591,14 +1591,14 @@ static void lapic_register_intr(int irq)
 static void __init setup_nmi(void)
 {
 	/*
- 	 * Dirty trick to enable the NMI watchdog ...
+	 * Dirty trick to enable the NMI watchdog ...
 	 * We put the 8259A master into AEOI mode and
 	 * unmask on all local APICs LVT0 as NMI.
 	 *
 	 * The idea to use the 8259A in AEOI mode ('8259A Virtual Wire')
 	 * is from Maciej W. Rozycki - so we do not have to EOI from
 	 * the NMI handler or the timer interrupt.
-	 */ 
+	 */
 	printk(KERN_INFO "activating NMI Watchdog ...");
 
 	enable_NMI_through_LVT0();
-- 
1.5.4.5

