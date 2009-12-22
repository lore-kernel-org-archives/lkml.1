Return-Path: <linux-kernel-owner+w=401wt.eu-S1751808AbZLVI10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbZLVI10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZLVI1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:27:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:34436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751624AbZLVI1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:27:20 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+/Mux2fZy/WumVR8G6jZWHE6nvngUbNP2bNWBtCI
	gF1mokC0nBViMG
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Karsten Keil <isdn@linux-pingi.de>,
       =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] isdn/hardware: add __init/__exit macros to isdn/hardware/mISDN/mISDNisar.c
Date: Tue, 22 Dec 2009 09:27:06 +0100
Message-Id: <1261470431-23642-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/isdn/hardware/mISDN/mISDNisar.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/isdn/hardware/mISDN/mISDNisar.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index 09095c7..f0bc6fa 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -1712,13 +1712,13 @@ mISDNisar_init(struct isar_hw *isar, void *hw)
 }
 EXPORT_SYMBOL(mISDNisar_init);
 
-static int isar_mod_init(void)
+static int __init isar_mod_init(void)
 {
 	pr_notice("mISDN: ISAR driver Rev. %s\n", ISAR_REV);
 	return 0;
 }
 
-static void isar_mod_cleanup(void)
+static void __exit isar_mod_cleanup(void)
 {
 	pr_notice("mISDN: ISAR module unloaded\n");
 }
-- 
1.6.4.4

