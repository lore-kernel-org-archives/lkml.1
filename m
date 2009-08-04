Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZHDOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZHDOsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZHDOsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:48:32 -0400
Received: from verein.lst.de ([213.95.11.210]:54608 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbZHDOsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:48:31 -0400
Date: Tue, 4 Aug 2009 16:48:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: convert to asm-generic/hardirq.h
Message-ID: <20090804144826.GA20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/alpha/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/hardirq.h	2009-07-27 14:32:58.111917814 +0200
+++ linux-2.6/arch/alpha/include/asm/hardirq.h	2009-07-27 14:58:12.767913104 +0200
@@ -1,17 +1,9 @@
 #ifndef _ALPHA_HARDIRQ_H
 #define _ALPHA_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/cache.h>
-
-
-/* entry.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned long __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 void ack_bad_irq(unsigned int irq);
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif /* _ALPHA_HARDIRQ_H */
