Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZDIRU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZDIRU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZDIRUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:20:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbZDIRUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:20:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Convert obsolete no_irq_type to no_irq_chip
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>
Date: Thu, 09 Apr 2009 18:18:47 +0100
Message-ID: <20090409171847.4299.84906.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Convert the last remaining users to no_irq_chip.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 50fdb5c..4c3c58e 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -140,7 +140,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		if (irq_desc[irq].chip == &no_irq_type)
+		if (irq_desc[irq].chip == &no_irq_chip)
 			/* due to the PIC latching interrupt requests, even
 			 * when the IRQ is disabled, IRQ_PENDING is superfluous
 			 * and we can use handle_level_irq() for edge-triggered

