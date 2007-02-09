Return-Path: <linux-kernel-owner+w=401wt.eu-S1946500AbXBIPFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946500AbXBIPFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946503AbXBIPFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:05:36 -0500
Received: from ozlabs.org ([203.10.76.45]:47172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946500AbXBIPFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:05:34 -0500
Subject: [PATCH 3 of 7]  lguest: Remove extern declaration from
	mm/discontig.c, put in header.
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171033436.2718.165.camel@localhost.localdomain>
References: <1171033146.2718.157.camel@localhost.localdomain>
	 <1171033383.2718.163.camel@localhost.localdomain>
	 <1171033436.2718.165.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 02:04:44 +1100
Message-Id: <1171033484.2718.167.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lguest wants it too, but Andi won't let me put an extern decl in.
Times, they are a'changin.

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


