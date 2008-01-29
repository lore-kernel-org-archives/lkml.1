Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYA2AWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYA2AWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYA2AWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:22:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:63814 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764390AbYA2AWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:22:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="331187253"
From: Jason Gaston <jason.d.gaston@intel.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, jason.d.gaston@intel.com
Subject: [PATCH 2.6.24] irq: patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 17:24:37 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281724.37858.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 LPC Controller DeviceID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24/arch/x86/pci/irq.c.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/arch/x86/pci/irq.c	2008-01-28 14:58:22.000000000 -0800
@@ -571,6 +571,10 @@
 		case PCI_DEVICE_ID_INTEL_ICH9_4:
 		case PCI_DEVICE_ID_INTEL_ICH9_5:
 		case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
+		case PCI_DEVICE_ID_INTEL_ICH10_0:
+		case PCI_DEVICE_ID_INTEL_ICH10_1:
+		case PCI_DEVICE_ID_INTEL_ICH10_2:
+		case PCI_DEVICE_ID_INTEL_ICH10_3:
 			r->name = "PIIX/ICH";
 			r->get = pirq_piix_get;
 			r->set = pirq_piix_set;
