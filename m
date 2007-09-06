Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXIFRZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXIFRZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXIFRY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:24:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:15634 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXIFRY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,216,1186383600"; 
   d="scan'208";a="273358203"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc4][reRESEND] irq: irq and pci_ids patch for Intel Tolapai
Date: Thu, 6 Sep 2007 10:24:54 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE0701B9A4C4@orsmsx420.amr.corp.intel.com>
In-Reply-To: <200708302033.48362.jason.d.gaston@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc4][reRESEND] irq: irq and pci_ids patch for Intel Tolapai
thread-index: Acfrf3Hep2kehoqCRkKVMejRAvC9+AFKuXnA
References: <200708302033.48362.jason.d.gaston@intel.com>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <khali@linux-fr.org>,
       "LM Sensors" <lm-sensors@lm-sensors.org>
Cc: "Gaston, Jason D" <jason.d.gaston@intel.com>
X-OriginalArrivalTime: 06 Sep 2007 17:24:55.0457 (UTC) FILETIME=[D7898910:01C7F0AA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Gaston, Jason D
>Sent: Thursday, August 30, 2007 8:34 PM
>To: gregkh@suse.de; linux-kernel@vger.kernel.org; linux-
>pci@atrey.karlin.mff.cuni.cz; khali@linux-fr.org; i2c@lm-sensors.nu;
>Gaston, Jason D
>Subject: [PATCH 2.6.23-rc4][reRESEND] irq: irq and pci_ids patch for
Intel
>Tolapai
>
>Resend with uppercase define.
>
>This updated patch adds the Intel Tolapai LPC and SMBus controller
DID's.
>
>Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>
>--- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27
>18:32:35.000000000 -0700
>+++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-30
20:23:49.000000000 -
>0700
>@@ -550,6 +550,7 @@
> 		case PCI_DEVICE_ID_INTEL_ICH9_3:
> 		case PCI_DEVICE_ID_INTEL_ICH9_4:
> 		case PCI_DEVICE_ID_INTEL_ICH9_5:
>+		case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
> 			r->name = "PIIX/ICH";
> 			r->get = pirq_piix_get;
> 			r->set = pirq_piix_set;
>--- linux-2.6.23-rc4/include/linux/pci_ids.h.orig	2007-08-27
>18:32:35.000000000 -0700
>+++ linux-2.6.23-rc4/include/linux/pci_ids.h	2007-08-30
>20:23:08.000000000 -0700
>@@ -2293,6 +2293,8 @@
> #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
> #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
> #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
>+#define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
>+#define PCI_DEVICE_ID_INTEL_TOLAPAI_1	0x5032
> #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
> #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
> #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020

Greg,

Is this patch acceptable?  I need to get this in before the i2c-i801
patch will be accepted.

Thanks,

Jason
