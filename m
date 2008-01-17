Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYAQVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYAQVmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYAQVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:19 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44743 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbYAQVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:18 -0500
Date: Thu, 17 Jan 2008 16:40:44 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/20] UML - Remove unused fields from mm_context
Message-ID: <20080117214044.GA6742@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3-level page table fixes forgot to remove a couple now-unused
fields from struct mm_context.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/um_mmu.h |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.22/arch/um/include/um_mmu.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/um_mmu.h	2007-12-19 13:17:20.000000000 -0500
+++ linux-2.6.22/arch/um/include/um_mmu.h	2007-12-19 19:34:49.000000000 -0500
@@ -12,10 +12,6 @@
 
 typedef struct mm_context {
 	struct mm_id id;
-	unsigned long last_page_table;
-#ifdef CONFIG_3_LEVEL_PGTABLES
-	unsigned long last_pmd;
-#endif
 	struct uml_ldt ldt;
 } mm_context_t;
 
