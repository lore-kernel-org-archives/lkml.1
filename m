Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbXLBMBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbXLBMBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXLBMBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:01:03 -0500
Received: from elvis.franken.de ([193.175.24.41]:58705 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbXLBMBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:01:00 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
cc: akpm@linux-foundation.org
Subject: [PATCH] SERIAL: Use SGI_HAS_ZILOG for IP22_ZILOG depends
Message-Id: <20071202115533.9A8C8C2EB6@solo.franken.de>
Date: Sun,  2 Dec 2007 12:55:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use SGI_HAS_ZILOG for IP22_ZILOG depends
- remove IP22 from description, because the driver works on more than
  IP22 SGI machines

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

Please apply for 2.6.25.

 drivers/serial/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d7e1996..90eb9ce 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -877,15 +877,15 @@ config SERIAL_SUNHV
 	  systems.  Say Y if you want to be able to use this device.
 
 config SERIAL_IP22_ZILOG
-	tristate "IP22 Zilog8530 serial support"
-	depends on SGI_IP22
+	tristate "SGI Zilog8530 serial support"
+	depends on SGI_HAS_ZILOG
 	select SERIAL_CORE
 	help
-	  This driver supports the Zilog8530 serial ports found on SGI IP22
+	  This driver supports the Zilog8530 serial ports found on SGI 
 	  systems.  Say Y or M if you want to be able to these serial ports.
 
 config SERIAL_IP22_ZILOG_CONSOLE
-	bool "Console on IP22 Zilog8530 serial port"
+	bool "Console on SGI Zilog8530 serial port"
 	depends on SERIAL_IP22_ZILOG=y
 	select SERIAL_CORE_CONSOLE
 
