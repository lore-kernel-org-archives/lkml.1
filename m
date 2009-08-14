Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZHNL0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZHNL0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZHNL0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:26:43 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:52237 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbZHNL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:40 -0400
Message-Id: <20090814112619.141728093@de.ibm.com>
References: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:45 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Christoph Hellwig <hch@lst.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 28/34] remove unused irq_cpustat_t defintion
Content-Disposition: inline; filename=127-remove-irq_cpustat_t.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

No need to defined a irq_cpustat_t type if __ARCH_IRQ_STAT is defined.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/hardirq.h |    7 -------
 1 file changed, 7 deletions(-)

Index: quilt-2.6/arch/s390/include/asm/hardirq.h
===================================================================
--- quilt-2.6.orig/arch/s390/include/asm/hardirq.h
+++ quilt-2.6/arch/s390/include/asm/hardirq.h
@@ -18,13 +18,6 @@
 #include <linux/interrupt.h>
 #include <asm/lowcore.h>
 
-/* irq_cpustat_t is unused currently, but could be converted
- * into a percpu variable instead of storing softirq_pending
- * on the lowcore */
-typedef struct {
-	unsigned int __softirq_pending;
-} irq_cpustat_t;
-
 #define local_softirq_pending() (S390_lowcore.softirq_pending)
 
 #define __ARCH_IRQ_STAT

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

