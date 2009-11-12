Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZKLUoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZKLUoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZKLUoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:44:32 -0500
Received: from mail.df.lth.se ([194.47.250.12]:37718 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754212AbZKLUob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:44:31 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Remove default selection of AB4500
Date: Thu, 12 Nov 2009 21:44:27 +0100
Message-Id: <1258058667-16722-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This remove the default 'y' selection of AB4500, currently everyone
enabling the SPI subsystem will get a copy of this driver.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
---
 drivers/mfd/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1d5370..b46b11b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -342,7 +342,6 @@ config MFD_88PM8607
 config AB4500_CORE
 	tristate "ST-Ericsson's AB4500 Mixed Signal Power management chip"
 	depends on SPI
-	default y
 	help
 	  Select this option to enable access to AB4500 power management
 	  chip. This connects to U8500 on the SSP/SPI bus and exports
-- 
1.6.3.3

