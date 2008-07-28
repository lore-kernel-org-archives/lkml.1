Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYG1VRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYG1VRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbYG1VJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:51 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbYG1VJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:46 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 23/24] x86: kernel/vmiclock_32.c cleanup
Date: Mon, 28 Jul 2008 18:09:30 -0300
Message-Id: <1217279371-4410-24-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-23-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-14-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-15-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-16-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-17-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-18-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-19-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-20-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-21-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-22-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-23-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove addtional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/vmiclock_32.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 6953859..00d0c8b 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -115,11 +115,11 @@ static void ack_timer_irq(unsigned int irq)
 }
 
 static struct irq_chip vmi_chip __read_mostly = {
-	.name 		= "VMI-LOCAL",
-	.startup 	= startup_timer_irq,
-	.mask	 	= mask_timer_irq,
-	.unmask	 	= unmask_timer_irq,
-	.ack 		= ack_timer_irq
+	.name		= "VMI-LOCAL",
+	.startup	= startup_timer_irq,
+	.mask		= mask_timer_irq,
+	.unmask		= unmask_timer_irq,
+	.ack		= ack_timer_irq
 };
 #endif
 
@@ -200,10 +200,10 @@ static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
 }
 
 static struct irqaction vmi_clock_action  = {
-	.name 		= "vmi-timer",
-	.handler 	= vmi_timer_interrupt,
-	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING,
-	.mask 		= CPU_MASK_ALL,
+	.name		= "vmi-timer",
+	.handler	= vmi_timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_NOBALANCING,
+	.mask		= CPU_MASK_ALL,
 };
 
 static void __devinit vmi_time_init_clockevent(void)
-- 
1.5.4.5

