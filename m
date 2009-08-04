Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZHDOzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZHDOzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbZHDOzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:55:33 -0400
Received: from verein.lst.de ([213.95.11.210]:60774 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZHDOzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:55:32 -0400
Date: Tue, 4 Aug 2009 16:55:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sh: convert to asm-generic/hardirq.h
Message-ID: <20090804145529.GL20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/sh/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/hardirq.h	2009-07-27 14:32:58.906148678 +0200
+++ linux-2.6/arch/sh/include/asm/hardirq.h	2009-07-27 14:44:39.214150931 +0200
@@ -1,16 +1,9 @@
 #ifndef __ASM_SH_HARDIRQ_H
 #define __ASM_SH_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-/* entry.S is sensitive to the offsets of these fields */
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
 
 #endif /* __ASM_SH_HARDIRQ_H */
