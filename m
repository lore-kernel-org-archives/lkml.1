Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXHXSrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXHXSrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763374AbXHXSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:46:40 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60513 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762995AbXHXSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:46:38 -0400
Date: Fri, 24 Aug 2007 14:46:16 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Message-ID: <20070824184616.GA9442@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This looks non-urgent to me ]

Without linux/pagemap.h, asm-generic/tlb.h is missing declarations of
page_cache_release and release_pages.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-generic/tlb.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.22.orig/include/asm-generic/tlb.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-generic/tlb.h	2007-08-22 17:29:45.000000000 -0400
@@ -13,6 +13,7 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
