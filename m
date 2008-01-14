Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYANWY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYANWY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYANWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:59979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbYANWQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:55 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [20/31] CPA: Fix inaccurate comments in 64bit change_page_attr()
Message-Id: <20080114221653.0A51014F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No code changes.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -120,7 +120,7 @@ static void flush_kernel_map(void *arg)
 		wbinvd();
 }
 
-/* both protected by init_mm.mmap_sem */
+/* All protected by init_mm.mmap_sem */
 static enum flush_mode full_flush;
 static LIST_HEAD(deferred_pages);
 static LIST_HEAD(flush_pages);
@@ -132,7 +132,7 @@ static inline void save_page(struct page
 }
 
 /* 
- * No more special protections in this 2/4MB area - revert to a
+ * No more special protections in this 2MB area - revert to a
  * large page again. 
  */
 static void revert_page(unsigned long address, pgprot_t ref_prot)
