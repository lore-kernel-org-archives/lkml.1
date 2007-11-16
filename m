Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbXKPHbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbXKPHbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXKPHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:31:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:11058 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbXKPHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:31:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,425,1188802800"; 
   d="scan'208";a="206372020"
Subject: [PATCH] PCI: Add PCI quirk function for some chipsets
From: Zhao Yakui <yakui.zhao@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, shaohua.li@intel.com
Content-Type: text/plain
Date: Fri, 16 Nov 2007 15:41:55 +0800
Message-Id: <1195198915.2460.20.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: PCI: Add PCI quirk function for some chipsets
From: Zhao Yakui  <yakui.zhao@intel.com>

PCI quirk function is added for some chipsets so that the resources
behind LPC bridge can be reserved.

Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>

---
 drivers/pci/quirks.c    |    6 ++++++
 include/linux/pci_ids.h |    2 ++
 2 files changed, 8 insertions(+)

Index: linux-2.6.24-rc2/drivers/pci/quirks.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/pci/quirks.c
+++ linux-2.6.24-rc2/drivers/pci/quirks.c
@@ -465,6 +465,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_0, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_2, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_3, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_1, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_4, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_2, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_4, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_7, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_8, quirk_ich6_lpc_acpi );
 
 /*
  * VIA ACPI: One IO region pointed to by longword at
Index: linux-2.6.24-rc2/include/linux/pci_ids.h
===================================================================
--- linux-2.6.24-rc2.orig/include/linux/pci_ids.h
+++ linux-2.6.24-rc2/include/linux/pci_ids.h
@@ -2314,6 +2314,8 @@
 #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
 #define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
 #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
+#define PCI_DEVICE_ID_INTEL_ICH9_7	0x2916
+#define PCI_DEVICE_ID_INTEL_ICH9_8	0x2918
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
 #define PCI_DEVICE_ID_INTEL_82830_CGC	0x3577
