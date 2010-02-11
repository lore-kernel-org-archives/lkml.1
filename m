Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0BKOEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:04:42 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52319 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0BKOEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:04:40 -0500
Date: Thu, 11 Feb 2010 15:04:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: devres/irq: Fix cross-referencing comments
Message-ID: <20100211150436.1f86e060@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the reference (in comment) from devm_request_irq to devm_free_irq
and back.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 kernel/irq/devres.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.33-rc7.orig/kernel/irq/devres.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.33-rc7/kernel/irq/devres.c	2010-02-11 14:53:35.000000000 +0100
@@ -42,7 +42,7 @@ static int devm_irq_match(struct device
  *	automatically freed on driver detach.
  *
  *	If an IRQ allocated with this function needs to be freed
- *	separately, dev_free_irq() must be used.
+ *	separately, devm_free_irq() must be used.
  */
 int devm_request_threaded_irq(struct device *dev, unsigned int irq,
 			      irq_handler_t handler, irq_handler_t thread_fn,
@@ -81,7 +81,7 @@ EXPORT_SYMBOL(devm_request_threaded_irq)
  *	Except for the extra @dev argument, this function takes the
  *	same arguments and performs the same function as free_irq().
  *	This function instead of free_irq() should be used to manually
- *	free IRQs allocated with dev_request_irq().
+ *	free IRQs allocated with devm_request_irq().
  */
 void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
 {


-- 
Jean Delvare
