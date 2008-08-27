Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYH0XxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYH0XxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYH0XxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:53:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:38030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbYH0XxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:53:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,283,1217833200"; 
   d="scan'208";a="432783392"
From: Seth Heasley <seth.heasley@intel.com>
To: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH 2.6.27-rc4] irq: irq and pci_ids patch for Intel Ibex Peak DeviceIDs
Date: Wed, 27 Aug 2008 16:58:26 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271658.26313.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Intel Ibex Peak (PCH) LPC and SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6/include/linux/pci_ids.h.orig	2008-08-27 11:54:07.000000000 -0700
+++ linux-2.6/include/linux/pci_ids.h	2008-08-27 12:01:53.000000000 -0700
@@ -2428,9 +2428,39 @@
 #define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
 #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
 #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
-#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b10
-#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b11
-#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b30
+#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b00
+#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b01
+#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b02
+#define PCI_DEVICE_ID_INTEL_PCH_3	0x3b03
+#define PCI_DEVICE_ID_INTEL_PCH_4	0x3b04
+#define PCI_DEVICE_ID_INTEL_PCH_5	0x3b05
+#define PCI_DEVICE_ID_INTEL_PCH_6	0x3b06
+#define PCI_DEVICE_ID_INTEL_PCH_7	0x3b07
+#define PCI_DEVICE_ID_INTEL_PCH_8	0x3b08
+#define PCI_DEVICE_ID_INTEL_PCH_9	0x3b09
+#define PCI_DEVICE_ID_INTEL_PCH_10	0x3b0a
+#define PCI_DEVICE_ID_INTEL_PCH_11	0x3b0b
+#define PCI_DEVICE_ID_INTEL_PCH_12	0x3b0c
+#define PCI_DEVICE_ID_INTEL_PCH_13	0x3b0d
+#define PCI_DEVICE_ID_INTEL_PCH_14	0x3b0e
+#define PCI_DEVICE_ID_INTEL_PCH_15	0x3b0f
+#define PCI_DEVICE_ID_INTEL_PCH_16	0x3b10
+#define PCI_DEVICE_ID_INTEL_PCH_17	0x3b11
+#define PCI_DEVICE_ID_INTEL_PCH_18	0x3b12
+#define PCI_DEVICE_ID_INTEL_PCH_19	0x3b13
+#define PCI_DEVICE_ID_INTEL_PCH_20	0x3b14
+#define PCI_DEVICE_ID_INTEL_PCH_21	0x3b15
+#define PCI_DEVICE_ID_INTEL_PCH_22	0x3b16
+#define PCI_DEVICE_ID_INTEL_PCH_23	0x3b17
+#define PCI_DEVICE_ID_INTEL_PCH_24	0x3b18
+#define PCI_DEVICE_ID_INTEL_PCH_25	0x3b19
+#define PCI_DEVICE_ID_INTEL_PCH_26	0x3b1a
+#define PCI_DEVICE_ID_INTEL_PCH_27	0x3b1b
+#define PCI_DEVICE_ID_INTEL_PCH_28	0x3b1c
+#define PCI_DEVICE_ID_INTEL_PCH_29	0x3b1d
+#define PCI_DEVICE_ID_INTEL_PCH_30	0x3b1e
+#define PCI_DEVICE_ID_INTEL_PCH_31	0x3b1f
+#define PCI_DEVICE_ID_INTEL_PCH_32	0x3b30
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
 #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5
--- linux-2.6/arch/x86/pci/irq.c.orig	2008-08-27 11:53:13.000000000 -0700
+++ linux-2.6/arch/x86/pci/irq.c	2008-08-27 12:07:21.000000000 -0700
@@ -592,6 +592,36 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
 	case PCI_DEVICE_ID_INTEL_PCH_0:
 	case PCI_DEVICE_ID_INTEL_PCH_1:
+	case PCI_DEVICE_ID_INTEL_PCH_2:
+	case PCI_DEVICE_ID_INTEL_PCH_3:
+	case PCI_DEVICE_ID_INTEL_PCH_4:
+	case PCI_DEVICE_ID_INTEL_PCH_5:
+	case PCI_DEVICE_ID_INTEL_PCH_6:
+	case PCI_DEVICE_ID_INTEL_PCH_7:
+	case PCI_DEVICE_ID_INTEL_PCH_8:
+	case PCI_DEVICE_ID_INTEL_PCH_9:
+	case PCI_DEVICE_ID_INTEL_PCH_10:
+	case PCI_DEVICE_ID_INTEL_PCH_11:
+	case PCI_DEVICE_ID_INTEL_PCH_12:
+	case PCI_DEVICE_ID_INTEL_PCH_13:
+	case PCI_DEVICE_ID_INTEL_PCH_14:
+	case PCI_DEVICE_ID_INTEL_PCH_15:
+	case PCI_DEVICE_ID_INTEL_PCH_16:
+	case PCI_DEVICE_ID_INTEL_PCH_17:
+	case PCI_DEVICE_ID_INTEL_PCH_18:
+	case PCI_DEVICE_ID_INTEL_PCH_19:
+	case PCI_DEVICE_ID_INTEL_PCH_20:
+	case PCI_DEVICE_ID_INTEL_PCH_21:
+	case PCI_DEVICE_ID_INTEL_PCH_22:
+	case PCI_DEVICE_ID_INTEL_PCH_23:
+	case PCI_DEVICE_ID_INTEL_PCH_24:
+	case PCI_DEVICE_ID_INTEL_PCH_25:
+	case PCI_DEVICE_ID_INTEL_PCH_26:
+	case PCI_DEVICE_ID_INTEL_PCH_27:
+	case PCI_DEVICE_ID_INTEL_PCH_28:
+	case PCI_DEVICE_ID_INTEL_PCH_29:
+	case PCI_DEVICE_ID_INTEL_PCH_30:
+	case PCI_DEVICE_ID_INTEL_PCH_31:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
