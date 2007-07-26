Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbXGZQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbXGZQdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933975AbXGZQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:33:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941AbXGZQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:33:10 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] sun userflash is PCI-dependent
Cc: linux-kernel@vger.kernel.org, dwm2@infradead.org
Message-Id: <E1IE6Gz-0005Aa-H4@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:33:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/mtd/maps/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index f88ebc5..cc6c734 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -103,7 +103,7 @@ config MTD_PMC_MSP_RAMROOT
 
 config MTD_SUN_UFLASH
 	tristate "Sun Microsystems userflash support"
-	depends on SPARC && MTD_CFI
+	depends on SPARC && MTD_CFI && PCI
 	help
 	  This provides a 'mapping' driver which supports the way in
 	  which user-programmable flash chips are connected on various
-- 
1.5.3.GIT

