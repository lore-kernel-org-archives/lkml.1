Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZCKAw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZCKAw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZCKAri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:47:38 -0400
Received: from www.tglx.de ([62.245.132.106]:40122 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZCKArh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:37 -0400
Message-Id: <20090311003235.677690312@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Howells <dhowells@redhat.com>
Subject: [patch 03/18] mn10300: convert obsolete no_irq_type to no_irq_chip
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=mn10300-convert-obsolete-no-irq-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert the last remaining users to no_irq_chip

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/mn10300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/irq.c
+++ linux-2.6/arch/mn10300/kernel/irq.c
@@ -140,7 +140,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		if (irq_desc[irq].chip == &no_irq_type)
+		if (irq_desc[irq].chip == &no_irq_chip)
 			/* due to the PIC latching interrupt requests, even
 			 * when the IRQ is disabled, IRQ_PENDING is superfluous
 			 * and we can use handle_level_irq() for edge-triggered


