Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZLVIe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZLVIe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZLVIeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:34:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:46473 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750956AbZLVIeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:34:24 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+C5pZhkGuCqr2EmhBMSecZNL/R6fcsPY3+AEAwwX
	VRbnzcH/6hMuKx
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Marcel Holtmann <marcel@holtmann.org>, Bing Zhao <bzhao@marvell.com>,
       Ben Hutchings <ben@decadent.org.uk>,
       =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Julia Lawall <julia@diku.dk>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] bluetooth: add __init/__exit macros to drivers/bluetooth/btmrvl_sdio.c
Date: Tue, 22 Dec 2009 09:34:20 +0100
Message-Id: <1261470861-23988-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/bluetooth/btmrvl_sdio.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/bluetooth/btmrvl_sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index f36defa..e397170 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -975,7 +975,7 @@ static struct sdio_driver bt_mrvl_sdio = {
 	.remove		= btmrvl_sdio_remove,
 };
 
-static int btmrvl_sdio_init_module(void)
+static int __init btmrvl_sdio_init_module(void)
 {
 	if (sdio_register_driver(&bt_mrvl_sdio) != 0) {
 		BT_ERR("SDIO Driver Registration Failed");
@@ -988,7 +988,7 @@ static int btmrvl_sdio_init_module(void)
 	return 0;
 }
 
-static void btmrvl_sdio_exit_module(void)
+static void __exit btmrvl_sdio_exit_module(void)
 {
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
-- 
1.6.4.4

