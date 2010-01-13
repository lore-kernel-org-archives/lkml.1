Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618Ab0AMBBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0AMBBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482Ab0AMBBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:01:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:50907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab0AMBBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:01:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232067535"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, khali@linux-fr.org
Subject: [PATCH 2.6.32.3] irq: irq and pci_ids patch for Intel Cougar Point DeviceIDs
Date: Tue, 12 Jan 2010 16:56:37 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001121656.37664.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Cougar Point (PCH) LPC and SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.32.3/arch/x86/pci/irq.c.orig	2010-01-06 15:07:45.000000000 -0800
+++ linux-2.6.32.3/arch/x86/pci/irq.c	2010-01-07 13:10:28.000000000 -0800
@@ -590,6 +590,8 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_2:
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
+	case PCI_DEVICE_ID_INTEL_CPT_LPC1:
+	case PCI_DEVICE_ID_INTEL_CPT_LPC2:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
--- linux-2.6.32.3/include/linux/pci_ids.h.orig	2010-01-06 15:07:45.000000000 -0800
+++ linux-2.6.32.3/include/linux/pci_ids.h	2010-01-07 13:10:28.000000000 -0800
@@ -2398,6 +2398,9 @@
 #define PCI_DEVICE_ID_INTEL_82840_HB	0x1a21
 #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
+#define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
+#define PCI_DEVICE_ID_INTEL_CPT_LPC1	0x1c42
+#define PCI_DEVICE_ID_INTEL_CPT_LPC2	0x1c43
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
 #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
 #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
