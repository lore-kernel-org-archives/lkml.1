Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZHDOyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZHDOyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZHDOyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:54:06 -0400
Received: from verein.lst.de ([213.95.11.210]:60760 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbZHDOyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:54:06 -0400
Date: Tue, 4 Aug 2009 16:54:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mips: convert to asm-generic/hardirq.h
Message-ID: <20090804145404.GJ20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/mips/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/hardirq.h	2009-07-27 14:32:58.677148625 +0200
+++ linux-2.6/arch/mips/include/asm/hardirq.h	2009-07-27 14:56:48.409931750 +0200
@@ -10,15 +10,9 @@
 #ifndef _ASM_HARDIRQ_H
 #define _ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 extern void ack_bad_irq(unsigned int irq);
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif /* _ASM_HARDIRQ_H */
