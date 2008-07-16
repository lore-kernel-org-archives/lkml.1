Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbYGPXjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbYGPXjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYGPXj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:39:28 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:52812 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754744AbYGPXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:39:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=EZQHU/yWlk70fgyFlEc7H6EJJyF4prLHPxu1uJppDW4Xp3ywSkOM/iAsF/yD3zZjdpg/voYslKSfvJEPB33r+qV8gv1hiAtUrh6rm0LgUpoxJAv3iS5zg6RM4s3uwOs9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI pull request for 2.6.27
Date: Wed, 16 Jul 2008 16:39:24 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161639.24289.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my linux-next branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git linux-next

I'm open to suggestions here about a couple of caveats with this pull:
  - it's not merged up to master (though the conflicts are fairly trivial,
    you can check out my linux-next-merge branch to see how I handled them)
  - it contains a revert for a patch I thought might be ready but have since
    chickened out on.  I didn't want to rebase since I'm carrying some
    changes from the ACPI tree

But if you're ok with that, please pull away.  Diffstat & shortlog below.
Note that the diffstat is actually from my linux-next-merge tree since my
master branch is up-to-date but my linux-next branch isn't, but it should
be pretty close to what you end up with after you merge.

Thanks,
Jesse

Adrian Bunk (4):
      PCI: make {pciehp,shpchp}_slot_with_bus static
      PCI: drivers/pci/pci.c: add prototypes
      PCI: remove CVS keywords
      PCI: remove unused arch pcibios_update_resource() functions

Alex Chiang (4):
      PCIe: fix 'symbol not declared' sparse warnings
      PCI: construct one fakephp slot per PCI slot
      PCI: introduce pci_slot
      PCI: ACPI PCI slot detection driver

Alok Kataria (1):
      x86/PCI: ACPI based PCI gap calculation

Bjorn Helgaas (3):
      PCI: use dev_printk when possible
      PCIE: aer: use dev_printk when possible
      PCIE: port driver: use dev_printk when possible

David Brownell (1):
      ACPI PM: acpi_pm_device_sleep_state() cleanup

David Howells (2):
      PCI: fix pci_setup_device()'s sprinting into a const buffer
      Fix acpi_pm_device_sleep_wake() by providing a stub for CONFIG_PM_SLEEP=n

Gary Hade (1):
      PCI: boot parameter to avoid expansion ROM memory allocation

Greg Kroah-Hartman (2):
      PCI: handle pci_name() being const
      PCI: make pci_name use dev_name

Hidetoshi Seto (1):
      PCI/MSI: skip calling pci_find_capability from msi_set_mask_bits

Jean Delvare (1):
      PCI: Unhide the SMBus on the Compaq Evo D510

Jesse Barnes (6):
      PCI: update location of PCI hotplug mailing lists
      Merge branch 'suspend' of git://git.kernel.org/.../lenb/linux-acpi-2.6 into linux-next
      x86/PCI: fixup early quirk probing
      PCI: fixup kdoc blocks for hotplug functions
      PCI: correct resource number in debug output
      Revert "x86/PCI: ACPI based PCI gap calculation"

Julia Lawall (1):
      PCI: eliminate double kfree in intel-iommu initialization

Kenji Kaneshige (19):
      pci-acpi: remove duplicate code for _OSC
      pci-acpi: use local buffer for _OSC
      pci-acpi: add flag to indicate query had been done
      pci-acpi: remove unused variable in __pci_osc_support_set
      pci-acpi: formatting cleanups for _OSC
      pciehp: remove redundant pci_dev initialization
      pciehp: evaluate _OSC/OSHP before controller init
      pciehp: block signals while waiting for command completion
      shpchp: check firmware before taking control
      pciehp: fixes typo in dbg_ctrl() in pciehp_hpc.c
      pciehp: removes redundant NULL write to slot status register
      pciehp: fix typo in hpc_release_ctlr
      pciehp: cleanup pcie_poll_cmd
      pciehp: change command polling frequency
      pciehp: remove inline from command related functions
      Remove unnecessary 'tmp' variable from pci_hp_register().
      pciehp: fix interrupt initialization
      pciehp: remove needless command completed interrupt setting
      pciehp: use get_service_data

Krzysztof Helt (1):
      PCI: unhide the SMBus on the Compaq Deskpro EN

Matthew Wilcox (1):
      x86/PCI: Fix PCI config space for domains > 0

Miklos Vajna (1):
      x86/PCI: janitor work in irq.c

Ming Lei (1):
      PCI: remove unnecessary volatile in PCIe hotplug struct controller

Rafael J. Wysocki (16):
      Suspend/Resume bug in PCI layer wrt quirks
      Introduce new top level suspend and hibernation callbacks
      PCI: implement new suspend/resume callbacks
      Implement new suspend and hibernation callbacks for platform busses
      PCI ACPI: Drop the second argument of platform_pci_choose_state
      ACPI PM: Remove obsolete Toshiba workaround
      Suspend-related patches for 2.6.27
      ACPI: Introduce acpi_bus_power_manageable function
      PCI: Introduce platform_pci_power_manageable function
      PCI: rework pci_set_power_state function to call platform first
      ACPI: Introduce acpi_device_sleep_wake function
      ACPI: Introduce new device wakeup flag 'prepared'
      PCI ACPI: Rework PCI handling of wake-up
      PCI PM: Introduce pci_prepare_to_sleep and pci_back_from_sleep
      PCI: Simplify PCI device PM code
      PCI PM: Fix pci_prepare_to_sleep

Randy Dunlap (1):
      PCI: add stub for pci_set_consistent_dma_mask()

Robert P. J. Day (1):
      PCI: Replace deprecated __initcall with device_initcall.

Stephen Rothwell (1):
      PCI: include linux/pm_wakeup.h for device_set_wakeup_capable

Wang Chen (1):
      PCI: Fix comment of pci_dynids

Yinghai Lu (2):
      PCI/x86: write_pci_config_byte fix offset
      PCI/x86: early dump pci conf space v2

Zhao Yakui (1):
      PCI: Disable PME during PCI scan

 Documentation/kernel-parameters.txt     |    9 +-
 MAINTAINERS                             |   12 +-
 arch/frv/mb93090-mb00/pci-frv.c         |   30 -
 arch/m68knommu/kernel/comempci.c        |    9 -
 arch/mips/pmc-sierra/yosemite/ht.c      |   36 --
 arch/sh/drivers/pci/pci.c               |   32 --
 arch/sparc64/kernel/pci.c               |    2 +-
 arch/x86/kernel/acpi/sleep.c            |    2 +
 arch/x86/kernel/apm_32.c                |    8 +-
 arch/x86/kernel/early-quirks.c          |   26 +-
 arch/x86/kernel/setup.c                 |    5 +
 arch/x86/pci/common.c                   |   30 +-
 arch/x86/pci/early.c                    |   60 ++-
 arch/x86/pci/irq.c                      |  258 ++++++---
 arch/x86/pci/pci.h                      |    3 +-
 drivers/acpi/Kconfig                    |    9 +
 drivers/acpi/Makefile                   |    1 +
 drivers/acpi/bus.c                      |   22 +
 drivers/acpi/glue.c                     |    2 +
 drivers/acpi/pci_slot.c                 |  368 ++++++++++++
 drivers/acpi/power.c                    |  138 ++++--
 drivers/acpi/scan.c                     |   42 +--
 drivers/acpi/sleep/main.c               |  328 +++++++-----
 drivers/acpi/sleep/wakeup.c             |   13 +-
 drivers/base/platform.c                 |  296 ++++++++++-
 drivers/base/power/main.c               |  675 ++++++++++++++++++-----
 drivers/base/power/power.h              |    2 +-
 drivers/base/power/sysfs.c              |    3 -
 drivers/base/power/trace.c              |    4 +-
 drivers/pci/Makefile                    |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c        |   85 +++-
 drivers/pci/hotplug/acpiphp.h           |    1 -
 drivers/pci/hotplug/acpiphp_core.c      |   25 +-
 drivers/pci/hotplug/acpiphp_glue.c      |   23 +-
 drivers/pci/hotplug/acpiphp_ibm.c       |    6 +-
 drivers/pci/hotplug/cpci_hotplug_core.c |    2 +-
 drivers/pci/hotplug/cpqphp_core.c       |    4 +-
 drivers/pci/hotplug/fakephp.c           |   86 +--
 drivers/pci/hotplug/ibmphp_ebda.c       |    3 +-
 drivers/pci/hotplug/pci_hotplug_core.c  |  284 ++++------
 drivers/pci/hotplug/pciehp.h            |   16 +-
 drivers/pci/hotplug/pciehp_core.c       |  127 ++----
 drivers/pci/hotplug/pciehp_hpc.c        |  318 +++++------
 drivers/pci/hotplug/rpadlpar_sysfs.c    |    5 +-
 drivers/pci/hotplug/rpaphp_slot.c       |   44 +--
 drivers/pci/hotplug/sgi_hotplug.c       |   12 +-
 drivers/pci/hotplug/shpchp.h            |   14 +-
 drivers/pci/hotplug/shpchp_core.c       |   37 +-
 drivers/pci/hotplug/shpchp_hpc.c        |    1 -
 drivers/pci/intel-iommu.c               |    1 -
 drivers/pci/msi.c                       |   22 +-
 drivers/pci/pci-acpi.c                  |  277 +++++-----
 drivers/pci/pci-driver.c                |  388 ++++++++++++--
 drivers/pci/pci.c                       |  479 ++++++++++++-----
 drivers/pci/pci.h                       |   48 ++-
 drivers/pci/pcie/aer/aerdrv.c           |    9 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c      |    8 +-
 drivers/pci/pcie/aer/aerdrv_core.c      |   24 +-
 drivers/pci/pcie/portdrv_bus.c          |    1 +
 drivers/pci/pcie/portdrv_core.c         |   22 +-
 drivers/pci/pcie/portdrv_pci.c          |    5 +-
 drivers/pci/probe.c                     |   38 +-
 drivers/pci/proc.c                      |    4 +-
 drivers/pci/quirks.c                    |  134 ++++--
 drivers/pci/setup-bus.c                 |   43 +-
 drivers/pci/setup-irq.c                 |    3 +-
 drivers/pci/setup-res.c                 |   70 ++--
 drivers/pci/slot.c                      |  233 ++++++++
 drivers/pnp/pnpacpi/core.c              |    4 +-
 include/acpi/acpi_bus.h                 |   12 +-
 include/acpi/acpi_drivers.h             |    4 +-
 include/asm-generic/vmlinux.lds.h       |    6 +
 include/asm-x86/pci-direct.h            |    4 +
 include/linux/acpi.h                    |    3 +
 include/linux/device.h                  |    9 +
 include/linux/pci.h                     |   57 ++-
 include/linux/pci_hotplug.h             |   14 +-
 include/linux/pci_regs.h                |    1 +
 include/linux/platform_device.h         |    1 +
 include/linux/pm.h                      |  314 ++++++++++-
 include/linux/pm_wakeup.h               |   28 +-
 include/linux/suspend.h                 |   14 +-
 kernel/power/disk.c                     |   50 ++-
 kernel/power/main.c                     |   16 +-
 lib/kobject.c                           |    1 +
 85 files changed, 4061 insertions(+), 1806 deletions(-)
 create mode 100644 drivers/acpi/pci_slot.c
 create mode 100644 drivers/pci/slot.c
