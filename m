Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXGaNJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXGaNJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbXGaNJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:07 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbXGaNJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:06 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125439.789255000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:20 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, David Miller <davem@davemloft.net>
Subject: [Patch 04/16] Remove unnecessary kmalloc casts from the sparc arch.
Content-Disposition: inline; filename=arch_sparc_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: David Miller <davem@davemloft.net>

---
 arch/sparc/kernel/ebus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/sparc/kernel/ebus.c
===================================================================
--- a/arch/sparc/kernel/ebus.c
+++ b/arch/sparc/kernel/ebus.c
@@ -64,7 +64,7 @@ static struct ebus_device_irq *ebus_blac
  */
 static inline unsigned long ebus_alloc(size_t size)
 {
-	return (unsigned long)kmalloc(size, GFP_ATOMIC);
+	return kmalloc(size, GFP_ATOMIC);
 }
 
 /*

-- 
