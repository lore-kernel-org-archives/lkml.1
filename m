Return-Path: <linux-kernel-owner+w=401wt.eu-S1767563AbXDFKUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767563AbXDFKUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767560AbXDFKTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:19:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44147 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767561AbXDFKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:19:37 -0400
Date: Fri, 6 Apr 2007 12:19:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?Q?Hans-J=C3=BCrgen?= Koch <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: tglx@linutronix.de, Benedikt Spranger <b.spranger@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/uio/uio_cif.c: convert pci_module_init()
Message-ID: <20070406101937.GD29169@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the pci_module_init() usage to pci_register_driver().

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm4/drivers/uio/uio_cif.c.old	2007-04-05 20:44:24.000000000 +0200
+++ linux-2.6.21-rc5-mm4/drivers/uio/uio_cif.c	2007-04-05 20:44:38.000000000 +0200
@@ -144,7 +144,7 @@
 
 static int __init hilscher_init_module(void)
 {
-	return pci_module_init(&hilscher_pci_driver);
+	return pci_register_driver(&hilscher_pci_driver);
 }
 
 static void __exit hilscher_exit_module(void)

