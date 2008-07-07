Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYGGTjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYGGTjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYGGTji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:39:38 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43098 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYGGTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:39:38 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: millet@isir.fr, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Misc: phantom, note PCI
Date: Mon,  7 Jul 2008 21:39:10 +0200
Message-Id: <1215459550-8785-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell users, that the driver is only for PCI devices to stop asking for
support of firewire and parallel devices.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/misc/Kconfig   |    4 +++-
 drivers/misc/phantom.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 780c99b..364dc53 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -77,11 +77,13 @@ config IBM_ASM
 	  for your IBM server.
 
 config PHANTOM
-	tristate "Sensable PHANToM"
+	tristate "Sensable PHANToM (PCI)"
 	depends on PCI
 	help
 	  Say Y here if you want to build a driver for Sensable PHANToM device.
 
+	  This driver is only for PCI PHANToMs.
+
 	  If you choose to build module, its name will be phantom. If unsure,
 	  say N here.
 
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 4ce3bdc..daf5856 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -563,6 +563,6 @@ module_init(phantom_init);
 module_exit(phantom_exit);
 
 MODULE_AUTHOR("Jiri Slaby <jirislaby@gmail.com>");
-MODULE_DESCRIPTION("Sensable Phantom driver");
+MODULE_DESCRIPTION("Sensable Phantom driver (PCI devices)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(PHANTOM_VERSION);
-- 
1.5.6.1

