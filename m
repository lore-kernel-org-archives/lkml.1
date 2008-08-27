Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYH0Xrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYH0Xrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbYH0XrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:47:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:47885 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbYH0XrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:47:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,283,1217833200"; 
   d="scan'208";a="329729503"
From: Seth Heasley <seth.heasley@intel.com>
To: linux-kernel@vger.kernel.org, khali@linux-fr.org, i2c@lm-sensors.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH 2.6.27-rc4] i2c-i801: SMBus patch for Intel Ibex Peak DeviceIDs
Date: Wed, 27 Aug 2008 16:52:37 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271652.37597.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6/drivers/i2c/busses/Kconfig.orig	2008-08-27 12:11:03.000000000 -0700
+++ linux-2.6/drivers/i2c/busses/Kconfig	2008-08-27 12:11:24.000000000 -0700
@@ -97,6 +97,7 @@
 	    ICH9
 	    Tolapai
 	    ICH10
+	    PCH
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
--- linux-2.6/drivers/i2c/busses/i2c-i801.c.orig	2008-08-27 11:52:45.000000000 -0700
+++ linux-2.6/drivers/i2c/busses/i2c-i801.c	2008-08-27 12:10:50.000000000 -0700
@@ -577,6 +577,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_32) },
 	{ 0, }
 };
 
@@ -600,6 +601,7 @@
 	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_4:
 	case PCI_DEVICE_ID_INTEL_ICH10_5:
+	case PCI_DEVICE_ID_INTEL_PCH_32:
 		i801_features |= FEATURE_I2C_BLOCK_READ;
 		/* fall through */
 	case PCI_DEVICE_ID_INTEL_82801DB_3:
