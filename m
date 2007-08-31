Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbXHaDkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbXHaDkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXHaDks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:40:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:32801 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbXHaDkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:40:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,328,1183359600"; 
   d="scan'208";a="286319190"
From: Jason Gaston <jason.d.gaston@intel.com>
To: khali@linux-fr.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jason.d.gaston@intel.com, i2c@lm-sensors.org
Subject: [PATCH 2.6.23-rc4][reRESEND] i2c-i801: SMBus patch for Intel Tolapai
Date: Thu, 30 Aug 2007 20:42:58 -0700
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708302042.59104.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resend with uppercase define.

This updated patch adds the Intel Tolapai SMBus Controller DID's.  This patch relies on the Tolapai patch to pci_ids.h 

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc4/drivers/i2c/busses/i2c-i801.c.orig	2007-08-27 18:32:35.000000000 -0700
+++ linux-2.6.23-rc4/drivers/i2c/busses/i2c-i801.c	2007-08-30 20:25:10.000000000 -0700
@@ -34,6 +34,7 @@
     ESB2		269B
     ICH8		283E
     ICH9		2930
+    Tolapai		5032
     This driver supports several versions of Intel's I/O Controller Hubs (ICH).
     For SMBus support, they are similar to the PIIX4 and are part
     of Intel's '810' and other chipsets.
@@ -543,6 +544,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_17) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
 	{ 0, }
 };
 
@@ -563,6 +565,7 @@
 	case PCI_DEVICE_ID_INTEL_ESB2_17:
 	case PCI_DEVICE_ID_INTEL_ICH8_5:
 	case PCI_DEVICE_ID_INTEL_ICH9_6:
+	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
 		isich4 = 1;
 		break;
 	default:
