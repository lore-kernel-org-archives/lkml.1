Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZAUTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZAUTK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 14:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZAUTKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 14:10:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:62051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZAUTKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,301,1231142400"; 
   d="scan'208";a="380387223"
From: Seth Heasley <seth.heasley@intel.com>
To: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, khali@linux-fr.org
Subject: [PATCH 2.6.28.1] irq: irq and pci_ids patch for Intel Tigerpoint DeviceIDs
Date: Wed, 21 Jan 2009 12:16:19 -0800
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211216.20284.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Tigerpoint LPC Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.28.1/include/linux/pci_ids.h.orig	2009-01-20 06:49:00.000000000 -0800
+++ linux-2.6.28.1/include/linux/pci_ids.h	2009-01-20 06:57:18.000000000 -0800
@@ -2412,6 +2412,7 @@
 #define PCI_DEVICE_ID_INTEL_ICH7_0	0x27b8
 #define PCI_DEVICE_ID_INTEL_ICH7_1	0x27b9
 #define PCI_DEVICE_ID_INTEL_ICH7_30	0x27b0
+#define PCI_DEVICE_ID_INTEL_TGP_LPC	0x27bc
 #define PCI_DEVICE_ID_INTEL_ICH7_31	0x27bd
 #define PCI_DEVICE_ID_INTEL_ICH7_17	0x27da
 #define PCI_DEVICE_ID_INTEL_ICH7_19	0x27dd
--- linux-2.6.28.1/arch/x86/pci/irq.c.orig	2009-01-20 06:57:33.000000000 -0800
+++ linux-2.6.28.1/arch/x86/pci/irq.c	2009-01-20 07:01:09.000000000 -0800
@@ -573,6 +573,7 @@
 	case PCI_DEVICE_ID_INTEL_ICH7_1:
 	case PCI_DEVICE_ID_INTEL_ICH7_30:
 	case PCI_DEVICE_ID_INTEL_ICH7_31:
+	case PCI_DEVICE_ID_INTEL_TGP_LPC:
 	case PCI_DEVICE_ID_INTEL_ESB2_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_1:

