Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZEHPVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZEHPVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZEHPVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:21:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1501 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZEHPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:21:08 -0400
Date: Fri, 8 May 2009 17:21:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Antonino Daplas <adaplas@gmail.com>
Cc: inux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: |PATCH] fbdev: Remove outdated advice about I2C configuration
Message-ID: <20090508172100.1f010efc@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The required I2C modules are now selected automatically by the means
of select statements in Kconfig, so there is no point in confusing the
users with options he/she would be supposed to enable manually.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Antonino Daplas <adaplas@gmail.com>
---
Already sent on:
 * 2009-3-24

 drivers/video/Kconfig |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- linux-2.6.29-rc8.orig/drivers/video/Kconfig	2009-03-22 14:55:07.000000000 +0100
+++ linux-2.6.29-rc8/drivers/video/Kconfig	2009-03-23 11:16:19.000000000 +0100
@@ -1128,13 +1128,6 @@ config FB_INTEL
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
           Say Y if you have and plan to use such a board.
 
-	  If you say Y here and want DDC/I2C support you must first say Y to
-	  "I2C support" and "I2C bit-banging support" in the character devices
-	  section.
-
-	  If you say M here then "I2C support" and "I2C bit-banging support"
-	  can be build either as modules or built-in.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called intelfb.
 
@@ -1207,11 +1200,10 @@ config FB_MATROX_G
 	  pixel and 32 bpp packed pixel. You can also use font widths
 	  different from 8.
 
-	  If you need support for G400 secondary head, you must first say Y to
-	  "I2C support" in the character devices section, and then to
-	  "Matrox I2C support" and "G400 second head support" here in the
-	  framebuffer section. G450/G550 secondary head and digital output
-	  are supported without additional modules.
+	  If you need support for G400 secondary head, you must say Y to
+	  "Matrox I2C support" and "G400 second head support" right below.
+	  G450/G550 secondary head and digital output are supported without
+	  additional modules.
 
 	  The driver starts in monitor mode. You must use the matroxset tool 
 	  (available at <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to 
@@ -1310,13 +1302,6 @@ config FB_RADEON
 	  a framebuffer device.  There are both PCI and AGP versions.  You
 	  don't need to choose this to run the Radeon in plain VGA mode.
 
-	  If you say Y here and want DDC/I2C support you must first say Y to
-	  "I2C support" and "I2C bit-banging support" in the character devices
-	  section.
-
-	  If you say M here then "I2C support" and "I2C bit-banging support" 
-	  can be build either as modules or built-in.
-
 	  There is a product page at
 	  http://apps.ati.com/ATIcompare/
 


-- 
Jean Delvare
