Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYLXB3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYLXB3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 20:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYLXB3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 20:29:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:53090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYLXB3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 20:29:22 -0500
Message-ID: <4951905C.6010802@kernel.org>
Date: Tue, 23 Dec 2008 17:29:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparseirq: remove duplicated arch_early_irq_init()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

already have one weak copy in init/main.c

Signed-off-by: Yinghai <yinghai@kernel.org>

---
 kernel/irq/handle.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -56,10 +56,6 @@ void handle_bad_irq(unsigned int irq, st
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
-void __init __attribute__((weak)) arch_early_irq_init(void)
-{
-}
-
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
