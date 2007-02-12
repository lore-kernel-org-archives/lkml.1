Return-Path: <linux-kernel-owner+w=401wt.eu-S964977AbXBLQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977AbXBLQyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965006AbXBLQwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:47989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965005AbXBLQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:57 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [28/29] i386: Remove extern declaration from  mm/discontig.c, put in header.
Message-Id: <20070212165149.4FB8113E1B@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>
Extern declarations belong in headers.  Times, they are a'changin.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

===================================================================
---
 arch/i386/mm/discontig.c |    1 -
 include/asm-i386/setup.h |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/i386/mm/discontig.c
===================================================================
--- linux.orig/arch/i386/mm/discontig.c
+++ linux/arch/i386/mm/discontig.c
@@ -101,7 +101,6 @@ extern void find_max_pfn(void);
 extern void add_one_highpage_init(struct page *, int, int);
 
 extern struct e820map e820;
-extern unsigned long init_pg_tables_end;
 extern unsigned long highend_pfn, highstart_pfn;
 extern unsigned long max_low_pfn;
 extern unsigned long totalram_pages;
Index: linux/include/asm-i386/setup.h
===================================================================
--- linux.orig/include/asm-i386/setup.h
+++ linux/include/asm-i386/setup.h
@@ -77,6 +77,8 @@ int __init sanitize_e820_map(struct e820
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
 
+extern unsigned long init_pg_tables_end;
+
 #endif /* __ASSEMBLY__ */
 
 #endif  /*  __KERNEL__  */
