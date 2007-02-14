Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXBNAlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXBNAlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932115AbXBNAlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:41:13 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40629 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXBNAlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:41:07 -0500
Date: Wed, 14 Feb 2007 01:40:57 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070214004058.4566.91267.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] scsi/tmscsim.c: pci_module_init to pci_register_driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index fa5382e..ce8845e 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2681,7 +2681,7 @@ static int __init dc390_module_init(void)
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
