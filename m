Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0BVElW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 23:41:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39718 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0BVElU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 23:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=hHeeWsOXiA8UPjbi/nOp5x15vXkh2GJDkezlQnivu89glpGM9NDMlk95Wmts8U7D+Z
         AP51d7/9kI8onz5F9Vdd5KHR8zFvAN073/MG5/paFyXGIYL6NfAGpqNMOlNUOG3BULLf
         Ux9TYeLJTNJym/sqlVmVAH4XAeG8v1PpikOGk=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
       sameo@linux.intel.com, linux-sh@vger.kernel.org
Date: Mon, 22 Feb 2010 13:40:59 +0900
Message-Id: <20100222044059.4684.59850.sendpatchset@t400s>
Subject: [PATCH] mfd/mmc: SDHI Kconfig update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Enable the sh_mobile_sdhi mfd driver on SH-Mobile ARM
processors. While at it, make CONFIG_TMIO_MMC depend on
CONFIG_MFD_SH_MOBILE_SDHI.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mfd/Kconfig      |    2 +-
 drivers/mmc/host/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- 0001/drivers/mfd/Kconfig
+++ work/drivers/mfd/Kconfig	2010-02-22 13:26:47.000000000 +0900
@@ -37,7 +37,7 @@ config MFD_ASIC3
 
 config MFD_SH_MOBILE_SDHI
 	bool "Support for SuperH Mobile SDHI"
-	depends on SUPERH
+	depends on SUPERH || ARCH_SHMOBILE
 	select MFD_CORE
 	 ---help---
 	  This driver supports the SDHI hardware block found in many
--- 0001/drivers/mmc/host/Kconfig
+++ work/drivers/mmc/host/Kconfig	2010-02-22 13:27:30.000000000 +0900
@@ -368,7 +368,7 @@ config MMC_SDRICOH_CS
 
 config MMC_TMIO
 	tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function support"
-	depends on MFD_TMIO || MFD_ASIC3 || SUPERH
+	depends on MFD_TMIO || MFD_ASIC3 || MFD_SH_MOBILE_SDHI
 	help
 	  This provides support for the SD/MMC cell found in TC6393XB,
 	  T7L66XB and also HTC ASIC3
