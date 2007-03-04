Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbXCDSuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbXCDSuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 13:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXCDSuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 13:50:01 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:53849 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbXCDSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 13:50:00 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Mar 2007 13:17:43 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: len.brown@intel.com
Subject: [PATCH][RFC] Make entire ACPI submenu dependent on PM.
Message-ID: <Pine.LNX.4.64.0703041312490.5332@CPE00045a9c397f-CM001225dbafb6>
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


  Make the visibility of the entire ACPI submenu dependent on PM.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that de-selecting Power Management (PM) de-activates the
entire contents of the ACPI submenu, it seems pointless to leave the
top-level menu entry visible.  but this is just a hack and i'll leave
it to the official maintainers to do it properly. :-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7c49e10..3208ce0 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -7,6 +7,7 @@ menu "ACPI (Advanced Configuration and Power Interface) Support"
 	depends on !X86_VISWS
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
+	depends on PM

 config ACPI
 	bool "ACPI Support"

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
