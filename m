Return-Path: <linux-kernel-owner+w=401wt.eu-S934283AbYBUXrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbYBUXrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYBUXrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:47:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48829 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYBUXrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:47:10 -0500
Date: Thu, 21 Feb 2008 15:46:44 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.25-rc2 git tree
Message-ID: <20080221234644.GA7128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some PCI patches against your 2.6.25-rc2 git tree.

They are a collection of PCI quirk additions, build fixes, and some PCI
hotplug fixes.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/


The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h


-------------

 arch/x86/kernel/acpi/boot.c        |    3 +-
 arch/x86/pci/irq.c                 |    4 ++
 drivers/pci/hotplug/acpiphp_core.c |    6 +++
 drivers/pci/hotplug/acpiphp_ibm.c  |   33 ++++++++-------
 drivers/pci/pci-acpi.c             |    1 +
 drivers/pci/proc.c                 |    2 +-
 drivers/pci/quirks.c               |   79 ++++++++++++++++++++++++++++++++---
 drivers/pci/setup-bus.c            |    6 +--
 drivers/pcmcia/i82092.c            |    7 +++-
 include/linux/pci_ids.h            |    6 +++
 10 files changed, 117 insertions(+), 30 deletions(-)

---------------

Andrew Morton (2):
      PCI: drivers/pcmcia/i82092.c: fix up after pci_bus_region changes
      PCI: fix up setup-bus.c #ifdef

Crane Cai (1):
      PCI: AMD SATA IDE mode quirk

Gary Hade (1):
      PCI: hotplug: acpiphp_ibm: Remove get device information

Jason Gaston (2):
      PCI: pci_ids: patch for Intel ICH10 DeviceID's
      PCI: irq: patch for Intel ICH10 DeviceID's

Kenji Kaneshige (1):
      PCI: Fix wrong reference counter check for proc_dir_entry

Peer Chen (1):
      PCI: quirks: set 'En' bit of MSI Mapping for devices onHT-based nvidia platform

Randy Dunlap (1):
      PCI: kernel-doc: fix pci-acpi warning

Yinghai Lu (1):
      PCI: don't load acpi_php when acpi is disabled

