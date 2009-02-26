Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbZBZWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbZBZWZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbZBZWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:25:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:9625 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbZBZWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:25:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,273,1233561600"; 
   d="scan'208";a="390111239"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Thu, 26 Feb 2009 14:24:28 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261424.28906.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

A few documentation fixes/additions, quirks, and the obligatory hotplug
related fixes.

Alex Chiang (1):
      PCI: Documentation: fix minor PCIe HOWTO thinko

Andrew Patterson (1):
      PCI: Enable PCIe AER only after checking firmware support

Chris Wright (1):
      PCI: add some sysfs ABI docs

Eric W. Biederman (1):
      PCI: pciehp: Handle interrupts that happen during initialization.

Matthew Wilcox (1):
      PCI/MSI: fix msi_mask() shift fix

Randy Dunlap (3):
      PCI: fix rom.c kernel-doc warning
      PCI: fix struct pci_platform_pm_ops kernel-doc
      PCI: fix missing kernel-doc and typos

Stefan Assmann (1):
      PCI: AMD 813x B2 devices do not need boot interrupt quirk

Yinghai Lu (2):
      PCI quirk: enable MSI on 8132
      PCI: don't enable too many HT MSI mappings

 Documentation/ABI/testing/sysfs-bus-pci |   43 +++++++++++
 Documentation/PCI/PCIEBUS-HOWTO.txt     |    2 +-
 drivers/pci/hotplug/pciehp.h            |    2 +
 drivers/pci/hotplug/pciehp_core.c       |    7 ++
 drivers/pci/hotplug/pciehp_hpc.c        |   15 ++--
 drivers/pci/msi.c                       |   10 +--
 drivers/pci/pci.c                       |   13 ++-
 drivers/pci/pci.h                       |   20 +++---
 drivers/pci/pcie/aer/aerdrv_core.c      |   48 ++++++++++--
 drivers/pci/pcie/portdrv_pci.c          |    2 -
 drivers/pci/quirks.c                    |  122 +++++++++++++++++++++++++++----
 drivers/pci/rom.c                       |    1 +
 12 files changed, 229 insertions(+), 56 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
