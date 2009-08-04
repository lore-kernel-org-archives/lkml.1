Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZHDO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZHDO4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZHDO4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:56:19 -0400
Received: from verein.lst.de ([213.95.11.210]:60777 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbZHDO4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:56:18 -0400
Date: Tue, 4 Aug 2009 16:56:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sparc32: convert to asm-generic/hardirq.h
Message-ID: <20090804145615.GM20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/sparc/include/asm/hardirq_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/hardirq_32.h	2009-07-27 14:37:54.393922856 +0200
+++ linux-2.6/arch/sparc/include/asm/hardirq_32.h	2009-07-27 14:57:42.583901007 +0200
@@ -7,17 +7,7 @@
 #ifndef __SPARC_HARDIRQ_H
 #define __SPARC_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/spinlock.h>
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */ /* XXX P3 Is it? */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 #define HARDIRQ_BITS    8
+#include <asm-generic/hardirq.h>
 
 #endif /* __SPARC_HARDIRQ_H */
