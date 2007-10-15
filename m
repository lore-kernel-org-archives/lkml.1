Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXJOVtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXJOVtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbXJOVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:13 -0400
Received: from zrnetservice.com ([209.133.52.163]:33156 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756286AbXJOVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:07 -0400
Message-Id: <20071015210114.891237072@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 04/12] Clean up duplicate includes in arch/i386/xen/
Content-Disposition: inline; filename=xen-clean-up-duplicate-includes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up duplicate includes in
	arch/i386/xen/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/xen/enlighten.c |    1 -
 arch/x86/xen/mmu.c       |    2 --
 2 files changed, 3 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
-#include <linux/smp.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4ae038a..35691a2 100644
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
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

