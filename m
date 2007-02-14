Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXBNAkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXBNAkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXBNAkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:40:45 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40616 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbXBNAko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:40:44 -0500
Date: Wed, 14 Feb 2007 01:40:21 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Krzysztof Halasa <khc@pm.waw.pl>, Andrew Morton <akpm@osdl.org>,
       Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070214004022.4455.49724.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] net/wan/pc300too.c: pci_module_init to pci_register_driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index bc156b5..aff05db 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -542,7 +542,7 @@ static int __init pc300_init_module(void)
 
 	CLOCK_BASE = use_crystal_clock ? 24576000 : pci_clock_freq;
 
-	return pci_module_init(&pc300_pci_driver);
+	return pci_register_driver(&pc300_pci_driver);
 }
 
 
