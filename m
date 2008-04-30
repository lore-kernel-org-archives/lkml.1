Return-Path: <linux-kernel-owner+w=401wt.eu-S1764025AbYD3SWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764025AbYD3SWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbYD3SWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:22:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:59324 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760445AbYD3SVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:21:55 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] ACPI patches for 2.6.26-rc0
Date: Wed, 30 Apr 2008 14:20:11 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200804301420.11696.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch is a proper super-set of the pull request I made a week ago.
It will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20080321-2.6.25.diff.gz

 Documentation/laptops/thinkpad-acpi.txt      |  139 +++++-
 Documentation/thermal/sysfs-api.txt          |   33 +-
 MAINTAINERS                                  |    7 +
 arch/frv/kernel/pm.c                         |    8 -
 arch/mips/au1000/common/power.c              |   35 +--
 arch/x86/kernel/apm_32.c                     |   16 -
 drivers/acpi/Kconfig                         |    3 +
 drivers/acpi/bay.c                           |    2 +
 drivers/acpi/dispatcher/dsfield.c            |  159 ++++---
 drivers/acpi/dispatcher/dsinit.c             |    2 +-
 drivers/acpi/dispatcher/dsmethod.c           |   33 +-
 drivers/acpi/dispatcher/dsmthdat.c           |    2 +-
 drivers/acpi/dispatcher/dsobject.c           |   97 +++-
 drivers/acpi/dispatcher/dsopcode.c           |  260 +++++++++-
 drivers/acpi/dispatcher/dsutils.c            |  167 +++++-
 drivers/acpi/dispatcher/dswexec.c            |   78 ++--
 drivers/acpi/dispatcher/dswload.c            |   37 +-
 drivers/acpi/dispatcher/dswscope.c           |    2 +-
 drivers/acpi/dispatcher/dswstate.c           |  515 ++++--------------
 drivers/acpi/ec.c                            |  220 ++++----
 drivers/acpi/events/evevent.c                |    2 +-
 drivers/acpi/events/evgpe.c                  |    6 +-
 drivers/acpi/events/evgpeblk.c               |    2 +-
 drivers/acpi/events/evmisc.c                 |   90 ++--
 drivers/acpi/events/evregion.c               |    4 +-
 drivers/acpi/events/evrgnini.c               |    2 +-
 drivers/acpi/events/evsci.c                  |    2 +-
 drivers/acpi/events/evxface.c                |   23 +-
 drivers/acpi/events/evxfevnt.c               |    2 +-
 drivers/acpi/events/evxfregn.c               |    2 +-
 drivers/acpi/executer/exconfig.c             |  105 +++-
 drivers/acpi/executer/exconvrt.c             |    2 +-
 drivers/acpi/executer/excreate.c             |  117 +----
 drivers/acpi/executer/exdump.c               |   65 ++-
 drivers/acpi/executer/exfield.c              |   59 +--
 drivers/acpi/executer/exfldio.c              |   46 ++-
 drivers/acpi/executer/exmisc.c               |    2 +-
 drivers/acpi/executer/exmutex.c              |  235 ++++++---
 drivers/acpi/executer/exnames.c              |    2 +-
 drivers/acpi/executer/exoparg1.c             |   25 +-
 drivers/acpi/executer/exoparg2.c             |   21 +-
 drivers/acpi/executer/exoparg3.c             |    3 +-
 drivers/acpi/executer/exoparg6.c             |   10 +-
 drivers/acpi/executer/exprep.c               |   17 +-
 drivers/acpi/executer/exregion.c             |   10 +-
 drivers/acpi/executer/exresnte.c             |   12 +-
 drivers/acpi/executer/exresolv.c             |   55 +-
 drivers/acpi/executer/exresop.c              |   13 +-
 drivers/acpi/executer/exstore.c              |  107 +++-
 drivers/acpi/executer/exstoren.c             |    2 +-
 drivers/acpi/executer/exstorob.c             |    2 +-
 drivers/acpi/executer/exsystem.c             |    3 +-
 drivers/acpi/executer/exutils.c              |   57 +-
 drivers/acpi/fan.c                           |    7 +-
 drivers/acpi/glue.c                          |   20 +
 drivers/acpi/hardware/hwacpi.c               |    2 +-
 drivers/acpi/hardware/hwgpe.c                |    2 +-
 drivers/acpi/hardware/hwregs.c               |    2 +-
 drivers/acpi/hardware/hwsleep.c              |   16 +-
 drivers/acpi/hardware/hwtimer.c              |    2 +-
 drivers/acpi/namespace/nsaccess.c            |   47 ++-
 drivers/acpi/namespace/nsalloc.c             |    2 +-
 drivers/acpi/namespace/nsdump.c              |   11 +-
 drivers/acpi/namespace/nsdumpdv.c            |    2 +-
 drivers/acpi/namespace/nseval.c              |    2 +-
 drivers/acpi/namespace/nsinit.c              |   12 +-
 drivers/acpi/namespace/nsload.c              |    6 +-
 drivers/acpi/namespace/nsnames.c             |    8 +-
 drivers/acpi/namespace/nsobject.c            |    2 +-
 drivers/acpi/namespace/nsparse.c             |   33 +-
 drivers/acpi/namespace/nssearch.c            |    2 +-
 drivers/acpi/namespace/nsutils.c             |    2 +-
 drivers/acpi/namespace/nswalk.c              |    4 +-
 drivers/acpi/namespace/nsxfeval.c            |   15 +-
 drivers/acpi/namespace/nsxfname.c            |    2 +-
 drivers/acpi/namespace/nsxfobj.c             |    2 +-
 drivers/acpi/osl.c                           |    1 +
 drivers/acpi/parser/psargs.c                 |   57 ++-
 drivers/acpi/parser/psloop.c                 |   61 ++-
 drivers/acpi/parser/psopcode.c               |   38 ++-
 drivers/acpi/parser/psparse.c                |   39 +-
 drivers/acpi/parser/psscope.c                |    2 +-
 drivers/acpi/parser/pstree.c                 |    4 +-
 drivers/acpi/parser/psutils.c                |    2 +-
 drivers/acpi/parser/pswalk.c                 |    2 +-
 drivers/acpi/parser/psxface.c                |    2 +-
 drivers/acpi/power.c                         |    2 +-
 drivers/acpi/processor_core.c                |    7 +-
 drivers/acpi/processor_idle.c                |   18 +-
 drivers/acpi/resources/rsaddr.c              |    2 +-
 drivers/acpi/resources/rscalc.c              |   26 +-
 drivers/acpi/resources/rscreate.c            |    2 +-
 drivers/acpi/resources/rsdump.c              |   10 +-
 drivers/acpi/resources/rsinfo.c              |    2 +-
 drivers/acpi/resources/rsio.c                |   41 ++-
 drivers/acpi/resources/rsirq.c               |   45 ++-
 drivers/acpi/resources/rslist.c              |    2 +-
 drivers/acpi/resources/rsmemory.c            |    2 +-
 drivers/acpi/resources/rsmisc.c              |   13 +-
 drivers/acpi/resources/rsutils.c             |    8 +-
 drivers/acpi/resources/rsxface.c             |    2 +-
 drivers/acpi/scan.c                          |   63 ++-
 drivers/acpi/sleep/main.c                    |   42 +-
 drivers/acpi/tables/tbfadt.c                 |    2 +-
 drivers/acpi/tables/tbfind.c                 |   28 +-
 drivers/acpi/tables/tbinstal.c               |   22 +-
 drivers/acpi/tables/tbutils.c                |    2 +-
 drivers/acpi/tables/tbxface.c                |   91 +++-
 drivers/acpi/tables/tbxfroot.c               |    2 +-
 drivers/acpi/thermal.c                       |   20 +-
 drivers/acpi/utilities/utalloc.c             |    4 +-
 drivers/acpi/utilities/utcache.c             |    2 +-
 drivers/acpi/utilities/utcopy.c              |   61 ++-
 drivers/acpi/utilities/utdebug.c             |   19 +-
 drivers/acpi/utilities/utdelete.c            |   23 +-
 drivers/acpi/utilities/uteval.c              |    2 +-
 drivers/acpi/utilities/utglobal.c            |   49 ++-
 drivers/acpi/utilities/utinit.c              |    5 +-
 drivers/acpi/utilities/utmath.c              |    4 +-
 drivers/acpi/utilities/utmisc.c              |    6 +-
 drivers/acpi/utilities/utmutex.c             |    2 +-
 drivers/acpi/utilities/utobject.c            |    8 +-
 drivers/acpi/utilities/utresrc.c             |    2 +-
 drivers/acpi/utilities/utstate.c             |    2 +-
 drivers/acpi/utilities/utxface.c             |   41 +-
 drivers/acpi/utils.c                         |    2 +-
 drivers/acpi/video.c                         |  230 ++++----
 drivers/misc/Kconfig                         |   21 +-
 drivers/misc/Makefile                        |    1 +
 drivers/misc/eeepc-laptop.c                  |  666 +++++++++++++++++++++++
 drivers/misc/intel_menlow.c                  |   16 +-
 drivers/misc/thinkpad_acpi.c                 |  755 +++++++++++++++++++-------
 drivers/pnp/base.h                           |   74 +++-
 drivers/pnp/card.c                           |   55 ++-
 drivers/pnp/core.c                           |   46 ++-
 drivers/pnp/driver.c                         |   28 +-
 drivers/pnp/interface.c                      |  109 ++---
 drivers/pnp/isapnp/Makefile                  |    4 +
 drivers/pnp/isapnp/core.c                    |  336 ++++++------
 drivers/pnp/manager.c                        |  356 ++++++-------
 drivers/pnp/pnpacpi/Makefile                 |    4 +
 drivers/pnp/pnpacpi/core.c                   |   92 +---
 drivers/pnp/pnpacpi/pnpacpi.h                |    8 +-
 drivers/pnp/pnpacpi/rsparser.c               |  587 +++++++++++----------
 drivers/pnp/pnpbios/Makefile                 |    4 +
 drivers/pnp/pnpbios/bioscalls.c              |    1 -
 drivers/pnp/pnpbios/core.c                   |   31 +-
 drivers/pnp/pnpbios/pnpbios.h                |  140 +++++-
 drivers/pnp/pnpbios/proc.c                   |    2 +-
 drivers/pnp/pnpbios/rsparser.c               |  314 +++++------
 drivers/pnp/quirks.c                         |   15 +-
 drivers/pnp/resource.c                       |  361 ++++++++++---
 drivers/pnp/support.c                        |   63 +++
 drivers/pnp/system.c                         |   21 +-
 drivers/rtc/rtc-cmos.c                       |    7 +-
 drivers/thermal/Kconfig                      |    4 +-
 drivers/thermal/Makefile                     |    2 +-
 drivers/thermal/{thermal.c => thermal_sys.c} |  165 ++++++-
 include/acpi/acconfig.h                      |   15 +-
 include/acpi/acdebug.h                       |    2 +-
 include/acpi/acdisasm.h                      |   38 +-
 include/acpi/acdispat.h                      |   31 +-
 include/acpi/acevents.h                      |    2 +-
 include/acpi/acexcep.h                       |    2 +-
 include/acpi/acglobal.h                      |   38 +-
 include/acpi/achware.h                       |    2 +-
 include/acpi/acinterp.h                      |   15 +-
 include/acpi/aclocal.h                       |   10 +-
 include/acpi/acmacros.h                      |   51 +-
 include/acpi/acnames.h                       |    2 +-
 include/acpi/acnamesp.h                      |    5 +-
 include/acpi/acobject.h                      |    5 +-
 include/acpi/acopcode.h                      |    6 +-
 include/acpi/acoutput.h                      |    2 +-
 include/acpi/acparser.h                      |    4 +-
 include/acpi/acpi.h                          |    2 +-
 include/acpi/acpiosxf.h                      |    2 +-
 include/acpi/acpixf.h                        |    7 +-
 include/acpi/acresrc.h                       |    3 +-
 include/acpi/acstruct.h                      |    5 +-
 include/acpi/actables.h                      |    2 +-
 include/acpi/actbl.h                         |    2 +-
 include/acpi/actbl1.h                        |  561 +++++++++++++++++++-
 include/acpi/actypes.h                       |   93 ++--
 include/acpi/acutils.h                       |    4 +-
 include/acpi/amlcode.h                       |    2 +-
 include/acpi/amlresrc.h                      |    2 +-
 include/acpi/platform/acenv.h                |    2 +-
 include/acpi/platform/acgcc.h                |    2 +-
 include/acpi/platform/aclinux.h              |    2 +-
 include/linux/isapnp.h                       |   10 -
 include/linux/pnp.h                          |  208 ++++----
 include/linux/pnpbios.h                      |  151 -----
 include/linux/thermal.h                      |   39 +-
 kernel/power/Kconfig                         |   10 -
 kernel/power/Makefile                        |    1 -
 kernel/power/pm.c                            |  205 -------
 197 files changed, 6535 insertions(+), 3545 deletions(-)

through these commits:

Adrian Bunk (1):
      #if 0 acpi/bay.c:eject_removable_drive()

Alexey Starikovskiy (9):
      ACPI: EC: Restore udelay in poll mode
      ACPI: EC: Add poll timer
      ACPI: EC: Improve debug output
      ACPI: EC: Replace broken controller workarounds with poll mode.
      ACPI: EC: Switch off GPE mode during suspend/resume
      ACPI: EC: Detect irq storm
      ACPI: EC: Use default setup handler
      ACPI: EC: Don't delete boot EC
      ACPI: GPE enabling should happen after EC installation

Andrew Morton (1):
      PM: arch/x86/kernel/apm_32.c: fix build warning

Bjorn Helgaas (55):
      PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is set
      ISAPNP: move config register addresses out of isapnp.h
      PNPACPI: continue after _CRS and _PRS errors
      PNP: make pnp_add_id() internal to PNP core
      PNP: change pnp_add_id() to allocate its own pnp_id structures
      PNP: add pnp_eisa_id_to_string()
      PNP: add pnp_alloc_dev()
      PNP: make pnp_add_card_id() internal to PNP core
      PNP: change pnp_add_card_id() to allocate its own pnp_id structures
      ISAPNP: pull pnp_add_card_id() out of isapnp_parse_card_id()
      PNP: add pnp_alloc_card()
      PNPACPI: pnpacpi_encode_ext_irq() wrongly set "irq" instead of "extended_irq"
      PNPACPI: use temporaries to reduce repetition
      PNPACPI: hoist dma_flags() out of pnpacpi_parse_allocated_dmaresource()
      PNPACPI: extend irq_flags() to set IORESOURCE_IRQ_SHAREABLE when appropriate
      PNPACPI: pass pnp_dev instead of acpi_handle
      PNP: add debug output to option registration
      PNP: remove pnp_resource_table from internal get/set interfaces
      PNP: remove more pnp_resource_table arguments
      PNP: add debug output to encoders
      PNP: add debug when assigning PNP resources
      PNP: add pnp_init_resources(struct pnp_dev *) interface
      PNP: remove pnp_resource_table from internal pnp_clean_resource_table interface
      PNP: remove unused interfaces using pnp_resource_table
      PNP: use dev_printk when possible
      PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
      PNP: add pnp_get_resource() interface
      PNP: remove pnp_mem_flags() as an lvalue
      PNP: convert resource accessors to use pnp_get_resource(), not pnp_resource_table
      PNP: use conventional "i" for loop indices
      PNP: reduce redundancy in pnp_assign_port() and others
      PNP: reduce redundancy in pnp_check_port() and others
      PNP: reduce redundancy in pnp_set_current_resources()
      PNP: check for conflicts with all resources, not just earlier ones
      PNP: pass resources, not indexes, to pnp_check_port(), et al
      PNP: convert resource checks to use pnp_get_resource(), not pnp_resource_table
      PNP: convert encoders to use pnp_get_resource(), not pnp_resource_table
      PNP: convert assign, interface to use pnp_get_resource(), not pnp_resource_table
      PNP: remove PNP_MAX_* uses
      rtc: dont reference pnp_resource_table directly
      PNP: make pnp_resource_table private to PNP core
      PNP: remove pnp_resource_table references from resource decoders
      PNP: add struct pnp_resource
      PNP: add pnp_get_pnp_resource()
      PNP: add pnp_resource index for ISAPNP
      PNP: add pnp_new_resource() to find a new unset pnp_resource
      PNP: make generic pnp_add_irq_resource()
      PNP: make generic pnp_add_dma_resource()
      PNP: make generic pnp_add_io_resource()
      PNP: make generic pnp_add_mem_resource()
      ISAPNP: fold isapnp_read_resources() back into isapnp_get_resources()
      PNPACPI: move _CRS/_PRS warnings closer to the action
      PNP: make interfaces private to the PNP core
      ISAPNP: remove unused pnp_dev->regs field
      PNPBIOS: remove include/linux/pnpbios.h

Bob Moore (54):
      ACPICA: Several fixes for internal method result stack
      ACPICA: Removed unused code
      ACPICA: Update for mutiple global lock acquisitions by same thread
      ACPICA: changed order of interpretation of operand objects
      ACPICA: Avoid use of invalid pointers in returned object field
      ACPICA: Fixed a couple compiler warnings for extra extern statements
      ACPICA: Update comments for acquire/release mutex interfaces
      ACPICA: Removed extraneous code
      ACPICA: Removed obsolete ACPI_NO_INTEGER64_SUPPORT define
      ACPICA: Misc fixes for recent global lock code update
      ACPICA: Increase maximum buffer size dumped to screen in buffer object dump
      ACPICA: Fix for package reference counts
      ACPICA: Update version to 20070320
      ACPICA: Fix for update of the Global Lock Handle
      ACPICA: Update version to 20070508
      ACPICA: Updated error message for dynamic method serialization
      ACPICA: Support for iASL - multiple files and wildcards
      ACPICA: Add minimal disassembly support for the SLIC table
      ACPICA: update version number to 20070919
      ACPICA: Fix for Alias operator to see target child objects
      ACPICA: Fix for fault if Load() fails
      ACPICA: Fix a fault when storing DdbHandle to Debug object
      ACPICA: Fix for memory leak related to DdbHandle objects
      ACPICA: Add a table checksum verify for Load operator
      ACPICA: Add error checks to prevent faults
      ACPICA: Fix for Load/LoadTable to specify load location
      ACPICA: Fixed a memory leak when Device or Thermal objects referenced in packages
      ACPICA: Update version to 20071019
      ACPICA: Cosmetic changes only, no functional changes
      ACPICA: Cosmetic changes only, no functional changes
      ACPICA: Cleanup of debug output
      ACPICA: Fixes a problem with control method references within packages
      ACPICA: Fixed a problem with FromBCD and ToBCD with some compilers
      ACPICA: Update version to 20071114
      ACPICA: Fixed a problem with AcpiGetDevices where the search of a branch of the device tree could be terminated prematurely
      ACPICA: Fixed a problem with Index Fields where the Index register was incorrectly limited to a maximum of 32 bits
      ACPICA: Undo accidental checkin of not-fully-tested mutex changes
      ACPICA: Update version to 20071219
      ACPICA: Include file support for new ACPI tables
      ACPICA: Bulletproof disassembler for bad ACPI tables
      ACPICA: Update version to 20080123
      ACPICA: Add va_end statements as appropriate
      ACPICA: Added new error messages
      ACPICA: Fix for ACPI_HIDWORD macro
      ACPICA: Disassembler support for new ACPI tables
      ACPICA: Fix for resource descriptor optimization issues for _CRS/_SRC
      ACPICA: Fix for possible error when packages/buffers are passed to methods externally
      ACPICA: Update ACPICA version to 20080213
      ACPICA: Fix for extraneous debug message for packages
      ACPICA: Fixes for external Reference Objects
      ACPICA: Updates for Debug object output
      ACPICA: Fixes for size of StartDependent resource descriptor
      ACPICA: Update version to 20080321
      ACPICA: Fix for some local named nodes not marked temporary and to disallow duplicates

Corentin Chary (2):
      eeepc-laptop: add backlight
      eeepc-laptop: add hwmon fan control

Cyrill Gorcunov (1):
      thinkpad_acpi: fix possible NULL pointer dereference if kstrdup failed

Damián Viano (1):
      ACPICA: always disable GPE when requested

David Brownell (1):
      ACPI: crosslink ACPI and "real" device nodes

Dmitry Torokhov (3):
      ACPI: video - do not store invalid entries in attached_array list
      ACPI: video - properly handle errors when registering proc elements
      ACPI: video - fix permissions on some proc entries

Eric Cooper (1):
      eeepc-laptop: add base driver

Henrique de Moraes Holschuh (14):
      ACPI: thinkpad-acpi: BIOS backlight mode helper (v2.1)
      ACPI: thinkpad-acpi: warn once about weird hotkey masks
      ACPI: thinkpad-acpi: enhance box identification output (v2)
      ACPI: thinkpad-acpi: rate-limit CMOS/EC unsynced error messages
      ACPI: thinkpad-acpi: fix brightness dimming control bug
      ACPI: thinkpad-acpi: claim tpacpi as an official short handle (v1.1)
      ACPI: thinkpad-acpi: prepare light and LED for sysfs support
      ACPI: thinkpad-acpi: add sysfs led class support for thinklight (v3.1)
      ACPI: thinkpad-acpi: add sysfs led class support to thinkpad leds (v3.2)
      ACPI: thinkpad-acpi: use uppercase for "LED" on user documentation
      ACPI: thinkpad-acpi: fluff really minor fix
      ACPI: thinkpad-acpi: use a private workqueue
      ACPI: thinkpad-acpi: fix selects in Kconfig
      ACPI: thinkpad-acpi: bump up version to 0.20

Ingo Molnar (1):
      ACER_WMI/ASUS_LAPTOP: fix build bug

Julia Lawall (1):
      ACPI: elide a non-zero test on a result that is never 0

Len Brown (4):
      ACPICA: update Intel copyright
      thermal: re-name thermal.c to thermal_sys.c
      ACPI: re-name acpi_pm_ops to acpi_suspend_ops
      intel_menlo: fix build warning

Li Zefan (1):
      ACPI: check a return value correctly in acpi_power_get_context()

Lin Ming (15):
      ACPICA: New interfaces for table event handlers
      ACPICA: Fix for namespace lookup problem
      ACPICA: Fix for Increment/Decrement operator, incorrect type change
      ACPICA: Added additional parameter validation for LoadTable
      ACPICA: Fixed a problem with Index references passed as method arguments
      ACPICA: Fixed a problem with CopyObject used in conjunction with the Index operator
      ACPICA: Implemented full support for deferred execution for the TermArg string arguments for DataTableRegion
      ACPICA: Implemented full argument resolution support for the BankValue argument to BankField
      ACPICA: Fix for SizeOf when used with Buffers and Packages
      ACPICA: Methods now implicitly return 0 in slack mode
      ACPICA: Fix for Load operator
      ACPICA: Fix for LoadTable operator, input strings
      ACPICA: Fixes for Unload and DDBHandles
      ACPICA: Update behavior of CopyObject to match ACPI spec
      ACPICA: Fix to handle NULL package elements correctly

Pavel Machek (1):
      PM: Remove legacy PM

Ralf Baechle (1):
      MIPS Alchemy: Crapectomy after removal of pm_send_all calls.

Sam Ravnborg (1):
      acpi: fix section mismatch warning in pnpacpi

Thomas Renninger (1):
      ACPI: Cleanup: Remove unneeded, multiple local dummy variables

Venkatesh Pallipadi (2):
      2.6.25 regression: powertop says 120K wakeups/sec
      ACPI: Fix acpi_processor_idle and idle= boot parameters interaction

Zhang Rui (5):
      ACPICA: Update for new Notify values
      flush kacpi_notify_wq before removing notify handler
      thermal: add the support for building the generic thermal as a module
      thermal: add hwmon sysfs I/F
      thermal: update the documentation

Zhang, Rui (2):
      thermal: add new get_crit_temp callback
      ACPI: update thermal temperature

Zhao Yakui (1):
      ACPI : Disable the device's ability to wake the sleeping system in the boot phase

with this log:

commit 008238b54ac2350babf195084ecedbcf7851a202
Merge: 9691609... dfd2e1b...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Apr 30 13:59:05 2008 -0400

    Merge branch 'pnp' into release

commit 96916090f488986a4ebb8e9ffa6a3b50881d5ccd
Merge: 75a44ce... 729b2bd... 2f67a06... 51ae796... ce52ddf... e1faa9d... 36a9135... 9448b0d... 99bda83... 1071695... 7aa0f1a... 68f12ae... 66fb9d1...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Apr 30 13:58:00 2008 -0400

    Merge branches 'release', 'acpica', 'bugzilla-10224', 'bugzilla-9772', 'bugzilla-9916', 'ec', 'eeepc', 'idle', 'misc', 'pm-legacy', 'sysfs-links-2.6.26', 'thermal', 'thinkpad' and 'video' into release

commit 36a913586597cab1cd565e9bf348d037f0df955b
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Wed Apr 30 13:57:15 2008 -0400

    ACPI: Fix acpi_processor_idle and idle= boot parameters interaction
    
    acpi_processor_idle and "idle=" boot parameter interaction is broken.
    The problem is that, at boot time acpi driver is checking for "idle=" boot
    option and not registering the acpi idle handler. But, when there is a CST
    changed callback (typically when switching AC <-> battery or suspend-resume)
    there are no checks for boot_option_idle_override and acpi idle handler tries
    to get installed with nasty side effects.
    
    With CPU_IDLE configured this issue causes results in a nasty oops on CST
    change callback and without CPU_IDLE there is no oops, but boot option
    of "idle=" gets ignored and acpi idle handler gets installed.
    
    Change the behavior to not do anything in acpi idle handler when there is a
    "idle=" boot option.
    
    Note that the problem is only there when "idle=" boot option is used.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9448b0d43e5509c6b7baca02510a92ef2de6e328
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Tue Apr 29 22:52:01 2008 +0200

    acpi: fix section mismatch warning in pnpacpi
    
    Fix following section mismatch warning:
    WARNING: vmlinux.o(.text+0x153d69): Section mismatch in reference from the function is_exclusive_device() to the variable .init.data:excluded_id_list
    
    is_exclusive_device is only used from __init context so document
    this with the __init annotation and get rid of the warning.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7aa0f1a8b1f7072990c9dc37f238c96dc6d78911
Author: Len Brown <len.brown@intel.com>
Date:   Tue Apr 29 12:24:24 2008 -0400

    intel_menlo: fix build warning
    
    drivers/misc/intel_menlow.c:191: warning: label ‘unregister’ defined but not used
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66fb9d120e91050093b8ce4c1daa2e440660152b
Author: Thomas Renninger <trenn@suse.de>
Date:   Wed Apr 16 20:52:02 2008 +0200

    ACPI: Cleanup: Remove unneeded, multiple local dummy variables
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c46e5658a0b81891532705bd65592afe091a5967
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:36 2007 -0500

    ACPI: video - fix permissions on some proc entries
    
    POST and DOS are supposed to be writable but permissions
    did not allow it.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 251cb0bc795f5c0d8ca27df093319e5b39966174
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:34 2007 -0500

    ACPI: video - properly handle errors when registering proc elements
    
    Have acpi_video_device_add_fs() and acpi_video_bus_add_fs()
    properly unwind proc creation after error.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78eed028f13b1a0b2612368dff3786e400e6cf8b
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:33 2007 -0500

    ACPI: video - do not store invalid entries in attached_array list
    
    this is a cleanup, not a change to function.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2c6e33c366bff2f839df60d9235ff09143e28dd9
Author: Len Brown <len.brown@intel.com>
Date:   Wed Apr 23 18:02:52 2008 -0400

    ACPI: re-name acpi_pm_ops to acpi_suspend_ops
    
    ... as they are platform_suspend_ops after all.
    
    cosmetic re-name only, no functional change.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e7ae1e7ef9b4ef50444a49611dab92cb778eb97c
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Apr 29 10:21:20 2008 +0200

    ACER_WMI/ASUS_LAPTOP: fix build bug
    
    randconfig testing in x86.git found the following upstream build bug:
    
     drivers/built-in.o: In function `acer_led_exit':
     acer-wmi.c:(.text+0xdc76e): undefined reference to `led_classdev_unregister'
     drivers/built-in.o: In function `acer_platform_probe':
     acer-wmi.c:(.devinit.text+0x63e6): undefined reference to `led_classdev_register'
    
    which was due to acer-wmi.o only depending on CONFIG_LEDS_CLASS, while
    also using a symbol offered by CONFIG_NEW_LEDS. Also fix a similar bug
    in CONFIG_ASUS_LAPTOP.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 90fe17f4df2f830601ffd422b11d1f7f9a9d0355
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Fri Apr 18 13:27:29 2008 -0700

    thinkpad_acpi: fix possible NULL pointer dereference if kstrdup failed
    
    Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a815ab8b5891f3d2515316655729272f68269e3b
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Fri Apr 18 13:27:29 2008 -0700

    ACPI: check a return value correctly in acpi_power_get_context()
    
    We should check *resource != NULL rather than resource != NULL, which will be
    always true.
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    Acked-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2a241d77cfdab08544a78057a4b24c9a98dc79d0
Author: Adrian Bunk <bunk@kernel.org>
Date:   Mon Mar 31 02:05:40 2008 +0300

    #if 0 acpi/bay.c:eject_removable_drive()
    
    This patch #if 0's the unused eject_removable_drive().
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e1faa9da284d14487ed4280b4e87cfde8e1539af
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Mar 13 12:57:18 2008 +0100

    eeepc-laptop: add hwmon fan control
    
    Adds an hwmon interface to control the fan.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a5fa429b4b19cccd3f91a98af891c7ba2706cc1d
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Mar 13 12:56:37 2008 +0100

    eeepc-laptop: add backlight
    
    Add backlight class support to the eeepc-laptop driver.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e59f87966adef2cb03d419530e3ade5159487d6d
Author: Eric Cooper <ecc@cmu.edu>
Date:   Thu Mar 13 12:55:46 2008 +0100

    eeepc-laptop: add base driver
    
    This patch is based on Eric Cooper's work to clean the original asus_acpi
    given by Asus.  It's a platform driver (/sys/devices/platform/eeepc/)
    wich support:
         - hotkeys - wlan on/off - camera on/off - cardr on/off
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68f12ae5d778279e13e406d3913c74c592307770
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:30 2008 -0300

    ACPI: thinkpad-acpi: bump up version to 0.20
    
    Full LED sysfs support, and the rest of the assorted minor fixes and
    enhancements are a good reason to checkpoint a new version...
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f6cb5630a5994f58c3cf620d0f6d71ff626229d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:29 2008 -0300

    ACPI: thinkpad-acpi: fix selects in Kconfig
    
    Add missing select for BACKLIGHT_LCD_SUPPORT, as select doesn't select the
    dependencies of a symbol for us.
    
    Also, "select INPUT" in Kconfig.  We are not an Input device, nor are we
    anywhere close to the input subsystem in the Kconfig tree, so using
    "depends on INPUT" is not user-friendly at all.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0e3c0615abdb1c3e28356595f7be87627288d5b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:28 2008 -0300

    ACPI: thinkpad-acpi: use a private workqueue
    
    Switch all task workers to a private thinkpad-acpi workqueue.
    
    This way, we don't risk causing trouble for other tasks scheduled to the
    default work queue, as our workers end up needing to access the ACPI EC,
    run ACPI AML code, trigger SMI traps... and none of those are exactly known
    to be fast, simple operations.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10cc92759bb5d6031d308bdde96775f74082bb44
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:27 2008 -0300

    ACPI: thinkpad-acpi: fluff really minor fix
    
    Fix a minor (nano?) thing that bothered me at exactly at the wrong time.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 65807cc284dd291b024dd6e55de88feb16b4230a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:26 2008 -0300

    ACPI: thinkpad-acpi: use uppercase for "LED" on user documentation
    
    Change all occourences of the "led" word to full uppercase in user
    documentation.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit af116101924914a9655dfad108548d0db58c40f9
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:25 2008 -0300

    ACPI: thinkpad-acpi: add sysfs led class support to thinkpad leds (v3.2)
    
    Add a sysfs led class interface to the led subdriver.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e306501d1c4ff610feaba74ac35dd13e470480e6
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:24 2008 -0300

    ACPI: thinkpad-acpi: add sysfs led class support for thinklight (v3.1)
    
    Add a sysfs led class interface to the thinklight (light subdriver).
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4fa6811b8ade1b7839342824939817a8fc751539
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:23 2008 -0300

    ACPI: thinkpad-acpi: prepare light and LED for sysfs support
    
    Do some preparatory work to add sysfs support to the thinklight and
    thinkpad leds driver.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95e57ab2cbd8b016327b23d76da8a96cbd26ac0c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:22 2008 -0300

    ACPI: thinkpad-acpi: claim tpacpi as an official short handle (v1.1)
    
    Unfortunately, a lot of stuff in the kernel has size limitations, so
    "thinkpad-acpi" ends up eating up too much real estate.  We were using
    "tpacpi" in symbols already, but this shorthand was not visible to
    userland.
    
    Document that the driver will use tpacpi as a short hand where necessary,
    and use it to name the kernel thread for NVRAM polling (now named
    "ktpacpi_nvramd").
    
    Also, register a module alias with the shorthand.  One can refer to the
    module using the shorthand name.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e11aecf1379e7c4a0293182096e38e5a336696b2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:21 2008 -0300

    ACPI: thinkpad-acpi: fix brightness dimming control bug
    
    ibm-acpi and thinkpad-acpi did not know about bit 5 of the EC backlight
    level control register (EC 0x31), so it was always forced to zero on
    any writes.
    
    This would disable the BIOS option to *not* use a dimmer backlight level
    scale while on battery, and who knows what else (there are two other
    control bits of unknown function).
    
    Bit 5 controls the "reduce backlight levels when on battery" optional
    functionality (active low).  Bits 6 and 7 are better left alone as well,
    instead of being forced to zero.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2d5e94d7ca315f859a0eee1366838e8ad34dd7b2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:20 2008 -0300

    ACPI: thinkpad-acpi: rate-limit CMOS/EC unsynced error messages
    
    If userspace applications mess with the CMOS NVRAM, or something causes
    both the ACPI firmware and thinkpad-acpi to try to change the brightness at
    the same time, it is possible to have the CMOS and EC registers for the
    current brightness go out of sync.
    
    Should that happen, thinkpad-acpi could be really obnoxious when using a
    brightness_mode of 3 (both EC and CMOS).  Instead of complaining a massive
    number of times, make sure to complain only once until EC and CMOS are back
    in sync.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Joerg Platte <lists@naasa.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c74adbc692a3cb040cc69d7ca3dfd86d75860a8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:19 2008 -0300

    ACPI: thinkpad-acpi: enhance box identification output (v2)
    
    During initialization, thinkpad-acpi outputs some messages to make sure
    releavant box identification information is easily available in-line with
    the rest of the driver messages.
    
    Enhance those messages to output the alfanumeric model number as well.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 92889022250d736e135ca92fbffd1ab0ea4780d1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:18 2008 -0300

    ACPI: thinkpad-acpi: warn once about weird hotkey masks
    
    thinkpad-acpi knows for a while now how to best program the hotkeys by
    default, and always enable them by default.  Unfortunately, this
    information has not filtered down everywhere it needs to, yet.  Notably,
    old ibm-acpi documentation and most "thinkpad setup guides" will have wrong
    information on this area.
    
    Warn the local admin once whenever any of the following patterns are met:
    
    1. Attempts to set hotkey mask to 0xffff (artifact from docs and config
       for the old ibm-acpi driver and behaviour).  This mask makes no
       real-world sense;
    
    2. Attempts to set hotkey mask to 0xffffffff, which means the user is
       trying to just have "everything work" without even reading the
       documentation, or that we need to get a bug report, because there
       is a new thinkpad out there with new exciting hot keys :-)
    
    3. Attempts to set hotkey mask to 0xffffff, which is almost never the
       correct way to set up volume and brightness event reporting (and with
       the current state-of-the-art, it is known to never be right way to do
       it).
    
    The driver will perform any and all requested operations, though,
    regardless of any warnings.  I hope these warnings can be removed one or
    two years from now.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b59727965d7f286489206c292e2788d4835a8a23
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 26 01:02:17 2008 -0300

    ACPI: thinkpad-acpi: BIOS backlight mode helper (v2.1)
    
    Lenovo ThinkPads with generic ACPI backlight level control can be easily
    set to react to keyboard brightness key presses in a more predictable way
    than what they do when in "DOS / bootloader" mode after Linux brings
    up the ACPI interface.
    
    The switch to the ACPI backlight mode in the firmware is designed to be
    safe to use only as an one way trapdoor.  One is not to force the firmware
    to switch back to "DOS/bootloader" mode except by rebooting.  The mode
    switch itself is performed by calling any of the ACPI _BCL methods at least
    once.
    
    When in ACPI mode, the backlight firmware just issues (standard) events for
    the brightness up/down hot key presses along with the non-standard HKEY
    events which thinkpad-acpi traps, and doesn't touch the hardware.
    
    thinkpad-acpi will:
    
    1. Place the ThinkPad firmware in ACPI backlight control mode
       if one is available
    2. Suppress HKEY backlight change notifications by default
       to avoid double-reporting when ACPI video is loaded when
       the ThinkPad is in ACPI backlight control mode
    3. Urge the user to load the ACPI video driver
    
    The user is free to use either the ACPI video driver to get the brightness
    key events, or to override the thinkpad-acpi default hotkey mask to get
    them from thinkpad-acpi as well (this will result in duplicate events if
    ACPI video is loaded, so let's hope distros won't screw this up).
    
    Provided userspace is sane, all should work (and *keep* working), which is
    more that can be said about the non-ACPI mode of the new Lenovo ThinkPad
    BIOSes when coupled to current userspace and X.org drivers.
    
    Full guidelines for backlight hot key reporting and use of the
    thinkpad-acpi backlight interface have been added to the documentation.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Matthew Garrett <mjg59@srcf.ucam.org>
    Cc: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 51ae796f7fa1d8034252628572053f477bc29913
Author: Damián Viano <des@debian.org>
Date:   Tue Apr 29 03:32:25 2008 -0400

    ACPICA: always disable GPE when requested
    
    acpi_ev_disable_gpe() has an optimization where it doesn't disable
    a GPE that it "doesn't have to".  Unfortunately, it can get tricked
    by AML that scribbles on register state behind its back.  So when asked
    to disable a GPE, simply do it -- a redundant register write
    in the common case is a fair price to pay to be bomb-proof
    for the rare cases.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=6217
    
    Signed-off-by: Damián Viano <des@debian.org>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dfd2e1b4e6eb46ff59c7e1c1111c967b8b5981c1
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:42 2008 -0600

    PNPBIOS: remove include/linux/pnpbios.h
    
    The contents of include/linux/pnpbios.h are used only inside the PNPBIOS
    backend, so this file doesn't need to be visible outside PNP.
    
    This patch moves the contents into an existing PNPBIOS-specific file,
    drivers/pnp/pnpbios/pnpbios.h.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 261b20da4bd349f1b26e206f440809f1351be34b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:41 2008 -0600

    ISAPNP: remove unused pnp_dev->regs field
    
    The "regs" field in struct pnp_dev is set but never read, so remove it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 62cfb298b95d713825deb8faf2044c45a1e17a0a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:40 2008 -0600

    PNP: make interfaces private to the PNP core
    
    The interfaces for registering protocols, devices, cards,
    and resource options should only be used inside the PNP core.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d152cf5d0c3325979e71ee53b425fdd51a1a285a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:39 2008 -0600

    PNPACPI: move _CRS/_PRS warnings closer to the action
    
    Move warnings about _CRS and _PRS problems to the place where we
    actually make the ACPI calls.  Then we don't have to pass around
    acpi_status values any more than necessary.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01115e7d41c4eaeffa064d818b4abbd3efa94f80
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:38 2008 -0600

    ISAPNP: fold isapnp_read_resources() back into isapnp_get_resources()
    
    isapnp_get_resources() does very little besides call
    isapnp_read_resources(), so just fold them back together.
    
    Based on a patch by Rene Herman <rene.herman@gmail.com>
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d6180f36617953990bf90d4c1ff85b77e9995cd1
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:37 2008 -0600

    PNP: make generic pnp_add_mem_resource()
    
    Add a pnp_add_mem_resource() that can be used by all the PNP
    backends.  This consolidates a little more pnp_resource_table
    knowledge into one place.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc8c2e308194f0997c718c7c735550ff06754d20
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:36 2008 -0600

    PNP: make generic pnp_add_io_resource()
    
    Add a pnp_add_io_resource() that can be used by all the PNP
    backends.  This consolidates a little more pnp_resource_table
    knowledge into one place.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dc16f5f2ede8cc2acf8ac22857a7fecf3a4296c2
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:35 2008 -0600

    PNP: make generic pnp_add_dma_resource()
    
    Add a pnp_add_dma_resource() that can be used by all the PNP
    backends.  This consolidates a little more pnp_resource_table
    knowledge into one place.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dbddd0383c59d588f8db5e773b062756e39117ec
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:34 2008 -0600

    PNP: make generic pnp_add_irq_resource()
    
    Add a pnp_add_irq_resource() that can be used by all the PNP
    backends.  This consolidates a little more pnp_resource_table
    knowledge into one place.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a50b6d7b8d7e1a8b13bd1be65a865b115e1190d9
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:33 2008 -0600

    PNP: add pnp_new_resource() to find a new unset pnp_resource
    
    This encapsulates the code to locate a new pnp_resource of the
    desired type.  Currently this uses the pnp_resource_table, but
    it will soon change to find a resource in a linked list.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 21855d69d1e3ace3efdb8159a4a7ab1ab98a6f19
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:32 2008 -0600

    PNP: add pnp_resource index for ISAPNP
    
    Save the ISAPNP config register index in the struct pnp_resource.
    
    We need this because it is important to write ISAPNP configuration
    back to the same registers we read it from.  For example, if we
    read valid regions from memory descriptors 0, 1, and 3, we'd
    better write them back to the same registers, without compressing
    them to descriptors 0, 1, and 2.
    
    This was previously guaranteed by using the index into the
    pnp_resource_table array as the ISAPNP config register index.
    However, I am removing those fixed-size arrays, so we need to
    save the ISAPNP register index elsewhere.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0a977f15469457d9a19eed992caf71995c674064
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:31 2008 -0600

    PNP: add pnp_get_pnp_resource()
    
    In some places, we need to get the struct pnp_resource, not just
    the struct resource, because ISAPNP needs to store the register
    index in the pnp_resource.
    
    I don't like pnp_get_pnp_resource() and hope that it is temporary,
    but we need it for a little while.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 784f01d5bdeae7d7005ede17305306b042ba2617
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:30 2008 -0600

    PNP: add struct pnp_resource
    
    This patch adds a "struct pnp_resource".  This currently
    contains only a struct resource, but we will soon need
    additional PNP-specific information.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06cb58a6eb0b689f95a6c055cfc400fd30c500c6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:29 2008 -0600

    PNP: remove pnp_resource_table references from resource decoders
    
    This removes a few more references to the pnp_resource_table.
    No functional change.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 02d83b5da3efa3c278ce87db2637f3dd6837166d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:28 2008 -0600

    PNP: make pnp_resource_table private to PNP core
    
    There are no remaining references to the PNP_MAX_* constants or
    the pnp_resource_table structure outside of the PNP core.  Make
    them private to the PNP core.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8766ad0ce8621aa6f0e4a91ef355509cc3364d5b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:27 2008 -0600

    rtc: dont reference pnp_resource_table directly
    
    pnp_resource_table is going away soon, so use the more
    generic public interfaces instead.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95ab3669f7830682c7762e9c305a0c1dd44454cc
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:26 2008 -0600

    PNP: remove PNP_MAX_* uses
    
    Remove some PNP_MAX_* uses.  The pnp_resource_table isn't
    dynamic yet, but with pnp_get_resource(), we can start moving
    away from the table size constants.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f6505fef18644557f732468c1f22f84560d8a819
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:25 2008 -0600

    PNP: convert assign, interface to use pnp_get_resource(), not pnp_resource_table
    
    This removes more direct references to pnp_resource_table from the
    pnp_assign_resources() path and the /sys user interface path.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7e2cf31f1c97ac14b6d9dc5f1ce9e1e01aef9c18
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:24 2008 -0600

    PNP: convert encoders to use pnp_get_resource(), not pnp_resource_table
    
    This removes more direct references to pnp_resource_table.  This
    path is used when telling a device what resources it should use.
    
    This doesn't convert ISAPNP because ISA needs to know the config
    register index in addition to the resource itself.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit be81b4a4838ce329b9f3978c7fc007b047c23722
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:23 2008 -0600

    PNP: convert resource checks to use pnp_get_resource(), not pnp_resource_table
    
    This removes more direct references to pnp_resource_table.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f5d94ff014cb7e6212f40fc6644f3fd68507df33
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:22 2008 -0600

    PNP: pass resources, not indexes, to pnp_check_port(), et al
    
    The caller already has the struct resource pointer, so no need for
    pnp_check_port(), pnp_check_mem(), etc., to look it up again.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db9eaeab3e7ab72d773820820f1ba33960ad24c4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:21 2008 -0600

    PNP: check for conflicts with all resources, not just earlier ones
    
    This patch removes a use of "idx" in pnp_check_port() and similar
    functions, in preparation for replacing idx with a pointer to the
    resource itself.
    
    I split this out because it changes the behavior slightly: we used
    to check for conflicts only with earlier resources, e.g., we checked
    resource 2 against resources 0 and 1 but not against 3, 4, etc.  Now
    we will check against all resources except 2.
    
    Since resources are assigned in ascending order, the old behavior
    was probably safe, but I don't like to depend on that ordering.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 470feb113a23de365b6051efde0d69de86d9d2f8
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:20 2008 -0600

    PNP: reduce redundancy in pnp_set_current_resources()
    
    Use a temporary "res" pointer to replace repeated lookups in
    the pnp resource tables.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 30c016a0c8d2aae10be6a87bb98f0e85db8b09d5
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:19 2008 -0600

    PNP: reduce redundancy in pnp_check_port() and others
    
    Use a temporary "res" pointer to replace repeated lookups in
    the pnp resource tables.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 28ccffcf028777e830cbdc30bc54ba8a37e2fc23
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:18 2008 -0600

    PNP: reduce redundancy in pnp_assign_port() and others
    
    Use a temporary "res" pointer to replace repeated lookups in
    the pnp resource tables.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ecfa935a2f7ef89543608f3ca05340c158c9a236
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:17 2008 -0600

    PNP: use conventional "i" for loop indices
    
    Cosmetic only: just use "i" instead of "tmp".
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13575e81bb38fc797a5513ad1bd8e6fda17439b8
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:16 2008 -0600

    PNP: convert resource accessors to use pnp_get_resource(), not pnp_resource_table
    
    This removes more direct references to pnp_resource_table.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53052feb6ddd05cb2b5c6e89fb489bf83bbb6803
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:15 2008 -0600

    PNP: remove pnp_mem_flags() as an lvalue
    
    A future change will change pnp_mem_flags() from a "#define that
    simplifies to an lvalue" to "an inline function that returns the
    flags value."
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b90eca0a61ebd010036242e29610bc6a909e3f19
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:14 2008 -0600

    PNP: add pnp_get_resource() interface
    
    This adds a pnp_get_resource() that works the same way as
    platform_get_resource().  This will enable us to consolidate
    many pnp_resource_table references in one place, which will
    make it easier to make the table dynamic.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d948a8daa059cf5b3e7f002e7b92acf00fc70c49
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:13 2008 -0600

    PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
    
    Move the common part of pnp_init_resource_table() and
    pnp_clean_resource_table() into a new pnp_init_resource().
    This reduces a little code duplication and will be
    useful later to initialize an individual resource.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit af11cb2d521f9d7e10c565bafe8f2358772baa65
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:12 2008 -0600

    PNP: use dev_printk when possible
    
    Use dev_printk() when possible for more informative error messages.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2cd1393098073426256cb4543c897f8c340d0b93
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:11 2008 -0600

    PNP: remove unused interfaces using pnp_resource_table
    
    Rene Herman <rene.herman@gmail.com> recently removed the only in-tree
    driver uses of:
    
        pnp_init_resource_table()
        pnp_manual_config_dev()
        pnp_resource_change()
    
    in this change:
    
        http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=109c53f840e551d6e99ecfd8b0131a968332c89f
    
    These are no longer used in the PNP core either, so we can just remove
    them completely.
    
    It's possible that there are out-of-tree drivers that use these
    interfaces.  They should be changed to either (1) use PNP quirks
    to work around broken hardware or firmware, or (2) use the sysfs
    interfaces to control resource usage from userspace.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6969c7ed558cf5e9eff01734be0174a296938092
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:10 2008 -0600

    PNP: remove pnp_resource_table from internal pnp_clean_resource_table interface
    
    This changes pnp_clean_resource_table() to take a pnp_dev pointer
    rather than a pnp_resource_table pointer.  This reduces the visibility
    of pnp_resource_table and removes an opportunity for error in the
    caller.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f44900020926b2cb06b87f0f52643d6285514fc3
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:09 2008 -0600

    PNP: add pnp_init_resources(struct pnp_dev *) interface
    
    Add pnp_init_resources(struct pnp_dev *) to replace
    pnp_init_resource_table(), which takes a pointer to the
    pnp_resource_table itself.  Passing only the pnp_dev * reduces
    the possibility for error in the caller and removes the
    pnp_resource_table implementation detail from the interface.
    
    Even though pnp_init_resource_table() is exported, I did not
    export pnp_init_resources() because it is used only by the PNP
    core.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 81b5c75f0ed22a93c3da00650d0898eec56e1d62
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:08 2008 -0600

    PNP: add debug when assigning PNP resources
    
    This patch adds code to dump PNP resources before and after
    assigning resources and before writing them to the device.
    
    This is enabled by CONFIG_PNP_DEBUG=y.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 72dcc883d8e5b59105e75ee5265442e458740575
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:07 2008 -0600

    PNP: add debug output to encoders
    
    Add debug output to encoders (enabled by CONFIG_PNP_DEBUG).  This
    uses dev_printk, so I had to add pnp_dev arguments at the same time.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4ab55d8d4f7b910c4c60e0f8ff70d0dfdd484f02
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:06 2008 -0600

    PNP: remove more pnp_resource_table arguments
    
    Stop passing around struct pnp_resource_table pointers.  In most cases,
    the caller doesn't need to know how the resources are stored inside
    the struct pnp_dev.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 59284cb4099411bc6f4915a5a4cb76414440c447
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:05 2008 -0600

    PNP: remove pnp_resource_table from internal get/set interfaces
    
    When we call protocol->get() and protocol->set() methods, we currently
    supply pointers to both the pnp_dev and the pnp_resource_table even
    though the pnp_resource_table should always be the one associated with
    the pnp_dev.
    
    This removes the pnp_resource_table arguments to make it clear that
    these methods only operate on the specified pnp_dev.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1caf06ccfd3a4efd4b489f89bcdabd2362f31d0
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:04 2008 -0600

    PNP: add debug output to option registration
    
    Add debug output to resource option registration functions (enabled
    by CONFIG_PNP_DEBUG).  This uses dev_printk, so I had to add pnp_dev
    arguments at the same time.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cdef6254e17e98f1071ce1bfc8f2a87997c855d0
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:03 2008 -0600

    PNPACPI: pass pnp_dev instead of acpi_handle
    
    Pass the pnp_dev pointer when possible instead of the acpi_handle.
    This allows better error messages and reduces the chance of error
    in the caller.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cd7ec927d9cd3d2001cbbdce872bd73f6e49c986
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:02 2008 -0600

    PNPACPI: extend irq_flags() to set IORESOURCE_IRQ_SHAREABLE when appropriate
    
    This simplifies IRQ resource parsing slightly by computing all the
    IORESOURCE_IRQ_* flags at the same time.
    
    This also keeps track of shareability information when parsing options
    from _PRS.  Previously we ignored shareability in _PRS.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bb84b41d1a1e3ad1ebe7f91a7c97d3b6ca242e9d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:01 2008 -0600

    PNPACPI: hoist dma_flags() out of pnpacpi_parse_allocated_dmaresource()
    
    Hoist dma_flags() out of pnpacpi_parse_allocated_dmaresource() into its
    caller.  This makes pnpacpi_parse_allocated_dmaresource() more similar
    to pnpbios_parse_allocated_dmaresource().
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9570a20e9da282721afc6885dbeaa1b9c1e7ff4d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:00 2008 -0600

    PNPACPI: use temporaries to reduce repetition
    
    No functional change, just fewer words and fewer chances for
    transcription errors.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f7e8466a045c690002c1926e695ae312dd73bb4a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:59 2008 -0600

    PNPACPI: pnpacpi_encode_ext_irq() wrongly set "irq" instead of "extended_irq"
    
    pnpacpi_encode_ext_irq() should set resource->data.extended_irq, not
    resource->data.irq.
    
    This has been wrong since at least 2.6.12.  I haven't seen any bug
    reports, but it's clearly incorrect.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6bf2aab24a5dc26bf8274c4b9dbbed8ca99ae82c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:58 2008 -0600

    PNP: add pnp_alloc_card()
    
    Add pnp_alloc_card() to allocate a struct pnp_card and fill in the
    protocol, instance number, and initial PNP ID.  Now it is always
    valid to use dev_printk() on any pnp_card pointer.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 068076d5517009654376ceda75ff44af0feb9b1d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:57 2008 -0600

    ISAPNP: pull pnp_add_card_id() out of isapnp_parse_card_id()
    
    Split the pnp_add_card_id() part from the PNPID conversion part so we
    can move the initial add_id() into the pnp_card allocation.
    
    This makes the PNPID conversion generic so we can use the same
    one for both devices and cards.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e436675f2a09ea389c1844507658f304924a2eca
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:56 2008 -0600

    PNP: change pnp_add_card_id() to allocate its own pnp_id structures
    
    This moves some of the pnp_id knowledge out of the backends and into
    the PNP core.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 048825deea5f261335b5202cd1114c53a3a21ae7
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:55 2008 -0600

    PNP: make pnp_add_card_id() internal to PNP core
    
    pnp_add_card_id() doesn't need to be exposed outside the PNP core, so
    move the declaration to an internal header file.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bda1e4e5a3d976046378cd495a63e1ee0847deec
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:54 2008 -0600

    PNP: add pnp_alloc_dev()
    
    Add pnp_alloc_dev() to allocate a struct pnp_dev and fill in the
    protocol, instance number, and initial PNP ID.  Now it is always
    valid to use dev_printk() on any pnp_dev pointer.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25eb846189d20db4114cebf14fee96d69bef4667
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:53 2008 -0600

    PNP: add pnp_eisa_id_to_string()
    
    Converting the EISA ID to a string is messy and error-prone, and
    we might as well use the same code for ISAPNP and PNPBIOS.
    
    PNPACPI uses the conversion done by the ACPI core with
    acpi_ex_eisa_id_to_string().
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 772defc6292bae8b6db298476d1dabd22a99492b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:52 2008 -0600

    PNP: change pnp_add_id() to allocate its own pnp_id structures
    
    This moves some of the pnp_id knowledge out of the backends and into
    the PNP core.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1692b27bf37826f85f9c12f8468848885643532a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:51 2008 -0600

    PNP: make pnp_add_id() internal to PNP core
    
    pnp_add_id() doesn't need to be exposed outside the PNP core, so
    move the declaration to an internal header file.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4a490498643ea37520c315769b293085b6018ddd
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:50 2008 -0600

    PNPACPI: continue after _CRS and _PRS errors
    
    Keep going and register the device even if we have trouble parsing
    _CRS or _PRS.  A parsing problem might mean we ignore some resources
    the device is using, or we might not be able to change its resources.
    But we should still take note of anything we *could* parse correctly.
    
    Also remove reference to dev_id because I plan to remove it soon.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ca0e8b6fd29819891c874b86ff286987c5bfdc21
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:49 2008 -0600

    ISAPNP: move config register addresses out of isapnp.h
    
    These are used only in drivers/pnp/isapnp/core.c, so no need to
    expose them to the world.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1bd17e63a068db6f464925a79b1cc4b27a8b1af9
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:33:48 2008 -0600

    PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is set
    
    Turn on -DDEBUG in CFLAGS when CONFIG_PNP_DEBUG=y.  This makes
    dev_dbg() do what you expect.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-by: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff16cab69b6ed621686cf342306785175775152d
Author: Len Brown <len.brown@intel.com>
Date:   Tue Apr 29 03:12:17 2008 -0400

    thermal: re-name thermal.c to thermal_sys.c
    
    thermal_sys was already the name of the resulting module,
    and it is built from  this one source file.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 76ecb4f2d7ea5c3aac8970b9529775316507c6d2
Author: Zhang, Rui <rui.zhang@intel.com>
Date:   Thu Apr 10 16:20:23 2008 +0800

    ACPI: update thermal temperature
    
    Fix the problem that thermal_get_temp returns the cached value,
    which causes the temperature in generic thermal never updates.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9030062f3d61f87c1e787b3aa134fa3a8e4b2d25
Author: Julia Lawall <julia@diku.dk>
Date:   Fri Apr 11 10:09:24 2008 +0800

    ACPI: elide a non-zero test on a result that is never 0
    
    thermal_cooling_device_register used to return NULL if THERMAL is "n".
    As the ACPI fan, processor and video drivers SELECT the generic
    thermal in PATCH 01, this is not a problem any more.
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9ae71078b2c8657c0e8de808b76b76049806906
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Apr 22 08:50:09 2008 +0800

    thermal: update the documentation
    
    Update the documentation for the thermal driver hwmon sys I/F.
    
    Change the ACPI thermal zone type to be consistent with hwmon.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e68b16abd91dca91e35ea47537ef8a1b7ad72841
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Apr 21 16:07:52 2008 +0800

    thermal: add hwmon sysfs I/F
    
    Add hwmon sys I/F for generic thermal driver.
    
    Note: we have one hwmon class device for EACH TYPE of the thermal zone device.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ec732ff80b7e8a9096666f78ae584d3b393bc84
Author: Zhang, Rui <rui.zhang@intel.com>
Date:   Thu Apr 10 16:13:10 2008 +0800

    thermal: add new get_crit_temp callback
    
    Add a new callback so that the generic thermal can get
    the critical trip point info of a thermal zone,
    which is needed for building the tempX_crit hwmon sysfs attribute.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 63c4ec905d63834a97ec7dbbf0a2ec89ef5872be
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Apr 21 16:07:13 2008 +0800

    thermal: add the support for building the generic thermal as a module
    
    Build the generic thermal driver as module "thermal_sys".
    
    Make ACPI thermal, video, processor and fan SELECT the generic
    thermal driver, as these drivers rely on it to build the sysfs I/F.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f67a0695dc389247c05041b05d2a2b06fc102a3
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Apr 29 02:34:42 2008 -0400

    flush kacpi_notify_wq before removing notify handler
    
    Flush kacpi_notify_wq before notify handler is removed,
    this can fix a bug which the deferred notify handler is executed
    after the notify_handler has already been removed.
    http://bugzilla.kernel.org/show_bug.cgi?id=9772
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0fda6b403f0eca66ad8a7c946b3996e359100443
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Wed Apr 9 21:31:46 2008 -0400

    2.6.25 regression: powertop says 120K wakeups/sec
    
    Patch to fix huge number of wakeups reported due to recent changes in
    processor_idle.c. The problem was that the entry_method determination was
    broken due to one of the recent commits (bc71bec91f987) causing
    C1 entry to not to go to halt.
    
    http://lkml.org/lkml/2008/3/22/124
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 204470272c3b055b352d5f127d5d5c7dce5fa597
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Mar 11 17:17:08 2008 -0400

    ACPI: GPE enabling should happen after EC installation
    
    GPE could try to access EC region, so should not be enabled before
    EC is installed
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9916
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75a44ce00b312f57264f42a0a985d17cd9994b98
Author: Len Brown <len.brown@intel.com>
Date:   Wed Apr 23 23:00:13 2008 -0400

    ACPICA: update Intel copyright
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cca97b81564c5edbc8700ebb64fc2b4e13dfa51f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Fix for some local named nodes not marked temporary and to disallow duplicates
    
    Fixed a problem with the CreateField, CreateXXXField (Bit, Byte,
    Word, Dword, Qword), Field, BankField, and IndexField operators
    when invoked from inside an executing control method. In this case,
    these operators created namespace nodes that were incorrectly
    left marked as permanent nodes instead of temporary nodes. This
    could cause a problem if there is race condition between an
    exiting control method and a running namespace walk. (Reported
    by Linn Crosetto). Fixed a problem where the CreateField and
    CreateXXXField operators would incorrectly allow duplicate names
    (the name of the field) with no exception generated.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66e2c0bcc5f6b8454d9091f6ba9ef4090abca4fd
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Update version to 20080321
    
    Update version to 20080321.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 514d18d79b1da052ed4553ceec1f7e1197a5bb51
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Update for new Notify values
    
    Implemented several changes for Notify handling: Added support
    for new Notify values (ACPI 2.0+) and improved the Notify debug
    output. Notify on PowerResource objects is no longer allowed,
    as per the ACPI specification.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66d3ca9ea28e1b3d591083772fd797b9b46410b8
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Fixes for size of StartDependent resource descriptor
    
    Fixed a couple of size calculation issues with the variable-length
    Start Dependent resource descriptor.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8846574ed4a81be319bf68728f9cca9af595afd
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Updates for Debug object output
    
    Implemented several improvements for the output of the ASL "Debug"
    object to clarify and keep all data for a given object on one
    output line.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cd0b2248241f4146152fb04a6bf4bccb6ce0478a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fixes for external Reference Objects
    
    All Reference Objects returned via the AcpiEvaluteObject interface
    are now marked as type "REFERENCE" instead of "ANY". The type ANY
    is now reservered for NULL objects - either NULL package elements
    or unresolved named references.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a5bb9964512c5313af19310c6a3002ec54f7336
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix to handle NULL package elements correctly
    
    Fixed problem where NULL package elements were not returned to
    the AcpiEvaluateObject interface correctly. Instead of returning a
    NULL ACPI_OBJECT package element, the element was simply ignored,
    potentially causing a buffer overflow and/or confusing the caller
    who expected a fixed number of elements.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10132
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ba7d25c70699cdd3e06fc049d8884ee54b9d5db
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix for extraneous debug message for packages
    
    Fixed a problem where an extraneous debug message was produced for
    package objects (when debugging enabled). The message "Package
    List length larger than NumElements count" is now produced in
    the correct case, and is also an error message rather than a
    debug message. Added a debug message for the opposite case, where
    NumElements is larger than the Package List, and the package has
    been padded out with NULL elements.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0144a2929620d9682bc4b0c6274ef03e417f49a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Update ACPICA version to 20080213
    
    Update ACPICA version to 20080213.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 24a3157a90ddf851a0880c0b8963bc43481cd85b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix for possible error when packages/buffers are passed to methods externally
    
    Fixed a problem where buffer and package objects passed as
    arguments to a control method via the external AcpiEvaluateObject
    interface could cause an AE_AML_INTERNAL exception depending on the
    order and type of operators executed by the target control method.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a3df4dadd446c0d7195f2bbe86dd5174426d8090
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Update behavior of CopyObject to match ACPI spec
    
    Fixed a problem where a CopyObject to RegionField, BankField, and
    IndexField objects did not perform an implicit conversion as it
    should. These types must retain their initial type permanently as
    per the ACPI specification. However, a CopyObject to all other
    object types should not perform an implicit conversion, as per
    the ACPI specification.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=388
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d5b285da1893b90507b081664ac27f1a8a3dc5b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix for resource descriptor optimization issues for _CRS/_SRC
    
    Fixed a problem where resource descriptor size optimization
    could cause a problem when a _CRS resource template is passed
    to a _SRS method. The _SRS resource template must use the same
    descriptors (with the same size) as returned from _CRS. This
    change affects the following resource descriptors: IRQ/IRQNoFlags
    and StartDependendentFn/StartDependentFnNoPri.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9487
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fa347770a8a9cb3568600380ce4b5c041b3ac0b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Disassembler support for new ACPI tables
    
    Implemented full disassembler support for the following new ACPI
    tables: BERT, EINJ, and ERST. Partial disassembler support for
    the complicated HEST table. These tables support the Windows
    Hardware Error Architecture (WHEA).
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7823665eccdc7e230d0a904c6ec01d5c70ee099b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fix for ACPI_HIDWORD macro
    
    Fixed a regression introduced in version 20071114. The ACPI_HIDWORD
    macro was inadvertently changed to return a 16-bit value instead of
    a 32-bit value, truncating the upper Dword of a 64-bit value. This
    macro is only used to display debug output, so no incorrect
    calculations were made.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1dd9096fef08642eb509fbf2a40b3c7734dce1c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Added new error messages
    
    New messages for the 2 AE_SUPPORT cases.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 507f046c4dd17e9c94b5130ba184f8da90504685
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Add va_end statements as appropriate
    
    Added missing va_end statements that should correspond with each
    va_start statement.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c49c235774002708bd0da1c28c570073ebd963b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Update version to 20080123
    
    Update version to 20080123.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc7a36ab74e09da7bb63e2477b0740ac992b290e
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fixes for Unload and DDBHandles
    
    Implemented support for the use of DDBHandles as an Indexed
    Reference, as per the ACPI spec.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=486.
    
    Implemented support for UserTerm (Method invocation) for the Unload operator
    as per the ACPI spec.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=580
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6f4a4511e65942b93ded60d746094ec0e58ed8e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Bulletproof disassembler for bad ACPI tables
    
    Fixed a problem with the disassembler where invalid ACPI tables
    could cause faults or infinite loops.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 970d9c9ec313daa1b41db0f8bdd1ca8cc2903822
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Include file support for new ACPI tables
    
    Implemented header file support for new ACPI tables - BERT, ERST,
    EINJ, HEST, IBFT, UEFI, WDAT. Disassembler support is forthcoming.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 47c08729bf1c60d522d020a7f8bc15d1c70e6ecb
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fix for LoadTable operator, input strings
    
    Fixed a problem with the LoadTable operator where the OemId
    and OemTableId input strings could cause unexpected failures if
    they were shorter than the maximum lengths allowed.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=576
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 200cce6a75061a3bf8d2e6b27c5cdcc7730893f1
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fix for Load operator
    
    Fixed a problem with the Load operator where an exception was not
    returned in the case where the table is already loaded.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=463
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9accd46459b8c068540451fdab07dbfcefaf7280
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Methods now implicitly return 0 in slack mode
    
    Implemented an enhancement to the interpreter "slack mode". In the
    absence of an explicit return or an implicitly returned object from
    the last executed opcode, a control method will now implicitly
    return an integer of value 0 for Microsoft compatibility.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=392
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8246934b7cf99d1f0c053d57890775e5d0df9c33
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fix for SizeOf when used with Buffers and Packages
    
    Fixed a problem with the SizeOf operator when used with Package
    and Buffer objects. These objects have deferred execution for some
    arguments, and the execution is now completed before the SizeOf is
    executed. This problem caused unexpected AE_PACKAGE_LIMIT errors
    on some systems.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9558
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c351f2dd542a3980e96cf128e06d19f784c5ea3e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Update version to 20071219
    
    Update version to 20071219.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ef805d956320ffa36d068673d5c5eb2a7d13209b
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Implemented full argument resolution support for the BankValue argument to BankField
    
    Previously, only constants were supported, now any TermArg may
    be used.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=387
    http://www.acpica.org/bugzilla/show_bug.cgi?id=393
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57345ee6b807d32e5eecf724a463378b80cc261c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Undo accidental checkin of not-fully-tested mutex changes
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 941f48bb465b0b291f8435b1e3de95b0975b84bc
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Implemented full support for deferred execution for the TermArg string arguments for DataTableRegion
    
    This enables forward references and full operand resolution for
    the three string arguments. Similar to OperationRegion deferred
    argument execution.)
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=430
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9aa6169f471771324b476a90d9392daa06d63a2d
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with Index Fields where the Index register was incorrectly limited to a maximum of 32 bits
    
    Now any size may be used.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 549f46044e1e207a2cbfdfb3f9a0d3fd5fd4105e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with AcpiGetDevices where the search of a branch of the device tree could be terminated prematurely
    
    In accordance with the ACPI specification, the search is terminated
    if a device is both not present and not functional (instead of
    just not present.) Yakui Zhao.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a2e71a82375aa2aef571d5fa9064ba67c8856a5
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Update version to 20071114
    
    Update version to 20071114.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1cb2ef6606e0abd8565f66b5f95267de1b390694
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with CopyObject used in conjunction with the Index operator
    
    The reference was incorrectly dereferenced before the copy. The
    reference is now correctly copied.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5391
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5bcc811f78f294e7be8a0721b3fb513028c5af4
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with Index references passed as method arguments
    
    References passed as arguments to control methods were dereferenced
    immediately (before control was passed to the called method). The
    references are now correctly passed directly to the called
    method.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5389
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1f549a240ccb2755066587e1e6ef9f74f485a46a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Fixed a problem with FromBCD and ToBCD with some compilers
    
    On some compilers, the ShortDivide function worked incorrectly,
    causing problems with the BCD functions with large input
    values. (Truncation from 64-bit to 32-bit occurred.) Internal
    http://www.acpica.org/bugzilla/show_bug.cgi?id=435
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b160987df7f49ee9c048a43b70ebae613a7e1437
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Fixes a problem with control method references within packages
    
    Completes the package changes started with version 20071019.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f2d69559b31c368cfe3a51607d9cd5e8c0168875
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Cleanup of debug output
    
    Improved output of object dump routine.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7f9f04228eae2cf5adc2ffeb494d4970a8dd8a5
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Cosmetic changes only, no functional changes
    
    Lint changes, fix compiler warnings, etc.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d18c05825c3f2b8933a7fc7f7528881e98deb04
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Cosmetic changes only, no functional changes
    
    Lint changes, fix compiler warnings, etc.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 39adb11e56d8eef6169aeae38f65df26883ff49c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Update version to 20071019
    
    Update version to 20071019.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49718b1741cb74d86eb8b1bd8f52ad6a013b40df
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Added additional parameter validation for LoadTable
    
    Implemented additional parameter validation for the LoadTable
    operator. The length of the input strings SignatureString,
    OemIdString, and OemTableId are now checked for maximum
    lengths.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=582
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe4078af56a7b7f37391712cf188df3202b03776
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Fix for Increment/Decrement operator, incorrect type change
    
    Fixed a problem with the Increment and Decrement operators where
    the type of the target object could be unexpectedly and incorrectly
    changed.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=353
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e41d93c975d403380b7debe05517d630c8e2836
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fixed a memory leak when Device or Thermal objects referenced in packages
    
    Problem introduced in fix for Package references.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f4ac9f91383a0707de559dc8fbca986fc2d302f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for Load/LoadTable to specify load location
    
    Fixed a problem with the Load and LoadTable operators where
    the table location within the namespace was ignored. Instead,
    the table was always loaded into the root or current scope.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8841647de7c4aa3f3ff5b8b8c4a3f042e848ff0
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Add error checks to prevent faults
    
    Added additional error checking to prevent run-time faults.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 98af37fba9b3e601ca4bded51ef51a2be4e8c97b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Add a table checksum verify for Load operator
    
    Added a table checksum verification for the Load operator, in
    the case where the load is from a buffer.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=578
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a13b8460c5b43a68192b599ce437168cc2ff04de
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for memory leak related to DdbHandle objects
    
    Fixed a memory leak where DdbHandle objects were not deleted
    automatically at control method exit.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 61ce421bb761f607b802c268bd8bd6a0c928a661
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix a fault when storing DdbHandle to Debug object
    
    Fixed a problem with the Debug object where a store of a DdbHandle
    reference object to the Debug object could cause a fault.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5eb691805f7ec5960fe9d5d7fc57a7fc3097bbd0
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for fault if Load() fails
    
    Fixed a problem with the Load operator when loading a table from
    a buffer object. The input buffer was prematurely zeroed and/or
    deleted.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=577
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53cf174409a24e8388e1d554d27436275fc81fe7
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for Alias operator to see target child objects
    
    Fixed a problem with the Alias operator when the target of the
    alias is a named ASL operator that opens a new scope -- Scope,
    Device, PowerResource, Processor, and ThermalZone. In these cases,
    any children of the original operator could not be accessed via
    the alias, potentially causing unexpected AE_NOT_FOUND exceptions.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c12a7dde1752f2c40fe170cabff463a0b362720
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: update version number to 20070919
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14808822a9cea782c2e6f8d39e438cc3891f6472
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Fix for namespace lookup problem
    
    Fixed a problem where objects of certain types (Device,
    ThermalZone, Processor, PowerResource) can be not found if they
    are declared and referenced from within the same control method
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=341.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e08e2d2d6efb256aa035e300deb059bb333b6db
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: New interfaces for table event handlers
    
    Designed and implemented new external interfaces to install and
    remove handlers for ACPI table-related events. Current events that
    are defined are LOAD and UNLOAD. These interfaces allow the host to
    track ACPI tables as they are dynamically loaded and unloaded. See
    AcpiInstallTableHandler and AcpiRemoveTableHandler.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 698c0a0c299bd9389522e14dae1aff02070bac25
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Add minimal disassembly support for the SLIC table
    
    SLIC - Software Licensing Description Table.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e20a679b4acf81a419bbe80beddedc988bf3bd51
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Support for iASL - multiple files and wildcards
    
    Implemented support to allow multiple files to be
    compiled/disassembled in a single invocation. This includes
    command line wildcard support for both the Windows and Unix
    versions of the compiler. This feature simplifies the disassembly
    and compilation of multiple ACPI tables in a single directory.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6deb65dd9d66ff70fa8f8665690295a1126f801a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Updated error message for dynamic method serialization
    
    Added more information to make the message clearer.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5cc1b9b42663878330a4cc1d8020bb9289c46066
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Update version to 20070508
    
    Update version to 20070508.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5567afa5cfa19e45f93c9c8796e46187a2d12f4
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Fix for update of the Global Lock Handle
    
    Fixed a problem where the global lock handle was not properly
    updated if a thread that acquired the global lock via
    executing AML code then attempted to acquire the lock via the
    AcpiAcquireGlobalLock interface.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 235eebbdb501261e9960deb2a9a3459af44ec0ea
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Update version to 20070320
    
    pdate version to 20070320
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91d02132fea3a60d3db7bd72933e38e36cd9e4c7
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Fix for package reference counts
    
    Prevents infinite loop of 'Large Reference Count' messages in
    aslts-bdemo-b286 test.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 422f4f90a23437e3e9de31eab5feb2a13f0cbb38
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Increase maximum buffer size dumped to screen in buffer object dump
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f02e9fa1ceee045f7d5c53d475032815752a2510
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Misc fixes for recent global lock code update
    
    Fixes as a result of running full validation test suite.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4df451a1055d97726ab890249bc3f941906fa75
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Removed obsolete ACPI_NO_INTEGER64_SUPPORT define
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a69c77c72094bfda1ed02336ec9a1bae186fd2fc
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Removed extraneous code
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91e38d10b2b49b8a200111baa7714c4a7e658a4c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Update comments for acquire/release mutex interfaces
    
    pdate comments for acquire/release mutex interfaces
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dbaaa9567543191faa933e78f979f5ff7385918c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Fixed a couple compiler warnings for extra extern statements
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b6e16cf2bacbf328535097fa74f1494b1873c54
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Avoid use of invalid pointers in returned object field
    
    During operand evaluation, ensure that the ReturnObj field is
    cleared on error and only valid pointers are stored there.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e3156b183aa087bc19804b3295c7c1a71f64752
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: changed order of interpretation of operand objects
    
    The interpreter now evaluates operands in the order that they
    appear (both in the
     AML and ASL), instead of in reverse order. This previously
     caused subtle incompatibilities with the MS interpreter as well
     as being non-intuitive.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba886cd4ac957608777fbc8d137f6b9f0450e775
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Update for mutiple global lock acquisitions by same thread
    
    Allows AcpiAcquireGlobalLock external interface to be called
    multiple times by the
     same thread. Allows use of AML fields that require the global
     lock while the running AML is already holding the global lock.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f654ecbfacb47d20e8cac087bbada1b947db846b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:36 2008 +0400

    ACPICA: Removed unused code
    
    Handling of AML_NAME_OP as a Reference.Opcode is no longer
    needed. Kernel bugzilla 2874
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 773069d48030e670cf2032a13ddf16a2e0034df3
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:36 2008 +0400

    ACPICA: Several fixes for internal method result stack
    
    fixes STACK_OVERFLOW exception on nested method calls. internal
    bugzilla 262 and 275.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 99bda83e8b3140b7e81572a5aabc7dedb455b272
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Thu Mar 13 23:54:09 2008 +0100

    MIPS Alchemy: Crapectomy after removal of pm_send_all calls.
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5373fd72577ffc4689ade0a2a1a885293c32c711
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Mar 27 02:00:06 2008 -0400

    PM: arch/x86/kernel/apm_32.c: fix build warning
    
    arch/x86/kernel/apm_32.c:1215: warning: label 'out' defined but not used
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6afe1a1fe8ff83f6ac2726b04665e76ba7b14f3e
Author: Pavel Machek <pavel@suse.cz>
Date:   Thu Mar 13 23:52:49 2008 +0100

    PM: Remove legacy PM
    
    AFAICT pm_send_all is a nop when noone uses pm_register...
    
    Hmm.. can we just force CONFIG_PM_LEGACY=n, and see what happens?
    
    Or maybe this is better idea? It may break build somewhere, but it
    should be easy to fix... (it builds here, i386 and x86-64).
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Acked-by: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 729b2bdbfa19dd9be98dbd49caf2773b3271cc24
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Mar 19 13:26:54 2008 +0800

    ACPI : Disable the device's ability to wake the sleeping system in the boot phase
    
    In some machines some GPE is shared by several ACPI devices, for example:
    sleep button, keyboard, mouse. At the same time one of them is
    non-wake(runtime) device and the other are wake devices. In such case OSPM
    should call the _PSW object to disable the device's ability to
    wake the sleeping system in the boot phase.
    Otherwise there will be ACPI interrupt flood triggered by the GPE input.
    
    The _PSW object is depreciated in ACPI 3.0 and is replaced by _DSW.
    So it is necessary to call _DSW object first. Only when it is not
    present will the _PSW object used.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10224
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ce52ddf58cbc2c40f5f08d37d2217945e4d5adf3
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Mar 24 23:22:36 2008 +0300

    ACPI: EC: Don't delete boot EC
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d9e11206371be370b153264934378a29b6afe9b
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Mar 24 23:22:29 2008 +0300

    ACPI: EC: Use default setup handler
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fa95ba04e6ba11d71e1b87becd054b38faf546c8
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 19:36:02 2008 +0300

    ACPI: EC: Detect irq storm
    
    Problem seems to be that hw fails to clear GPE after we service it and write 1
    into corresponding bit. Thus, as soon as we get interrupts enabled again, we
    receive a new one. Google gives too many results for "acer interrupt storm" for
    this being one-broken-machine case.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9998
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 223883b7aafa02410ed2e571d6032c876d0b23b8
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 17:07:21 2008 +0300

    ACPI: EC: Switch off GPE mode during suspend/resume
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b77d81b2678950077088956da4638c26853389fc
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 17:07:15 2008 +0300

    ACPI: EC: Replace broken controller workarounds with poll mode.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dc0e8490fe884a9378b8ee04a5b5f905f06f4633
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 17:07:09 2008 +0300

    ACPI: EC: Improve debug output
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 845625cdcb17119d5f6c5c8dbe586f2f36e8008a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 17:07:03 2008 +0300

    ACPI: EC: Add poll timer
    
    If we can not use interrupt mode of EC for some reason, start polling
    EC for events periodically.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e6e82a3087e6dad619149246082c910623ea9c36
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 17:06:57 2008 +0300

    ACPI: EC: Restore udelay in poll mode
    
    This fixes keyboard event handling on some systems.
    
    Note that this delay was thought unnecessary, and removed
    from linux-2.6.20 with 50c1e1138cb94f6aca0f8555777edbcefe0324e2
    'ACPI: ec: Drop udelay() from poll mode. Loop by reading status field instead.'
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1071695f17daf050638e0bc550db647f8237c3bb
Author: David Brownell <david-b@pacbell.net>
Date:   Fri Feb 22 21:54:24 2008 -0800

    ACPI: crosslink ACPI and "real" device nodes
    
    Add cross-links between ACPI device and "real" devices in sysfs,
    exposing otherwise-hidden interrelationships between the various
    device nodes for ACPI stuff.  As a representative example, one
    hardware device is exposed as two logical devices (PNP and ACPI):
    
      .../pnp0/00:06/
      .../LNXSYSTM:00/device:00/PNP0A03:00/device:15/PNP0B00:00/
    
    The PNP device gets a "firmware_node" link pointing to the ACPI device,
    and is what a Linux device driver binds to.  The ACPI device has instead
    a "physical_node" link pointing back to the PNP device.  Other firmware
    frameworks, like OpenFirmware, could do the same thing to couple their
    firmware tables to the rest of the system.
    
    (Based on a patch from Zhang Rui.  This version is modified to not
    depend on the patch makig ACPI initialize driver model wakeup flags.)
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Cc: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
