Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXHaDbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXHaDbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXHaDbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:31:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:5978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbXHaDbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,328,1183359600"; 
   d="scan'208";a="286317037"
From: Jason Gaston <jason.d.gaston@intel.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu, jason.d.gaston@intel.com
Subject: [PATCH 2.6.23-rc4][reRESEND] irq: irq and pci_ids patch for Intel Tolapai
Date: Thu, 30 Aug 2007 20:33:47 -0700
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708302033.48362.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resend with uppercase define.

This updated patch adds the Intel Tolapai LPC and SMBus controller DID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27 18:32:35.000000000 -0700
+++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-30 20:23:49.000000000 -0700
@@ -550,6 +550,7 @@
 		case PCI_DEVICE_ID_INTEL_ICH9_3:
 		case PCI_DEVICE_ID_INTEL_ICH9_4:
 		case PCI_DEVICE_ID_INTEL_ICH9_5:
+		case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
 			r->name = "PIIX/ICH";
 			r->get = pirq_piix_get;
 			r->set = pirq_piix_set;
--- linux-2.6.23-rc4/include/linux/pci_ids.h.orig	2007-08-27 18:32:35.000000000 -0700
+++ linux-2.6.23-rc4/include/linux/pci_ids.h	2007-08-30 20:23:08.000000000 -0700
@@ -2293,6 +2293,8 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
+#define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
+#define PCI_DEVICE_ID_INTEL_TOLAPAI_1	0x5032
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
 #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
 #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
