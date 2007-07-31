Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbXGaNKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbXGaNKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXGaNJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:26 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761350AbXGaNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:25 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125442.568820000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:24 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Matthew Wilcox <matthew@will.cx>
Subject: [Patch 08/16] Remove unnecessary kmalloc casts in the parisc drivers.
Content-Disposition: inline; filename=drivers_parisc_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Matthew Wilcox <matthew@will.cx>

---
 drivers/parisc/iosapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/parisc/iosapic.c
===================================================================
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -243,7 +243,7 @@ static struct irt_entry *iosapic_alloc_i
 	 * if CONFIG_DEBUG_SLAB is enabled, then we can get only
 	 * 4-byte alignment on 32-bit kernels
 	 */
-	a = (unsigned long)kmalloc(sizeof(struct irt_entry) * num_entries + 8, GFP_KERNEL);
+	a = kmalloc(sizeof(struct irt_entry) * num_entries + 8, GFP_KERNEL);
 	a = (a + 7UL) & ~7UL;
 	return (struct irt_entry *)a;
 }

-- 
