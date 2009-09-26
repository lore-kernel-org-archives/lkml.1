Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZIZOMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZIZOMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZIZOMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:12:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZIZOMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:12:12 -0400
Subject: [PATCH] ARM: OMAP: Remove unused CONFIG MACH_OMAP_HTCWIZARD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Zebediah C. McClure" <zmc@lurian.net>, Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 19:41:43 +0530
Message-Id: <1253974303.4568.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unused CONFIG MACH_OMAP_HTCWIZARD from Kconfig

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Zebediah C. McClure <zmc@lurian.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
---
 arch/arm/mach-omap1/Kconfig |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 55ecc01..c25038e 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -50,12 +50,6 @@ config MACH_OMAP_H3
 	  TI OMAP 1710 H3 board support. Say Y here if you have such
 	  a board.
 
-config MACH_OMAP_HTCWIZARD
-	bool "HTC Wizard"
-	depends on ARCH_OMAP850
-	help
-	  HTC Wizard smartphone support (AKA QTEK 9100, ...)
-
 config MACH_OMAP_OSK
 	bool "TI OSK Support"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
-- 
1.6.0.6


