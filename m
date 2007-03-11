Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbXCKS0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbXCKS0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933976AbXCKS0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:26:49 -0400
Received: from outmx018.isp.belgacom.be ([195.238.4.117]:39026 "EHLO
	outmx018.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975AbXCKS0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:26:48 -0400
Date: Sun, 11 Mar 2007 19:27:46 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [WATCHDOG] i8xx_tco - mark for removal patch
Message-ID: <20070311182746.GA2504@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm planning to remove the i8xx_tco watchdog driver
(since we now have the iTCO_wdt driver that has a broader scope).

If no-one objects I will sent the below patch to Linus for inclusion.
(it adds the driver to the feature-removal-schedule list and defaults
CONFIG_I8XX_TCO to n).

Thanks,
Wim.

================================================================================
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c3b1430..0bc8b0b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -316,3 +316,11 @@ Why:	The option/code is
 Who:	Johannes Berg <johannes@sipsolutions.net>
 
 ---------------------------
+
+What:	i8xx_tco watchdog driver
+When:	in 2.6.22
+Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
+	watchdog driver.
+Who:	Wim Van Sebroeck <wim@iguana.be>
+
+---------------------------
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index ea09d0c..e812aa1 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -301,6 +301,7 @@ config I6300ESB_WDT
 config I8XX_TCO
 	tristate "Intel i8xx TCO Timer/Watchdog"
 	depends on WATCHDOG && (X86 || IA64) && PCI
+	default n
 	---help---
 	  Hardware driver for the TCO timer built into the Intel 82801
 	  I/O Controller Hub family.  The TCO (Total Cost of Ownership)
