Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbXBXKrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbXBXKrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 05:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933495AbXBXKq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 05:46:59 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35615 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487AbXBXKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 05:46:48 -0500
Date: Sat, 24 Feb 2007 11:46:37 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: driver-support@fabric7.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070224104634.20864.96190.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH -mm] drivers/net/vioc/vioc_driver.c: Replace pci_module_init with pci_register_driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pci_module_init with pci_register_driver

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
---
Not compile-tested (but should be correct!)

--- a/drivers/net/vioc/vioc_driver.c	2007-02-24 10:04:03.000000000 +0100
+++ b/drivers/net/vioc/vioc_driver.c	2007-02-24 10:05:01.000000000 +0100
@@ -841,9 +841,9 @@ static int __init vioc_module_init(void)
 	vioc_irq_init();
 	spp_init();
 
-	ret = pci_module_init(&vioc_driver);
+	ret = pci_register_driver(&vioc_driver);
 	if (ret) {
-		printk(KERN_ERR "%s: pci_module_init() -> %d\n", __FUNCTION__,
+		printk(KERN_ERR "%s: pci_register_driver() -> %d\n", __FUNCTION__,
 		       ret);
 		vioc_irq_exit();
 		return ret;
