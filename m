Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZISGmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZISGmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 02:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZISGmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 02:42:42 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:64175 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZISGmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 02:42:37 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_+DAczm4CDZcjZVLnYew2kA)"
Date: Sat, 19 Sep 2009 02:42:21 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver patches for Linux-2.6.32-rc0
Message-id: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_+DAczm4CDZcjZVLnYew2kA)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Two new drivers, bring the ACPICA core up to date with ACPI 4.0,
and a bunch of other stuff...

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-release-20090903-2.6.31.diff.gz

 Documentation/ABI/stable/sysfs-class-backlight     |   36 +
 Documentation/ABI/testing/sysfs-class-lcd          |   23 +
 Documentation/ABI/testing/sysfs-class-led          |   28 +
 .../ABI/testing/sysfs-platform-asus-laptop         |   52 +
 .../ABI/testing/sysfs-platform-eeepc-laptop        |   50 +
 Documentation/hwmon/acpi_power_meter               |   51 +
 Documentation/laptops/asus-laptop.txt              |  258 +++++
 Documentation/laptops/thinkpad-acpi.txt            |    8 +-
 Documentation/leds-class.txt                       |    9 +-
 MAINTAINERS                                        |    5 +
 arch/ia64/hp/common/sba_iommu.c                    |    7 +-
 arch/x86/include/asm/acpi.h                        |    1 -
 arch/x86/pci/mmconfig-shared.c                     |    2 +
 drivers/acpi/Kconfig                               |   17 +-
 drivers/acpi/Makefile                              |    1 +
 drivers/acpi/ac.c                                  |    2 +
 drivers/acpi/acpi_memhotplug.c                     |   51 +-
 drivers/acpi/acpica/Makefile                       |    4 +-
 drivers/acpi/acpica/acconfig.h                     |   10 +-
 drivers/acpi/acpica/acdebug.h                      |    4 -
 drivers/acpi/acpica/acglobal.h                     |   37 +-
 drivers/acpi/acpica/achware.h                      |    8 +
 drivers/acpi/acpica/acinterp.h                     |    4 +-
 drivers/acpi/acpica/aclocal.h                      |   16 +
 drivers/acpi/acpica/acmacros.h                     |    2 +
 drivers/acpi/acpica/acnamesp.h                     |   25 +
 drivers/acpi/acpica/acobject.h                     |    1 +
 drivers/acpi/acpica/acparser.h                     |    2 +
 drivers/acpi/acpica/acpredef.h                     |  584 +++++++-----
 drivers/acpi/acpica/acutils.h                      |   30 +-
 drivers/acpi/acpica/amlcode.h                      |    1 +
 drivers/acpi/acpica/dsfield.c                      |   18 +-
 drivers/acpi/acpica/dsmethod.c                     |   15 +-
 drivers/acpi/acpica/dsmthdat.c                     |    8 +-
 drivers/acpi/acpica/dsobject.c                     |   23 +-
 drivers/acpi/acpica/dswload.c                      |   41 +-
 drivers/acpi/acpica/evgpe.c                        |    8 +-
 drivers/acpi/acpica/evgpeblk.c                     |    4 +-
 drivers/acpi/acpica/evrgnini.c                     |   45 +-
 drivers/acpi/acpica/exconfig.c                     |    7 +
 drivers/acpi/acpica/exdump.c                       |    6 +-
 drivers/acpi/acpica/exfield.c                      |   82 ++-
 drivers/acpi/acpica/exfldio.c                      |    7 +-
 drivers/acpi/acpica/exutils.c                      |   53 +-
 drivers/acpi/acpica/hwgpe.c                        |   34 +-
 drivers/acpi/acpica/hwregs.c                       |  206 ++++-
 drivers/acpi/acpica/hwtimer.c                      |    2 +-
 drivers/acpi/acpica/hwxface.c                      |  195 +++--
 drivers/acpi/acpica/nsalloc.c                      |   88 ++-
 drivers/acpi/acpica/nsdumpdv.c                     |    7 +-
 drivers/acpi/acpica/nseval.c                       |  137 +++
 drivers/acpi/acpica/nsinit.c                       |   15 +
 drivers/acpi/acpica/nsload.c                       |    3 +-
 drivers/acpi/acpica/nspredef.c                     |  718 +++++++-------
 drivers/acpi/acpica/nsrepair.c                     |  203 ++++
 drivers/acpi/acpica/nsutils.c                      |    5 +-
 drivers/acpi/acpica/nsxfeval.c                     |   23 +-
 drivers/acpi/acpica/nsxfname.c                     |  237 ++++--
 drivers/acpi/acpica/psloop.c                       |  119 +++-
 drivers/acpi/acpica/psxface.c                      |    4 +
 drivers/acpi/acpica/tbutils.c                      |   82 ++-
 drivers/acpi/acpica/utdelete.c                     |    6 +
 drivers/acpi/acpica/uteval.c                       |  378 +-------
 drivers/acpi/acpica/utglobal.c                     |   12 +-
 drivers/acpi/acpica/utids.c                        |  382 ++++++++
 drivers/acpi/acpica/utinit.c                       |   22 +-
 drivers/acpi/acpica/utmisc.c                       |   85 ++-
 drivers/acpi/acpica/utxface.c                      |   26 +-
 drivers/acpi/battery.c                             |   22 +
 drivers/acpi/blacklist.c                           |    2 +
 drivers/acpi/bus.c                                 |    3 +-
 drivers/acpi/button.c                              |    2 +
 drivers/acpi/cm_sbs.c                              |    2 +
 drivers/acpi/container.c                           |   13 +-
 drivers/acpi/debug.c                               |   82 +-
 drivers/acpi/dock.c                                |   10 +-
 drivers/acpi/ec.c                                  |  270 ++----
 drivers/acpi/event.c                               |    2 +
 drivers/acpi/fan.c                                 |    2 +
 drivers/acpi/glue.c                                |   10 +-
 drivers/acpi/internal.h                            |   22 +-
 drivers/acpi/numa.c                                |    2 +
 drivers/acpi/osl.c                                 |  126 ++-
 drivers/acpi/pci_irq.c                             |    2 +
 drivers/acpi/pci_link.c                            |    2 +
 drivers/acpi/pci_root.c                            |    2 +
 drivers/acpi/pci_slot.c                            |    5 +-
 drivers/acpi/power.c                               |    3 +-
 drivers/acpi/power_meter.c                         | 1018 ++++++++++++++++++++
 drivers/acpi/processor_core.c                      |  246 +++---
 drivers/acpi/processor_idle.c                      |   12 +-
 drivers/acpi/processor_perflib.c                   |    2 +
 drivers/acpi/processor_thermal.c                   |    5 +-
 drivers/acpi/processor_throttling.c                |    5 +-
 drivers/acpi/sbs.c                                 |    2 +
 drivers/acpi/sbshc.c                               |    2 +
 drivers/acpi/scan.c                                |  183 +++--
 drivers/acpi/sleep.c                               |    8 +
 drivers/acpi/system.c                              |    2 +
 drivers/acpi/tables.c                              |    6 +
 drivers/acpi/thermal.c                             |    2 +
 drivers/acpi/utils.c                               |    2 +
 drivers/acpi/video.c                               |   80 +-
 drivers/acpi/video_detect.c                        |    2 +
 drivers/char/agp/hp-agp.c                          |    9 +-
 drivers/ide/ide-acpi.c                             |    5 +-
 drivers/pci/dmar.c                                 |    4 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |   12 +-
 drivers/platform/x86/Kconfig                       |   10 +
 drivers/platform/x86/Makefile                      |    1 +
 drivers/platform/x86/acerhdf.c                     |  121 ++-
 drivers/platform/x86/asus-laptop.c                 |  227 ++++-
 drivers/platform/x86/eeepc-laptop.c                |  340 ++++---
 drivers/platform/x86/fujitsu-laptop.c              |  109 +--
 drivers/platform/x86/hp-wmi.c                      |    2 +-
 drivers/platform/x86/sony-laptop.c                 |    7 +-
 drivers/platform/x86/thinkpad_acpi.c               |  382 ++++++--
 drivers/platform/x86/topstar-laptop.c              |  265 +++++
 drivers/platform/x86/wmi.c                         |    1 -
 drivers/pnp/pnpacpi/core.c                         |    6 +-
 drivers/thermal/Kconfig                            |    1 +
 include/acpi/acpi_bus.h                            |   16 +-
 include/acpi/acpiosxf.h                            |    3 +
 include/acpi/acpixf.h                              |   10 +-
 include/acpi/actbl.h                               |   78 +-
 include/acpi/actbl1.h                              |  872 +++++-------------
 include/acpi/actbl2.h                              |  868 +++++++++++++++++
 include/acpi/actypes.h                             |   92 +-
 include/acpi/platform/aclinux.h                    |    4 +-
 include/linux/acpi.h                               |   15 +-
 130 files changed, 7234 insertions(+), 3022 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-backlight
 create mode 100644 Documentation/ABI/testing/sysfs-class-lcd
 create mode 100644 Documentation/ABI/testing/sysfs-class-led
 create mode 100644 Documentation/ABI/testing/sysfs-platform-asus-laptop
 create mode 100644 Documentation/ABI/testing/sysfs-platform-eeepc-laptop
 create mode 100644 Documentation/hwmon/acpi_power_meter
 create mode 100644 Documentation/laptops/asus-laptop.txt
 create mode 100644 drivers/acpi/acpica/nsrepair.c
 create mode 100644 drivers/acpi/acpica/utids.c
 create mode 100644 drivers/acpi/power_meter.c
 create mode 100644 drivers/platform/x86/topstar-laptop.c
 create mode 100644 include/acpi/actbl2.h

through these commits:

Alan Jenkins (11):
      eeepc-laptop: don't touch the pci slot if it was claimed by a different driver
      eeepc-laptop: use a mutex to serialize pci hotplug (resume vs. notify)
      eeepc-laptop: fix pci hotplug race on load and unload
      eeepc-laptop: fix ordering of init and exit functions
      eeepc-laptop: make input device a child of the platform device
      eeepc-laptop: remove redundant rfkill_set_sw_state in resume handler
      eeepc-laptop: check the 3G rfkill state on resume
      eeepc-laptop: correct the description of the hibernation abort bug
      eeepc-laptop: switch to dev_pm_ops
      eeepc-laptop: fix rfkill memory leak on unload
      eeepc-laptop: allow rfkill hotplug to work on the 900A model

Alex Chiang (1):
      ACPI: pci_slot.ko wants a 64-bit _SUN

Alexey Dobriyan (1):
      acpi: switch /proc/acpi/{debug_layer,debug_level} to seq_file

Alexey Starikovskiy (4):
      ACPICA: Don't switch task then not allowed
      ACPI: EC: Merge IRQ and POLL modes
      ACPI: EC: use BURST mode only for MSI notebooks
      ACPI: EC: Drop orphan comment

Bartlomiej Zolnierkiewicz (2):
      fujitsu-laptop: remove superfluous NULL pointer checks
      fujitsu-laptop: driver [un]registration fixes

Bjorn Helgaas (12):
      ACPI: processor: remove KOBJ_ONLINE/KOBJ_OFFLINE events
      ACPI: processor: clean up in acpi_processor_start() error exits
      ACPI: processor: move acpi_processor_start() after acpi_processor_add()
      ACPI: processor: remove .start() method
      ACPI: memory hotplug: remove .start() method
      ACPI: EC: move acpi_ec_start() after acpi_ec_add()
      ACPI: EC: remove .start() method
      ACPI: EC: remove .stop() method
      ACPI: remove unused acpi_device_ops .stop method
      ACPI: simplify deferred execution path
      ACPI: remove null pointer checks in deferred execution path
      ACPI: don't pass handle for fixed hardware notifications

Bob Moore (29):
      ACPICA: Fix several pointer casts to avoid possible compile warnings
      ACPICA: Remove duplicate extern declarations for public globals
      ACPICA: Add 64-bit support to acpi_read and acpi_write
      ACPICA: Remove duplicate prototypes from header
      ACPICA: Major update for acpi_get_object_info external interface
      ACPICA: Fix possible memory leak in nspredef
      ACPICA: Fix several acpi_attach_data problems
      ACPICA: Dump table header - suppress output of non-printable characters
      ACPICA: Fix: Predefined object repair executed only once
      ACPICA: Clarify common suffix for error/warning messages
      ACPICA: ACPI 4.0: Changes for existing ACPI tables.
      ACPICA: Update version to 20090625
      ACPICA: Move predefined repair code to new file, no functional change
      ACPICA: Add repair for predefined methods that return nested packages
      ACPICA: ACPI 4.0 : Add new return package type, restructure module.
      ACPICA: Fix fault if acpi_terminate is called twice
      ACPICA: Split large ACPI table header
      ACPICA: ACPI 4: Update headers for new and changed ACPI tables.
      ACPICA: ACPI 4: Add validation for new predefined names.
      ACPICA: Update definitions for HEST table
      ACPICA: Fix typo for HEST ACPI table
      ACPICA: acpi_reset: Bypass port validation mechanism
      ACPICA: Update version to 20090730
      ACPICA: Fix extraneous warning if _DSM returns a package
      ACPICA: Remove error message for Store(Localx,Localx)
      ACPICA: Fix memory leak for ill-formed Package objects
      ACPICA: Update _OSI with new Windows OS strings
      ACPICA: Windows compatibility: autoexecute root _INI method
      ACPICA: Update version to 20090903.

Borislav Petkov (1):
      acerhdf: convert to dev_pm_ops

Corentin Chary (18):
      eeepc-laptop: add rfkill support for the Wimax in ASUS Eee PC 1000HG
      eeepc-laptop: document sysfs interface
      video/backlight: document sysfs interface
      video/lcd: document sysfs interface
      led: document sysfs interface
      asus-laptop: Show HRWS in infos and fix output format
      asus-laptop: Add *_led_get() functions
      asus-laptop: Map X50R hotkeys
      asus-laptop: set maximum led brightness
      asus-laptop: Add support for Keyboard backlight
      asus-laptop: handle keyboard backlight keys
      asus-laptop: Add suport for another "Media" key
      asus-laptop: Add "calculator" hotkey
      asus-laptop: document the module
      asus-laptop: document sysfs interface
      asus-laptop: Fix coding style for comments
      thinkpad_acpi: fix rfkill memory leak on unload
      hp-wmi: fix rfkill memory leak on unload

Darrick J. Wong (1):
      hwmon driver for ACPI 4.0 power meters

Dmitry Torokhov (2):
      ACPI: video - fix potential crash when unloading
      ACPI: video - rename cdev to cooling_dev -- syntax only

Feng Tang (1):
      ACPI: Handle CONFIG_ACPI=n better from linux/acpi.h

Hector Martin (1):
      ACPI battery: work around negative s16 battery current on Acer

Henrique de Moraes Holschuh (8):
      thinkpad-acpi: don't ask about brightness_mode for fw. 1V and 1R
      thinkpad-acpi: firmware version checks
      thinkpad-acpi: be more strict when detecting a ThinkPad
      thinkpad-acpi: hotkey poll fixes
      thinkpad-acpi: deprecate hotkey_bios_mask
      thinkpad-acpi: Fix procfs hotkey reset command
      thinkpad-acpi: don't poll by default any of the reserved hotkeys
      thinkpad-acpi: report brightness events when required

Herton Ronaldo Krzesinski (1):
      topstar-laptop: add new driver for hotkeys support on Topstar N01

Hugh Dickins (1):
      ACPI: fix NULL bug for HID/UID string

Jan Beulich (1):
      thermal: add missing Kconfig dependency

Jonathan Woithe (2):
      fujitsu-laptop: fix config corner case
      fujitsu-laptop: increment driver version

Julia Lawall (1):
      fujitsu-laptop: Correct redundant test

Len Brown (9):
      ACPI: fix CONFIG_ACPI_PROCFS=n build warning
      eeepc-laptop: whitespace for checkpatch.pl
      ACPI: Move definition of PREFIX from acpi_bus.h to internal..h
      ACPI, PCI: Change PREFIX to "PCI" from "ACPI" in mmconfig-shared.c
      ACPI: check acpi_disabled in acpi_table_parse() and acpi_table_parse_entries()
      ACPI: sleep: another HP DMI entry for init_set_sci_en_on_resume
      Revert "ACPI: Attach the ACPI device to the ACPI handle as early as possible"
      ACPI: linux/acpi.h should not include linux/dmi.h
      ACPI: remove unnecessary #ifdef CONFIG_DMI

Lin Ming (5):
      ACPICA: ACPI 4.0: iASL/Disassembler - IPMI keyword support.
      ACPICA: ACPI 4.0: Interpreter support for IPMI.
      ACPICA: fix leak of acpi_os_validate_address
      ACPICA: reformat predefined method table, no functional change
      ACPICA: Add support for module-level executable AML code

Peter Feuerer (2):
      acerhdf: fix fan control for AOA150 model
      acerhdf: additional BIOS versions

Stephen Gildea (1):
      fujitsu-laptop: support led-class as module

Vladimir Serbinenko (1):
      ACPI video: ignore buggy _BQC

Zhang Rui (2):
      ACPI: video: remove unneeded memsets
      ACPI video: work-around BIOS AML bug in _BQC

Zhao Yakui (1):
      ACPI: Make ACPI processor proc I/F depend on the ACPI_PROCFS

with this log:

commit 193a6dec1c0246a80b6d0101e4f351ccf877bcac
Merge: 53de535 90c53ca
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:31:39 2009 -0400

    Merge branch 'video' into release
    
    Conflicts:
    	drivers/acpi/video.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53de5356be3ac62c22ae1da266943059b169d9b1
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Aug 31 22:32:20 2009 +0000

    ACPI: don't pass handle for fixed hardware notifications
    
    Fixed hardware devices have no handles, so just pass an explicit
    NULL rather than something that looks like it might be meaningful.
    acpi_device_notify() doesn't need the handle anyway; the only
    reason it takes it as an argument is because the acpi_notify_handler
    typedef requires it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 59fc9e5e21baf2bf5c87d8006e006007c3a708c2
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Aug 31 22:32:15 2009 +0000

    ACPI: remove null pointer checks in deferred execution path
    
    Better to oops and learn about a bug than to silently cover it up.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ac6185669d0d277c4082fa92ba8eb2e55534cbf
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Aug 31 22:32:10 2009 +0000

    ACPI: simplify deferred execution path
    
    We had two functions, acpi_os_execute_deferred() and
    acpi_os_execute_hp_deferred() that differed only in that the
    latter did acpi_os_wait_events_complete(NULL) before executing
    the deferred function.
    
    This patch consolidates those two functions and uses a flag in
    the struct acpi_os_dpc to determine whether to do the wait.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d26f0528d588e596955bf296a609afe52eafc099
Merge: b963bd3 df43176
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:14:45 2009 -0400

    Merge branch 'misc-2.6.32' into release
    
    Conflicts:
    	drivers/pci/dmar.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b963bd39c9000328f6ce4f12aa52abbb0c68ee91
Merge: cbeee13 5f0dadb
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:11:06 2009 -0400

    Merge branch 'thinkpad' into release

commit cbeee13570adfb0af494a07074958e4888c2351c
Merge: 7ef0143 b188e4c
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:10:40 2009 -0400

    Merge branch 'processor-procfs-2.6.32' into release

commit 7ef0143e2f898f9bf675c81bdf0e045c8dd53c57
Merge: 44396a2 138d156
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:10:27 2009 -0400

    Merge branch 'preempt' into release

commit 44396a262286d1a07216a7c7792d4ed7a4c89ea7
Merge: 89ae400 de584af
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:10:22 2009 -0400

    Merge branch 'power-meter' into release

commit 89ae400e3f57c9d60cd4da3501bb09c1502b723c
Merge: bf25400 84a6ce2
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:09:50 2009 -0400

    Merge branch 'fujitsu' into release

commit bf25400e889dac3f9a3d5a5b77e8ec4c170a5006
Merge: 762caf0 a5fe1a0
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:09:37 2009 -0400

    Merge branch 'bugzilla-13620' into release

commit 762caf0baafc657c410b9c04f4a95d4e3aa4dda1
Merge: 3b87bb6 f25752e
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 02:05:34 2009 -0400

    Merge branch 'ec' into release
    
    Conflicts:
    	drivers/acpi/ec.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b87bb640e77023c97cf209e3dd85887a1113ad0
Merge: 7a92d80 dcf52fb
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:56:39 2009 -0400

    Merge branch 'bjorn-start-stop-2.6.32' into release

commit 7a92d803227a523a9a5546e4e0dce1325a4b5926
Merge: b4549a2 bc76f90
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:56:17 2009 -0400

    Merge branch 'battery' into release

commit b4549a24b6194201077d0295207ec204f785fab1
Merge: 3bb29ec 52cc96b
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:55:27 2009 -0400

    Merge branch 'asus' into release

commit 3bb29ec14ce5f448ab37a5da16c3d720ae5af9cf
Merge: 985f387 f944915
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:54:35 2009 -0400

    Merge branch 'acer' into release

commit f944915187f53810130eb1c56985e27e3cbe4a6d
Author: Peter Feuerer <peter@piie.net>
Date:   Fri Sep 18 12:41:07 2009 -0700

    acerhdf: additional BIOS versions
    
    Added BIOS versions:
    Acer: AOA110-v0.3307, AOA150-v0.3301, AOA150-v0.3307
    Packard Bell: AOA150-v0.3105
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Cc: Andreas Mohr <andi@lisas.de>
    Cc: Borislav Petkov <petkovbb@googlemail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff27e1f3037535a547e2474eecb688428d654dc3
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Fri Sep 18 12:41:05 2009 -0700

    acerhdf: convert to dev_pm_ops
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Cc: Andreas Mohr <andi@lisas.de>
    Cc: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ded0cdfc6a7673916b0878c32fa8ba566b4f8cdb
Author: Peter Feuerer <peter@piie.net>
Date:   Thu Aug 6 15:57:52 2009 -0700

    acerhdf: fix fan control for AOA150 model
    
    - Apply Borislav Petkov's patch (convert the fancmd[] array to a real
      struct thus disambiguating command handling and making code more
      readable.)
    
    - Add BIOS product to BIOS table as AOA110 and AOA150 have different
      register values
    
    - Add force_product parameter to allow forcing different product
    
    - fix linker warning caused by "acerhdf_drv" not being named
      "acerhdf_driver"
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Cc: Andreas Mohr <andi@lisas.de>
    Acked-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 985f38781d19101aba121df423f92c87b208c6df
Merge: d093d70 c976623
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:45:22 2009 -0400

    Merge branch 'acpica' into release

commit df43176c934f2bc01f7615a6e20a4b8e77dcdd11
Author: Jan Beulich <JBeulich@novell.com>
Date:   Fri Sep 18 12:41:10 2009 -0700

    thermal: add missing Kconfig dependency
    
    Otherwise THERMAL_HWMON can be selected when HWMON=n and THERMAL=n, which
    fails to build.
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Cc: Zhang Rui <rui.zhang@intel.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d7decb213a65dea0973ed980c02dae2b1b88dbe
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Sep 18 12:41:08 2009 -0700

    acpi: switch /proc/acpi/{debug_layer,debug_level} to seq_file
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 09729f0b11a389e046f621f3e4841043f460b603
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Sep 14 12:43:51 2009 +0200

    hp-wmi: fix rfkill memory leak on unload
    
    rfkill_unregister() should always be followed by rfkill_destroy()
    In this case, rfkill_destroy was called two times on wifi_rfkill and
    never on bluetooth_rfkill.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4f55966d02c5dfade2978c2aa05fb202a78a4d1
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 6 23:42:10 2009 -0400

    ACPI: remove unnecessary #ifdef CONFIG_DMI
    
    acpi_osi_setup() does not depend on CONFIG_DMI
    acpi_dmi_osi_linux()'s definition doesn't depend on CONFIG_DMI either
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eb27cae8adaa658a0bf31631baa1ce29d8183759
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 6 23:40:19 2009 -0400

    ACPI: linux/acpi.h should not include linux/dmi.h
    
    users of acpi.h that need dmi.h should include it directly.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit de584afa5e188a2da484bb5373d449598cdb9f5e
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Fri Sep 18 12:41:09 2009 -0700

    hwmon driver for ACPI 4.0 power meters
    
    This driver exposes ACPI 4.0 compliant power meters as hardware monitoring
    devices.  This second revision of the driver also exports the ACPI string
    info as sysfs attributes, a list of the devices that the meter measures,
    and will send ACPI notifications over the ACPI netlink socket.  This
    latest revision only enables the power capping controls if it can be
    confirmed that the power cap can be enforced by the hardware and explains
    how the notification interfaces work.
    
    [akpm@linux-foundation.org: remove default-y]
    [akpm@linux-foundation.org: build fix]
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Cc: Zhang Rui <rui.zhang@intel.com>
    Cc: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d093d70a81b08673d1577ad73419998f02be9d29
Merge: 596fb7a 9caeb53
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:29:01 2009 -0400

    Merge branch 'topstar-laptop' into release

commit 9caeb5324427990db7bc97e674794d201c1f0797
Author: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date:   Mon Sep 14 21:11:21 2009 -0300

    topstar-laptop: add new driver for hotkeys support on Topstar N01
    
    This adds Topstar Laptop Extras ACPI driver. It enables hotkeys
    functionality with Topstar N01 netbook. Besides hotkeys there are
    other functions exposed by its ACPI firmware, but for now only
    hotkeys reporting on Topstar N01 is supported. Topstar is a chinese
    manufacturer, its website can be currently reached at
    http://www.topstardigital.cn/
    
    Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
    Reviewed-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f0dadb4bd259c3b832e19702f552947244edfb9
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Sep 14 12:43:52 2009 +0200

    thinkpad_acpi: fix rfkill memory leak on unload
    
    rfkill_unregister() should always be followed by rfkill_destroy()
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 596fb7ae462f5c82a1d663fe04f8c98464c963c9
Merge: 003d6a3 de4c8cc
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 01:06:16 2009 -0400

    Merge branch 'thinkpad' into release

commit de4c8cc7bddd9c43dc1b85517ab445ffa8163058
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:18 2009 -0300

    thinkpad-acpi: report brightness events when required
    
    Report KEY_BRIGHTNESSUP and KEY_BRIGHTNESSDOWN input events when the
    ThinkPad is in "passive brightness control" mode (because either we or
    ACPI video touched _BCL), and ACPI video is not processing these
    events by itself.
    
    This happens only on Lenovo ThinkPads with ACPI video support, when
    operating with the ACPI video driver in acpi_backlight=vendor mode.
    
    Issuing these events is the right thing to do, and will work around
    bugzilla #13368, if userspace is properly configured and actively
    handles these events.
    
    For other ThinkPads, and when ACPI video is handling brightness
    changes, thinkpad-acpi will continue NOT sending KEY_BRIGHTNESS*
    events by default.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 230d8cf25ac32c7d2fdb4dda861ec5d954000ffb
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:17 2009 -0300

    thinkpad-acpi: don't poll by default any of the reserved hotkeys
    
    Init hotkey_source_mask late, so that we can make use of
    hotkey_reserved_mask to avoid polling any of the reserved
    hotkeys by default.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 20c9aa46f644b3ddb161a819d1b0c2b07097c4ee
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:16 2009 -0300

    thinkpad-acpi: Fix procfs hotkey reset command
    
    echo "reset" > /proc/acpi/ibm/hotkey should do something non-useless,
    so instead of setting it to Fn+F2, Fn+F3, Fn+F5, set it to
    hotkey_recommended_mask.
    
    It is not like it will survive for much longer, anyway.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06777be6d8688ba93103fffbbe9e64a5e6fab3c8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:15 2009 -0300

    thinkpad-acpi: deprecate hotkey_bios_mask
    
    Some analysis of the ACPI DSDTs shows that the HKEY pre-enabled mask
    is always 0x80c (FN+F3,FN+F4 and FN+F12), which are the hotkeys that
    the second gen of HKEY firmware supported (the first gen didn't report
    any hotkeys, the second reported these tree hotkeys but had no mask
    support, and the third added mask support).
    
    So, this is probably some sort of backwards compatibility with older
    versions of the IBM ThinkVantage suite.  We have no use for that, and
    I know of exactly ZERO users of that attribute, anyway.  Start the
    process of getting rid of it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db25f16d1dcce8de12f2f5daf884cda02196b28c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:14 2009 -0300

    thinkpad-acpi: hotkey poll fixes
    
    Fix some locking, avoid exiting the kthread before kthread_stop() is
    called on it, and clean up the hotkey poll routines a little bit.
    
    Also, restore bits in the firmware mask after hotkey_source_mask is
    changed.  Without this, we leave events disabled...
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e675abafcc0df38125e6e94a9ba91c92fe774f52
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:13 2009 -0300

    thinkpad-acpi: be more strict when detecting a ThinkPad
    
    Use stricter checks to decide that we're running on a supported ThinkPad.
    This should remove some possible false positives, although nobody ever
    bothered to report any.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 600a99fa3b4ce4a54375fb089e5ce0f3a1c9a7e1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:12 2009 -0300

    thinkpad-acpi: firmware version checks
    
    Use the quirk infrastructure to warn of outdated firmware and also of
    firmware versions that are known to cause problems.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6da25bf51689a5cc60370d30275dbb9e6852e0cb
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 12 15:22:11 2009 -0300

    thinkpad-acpi: don't ask about brightness_mode for fw. 1V and 1R
    
    X40 (firmware 1V) and T41 (firmware 1R) have been confirmed to work
    well with the new defaults, so we can stop pestering people to confirm
    that fact.
    
    For now, whitelist just these two firmware types.  It is best to have
    at least one more firmware type confirmed for Radeon 9xxx and Intel
    GMA-2 ThinkPads before removing the confirmation requests entirely.
    
    Reported-by: Robert de Rooy <robert.de.rooy@gmail.com>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 003d6a38ce1a59e0053a02fd9e9a65b588bc8e33
Merge: 71fd68e e55a599
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 00:37:13 2009 -0400

    Merge branch 'sfi-base' into release
    
    Conflicts:
    	drivers/acpi/power.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 71fd68e7d234f6b7d8407c8f486764d24f8411f4
Merge: 8ff0e08 78f28b7
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 00:06:59 2009 -0400

    Merge branch 'linus' into release

commit c9766237afa92e8d7f27bbcd4964f1b43fa0bce8
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Sep 4 08:56:17 2009 +0800

    ACPICA: Update version to 20090903.
    
    Version 20090903.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e64155eb1b6ab78980db58cfd21385fa5f6b024
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Sep 3 10:21:03 2009 +0800

    ACPICA: Windows compatibility: autoexecute root _INI method
    
    Add support for execution of an _INI method at the namespace root.
    Although not defined in the ACPI specification, this support was
    added to Windows around the Vista timeframe. It is added here
    for Windows compatibility.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eb752552464dbb7a99f8a975ec3b9355893cedd4
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Sep 3 10:05:08 2009 +0800

    ACPICA: Update _OSI with new Windows OS strings
    
    Added strings for Windows server 2008, Windows Vista SP1,
    Windows 7, and Windows server 2008 R2.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e3fe0913b8e732ae636cf23afca76cf2c30718e5
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Sep 3 10:03:37 2009 +0800

    ACPICA: Fix memory leak for ill-formed Package objects
    
    Fixes a possible memory leak in the interpreter for package
    objects if the package initializer list is longer than the
    defined size of the package. This apparently can only happen
    if the BIOS changes the package size on the fly (seen in a _PSS
    object), as both iASL and the other compiler do not allow this.
    The interpreter will truncate the package to the defined size
    (and issue an error message), but can leave the extra objects
    undeleted if they have been pre-created during the argument
    processing (such is the case if the package consists of a number
    of sub-packages as in the _PSS.) ACPICA BZ 805.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=805
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e678902ee899f6b0ab48166b410cdc9f1c27a350
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Sep 3 09:58:14 2009 +0800

    ACPICA: Remove error message for Store(Localx,Localx)
    
    We silently ignore this construct for Windows compatibility
    ACPICA BZ 785.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=785
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 307a042416dfc2216251a85b79e8578b65fdc0e7
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Sep 3 09:55:40 2009 +0800

    ACPICA: Fix extraneous warning if _DSM returns a package
    
    _DSM can return any type of object, so validation on the return
    type cannot be performed. ACPICA BZ 802.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=802
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8ff0e082f0833d32c7523a6cd72b6cf6a2142ce8
Merge: 8aeb0a3 f61f925
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 5 13:38:34 2009 -0400

    Merge branch 'bugzilla-13002' into release

commit f61f925859c57f6175082aeeee17743c68558a6e
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 5 13:33:23 2009 -0400

    Revert "ACPI: Attach the ACPI device to the ACPI handle as early as possible"
    
    This reverts commit eab4b645769fa2f8703f5a3cb0cc4ac090d347af.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13002
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8aeb0a352af7eb26863e53c203eeb852fd4590c3
Merge: 7e24bc1 eb0ca84
Author: Len Brown <len.brown@intel.com>
Date:   Mon Aug 31 23:42:51 2009 -0400

    Merge branch 'bugzilla-13745' into release

commit 718fb0de8ff88f71b3b91a8ee8e42e60c88e5128
Author: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date:   Thu Aug 6 23:18:12 2009 +0000

    ACPI: fix NULL bug for HID/UID string
    
    acpi_device->pnp.hardware_id and unique_id are now allocated pointers,
    replacing the previous arrays.  acpi_device_install_notify_handler()
    oopsed on the NULL hid when probing the video device, and perhaps other
    uses are vulnerable too.  So initialize those pointers to empty strings
    when there is no hid or uid.  Also, free hardware_id and unique_id when
    when acpi_device is going to be freed.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14096
    
    Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7e24bc1ce669b2876ffa475ea1147f2bb9ffdc52
Author: Alex Chiang <achiang@hp.com>
Date:   Tue Aug 4 14:44:17 2009 -0600

    ACPI: pci_slot.ko wants a 64-bit _SUN
    
    Similar to commit b6adc195 (PCI hotplug: acpiphp wants a 64-bit
    _SUN), pci_slot.ko reads and creates sysfs directories based on
    the _SUN method.
    
    Certain HP platforms return 64 bits in _SUN. This change to
    pci_slot.ko allows us to see the correct sysfs directories.
    
    Reported-by: Chad Smith <chad.smith@hp.com>
    Cc: stable@kernel.org
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 90c53ca426cb93d15eefea79dcf6bd15ad3ffeb4
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Aug 31 12:39:54 2009 -0400

    ACPI video: work-around BIOS AML bug in _BQC
    
    _BQC on some laptops returns an uninitialized value when it's
    invoked for the first time.
    
    Set the laptop to the maximum backlight level in this case.
    http://bugzilla.kernel.org/attachment.cgi?id=22675
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4a703a8fe562824f269943d995ddff35077253a9
Author: Dmitry Torokhov <dtor@mail.ru>
Date:   Sat Aug 29 23:03:16 2009 -0400

    ACPI: video - rename cdev to cooling_dev -- syntax only
    
    Cdev name is normally used for ether class devices or character
    devices so rename member to avoid confusion for casual reader
    of the code.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b4fe3b62e8d88068083218d3e42c45223b51d29
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sat Aug 8 00:26:25 2009 -0700

    ACPI: video - fix potential crash when unloading
    
    thermal_cooling_device_register() returns error encoded in a pointer
    when it fails in which case we need to explictly set device->cdev
    to NULL so we don't try to unregister it when unloading.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eb0ca849863ecdc593ba7faa95fda5695af891c8
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 29 22:39:06 2009 -0400

    ACPI: sleep: another HP DMI entry for init_set_sci_en_on_resume
    
    DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv3 Notebook PC")
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13745
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f25752e67d9d9ee7562ae9944314dd8c057d3fa2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Aug 28 23:29:51 2009 +0400

    ACPI: EC: Drop orphan comment
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a63b06f3c494cc87eade97f081300bda60acec7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Aug 28 23:29:44 2009 +0400

    ACPI: EC: use BURST mode only for MSI notebooks
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2a84cb9852f52c0cd1c48bca41a8792d44ad06cc
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sun Aug 30 03:06:14 2009 +0400

    ACPI: EC: Merge IRQ and POLL modes
    
    In general, EC transaction should complete in less than 1ms, thus it is possible to merge wait for
    1ms in poll mode and 1ms of interrupt transaction timeout.
    Still, driver will wait 500ms for EC to complete transaction.
    
    This significantly simplifies driver and makes it immune to problematic EC interrupt
    implementations.
    
    It also may lessen kernel start-up time by 500ms.
    
    References: http://bugzilla.kernel.org/show_bug.cgi?id=12949
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc76f90b8a5cf4aceedf210d08d5e8292f820cec
Author: Hector Martin <hector@marcansoft.com>
Date:   Thu Aug 6 15:57:48 2009 -0700

    ACPI battery: work around negative s16 battery current on Acer
    
    Acer Aspire 8930G laptops (and possibly others) report the battery current
    as a 16-bit signed negative when it is charging.  It also reports it as
    0x10000 when the current is 0.  This patch adds a quirk for this which
    takes the absolute value of the reported current cast to an s16.  This is
    a DSDT bug present in the latest BIOS revision (the EC register is 16 bits
    signed and the DSDT attempts to take the 16-bit two's complement of this,
    which works for discharge but not charge.  It also breaks zero values
    because a 32-bit register is used and the high bits aren't thrown away).
    
    I've enabled this for all Acer systems which report in mA units.  This
    should be safe since it won't break compliant systems unless they report a
    current above 32A, which is insane.  The patch also detects the valid
    32-bit value -1, which indicates unknown status, and does not attempt the
    fix in that case (note that this does not conflict with 16-bit -1, which
    is 65535 as read normally and gets translated to 1mA).
    
    Signed-off-by: Hector Martin <hector@marcansoft.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e231fa4cbd3ff53fcb7d76eccd6fd86a152a95f
Author: Vladimir Serbinenko <phcoder@gmail.com>
Date:   Wed Jun 24 15:17:36 2009 +0800

    ACPI video: ignore buggy _BQC
    
    _BQC doesn't return a value listed in _BCL method.
    http://bugzilla.kernel.org/show_bug.cgi?id=13511
    
    ingore the buggy _BQC method in this case
    
    Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
    Signed-off-by: Scott Howard <showard314@gmail.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 138d15692bf76841f252d4b836a535cf5f9154e9
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Aug 28 23:29:38 2009 +0400

    ACPICA: Don't switch task then not allowed
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 52cc96bd5b61775db2792780c610979fc02313eb
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Sat Aug 29 10:28:31 2009 +0200

    eeepc-laptop: allow rfkill hotplug to work on the 900A model
    
    The 900A provides hotplug notifications on a different ACPI object to
    other models.
    
    Reported-by: Trevor <trevor.chart@gmail.com>
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a8258069793609903b5ebf0bca3320249154c379
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Sat Aug 29 10:28:30 2009 +0200

    eeepc-laptop: fix rfkill memory leak on unload
    
    rfkill_unregister() should always be followed by rfkill_destroy()
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit be96666065fd36ccfa09a13903d31d7ff5f4ef91
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sat Aug 29 10:28:29 2009 +0200

    asus-laptop: Fix coding style for comments
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e55a5999ffcf72dc4d43d73618957964cb87065a
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 28 17:41:53 2009 +0800

    ACPI: Handle CONFIG_ACPI=n better from linux/acpi.h
    
    linux/acpi.h is the top level header for interfacing
    with the ACPI sub-system, so acpi_disabled should be
    up there instead of down in asm/acpi.h -- particularly
    since asm/acpi.h doesn't exist for all architectures.
    
    Same story for acpi_table_parse(), which is a top-level
    API to Linux/ACPI.
    
    This is necessary for building some code that
    used to always depend on CONFIG_ACPI=y, but will soon
    also need to build with CONFIG_ACPI=n.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 7 23:22:58 2009 -0400

    ACPI: check acpi_disabled in acpi_table_parse() and acpi_table_parse_entries()
    
    Allow consumers of the acpi_table_parse()/acpi_table_parse_entries() API
    to gracefully handle the acpi_disabled=1 case via return value
    rather than checking the global flag themselves.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f4a2d5840e9f0e48d1a787b66e7346087a756029
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 28 16:48:02 2009 -0400

    ACPI, PCI: Change PREFIX to "PCI" from "ACPI" in mmconfig-shared.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

commit a192a9580bcc41692be1f36b77c3b681827f566a
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 28 16:45:54 2009 -0400

    ACPI: Move definition of PREFIX from acpi_bus.h to internal..h
    
    Linux/ACPI core files using internal.h all PREFIX "ACPI: ",
    however, not all ACPI drivers use/want it -- and they
    should not have to #undef PREFIX to define their own.
    
    Add GPL commment to internal.h while we are there.
    
    This does not change any actual console output,
    asside from a whitespace fix.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49ae80c9944401222e47108883c486b5a5a24006
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Aug 13 13:43:12 2009 +0800

    ACPICA: Update version to 20090730
    
    Version 20090730.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a964236800839263b3dddd7f7851d666e7d53e1
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Aug 13 13:42:19 2009 +0800

    ACPICA: acpi_reset: Bypass port validation mechanism
    
    Allow writes to reserved ports. This change may eventually be
    driven down in to acpi_write and acpi_read.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1872bbc94b2d092ece22a8fbf1c3e81f0fba0052
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Aug 13 13:31:00 2009 +0800

    ACPICA: Fix typo for HEST ACPI table
    
    Problem with the name of one of the subtables.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c276e3884163355464a76e60ed9e272b52b4acc2
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jul 27 14:55:02 2009 +0800

    ACPICA: Update definitions for HEST table
    
    Eliminate duplicated code in disassembler.
    Shorten identifiers that were too long.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f0c826a437157d2b19662977e9cf3b472cf24a6
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Aug 13 14:03:15 2009 +0800

    ACPICA: Add support for module-level executable AML code
    
    Add limited support for executable AML code that exists outside
    of any control method. This type of code has been illegal since
    ACPI 2.0.  The code must exist in an If/Else/While block. All AML
    tables are supported, including tables that are dynamically loaded.
    ACPICA BZ 762.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=762
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 999e08f99846a1fd6ee9642ec306a2d318925116
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Aug 13 14:30:16 2009 +0800

    ACPICA: ACPI 4: Add validation for new predefined names.
    
    Added 31 new names for ACPI 4.0.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Jul 27 11:31:10 2009 +0800

    ACPICA: reformat predefined method table, no functional change
    
    Reformatted the methods that return package objects.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6e2d5ebd0d36199920676fdceaff4f4bfe66297b
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jul 27 10:53:00 2009 +0800

    ACPICA: ACPI 4: Update headers for new and changed ACPI tables.
    
    Add IVRS,MSCT,UEFI,WAET,WDAT.
    Updated several existing tables for ACPI 4.0-related changes.
    Added document references for all tables not defined in ACPI spec.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b24aad44438d5bc21cbbfb94a99d9bf710d8295b
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 24 13:30:17 2009 +0800

    ACPICA: Split large ACPI table header
    
    Split out the non-acpi-defined ACPI tables into the existing
    (but empty) actbl2.h file. Preparation for new ACPI 4.0 tables.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f977b36e5f175e5126f280e7a94f0c53d1b1a16
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 24 11:25:16 2009 +0800

    ACPICA: Fix fault if acpi_terminate is called twice
    
    Fixes a problem with the mechanism that prevents problems if the
    acpi_terminate interface is inadvertently called more than once
    before the ACPICA code is re-initialized. ACPICA BZ 795.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=795
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53e9387bdd8bfef6cffff2d2eb6bd28eca812682
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 24 11:22:11 2009 +0800

    ACPICA: ACPI 4.0 : Add new return package type, restructure module.
    
    Added one new package type, a package that contains a revision number and
    a variable number of sub-packages. Restructured the module to
    put the sub-package list traversal in a separate function.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5f69d6ef7a6b0dbad8d4c00d83009960be02155
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 24 11:03:09 2009 +0800

    ACPICA: Add repair for predefined methods that return nested packages
    
    Fixes a problem where a predefined method is defined to return
    a variable-length Package of sub-packages. If the length is one,
    the BIOS code occasionally creates a simple single package with
    no sub-packages. This code attempts to fix the problem by wrapping
    a new package object around the existing package. ACPICA BZ 790.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=790
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2deadd53c3630786e73746fb0ad8450f4e015bf
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 24 10:56:43 2009 +0800

    ACPICA: Move predefined repair code to new file, no functional change
    
    New file is nsrepair.c. This is in preparation for additional
    errror correcting code.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aeb41b852fe90764b75ef7a9f185ca94696af6ff
Author: Len Brown <len.brown@intel.com>
Date:   Fri Aug 28 19:03:11 2009 -0400

    eeepc-laptop: whitespace for checkpatch.pl
    
    checkpatch doesn't like tab+space for a return statement.
    
    WARNING: suspect code indent for conditional statements (8, 17)
    +	if (!device)
    +		 return -EINVAL;
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b09f5fecf8b97c9de7add3e2eb0cfeb91ef28dbb
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:55 2009 +0000

    asus-laptop: document sysfs interface
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ce2c9d9a531e8753005a25a686dafab9a5d04bb
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:54 2009 +0000

    asus-laptop: document the module
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0aa20f7d720ed1feeb74df8c63a6427d9a2d3ebd
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:53 2009 +0000

    asus-laptop: Add "calculator" hotkey
    
    Found on UX50V.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4644d0e5bd1412bbaed77e46c0c3376c6d060a74
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:52 2009 +0000

    asus-laptop: Add suport for another "Media" key
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dc79526078d2c0f01445e54e1d9fdf7c15ffd63d
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:51 2009 +0000

    asus-laptop: handle keyboard backlight keys
    
    Add support for the Fn+F3/Fn+F4 keys and map them
    as KEY_KBDILLUMUP and KEY_KBDILLUMDOWN.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7d3fbc2ed624cc216adda0f2574570e6d6d6aed
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:50 2009 +0000

    asus-laptop: Add support for Keyboard backlight
    
    Add support for keyboard backlight found in Asus U50VG.
    
    The SMC driver for the Apples does it via LED. To be
    consistent with that we create /sys/class/leds/asus::kbd_backlight/
    to control the keyboard backlight.
    
    SLKB and GLKB are used to get/set the backlight. On
    the U50VG is supports 4 brightness level, but this may
    change with other models.
    
    SLKB take a 8 bit integer where the higher bit is used
    to toggle the backlight, and the over 7 bits control the
    brightness level.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 977c328d81e31fde70c5ba381d9cf7357451dd74
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:49 2009 +0000

    asus-laptop: set maximum led brightness
    
    Set the right maximum brightness which is one, because
    they can only be on or off.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f641375b65f64e83be8be68ae1ebce21ee4fd578
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:48 2009 +0000

    asus-laptop: Map X50R hotkeys
    
    Map some new hotkeys found on X50R.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit abfa57e15acaa6e1ec567c250e5212bc55d79e43
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:47 2009 +0000

    asus-laptop: Add *_led_get() functions
    
    Add support for getting led brightness directly from
    the hardware. Currently we don't need it, but it is needed
    to support keyboard backlight/led.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d4a3800c764d111d67462a14589ed1611b2f55e
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:46 2009 +0000

    asus-laptop: Show HRWS in infos and fix output format
    
    Show HRWS in /sys/platform/devices/asus-laptop/infos.
    HRWS is a bitfield used to get information about Hardware
    available in the laptop.
    Also change sprintf format from 0x%04x to %#x.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f634c6527249275df4199a294ee9cec2f3ff3b1
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:45 2009 +0000

    led: document sysfs interface
    
    Also fix Documentation/led-class.txt, the acceptable
    range of values for brightness is 0-max_brightness, not 0-255.
    
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 243ca3e401bc62e704785d215931f1a51fd53bd7
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:44 2009 +0000

    video/lcd: document sysfs interface
    
    Date and KernelVersion may be wrong because the lcd
    interface was introduced before git initial import.
    
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3c4c1b69a2d76ac9a1c716233fde956dba757d76
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:43 2009 +0000

    video/backlight: document sysfs interface
    
    Date and KernelVersion may be wrong because the backlight
    interface was introduced before git initial import.
    
    Cc:Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0a6825c9217cfc52d39b2b2bedd73bef8019f79
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:42 2009 +0000

    eeepc-laptop: document sysfs interface
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d1ec9c3d434d94e3674bcf433e8e8e7462b8e1c0
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Aug 28 12:56:41 2009 +0000

    eeepc-laptop: add rfkill support for the Wimax in ASUS Eee PC 1000HG
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c200da5d2900df9c24fb8041870d92a4175bbef3
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:40 2009 +0000

    eeepc-laptop: switch to dev_pm_ops
    
    This also involves switching the resume handler from the acpi device
    to the platform device.  Using the more fine grained handlers allows
    two improvements:
    
    1. We only need to recheck rfkill state after resume from hibernation.
    
    2. The wireless LED workaround accounts for up to 1.1s out of 1.7s
    resuming devices (when wireless is enabled).  We can limit the
    workaround to thaw(), so that it only delays suspend to disk.
    
    The workaround is only likely to help when hibernation is aborted.
    Suspend to ram cannot be aborted by the user.  Device suspend errors may
    well happen before eeepc-laptop would even be frozen.  Suspend errors
    which happen after that could be pretty funky anyway.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1edd99f1c2b0285ce810d217180bf37bbae550e
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:39 2009 +0000

    eeepc-laptop: correct the description of the hibernation abort bug
    
    Actually it is only the LED which is affected.  The bios bug does not
    disable the wifi.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a47461011a0f5110c497b9b163d1125d258418b2
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:38 2009 +0000

    eeepc-laptop: check the 3G rfkill state on resume
    
    All the rfkill devices are treated as "persistent", 3G is no exception.
    This means their state may change over hibernation.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ffb03575284e0f72d7ea001178c793afa265b8b5
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:37 2009 +0000

    eeepc-laptop: remove redundant rfkill_set_sw_state in resume handler
    
    rfkill_set_sw_state() will already be called by eeepc_rfkill_hotplug().
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f2a9d5e8a649c606f520b7a7b9f4f46fba79c327
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:36 2009 +0000

    eeepc-laptop: make input device a child of the platform device
    
    Sysfs showed the ehotk input device as a "virtual" device - lies!
    The input device is provided by a physical device, the eeepc platform.
    
    This requires that we move the creation of the input device to come
    after platform device is created.  Input initialization is moved from
    ehotk_check() [sic] to a new function called eeepc_input_init().  This
    brings the input device into line with the other eeepc-laptop devices.
    
    Also, refuse to load if we fail to register the input device.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1e7798547fe6920ae27fb92c9202353e9e4c55db
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:35 2009 +0000

    eeepc-laptop: fix ordering of init and exit functions
    
    1. input and backlight devices were registered after acpi notifications
       are enabled.  This left a window where eeepc_hotk_notify() might
       find these devices in an inconsistent (half-initialized) state.
    
    -> Move all device registration into eeepc_hotk_add(), which is called
       before enabling acpi notifications.
    
    2. input and backlight devices were unregistered before acpi
       notifications are disabled.  This left a window where
       eeepc_hotk_notify() might find these devices in an inconsistent
       (half-destroyed) state.
    
    -> Move all device unregistration into eeepc_hotk_remove(), which is
       called after disabling acpi notifications.
    
    3. The acpi driver was not freed if an error occured further down in
       eeepc_laptop_init().
    
    -> The rest of eeepc_laptop_init() has been moved to eeepc_hotk_add(),
       so this is no longer a problem.
    
    4. The acpi driver was unregistered before the platform driver.  This
       left a window where a sysfs access could attempt to read the ehotk
       structure after it had been freed by eeepc_hotk_remove().
    
    -> The acpi driver is now unregistered as the last step in
       eeepc_laptop_exit(), so this is no longer a problem.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 07e84aa98f6b3a7278d3267f6f657955ed3eb973
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:34 2009 +0000

    eeepc-laptop: fix pci hotplug race on load and unload
    
    Wifi rfkill state changes can race with pci hotplug cleanup.  A simple
    fix is to refresh the hotplug state just before deregistering the pci
    hotplug slot.
    
    There is also potential for a hotplug notification to fire too early
    during setup, while the structures it uses are still being initialised.
    (This could only happen if the BIOS performs hotplug itself; a bug
    triggered by removing the battery while hibernated).  Avoid this by
    registering the notifier later.  The same refresh mechanism is used
    to handle rfkill state changes which can now race with registration.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dcf443b5813074031a45b05ad9c57da98bcae329
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:33 2009 +0000

    eeepc-laptop: use a mutex to serialize pci hotplug (resume vs. notify)
    
    Commit d0265f0 "eeepc-laptop: fix hot-unplug on resume" used a workqueue
    to protect pci hotplug against multiple simultaneous calls during
    resume.  It seems to work, but a mutex would be more appropriate.
    
    This is in preparation to fix the potential pci hotplug race on unload.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d41839e762f8b8b03dbb97fd0d41b244d0bc902
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Fri Aug 28 12:56:32 2009 +0000

    eeepc-laptop: don't touch the pci slot if it was claimed by a different driver
    
    The whole point of registering as a PCI hotplug driver was to prevent
    conflict with pciehp.  At the moment it happens to work because
    eeepc-laptop is loaded first, but it doesn't work the other way round.
    If pciehp is loaded first then we fail to claim the slot - we need to
    respect this and not handle hotplug events.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 84a6ce267296dabdf427ea4aff73dc58164863bb
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Fri Jul 31 18:16:59 2009 +0930

    fujitsu-laptop: increment driver version
    
    Increment driver version to reflect the changes from this patch series.
    
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 72afeeafe54853881a4e53dc78d538e249130ad8
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Jul 31 18:16:02 2009 +0930

    fujitsu-laptop: driver [un]registration fixes
    
    * Move led_classdev_unregister() calls from fujitsu_cleanup() to
      acpi_fujitsu_hotkey_remove().
    
    * Fix ordering in fujitsu_cleanup().
    
    * Fix backlight_device_register() failure handling in fujitsu_init().
    
    * Add missing sysfs group removal on failure to fujitsu_init().
    
    * Add input device unregistering on failure to acpi_fujitsu_add()
      and acpi_fujitsu_hotkey_add().
    
    * Add input device unregistering/freeing to acpi_fujitsu_remove()
      and acpi_fujitsu_hotkey_remove() (also remove superfluous 'device'
      and 'acpi_driver_data(device)' checks while at it).
    
    * Do few minor cleanups.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 67059406219d30a36b7ca93f863eb1f3032f05ce
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Jul 31 08:43:56 2009 +0000

    fujitsu-laptop: remove superfluous NULL pointer checks
    
    This takes care of the following entries from Dan's list:
    
    drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning:
    variable derefenced before check 'fujitsu'
    drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning:
    variable derefenced before check 'fujitsu'
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Cc: corbet@lwn.net
    Cc: eteo@redhat.com
    Cc: Julia Lawall <julia@diku.dk>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14485c57270e8f3de2a25abaf93bae5712c97e9e
Author: Julia Lawall <julia@diku.dk>
Date:   Fri Jul 31 18:12:00 2009 +0930

    fujitsu-laptop: Correct redundant test
    
    device and acpi_driver_data(device) were tested just a few lines above.
    
    A simplified version of the semantic match that finds this problem is as
    follows: (http://www.emn.fr/x-info/coccinelle/)
    
    // <smpl>
    @r exists@
    local idexpression x;
    expression E;
    @@
    
    if (x == NULL || ...) { ... when forall
       return ...; }
    .. when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
    (
    *x == NULL
    |
    *x != NULL
    )
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1e384cb0f9a940f2a431d1708f963987e61d71e3
Author: Stephen Gildea <stepheng+linux@gildea.com>
Date:   Tue Aug 25 14:41:52 2009 +0930

    fujitsu-laptop: support led-class as module
    
    Support fujitsu-laptop with led-class built as a module instead of
    being compiled in.
    
    Signed-off-by: Stephen Gildea <stepheng+linux@gildea.com>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1b5310a957c47d1c66bb53035c6ba6aa20a150f
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Thu Aug 27 18:45:33 2009 -0400

    fujitsu-laptop: fix config corner case
    
    This patch is a trivial fix for a config corner case, ensuring that
    fujitsu-laptop doesn't get compiled into the kernel when the led class
    is a module.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b5e634103a5471d74e55d774e53db3df5c7b650
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Aug 6 15:57:54 2009 -0700

    ACPI: video: remove unneeded memsets
    
    device->cap and video->cap are zeroed initially so we don't need to clear
    them again.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a5fe1a03f7720b8da8364a1737e1e5a357904e99
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Aug 13 10:43:27 2009 +0800

    ACPICA: fix leak of acpi_os_validate_address
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13620
    
    If the dynamic region is created and added to resource list over and over again,
    it has the potential to be a memory leak by growing the list every time.
    
    This patch fixes the memory leak, as below
    
    1) add a new field "count" to struct acpi_res_list.
    
       When inserting, if the region(addr, len) is already in the resource
       list, we just increase "count", otherwise, the region is inserted
       with count=1.
    
       When deleting, the "count" is decreased, if it's decreased to 0,
       the region is deleted from the resource list.
    
       With "count", the region with same address and length can only be
       inserted to the resource list once, so prevent potential memory leak.
    
    2) add a new function acpi_os_invalidate_address, which is called when
       region is deleted.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3ce804ed83827a7fd27190836f9421b29ac64512
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Jun 25 10:31:32 2009 -0700

    ACPICA: Update version to 20090625
    
    Update version number.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eb2289ba1ba994de25af0d94b5e80ba93d2c1c3c
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 13:42:00 2009 +0800

    ACPICA: ACPI 4.0: Changes for existing ACPI tables.
    
    FACS: new flag and new OspmFlags field.
    SRAT: x2APIC - add ClockDomain field to descriptor #2
    
    Includes header and disassembler support.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8d590c7af1152685efcf302905baeb6dda3c2d2f
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 13:39:29 2009 +0800

    ACPICA: Clarify common suffix for error/warning messages
    
    Added parens around the acpica version/modulename/linenumber to
    clearly differentiate this group from the rest of the message.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0444e8f6d72d6e38f92d48884bc90bbc6c22fd5a
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 13:38:02 2009 +0800

    ACPICA: Fix: Predefined object repair executed only once
    
    This fixes a problem where the code that attempts to repair/convert
    an object of incorrect type is only executed on the first time the
    predefined method is called. The mechanism that disables warnings
    on subsequent calls was interfering with the repair mechanism.
    ACPICA BZ 781.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=781
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cf02cd47d4747abf8ff0617e15fc05a00202e6d5
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 11:38:46 2009 +0800

    ACPICA: Dump table header - suppress output of non-printable characters
    
    Function acpi_tb_print_table_header. Some ACPI tables contain
    non-printable characters in one of the string fields of the the
    header - Signature, OemId, OemTableId, or CompilerId. Invalid
    characters are replaced by '?'. ACPICA BZ 788.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=788
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e4319c425077c4cc540696a5bb6c4d12f017dcd
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jun 29 13:43:27 2009 +0800

    ACPICA: Fix several acpi_attach_data problems
    
    Handler was never invoked. Now invoked if/when host node is deleted.
    Data object was not automatically deleted when host node was deleted.
    Interface to handler had an unused parameter, removed it.
    ACPICA BZ 778.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=778
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6557a49a443a347d24aed58076365432ded30edc
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Jun 24 11:32:04 2009 +0800

    ACPICA: ACPI 4.0: Interpreter support for IPMI.
    
    Adds support for IPMI which is similar to SMBus and uses a bi-directional data buffer.
    ACPICA BZ 773.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=773
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3db20bed579bc4e7fe581c48ad1bde853aa9ff68
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Jun 24 11:25:17 2009 +0800

    ACPICA: ACPI 4.0: iASL/Disassembler - IPMI keyword support.
    
    Adds support for the new IPMI operation region keyword.
    ACPICA BZ 771, 772.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=771
    http://acpica.org/bugzilla/show_bug.cgi?id=772
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dbdc8f02fe8339686623c84745ba15b0f4f889a1
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 11:22:22 2009 +0800

    ACPICA: Fix possible memory leak in nspredef
    
    Fixed a possible leak when an attempt is made to repair a return
    object.  The only current repair is an automatic buffer to string
    conversion.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 15b8dd53f5ffaf8e2d9095c423f713423f576c0f
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jun 29 13:39:29 2009 +0800

    ACPICA: Major update for acpi_get_object_info external interface
    
    Completed a major update for the acpi_get_object_info external interface.
    Changes include:
     - Support for variable, unlimited length HID, UID, and CID strings
     - Support Processor objects the same as Devices (HID,UID,CID,ADR,STA, etc.)
     - Call the _SxW power methods on behalf of a device object
     - Determine if a device is a PCI root bridge
     - Change the ACPI_BUFFER parameter to ACPI_DEVICE_INFO.
    These changes will require an update to all callers of this interface.
    See the ACPICA Programmer Reference for details.
    
    Also, update all invocations of acpi_get_object_info interface
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9c61b34cf7078da72cce276ff8cfae5d6e9955bc
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 09:45:17 2009 +0800

    ACPICA: Remove duplicate prototypes from header
    
    Two duplicates in acdebug.h.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c6b5774caafa4c12b6019366e2fdaaff117e95a4
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jun 24 09:44:06 2009 +0800

    ACPICA: Add 64-bit support to acpi_read and acpi_write
    
    Needed by drivers for new ACPi tables.  Internal versions of
    these functions still use 32-bit max transfers, in order to
    minimize disruption and stack use for the standard ACPI registers
    (FADT-based).
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f8d80cdf40fe4d2393159012b38ce9f85a488686
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 2 13:28:13 2009 +0800

    ACPICA: Remove duplicate extern declarations for public globals
    
    Some were defined twice, causes a warning with gcc
    -Wredundant-decls.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5853a9f6dda244b4163b9daad663bdc41a74f596
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 2 13:20:00 2009 +0800

    ACPICA: Fix several pointer casts to avoid possible compile warnings
    
    Fixes warnings with gcc -Wcast-qual flag.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dcf52fb71d988ba945054308f661bddf9b2455fb
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:45 2009 +0000

    ACPI: remove unused acpi_device_ops .stop method
    
    No drivers use the .stop method, so remove it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cf745ec7a1222a661b2c5f0e8c2c4be81300d2a4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:40 2009 +0000

    ACPI: EC: remove .stop() method
    
    This patch folds the .stop() method into .remove().
    
    acpi_ec_stop() is only called via acpi_device_probe() and
    acpi_device_remove(), and in both cases it is called immediately before
    acpi_ec_remove(), so there's no need to have it be a separate method.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    CC: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d02be04707b8ff5375a76c027327e8708877da39
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:35 2009 +0000

    ACPI: EC: remove .start() method
    
    This patch folds the .start() method into .add().
    
    acpi_ec_start() is always called immediately after acpi_ec_add(),
    so there's no need to have it be a separate method.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    CC: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5efc5476184173996dfcce780c2bb5e727df674e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:30 2009 +0000

    ACPI: EC: move acpi_ec_start() after acpi_ec_add()
    
    This patch rearranges ec_install_handlers() and acpi_ec_start() so
    acpi_ec_start() ends up just after acpi_ec_add().  A subsequent patch
    will merge them.
    
    Code movement only; no functional change.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 80f20fef6a2381402e59b169eb51b989cc175ab7
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:25 2009 +0000

    ACPI: memory hotplug: remove .start() method
    
    This patch folds the .start() method into .add().
    
    The .start() method is called in two paths: boot-time device enumeration
    and run-time node addition, currently via container_device_add().  In both
    cases, .start() is called immediately after .add(), so there's no reason
    to make them separate methods.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    CC: Yasunori Goto <y-goto@jp.fujitsu.com>
    CC: Dave Hansen <haveblue@us.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 970b04929a68134acca17878b1d93e115e58c12a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:19 2009 +0000

    ACPI: processor: remove .start() method
    
    This patch folds the .start() method into .add().
    
    acpi_processor_start() is always called immediately after
    acpi_processor_add(), so there's really no point in having them be
    separate methods.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    CC: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ddcd62d89e8c919cc75aeffd2ca37c986141b0f0
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:14 2009 +0000

    ACPI: processor: move acpi_processor_start() after acpi_processor_add()
    
    Move acpi_processor_start() to just after acpi_processor_add().
    A subsequent patch will merge them.
    
    Code movement only; no functional change.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    CC: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d4e0526184199e23ac1460fe59b8a3741b17a8b5
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:09 2009 +0000

    ACPI: processor: clean up in acpi_processor_start() error exits
    
    We used to leave crud around if things failed in acpi_processor_start().
    This patch cleans up as much as we can before returning.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    CC: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1815e074079838d36d89e45e92b7ee317190700
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 22 20:41:04 2009 +0000

    ACPI: processor: remove KOBJ_ONLINE/KOBJ_OFFLINE events
    
    This patch removes the KOBJ_ONLINE/KOBJ_OFFLINE events the driver used
    to generate for CPU hotplug.  As far as I know, nobody consumes these.
    The driver core still generates KOBJ_ADD and KOBJ_REMOVE, of course.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    CC: Zhao Yakui <yakui.zhao@intel.com>
    CC: Matthew Garrett <mjg@redhat.com>
    CC: Thomas Renninger <trenn@suse.de>
    CC: Dave Jones <davej@codemonkey.org.uk>
    CC: Kay Sievers <kay.sievers@vrfy.org>
    CC: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b188e4ce3b7965ecc8d45191042cc9d25f6b90ee
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jun 24 01:48:32 2009 -0400

    ACPI: fix CONFIG_ACPI_PROCFS=n build warning
    
    drivers/acpi/processor_idle.c:1162: warning: unused variable ¡entry¢
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74cad4ee9839669ad920257678ea0bf0a818cd3b
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Jun 24 11:49:49 2009 +0800

    ACPI: Make ACPI processor proc I/F depend on the ACPI_PROCFS
    
    Now whether the ACPI processor proc I/F is registered depends on the
    CONFIG_PROC. It had better depend on the CONFIG_ACPI_PROCFS.
    When the CONFIG_ACPI_PROCFS is unset in kernel configuration, the
    ACPI processor proc I/F won't be registered.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_+DAczm4CDZcjZVLnYew2kA)--
