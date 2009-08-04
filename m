Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZHDOwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZHDOwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZHDOwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:52:18 -0400
Received: from verein.lst.de ([213.95.11.210]:39711 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbZHDOwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:52:18 -0400
Date: Tue, 4 Aug 2009 16:52:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: convert to asm-generic/hardirq.h
Message-ID: <20090804145210.GG20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/m68k/include/asm/hardirq_mm.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/hardirq_mm.h	2009-07-27 14:35:39.570899187 +0200
+++ linux-2.6/arch/m68k/include/asm/hardirq_mm.h	2009-07-27 14:42:42.363922072 +0200
@@ -1,16 +1,8 @@
 #ifndef __M68K_HARDIRQ_H
 #define __M68K_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 #define HARDIRQ_BITS	8
 
+#include <asm-generic/hardirq.h>
+
 #endif
