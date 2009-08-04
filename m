Return-Path: <linux-kernel-owner+w=401wt.eu-S932557AbZHDO5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbZHDO5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZHDO5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:57:06 -0400
Received: from verein.lst.de ([213.95.11.210]:60784 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZHDO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:57:05 -0400
Date: Tue, 4 Aug 2009 16:56:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] um: convert to asm-generic/hardirq.h
Message-ID: <20090804145653.GN20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/um/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/hardirq.h	2009-07-27 14:32:58.969148744 +0200
+++ linux-2.6/arch/um/include/asm/hardirq.h	2009-07-27 14:57:49.430900969 +0200
@@ -1,25 +1 @@
-/* (c) 2004 cw@f00f.org, GPLv2 blah blah */
-
-#ifndef __ASM_UM_HARDIRQ_H
-#define __ASM_UM_HARDIRQ_H
-
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-/* NOTE: When SMP works again we might want to make this
- * ____cacheline_aligned or maybe use per_cpu state? --cw */
-typedef struct {
-	unsigned int __softirq_pending;
-} irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>
-
-/* As this would be very strange for UML to get we BUG() after the
- * printk. */
-static inline void ack_bad_irq(unsigned int irq)
-{
-	printk(KERN_ERR "unexpected IRQ %02x\n", irq);
-	BUG();
-}
-
-#endif /* __ASM_UM_HARDIRQ_H */
+#include <asm-generic/hardirq.h>
