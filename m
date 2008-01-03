Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYACPaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYACPaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYACPYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:42 -0500
Received: from ns1.suse.de ([195.135.220.2]:46759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbYACPYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:36 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [20/28] CPA: Fix inaccurate comments in 64bit change_page_attr()
Message-Id: <20080103152435.3F24314E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:35 +0100 (CET)
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
