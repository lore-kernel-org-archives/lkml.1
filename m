Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbXGQHts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbXGQHts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXGQHth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50984 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbXGQHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:36 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] mark a bunch of ISA|EISA|PCI drivers as such
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Message-Id: <E1IAhoN-0001in-RQ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/Kconfig      |    8 ++++----
 drivers/telephony/Kconfig |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ec9dc3d..ab690a6 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -114,7 +114,7 @@ config COMPUTONE
 
 config ROCKETPORT
 	tristate "Comtrol RocketPort support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
 	help
 	  This driver supports Comtrol RocketPort and RocketModem PCI boards.   
           These boards provide 2, 4, 8, 16, or 32 high-speed serial ports or
@@ -157,7 +157,7 @@ config CYZ_INTR
 
 config DIGIEPCA
 	tristate "Digiboard Intelligent Async Support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
 	---help---
 	  This is a driver for Digi International's Xx, Xeve, and Xem series
 	  of cards which provide multiple serial ports. You would need
@@ -354,7 +354,7 @@ config STALDRV
 
 config STALLION
 	tristate "Stallion EasyIO or EC8/32 support"
-	depends on STALDRV && BROKEN_ON_SMP
+	depends on STALDRV && BROKEN_ON_SMP && (ISA || EISA || PCI)
 	help
 	  If you have an EasyIO or EasyConnection 8/32 multiport Stallion
 	  card, then this is for you; say Y.  Make sure to read
@@ -365,7 +365,7 @@ config STALLION
 
 config ISTALLION
 	tristate "Stallion EC8/64, ONboard, Brumby support"
-	depends on STALDRV && BROKEN_ON_SMP
+	depends on STALDRV && BROKEN_ON_SMP && (ISA || EISA || PCI)
 	help
 	  If you have an EasyConnection 8/64, ONboard, Brumby or Stallion
 	  serial multiport card, say Y here. Make sure to read
diff --git a/drivers/telephony/Kconfig b/drivers/telephony/Kconfig
index 8f530e6..5f98f67 100644
--- a/drivers/telephony/Kconfig
+++ b/drivers/telephony/Kconfig
@@ -19,6 +19,7 @@ if PHONE
 
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
+	depends ISA || PCI
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and
-- 
1.5.3.GIT


