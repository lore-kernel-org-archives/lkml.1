Return-Path: <linux-kernel-owner+w=401wt.eu-S1750915AbXBXKqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915AbXBXKqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 05:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933487AbXBXKqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 05:46:36 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35607 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbXBXKqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 05:46:35 -0500
Date: Sat, 24 Feb 2007 11:46:06 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Vincent Sanders <vince@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070224104603.20765.30521.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/mfd/sm501.c: Replace pci_module_init with pci_register_driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pci_module_init with pci_register_driver

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 5c5a1e2..c707c8e 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1131,7 +1131,7 @@ static struct platform_driver sm501_plat_drv = {
 static int __init sm501_base_init(void)
 {
 	platform_driver_register(&sm501_plat_drv);
-	return pci_module_init(&sm501_pci_drv);
+	return pci_register_driver(&sm501_pci_drv);
 }
 
 static void __exit sm501_base_exit(void)
