Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbZCKAsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbZCKAsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZCKAqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:51 -0400
Received: from www.tglx.de ([62.245.132.106]:40039 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbZCKAqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:50 -0400
Message-Id: <20090311003236.015120391@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 06/18] drivers/mfd: convert obsolete irq_desc_t to struct
	irq_desc
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=mfd-convert-obsolete-irq-desc-t-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_desc.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/twl4030-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/mfd/twl4030-irq.c
===================================================================
--- linux-2.6.orig/drivers/mfd/twl4030-irq.c
+++ linux-2.6/drivers/mfd/twl4030-irq.c
@@ -255,7 +255,7 @@ static int twl4030_irq_thread(void *data
  * thread.  All we do here is acknowledge and mask the interrupt and wakeup
  * the kernel thread.
  */
-static void handle_twl4030_pih(unsigned int irq, irq_desc_t *desc)
+static void handle_twl4030_pih(unsigned int irq, struct irq_desc *desc)
 {
 	/* Acknowledge, clear *AND* mask the interrupt... */
 	desc->chip->ack(irq);


