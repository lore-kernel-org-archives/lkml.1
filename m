Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbXBNAjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbXBNAjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbXBNAjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:39:48 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40583 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbXBNAjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:39:48 -0500
Date: Wed, 14 Feb 2007 01:39:42 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mark Lord <mlord@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070214003942.4331.78713.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] ide/pci/delkin_cb.c: pci_module_init to pci_register_driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index e2672fc..d4b753e 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -122,7 +122,7 @@ static struct pci_driver driver = {
 static int
 delkin_cb_init (void)
 {
-	return pci_module_init(&driver);
+	return pci_register_driver(&driver);
 }
 
 static void
