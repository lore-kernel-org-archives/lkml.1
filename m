Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXCWTDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXCWTDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXCWTDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:03:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:32794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbXCWTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:27 -0400
Message-Id: <20070323190113.452996000@strauss.suse.de>
References: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:53 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 6/7] Add IRQF_IRQPOLL_IRQ flag on parisc
Content-Disposition: inline; filename=IRQF_IRQPOLL_IRQ-parisc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL_IRQ to the timer interrupt on parisc.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/parisc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc4-mm1/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/parisc/kernel/irq.c
+++ linux-2.6.21-rc4-mm1/arch/parisc/kernel/irq.c
@@ -388,7 +388,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL_IRQ,
 };
 
 #ifdef CONFIG_SMP

-- 
