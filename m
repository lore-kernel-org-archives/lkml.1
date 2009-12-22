Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbZLVIe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbZLVIe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZLVIey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:34:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:52722 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751090AbZLVIex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:34:53 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/AkAgZEczAOErvbcdlI8ZIG7qjATzKT3Q+KJ6WIG
	Zc4ihQNAp4XcWh
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Imre Deak <imre.deak@nokia.com>, Tony Lindgren <tony@atomide.com>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-fbdev@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] video/omap: add __init/__exit macros to drivers/video/omap/lcd_htcherald.c
Date: Tue, 22 Dec 2009 09:34:49 +0100
Message-Id: <1261470890-24031-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/video/omap/lcd_htcherald.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/omap/lcd_htcherald.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap/lcd_htcherald.c b/drivers/video/omap/lcd_htcherald.c
index a9007c5..4802419 100644
--- a/drivers/video/omap/lcd_htcherald.c
+++ b/drivers/video/omap/lcd_htcherald.c
@@ -115,12 +115,12 @@ struct platform_driver htcherald_panel_driver = {
 	},
 };
 
-static int htcherald_panel_drv_init(void)
+static int __init htcherald_panel_drv_init(void)
 {
 	return platform_driver_register(&htcherald_panel_driver);
 }
 
-static void htcherald_panel_drv_cleanup(void)
+static void __exit htcherald_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&htcherald_panel_driver);
 }
-- 
1.6.4.4

