Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZDGOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZDGOyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZDGOyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:54:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58006 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758375AbZDGOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:54:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/11] Adjust path to gpio headers
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:53:11 +0100
Message-ID: <20090407155254.18020.91957.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 1537e0d..0328fd4 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -738,7 +738,7 @@ config UART0_CTS_PIN
 	default 23
 	help
 	  The default pin is GPIO_GP7.
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART0_RTS_PIN
 	int "UART0 RTS pin"
@@ -746,7 +746,7 @@ config UART0_RTS_PIN
 	default 22
 	help
 	  The default pin is GPIO_GP6.
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
@@ -766,14 +766,14 @@ config UART1_CTS_PIN
 	depends on BFIN_UART1_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART1_RTS_PIN
 	int "UART1 RTS pin"
 	depends on BFIN_UART1_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART2
 	bool "Enable UART2"
@@ -793,14 +793,14 @@ config UART2_CTS_PIN
 	depends on BFIN_UART2_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART2_RTS_PIN
 	int "UART2 RTS pin"
 	depends on BFIN_UART2_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART3
 	bool "Enable UART3"
@@ -820,14 +820,14 @@ config UART3_CTS_PIN
 	depends on BFIN_UART3_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART3_RTS_PIN
 	int "UART3 RTS pin"
 	depends on BFIN_UART3_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_IMX
 	bool "IMX serial port support"

