Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbXIOKP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbXIOKP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXIOKPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:15:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:36558 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbXIOKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:subject:mime-version:from:to:cc:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Rh3r9hRvzBmQPGIpJtsnjBcrM+k/47W2MQJrpUJoPW4ea2guFl2fjO2xS9q05/6tFq3abDmtkD4aH5aFbh5GwLXt38ePrElqr4y1CCNkSa1WEo0ivlBIeKUTqM8hI52MrvKum1r84jos0lRLFa8s4hRQCBRPNQGElQQ7RWuCjt8=
Date: Sat, 15 Sep 2007 12:15:43 +0200
Subject: [PATCH v2] Kconfig: Make MSI Laptop select BACKLIGHT_CLASS_DEVICE instead of depend
MIME-Version: 1.0
From: Matej Laitl <strohel@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Lennart Poettering <mzxreary@0pointer.de>
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200709151215.44578.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matěj Laitl <strohel@gmail.com>

This simple patch helps users reveal this config option and makes MSI Laptop
more coherent with other laptop extras found in misc devices.

(this option was hidden until user says y to BACKLIGHT_CLASS_DEVICE under
Graphics drivers)

When at it, convert space indentation to tabs to match CodingStyle.

Signed-off-by: Matěj Laitl <strohel@gmail.com>
Acked-by: Lennart Poettering <mzxreary@0pointer.de>
---
Please ignore any garbage from me that may have arrived in your inbox when I 
tried to send v1 of my patch. My apologies. (mail client misconfiguration)

Only change since v1 of this patch is space -> tabs conversion.

 drivers/misc/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a266558..8edf0fa 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -112,11 +112,11 @@ config ASUS_LAPTOP
 	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
 
 config MSI_LAPTOP
-        tristate "MSI Laptop Extras"
-        depends on X86
-        depends on ACPI_EC
-        depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
+	tristate "MSI Laptop Extras"
+	depends on X86
+	depends on ACPI_EC
+	select BACKLIGHT_CLASS_DEVICE
+	---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
 
-- 
1.5.1.6

