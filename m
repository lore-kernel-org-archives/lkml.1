Return-Path: <linux-kernel-owner+w=401wt.eu-S1765620AbYCWJCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765620AbYCWJCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbYCWIML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2360 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbYCWILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:48 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 071/148] include/asm-x86/mmzone_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:46 -0700
Message-Id: <1206259443-13210-72-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mmzone_32.h |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/asm-x86/mmzone_32.h b/include/asm-x86/mmzone_32.h
index b9f5be2..e3a1390 100644
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -18,7 +18,7 @@ extern struct pglist_data *node_data[];
 	#include <asm/srat.h>
 #endif
 
-extern int get_memcfg_numa_flat(void );
+extern int get_memcfg_numa_flat(void);
 /*
  * This allows any one NUMA architecture to be compiled
  * for, and still fall back to the flat function if it
@@ -107,34 +107,36 @@ static inline int pfn_valid(int pfn)
 /*
  * Following are macros that are specific to this numa platform.
  */
-#define reserve_bootmem(addr, size, flags) \
+#define reserve_bootmem(addr, size, flags)				\
 	reserve_bootmem_node(NODE_DATA(0), (addr), (size), (flags))
-#define alloc_bootmem(x) \
-	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low(x) \
+#define alloc_bootmem(x)						\
+	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES,	\
+			     __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_low(x)						\
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, 0)
-#define alloc_bootmem_pages(x) \
-	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low_pages(x) \
+#define alloc_bootmem_pages(x)						\
+	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE,		\
+			     __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_low_pages(x)					\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x)					\
 ({									\
-	struct pglist_data  __maybe_unused			\
-				*__alloc_bootmem_node__pgdat = (pgdat);	\
+	struct pglist_data *__alloc_bootmem_node__pgdat = (pgdat)	\
+		__maybe_unused;						\
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES,	\
-						__pa(MAX_DMA_ADDRESS));	\
+			     __pa(MAX_DMA_ADDRESS));			\
 })
 #define alloc_bootmem_pages_node(pgdat, x)				\
 ({									\
-	struct pglist_data  __maybe_unused			\
-				*__alloc_bootmem_node__pgdat = (pgdat);	\
+	struct pglist_data *__alloc_bootmem_node__pgdat = (pgdat)	\
+		__maybe_unused;						\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE,		\
-						__pa(MAX_DMA_ADDRESS));	\
+			     __pa(MAX_DMA_ADDRESS));			\
 })
 #define alloc_bootmem_low_pages_node(pgdat, x)				\
 ({									\
-	struct pglist_data  __maybe_unused			\
-				*__alloc_bootmem_node__pgdat = (pgdat);	\
+	struct pglist_data *__alloc_bootmem_node__pgdat = (pgdat)	\
+		__maybe_unused;						\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0);		\
 })
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
-- 
1.5.4.rc2

