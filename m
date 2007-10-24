Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXJXCGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXJXCGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXJXCEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:24 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34306 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754896AbXJXCEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:22 -0400
Date: Wed, 24 Oct 2007 12:03:46 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23ken016670@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: mark mem init functions as __init
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the m68knommu memory init functions as __init.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-git19/arch/m68knommu/mm/init.c linux-2.6.23-git19.hacked/arch/m68knommu/mm/init.c
--- linux-2.6.23-git19/arch/m68knommu/mm/init.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23-git19.hacked/arch/m68knommu/mm/init.c	2007-10-24 11:37:48.000000000 +1000
@@ -98,7 +98,7 @@ extern unsigned long memory_end;
  * The parameters are pointers to where to stick the starting and ending
  * addresses of available kernel virtual memory.
  */
-void paging_init(void)
+void __init paging_init(void)
 {
 	/*
 	 * Make sure start_mem is page aligned, otherwise bootmem and
@@ -147,7 +147,7 @@ void paging_init(void)
 	}
 }
 
-void mem_init(void)
+void __init mem_init(void)
 {
 	int codek = 0, datak = 0, initk = 0;
 	unsigned long tmp;
