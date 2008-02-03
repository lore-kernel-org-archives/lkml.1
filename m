Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYBCXHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYBCXHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYBCXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:06:30 -0500
Received: from xenotime.net ([66.160.160.81]:53567 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755214AbYBCXG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:06:29 -0500
Date: Sun, 3 Feb 2008 15:06:25 -0800 (PST)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: greg@kroah.com, len.brown@intel.com, akpm@linux-foundation.org
Subject: [PATCH 5/8] kernel-doc: fix pci-acpi warning
Message-ID: <Pine.LNX.4.64.0802031444390.3021@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix PCI kernel-doc warning:
Warning(linux-2.6.24-git12//drivers/pci/pci-acpi.c:166): No description found for parameter 'hid'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  drivers/pci/pci-acpi.c |    1 +
  1 file changed, 1 insertion(+)

--- linux-2.6.24-git12.orig/drivers/pci/pci-acpi.c
+++ linux-2.6.24-git12/drivers/pci/pci-acpi.c
@@ -158,6 +158,7 @@ run_osc_out:
  /**
   * __pci_osc_support_set - register OS support to Firmware
   * @flags: OS support bits
+ * @hid: hardware ID
   *
   * Update OS support fields and doing a _OSC Query to obtain an update
   * from Firmware on supported control bits.
