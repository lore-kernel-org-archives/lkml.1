Return-Path: <linux-kernel-owner+w=401wt.eu-S935656AbXJSUe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935656AbXJSUe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbXJSUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:34:49 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:42530 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762792AbXJSUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:34:48 -0400
Date: Fri, 19 Oct 2007 21:34:41 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz: Update Kconfig description
Message-ID: <Pine.LNX.4.64N.0710192130060.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Reformat the Kconfig entries and update descriptions for accuracy.  
Select the driver by default for configurations of interest.  For the 
curious: 32BIT means only 32-bit DECstations support the device, not that 
the driver is not 64-bit clean; I have not checked that either though.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Please apply,

  Maciej

patch-mips-2.6.18-20060920-dz-kconfig-2
diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/drivers/serial/Kconfig linux-mips-2.6.18-20060920/drivers/serial/Kconfig
--- linux-mips-2.6.18-20060920.macro/drivers/serial/Kconfig	2006-06-29 05:03:07.000000000 +0000
+++ linux-mips-2.6.18-20060920/drivers/serial/Kconfig	2007-02-04 20:18:36.000000000 +0000
@@ -385,20 +385,24 @@ config SERIAL_DZ
 	bool "DECstation DZ serial driver"
 	depends on MACH_DECSTATION && 32BIT
 	select SERIAL_CORE
-	help
-	  DZ11-family serial controllers for VAXstations, including the
-	  DC7085, M7814, and M7819.
+	default y
+	---help---
+	  DZ11-family serial controllers for DECstations and VAXstations,
+	  including the DC7085, M7814, and M7819.
 
 config SERIAL_DZ_CONSOLE
 	bool "Support console on DECstation DZ serial driver"
 	depends on SERIAL_DZ=y
 	select SERIAL_CORE_CONSOLE
-	help
+	default y
+	---help---
 	  If you say Y here, it will be possible to use a serial port as the
 	  system console (the system console is the device which receives all
 	  kernel messages and warnings and which allows logins in single user
-	  mode).  Note that the firmware uses ttyS0 as the serial console on
-	  the Maxine and ttyS2 on the others.
+	  mode).
+
+	  Note that the firmware uses ttyS3 as the serial console on
+	  DECstations that use this driver.
 
 	  If unsure, say Y.
 
