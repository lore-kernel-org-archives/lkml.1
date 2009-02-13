Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbZBMTD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbZBMTD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZBMTDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:03:19 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30723 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZBMTDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:03:18 -0500
Date: Fri, 13 Feb 2009 12:03:17 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: Documentation: fix minor PCIe HOWTO thinko
Message-ID: <20090213190317.GB20356@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update doc to correctly refer to replacing the pci_register_driver API,
and not the non-existent "pci_module_init" API.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

diff --git a/Documentation/PCI/PCIEBUS-HOWTO.txt b/Documentation/PCI/PCIEBUS-HOWTO.txt
index 9a07e38..6bd5f37 100644
--- a/Documentation/PCI/PCIEBUS-HOWTO.txt
+++ b/Documentation/PCI/PCIEBUS-HOWTO.txt
@@ -93,7 +93,7 @@ the PCI Express Port Bus driver from loading a service driver.
 
 int pcie_port_service_register(struct pcie_port_service_driver *new)
 
-This API replaces the Linux Driver Model's pci_module_init API. A
+This API replaces the Linux Driver Model's pci_register_driver API. A
 service driver should always calls pcie_port_service_register at
 module init. Note that after service driver being loaded, calls
 such as pci_enable_device(dev) and pci_set_master(dev) are no longer
