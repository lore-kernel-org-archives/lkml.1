Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZCZNdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZCZNdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZCZNcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:32:42 -0400
Received: from mx1.emlix.com ([193.175.82.87]:40216 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZCZNcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:32:41 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/4] xtensa: move definition of irq numbers to platform header
Date: Thu, 26 Mar 2009 14:33:45 +0100
Message-Id: <1238074428-24666-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alsa SoC drivers traditionally provide the platform specific code as
separate modules. Move the list of irq numbers to a header file to
allow it being used in several files.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c               |    8 +-------
 arch/xtensa/platforms/s6105/include/platform/irq.h |   11 +++++++++++
 2 files changed, 12 insertions(+), 7 deletions(-)
 create mode 100644 arch/xtensa/platforms/s6105/include/platform/irq.h

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index bb59580..d296201 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -26,13 +26,7 @@
 #include <variant/dmac.h>
 
 #include <platform/gpio.h>
-
-#define GPIO3_INTNUM		3
-#define UART_INTNUM		4
-#define GMAC_INTNUM		5
-#define I2C_INTNUM		6
-#define ISEF_INTNUM		8
-#define SPI_INTNUM		11
+#include <platform/irq.h>
 
 static const signed char gpio3_irq_mappings[] = {
 	S6_INTC_GPIO(3),
diff --git a/arch/xtensa/platforms/s6105/include/platform/irq.h b/arch/xtensa/platforms/s6105/include/platform/irq.h
new file mode 100644
index 0000000..3d5d4d2
--- /dev/null
+++ b/arch/xtensa/platforms/s6105/include/platform/irq.h
@@ -0,0 +1,11 @@
+#ifndef __XTENSA_PLATFORM_S6105_IRQ_H
+#define __XTENSA_PLATFORM_S6105_IRQ_H
+
+#define GPIO3_INTNUM	3
+#define UART_INTNUM	4
+#define GMAC_INTNUM	5
+#define I2C_INTNUM	6
+#define ISEF_INTNUM	8
+#define SPI_INTNUM	11
+
+#endif
-- 
1.6.2.107.ge47ee

