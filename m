Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZFNDBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZFNDBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 23:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZFNDBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 23:01:09 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:50085 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZFNDBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 23:01:08 -0400
Message-ID: <4A3467EC.50006@oracle.com>
Date: Sat, 13 Jun 2009 20:01:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] irq.h: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A3467ED.001C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in linux/irq.h:

Warning(include/linux/irq.h:201): No description found for parameter 'node'
Warning(include/linux/irq.h:201): Excess struct/union/enum/typedef member 'cpu' description in 'irq_desc'
Warning(include/linux/irq.h:434): No description found for parameter 'node'
Warning(include/linux/irq.h:434): Excess function parameter 'cpu' description in 'alloc_desc_masks'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/irq.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.30-git7.orig/include/linux/irq.h
+++ linux-2.6.30-git7/include/linux/irq.h
@@ -157,7 +157,7 @@ struct irq_2_iommu;
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
- * @cpu:		cpu index useful for balancing
+ * @node:		node index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
@@ -423,7 +423,7 @@ extern int set_irq_msi(unsigned int irq,
 /**
  * alloc_desc_masks - allocate cpumasks for irq_desc
  * @desc:	pointer to irq_desc struct
- * @cpu:	cpu which will be handling the cpumasks
+ * @node:	node which will be handling the cpumasks
  * @boot:	true if need bootmem
  *
  * Allocates affinity and pending_mask cpumask if required.
