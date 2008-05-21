Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbYEUBNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbYEUBNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYEUBMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:12:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38202 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765548AbYEUBMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:12:18 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] HTC_EGPIO is ARM-only
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Message-Id: <E1JycsL-0000NA-3G@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:12:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 638
Lines: 22

driver uses symbols defined only on ARM

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 072b683..d83b50f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -25,7 +25,7 @@ config MFD_ASIC3
 
 config HTC_EGPIO
 	bool "HTC EGPIO support"
-	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB
+	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
-- 
1.5.3.GIT

