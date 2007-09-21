Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbXIUU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbXIUU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763483AbXIUUpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:50101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbXIUUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:24 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: rpjday@mindspring.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [40/45] i386: deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
Message-Id: <20070921204523.6CABA14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/vmi.c
===================================================================
--- linux.orig/arch/i386/kernel/vmi.c
+++ linux/arch/i386/kernel/vmi.c
@@ -242,7 +242,7 @@ static void vmi_nop(void)
 {
 }
 
-#ifdef CONFIG_DEBUG_PAGE_TYPE
+#if 0 /* debug page type */
 
 #ifdef CONFIG_X86_PAE
 #define MAX_BOOT_PTS (2048+4+1)
@@ -343,7 +343,7 @@ static void vmi_check_page_type(u32 pfn,
 #else
 #define vmi_set_page_type(p,t) do { } while (0)
 #define vmi_check_page_type(p,t) do { } while (0)
-#endif
+#endif /* debug page type */
 
 #ifdef CONFIG_HIGHPTE
 static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
