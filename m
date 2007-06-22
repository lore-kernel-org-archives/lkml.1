Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbXFVUsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbXFVUsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXFVUse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:48:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:47363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXFVUsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:48:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="99302284"
Date: Fri, 22 Jun 2007 13:44:11 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 7/7] ICH Force HPET: Add ICH7_0 pciid to quirk list
Message-ID: <20070622204411.GG22807@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Add another PCI ID for ICH7 force hpet.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21/arch/i386/kernel/quirks.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/quirks.c
+++ linux-2.6.21/arch/i386/kernel/quirks.c
@@ -149,6 +149,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
                          ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,
+                         ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1,
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,
