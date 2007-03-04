Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXCDLcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXCDLcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXCDLcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:32:13 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:45305 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXCDLcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:32:12 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Mar 2007 06:28:53 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] Kconfig:  Replace obsolete "depends" with "depends on".
Message-ID: <Pine.LNX.4.64.0703040624310.16583@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace the obsolete variant "depends" with the standardized form
"depends on" in Kconfig files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that "depends on" was accepted as the standard Kconfig
directive over "depends" and "requires", could we:

  1) please stop using "depends", and
  2) modify the actual parser to not accept anything *other* than
     "depends on"

  after all, there's no point in having applied all that
standardization if we just let the old form back into the tree.

 arch/powerpc/Kconfig |    2 +-
 drivers/leds/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6dfbd52..54a7fd0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -622,7 +622,7 @@ config RTAS_FLASH

 config PPC_PMI
 	tristate "Support for PMI"
-	depends PPC_IBM_CELL_BLADE
+	depends on PPC_IBM_CELL_BLADE
 	help
 	  PMI (Platform Management Interrupt) is a way to
 	  communicate with the BMC (Baseboard Mangement Controller).
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 80acd08..069b57d 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -84,7 +84,7 @@ config LEDS_WRAP

 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
-	depends LEDS_CLASS && ARCH_H1940
+	depends on LEDS_CLASS && ARCH_H1940
 	help
 	  This option enables support for the LEDs on the h1940.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
