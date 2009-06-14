Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZFNHKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZFNHKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZFNHKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:10:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:49708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZFNHKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:10:30 -0400
Date: Sun, 14 Jun 2009 07:09:57 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <4A3467EC.50006@oracle.com>
References: <4A3467EC.50006@oracle.com>
Subject: [tip:irq/urgent] genirq, irq.h: Fix kernel-doc warnings
Message-ID: <tip-ab33dcff40d7a9a28587e4425621e4cbc4089e03@git.kernel.org>
Git-Commit-ID: ab33dcff40d7a9a28587e4425621e4cbc4089e03
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Jun 2009 07:09:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab33dcff40d7a9a28587e4425621e4cbc4089e03
Gitweb:     http://git.kernel.org/tip/ab33dcff40d7a9a28587e4425621e4cbc4089e03
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sat, 13 Jun 2009 20:01:00 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Jun 2009 09:08:30 +0200

genirq, irq.h: Fix kernel-doc warnings

Fix kernel-doc warnings in linux/irq.h:

  Warning(include/linux/irq.h:201): No description found for parameter 'node'
  Warning(include/linux/irq.h:201): Excess struct/union/enum/typedef member 'cpu' description in 'irq_desc'
  Warning(include/linux/irq.h:434): No description found for parameter 'node'
  Warning(include/linux/irq.h:434): Excess function parameter 'cpu' description in 'alloc_desc_masks'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <4A3467EC.50006@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/irq.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b7cbeed..0c001c1 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -157,7 +157,7 @@ struct irq_2_iommu;
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
- * @cpu:		cpu index useful for balancing
+ * @node:		node index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
@@ -426,7 +426,7 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 /**
  * init_alloc_desc_masks - allocate cpumasks for irq_desc
  * @desc:	pointer to irq_desc struct
- * @cpu:	cpu which will be handling the cpumasks
+ * @node:	node which will be handling the cpumasks
  * @boot:	true if need bootmem
  *
  * Allocates affinity and pending_mask cpumask if required.
