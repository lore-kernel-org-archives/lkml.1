Return-Path: <linux-kernel-owner+w=401wt.eu-S932948AbXBLDii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbXBLDii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXBLDii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:38:38 -0500
Received: from ozlabs.org ([203.10.76.45]:50880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbXBLDih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:38:37 -0500
Subject: [PATCH 6/7] cleanup: Remove extern declaration from
	mm/discontig.c, put in header.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1171251406.10409.13.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
	 <1171251406.10409.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:37:51 +1100
Message-Id: <1171251471.10409.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations belong in headers.  Times, they are a'changin.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/arch/i386/mm/discontig.c
+++ b/arch/i386/mm/discontig.c
@@ -101,7 +101,6 @@ extern void add_one_highpage_init(struct
 extern void add_one_highpage_init(struct page *, int, int);
 
 extern struct e820map e820;
-extern unsigned long init_pg_tables_end;
 extern unsigned long highend_pfn, highstart_pfn;
 extern unsigned long max_low_pfn;
 extern unsigned long totalram_pages;
===================================================================
--- a/include/asm-i386/setup.h
+++ b/include/asm-i386/setup.h
@@ -77,6 +77,8 @@ void __init add_memory_region(unsigned l
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
 
+extern unsigned long init_pg_tables_end;
+
 #endif /* __ASSEMBLY__ */
 
 #endif  /*  __KERNEL__  */


