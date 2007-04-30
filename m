Return-Path: <linux-kernel-owner+w=401wt.eu-S965536AbXD3Kau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536AbXD3Kau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965254AbXD3K2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:42977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbXD3K1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:53 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/40] i386: fix paravirt-documentation
Message-Id: <20070430102752.F2EFE151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Remove #defines, add enum for PARAVIRT_LAZY_FLUSH.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/paravirt.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

===================================================================
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -30,6 +30,7 @@ enum paravirt_lazy_mode {
 	PARAVIRT_LAZY_NONE = 0,
 	PARAVIRT_LAZY_MMU = 1,
 	PARAVIRT_LAZY_CPU = 2,
+	PARAVIRT_LAZY_FLUSH = 3,
 };
 
 struct paravirt_ops
@@ -1036,12 +1037,6 @@ static inline pte_t raw_ptep_get_and_cle
 }
 #endif	/* CONFIG_X86_PAE */
 
-/* Lazy mode for batching updates / context switch */
-#define PARAVIRT_LAZY_NONE 0
-#define PARAVIRT_LAZY_MMU  1
-#define PARAVIRT_LAZY_CPU  2
-#define PARAVIRT_LAZY_FLUSH 3
-
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 static inline void arch_enter_lazy_cpu_mode(void)
 {
