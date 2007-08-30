Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbXH3Wpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbXH3Wpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763214AbXH3Wos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:44:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:30111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763373AbXH3Woq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,327,1183359600"; 
   d="scan'208";a="286229819"
From: Jason Gaston <jason.d.gaston@intel.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu, jason.d.gaston@intel.com
Subject: [PATCH 2.6.23-rc4] irq: irq and pci_ids patch for Intel Tolapai
Date: Thu, 30 Aug 2007 15:46:56 -0700
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708301546.56998.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updated patch adds the Intel Tolapai LPC and SMBus Controller DID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27 18:32:35.000000000 
-0700
+++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-28 16:58:31.000000000 -0700
@@ -550,6 +550,7 @@
 		case PCI_DEVICE_ID_INTEL_ICH9_3:
 		case PCI_DEVICE_ID_INTEL_ICH9_4:
 		case PCI_DEVICE_ID_INTEL_ICH9_5:
+		case PCI_DEVICE_ID_INTEL_Tolapai_0:
 			r->name = "PIIX/ICH";
 			r->get = pirq_piix_get;
 			r->set = pirq_piix_set;
--- linux-2.6.23-rc4/include/linux/pci_ids.h.orig	2007-08-27 
18:32:35.000000000 -0700
+++ linux-2.6.23-rc4/include/linux/pci_ids.h	2007-08-28 16:58:31.000000000 
-0700
@@ -2293,6 +2293,8 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
+#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
+#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
 #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
 #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
