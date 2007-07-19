Return-Path: <linux-kernel-owner+w=401wt.eu-S940465AbXGSRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940465AbXGSRS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939068AbXGSRS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:18:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18995 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938982AbXGSRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:18:22 -0400
Date: Thu, 19 Jul 2007 10:20:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] irq.h fix kernel-doc
Message-Id: <20070719102036.65e210b2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc entry in <linux/irq.h> for:

Warning(linux-2.6.22-git12//include/linux/irq.h:177): No description found for parameter 'last_unhandled'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/irq.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.22-git12.orig/include/linux/irq.h
+++ linux-2.6.22-git12/include/linux/irq.h
@@ -140,6 +140,7 @@ struct irq_chip {
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
+ * @last_unhandled:	aging timer for unhandled count
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
  * @cpu:		cpu index useful for balancing
