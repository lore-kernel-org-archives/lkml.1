Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZAWTho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZAWTho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZAWThg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:37:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:36019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbZAWThf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:37:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,314,1231142400"; 
   d="scan'208";a="381004432"
From: Seth Heasley <seth.heasley@intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, khali@linux-fr.org
Subject: [PATCH 2.6.29-rc2] irq: irq and pci_ids patch for Intel Tigerpoint DeviceIDs
Date: Fri, 23 Jan 2009 12:43:38 -0800
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901231243.38626.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Tigerpoint LPC Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.29-rc2/arch/x86/pci/irq.c.orig	2009-01-16 12:43:00.000000000 -0800
+++ linux-2.6.29-rc2/arch/x86/pci/irq.c	2009-01-23 11:23:58.000000000 -0800
@@ -572,6 +572,7 @@
 	case PCI_DEVICE_ID_INTEL_ICH7_1:
 	case PCI_DEVICE_ID_INTEL_ICH7_30:
 	case PCI_DEVICE_ID_INTEL_ICH7_31:
+	case PCI_DEVICE_ID_INTEL_TGP_LPC:
 	case PCI_DEVICE_ID_INTEL_ESB2_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_1:
--- linux-2.6.29-rc2/include/linux/pci_ids.h.orig	2009-01-16 12:43:00.000000000 -0800
+++ linux-2.6.29-rc2/include/linux/pci_ids.h	2009-01-23 11:23:58.000000000 -0800
@@ -2421,6 +2421,7 @@
 #define PCI_DEVICE_ID_INTEL_ICH7_0	0x27b8
 #define PCI_DEVICE_ID_INTEL_ICH7_1	0x27b9
 #define PCI_DEVICE_ID_INTEL_ICH7_30	0x27b0
+#define PCI_DEVICE_ID_INTEL_TGP_LPC	0x27bc
 #define PCI_DEVICE_ID_INTEL_ICH7_31	0x27bd
 #define PCI_DEVICE_ID_INTEL_ICH7_17	0x27da
 #define PCI_DEVICE_ID_INTEL_ICH7_19	0x27dd
