Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZI1XxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZI1XxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 19:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZI1XxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 19:53:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:58589 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753527AbZI1XxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 19:53:14 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18IY0Au8DwIR0eJNOscclF0i78O4fKnnm5grSpKx5
	CWP5x8lwj3teZy
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/phison:  adding __init/__exit macros
Date: Tue, 29 Sep 2009 01:53:16 +0200
User-Agent: KMail/1.9.10
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290153.16839.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of drivers/staging/phison/phison.c

Greg, please have a look at the small patch and either pull it through
your staging tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 270ebcb..3817d74 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -87,12 +87,12 @@ static struct pci_driver phison_pci_driver = {
 #endif
 };
 
-static int phison_ide_init(void)
+static int __init phison_ide_init(void)
 {
 	return pci_register_driver(&phison_pci_driver);
 }
 
-static void phison_ide_exit(void)
+static void __exit phison_ide_exit(void)
 {
 	pci_unregister_driver(&phison_pci_driver);
 }
