Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbYE3EAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbYE3EAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYE3EAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45432 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761AbYE3EAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530040010.806208523@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:21 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 01/41] cpu_alloc: Increase percpu area size to 128k
Content-Disposition: inline; filename=ia64_increase_percpu_size
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per cpu allocator requires more per cpu space and we are already near
the limit on IA64. Increase the maximum size of the IA64 per cpu area from
64K to 128K.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-ia64/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/asm-ia64/page.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/page.h	2008-05-29 12:10:42.216486476 -0700
+++ linux-2.6/include/asm-ia64/page.h	2008-05-29 12:11:06.218953049 -0700
@@ -42,7 +42,7 @@
 #define PAGE_MASK		(~(PAGE_SIZE - 1))
 #define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
 
-#define PERCPU_PAGE_SHIFT	16	/* log2() of max. size of per-CPU area */
+#define PERCPU_PAGE_SHIFT	17	/* log2() of max. size of per-CPU area */
 #define PERCPU_PAGE_SIZE	(__IA64_UL_CONST(1) << PERCPU_PAGE_SHIFT)
 
 

-- 
