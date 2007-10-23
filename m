Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXJWEki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXJWEki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXJWEi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:38:57 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58874 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574AbXJWEiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:38:55 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bsdl001788@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add config support for Savant/Rosie1 board
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wilson Callan <wcallan@savantav.com>

Add configure support for the Savant/Rosie1 board.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/Kconfig linux-2.6.23-uc0/arch/m68knommu/Kconfig
--- linux-2.6.23/arch/m68knommu/Kconfig	2007-10-19 10:30:57.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/Kconfig	2007-10-19 10:35:41.000000000 +1000
@@ -451,6 +451,12 @@ config MOD5272
 	help
 	  Support for the Netburner MOD-5272 board.
 
+config SAVANTrosie1
+	bool "Savant Rosie1 board support"
+	depends on M523x
+	help
+	  Support for the Savant Rosie1 board.
+
 config ROMFS_FROM_ROM
 	bool "ROMFS image not RAM resident"
 	depends on (NETtel || SNAPGEAR)
@@ -492,7 +498,12 @@ config SNEHA
         bool
 	default y
 	depends on CPU16B
-	
+
+config SAVANT
+	bool
+	default y
+	depends on SAVANTrosie1
+
 config AVNET
 	bool
 	default y
