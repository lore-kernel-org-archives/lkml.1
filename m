Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbXGaNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbXGaNLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXGaNJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:28 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760888AbXGaNJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:27 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125438.132063000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:17 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Mikael Starvik <starvik@axis.com>
Subject: [Patch 01/16] Remove unnecessary kmalloc casts from the cris arch.
Content-Disposition: inline; filename=arch_cris_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Mikael Starvik <starvik@axis.com>

---
 arch/cris/arch-v32/mm/intmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/cris/arch-v32/mm/intmem.c
===================================================================
--- a/arch/cris/arch-v32/mm/intmem.c
+++ b/arch/cris/arch-v32/mm/intmem.c
@@ -28,7 +28,7 @@ static void crisv32_intmem_init(void)
 	static int initiated = 0;
 	if (!initiated) {
 		struct intmem_allocation* alloc =
-		  (struct intmem_allocation*)kmalloc(sizeof *alloc, GFP_KERNEL);
+		  kmalloc(sizeof *alloc, GFP_KERNEL);
 		INIT_LIST_HEAD(&intmem_allocations);
 		intmem_virtual = ioremap(MEM_INTMEM_START, MEM_INTMEM_SIZE);
 		initiated = 1;

-- 
