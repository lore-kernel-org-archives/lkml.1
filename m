Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbXJLVpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbXJLVpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbXJLVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:37 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42256 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760300AbXJLVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:36 -0400
Message-Id: <20071012211147.800072000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 02/10] Clean up duplicate includes in arch/i386/xen/
Content-Disposition: inline; filename=xen-clean-up-duplicate-includes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up duplicate includes in
	arch/i386/xen/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/i386/xen/enlighten.c |    1 -
 arch/i386/xen/mmu.c       |    2 --
 2 files changed, 3 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
-#include <linux/smp.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
diff --git a/arch/i386/xen/mmu.c b/arch/i386/xen/mmu.c
index 4ae038a..35691a2 100644
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -41,7 +41,6 @@
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/bug.h>
-#include <linux/sched.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

-- 

