Return-Path: <linux-kernel-owner+w=401wt.eu-S935018AbYCDXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018AbYCDXSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934869AbYCDXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:15:38 -0500
Received: from ns2.suse.de ([195.135.220.15]:42564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934823AbYCDXPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:15:36 -0500
Date: Tue, 4 Mar 2008 15:15:09 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.25-rc3 git tree
Message-ID: <20080304231509.GA3073@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some PCI patches against your 2.6.25-rc3 git tree.

Some more quirk fixups, a pci hotplug fix, and hopefully the final
section mismatch fixup.  I've also added the DECLARE_PCI_DEVICE_TABLE
macro so that other driver authors can start converting their code over
easier.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

A lot of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h


-------------

 Documentation/pci.txt                  |    6 +++-
 drivers/pci/bus.c                      |   10 ++++---
 drivers/pci/hotplug-pci.c              |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c       |    5 ++-
 drivers/pci/hotplug/pciehp_pci.c       |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/probe.c                    |    8 +++---
 drivers/pci/quirks.c                   |   41 ++++++-------------------------
 include/linux/pci.h                    |   10 +++++++
 11 files changed, 40 insertions(+), 50 deletions(-)

---------------

Bjorn Helgaas (2):
      PCI: use dev_printk in quirk messages
      PCI: consolidate duplicated MSI enable functions

Greg Kroah-Hartman (1):
      PCI: fix up error messages for pci_bus registering

Jonas Bonn (1):
      PCI: Add DECLARE_PCI_DEVICE_TABLE macro

Kenji Kaneshige (1):
      pci: hotplug: pciehp: fix error code path in hpc_power_off_slot

Sam Ravnborg (1):
      PCI: fix section mismatch warning in pci_scan_child_bus

