Return-Path: <linux-kernel-owner+w=401wt.eu-S1767557AbXDFKTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767557AbXDFKTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767562AbXDFKTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:19:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44142 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767557AbXDFKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:19:33 -0400
Date: Fri, 6 Apr 2007 12:19:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ryan Jackson <rjackson@lnxi.com>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/mtd/maps/ck804xrom.c: convert pci_module_init()
Message-ID: <20070406101933.GC29169@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the pci_module_init() usage to pci_register_driver().

It's currently #if 0'ed, but still not a bad idea to change it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm4/drivers/mtd/maps/ck804xrom.c.old	2007-04-05 20:39:54.000000000 +0200
+++ linux-2.6.21-rc5-mm4/drivers/mtd/maps/ck804xrom.c	2007-04-05 20:40:15.000000000 +0200
@@ -338,7 +338,7 @@
 	}
 	return -ENXIO;
 #if 0
-	return pci_module_init(&ck804xrom_driver);
+	return pci_register_driver(&ck804xrom_driver);
 #endif
 }
 

