Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYJVJ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYJVJ7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYJVJ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:58:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45005 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752550AbYJVJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:58:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Make WM8400 depend on I2C until SPI is submitted
Date: Wed, 22 Oct 2008 10:58:36 +0100
Message-Id: <1224669516-16538-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1224669516-16538-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1224669516-16538-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we could build in WM8400 but not I2C.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5a79d2d..75cdcf5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -105,6 +105,7 @@ config MFD_TC6393XB
 
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
+	depends on I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
 	  CODEC.  This driver adds provides common support for accessing
-- 
1.5.6.5

