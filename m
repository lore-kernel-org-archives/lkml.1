Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZBFXpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZBFXpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZBFXp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:45:28 -0500
Received: from kroah.org ([198.145.64.141]:53280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753071AbZBFXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:45:27 -0500
Date: Fri, 6 Feb 2009 15:44:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.15
Message-ID: <20090206234439.GB30958@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.15
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.14 and 2.6.27.15

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 
 arch/ia64/sn/kernel/io_acpi_init.c  |    8 +--
 arch/m68knommu/Kconfig              |    4 +
 arch/x86/Kconfig                    |    3 +
 arch/x86/kernel/acpi/cstate.c       |    4 +
 arch/x86/lib/usercopy_32.c          |    4 -
 arch/x86/lib/usercopy_64.c          |    4 -
 arch/x86/mm/pageattr.c              |   49 ++++++++++++------
 arch/x86/pci/irq.c                  |    1 
 drivers/acpi/ac.c                   |    2 
 drivers/acpi/acpi_memhotplug.c      |    5 -
 drivers/acpi/asus_acpi.c            |    4 +
 drivers/acpi/battery.c              |    5 +
 drivers/acpi/bay.c                  |    2 
 drivers/acpi/bus.c                  |    4 -
 drivers/acpi/button.c               |    4 -
 drivers/acpi/container.c            |    2 
 drivers/acpi/dispatcher/dsmethod.c  |    3 +
 drivers/acpi/dock.c                 |    6 +-
 drivers/acpi/ec.c                   |    8 ++-
 drivers/acpi/namespace/nsutils.c    |    8 ++-
 drivers/acpi/namespace/nsxfname.c   |    1 
 drivers/acpi/numa.c                 |    2 
 drivers/acpi/osl.c                  |    5 -
 drivers/acpi/parser/psparse.c       |    4 +
 drivers/acpi/pci_link.c             |    4 -
 drivers/acpi/pci_root.c             |    2 
 drivers/acpi/pci_slot.c             |   10 +--
 drivers/acpi/power.c                |    2 
 drivers/acpi/processor_core.c       |    4 -
 drivers/acpi/processor_idle.c       |    1 
 drivers/acpi/processor_perflib.c    |    2 
 drivers/acpi/processor_throttling.c |    2 
 drivers/acpi/sbshc.c                |    2 
 drivers/acpi/scan.c                 |   12 +++-
 drivers/acpi/sleep/main.c           |   10 +++
 drivers/acpi/thermal.c              |   43 ++++++++++------
 drivers/acpi/utils.c                |    4 -
 drivers/acpi/video.c                |   47 +++++++++--------
 drivers/ata/libata-acpi.c           |    2 
 drivers/ata/sata_mv.c               |    6 +-
 drivers/ata/sata_nv.c               |   77 ++++++++++++++++++----------
 drivers/char/selection.c            |    2 
 drivers/cpuidle/cpuidle.c           |    9 +++
 drivers/cpuidle/governors/menu.c    |   10 +++
 drivers/input/keyboard/atkbd.c      |   34 ++++++++++++
 drivers/misc/asus-laptop.c          |   15 +++--
 drivers/misc/eeepc-laptop.c         |    2 
 drivers/misc/fujitsu-laptop.c       |    8 +--
 drivers/misc/intel_menlow.c         |   29 +++++-----
 drivers/net/ixgb/ixgb_main.c        |    8 +--
 drivers/pci/hotplug/acpiphp_glue.c  |   14 ++---
 drivers/pci/hotplug/acpiphp_ibm.c   |    4 -
 drivers/pci/hotplug/sgi_hotplug.c   |    4 -
 drivers/serial/jsm/jsm_tty.c        |    6 ++
 drivers/usb/host/isp1760-if.c       |   96 ++++++++++++++++++++----------------
 drivers/video/aty/mach64_ct.c       |   11 ++++
 fs/cifs/connect.c                   |   18 +++---
 fs/dlm/plock.c                      |    2 
 fs/nfsd/nfs4state.c                 |   31 +++++++----
 include/acpi/acpi_bus.h             |    2 
 include/acpi/actypes.h              |    2 
 include/linux/if_vlan.h             |    7 ++
 include/linux/pci_ids.h             |    1 
 net/8021q/vlan_core.c               |   46 ++++++++++++-----
 net/core/dev.c                      |    3 +
 66 files changed, 480 insertions(+), 258 deletions(-)

Adrian Bunk (1):
      m68knommu: set NO_DMA

Alexey Starikovskiy (2):
      ACPI EC: Fix regression due to use of uninitialized variable
      Newly inserted battery might differ from one just removed, so update of battery info fields is required.

Andi Kleen (1):
      x86: use early clobbers in usercopy*.c

Bob Moore (1):
      ACPICA: Fix wrong resource descriptor length for 64-bit build

Brandeburg, Jesse (1):
      ixgb: fix bug when freeing resources

Corentin Chary (1):
      asus-laptop: Fix the led behavior with value > 1

Fiodor Suietov (1):
      ACPICA: Add check for invalid handle in acpi_get_object_info

Greg Kroah-Hartman (1):
      Linux 2.6.27.15

J. Bruce Fields (1):
      nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT

Jeff Layton (3):
      cifs: make sure we allocate enough storage for socket address
      nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a stateowner is found
      dlm: initialize file_lock struct in GETLK before copying conflicting lock

Karl Bongers (1):
      USB: isp1760: Fix probe in PCI glue code

Lin Ming (2):
      ACPICA: Fixed a couple memory leaks associated with "implicit return"
      ACPICA: Allow multiple backslash prefix in namepaths

Mark Lord (2):
      sata_mv: fix 8-port timeouts on 508x/6081 chips
      sata_mv: Fix chip type for Hightpoint RocketRaid 1740/1742

Matthew Garrett (1):
      Input: atkbd - broaden the Dell DMI signatures

Matthew Wilcox (1):
      ACPI: Change acpi_evaluate_integer to support 64-bit on 32-bit kernels

Mikulas Patocka (1):
      Fix memory corruption in console selection

Patrick McHardy (1):
      net: fix packet socket delivery in rx irq handler

Paul Larson (1):
      Add enable_ms to jsm driver

Rafael J. Wysocki (2):
      ACPI: Do not modify SCI_EN directly
      ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering

Risto Suominen (1):
      fbdev/atyfb: Fix DSP config on some PowerMacs & PowerBooks

Seth Heasley (1):
      PCI: irq and pci_ids patch for Intel Tigerpoint DeviceIDs

Stuart Hopkins (1):
      Input: atkbd - Samsung NC10 key repeat fix

Suresh Siddha (1):
      x86: fix page attribute corruption with cpa()

Tejun Heo (3):
      sata_nv: rename nv_nf2_hardreset()
      sata_nv: fix MCP5x reset
      sata_nv: ck804 has borked hardreset too

Thomas Renninger (1):
      ACPI: Fix compiler warnings introduced by 32 to 64 bit acpi conversions

Torsten Krah (1):
      asus-laptop: Add support for P30/P35

Venkatesh Pallipadi (4):
      cpuidle: update the last_state acpi cpuidle reflecting actual state entered
      cpuidle: upon BIOS bug, default to default_idle rather than polling
      cpuidle: use last_state which can reflect the actual state entered
      cpuidle: Add decaying history logic to menu idle predictor

Zhang Rui (2):
      video: always update the brightness when poking "brightness"
      don't load asus-acpi if model is not supported

Zhao Yakui (2):
      ACPI: Avoid array address overflow when _CST MWAIT hint bits are set
      ACPI: Attach the ACPI device to the ACPI handle as early as possible

