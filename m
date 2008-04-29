Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbYD2RNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbYD2RNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYD2RMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:12:33 -0400
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:51727 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756351AbYD2RMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:12:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI updates for 2.6.26
Date: Tue, 29 Apr 2008 10:12:21 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291012.21832.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing really major here: some bug fixes, documentation fixes and some
trivial stuff for 2.6.26.  Some of the more important changes are actually
coming in through Ingo's "big box" tree, so the excitement (and risk) level
here should be pretty low.

So please pull from

git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

I hope I got this tree right; I read through some of the earlier discussions
about how trees should be run.  This branch hasn't seen any merges from your
tree (I think you suggested this); hopefully there won't be any conflicts.

Thanks,
Jesse

Adrian Bunk (1):
      make pciehp_acpi_get_hp_hw_control_from_firmware()

Alek Du (1):
      PCI: Add Intel SCH PCI IDs

Jesper Juhl (1):
      PCI Express ASPM support should default to 'No'

Jesse Barnes (2):
      Update MAINTAINERS with location of PCI tree
      PCI: don't expose struct pci_vpd to userspace

Kenji Kaneshige (11):
      pciehp: fix slot name
      pciehp: Fix interrupt event handlig
      pciehp: Add missing memory barrier
      pciehp: Fix wrong slot control register access
      pciehp: Fix wrong slot capability check
      pciehp: Remove useless hotplug interrupt enabling
      pciehp: Mask hotplug interrupt at controller release
      pciehp: Clean up pcie_init()
      shpchp: fix slot name
      pciehp: Fix command write
      pciehp: fix error message about getting hotplug control

Matti Linnanvuori (3):
      Consistently use pdev as the variable of type struct pci_dev *.
      doc: fix an incorrect suggestion to pass NULL for PCI like buses
      doc: replace another dev with pdev for consistency in DMA-mapping.txt

Yinghai Lu (2):
      pci/irq: restore mask_bits in msi shutdown -v3
      pci/irq: let pci_device_shutdown to call pci_msi_shutdown v2

 Documentation/DMA-mapping.txt     |   38 +-
 MAINTAINERS                       |    1
 drivers/pci/hotplug/pciehp.h      |   17 -
 drivers/pci/hotplug/pciehp_core.c |   19 -
 drivers/pci/hotplug/pciehp_ctrl.c |   46 +--
 drivers/pci/hotplug/pciehp_hpc.c  |  565 +++++++++++---------------------------
 drivers/pci/hotplug/shpchp_core.c |   11
 drivers/pci/msi.c                 |   56 ++-
 drivers/pci/pci-driver.c          |    2
 drivers/pci/pcie/Kconfig          |    2
 include/linux/msi.h               |    1
 include/linux/pci.h               |   10
 include/linux/pci_ids.h           |    2
 13 files changed, 302 insertions(+), 468 deletions(-)

