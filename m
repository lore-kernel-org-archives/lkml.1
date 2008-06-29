Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbYF2PBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbYF2PBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbYF2PB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:01:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32051 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYF2PBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ur4AlvVnlcBrdkALBcHZuug2XXUoVgDxjGaxbbYeXwASDWc4R1i6AMb5134levijWo
         OcAO39+Z/h59xh78vagwnNgUQ6+RJvnVFKCHdXWze2NSBSz6f+EPpJOMSvlhXg5x2YC4
         +0AUIiJ38XFj5kuEZlqy/xgJkabRTXmNilJIQ=
Subject: [PATCH] mfd: add ASIC3_CONFIG_GPIO templates for blueangel and
	hx4700
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 17:01:18 +0200
Message-Id: <1214751678.2758.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As ASIC3 GPIO alternate function configuration is expected to be similar
for several devices, it is convenient to define descriptive macros. This
patch is inspired by the PXA MFP configuration, the alternate functions
were observed on hx4700 and blueangel.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/mfd/asic3.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 0610449..f149180 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -100,6 +100,35 @@ struct asic3_platform_data {
 #define ASIC3_CONFIG_GPIO_DEFAULT_OUT(gpio, init) \
 	ASIC3_CONFIG_GPIO((gpio), 0, 1, (init))
 
+/*
+ * Alternate functions
+ */
+#define ASIC3_GPIOA11_PWM0		ASIC3_CONFIG_GPIO(11, 1, 1, 0)
+#define ASIC3_GPIOA12_PWM1		ASIC3_CONFIG_GPIO(12, 1, 1, 0)
+#define ASIC3_GPIOA15_CONTROL_CX	ASIC3_CONFIG_GPIO(15, 1, 1, 0)
+#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 1, 0)
+#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 1, 0)
+#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 1, 0)
+#define ASIC3_GPIOC3_SPI_RXD		ASIC3_CONFIG_GPIO(35, 1, 0, 0)
+#define ASIC3_GPIOC4_CF_nCD		ASIC3_CONFIG_GPIO(36, 1, 0, 0)
+#define ASIC3_GPIOC4_SPI_TXD		ASIC3_CONFIG_GPIO(36, 1, 1, 0)
+#define ASIC3_GPIOC5_SPI_CLK		ASIC3_CONFIG_GPIO(37, 1, 1, 0)
+#define ASIC3_GPIOC5_nCIOW		ASIC3_CONFIG_GPIO(37, 1, 1, 0)
+#define ASIC3_GPIOC6_nCIOR		ASIC3_CONFIG_GPIO(38, 1, 1, 0)
+#define ASIC3_GPIOC7_nPCE_1		ASIC3_CONFIG_GPIO(39, 1, 0, 0)
+#define ASIC3_GPIOC8_nPCE_2		ASIC3_CONFIG_GPIO(40, 1, 0, 0)
+#define ASIC3_GPIOC9_nPOE		ASIC3_CONFIG_GPIO(41, 1, 0, 0)
+#define ASIC3_GPIOC10_nPWE		ASIC3_CONFIG_GPIO(42, 1, 0, 0)
+#define ASIC3_GPIOC11_PSKTSEL		ASIC3_CONFIG_GPIO(43, 1, 0, 0)
+#define ASIC3_GPIOC12_nPREG		ASIC3_CONFIG_GPIO(44, 1, 0, 0)
+#define ASIC3_GPIOC13_nPWAIT		ASIC3_CONFIG_GPIO(45, 1, 1, 0)
+#define ASIC3_GPIOC14_nPIOIS16		ASIC3_CONFIG_GPIO(46, 1, 1, 0)
+#define ASIC3_GPIOC15_nPIOR		ASIC3_CONFIG_GPIO(47, 1, 0, 0)
+#define ASIC3_GPIOD11_nCIOIS16		ASIC3_CONFIG_GPIO(59, 1, 0, 0)
+#define ASIC3_GPIOD12_nCWAIT		ASIC3_CONFIG_GPIO(60, 1, 0, 0)
+#define ASIC3_GPIOD15_nPIOW		ASIC3_CONFIG_GPIO(63, 1, 0, 0)
+
+
 #define ASIC3_SPI_Base		      0x0400
 #define ASIC3_SPI_Control               0x0000
 #define ASIC3_SPI_TxData                0x0004
-- 
1.5.5.4


