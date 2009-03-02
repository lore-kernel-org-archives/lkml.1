Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZCBQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZCBQ6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758434AbZCBQ5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:39 -0500
Received: from mx1.emlix.com ([193.175.82.87]:45599 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbZCBQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:38 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:42:59 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/7] xtensa: remove redefinition of XCHAL_MMU_ASID_BITS
Content-Disposition: inline; filename=xtensa-remove-XCHAL_MMU_ASID_BITS-redefinition.patch
Message-Id: <E1LeBSS-0003Yv-QG@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This constant is defined in all core headers.  Remove the redundant
definition which might error out if other includes lead to inclusion
of <variant/core.h>.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/include/asm/mmu_context.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/mmu_context.h
+++ b/arch/xtensa/include/asm/mmu_context.h
@@ -16,13 +16,13 @@
 #include <linux/stringify.h>
 #include <linux/sched.h>
 
+#include <variant/core.h>
+
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
 
-#define XCHAL_MMU_ASID_BITS	8
-
 #if (XCHAL_HAVE_TLBS != 1)
 # error "Linux must have an MMU!"
 #endif

-- 

