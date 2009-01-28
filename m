Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZA1X3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZA1X3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbZA1X2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:12 -0500
Received: from kroah.org ([198.145.64.141]:56978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753553AbZA1X2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/10] Staging: meilhaus: fix Kbuild
Date: Wed, 28 Jan 2009 15:26:42 -0800
Message-Id: <1233185210-23098-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Meilhaus drivers do not like being built into the kernel right now,
so force them to be a module.

Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/meilhaus/Kconfig |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/meilhaus/Kconfig b/drivers/staging/meilhaus/Kconfig
index 6def83f..923af22 100644
--- a/drivers/staging/meilhaus/Kconfig
+++ b/drivers/staging/meilhaus/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig MEILHAUS
 	tristate "Meilhaus support"
+	depends on m
 	---help---
 	  If you have a Meilhaus card, say Y (or M) here.
 
@@ -18,7 +19,7 @@ if MEILHAUS
 config ME0600
 	tristate "Meilhaus ME-600 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-600 family of boards
 	  that do data collection and multipurpose I/O.
@@ -29,7 +30,7 @@ config ME0600
 config ME0900
 	tristate "Meilhaus ME-900 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-900 family of boards
 	  that do data collection and multipurpose I/O.
@@ -40,7 +41,7 @@ config ME0900
 config ME1000
 	tristate "Meilhaus ME-1000 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-1000 family of boards
 	  that do data collection and multipurpose I/O.
@@ -51,7 +52,7 @@ config ME1000
 config ME1400
 	tristate "Meilhaus ME-1400 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-1400 family of boards
 	  that do data collection and multipurpose I/O.
@@ -62,7 +63,7 @@ config ME1400
 config ME1600
 	tristate "Meilhaus ME-1600 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-1600 family of boards
 	  that do data collection and multipurpose I/O.
@@ -73,7 +74,7 @@ config ME1600
 config ME4600
 	tristate "Meilhaus ME-4600 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-4600 family of boards
 	  that do data collection and multipurpose I/O.
@@ -84,7 +85,7 @@ config ME4600
 config ME6000
 	tristate "Meilhaus ME-6000 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-6000 family of boards
 	  that do data collection and multipurpose I/O.
@@ -95,7 +96,7 @@ config ME6000
 config ME8100
 	tristate "Meilhaus ME-8100 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-8100 family of boards
 	  that do data collection and multipurpose I/O.
@@ -106,7 +107,7 @@ config ME8100
 config ME8200
 	tristate "Meilhaus ME-8200 support"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This driver supports the Meilhaus ME-8200 family of boards
 	  that do data collection and multipurpose I/O.
@@ -117,7 +118,7 @@ config ME8200
 config MEDUMMY
 	tristate "Meilhaus dummy driver"
 	default n
-	depends on PCI
+	depends on PCI && m
 	help
 	  This provides a dummy driver for the Meilhaus driver package
 
-- 
1.6.0.2

