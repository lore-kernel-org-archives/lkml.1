Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYFZNEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYFZNEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYFZMpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:45:39 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23819 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760491AbYFZMpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:45:36 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 60/60] microblaze_v4: Enable drivers for Microblaze
Date: Thu, 26 Jun 2008 14:30:29 +0200
Message-Id: <1214483429-32360-61-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-60-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
 <1214483429-32360-40-git-send-email-monstr@seznam.cz>
 <1214483429-32360-41-git-send-email-monstr@seznam.cz>
 <1214483429-32360-42-git-send-email-monstr@seznam.cz>
 <1214483429-32360-43-git-send-email-monstr@seznam.cz>
 <1214483429-32360-44-git-send-email-monstr@seznam.cz>
 <1214483429-32360-45-git-send-email-monstr@seznam.cz>
 <1214483429-32360-46-git-send-email-monstr@seznam.cz>
 <1214483429-32360-47-git-send-email-monstr@seznam.cz>
 <1214483429-32360-48-git-send-email-monstr@seznam.cz>
 <1214483429-32360-49-git-send-email-monstr@seznam.cz>
 <1214483429-32360-50-git-send-email-monstr@seznam.cz>
 <1214483429-32360-51-git-send-email-monstr@seznam.cz>
 <1214483429-32360-52-git-send-email-monstr@seznam.cz>
 <1214483429-32360-53-git-send-email-monstr@seznam.cz>
 <1214483429-32360-54-git-send-email-monstr@seznam.cz>
 <1214483429-32360-55-git-send-email-monstr@seznam.cz>
 <1214483429-32360-56-git-send-email-monstr@seznam.cz>
 <1214483429-32360-57-git-send-email-monstr@seznam.cz>
 <1214483429-32360-58-git-send-email-monstr@seznam.cz>
 <1214483429-32360-59-git-send-email-monstr@seznam.cz>
 <1214483429-32360-60-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/block/Kconfig  |    2 +-
 drivers/char/Kconfig   |    2 +-
 drivers/serial/Kconfig |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 0d1d213..a92767c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -413,7 +413,7 @@ source "drivers/s390/block/Kconfig"
 
 config XILINX_SYSACE
 	tristate "Xilinx SystemACE support"
-	depends on 4xx
+	depends on 4xx || MICROBLAZE
 	help
 	  Include support for the Xilinx SystemACE CompactFlash interface
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 2d854bb..981c57a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -879,7 +879,7 @@ config DTLK
 
 config XILINX_HWICAP
 	tristate "Xilinx HWICAP Support"
-	depends on XILINX_VIRTEX
+	depends on XILINX_VIRTEX || MICROBLAZE
 	help
 	  This option enables support for Xilinx Internal Configuration
 	  Access Port (ICAP) driver.  The ICAP is used on Xilinx Virtex
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 9bc4276..984ba34 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -776,7 +776,7 @@ config SERIAL_IMX_CONSOLE
 
 config SERIAL_UARTLITE
 	tristate "Xilinx uartlite serial port support"
-	depends on PPC32
+	depends on PPC32 || MICROBLAZE
 	select SERIAL_CORE
 	help
 	  Say Y here if you want to use the Xilinx uartlite serial controller.
-- 
1.5.4.GIT

