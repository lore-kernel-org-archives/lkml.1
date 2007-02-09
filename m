Return-Path: <linux-kernel-owner+w=401wt.eu-S1946595AbXBIQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946595AbXBIQFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946594AbXBIQFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53643 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946590AbXBIQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:42 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] TIFM should depend on PCI - TIFM_CORE leads to use of pci primitives
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYFq-0004t4-1a@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/Kconfig |    2 +-
 drivers/mmc/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 89bba27..bedae4a 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -42,7 +42,7 @@ config SGI_IOC4
 
 config TIFM_CORE
 	tristate "TI Flash Media interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && PCI
 	help
 	  If you want support for Texas Instruments(R) Flash Media adapters
 	  you should select this option and then also choose an appropriate
diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
index 4224686..12af9c7 100644
--- a/drivers/mmc/Kconfig
+++ b/drivers/mmc/Kconfig
@@ -111,7 +111,7 @@ config MMC_IMX
 
 config MMC_TIFM_SD
 	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
-	depends on MMC && EXPERIMENTAL
+	depends on MMC && EXPERIMENTAL && PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MMC/SD cards with
-- 
1.5.0-rc2.GIT

