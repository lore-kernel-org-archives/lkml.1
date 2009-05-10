Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZEJC2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZEJC2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 22:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZEJC2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 22:28:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:47034 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbZEJC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 22:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YkFNdzsHo+8dGBLfzhG/WSRSvjPIWPACdr2SsYN9HtEJ+GBE1M1nPcvc2SIc8xSFRL
         3vDl+Q+OwP3jYd2lygjwd4GZDagqeuKHrSHo3KWnXvW0tVky72/xRlTULa/wdwezsUB4
         R0Guo+7R+krhso+36E0ioSsZRb4cVHgpgIsHg=
MIME-Version: 1.0
Date: Sun, 10 May 2009 10:28:39 +0800
Message-ID: <a8e1da0905091928p40228e4ejdcf10a706c5b95b7@mail.gmail.com>
Subject: [PATCH] dell-laptop : remove the duplicated kconfig option
From: Dave Young <hidave.darkstar@gmail.com>
To: mjg59@srcf.ucam.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dell-laptop driver has duplicated Kconfig defination both in
drivers/misc/Kconfig and drivers/platform/x86/Kconfig.

Here remove the drivers/misc/ option because its source code is under
drivers/platform/x86.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/misc/Kconfig |   13 -------------
1 file changed, 13 deletions(-)

--- linux-2.6.orig/drivers/misc/Kconfig	2009-04-09 16:22:34.000000000 +0800
+++ linux-2.6/drivers/misc/Kconfig	2009-05-09 10:54:43.000000000 +0800
@@ -210,19 +210,6 @@
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.

-config DELL_LAPTOP
-	tristate "Dell Laptop Extras (EXPERIMENTAL)"
-	depends on X86
-	depends on DCDBAS
-	depends on EXPERIMENTAL
-	depends on BACKLIGHT_CLASS_DEVICE
-	depends on RFKILL
-	depends on POWER_SUPPLY
-	default n
-	---help---
-	This driver adds support for rfkill and backlight control to Dell
-	laptops.
-
 config ISL29003
 	tristate "Intersil ISL29003 ambient light sensor"
 	depends on I2C && SYSFS
