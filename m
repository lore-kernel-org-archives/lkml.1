Return-Path: <linux-kernel-owner+w=401wt.eu-S1751645AbZLVI3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbZLVI3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZLVI3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:29:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:51763 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751069AbZLVI3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:29:30 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18XB4F+HC0XG60IzEP4gAn7xlfWFqdIOqwl5srTIo
	ghg0osjR5uUWVz
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       "David S. Miller" <davem@davemloft.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ide: add __init/__exit macros to drivers/ide/scc_pata.c
Date: Tue, 22 Dec 2009 09:29:24 +0100
Message-Id: <1261470564-23754-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de>
References: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/ide/scc_pata.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/ide/scc_pata.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 1104bb3..58c9c91 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -872,14 +872,14 @@ static struct pci_driver scc_pci_driver = {
 	.remove = __devexit_p(scc_remove),
 };
 
-static int scc_ide_init(void)
+static int __init scc_ide_init(void)
 {
 	return ide_pci_register_driver(&scc_pci_driver);
 }
 
 module_init(scc_ide_init);
 /* -- No exit code?
-static void scc_ide_exit(void)
+static void __exit scc_ide_exit(void)
 {
 	ide_pci_unregister_driver(&scc_pci_driver);
 }
-- 
1.6.4.4

