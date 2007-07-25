Return-Path: <linux-kernel-owner+w=401wt.eu-S1764785AbXGYMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764785AbXGYMLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760574AbXGYMIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:53 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33042 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758776AbXGYMIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:51 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7Kjk032168@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add configure support for Intec boards
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add configure support for the Intec Wildfire and WildFireMod boards.

Signed-Off-By: Steve Bennett <steveb@workware.net.au>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.22/arch/m68knommu/Kconfig linux-2.6.22-uc0/arch/m68knommu/Kconfig
--- linux-2.6.22/arch/m68knommu/Kconfig	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/Kconfig	2007-07-12 15:27:03.000000000 +1000
@@ -338,6 +354,18 @@
 	depends on M528x
 	help
 	  Support for the EMAC.Inc SOM5282EM module.  
+	  
+config WILDFIRE
+	bool "Intec Automation Inc. WildFire board support"
+	depends on M528x
+	help
+	  Support for the Intec Automation Inc. WildFire.
+	  
+config WILDFIREMOD
+	bool "Intec Automation Inc. WildFire module support"
+	depends on M528x
+	help
+	  Support for the Intec Automation Inc. WildFire module.
 
 config ARN5307
 	bool "Arnewsh 5307 board support"
