Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXCWTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXCWTBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXCWTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:01:25 -0400
Received: from mail.suse.de ([195.135.220.2]:45722 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbXCWTBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:23 -0400
Message-Id: <20070323190112.007833000@strauss.suse.de>
References: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:49 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-ia64@vger.kernel.org
Subject: [patch 2/7] Add IRQF_IRQPOLL_IRQ flag on IA64
Content-Disposition: inline; filename=IRQF_IRQPOLL_IRQ-IA64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL_IRQ for the timer interrupt on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/ia64/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc4-mm1/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/ia64/kernel/time.c
+++ linux-2.6.21-rc4-mm1/arch/ia64/kernel/time.c
@@ -235,7 +235,7 @@ ia64_init_itm (void)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	IRQF_DISABLED | IRQF_IRQPOLL_IRQ,
 	.name =		"timer"
 };
 

-- 
