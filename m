Return-Path: <linux-kernel-owner+w=401wt.eu-S1763105AbYEWGYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105AbYEWGYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYEWGX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:23:58 -0400
Received: from mx1.intellilink.co.jp ([61.115.5.245]:4263 "EHLO
	intellilink.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752325AbYEWGX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:23:57 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2008 02:23:57 EDT
Subject: [PATCH] cris: remove unused global_flush_tlb
From: Fernando Luis Vazquez Cao <fernando@intellilink.co.jp>
To: akpm@linux-foundation.org
Cc: starvik@axis.com, jesper.nilsson@axis.com, dev-etrax@axis.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Data Intellilink
Date: Fri, 23 May 2008 15:36:31 +0900
Message-Id: <1211524591.2719.11.camel@nausicaa.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

global_flush_tlb is declared but never used.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26-rc3-git4-orig/include/asm-cris/cacheflush.h linux-2.6.26-rc3-git4/include/asm-cris/cacheflush.h
--- linux-2.6.26-rc3-git4-orig/include/asm-cris/cacheflush.h	2008-04-17 11:49:44.000000000 +0900
+++ linux-2.6.26-rc3-git4/include/asm-cris/cacheflush.h	2008-05-23 15:19:26.000000000 +0900
@@ -26,7 +26,6 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-void global_flush_tlb(void); 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 
 #endif /* _CRIS_CACHEFLUSH_H */


