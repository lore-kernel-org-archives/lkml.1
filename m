Return-Path: <linux-kernel-owner+w=401wt.eu-S933091AbXBLHmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbXBLHmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXBLHiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:49628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXBLHiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:07 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [19/39] x86_64: remove get_pmd()
Message-Id: <20070212073806.9A17913D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Function is dead.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/pgalloc.h |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/include/asm-x86_64/pgalloc.h
===================================================================
--- linux.orig/include/asm-x86_64/pgalloc.h
+++ linux/include/asm-x86_64/pgalloc.h
@@ -18,11 +18,6 @@ static inline void pmd_populate(struct m
 	set_pmd(pmd, __pmd(_PAGE_TABLE | (page_to_pfn(pte) << PAGE_SHIFT)));
 }
 
-static inline pmd_t *get_pmd(void)
-{
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL);
-}
-
 static inline void pmd_free(pmd_t *pmd)
 {
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
