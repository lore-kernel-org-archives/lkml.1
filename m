Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbXGSKRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbXGSKRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762289AbXGSJz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:33107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759615AbXGSJze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:34 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: bunk@stusta.de, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [40/58] i386: remapped_pgdat_init() static
Message-Id: <20070719095526.746E714E0A@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/setup.c
===================================================================
--- linux.orig/arch/i386/kernel/setup.c
+++ linux/arch/i386/kernel/setup.c
@@ -466,7 +466,7 @@ void __init setup_bootmem_allocator(void
  *
  * This should all compile down to nothing when NUMA is off.
  */
-void __init remapped_pgdat_init(void)
+static void __init remapped_pgdat_init(void)
 {
 	int nid;
 
