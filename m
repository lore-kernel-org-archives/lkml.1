Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYJJPAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYJJPAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbYJJO61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:58:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42853 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760804AbYJJO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:58:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/14] mfd: Add WM8350 comparator register definitions
Date: Fri, 10 Oct 2008 15:58:07 +0100
Message-Id: <1223650696-15552-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223650696-15552-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1223649928.6814.333.camel@dell-desktop.example.com>
 <1223650696-15552-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-4-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8350/comparator.h |  167 +++++++++++++++++++++++++++++++++
 1 files changed, 167 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/wm8350/comparator.h

diff --git a/include/linux/mfd/wm8350/comparator.h b/include/linux/mfd/wm8350/comparator.h
new file mode 100644
index 0000000..0537886
--- /dev/null
+++ b/include/linux/mfd/wm8350/comparator.h
@@ -0,0 +1,167 @@
+/*
+ * comparator.h  --  Comparator Aux ADC for Wolfson WM8350 PMIC
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#ifndef __LINUX_MFD_WM8350_COMPARATOR_H_
+#define __LINUX_MFD_WM8350_COMPARATOR_H_
+
+/*
+ * Registers
+ */
+
+#define WM8350_DIGITISER_CONTROL_1              0x90
+#define WM8350_DIGITISER_CONTROL_2              0x91
+#define WM8350_AUX1_READBACK                    0x98
+#define WM8350_AUX2_READBACK                    0x99
+#define WM8350_AUX3_READBACK                    0x9A
+#define WM8350_AUX4_READBACK                    0x9B
+#define WM8350_CHIP_TEMP_READBACK               0x9F
+#define WM8350_GENERIC_COMPARATOR_CONTROL       0xA3
+#define WM8350_GENERIC_COMPARATOR_1             0xA4
+#define WM8350_GENERIC_COMPARATOR_2             0xA5
+#define WM8350_GENERIC_COMPARATOR_3             0xA6
+#define WM8350_GENERIC_COMPARATOR_4             0xA7
+
+/*
+ * R144 (0x90) - Digitiser Control (1)
+ */
+#define WM8350_AUXADC_CTC                       0x4000
+#define WM8350_AUXADC_POLL                      0x2000
+#define WM8350_AUXADC_HIB_MODE                  0x1000
+#define WM8350_AUXADC_SEL8                      0x0080
+#define WM8350_AUXADC_SEL7                      0x0040
+#define WM8350_AUXADC_SEL6                      0x0020
+#define WM8350_AUXADC_SEL5                      0x0010
+#define WM8350_AUXADC_SEL4                      0x0008
+#define WM8350_AUXADC_SEL3                      0x0004
+#define WM8350_AUXADC_SEL2                      0x0002
+#define WM8350_AUXADC_SEL1                      0x0001
+
+/*
+ * R145 (0x91) - Digitiser Control (2)
+ */
+#define WM8350_AUXADC_MASKMODE_MASK             0x3000
+#define WM8350_AUXADC_CRATE_MASK                0x0700
+#define WM8350_AUXADC_CAL                       0x0004
+#define WM8350_AUX_RBMODE                       0x0002
+#define WM8350_AUXADC_WAIT                      0x0001
+
+/*
+ * R152 (0x98) - AUX1 Readback
+ */
+#define WM8350_AUXADC_SCALE1_MASK               0x6000
+#define WM8350_AUXADC_REF1                      0x1000
+#define WM8350_AUXADC_DATA1_MASK                0x0FFF
+
+/*
+ * R153 (0x99) - AUX2 Readback
+ */
+#define WM8350_AUXADC_SCALE2_MASK               0x6000
+#define WM8350_AUXADC_REF2                      0x1000
+#define WM8350_AUXADC_DATA2_MASK                0x0FFF
+
+/*
+ * R154 (0x9A) - AUX3 Readback
+ */
+#define WM8350_AUXADC_SCALE3_MASK               0x6000
+#define WM8350_AUXADC_REF3                      0x1000
+#define WM8350_AUXADC_DATA3_MASK                0x0FFF
+
+/*
+ * R155 (0x9B) - AUX4 Readback
+ */
+#define WM8350_AUXADC_SCALE4_MASK               0x6000
+#define WM8350_AUXADC_REF4                      0x1000
+#define WM8350_AUXADC_DATA4_MASK                0x0FFF
+
+/*
+ * R156 (0x9C) - USB Voltage Readback
+ */
+#define WM8350_AUXADC_DATA_USB_MASK             0x0FFF
+
+/*
+ * R157 (0x9D) - LINE Voltage Readback
+ */
+#define WM8350_AUXADC_DATA_LINE_MASK            0x0FFF
+
+/*
+ * R158 (0x9E) - BATT Voltage Readback
+ */
+#define WM8350_AUXADC_DATA_BATT_MASK            0x0FFF
+
+/*
+ * R159 (0x9F) - Chip Temp Readback
+ */
+#define WM8350_AUXADC_DATA_CHIPTEMP_MASK        0x0FFF
+
+/*
+ * R163 (0xA3) - Generic Comparator Control
+ */
+#define WM8350_DCMP4_ENA                        0x0008
+#define WM8350_DCMP3_ENA                        0x0004
+#define WM8350_DCMP2_ENA                        0x0002
+#define WM8350_DCMP1_ENA                        0x0001
+
+/*
+ * R164 (0xA4) - Generic comparator 1
+ */
+#define WM8350_DCMP1_SRCSEL_MASK                0xE000
+#define WM8350_DCMP1_GT                         0x1000
+#define WM8350_DCMP1_THR_MASK                   0x0FFF
+
+/*
+ * R165 (0xA5) - Generic comparator 2
+ */
+#define WM8350_DCMP2_SRCSEL_MASK                0xE000
+#define WM8350_DCMP2_GT                         0x1000
+#define WM8350_DCMP2_THR_MASK                   0x0FFF
+
+/*
+ * R166 (0xA6) - Generic comparator 3
+ */
+#define WM8350_DCMP3_SRCSEL_MASK                0xE000
+#define WM8350_DCMP3_GT                         0x1000
+#define WM8350_DCMP3_THR_MASK                   0x0FFF
+
+/*
+ * R167 (0xA7) - Generic comparator 4
+ */
+#define WM8350_DCMP4_SRCSEL_MASK                0xE000
+#define WM8350_DCMP4_GT                         0x1000
+#define WM8350_DCMP4_THR_MASK                   0x0FFF
+
+/*
+ * Interrupts.
+ */
+#define WM8350_IRQ_AUXADC_DATARDY		16
+#define WM8350_IRQ_AUXADC_DCOMP4		17
+#define WM8350_IRQ_AUXADC_DCOMP3		18
+#define WM8350_IRQ_AUXADC_DCOMP2		19
+#define WM8350_IRQ_AUXADC_DCOMP1		20
+#define WM8350_IRQ_SYS_HYST_COMP_FAIL		21
+#define WM8350_IRQ_SYS_CHIP_GT115		22
+#define WM8350_IRQ_SYS_CHIP_GT140		23
+
+/*
+ * USB/2, LINE & BATT = ((VRTC * 2) / 4095)) * 10e6 uV
+ * Where VRTC = 2.7 V
+ */
+#define WM8350_AUX_COEFF			1319
+
+#define WM8350_AUXADC_AUX1			0
+#define WM8350_AUXADC_AUX2			1
+#define WM8350_AUXADC_AUX3			2
+#define WM8350_AUXADC_AUX4			3
+#define WM8350_AUXADC_USB			4
+#define WM8350_AUXADC_LINE			5
+#define WM8350_AUXADC_BATT			6
+#define WM8350_AUXADC_TEMP			7
+
+#endif
-- 
1.5.6.5

