Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbXLBMBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbXLBMBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXLBMA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:00:58 -0500
Received: from elvis.franken.de ([193.175.24.41]:58694 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXLBMA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:00:57 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
cc: wim@iguana.be
Subject: [PATCH] WATCHDOG: Use SGI_HAS_INDYDOG for INDYDOG depends
Message-Id: <20071202115442.E7844C2EB5@solo.franken.de>
Date: Sun,  2 Dec 2007 12:54:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SGI_HAS_INDYDOG for INDYDOG depends.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

Please apply for 2.6.25.

 drivers/watchdog/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 2792bc1..1ba30cb 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -586,7 +586,7 @@ config SBC_EPX_C3_WATCHDOG
 
 config INDYDOG
 	tristate "Indy/I2 Hardware Watchdog"
-	depends on SGI_IP22
+	depends on SGI_HAS_INDYDOG
 	help
 	  Hardware driver for the Indy's/I2's watchdog. This is a
 	  watchdog timer that will reboot the machine after a 60 second
