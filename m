Return-Path: <linux-kernel-owner+w=401wt.eu-S1765663AbYCWIoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765663AbYCWIoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbYCWIK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:59 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2316 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759950AbYCWIKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:52 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 072/148] include/asm-x86/mmzone_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:47 -0700
Message-Id: <1206259443-13210-73-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mmzone_64.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/asm-x86/mmzone_64.h b/include/asm-x86/mmzone_64.h
index ebaf966..594bd0d 100644
--- a/include/asm-x86/mmzone_64.h
+++ b/include/asm-x86/mmzone_64.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_NUMA
 
-#define VIRTUAL_BUG_ON(x) 
+#define VIRTUAL_BUG_ON(x)
 
 #include <asm/smp.h>
 
@@ -16,7 +16,7 @@ struct memnode {
 	int shift;
 	unsigned int mapsize;
 	s16 *map;
-	s16 embedded_map[64-8];
+	s16 embedded_map[64 - 8];
 } ____cacheline_aligned; /* total size = 128 bytes */
 extern struct memnode memnode;
 #define memnode_shift memnode.shift
@@ -25,27 +25,27 @@ extern struct memnode memnode;
 
 extern struct pglist_data *node_data[];
 
-static inline __attribute__((pure)) int phys_to_nid(unsigned long addr) 
-{ 
-	unsigned nid; 
+static inline __attribute__((pure)) int phys_to_nid(unsigned long addr)
+{
+	unsigned nid;
 	VIRTUAL_BUG_ON(!memnodemap);
 	VIRTUAL_BUG_ON((addr >> memnode_shift) >= memnodemapsize);
-	nid = memnodemap[addr >> memnode_shift]; 
-	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]); 
-	return nid; 
-} 
+	nid = memnodemap[addr >> memnode_shift];
+	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]);
+	return nid;
+}
 
 #define NODE_DATA(nid)		(node_data[nid])
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn + \
+#define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
 				 NODE_DATA(nid)->node_spanned_pages)
 
 extern int early_pfn_to_nid(unsigned long pfn);
 
 #ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	(64*1024*1024)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1uL))
+#define FAKE_NODE_MIN_SIZE	(64 * 1024 * 1024)
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 #endif
 
 #endif
-- 
1.5.4.rc2

