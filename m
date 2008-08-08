Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbYHHXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbYHHXFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYHHXFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:05:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:12854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYHHXFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:05:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="324554563"
From: Seth Heasley <seth.heasley@intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: [PATCH 2.6.26.2] irq: patch for Intel Ibex Peak DeviceIDs
Date: Fri, 8 Aug 2008 16:10:15 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081610.15704.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) LPC Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.26.2/arch/x86/pci/irq.c.orig      2008-08-08 11:23:03.000000000 -0700
+++ linux-2.6.26.2/arch/x86/pci/irq.c   2008-08-08 11:24:02.000000000 -0700
@@ -589,6 +589,8 @@
                case PCI_DEVICE_ID_INTEL_ICH10_1:
                case PCI_DEVICE_ID_INTEL_ICH10_2:
                case PCI_DEVICE_ID_INTEL_ICH10_3:
+               case PCI_DEVICE_ID_INTEL_PCH_0:
+               case PCI_DEVICE_ID_INTEL_PCH_1:
                        r->name = "PIIX/ICH";
                        r->get = pirq_piix_get;
                        r->set = pirq_piix_set;
