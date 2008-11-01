Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYKASVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYKASVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYKASUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:20:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58325 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYKASUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:20:23 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] el3_common_init() should be __devinit, not __init
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 01 Nov 2008 18:20:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/3c509.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/3c509.c b/drivers/net/3c509.c
index 3a7bc52..c7a4f3b 100644
--- a/drivers/net/3c509.c
+++ b/drivers/net/3c509.c
@@ -94,7 +94,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-static char version[] __initdata = DRV_NAME ".c:" DRV_VERSION " " DRV_RELDATE " becker@scyld.com\n";
+static char version[] __devinitdata = DRV_NAME ".c:" DRV_VERSION " " DRV_RELDATE " becker@scyld.com\n";
 
 #ifdef EL3_DEBUG
 static int el3_debug = EL3_DEBUG;
@@ -186,7 +186,7 @@ static int max_interrupt_work = 10;
 static int nopnp;
 #endif
 
-static int __init el3_common_init(struct net_device *dev);
+static int __devinit el3_common_init(struct net_device *dev);
 static void el3_common_remove(struct net_device *dev);
 static ushort id_read_eeprom(int index);
 static ushort read_eeprom(int ioaddr, int index);
@@ -537,7 +537,7 @@ static struct mca_driver el3_mca_driver = {
 static int mca_registered;
 #endif /* CONFIG_MCA */
 
-static int __init el3_common_init(struct net_device *dev)
+static int __devinit el3_common_init(struct net_device *dev)
 {
 	struct el3_private *lp = netdev_priv(dev);
 	int err;
-- 
1.5.6.5


