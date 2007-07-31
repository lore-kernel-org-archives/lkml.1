Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbXGaNJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbXGaNJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbXGaNJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:08 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759328AbXGaNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:07 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125443.880871000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:25 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Patch 09/16] Remove unnecessary kmalloc casts in the pci subsystem.
Content-Disposition: inline; filename=drivers_pci_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/rom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/pci/rom.c
===================================================================
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -185,7 +185,7 @@ void __iomem *pci_map_rom_copy(struct pc
 			  IORESOURCE_ROM_BIOS_COPY))
 		return rom;
 
-	res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
+	res->start = kmalloc(*size, GFP_KERNEL);
 	if (!res->start)
 		return rom;
 

-- 
