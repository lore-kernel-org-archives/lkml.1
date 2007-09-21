Return-Path: <linux-kernel-owner+w=401wt.eu-S1765380AbXIUU7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765380AbXIUU7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763545AbXIUUpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:33049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762879AbXIUUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:28 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: jesper.juhl@gmail.com, jeremy@goop.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [43/45] i386: Clean up duplicate includes in arch/i386/xen/
Message-Id: <20070921204526.9BA3614EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	arch/i386/xen/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/enlighten.c |    1 -
 arch/i386/xen/mmu.c       |    1 -
 2 files changed, 2 deletions(-)

Index: linux/arch/i386/xen/enlighten.c
===================================================================
--- linux.orig/arch/i386/xen/enlighten.c
+++ linux/arch/i386/xen/enlighten.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
-#include <linux/smp.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
Index: linux/arch/i386/xen/mmu.c
===================================================================
--- linux.orig/arch/i386/xen/mmu.c
+++ linux/arch/i386/xen/mmu.c
@@ -41,7 +41,6 @@
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/bug.h>
-#include <linux/sched.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
