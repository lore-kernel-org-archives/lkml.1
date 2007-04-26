Return-Path: <linux-kernel-owner+w=401wt.eu-S1031420AbXDZSp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031420AbXDZSp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031436AbXDZSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:45:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58088 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031420AbXDZSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:45:27 -0400
X-Originating-Ip: 74.109.98.66
Date: Thu, 26 Apr 2007 14:44:56 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] KCONFIG: Replace remaining "depends" with "depends on".
Message-ID: <Pine.LNX.4.64.0704261438050.8338@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace the few remaining instances of "depends" in the Kconfig files
with the new standard of "depends on".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  for what i hope is the *very* *last* *time*, replace the deprecated
"depends" (and, for the sake of historical completeness, "requires")
Kconfig directives with the consensus of "depends on".  to be frank,
it's getting increasingly annoying to run my aesthetics script and
watch as old instances of this get deleted, only to be replaced with
new instances.

  once this patch goes in, i would be happy to go into the Kconfig
parser and rip out the %#$^%&#%$^ code that recognizes anything except
"depends on".

 arch/powerpc/Kconfig       |    2 +-
 arch/powerpc/Kconfig.debug |    2 +-
 drivers/leds/Kconfig       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index d39d133..5c11b47 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -125,7 +125,7 @@ config BDI_SWITCH

 config BOOTX_TEXT
 	bool "Support for early boot text console (BootX or OpenFirmware only)"
-	depends PPC_OF
+	depends on PPC_OF
 	help
 	  Say Y here to see progress messages from the boot firmware in text
 	  mode. Requires either BootX or Open Firmware.
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
