Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYJTUBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYJTUBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYJTUAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:00:53 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:60215 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751415AbYJTUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:00:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=E4jP0UUyk9FjrqOdmPDH+Ua51WQK9sg8LmFUynkMDGJ7Mp9/gFW72esCxtgzYWDYLrfsf9ZkIxE+Utj7C1WGWp4gKtphfPqYSni+fUJVfASaFShx2c1GamwFJ4tjlxw4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI pull request for 2.6.28
Date: Mon, 20 Oct 2008 13:00:42 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>,
       Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201300.42950.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my linux-next branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git linux-next

I would have preferred to send this sooner, but I seem to flee the country
whenever a merge window opens (well that and I totally horked my tree with
a bad rebase, so I needed to fix it up, rebase again, and re-test a bit).

Anyway, shortlog and diffstat are below for confirmation, sorry for the
delay.

Thanks,
Jesse

Alex Chiang (1):
      PCI: connect struct pci_dev to struct pci_slot

Andi Kleen (1):
      PCI: Document that most pci options are shared between i386 and x86-64

Arjan van de Ven (1):
      PCI: introduce an pci_ioremap(pdev, barnr) function

Benjamin Herrenschmidt (2):
      PCI: Add ability to mmap legacy_io on some platforms
      powerpc/PCI: Add legacy PCI access via sysfs

Bjorn Helgaas (3):
      x86/PCI: follow lspci device/vendor style
      PCI: follow lspci device/vendor style
      PCI: tidy PME support messages

Chuck Ebbert (1):
      PCI: document the pcie_aspm kernel parameter

Heiko Carstens (1):
      PCI: fix pci_ioremap_bar() on s390

Jean Delvare (1):
      PCI: Check dynids driver_data value for validity

Jesse Barnes (3):
      PCI: fix -Wakpm warnings in pci_pm_init debug output
      PCI: remove #ifdef DEBUG around dev_dbg call
      PCI: use pci_find_ext_capability everywhere

Jike Song (1):
      PCI: utilize calculated results when detecting MSI features

Kenji Kaneshige (2):
      PCI: pciehp: fix irq initialization
      PCI hotplug: fix get_##name return value problem

Kristen Carlson Accardi (1):
      PCI hotplug: rpaphp: make debug var unique

Mike Travis (1):
      PCI: make CPU list affinity visible

Milton Miller (1):
      PCI: remove dynids.use_driver_data

Peter Chubb (1):
      PCI: fix 64-vbit prefetchable memory resource BARs

Rafael J. Wysocki (1):
      PCI PM: Introduce function pci_wake_from_d3

Roland Dreier (1):
      PCI: fix MSI-HOWTO.txt info about MSI-X MMIO space

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Ibex Peak DeviceIDs

Stephen Hemminger (1):
      PCI: fix sparse warning in pci_remove_behind_bridge

Taku Izumi (2):
      PCI: pciehp: change name tag of "hpdriver_portdrv" variable
      PCI: pciehp: replace printk with dev_printk

Thomas Petazzoni (1):
      PCI: allow quirks to be compiled out

Vincent Legoll (1):
      PCI: probing debug message uniformization

Yinghai Lu (2):
      PCI: change MSI-x vector to 32bit
      PCI: use %pF instead of print_fn_descriptor_symbol() in quirks.c

Yu Zhao (2):
      PCI: support PCIe ARI capability
      PCI: fix AER capability check

Zhao, Yu (6):
      PCI: fix hotplug get_##name return value problem
      PCI: use same arg names in PCI_VDEVICE comment
      PCI: use resource_size() everywhere.
      PCI: replace cfg space size (256/4096) by macros.
      PCI: centralize the capabilities code in pci-sysfs.c
      PCI: centralize the capabilities code in probe.c

akpm@linux-foundation.org (2):
      PCI: ibmphp: list_for_each to list_for_each_entry
      PCI: ibmphp: list_for_each to list_for_each_entry-checkpatch cleanups

 Documentation/MSI-HOWTO.txt            |    6 +-
 Documentation/PCI/pci.txt              |    4 +
 Documentation/PCI/pcieaer-howto.txt    |   11 +-
 Documentation/kernel-parameters.txt    |   31 +++--
 arch/ia64/include/asm/pci.h            |   12 +--
 arch/ia64/pci/pci.c                    |    7 +-
 arch/powerpc/include/asm/pci-bridge.h  |    7 +
 arch/powerpc/include/asm/pci.h         |   11 ++
 arch/powerpc/kernel/pci-common.c       |  136 ++++++++++++++++++-
 arch/x86/pci/irq.c                     |   19 ++-
 drivers/i2c/busses/i2c-amd756.c        |    5 -
 drivers/i2c/busses/i2c-viapro.c        |    5 -
 drivers/pci/bus.c                      |    7 +
 drivers/pci/hotplug/ibmphp_ebda.c      |   92 +++---------
 drivers/pci/hotplug/pci_hotplug_core.c |   14 +-
 drivers/pci/hotplug/pciehp.h           |   16 ++-
 drivers/pci/hotplug/pciehp_core.c      |   78 ++++++----
 drivers/pci/hotplug/pciehp_ctrl.c      |  136 ++++++++++--------
 drivers/pci/hotplug/pciehp_hpc.c       |  202 +++++++++++++++-----------
 drivers/pci/hotplug/pciehp_pci.c       |   26 ++--
 drivers/pci/hotplug/rpaphp.h           |    4 +-
 drivers/pci/hotplug/rpaphp_core.c      |    4 +-
 drivers/pci/hotplug/rpaphp_pci.c       |    2 +-
 drivers/pci/msi.c                      |   10 +-
 drivers/pci/pci-driver.c               |   21 +++-
 drivers/pci/pci-sysfs.c                |  241 +++++++++++++++++++++++---------
 drivers/pci/pci.c                      |   91 ++++++++++---
 drivers/pci/pci.h                      |   26 ++++
 drivers/pci/pcie/aer/aerdrv.c          |    6 +-
 drivers/pci/pcie/aer/aerdrv_core.c     |   47 ++-----
 drivers/pci/pcie/aspm.c                |    6 +-
 drivers/pci/pcie/portdrv.h             |    1 -
 drivers/pci/pcie/portdrv_core.c        |   23 +---
 drivers/pci/pcie/portdrv_pci.c         |    2 +-
 drivers/pci/probe.c                    |  133 ++++++------------
 drivers/pci/quirks.c                   |  173 ++++++++++++-----------
 drivers/pci/remove.c                   |   11 +-
 drivers/pci/setup-bus.c                |    4 +-
 drivers/pci/setup-res.c                |    2 +-
 drivers/pci/slot.c                     |   10 ++
 drivers/scsi/ipr.c                     |    1 -
 drivers/scsi/qla2xxx/qla_def.h         |    2 +-
 drivers/scsi/qla2xxx/qla_os.c          |    5 +-
 include/linux/aer.h                    |    5 -
 include/linux/pci.h                    |   24 +++-
 include/linux/pci_ids.h                |    6 +-
 include/linux/pci_regs.h               |   14 ++
 init/Kconfig                           |    8 +
 48 files changed, 1026 insertions(+), 681 deletions(-)

