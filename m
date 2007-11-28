Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbXK1WtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbXK1WtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbXK1Ws7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:48:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbXK1Ws6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:48:58 -0500
Date: Wed, 28 Nov 2007 14:47:55 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.24-rc3
Message-ID: <20071128224755.GB28410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a some PCI fixes against your 2.6.24-rc3 git tree.

They are just some minor fixes and a number of kerneldoc warning fixes
as well.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h

-------------

 drivers/pci/hotplug/acpiphp.h       |    8 ++--
 drivers/pci/hotplug/acpiphp_core.c  |   29 ++++------
 drivers/pci/hotplug/acpiphp_glue.c  |   36 ++++++--------
 drivers/pci/hotplug/acpiphp_ibm.c   |   47 +++++++++--------
 drivers/pci/hotplug/cpqphp_core.c   |   41 ++++++++-------
 drivers/pci/hotplug/cpqphp_ctrl.c   |   96 +++++++++++++++++------------------
 drivers/pci/hotplug/fakephp.c       |   14 +++---
 drivers/pci/hotplug/pciehp_ctrl.c   |   16 +++---
 drivers/pci/hotplug/rpadlpar_core.c |   19 +++----
 drivers/pci/hotplug/rpaphp_core.c   |   15 ++++-
 drivers/pci/hotplug/rpaphp_pci.c    |    1 +
 drivers/pci/hotplug/shpchp_ctrl.c   |   16 +++---
 drivers/pci/pci-sysfs.c             |    4 +-
 drivers/pci/pcie/aer/aerdrv_core.c  |   29 ++++++-----
 drivers/pci/pcie/portdrv_pci.c      |    2 +-
 15 files changed, 188 insertions(+), 185 deletions(-)

---------------

Julia Lawall (1):
      PCI: drivers/pci/pci-sysfs.c: Add missing pci_dev_put

Linas Vepstas (1):
      PCI: pcie portdriver: initialize returned value

Randy Dunlap (2):
      pci-aer: fix kernel-doc mistakes
      pci hotplug: kernel-doc fixes

