Return-Path: <linux-kernel-owner+w=401wt.eu-S1763163AbZLPUGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163AbZLPUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762478AbZLPUGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:06:47 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:38666 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZLPUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:06:44 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_xBs6XCwF1U1f336CgmxiBw)"
Date: Wed, 16 Dec 2009 15:06:40 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI and driver patches for 2.6.33.merge
Message-id: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_xBs6XCwF1U1f336CgmxiBw)
Content-type: TEXT/PLAIN; charset=ISO-8859-15
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

I admit that I didn't have a bunch of this stuff up in linux-next,
for I pushed a batch quite recently and linux-next was
using last week's tree due to merge conflicts.

Anyway, this completes the ACPICA changes we
started for this release.

The bulk of the platform driver updates should be in here,
though I do expect some smaller updates still.

I also expect some ACPI bug fixes which are now percolating.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.32/acpi-release-20091214-2.6.32.diff.gz

 Documentation/acpi/method-customizing.txt  |   66 ++
 Documentation/feature-removal-schedule.txt |   19 +
 Documentation/laptops/thinkpad-acpi.txt    |  114 ++-
 Documentation/thermal/sysfs-api.txt        |    1 +
 arch/x86/kernel/acpi/cstate.c              |    2 +-
 drivers/acpi/acpi_pad.c                    |    3 +-
 drivers/acpi/acpica/acnamesp.h             |    9 +-
 drivers/acpi/acpica/acobject.h             |    6 +-
 drivers/acpi/acpica/dsmethod.c             |    2 +-
 drivers/acpi/acpica/dswload.c              |   64 +-
 drivers/acpi/acpica/evregion.c             |    4 +-
 drivers/acpi/acpica/evrgnini.c             |   15 +
 drivers/acpi/acpica/evxface.c              |    4 +-
 drivers/acpi/acpica/evxfevnt.c             |    4 +-
 drivers/acpi/acpica/evxfregn.c             |    4 +-
 drivers/acpi/acpica/exmutex.c              |   18 +-
 drivers/acpi/acpica/nsaccess.c             |    2 +-
 drivers/acpi/acpica/nsdump.c               |    2 +-
 drivers/acpi/acpica/nseval.c               |   18 +
 drivers/acpi/acpica/nsnames.c              |    2 +-
 drivers/acpi/acpica/nspredef.c             |   93 +--
 drivers/acpi/acpica/nsrepair.c             |  447 ++++++++--
 drivers/acpi/acpica/nsrepair2.c            |  195 +++-
 drivers/acpi/acpica/nsutils.c              |   57 +-
 drivers/acpi/acpica/nsxfeval.c             |   10 +-
 drivers/acpi/acpica/nsxfname.c             |   10 +-
 drivers/acpi/acpica/nsxfobj.c              |   14 +-
 drivers/acpi/acpica/psxface.c              |    3 +-
 drivers/acpi/acpica/rsxface.c              |    2 +-
 drivers/acpi/acpica/utcopy.c               |   27 +-
 drivers/acpi/battery.c                     |    2 +-
 drivers/acpi/bus.c                         |  148 +++
 drivers/acpi/button.c                      |    7 +
 drivers/acpi/debug.c                       |   84 ++-
 drivers/acpi/dock.c                        |  261 ++----
 drivers/acpi/fan.c                         |    2 +-
 drivers/acpi/numa.c                        |   21 +-
 drivers/acpi/osl.c                         |    2 +-
 drivers/acpi/pci_root.c                    |   76 +--
 drivers/acpi/processor_core.c              |   10 +-
 drivers/acpi/processor_idle.c              |   11 +-
 drivers/acpi/processor_perflib.c           |   50 +-
 drivers/acpi/thermal.c                     |    7 +
 drivers/char/ipmi/ipmi_si_intf.c           |  118 +++-
 drivers/misc/Kconfig                       |   13 -
 drivers/platform/x86/Kconfig               |   29 +
 drivers/platform/x86/Makefile              |    2 +
 drivers/platform/x86/acerhdf.c             |   63 +-
 drivers/platform/x86/asus-laptop.c         |   25 +-
 drivers/platform/x86/asus_acpi.c           |   19 +-
 drivers/platform/x86/dell-laptop.c         |   86 ++-
 drivers/platform/x86/dell-wmi.c            |  129 +++-
 drivers/platform/x86/eeepc-laptop.c        | 1415 +++++++++++++++------------
 drivers/platform/x86/hp-wmi.c              |  139 ++--
 drivers/platform/x86/msi-wmi.c             |  293 ++++++
 drivers/platform/x86/thinkpad_acpi.c       | 1178 ++++++++++++++++++------
 drivers/platform/x86/toshiba_bluetooth.c   |  144 +++
 drivers/platform/x86/wmi.c                 |  175 ++++-
 drivers/pnp/pnpacpi/core.c                 |   20 +-
 drivers/pnp/pnpacpi/rsparser.c             |    9 +-
 drivers/thermal/thermal_sys.c              |   19 +-
 include/acpi/acoutput.h                    |    8 +-
 include/acpi/acpixf.h                      |    2 +-
 include/acpi/processor.h                   |    5 +-
 include/linux/acpi.h                       |   23 +-
 include/linux/pnp.h                        |   13 +
 66 files changed, 4113 insertions(+), 1712 deletions(-)
 create mode 100644 Documentation/acpi/method-customizing.txt
 create mode 100644 drivers/platform/x86/msi-wmi.c
 create mode 100644 drivers/platform/x86/toshiba_bluetooth.c

through these commits:

Alan Jenkins (31):
      eeepc-laptop: disp attribute should be write-only
      asus-laptop: Remove redundant NULL checks
      asus-acpi: Remove redundant NULL checks
      asus-laptop: Remove uneccesary acpi_disabled check
      asus-acpi: Remove uneccesary acpi_disabled checks
      asus-acpi: set acpi_driver.owner
      asus-laptop: set acpi_driver.owner
      eeepc-laptop: Remove redundant NULL checks
      eeepc-laptop: Remove uneccesary acpi_disabled check
      eeepc-laptop: set acpi_driver.owner
      eeepc-laptop: fix value of pwm1_enable to match documentation
      eeepc-laptop: fix led initialization order
      eeepc-laptop: fix potential leak (led_init() failure)
      eeepc-laptop: fix set_acpi() to return non-zero on failure
      eeepc-laptop: remove redundant NULL checks
      eeepc-laptop: no need to check argument of set_brightness()
      eeepc-laptop: simplify acpi initialization
      eeepc-laptop: simplify how the hwmon device reads values from the EC
      eeepc-laptop: refactor notifications
      eeepc-laptop: move platform driver registration out of eeepc_hotk_add()
      eeepc-laptop: move platform device initialisation to a separate function
      eeepc-laptop: code movement
      eeepc-laptop: revise names
      eeepc-laptop: callbacks should use "driver data" parameter or field
      eeepc-laptop: re-add check for eeepc->backlight == NULL
      hp-wmi: improve rfkill support
      dell-laptop: fix a use-after-free error on the failure path
      dell-laptop: fix rfkill memory leak on unload and failure paths
      dell-laptop: create a platform device as a parent for the rfkill devices etc.
      dell-laptop: add __init to init functions
      dell-laptop: remove duplicate Kconfig entry under drivers/misc

Alex Chiang (6):
      ACPI: dock: convert sysfs attributes to an attribute_group
      ACPI: dock: combine add|alloc_dock_dependent_device (v2)
      ACPI: dock: remove global 'dock_device_name'
      ACPI: dock: dock_add - hoist up platform_device_register_simple()
      ACPI: dock: add struct dock_station * directly to platform device data
      ACPI: dock: minor whitespace and style cleanups

Alexey Dobriyan (1):
      thinkpad-acpi: convert to seq_file

Andrew Morton (1):
      acpi_pad: squish warning

Anisse Astier (7):
      msi-wmi: remove useless includes
      msi-wmi: rework init
      msi-wmi: remove custom runtime debug implementation
      msi-wmi: remove unused field 'instance' in key_entry structure
      msi-wmi: replace one-condition switch-case with if statement
      msi-wmi: switch to using input sparse keymap library
      msi-wmi: depend on backlight and fix corner-cases problems

Bjorn Helgaas (5):
      PNPACPI: save struct acpi_device, not just acpi_handle
      PNP: add interface to retrieve ACPI device from a PNPACPI device
      ipmi: remove unused PCI probe code
      ipmi: refer to table as "SPMI", not "ACPI"
      ipmi: add PNP discovery (ACPI namespace via PNPACPI)

Bob Moore (13):
      ACPICA: Fix two Scope type error messages
      ACPICA: Fix two additional Scope override error messages
      ACPICA: Add repair for bad _FDE/_GTM buffers
      ACPICA: Update internal namespace node/handle interfaces
      ACPICA: Add more conversions to predefined name repair module
      ACPICA: Update function headers, no functional change
      ACPICA: Fix mutex errors when running _REG methods
      ACPICA: Move Package-to-Buffer repair code into common ToBuffer function
      ACPICA: Remove messages if predefined repair(s) are successful
      ACPICA: Update function headers and comments, no functional change
      ACPICA: Conditionally perform complex per-predefined-name repairs
      ACPICA: Predefined name repair: automatically remove null package elements
      ACPICA: Update version to 20091214

Corentin Chary (7):
      eeepc-laptop: add touchpad led
      asus-laptop: use KEY_F13 to map "Disable Touchpad" event
      asus-laptop: Add wlan switch found on V6V
      eeepc-laptop: map keys found on newer eeepc
      eeepc-laptop: fix coding style
      asus-laptop: schedule display_get and lcd_switch for removal
      asus-laptop: change light sens default values.

Dan Carpenter (1):
      ACPICA: Move check for valid Thread ID structure

David Rientjes (1):
      ACPI: remove NID_INVAL

Frans Pop (5):
      acpi: thermal: display forced passive trip points in proc
      thermal: add sanity check for the passive attribute
      thermal: Only set passive_delay for forced_passive cooling
      thermal: disable polling if passive_delay and polling_delay are both unset
      acpi: thermal: display forced passive trip points in proc

Henrique de Moraes Holschuh (16):
      thinkpad-acpi: fix default brightness_mode for R50e/R51
      thinkpad-acpi: preserve rfkill state across suspend/resume
      thinkpad-acpi: fix some version quirks
      thinkpad-acpi: issue backlight class events
      thinkpad-acpi: silence bogus complain during rmmod
      thinkpad-acpi: adopt input device
      thinkpad-acpi: expose module parameters
      thinkpad-acpi: log temperatures on termal alarm (v2)
      thinkpad-acpi: use input_set_capability
      thinkpad-acpi: sync input device EV_SW initial state
      thinkpad-acpi: log initial state of rfkill switches
      thinkpad-acpi: volume subdriver rewrite
      thinkpad-acpi: support MUTE-only ThinkPads
      thinkpad-acpi: disable volume control
      thinkpad-acpi: basic ALSA mixer support (v2)
      thinkpad-acpi: bump version to 0.24

Hidetoshi Seto (1):
      ACPI: fix for lapic_timer_propagate_broadcast()

Ike Panhc (1):
      asus-laptop: add Lenovo SL hotkey support

Jean Delvare (1):
      ACPI: add const to acpi_check_resource_conflict()

Jes Sorensen (1):
      Toshiba Bluetooth Enabling driver (RFKill handler v3)

Justin P. Mattock (1):
      battery: fix typo in comment

Lin Ming (2):
      ACPICA: Fix possible memory leak for module-level code execution
      ACPICA: Module-level code: enable _REG execution in same scope

Matthew Garrett (2):
      wmi: Add support for module autoloading
      dell-laptop: Fix rfkill state queries

Mike Travis (1):
      ACPI: Remove repeated registered as cooling_device messages

Peter Feuerer (1):
      acerhdf: add new BIOS versions

Rezwanul Kabir (1):
      dell-wmi: Add support for new Dell systems

Roel Kluin (1):
      thermal: Fix test of unsigned in thermal_cooling_device_cur_state_store()

Shaohua Li (3):
      ACPI: Add a generic API for _OSC -v2
      ACPI: cleanup pci_root _OSC code.
      ACPI: Add platform-wide _OSC support.

Thomas Renninger (2):
      X86 drivers: Introduce msi-wmi driver
      ACPI processor: Fix section mismatch for processor_add()

Zhang Rui (2):
      ACPI: support customizing ACPI control methods at runtime
      ACPI: add kernel tainting after overriding an ACPI control method

Zhao Yakui (3):
      ACPI: Notify the _PPC evaluation status to the platform
      ACPI: Use the ARB_DISABLE for the CPU which model id is less than 0x0f.
      ACPI: Use the return result of ACPI lid notifier chain correctly

with this log:

commit aa96ce0af8385415a3450bc13e6254a4d6b4a888
Merge: 2900681 bf8b454
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 14:22:32 2009 -0500

    Merge branch 'misc-2.6.33' into release

commit bf8b4542f92c4d8222941b1cab055fa350ab2fb4
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Oct 26 17:44:18 2009 +0100

    ACPI processor: Fix section mismatch for processor_add()
    
    Due to the merge of processor_start() (declared with __cpuinit) into
    processor_add(), a section mismatch warning appears:
    
    WARNING: drivers/built-in.o(.text+0x4d59d): Section mismatch in reference
    from the function acpi_processor_add() to the function
    .cpuinit.text:acpi_processor_power_init()
    ...
    
    This patch fixes the warning by declaring processor_add() as __cpuinit
    and also declares acpi_processor_add_fs() as __cpuinit as it is only
    used in acpi_processor_add().
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2900681b25d5a1a1a7b39ab66da3b8c6b1b0b7ad
Merge: 243e1ef 3563ff9
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 14:07:29 2009 -0500

    Merge branch 'osc' into release

commit 3563ff964fdc36358cef0330936fdac28e65142a
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Oct 29 11:05:05 2009 +0800

    ACPI: Add platform-wide _OSC support.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a9622dc4659af44a8098a233f65c51e495ff0a5
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Oct 29 11:04:50 2009 +0800

    ACPI: cleanup pci_root _OSC code.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 70023de88c58a81a730ab4d13c51a30e537ec76e
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Oct 29 11:04:28 2009 +0800

    ACPI: Add a generic API for _OSC -v2
    
    v2->v1:
    .improve debug info as suggedted by Bjorn,Kenji
    .API is using uuid string as suggested by Alexey
    
    Add an API to execute _OSC. A lot of devices can have this method, so add a
    generic API.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 243e1ef842ef9e24fbf1cc7ddf4fd1c01471544a
Merge: 7d8c220 42b4e9e
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 13:57:16 2009 -0500

    Merge branch 'toshiba-bt' into release

commit 7d8c22060555a51c23b9c6a76b97a5e75b5db882
Merge: f02f465 de078e5
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 13:57:12 2009 -0500

    Merge branch 'msi-wmi' into release

commit de078e5747fa3a95efac04fd6725dcceb4520416
Author: Anisse Astier <anisse@astier.eu>
Date:   Mon Dec 14 10:21:39 2009 +0100

    msi-wmi: depend on backlight and fix corner-cases problems
    
    Now depends on BACKLIGHT_CLASS_DEVICE.
    Driver will return an error if it can't get actual backlight value
    Fix remapping of brightness keys when backlight is not controlled by ACPI.
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c30116c6f0d26cd6e46dfa578163d573ef4730b2
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 10 14:18:19 2009 +0100

    msi-wmi: switch to using input sparse keymap library
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d607af93006594f7da1d4b7d44724c5308f4e892
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 10 14:18:18 2009 +0100

    msi-wmi: replace one-condition switch-case with if statement
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 977f9b921c82726745a8b7281dc679edb32b4906
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 10 14:18:17 2009 +0100

    msi-wmi: remove unused field 'instance' in key_entry structure
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 822ddc042a12aa2a8c2030ad4ebc660bc0e66c3f
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 10 14:18:16 2009 +0100

    msi-wmi: remove custom runtime debug implementation
    
    Rely on DYNAMIC_DEBUG instead if needed
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 46b51eb9e14afb3bde4bc2fe3bbc22ce012647d4
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 10 14:18:15 2009 +0100

    msi-wmi: rework init
    
    There should be less code duplication with usage of gotos
    Driver won't load if there's no hardware to control
    Safer error handling at input driver allocation
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit addd65aac7bcfed7348048b3ce24774718fc44c3
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 10 14:18:14 2009 +0100

    msi-wmi: remove useless includes
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d12d8baff927a31b7e13b72ed9549be6f296a6ef
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Dec 10 14:18:13 2009 +0100

    X86 drivers: Introduce msi-wmi driver
    
    This driver serves backlight (including switching) and volume up/down
    keys for MSI machines providing a specific wmi interface:
    551A1F84-FBDD-4125-91DB-3EA8F44F1D45
    B6F3EEF2-3D2F-49DC-9DE3-85BCE18C62F2
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: Carlos Corbacho <carlos@strangeworlds.co.uk>
    CC: Matthew Garrett <mjg59@srcf.ucam.org>
    Tested-by: Matt Chen <machen@novell.com>
    Reviewed-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 42b4e9ee3d1d3b691bcae37f217f08740320c58c
Author: Jes Sorensen <Jes.Sorensen@gmail.com>
Date:   Wed Dec 16 12:08:15 2009 -0500

    Toshiba Bluetooth Enabling driver (RFKill handler v3)
    
    This patch adds support for the ACPI events generated by the RFKill
    switch on modern Toshiba laptops, and re-enables the Bluetooth USB
    device when the switch is flipped back to the 'on' position.
    
    The RFKill switch brute force pulls out the USB device when flipped to
    'off', but it doesn't automatically re-enable it. Without this driver,
    the Bluetooth is gone until after a reboot on my Portege R500.
    
    Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 918aae42aa9b611a3663b16ae849fdedc67c2292
Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date:   Mon Dec 14 17:10:06 2009 +0900

    ACPI: fix for lapic_timer_propagate_broadcast()
    
    I got following warning on ia64 box:
      In function 'acpi_processor_power_verify':
      642: warning: passing argument 2 of 'smp_call_function_single' from
      incompatible pointer type
    
    This smp_call_function_single() was introduced by a commit
    f833bab87fca5c3ce13778421b1365845843b976:
    
     > @@ -162,8 +162,9 @@
     >               pr->power.timer_broadcast_on_state = state;
     >  }
     >
     > -static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
     > +static void lapic_timer_propagate_broadcast(void *arg)
     >  {
     > +       struct acpi_processor *pr = (struct acpi_processor *) arg;
     >         unsigned long reason;
     >
     >         reason = pr->power.timer_broadcast_on_state < INT_MAX ?
     > @@ -635,7 +636,8 @@
     >                 working++;
     >         }
     >
     > -       lapic_timer_propagate_broadcast(pr);
     > +       smp_call_function_single(pr->id, lapic_timer_propagate_broadcast,
     > +                                pr, 1);
     >
     >         return (working);
     >  }
    
    The problem is that the lapic_timer_propagate_broadcast() has 2 versions:
    One is real code that modified in the above commit, and the other is NOP
    code that used when !ARCH_APICTIMER_STOPS_ON_C3:
    
      static void lapic_timer_propagate_broadcast(struct acpi_processor *pr) { }
    
    So I got warning because of !ARCH_APICTIMER_STOPS_ON_C3.
    
    We really want to do nothing here on !ARCH_APICTIMER_STOPS_ON_C3, so
    modify lapic_timer_propagate_broadcast() of real version to use
    smp_call_function_single() in it.
    
    Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f02f465b1cdcdf7485f89ec019e6cceaf80cadd5
Merge: b620283 747479a
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 03:33:28 2009 -0500

    Merge branch 'dock' into release
    
    Conflicts:
    	drivers/acpi/dock.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f67538f81e6b8da9175c82807d649fbdb0055844
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Fri Nov 13 19:55:30 2009 -0800

    acpi_pad: squish warning
    
    drivers/acpi/acpi_pad.c: In function 'power_saving_thread':
    drivers/acpi/acpi_pad.c:103: warning: 'preferred_cpu' may be used uninitialized in this function
    
    Cc: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 747479a3fb42849fe73b9b1f7545d751bde7d632
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Oct 19 15:14:50 2009 -0600

    ACPI: dock: minor whitespace and style cleanups
    
    Removed some stray whitespaces
    Added whitespace when needed for legibility
    Removed unneeded curly braces
    Removed useless void casts
    Removed unnecessary local variable initialization
    Renamed variables to help out with 80-column fixes
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe06fba292af5ed5c1c6ad9af3a9ef68da7a5088
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Oct 19 15:14:45 2009 -0600

    ACPI: dock: add struct dock_station * directly to platform device data
    
    Instead of adding a (struct dock_station **) to our dock device's
    platform data, we can add the (struct dock_station *) directly.
    
    This change saves us some ugly casting and improves readability.
    
    The cost of making this change is an extra 290 bytes of stack usage,
    but this is an infrequently called code-path and unlikely to cause
    the kernel to blow up.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9751cb721ef650729e981c7b39abb7676cd646e1
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Oct 19 15:14:40 2009 -0600

    ACPI: dock: dock_add - hoist up platform_device_register_simple()
    
    Move the call to platform_device_register_simple so that we do it
    before allocating and initializing our struct dock_station.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c6f1905ea91bf56a921c6eb574488869c8c3eeff
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Oct 19 15:14:35 2009 -0600

    ACPI: dock: remove global 'dock_device_name'
    
    We only use it in one spot, so it probably gets optimized out, but there's
    still no need to use a global variable for this.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f69cfdd24ac40ab7bbd00d6ad85e003da755e3a0
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Oct 19 15:14:29 2009 -0600

    ACPI: dock: combine add|alloc_dock_dependent_device (v2)
    
    There's no real need to have a separate allocation step when adding
    a dock dependent device.
    
    Combining the two functions is both logical and helps with legibility.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6202832b43abb56b90ba8d68e2b9fc53c442fa6
Merge: 1a544d2 1caab3c
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 02:21:25 2009 -0500

    Merge branch 'wmi' into release

commit 1a544d28dd2fd7c90bb23118ab0ca09b1304a50c
Merge: 689a8ab 9e368fa
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 02:20:58 2009 -0500

    Merge branch 'ipmi' into release

commit 689a8ab32fa0ba11c4005b3733e59fb7094c2870
Merge: 1fc22fa 5ea2559
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 02:20:43 2009 -0500

    Merge branch 'dell-wmi' into release

commit 1fc22fad1f9115f37778f159c07b414923ba1cdc
Merge: 8033c31 4bab30a
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 02:19:59 2009 -0500

    Merge branch 'debug-aml' into release

commit 8033c314b9b67f53eddb3afcbec74c39b57b56b6
Merge: 8fa79e0 13c199c
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 02:19:55 2009 -0500

    Merge branch 'bugzilla-14782' into release

commit 8fa79e08f50f4ec1fd8903eca6fd6f36c36dd4c4
Merge: 7458bbd d81c45e
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 02:18:36 2009 -0500

    Merge branch 'ost' into release
    
    Conflicts:
    	include/acpi/processor.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 360657463679dee44f0b167ffa61f563b4fee101
Author: Peter Feuerer <peter@piie.net>
Date:   Tue Nov 17 14:27:37 2009 -0800

    acerhdf: add new BIOS versions
    
    Added new BIOS versions for following netbooks: Acer 1410, Gateway LT31,
    Packard Bell DOA150.  As the Gateway LT31 machines have different register
    values for setting and checking the off-state, the "cmd_off" variable has
    been splitted up to "cmd_off" and "chk_off".
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Cc: Borislav Petkov <petkovbb@gmail.com>
    Cc: Andreas Mohr <andi@lisas.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bf2abdd79ac81c52957bf0d0d5430cec5433cfb7
Author: Frans Pop <elendil@planet.nl>
Date:   Tue Nov 17 14:27:33 2009 -0800

    acpi: thermal: display forced passive trip points in proc
    
    Users can force a passive trip point for a thermal zone that does not have
    _PSV defined in ACPI by setting the passive attribute in sysfs.  It's
    useful to display such trip points in /proc/acpi/thermal_zone.
    
    .../TZ1/cooling_mode:<setting not supported>
    .../TZ1/polling_frequency:polling frequency:       10 seconds
    .../TZ1/state:state:                   ok
    .../TZ1/temperature:temperature:             53 C
    .../TZ1/trip_points:critical (S5):           110 C
    .../TZ1/trip_points:passive (forced):        95 C
    
    And if not set (passive is 0):
    .../TZ1/trip_points:passive (forced):<not set>
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Cc: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b552a8c56db8a74ceffdcbb9269664009a81d536
Author: David Rientjes <rientjes@google.com>
Date:   Tue Nov 17 14:27:32 2009 -0800

    ACPI: remove NID_INVAL
    
    NUMA_NO_NODE has been exported globally and thus it can replace NID_INVAL
    in the acpi code.
    
    Also removes the unused acpi_unmap_pxm_to_node() function.
    
    [akpm@linux-foundation.org: coding-style fixes]
    Cc: Cyrill Gorcunov <gorcunov@openvz.org>
    Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
    Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
    Signed-off-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13c199c0d0cf78b27592991129fb8cbcfc5164de
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Dec 15 22:01:57 2009 +0800

    ACPI: Use the return result of ACPI lid notifier chain correctly
    
    On some laptops it will return NOTIFY_OK(non-zero) when calling the ACPI LID
    notifier. Then it is used as the result of ACPI LID resume function, which
    will complain the following warning message in course of suspend/resume:
    
         >PM: Device PNP0C0D:00 failed to resume: error 1
    
    This patch is to eliminate the above warning message.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14782
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2345baf4a8a0ac2e7e83f932048bb2d8ec1287e7
Author: Justin P. Mattock <justinmattock@gmail.com>
Date:   Sun Dec 13 14:42:36 2009 -0800

    battery: fix typo in comment
    
    Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit edb949185210365f107ddc5efa60df105d25e1d7
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Tue Dec 15 22:46:50 2009 +0100

    thermal: Fix test of unsigned in thermal_cooling_device_cur_state_store()
    
    state is unsigned long so the test did not work.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13c41157096f05d5037a99152b4cf9d68ef00ef7
Author: Mike Travis <travis@sgi.com>
Date:   Mon Dec 14 13:38:30 2009 -0800

    ACPI: Remove repeated registered as cooling_device messages
    
    This message shows up for each cpu.  Print as debug messages.
    
    [   12.893967] processor ACPI0007:00: registered as cooling_device0
    [   12.907838] processor ACPI0007:01: registered as cooling_device1
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: linux-acpi@vger.kernel.org
    Cc: linux-kernel@vger.kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7458bbd044f0e799ad27c3fc71e1115ac30a9c25
Merge: 1667e399 5d2eb14
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 16 00:00:54 2009 -0500

    Merge branch 'thinkpad-2.6.33' into release

commit 5d2eb14d36723eba0b31ae208bc346835751e944
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:13 2009 -0200

    thinkpad-acpi: bump version to 0.24
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 887965e6576a78f71b9b98dec43fd1c73becd2e8
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue Dec 15 21:51:12 2009 -0200

    thinkpad-acpi: convert to seq_file
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0d204c34e85d1d63e5fdd3e3192747daf0ee7ec1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:11 2009 -0200

    thinkpad-acpi: basic ALSA mixer support (v2)
    
    Add the basic ALSA mixer functionality.  The mixer is event-driven,
    and will work fine on IBM ThinkPads.  I expect Lenovo ThinkPads will
    cause some trouble with the event interface.
    
    Heavily based on work by Lorne Applebaum <lorne.applebaum@gmail.com>
    and ideas from Matthew Garrett <mjg@redhat.com>.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Lorne Applebaum <lorne.applebaum@gmail.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c7ac6291ea7ebc568a1fce16fed87d102898f264
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:10 2009 -0200

    thinkpad-acpi: disable volume control
    
    Disable volume control by default.  It can be enabled at module load
    time by a module parameter (volume_control=1).
    
    The audio control mixer that thinkpad-acpi interacts with is fully
    functional without any drivers, and operated by hotkeys.
    
    The idea behind the console audio control is that the human operator
    is the only one that can interact with it.  The ThinkVantage suite in
    Windows does not allow any software-based overrides, and only does OSD
    (on-screen-display) functions.
    
    The Linux driver will, with the addition of the ALSA interface, try to
    follow and enforce the ThinkVantage UI design:
    
    The user is supposed to use the keyboard hotkeys to interact with the
    console audio control.  The kernel and the desktop environment is
    supposed to cooperate to provide proper user feedback through
    on-screen-display functions.
    
    Distros are urged to not to enable volume control by default.
    Enabling this must be a local admin's decision.  This is the reason
    why there is no Kconfig option.
    
    Keep in mind that all ThinkPads have a normal, main mixer (AC97 or
    HDA) for regular software-based audio control.  We are not talking
    about that mixer here.
    
    Advanced users are, of course, free to enable volume control and do as
    they please.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Lorne Applebaum <lorne.applebaum@gmail.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a112ceee673629afc204bf6b4a4828a6143a083f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:09 2009 -0200

    thinkpad-acpi: support MUTE-only ThinkPads
    
    Lenovo removed the extra mixer since the T61 and thereabouts.
    Newer Lenovo models only have the mute gate function, and leave
    the volume control to the HDA mixer.
    
    Until a way to automatically query the firmware about its audio
    control capabilities is discovered (there might not be any), use a
    white/black list.
    
    We will likely need to ask T60 (old and new model) and Z60/Z61 users
    whether they have volume control to populate the black/white list.
    Meanwhile, provide a volume_capabilities parameter that can be used to
    override the defaults.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Lorne Applebaum <lorne.applebaum@gmail.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 329e4e18dfdc552f36b0642a3de5ebfa96063666
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:08 2009 -0200

    thinkpad-acpi: volume subdriver rewrite
    
    I don't trust the coupled EC writes and SMI calls the current volume
    control code does very much, although it is exactly what the IBM DSDTs
    seem to do (they never do more than a single step though).
    
    Change the driver to stop issuing SMIs, and just drive the EC directly
    to the desired level (DSDTs seem to confirm this will work even on
    very old models like the 570 and 600e/x).
    
    We checkpoint directly to NVRAM (this can be turned off) at
    suspend/shutdown/driver unload, which from what I can see in tbp,
    should also work on every ThinkPad.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Lorne Applebaum <lorne.applebaum@gmail.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5451a923bbdcff6ae665947e120af7238b21a9d2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:07 2009 -0200

    thinkpad-acpi: log initial state of rfkill switches
    
    We already log the initial state of the hardware rfkill switch (WLSW),
    might as well log the state of the softswitches as well.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Josip Rodin <joy+kernel@entuzijast.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d89a727aff649f6768f7a34ee57f031ebf8bab4c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Dec 15 21:51:06 2009 -0200

    thinkpad-acpi: sync input device EV_SW initial state
    
    Before we register the input device, sync the input layer EV_SW state
    through a call to input_report_switch(), to avoid issuing a gratuitous
    event for the initial state of these switches.
    
    This fixes some annoyances caused by the interaction with rfkill and
    EV_SW SW_RFKILL_ALL events.
    
    Reported-by: Kevin Locke <kevin@kevinlocke.name>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Cc: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4bab30a041a2f27807b0b2a7fd36c8c8695c90c8
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 14 11:24:18 2009 +0800

    ACPI: add kernel tainting after overriding an ACPI control method
    
    Add kernel tainting after overriding an ACPI control method successfully.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1667e399a41be976c9d37bf02aa477979df111d2
Merge: abdef01 3767cb5
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 15 22:35:50 2009 -0500

    Merge branch 'thermal-2.6.33' into release

commit abdef01daceb120ef8cc03fbc96d5e029e2810b0
Merge: 6cbef9f e5fbba8
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 15 22:35:40 2009 -0500

    Merge branch 'hp-wmi' into release

commit 6cbef9fd7c7fa105ad758dc342cc0a14f413fa07
Merge: 0ceafc3 8c5d30e
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 15 22:35:31 2009 -0500

    Merge branch 'dell-laptop' into release

commit 0ceafc33affb566434f362c947b2e1a41450dcf9
Merge: 9a3bff2 03a05ed
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 15 22:35:21 2009 -0500

    Merge branch 'bugzilla-14700' into release

commit 9a3bff236b51583eaac7c2f0bd1db0dcf7b36a5c
Merge: 173cc11 d951d4c
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 15 22:34:48 2009 -0500

    Merge branch 'asus' into release
    
    Conflicts:
    	Documentation/feature-removal-schedule.txt
    	drivers/platform/x86/eeepc-laptop.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 173cc11a6e10c38ff7d4949b48e8d2eb0aee3e05
Merge: 8bea867 88e5071
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 15 22:27:39 2009 -0500

    Merge branch 'acpica' into release

commit d951d4cc84e8b5ddb8e0ab81cf6a72cc73fdd668
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Dec 7 22:05:50 2009 +0100

    asus-laptop: change light sens default values.
    
    The light sensor disable brightness key and
    /sys/class/backlight/ control. There was a lot of report
    from users who didn't understand why they couldn't change their
    brightness, including:
    
    https://bugs.launchpad.net/bugs/222171
    https://bugzilla.novell.com/show_bug.cgi?id=514747
    http://bugzilla.kernel.org/show_bug.cgi?id=13671
    http://bugzilla.kernel.org/show_bug.cgi?id=14432
    
    Now the light sensor is disabled, and if the user want to enable
    it, the level should be ok.
    
    The funny thing is that comments where ok, not code.
    
    Cc: stable@kernel.org
    Cc: Thomas Renninger <trenn@suse.de>
    Cc: Peter Küppers <peter-mailbox@web.de>
    Cc: Michael Franzl <michaelfranzl@gmx.at>
    Cc: Ian Turner <vectro@vectro.org>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e368fa011d4e0aa050db348d69514900520e40b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Nov 17 17:05:34 2009 -0700

    ipmi: add PNP discovery (ACPI namespace via PNPACPI)
    
    This allows ipmi_si_intf.c to claim IPMI devices described in the ACPI
    namespace.  Using PNP makes it simpler to parse the IRQ/IO/memory resources
    of the device.
    
    We look at any SPMI tables before looking for devices in the namespace.
    
    This is based on ipmi_pci_probe().
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 18a3e0bfbcd589599d0affbfd484ba9a97e5f122
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Nov 17 17:05:29 2009 -0700

    ipmi: refer to table as "SPMI", not "ACPI"
    
    This discovery method uses the SPMI table, not the ACPI namespace.  In
    the future, we will look in the namespace, so let's refer to the table
    as "SPMI" and save "ACPI" for the namespace.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad497680a5ff646e645752e3e065a752f32f12f8
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Nov 17 17:05:24 2009 -0700

    ipmi: remove unused PCI probe code
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9065ce4500085b9ca66b19d3c4d21a73cb410173
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Nov 17 17:05:19 2009 -0700

    PNP: add interface to retrieve ACPI device from a PNPACPI device
    
    Add pnp_acpi_device(pnp_dev), which takes a PNP device and returns the
    associated ACPI device (or NULL, if the device is not a PNPACPI device).
    
    This allows us to write a PNP driver that can manage both traditional
    PNPBIOS and ACPI devices, treating ACPI-only functionality as an optional
    extension.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 88e5071525ad6814be3a8a2792ce9e81a0cca22a
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 15 12:45:15 2009 +0800

    ACPICA: Update version to 20091214
    
    Version 20091214.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fbc3be2af3e8beb581a20c2a0cfda5692f5a1c08
Author: Dan Carpenter <error27@gmail.com>
Date:   Fri Dec 11 15:31:40 2009 +0800

    ACPICA: Move check for valid Thread ID structure
    
    This change moves the check for a valid Thread ID structure up a
    few lines to insure that the check is made before the structure
    is actually used.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d4085a3ffee8828f7f1bae7fa3cf5e58f59ba627
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:29:44 2009 +0800

    ACPICA: Predefined name repair: automatically remove null package elements
    
    This change will automatically remove embedded and trailing NULL
    package elements from returned package objects that are defined
    to containe a variable number of sub-packages. The driver is then
    presented with a package with no null elements to deal with.
    ACPICA BZ 819.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=819
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e31c32cfe52e98344dad28853c3331879f72c4b0
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Dec 11 15:28:27 2009 +0800

    ACPICA: Module-level code: enable _REG execution in same scope
    
    This change enables the execution of _REG methods that appear
    in the same scope as the module-level code, in resonse to an
    operation region declaration within the module-level code.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 465da9eb75665203a826f961de74a817b870850a
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:26:13 2009 +0800

    ACPICA: Conditionally perform complex per-predefined-name repairs
    
    Only attempt the "complex" repairs (package sorting, buffer
    expansion) if the previous "generic" validation and repair was
    successful.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 43420bbb892268b5fc42cb80c3bc31dedbad3ac9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:24:27 2009 +0800

    ACPICA: Update function headers and comments, no functional change
    
    Update comments for repair of _FDE and _GTM methods.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a58176e4fa47d8232e04131b023f3f2ecd7084b
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:23:22 2009 +0800

    ACPICA: Remove messages if predefined repair(s) are successful
    
    Repair mechanism was considered too wordy. Now, messages are only
    unconditionally emitted if the return object cannot be repaired.
    Existing messages for successful repairs were converted to
    ACPI_DEBUG_PRINT messages for now. ACPICA BZ 827.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=827
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea7c5ec148044776d5e134e52a3e1aca8d662dbe
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:18:52 2009 +0800

    ACPICA: Move Package-to-Buffer repair code into common ToBuffer function
    
    Move code specific to _FDE and _GTM into the generic repair code.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d97659112044c0c77b93c6199eee7ee884eb3cca
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:16:38 2009 +0800

    ACPICA: Fix mutex errors when running _REG methods
    
    Fixes a problem where mutex errors can occur when running a _REG
    method that is in the same scope as a method-defined operation
    region or an operation region under a module-level IF block.
    This is rare, so the problem has not been seen before.
    ACPICA BZ 826.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=826
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 90434c1c7c61ce7dd349f17f003b8813421aeadc
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:02:15 2009 +0800

    ACPICA: Update function headers, no functional change
    
    Fixed a few errors with the headers in utcopy.c
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 47e11d54d2a516461d89cbb3f2fb87084056af72
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 15:01:12 2009 +0800

    ACPICA: Add more conversions to predefined name repair module
    
    This change enhances the automatic repairs/conversions for
    predefined name return values to make Integers, Strings, and
    Buffers fully interchangeable. Also, a Buffer can be converted
    to a Package of Integers if necessary. The nsrepair.c module was
    completely restructured.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f24b664dc44a4ab4df61db2258cea298eeb43a8e
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 14:57:00 2009 +0800

    ACPICA: Update internal namespace node/handle interfaces
    
    This change deletes the unnecessary acpi_ns_convert_entry_to_handle
    interface and renames the acpi_ns_map_handle_to_node interface to
    acpi_ns_validate_handle.  ACPICA BZ 798.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=798
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 34c39c755347c1ca3d06284bad2273c6a9c3108a
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 14:53:11 2009 +0800

    ACPICA: Add repair for bad _FDE/_GTM buffers
    
    The expected return value for both names is a Buffer of 5 DWORDS.
    This repair fixes two possible problems (both seen in the field):
    A package of integers is returned, or a buffer of BYTEs is returned.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ebdca3edd5ac61e37f2f5e7c11006c1a68d3cc7e
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 14:40:17 2009 +0800

    ACPICA: Fix two additional Scope override error messages
    
    These messages were using the internal path for the message
    instead of using the node name.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f2cb12510836da63cf459dca452fc0770da155f1
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Dec 11 14:38:08 2009 +0800

    ACPICA: Fix two Scope type error messages
    
    Both messages incorrectly used the internal Path string instead
    of the node name.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 583061c59ffea1ea14f6dca735ab0f99238a7a92
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Dec 11 14:36:47 2009 +0800

    ACPICA: Fix possible memory leak for module-level code execution
    
    An object can be leaked for each block of executed module-level
    code if the interpreter slack mode is enabled. The change deletes
    any implicitly returned object in this case.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03a05ed1152944000151d57b71000de287a1eb02
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Dec 11 15:17:20 2009 +0800

    ACPI: Use the ARB_DISABLE for the CPU which model id is less than 0x0f.
    
    Currently, ARB_DISABLE is a NOP on all of the recent Intel platforms.
    For such platforms, reduce contention on c3_lock by skipping the fake
    ARB_DISABLE.
    
    The cpu model id on one laptop is 14. If we disable ARB_DISABLE on this box,
    the box can't be booted correctly. But if we still enable ARB_DISABLE on this
    box, the box can be booted correctly.
    
    So we still use the ARB_DISABLE for the cpu which mode id is less than 0x0f.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14700
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
    cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a1a541d86f50a9957beeedb122a035870d602647
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 2 13:31:00 2009 +0800

    ACPI: support customizing ACPI control methods at runtime
    
    Introduce a new debugfs I/F (/sys/kernel/debug/acpi/custom_method) for ACPI,
    which can be used to customize the ACPI control methods at runtime.
    
    We can use this to debug the AML code level bugs instead of overriding the
    whole DSDT table, without rebuilding/rebooting kernel any more.
    
    Detailed description about how to use this debugfs I/F is stated in
    Documentation/acpi/method-customizing.txt
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c4da6940a7a41c72781ff2d62ebd4b99f3749f14
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Nov 17 17:05:14 2009 -0700

    PNPACPI: save struct acpi_device, not just acpi_handle
    
    Some drivers need to look at things in the acpi_device structure
    besides the handle.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5ea2559726b786283236835dc2905c23b36ac91c
Author: Rezwanul Kabir <Rezwanul_Kabir@dell.com>
Date:   Mon Nov 2 12:00:42 2009 -0500

    dell-wmi: Add support for new Dell systems
    
    Newer Dell systems support HotKey features differently from legacy
    systems.  A new vendor specifc HotKey SMBIOS table (Type 0xB2) is
    defined. This table contains a mapping between scancode and the
    corresponding predefined keyfunction ( i.e. keycode).. Also, a new
    ACPI-WMI event type (called KeyIDList) with a value of 0x0010 is
    defined. Any BIOS containing 0xB2 table will send hotkey notifications
    using KeyIDList event.
    
    This is Rezwanul's patch, updated to ensure that brightness events are
    not sent if the backlight is controlled via ACPI and with the default
    keycode for the display output switching altered to match desktop
    expectations.
    
    Signed-off-by: Rezwanul Kabir <Rezwanul_Kabir@dell.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c5d30e590593495c5bb8bd4a2519ce1ac909a22
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Aug 19 15:44:10 2009 +0100

    dell-laptop: remove duplicate Kconfig entry under drivers/misc
    
    This showed up as an unselectable option when using xconfig and
    searching for "dell".  It must been overlooked when dell-laptop
    was moved to drivers/platform/x86.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4788df4cf44fd14847d37f88daea649f01c01017
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Aug 19 15:06:50 2009 +0100

    dell-laptop: add __init to init functions
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ada3248a5d38654b33b0ae2eabe1d7e3d9a9ffce
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Aug 19 15:06:49 2009 +0100

    dell-laptop: create a platform device as a parent for the rfkill devices etc.
    
    dell-laptop may not need to export any sysfs files, but it should still
    create a platform device as a parent for the rfkill and backlight
    devices.  Otherwise sysfs will display these as "virtual" devices,
    with no connection to either physical hardware or the dell-laptop
    module.
    
    Apparently this is useful for hardware detection.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4311bb230e0f7e4daa5fd5bc0cc536e2bd1eff20
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Aug 19 15:06:48 2009 +0100

    dell-laptop: fix rfkill memory leak on unload and failure paths
    
    rfkill_unregister() should always be followed by rfkill_destroy().
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 71e9dc73cb6b1351bdd5f732cef5dbef411b3219
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Aug 19 15:06:47 2009 +0100

    dell-laptop: fix a use-after-free error on the failure path
    
    dell_setup_rfkill() already cleans up the rfkill devices on failure.
    So if it returns an error, we should not try to unregister the rfkill
    devices.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e1fbf346c7c56d6b2f9d835d297bcb088baaff3a
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Jul 31 03:25:38 2009 +0100

    dell-laptop: Fix rfkill state queries
    
    The current code in dell-laptop is confused about the hardware rfkill
    state. Fix it up such that it's always reported correctly.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Tested-by: Tim Gardner <tim.gardner@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5fbba85a7acc2626d4fe14501816811d702f3e9
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Tue Jul 21 12:14:01 2009 +0100

    hp-wmi: improve rfkill support
    
    1) Add support for reading the hardware blocked state.  Previously
       we read a combination of the hardware and software blocked states,
       reporting it as the software blocked state.  This caused some
       confusing behaviour.
    
    2) The software state is persistent, mark it as such.
    
    3) Check rfkill in the resume handler.  Both the hard and soft
       blocked states may change over hibernation.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 728900f6fa7142e07a67d10d862bcb774d7a3493
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Dec 3 07:45:17 2009 +0000

    asus-laptop: schedule display_get and lcd_switch for removal
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 325fb8e9aeddf7bf8a7a892869dca00e7305c41e
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:15 2009 +0000

    eeepc-laptop: re-add check for eeepc->backlight == NULL
    
    As Corentin points out, we do not create a backlight device if the ACPI
    video driver is able to provide equivalent functionality. So we do need
    to check before we try to update the backlight device.
    
    We now ignore brightness events completely if we have not created a
    backlight device.  This is slightly more cautious than the original
    check.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f90be874303eddc53c199083a37bc44d65ab8351
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Dec 3 07:45:14 2009 +0000

    eeepc-laptop: fix coding style
    
    fix styles problems introduced by commit
    e86bda235a08b6a8e64c1e8bb9d175f6961554e3
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b39b85e74acfd62a22afc33a88a7bda36beb3367
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Dec 3 07:45:13 2009 +0000

    eeepc-laptop: map keys found on newer eeepc
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1f0233eee9b385d78fda78626136c43e045082f7
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Dec 3 07:45:12 2009 +0000

    asus-laptop: Add wlan switch found on V6V
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14f8af311e7d3e4198cbaade84a34f86505dcb37
Author: Ike Panhc <ike.pan@canonical.com>
Date:   Thu Dec 3 07:45:11 2009 +0000

    asus-laptop: add Lenovo SL hotkey support
    
    Lenovo SL series laptop has a very similar DSDT with Asus laptops. We can
    easily have the extra ACPI function support with little modification in
    asus-laptop.c
    
    Here is the hotkey enablement for Lenovo SL series laptop.
    
    This patch will enable the following hotkey:
     - Volumn Up
     - Volumn Down
     - Mute
     - Screen Lock (Fn+F2)
     - Battery Status (Fn+F3)
     - WLAN switch (Fn+F5)
     - Video output switch (Fn+F7)
     - Touchpad switch (Fn+F8)
     - Screen Magnifier (Fn+Space)
    
    The following function of Lenovo SL laptop is still need to be enabled:
     - Hotkey: KEY_SUSPEND (Fn+F4), KEY_SLEEP (Fn+F12), Dock Eject (Fn+F9)
     - Rfkill for bluetooth and wlan
     - LenovoCare LED
     - Hwmon for fan speed
     - Fingerprint scanner
     - Active Protection System
    
    Signed-off-by: Ike Panhc <ike.pan@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16851f92a5998bf8880a7401898ecfe351913854
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Dec 3 07:45:10 2009 +0000

    asus-laptop: use KEY_F13 to map "Disable Touchpad" event
    
    The same key is used in toshiba-laptop, and there is no
    reserved key for that.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 854c78363f37f03e30e2856ef17d7eefc62e0d06
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:09 2009 +0000

    eeepc-laptop: callbacks should use "driver data" parameter or field
    
    Callback methods should not refer to a variable like "eeepc" (formally
    "ehotk").  Instead, they should extract the data they need either from
    a "driver data" parameter, or the "driver data" field of the object
    which they operate on.  The "eeepc" variable can then be removed.
    
    In practice, drivers under "drivers/platform" can get away without using
    driver data, because it doesn't make sense to have more than one
    instance of them.  However this makes it harder to review them for
    correctness.  This is especially true for core ACPI developers who have
    not previously been exposed to this anti-pattern :-).
    
    This will serve as an example of best practice for new driver writers
    (whether they find it themselves, or have it pointed out during review
    :-).
    
    The hwmon sub-device is a special case.  It uses ec_{read,write} which
    are defined to communicate with the (first) EC, so it does not require
    any driver data.  It should still only be instantiated in the context of
    an ASUS010 device because we don't have a safe way to probe for it.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7624b63fdf50d7f460170891a49397280f08758
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:08 2009 +0000

    eeepc-laptop: revise names
    
    eeepc-laptop now does a lot more than just hotkeys.  Replace the "hotk"
    names used throughout the driver with some slightly more appropriate
    names.  The actual strings used in kernel messages and sysfs are left
    unchanged.
    
    e.g.
    	EEEPC_HOTK_FILE  -> EEEPC_LAPTOP_FILE
    	EEEPC_HOTK_HID   -> EEEPC_ACPI_HID
    
    	eeepc_hotk_notify -> eeepc_acpi_notify
    	struct eeepc_hotk -> struct eeepc_laptop
    	ehotk             -> eeepc
    
    I'm about to refactor the entire driver to remove the global "ehotk"
    variable, and I don't wish to add "struct eeepc_hotk *ehotk" to
    functions which have nothing to do with hotkeys.
    
    Also
     - fix the name of "eepc_get_entry_by_keycode()"
     - remove the unused definition of NOTIFY_WLAN_ON.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 52bbe3c7b413d656833686f9f08e5dcab3786eeb
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:07 2009 +0000

    eeepc-laptop: code movement
    
    Move e.g. backlight_init() and backlight_exit() together along with the
    other backlight functions, instead of grouping init() and exit()
    functions.  Move e.g. backlight_ops to follow the functions it refers
    to, and remove the forward declarations.  The code itself should remain
    unchanged.
    
    The eeepc-laptop driver implements a number of interfaces like the
    backlight class driver.  This change makes it easier to examine the
    implementation of one interface at at a time, without having to search
    through the file to find init() and exit() functions etc.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9db106be554288df5a0a7c56c20257a4391b9738
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:06 2009 +0000

    eeepc-laptop: move platform device initialisation to a separate function
    
    This moves the sysfs_create_group() call just after the declaration of
    the platform device attributes.  It should make it easier to examine
    the implementation of the platform device attributes in isolation
    from the rest of the code.  (The next commit will apply this pattern
    to all of the sub-devices as well).
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22072e92a038d2ee5848b3e54499ecab730c722c
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:05 2009 +0000

    eeepc-laptop: move platform driver registration out of eeepc_hotk_add()
    
    Strictly speaking we should register the platform driver exactly once,
    whether there are zero, one, or multiple matching acpi devices.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bf9598bcd5a73385ced7880ea09998a545e03dd8
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:04 2009 +0000

    eeepc-laptop: refactor notifications
    
    Separate out input_notify(), in a similar way to how notify_brn()
    is already separated.  This will allow all the functions which refer to
    the input device to be grouped together.
    
    This includes a small behaviour change - we now synthesize brightness
    up/down key events even if the brightness is already at the
    maximum/minimum value.  This is consistent with the new uevent
    interface.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 463b4e474ed0905ffc27ee347648739dbfb03acc
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:03 2009 +0000

    eeepc-laptop: simplify how the hwmon device reads values from the EC
    
    The hwmon device uses ec_write() to write values to the EC.  So for
    consistency it should use ec_read() to read values.  The extra layers
    of indirection used did not add any value.
    
    This may mean we no longer take the ACPI global lock for such reads
    (if the EC operation region requires the lock and the EC does not).
    But there is no point locking each one-byte read individually, when
    write operations do not use the lock at all.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6b188a7b218cb33d918e72f24995341f949297d2
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:02 2009 +0000

    eeepc-laptop: simplify acpi initialization
    
    We don't need to store init_flags after using them.  And we don't use
    the result of INIT, so we don't need to allocate a buffer for it.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 951037ea1cf4dc323906fd45d55ff015fd295d0c
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:01 2009 +0000

    eeepc-laptop: no need to check argument of set_brightness()
    
    We already tell the backlight class our maximum brightness value; it
    will validate the user requested values for us.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a2a1d36c78e90977e4ded9a20a7d8d27d84b13e4
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:45:00 2009 +0000

    eeepc-laptop: remove redundant NULL checks
    
    eeepc_hotk_notify() cannot be called with ehotk == NULL or bd == NULL.
    We check both variables for allocation failure and would bail out before
    the notifier is registered.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13f70029daa3cd7f9983e4aec82f32939b1a6e6a
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:59 2009 +0000

    eeepc-laptop: fix set_acpi() to return non-zero on failure
    
    If the control method does not exist, return -ENODEV for consistency
    with get_acpi()
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dc56ad9b49d20e38bb9745bf3beca84291b21a51
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:58 2009 +0000

    eeepc-laptop: fix potential leak (led_init() failure)
    
    If we bail out because we can't create the led class device, we need to
    ensure the led workqueue is cleaned up.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b56f1c170fc6338a7d907d6a7132669f9ccdf62
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:57 2009 +0000

    eeepc-laptop: fix led initialization order
    
    Create the workqueue thread used by tpd_led_set() *before* we register
    the led device.  (And vice versa for unregistration).
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 487186880d31821eaaba0cc1f27d5a581c56981d
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:56 2009 +0000

    eeepc-laptop: fix value of pwm1_enable to match documentation
    
    Documentation/hwmon/sysfs-interface tells us that automatic fan speed
    control should be represented by a value of 2 or above for pwm1_enable.
    Fix eeepc_get_fan_ctrl() to return 2 for automatic fan control.
    
    Setting "1" for manual control is already consistent with the
    documentation, so this remains unchanged.
    
    Let's preserve the ABI for this specific driver, so that writing "0"
    will still invoke automatic control.
    
    (The documentation says setting "0" should leave the fan at full speed
    all the time.  This mode is not directly supported by our hardware. Full
    speed is rather noisy on my 701 and the automatic control has never used
    it.  If you really want this e.g. to prolong the life of an EeePC used
    as a server, you can always use manual mode.  hwmon has always been
    fairly machine-specific, and you're in a tiny minority (or elite :-).
    I'm sure you're smart enough to notice that the fan doesn't turn on to
    full speed when you try this mode, either by ear or checking
    fan_input1.
    
    We could even claim to be honouring the spirit of the documentation.
    "0" really means "safe mode".  EeePCs default to automatic mode, ie that
    is what Asus will actually test.  Since we do not provide any way to
    tamper with the temperature threshold, automatic mode _is_ the safe
    option).
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eacec3031d1f444a618cf2d023d52f088cf82a7e
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:55 2009 +0000

    eeepc-laptop: set acpi_driver.owner
    
    The owner field provides the link between drivers and modules in sysfs,
    but no ACPI driver was setting it.
    
    After setting the owner field, we can see which module provides which
    driver and vice versa by looking at /sys/bus/acpi/driver/*/module and
    /sys/module/*/drivers/acpi:*.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2adb8bd380314feb8170d58b3852cad2c374d20f
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:54 2009 +0000

    eeepc-laptop: Remove uneccesary acpi_disabled check
    
    acpi_bus_register_driver() already checks acpi_disabled, so acpi bus
    drivers don't need to.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fbe3d8942e8fd1e947e4d11a3e9e15675a1cac7e
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:53 2009 +0000

    eeepc-laptop: Remove redundant NULL checks
    
    The acpi device callbacks add, start, remove, suspend and resume can
    never be called with a NULL acpi_device. Each callsite in acpi/scan.c
    has to dereference the device in order to get the ops structure, e.g.
    
        struct acpi_device *acpi_dev = to_acpi_device(dev);
        struct acpi_driver *acpi_drv = acpi_dev->driver;
    
        if (acpi_drv && acpi_drv->ops.suspend)
            return acpi_drv->ops.suspend(acpi_dev, state);
    
    Remove all checks for acpi_dev == NULL within these callbacks.
    
    Also remove the checks for acpi_driver_data(acpi_dev) == NULL. None of
    these checks could fail unless the driver does something strange
    (which none of them do), the acpi core did something terribly wrong,
    or we have a memory corruption issue. If this does happen then it's
    best to dereference the pointer and crash noisily.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3c0eb510697dbbb53674c72544350624a04ab5b4
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Dec 3 07:44:52 2009 +0000

    eeepc-laptop: add touchpad led
    
    This led can be found on Eeepc 1005 series.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit edf624522757adec8ceb83a4b97747eba645c454
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:51 2009 +0000

    asus-laptop: set acpi_driver.owner
    
    The owner field provides the link between drivers and modules in sysfs,
    but no ACPI driver was setting it.
    
    After setting the owner field, we can see which module provides which
    driver and vice versa by looking at /sys/bus/acpi/driver/*/module and
    /sys/module/*/drivers/acpi:*.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db7c554afeee7e535a5476dedb1339cb30d0b5df
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:50 2009 +0000

    asus-acpi: set acpi_driver.owner
    
    The owner field provides the link between drivers and modules in sysfs,
    but no ACPI driver was setting it.
    
    After setting the owner field, we can see which module provides which
    driver and vice versa by looking at /sys/bus/acpi/driver/*/module and
    /sys/module/*/drivers/acpi:*.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a4a9f6fd3dedefe06aed0e35c76bb6e0177adb6
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:49 2009 +0000

    asus-acpi: Remove uneccesary acpi_disabled checks
    
    acpi_bus_register_driver() already checks acpi_disabled, so acpi bus
    drivers don't need to.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7fab7a0703a9d3a3b4b59aa2f7b098b2b83b8fe
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:48 2009 +0000

    asus-laptop: Remove uneccesary acpi_disabled check
    
    acpi_bus_register_driver() already checks acpi_disabled, so acpi bus
    drivers don't need to.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2d5db0be4ce36b265f9ddd8debab40acd8580403
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:47 2009 +0000

    asus-acpi: Remove redundant NULL checks
    
    The acpi device callbacks add, start, remove, suspend and resume can
    never be called with a NULL acpi_device. Each callsite in acpi/scan.c
    has to dereference the device in order to get the ops structure, e.g.
    
        struct acpi_device *acpi_dev = to_acpi_device(dev);
        struct acpi_driver *acpi_drv = acpi_dev->driver;
    
        if (acpi_drv && acpi_drv->ops.suspend)
            return acpi_drv->ops.suspend(acpi_dev, state);
    
    Remove all checks for acpi_dev == NULL within these callbacks.
    
    Also remove the checks for acpi_driver_data(acpi_dev) == NULL. None of
    these checks could fail unless the driver does something strange
    (which none of them do), the acpi core did something terribly wrong,
    or we have a memory corruption issue. If this does happen then it's
    best to dereference the pointer and crash noisily.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1df8d8d4efb7bce0e44d2aa91c4c0fa7ffe613c0
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:46 2009 +0000

    asus-laptop: Remove redundant NULL checks
    
    The acpi device callbacks add, start, remove, suspend and resume can
    never be called with a NULL acpi_device. Each callsite in acpi/scan.c
    has to dereference the device in order to get the ops structure, e.g.
    
        struct acpi_device *acpi_dev = to_acpi_device(dev);
        struct acpi_driver *acpi_drv = acpi_dev->driver;
    
        if (acpi_drv && acpi_drv->ops.suspend)
            return acpi_drv->ops.suspend(acpi_dev, state);
    
    Remove all checks for acpi_dev == NULL within these callbacks.
    
    Also remove the checks for acpi_driver_data(acpi_dev) == NULL. None of
    these checks could fail unless the driver does something strange
    (which none of them do), the acpi core did something terribly wrong,
    or we have a memory corruption issue. If this does happen then it's
    best to dereference the pointer and crash noisily.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6dff29b63a5bf2eaf3313cb8a84f0b7520c43401
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Thu Dec 3 07:44:45 2009 +0000

    eeepc-laptop: disp attribute should be write-only
    
    Currently, reading from the disp attribute fails with "No such device",
    which is misleading. According to CMSG table on acpi4asus project site,
    no models have a getter method corresponding to SDSP. Change the file
    permission to disallow reads.
    
    If some joker changes the permission to permit reads, then return -EIO
    to be consistent with sysfs' behaviour when no show() method is
    provided.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 792979c8032b8f5adb77ea986db7082fff04c8e7
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:29 2009 +0000

    thinkpad-acpi: use input_set_capability
    
    Use input_set_capability() instead of set_bit.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ebd9e833648745fa5ac6998b9e0153ccd3ba839
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:28 2009 +0000

    thinkpad-acpi: log temperatures on termal alarm (v2)
    
    Log temperatures on any of the EC thermal alarms.  It could be
    useful to help tracking down what is happening...
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b09c72259e88cec3d602aef987a3209297f3a9c2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:27 2009 +0000

    thinkpad-acpi: expose module parameters
    
    Export the normal (non-command) module paramenters as mode 0444, so
    that they will show up in sysfs.
    
    These parameters must not be changed at runtime as a rule, with very
    few exceptions.
    
    Reported-by: Ferenc Wagner <wferi@niif.hu>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d112ef95d4ec1ee7fe7123e3f21e4aac0d57570c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:26 2009 +0000

    thinkpad-acpi: adopt input device
    
    Properly init the parent field of the input device.  Thanks to Alan
    Jenkins, who noted this problem in a different driver.
    
    Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6b30eb7d211840ba1a03f855d9e7b80a921368f2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:25 2009 +0000

    thinkpad-acpi: silence bogus complain during rmmod
    
    Fix this bogus warning during module shutdown, when
    backlight event reporting is enabled:
    
    "thinkpad_acpi: required events 0x00018000 not enabled!"
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 347a26860e2293b1347996876d3550499c7bb31f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:24 2009 +0000

    thinkpad-acpi: issue backlight class events
    
    Take advantage of the new events capabilities of the backlight class to
    notify userspace of backlight changes.
    
    This depends on "backlight: Allow drivers to update the core, and
    generate events on changes", by Matthew Garrett.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Matthew Garrett <mjg@redhat.com>
    Cc: Richard Purdie <rpurdie@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 90765c6aee568137521ba19347c744b5abde8161
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:23 2009 +0000

    thinkpad-acpi: fix some version quirks
    
    Update some of the BIOS/EC version quirks.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 208b996b6c460285650d39b2330f8ef82c007d10
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:22 2009 +0000

    thinkpad-acpi: preserve rfkill state across suspend/resume
    
    Since the rfkill rework in 2.6.31, the driver is always resuming with
    the radios disabled.
    
    Change thinkpad-acpi to ask the firmware to resume with the radios in
    the last state.  This fixes the Bluetooth and WWAN rfkill switches.
    
    Note that it means we respect the firmware's oddities.  Should the
    user toggle the hardware rfkill switch on and off, it might cause the
    radios to resume enabled.
    
    UWB is an unknown quantity since it has nowhere the same level of
    firmware support (no control over state storage in NVRAM, for
    example), and might need further fixing.  Testers welcome.
    
    This change fixes a regression from 2.6.30.
    
    Reported-by: Jerone Young <jerone.young@canonical.com>
    Reported-by: Ian Molton <ian.molton@collabora.co.uk>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Tested-by: Ian Molton <ian.molton@collabora.co.uk>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a9f8eacca4e9e8693de9b896c1fa7aadaa9402e8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Dec 9 01:36:21 2009 +0000

    thinkpad-acpi: fix default brightness_mode for R50e/R51
    
    According to a report, the R50e wants EC-based brightness control,
    even if it uses an Intel GPU.  The current driver default was reported
    to not work at all.
    
    This bug can be worked around by the "brightness_mode=3" module
    parameter.
    
    Change the default of the R50e and R51 2xxx models (which use the same
    EC firmware, 1V) to TPACPI_BRGHT_Q_EC, but keep TPACPI_BRGHT_Q_ASK set
    for now, as I'd like to get more reports.
    
    This fixes a regression caused by commit
    59fe4fe34d7afdf63208124f313be9056feaa2f4,
    "thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM"
    
    Kernel 2.6.31 also needs this fix.
    
    Reported-by: Ferenc Wagner <wferi@niif.hu>
    Tested-by: Ferenc Wagner <wferi@niif.hu>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 876fba43cc810e3c37ce26995933f9547b83cb0e
Author: Jean Delvare <khali@linux-fr.org>
Date:   Wed Nov 11 15:22:15 2009 +0100

    ACPI: add const to acpi_check_resource_conflict()
    
    acpi_check_resource_conflict() doesn't change the resource
    it operates on, so the res parameter can be marked const.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d81c45e1c9369855901420f79114852eba2ea16a
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 16 09:20:41 2009 +0800

    ACPI: Notify the _PPC evaluation status to the platform
    
    According to the ACPI spec(section 8.4.4.3) OSPM should convey the _PPC
    evaluations status to the platform if there exists the _OST object.
    The _OST contains two arguments:
    	The first is the PERFORMANCE notificatin event.
    	The second is the status of _PPC object.
    OSPM will convey the _PPC evaluation status to the platform.
    Of course when the module parameter of "ignore_ppc" is added, OSPM won't
    evaluate the _PPC object. But it will call the _OST object.
    
    At the same time the _OST object will be evaluated only when the PERFORMANCE
    notification event is received.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3767cb54ac718eb049d2a29f7a575ab923550ba5
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 26 08:39:04 2009 +0100

    thermal: disable polling if passive_delay and polling_delay are both unset
    
    Otherwise polling will continue for the thermal zone even when
    it is no longer needed, for example because forced passive cooling
    was disabled.
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4143b0324a6a468cb00c4341cd20d60cc441252
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 26 08:39:03 2009 +0100

    thermal: Only set passive_delay for forced_passive cooling
    
    Setting polling_delay is useless as passive_delay has priority,
    so the value shown in proc isn't the actual polling delay. It
    also gives the impression to the user that he can change the
    polling interval through proc, while in fact he can't.
    
    Also, unset passive_delay when the forced passive trip point is
    unbound to allow polling to be disabled.
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d8e3ad879441ae14c5957b933028daf39d252b0
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 26 08:39:02 2009 +0100

    thermal: add sanity check for the passive attribute
    
    Values below 1000 milli-celsius don't make sense and can cause the
    system to go into a thermal heart attack: the actual temperature
    will always be lower and thus the system will be throttled down to
    its lowest setting.
    
    An additional problem is that values below 1000 will show as 0 in
    /proc/acpi/thermal/TZx/trip_points:passive.
    
    cat passive
    0
    echo -n 90 >passive
    bash: echo: write error: Invalid argument
    echo -n 90000 >passive
    cat passive
    90000
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7fb2616e249184e217f9818a7662596165710ea4
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 26 08:39:01 2009 +0100

    acpi: thermal: display forced passive trip points in proc
    
    Users can force a passive trip point for a thermal zone that does not
    have _PSV defined in ACPI by setting the passive attribute in sysfs.
    It's useful to display such trip points in /proc/acpi/thermal_zone.
    
    .../TZ1/cooling_mode:<setting not supported>
    .../TZ1/polling_frequency:polling frequency:       10 seconds
    .../TZ1/state:state:                   ok
    .../TZ1/temperature:temperature:             53 C
    .../TZ1/trip_points:critical (S5):           110 C
    .../TZ1/trip_points:passive (forced):        95 C
    
    And if not set (passive is 0):
    .../TZ1/trip_points:passive (forced):<not set>
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1caab3c1a90be3aa4ec3599409d8fe044b077478
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Nov 4 14:17:53 2009 -0500

    wmi: Add support for module autoloading
    
    WMI provides interface-specific GUIDs that are exported from modules as
    modalises, but the core currently generates no events to trigger module
    loading. This patch adds support for registering devices for each WMI GUID
    and generating the appropriate uevent.
    
    Based heavily on a patch by Carlos Corbacho (<carlos@strangeworlds.co.uk>).
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f46c2f25cfbb5faca7550738ac42c4d1491ddc8
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Oct 19 15:14:24 2009 -0600

    ACPI: dock: convert sysfs attributes to an attribute_group
    
    As suggested by Dmitry Torokhov, convert the individual sysfs
    attributes into an attribute group.
    
    This change eliminates quite a bit of copy/paste code in the
    error handling paths.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Reviewed-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_xBs6XCwF1U1f336CgmxiBw)--
