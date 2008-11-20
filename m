Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYKTPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYKTPYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYKTPYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:24:07 -0500
Received: from mail.atmel.fr ([81.80.104.162]:50726 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbYKTPYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:24:04 -0500
Message-ID: <49257B40.8020807@atmel.com>
Date: Thu, 20 Nov 2008 15:59:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Ben Dooks <ben-linux@fluff.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
References: <491C0C05.6040301@atmel.com>	<20081113134818.GA9161@fluff.org.uk>	<491C3D16.1050501@atmel.com> <20081119193631.448ae25e@mjolnir.drzeus.cx>
In-Reply-To: <20081119193631.448ae25e@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to use the atmel-mci driver in an architecture
independant maner.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
V2: add mimc200 board.
Beware: embeds a git mv of atmel-mci.h

 arch/avr32/boards/atngw100/setup.c                 |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c            |    2 +-
 arch/avr32/boards/atstk1000/atstk1003.c            |    2 +-
 arch/avr32/boards/atstk1000/atstk1004.c            |    2 +-
 arch/avr32/boards/mimc200/setup.c                  |    2 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |    2 +-
 drivers/mmc/host/atmel-mci.c                       |    2 +-
 .../include/asm => include/linux}/atmel-mci.h      |    6 +++---
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index 32fb9ba..05d3722 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -19,8 +19,8 @@
 #include <linux/types.h>
 #include <linux/leds.h>
 #include <linux/spi/spi.h>
+#include <linux/atmel-mci.h>
 
-#include <asm/atmel-mci.h>
 #include <asm/io.h>
 #include <asm/setup.h>
 
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 5c5cdf3..6d94f74 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -16,12 +16,12 @@
 #include <linux/types.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/at73c213.h>
+#include <linux/atmel-mci.h>
 
 #include <video/atmel_lcdc.h>
 
 #include <asm/io.h>
 #include <asm/setup.h>
-#include <asm/atmel-mci.h>
 
 #include <mach/at32ap700x.h>
 #include <mach/board.h>
diff --git a/arch/avr32/boards/atstk1000/atstk1003.c b/arch/avr32/boards/atstk1000/atstk1003.c
index 134b566..db2038c 100644
--- a/arch/avr32/boards/atstk1000/atstk1003.c
+++ b/arch/avr32/boards/atstk1000/atstk1003.c
@@ -17,9 +17,9 @@
 
 #include <linux/spi/at73c213.h>
 #include <linux/spi/spi.h>
+#include <linux/atmel-mci.h>
 
 #include <asm/setup.h>
-#include <asm/atmel-mci.h>
 
 #include <mach/at32ap700x.h>
 #include <mach/board.h>
diff --git a/arch/avr32/boards/atstk1000/atstk1004.c b/arch/avr32/boards/atstk1000/atstk1004.c
index cb32eb8..29b35ac 100644
--- a/arch/avr32/boards/atstk1000/atstk1004.c
+++ b/arch/avr32/boards/atstk1000/atstk1004.c
@@ -17,11 +17,11 @@
 
 #include <linux/spi/at73c213.h>
 #include <linux/spi/spi.h>
+#include <linux/atmel-mci.h>
 
 #include <video/atmel_lcdc.h>
 
 #include <asm/setup.h>
-#include <asm/atmel-mci.h>
 
 #include <mach/at32ap700x.h>
 #include <mach/board.h>
diff --git a/arch/avr32/boards/mimc200/setup.c b/arch/avr32/boards/mimc200/setup.c
index 397cbb8..811d730 100644
--- a/arch/avr32/boards/mimc200/setup.c
+++ b/arch/avr32/boards/mimc200/setup.c
@@ -24,7 +24,7 @@ extern struct atmel_lcdfb_info mimc200_lcdc_data;
 #include <video/atmel_lcdc.h>
 #include <linux/fb.h>
 
-#include <asm/atmel-mci.h>
+#include <linux/atmel-mci.h>
 #include <linux/io.h>
 #include <asm/setup.h>
 
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0c6e02f..bc95ba7 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -15,8 +15,8 @@
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
+#include <linux/atmel-mci.h>
 
-#include <asm/atmel-mci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 7a3f243..1e97916 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -25,8 +25,8 @@
 #include <linux/stat.h>
 
 #include <linux/mmc/host.h>
+#include <linux/atmel-mci.h>
 
-#include <asm/atmel-mci.h>
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
diff --git a/arch/avr32/include/asm/atmel-mci.h b/include/linux/atmel-mci.h
similarity index 91%
rename from arch/avr32/include/asm/atmel-mci.h
rename to include/linux/atmel-mci.h
index 59f3fad..2a2213e 100644
--- a/arch/avr32/include/asm/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_ATMEL_MCI_H
-#define __ASM_AVR32_ATMEL_MCI_H
+#ifndef __LINUX_ATMEL_MCI_H
+#define __LINUX_ATMEL_MCI_H
 
 #define ATMEL_MCI_MAX_NR_SLOTS	2
 
@@ -36,4 +36,4 @@ struct mci_platform_data {
 	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
 };
 
-#endif /* __ASM_AVR32_ATMEL_MCI_H */
+#endif /* __LINUX_ATMEL_MCI_H */
-- 
1.5.3.7


