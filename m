Return-Path: <linux-kernel-owner+w=401wt.eu-S1764861AbXIUUyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764861AbXIUUyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762944AbXIUUpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:50063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763315AbXIUUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:11 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: akpm@linux-foundation.org, ak@suse.de, rientjes@google.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [28/45] x86_64: clean up apicid_to_node declaration
Message-Id: <20070921204510.9FEBE14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

Use the correct #define in the declaration of apicid_to_node[], to match the
definition.

Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/numa.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/include/asm-x86_64/numa.h
===================================================================
--- linux.orig/include/asm-x86_64/numa.h
+++ linux/include/asm-x86_64/numa.h
@@ -2,6 +2,7 @@
 #define _ASM_X8664_NUMA_H 1
 
 #include <linux/nodemask.h>
+#include <asm/apicdef.h>
 
 struct bootnode {
 	u64 start,end; 
@@ -19,7 +20,7 @@ extern void numa_set_node(int cpu, int n
 extern void srat_reserve_add_area(int nodeid);
 extern int hotadd_percent;
 
-extern unsigned char apicid_to_node[256];
+extern unsigned char apicid_to_node[MAX_LOCAL_APIC];
 #ifdef CONFIG_NUMA
 extern void __init init_cpu_to_node(void);
 
