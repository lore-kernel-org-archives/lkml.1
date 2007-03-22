Return-Path: <linux-kernel-owner+w=401wt.eu-S965770AbXCVGCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965770AbXCVGCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965793AbXCVGC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:02:29 -0400
Received: from ozlabs.org ([203.10.76.45]:41769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965780AbXCVGCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:02:11 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:00:30 +1100
Subject: [RFC/PATCH 3/15] get_unmapped_area handles MAP_FIXED on arm
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060210.E0374DDF2F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/arm/mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-cell/arch/arm/mm/mmap.c
===================================================================
--- linux-cell.orig/arch/arm/mm/mmap.c	2007-03-22 14:59:51.000000000 +1100
+++ linux-cell/arch/arm/mm/mmap.c	2007-03-22 15:00:01.000000000 +1100
@@ -49,8 +49,7 @@ arch_get_unmapped_area(struct file *filp
 #endif
 
 	/*
-	 * We should enforce the MAP_FIXED case.  However, currently
-	 * the generic kernel code doesn't allow us to handle this.
+	 * We enforce the MAP_FIXED case.
 	 */
 	if (flags & MAP_FIXED) {
 		if (aliasing && flags & MAP_SHARED && addr & (SHMLBA - 1))
