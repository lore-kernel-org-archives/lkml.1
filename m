Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbZHWABN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbZHWABN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 20:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbZHWABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 20:01:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:50507 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933333AbZHWABL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 20:01:11 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19YlUhYkpZY0Sd6FOo+XFs/uDFfpIEnVUe6Wz8tkJ
	c9yP/JVN7NZdOH
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] gpio: adding __init/__exit macros in drivers/gpio/bt8xxgpio.c
Date: Sun, 23 Aug 2009 02:01:10 +0200
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908230201.10471.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macro to the init/exit functions of
drivers/gpio/bt8xxgpio.c

Michael, Kay or Greg, please have a look at the small patch and either pull it
through your tree, or please ack' it so Jiri can pull it through the trivial
tree.

linux version 2.6.31-rc7 - linus git tree, So 23. Aug 01:38:43 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index 984b587..5590414 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -331,13 +331,13 @@ static struct pci_driver bt8xxgpio_pci_driver = {
 	.resume		= bt8xxgpio_resume,
 };
 
-static int bt8xxgpio_init(void)
+static int __init bt8xxgpio_init(void)
 {
 	return pci_register_driver(&bt8xxgpio_pci_driver);
 }
 module_init(bt8xxgpio_init)
 
-static void bt8xxgpio_exit(void)
+static void __exit bt8xxgpio_exit(void)
 {
 	pci_unregister_driver(&bt8xxgpio_pci_driver);
 }
