Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZKWNmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZKWNmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZKWNma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:42:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37013 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751022AbZKWNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:42:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Don't allow wm831x to be built as a module
Date: Mon, 23 Nov 2009 13:42:34 +0000
Message-Id: <1258983754-28430-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq infrastructure functions aren't currently exported,
preventing modular builds.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1d5370..7ef1ef4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -195,7 +195,7 @@ config MFD_WM8400
 	  the functionality of the device.
 
 config MFD_WM831X
-	tristate "Support Wolfson Microelectronics WM831x/2x PMICs"
+	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
 	select MFD_CORE
 	depends on I2C
 	help
-- 
1.6.5.2

