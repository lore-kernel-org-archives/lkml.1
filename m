Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZHRWyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZHRWyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZHRWyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:54:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42823 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZHRWyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:54:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 18 Aug 2009 23:54:05 +0100
Message-Id: <1250636045-23014-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: Make MC13783 driver depend on SPI
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atlas chips need SPI to be enabled for chip access, if it is not
available build failures result due to the use of the SPI APIs for
register I/O.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 960c9d4..a4f3dff 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -240,6 +240,7 @@ config MFD_PCF50633
 
 config MFD_MC13783
 	tristate "Support Freescale MC13783"
+	depends on SPI_MASTER
 	select MFD_CORE
 	help
 	  Support for the Freescale (Atlas) MC13783 PMIC and audio CODEC.
-- 
1.6.3.3

