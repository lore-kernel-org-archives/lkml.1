Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXCWTBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXCWTBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXCWTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:01:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:45727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXCWTBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:23 -0400
Message-Id: <20070323190113.145922000@strauss.suse.de>
References: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:52 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 5/7] Add IRQF_IRQPOLL_IRQ flag on sh
Content-Disposition: inline; filename=IRQF_IRQPOLL_IRQ-sh
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL_IRQ on each timer interrupt on SH2.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/sh/kernel/timers/timer-cmt.c  |    2 +-
 arch/sh/kernel/timers/timer-mtu2.c |    2 +-
 arch/sh/kernel/timers/timer-tmu.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc4-mm1/arch/sh/kernel/timers/timer-cmt.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/sh/kernel/timers/timer-cmt.c
+++ linux-2.6.21-rc4-mm1/arch/sh/kernel/timers/timer-cmt.c
@@ -115,7 +115,7 @@ static irqreturn_t cmt_timer_interrupt(i
 static struct irqaction cmt_irq = {
 	.name		= "timer",
 	.handler	= cmt_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL_IRQ,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6.21-rc4-mm1/arch/sh/kernel/timers/timer-mtu2.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/sh/kernel/timers/timer-mtu2.c
+++ linux-2.6.21-rc4-mm1/arch/sh/kernel/timers/timer-mtu2.c
@@ -110,7 +110,7 @@ static irqreturn_t mtu2_timer_interrupt(
 static struct irqaction mtu2_irq = {
 	.name		= "timer",
 	.handler	= mtu2_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL_IRQ,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6.21-rc4-mm1/arch/sh/kernel/timers/timer-tmu.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/sh/kernel/timers/timer-tmu.c
+++ linux-2.6.21-rc4-mm1/arch/sh/kernel/timers/timer-tmu.c
@@ -99,7 +99,7 @@ static irqreturn_t tmu_timer_interrupt(i
 static struct irqaction tmu_irq = {
 	.name		= "timer",
 	.handler	= tmu_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL_IRQ,
 	.mask		= CPU_MASK_NONE,
 };
 

-- 
