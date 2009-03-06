Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZCFGqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZCFGqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZCFGlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:08 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:39798 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZCFGk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:58 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883663"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 18/18] Blackfin Serial Driver: update path to gpio header
Date: Fri,  6 Mar 2009 14:43:00 +0800
Message-Id: <1236321780-28718-19-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index beb4617..33c678a 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -731,7 +731,7 @@ config UART0_CTS_PIN
 	default 23
 	help
 	  The default pin is GPIO_GP7.
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART0_RTS_PIN
 	int "UART0 RTS pin"
@@ -739,7 +739,7 @@ config UART0_RTS_PIN
 	default 22
 	help
 	  The default pin is GPIO_GP6.
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
@@ -759,14 +759,14 @@ config UART1_CTS_PIN
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
@@ -786,14 +786,14 @@ config UART2_CTS_PIN
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
@@ -813,14 +813,14 @@ config UART3_CTS_PIN
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
-- 
1.5.6.3
