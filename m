Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYGPVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYGPVqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYGPVqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:46:01 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:52258 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbYGPVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:45:59 -0400
Date: Wed, 16 Jul 2008 23:45:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Please pull ACPI updates
Message-ID: <20080716214516.GA10777@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 16 Jul 2008 21:45:15.0389 (UTC) FILETIME=[3B7382D0:01C8E78D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-merge-2.6 release-2.6.27

to get the initial ACPI updates for 2.6.27. We got a few more changes
dependent on yet unpulled trees and some other candidate patches,
but that's the bulk for the changes intended for 2.6.27. Most of that
has been collected by Len Brown before he went on sabbatical. I was
relatively conservative with additional changes so far.

-Andi

Aaron Durbin (1):
      Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.

Adrian Bunk (1):
      eeepc-laptop: static

Alan Cox (1):
      snapshot: Push BKL down into ioctl handlers

Alok N Kataria (1):
      ACPI: fix checkpatch.pl complaints in scan.c

Bjorn Helgaas (29):
      PNP: add detail to debug resource dump
      PNP: remove pnp_resource.index
      PNP: add pnp_resource_type() internal interface
      PNP: add pnp_resource_type_name() helper function
      PNP: make pnp_{port,mem,etc}_start(), et al work for invalid resources
      PNP: replace pnp_resource_table with dynamically allocated resources
      PNPACPI: keep disabled resources when parsing current config
      PNP: remove ratelimit on add resource failures
      PNP: dont sort by type in /sys/.../resources
      PNP: add pnp_possible_config() -- can a device could be configured this way?
      PNP: whitespace/coding style fixes
      PNP: define PNP-specific IORESOURCE_IO_* flags alongside IRQ, DMA, MEM
      PNP: make resource option structures private to PNP subsystem
      PNP: introduce pnp_irq_mask_t typedef
      PNP: increase I/O port & memory option address sizes
      PNP: improve resource assignment debug
      PNP: in debug resource dump, make empty list obvious
      PNP: make resource assignment functions return 0 (success) or -EBUSY (failure)
      PNP: remove redundant pnp_can_configure() check
      PNP: centralize resource option allocations
      PNPACPI: ignore _PRS interrupt numbers larger than PNP_IRQ_NR
      PNP: rename pnp_register_*_resource() local variables
      PNP: support optional IRQ resources
      PNP: remove extra 0x100 bit from option priority
      ISAPNP: handle independent options following dependent ones
      PNP: convert resource options to single linked list
      PNP: avoid legacy IDE IRQs
      PNPACPI: add support for HP vendor-specific CCSR descriptors
      ACPI: use dev_printk when possible

Bob Moore (17):
      Make GPE disable more robust
      ACPICA: Add argument count checking to control method invocation via acpi_evaluate_object
      ACPICA: Fix for hang on GPE method invocation
      ACPICA: Fix possible negative array index in acpi_ut_validate_exception
      ACPICA: Eliminate acpi_native_uint type v2
      ACPICA: Removed unused include files from source files
      ACPICA: Several lint changes, no functional changes
      ACPICA: Add const qualifier for appropriate string constants
      ACPICA: Update version to 20080514
      ACPICA: Workaround for reversed _PRT entries from BIOS
      ACPICA: Update DMAR and SRAT table definitions
      ACPICA: Update disassembler for DMAR table changes
      ACPICA: Fix for invalid large array index on 64-bit systems
      ACPICA: Cleanup debug operand dump mechanism
      ACPICA: Cleanup of _PRT parsing code
      ACPICA: Fix mutex debug code for wrong loop termination value
      ACPICA: Update version to 20080609

Carlos Corbacho (7):
      acer-wmi: Remove LED colour comment from documentation
      acer-wmi: Blacklist backlight on Acer Aspire 1520 & 1360 series
      acer-wmi: Respect framebuffer blanking in backlight
      acer-wmi: Add EC quirk for Fujitsu Siemens Amilo Li 1718
      acer-wmi: Disable device autodetection on Fujitsu Siemens Amilo Li2732
      acer-wmi: Add debugfs file for device detection
      acer-wmi: Remove version number

Cezary Jackiewicz (2):
      misc,acpi,backlight: compal Laptop Extras
      compal-laptop: remove unnecessary lcd_level attribute

David Brownell (1):
      ACPI PM: acpi_pm_device_sleep_state() cleanup

Jan Beulich (2):
      ACPICA: Update tracking macros to reduce code/data size
      Fix FADT parsing

Johannes Berg (1):
      APM emulation: Notify about all suspend events, not just APM invoked ones (v2)

Jonathan Woithe (1):
      Fujitsu-laptop update

Julia Jomantaite (1):
      ACPI: video: fix brightness allocation

Len Brown (3):
      dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.
      ACPI: Zhang Rui maintains ACPI THERMAL and FAN
      ACPI: Andi Kleen maintains the ACPI sub-system

Mike Travis (1):
      ACPI: change processors from array to per_cpu variable

Rafael J. Wysocki (4):
      PCI ACPI: Drop the second argument of platform_pci_choose_state
      ACPI PM: Remove obsolete Toshiba workaround
      Freezer: Introduce PF_FREEZER_NOSIG
      snapshot: Use pm_mutex for mutual exclusion

Randy Dunlap (2):
      acpi: fix printk format warning
      fujitsu-laptop: depends on INPUT

Vegard Nossum (2):
      ACPICA: fix mutex names in debug code.
      ACPI: don't walk tables if ACPI was disabled

Yi Yang (2):
      ACPI: fix acpi fan state set error
      ACPI: fix processor throttling set error

Zhang Rui (4):
      fix a deadlock issue when poking "eject" file
      force offline the processor during hot-removal
      create sysfs link from acpi device to sysdev for cpu
      ACPI: Enhance /sys/firmware/interrupts to allow enable/disable/clear from user-space

Zhao Yakui (4):
      ACPI: Disable the C2C3_FFH access mode HW has no MWAIT support
      ACPI: Create "idle=halt" bootparam
      ACPI : Create "idle=nomwait" bootparam
      ACPI: Disable MWAIT via DMI on broken Compal board

 Documentation/ABI/testing/sysfs-firmware-acpi |  127 +++--
 Documentation/kernel-parameters.txt           |    5 +-
 Documentation/laptops/acer-wmi.txt            |    2 -
 MAINTAINERS                                   |   25 +-
 arch/ia64/kernel/process.c                    |    4 +
 arch/x86/kernel/acpi/processor.c              |    6 +
 arch/x86/kernel/process.c                     |   28 +-
 arch/x86/mm/srat_32.c                         |    3 +-
 drivers/acpi/Makefile                         |    2 +-
 drivers/acpi/bay.c                            |    3 +
 drivers/acpi/bus.c                            |    2 +-
 drivers/acpi/dispatcher/dsinit.c              |    2 +-
 drivers/acpi/dispatcher/dsmethod.c            |    1 -
 drivers/acpi/dispatcher/dsopcode.c            |   22 +-
 drivers/acpi/dispatcher/dswexec.c             |    8 -
 drivers/acpi/dispatcher/dswstate.c            |   20 +-
 drivers/acpi/dock.c                           |    3 +
 drivers/acpi/events/evevent.c                 |    6 +-
 drivers/acpi/events/evgpe.c                   |   36 +-
 drivers/acpi/events/evgpeblk.c                |   18 +-
 drivers/acpi/events/evmisc.c                  |    4 +-
 drivers/acpi/events/evregion.c                |    5 +-
 drivers/acpi/events/evrgnini.c                |    2 +-
 drivers/acpi/events/evxfevnt.c                |   18 +-
 drivers/acpi/executer/exconfig.c              |   17 +-
 drivers/acpi/executer/exconvrt.c              |   12 +-
 drivers/acpi/executer/excreate.c              |    2 -
 drivers/acpi/executer/exdump.c                |   67 +--
 drivers/acpi/executer/exfldio.c               |    9 +-
 drivers/acpi/executer/exmisc.c                |    8 +-
 drivers/acpi/executer/exprep.c                |    8 +-
 drivers/acpi/executer/exregion.c              |    2 +-
 drivers/acpi/executer/exresop.c               |    4 +
 drivers/acpi/executer/exstore.c               |    6 -
 drivers/acpi/fan.c                            |    8 +-
 drivers/acpi/glue.c                           |    3 +
 drivers/acpi/hardware/hwgpe.c                 |   52 ++-
 drivers/acpi/namespace/nsdump.c               |    6 +-
 drivers/acpi/namespace/nseval.c               |   35 +
 drivers/acpi/namespace/nsinit.c               |    1 -
 drivers/acpi/namespace/nsload.c               |    3 +-
 drivers/acpi/namespace/nsparse.c              |   15 +-
 drivers/acpi/namespace/nsutils.c              |   50 +-
 drivers/acpi/namespace/nsxfeval.c             |    3 +-
 drivers/acpi/numa.c                           |    4 +-
 drivers/acpi/parser/psargs.c                  |    4 +-
 drivers/acpi/parser/psxface.c                 |    4 +-
 drivers/acpi/pci_irq.c                        |   38 +-
 drivers/acpi/processor_core.c                 |   75 ++-
 drivers/acpi/processor_idle.c                 |   34 +-
 drivers/acpi/processor_perflib.c              |   18 +-
 drivers/acpi/processor_throttling.c           |   38 +-
 drivers/acpi/reboot.c                         |   50 ++
 drivers/acpi/resources/rscalc.c               |    4 +-
 drivers/acpi/resources/rscreate.c             |   41 +-
 drivers/acpi/resources/rsmisc.c               |    2 +-
 drivers/acpi/resources/rsutils.c              |   13 +-
 drivers/acpi/scan.c                           |   62 ++-
 drivers/acpi/sleep/main.c                     |   39 +-
 drivers/acpi/system.c                         |  169 +++++-
 drivers/acpi/tables/tbfadt.c                  |   23 +-
 drivers/acpi/tables/tbfind.c                  |    5 +-
 drivers/acpi/tables/tbinstal.c                |   30 +-
 drivers/acpi/tables/tbutils.c                 |   15 +-
 drivers/acpi/tables/tbxface.c                 |   28 +-
 drivers/acpi/tables/tbxfroot.c                |    4 +-
 drivers/acpi/utilities/utalloc.c              |    5 +-
 drivers/acpi/utilities/utcopy.c               |    4 +-
 drivers/acpi/utilities/utdebug.c              |   54 +-
 drivers/acpi/utilities/utdelete.c             |    2 +-
 drivers/acpi/utilities/uteval.c               |    5 +-
 drivers/acpi/utilities/utmisc.c               |   39 +-
 drivers/acpi/utilities/utmutex.c              |    4 +-
 drivers/acpi/utilities/utobject.c             |    9 +-
 drivers/acpi/video.c                          |  123 +++--
 drivers/char/apm-emulation.c                  |  346 +++++++-----
 drivers/misc/Kconfig                          |   31 +-
 drivers/misc/Makefile                         |    5 +-
 drivers/misc/acer-wmi.c                       |  145 ++++-
 drivers/misc/compal-laptop.c                  |  404 ++++++++++++
 drivers/misc/eeepc-laptop.c                   |    4 +-
 drivers/misc/fujitsu-laptop.c                 |  825 +++++++++++++++++++++++--
 drivers/pci/pci-acpi.c                        |    6 +-
 drivers/pci/pci.c                             |    4 +-
 drivers/pci/pci.h                             |    3 +-
 drivers/pnp/base.h                            |  148 ++++-
 drivers/pnp/core.c                            |   29 +-
 drivers/pnp/interface.c                       |  207 +++----
 drivers/pnp/isapnp/core.c                     |  253 +++-----
 drivers/pnp/manager.c                         |  414 ++++---------
 drivers/pnp/pnpacpi/core.c                    |    4 +-
 drivers/pnp/pnpacpi/rsparser.c                |  492 +++++++++------
 drivers/pnp/pnpbios/rsparser.c                |  274 +++++----
 drivers/pnp/quirks.c                          |  307 +++++-----
 drivers/pnp/resource.c                        |  454 ++++++--------
 drivers/pnp/support.c                         |  171 +++++-
 drivers/pnp/system.c                          |    4 +-
 drivers/serial/8250_pnp.c                     |   24 +-
 include/acpi/acconfig.h                       |    2 +-
 include/acpi/acdisasm.h                       |    1 +
 include/acpi/acdispat.h                       |    2 +-
 include/acpi/acexcep.h                        |   10 +-
 include/acpi/acglobal.h                       |    2 +-
 include/acpi/achware.h                        |    4 +-
 include/acpi/acinterp.h                       |    5 +-
 include/acpi/aclocal.h                        |    6 +-
 include/acpi/acmacros.h                       |   38 +-
 include/acpi/acnamesp.h                       |   30 +-
 include/acpi/acpi_bus.h                       |    4 +-
 include/acpi/acpiosxf.h                       |    2 +-
 include/acpi/acpixf.h                         |   12 +-
 include/acpi/acstruct.h                       |   10 +-
 include/acpi/actables.h                       |   27 +-
 include/acpi/actbl1.h                         |   23 +-
 include/acpi/actypes.h                        |   16 +-
 include/acpi/acutils.h                        |   70 ++-
 include/acpi/processor.h                      |    2 +-
 include/acpi/reboot.h                         |   14 +-
 include/asm-ia64/processor.h                  |    2 +
 include/asm-x86/processor.h                   |    2 +
 include/linux/freezer.h                       |   10 +
 include/linux/ioport.h                        |    5 +
 include/linux/pnp.h                           |  146 +++--
 include/linux/sched.h                         |    1 +
 kernel/cpu.c                                  |    1 +
 kernel/kthread.c                              |    2 +-
 kernel/power/process.c                        |   97 ++--
 kernel/power/user.c                           |   71 ++-
 128 files changed, 4330 insertions(+), 2449 deletions(-)
 create mode 100644 drivers/acpi/reboot.c
 create mode 100644 drivers/misc/compal-laptop.c
