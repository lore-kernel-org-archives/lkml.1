Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbZFORuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbZFORuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZFORuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:50:02 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:41738 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZFORuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:50:00 -0400
Date: Mon, 15 Jun 2009 13:09:12 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull request] ACPICA patches for Linux 2.6.31-rc0
Message-id: <alpine.LFD.2.00.0906151228260.7530@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpica

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.30/acpi-acpica-20090521-2.6.30-rc7.diff.gz

 drivers/acpi/acpica/acevents.h  |    2 +-
 drivers/acpi/acpica/acglobal.h  |    3 -
 drivers/acpi/acpica/aclocal.h   |   12 ++-
 drivers/acpi/acpica/acnamesp.h  |   13 +++-
 drivers/acpi/acpica/amlcode.h   |    2 +-
 drivers/acpi/acpica/dsobject.c  |    5 +-
 drivers/acpi/acpica/dsopcode.c  |   17 +++--
 drivers/acpi/acpica/dswstate.c  |    4 +-
 drivers/acpi/acpica/evregion.c  |   12 ++--
 drivers/acpi/acpica/evxfevnt.c  |    4 +-
 drivers/acpi/acpica/exconfig.c  |  125 ++++++++++++++++++++++++++------
 drivers/acpi/acpica/excreate.c  |    2 +-
 drivers/acpi/acpica/exdump.c    |    6 +-
 drivers/acpi/acpica/exfldio.c   |   20 +++---
 drivers/acpi/acpica/exmutex.c   |   45 +++++++++---
 drivers/acpi/acpica/exstore.c   |    4 +-
 drivers/acpi/acpica/hwregs.c    |    4 +-
 drivers/acpi/acpica/nsalloc.c   |   14 +---
 drivers/acpi/acpica/nsnames.c   |    2 +-
 drivers/acpi/acpica/nsobject.c  |    9 +++
 drivers/acpi/acpica/nspredef.c  |    7 +--
 drivers/acpi/acpica/nssearch.c  |    4 +
 drivers/acpi/acpica/nswalk.c    |   69 ++++++++++++++----
 drivers/acpi/acpica/nsxfname.c  |  150 +++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/nsxfobj.c   |    9 ++-
 drivers/acpi/acpica/rscalc.c    |    5 +-
 drivers/acpi/acpica/rsxface.c   |    8 ++-
 drivers/acpi/acpica/tbfadt.c    |   16 ++---
 drivers/acpi/acpica/tbinstal.c  |    2 +-
 drivers/acpi/acpica/utcopy.c    |   23 ++++++
 drivers/acpi/acpica/utdebug.c   |    8 +-
 drivers/acpi/acpica/utdelete.c  |   21 ++++++
 drivers/acpi/acpica/utmisc.c    |   20 +++---
 drivers/acpi/acpica/utmutex.c   |   26 ++++----
 include/acpi/acpixf.h           |    9 ++-
 include/acpi/actypes.h          |   20 ++----
 include/acpi/platform/acgcc.h   |    4 +
 include/acpi/platform/aclinux.h |   63 ++++++++++-------
 38 files changed, 571 insertions(+), 198 deletions(-)

through these commits:

Alex Chiang (1):
      ACPICA: Eliminate extra call to NsGetParentNode

Bob Moore (22):
      ACPICA: Update error/warning interfaces
      ACPICA: Fix a few warnings for gcc 3.4.4
      ACPICA: Change behavior of object copy for mutex/event objects
      ACPICA: Remove unused global variables
      ACPICA: Fix possible warnings for ACPI_THREAD_ID on 64-bit build
      ACPICA: Cleanup byte/word/dword extraction macros, fix possible warnings
      ACPICA: Fix printf format warnings for 64-bit build
      ACPICA: Fix possible dereference of null pointer
      ACPICA: Miscellaneous lint changes
      ACPICA: Fix miscellaneous warnings under gcc 4+
      ACPICA: Fix implementation of AML BreakPoint operator (break to debugger)
      ACPICA: Linux OSL: cleanup/update/merge
      ACPICA: Update version to 20090422.
      ACPICA: Mutex support: Fix release ordering issue and current sync level
      ACPICA: Fix allowable release order for ASL mutex objects
      ACPICA: Fix DebugObject output for DdbHandle objects
      ACPICA: Additional validation of _PRT packages (resource mgr)
      ACPICA: Simplify and optimize NsGetNextNode function
      ACPICA: Update Load() to use operation region interfaces
      ACPICA: Simplify internal operation region interface
      ACPICA: Disable preservation of SCI enable bit (SCI_EN)
      ACPICA: Update version to 20090521.

Lin Ming (4):
      ACPICA: Fix reference count issues for DdbHandle object
      ACPICA: Invalidate DdbHandle after table unload
      ACPICA: New: AcpiInstallMethod - install a single control method
      ACPICA: Region deletion: Ensure region object is removed from handler list

with this log:

commit d6a1cd4975a5ffaa21a961be04a469519edf50d6
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 11:06:53 2009 +0800

    ACPICA: Update version to 20090521.
    
    Update version number.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1cd843be74ba0dcc6c42db7b11b76d63be149f6
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 11:05:03 2009 +0800

    ACPICA: Disable preservation of SCI enable bit (SCI_EN)
    
    Preserving this bit breaks some machines. Not preserving this bit
    seems to work OK in all cases, even though this goes against the
    ACPI spec.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13289
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3362a6badb4fe75e198885b125b21ccf846861b4
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu May 21 11:03:29 2009 +0800

    ACPICA: Region deletion: Ensure region object is removed from handler list
    
    Prevents a possible fault when a dynamic operation region is
    deleted. ACPICA BZ 507.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=507
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c446eed6187addf9f76ee0028abed32393aef27e
Author: Alex Chiang <achiang@hp.com>
Date:   Thu May 21 10:59:15 2009 +0800

    ACPICA: Eliminate extra call to NsGetParentNode
    
    Was called twice in the same function with the same parameter.
    Alex Chiang.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f5407af3f271ed4cd6655cf30d419d77e0f8bfaa
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:56:52 2009 +0800

    ACPICA: Simplify internal operation region interface
    
    Changed address parameter to a simple offset. This removes the
    need for the caller to access the region object to obtain the
    physical address.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3c59f96081259358d9d5d677f4839c36391806b6
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:51:53 2009 +0800

    ACPICA: Update Load() to use operation region interfaces
    
    Replace memory mapping with region access calls. Now, all region
    accesses go through the region handler as they should.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2f7ddcfcb9c2436896cb339a7ff70245648f033
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu May 21 10:42:09 2009 +0800

    ACPICA: New: AcpiInstallMethod - install a single control method
    
    This interface enables the override or creation of a single
    control method. Useful to repair a bug or install a missing method.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0be6f5a9863b626c19f0be04946c6285cc9db56
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu May 21 10:32:02 2009 +0800

    ACPICA: Invalidate DdbHandle after table unload
    
    Mark the DdbHandle as invalid after the table it refers to is
    unloaded.  This is needed because the handle itself may not be
    deleted after the table unload, depending on whether it has been
    stored in a named object by the caller.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06366c149232f64c89f513f188ccc6783d0e444f
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu May 21 10:29:28 2009 +0800

    ACPICA: Fix reference count issues for DdbHandle object
    
    Fix a problem where the DdbHandle could be prematurely deleted,
    possibly causing a fault.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c725bf93706db976e9de495579ca625d493e809
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:27:51 2009 +0800

    ACPICA: Simplify and optimize NsGetNextNode function
    
    Reduced parameter count and reduced code for this frequently
    used function.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 474caffdc1ab35e9bcb1f88768442e3a4079a10d
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:10:16 2009 +0800

    ACPICA: Additional validation of _PRT packages (resource mgr)
    
    Fixes a possible fault when parsing an ill-formed _PRT package.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a76b7727364ebb77b25983427623757d2c99bbc3
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:06:19 2009 +0800

    ACPICA: Fix DebugObject output for DdbHandle objects
    
    Was putting several extra spaces on the next line.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 315c728887f198d12eb6ec7ef9d88483018c11cb
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:04:33 2009 +0800

    ACPICA: Fix allowable release order for ASL mutex objects
    
    The ACPI 4.0 specification has been changed to make the SyncLevel
    for mutex objects more useful. When releasing a mutex, the
    synclevel of the mutex must now be the same as the current sync
    level. This makes more sense. This change updates the code to
    match the spec.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10a3b461a258f52b17fb8e35edf3625726eca9a8
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 21 10:02:34 2009 +0800

    ACPICA: Mutex support: Fix release ordering issue and current sync level
    
    Fixes a problem where if multiple mutexes of the same sync level
    are acquired but then not released in strict opposite order, the
    current sync level becomes confused and can cause errors.
    ACPICA BZ 471.
    
    http://acpica.org/bugzilla/show_bug.cgi?id=471
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba9e2ae443feb7231d9631ea0f62b63e26cfb9b1
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Apr 24 10:43:43 2009 +0800

    ACPICA: Update version to 20090422.
    
    Version 20090422.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0c437bcca6926b541c738b5c64445654750b365
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 13:39:47 2009 +0800

    ACPICA: Linux OSL: cleanup/update/merge
    
    Merge the OSL with the actual file used by Linux, so that the
    file does not require patching when integrated with Linux. General
    cleanup and some restructuring.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b09ce98a25e467455ecd81354cc18381628be75
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 13:22:38 2009 +0800

    ACPICA: Fix implementation of AML BreakPoint operator (break to debugger)
    
    The AML BreakPoint opcode will now cause a break into the AML
    debugger if it is present/configured. This matches the expected
    behavior per the ACPI specification. Previously, only a message
    was output.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba9c3f550e5792fbce2bbd7a429bf6f6d1f45fda
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 13:13:48 2009 +0800

    ACPICA: Fix miscellaneous warnings under gcc 4+
    
    Some possible warnings with gcc 4+, especially with extended warnings
    enabled
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4c1ebfc65c125b1289144f5815715f238367683
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 13:02:06 2009 +0800

    ACPICA: Miscellaneous lint changes
    
    Unused variables/headers, casting, etc.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 65259094c3e038519a2d8fa6fbc6256f04ad6535
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 12:57:40 2009 +0800

    ACPICA: Fix possible dereference of null pointer
    
    Fix dereference of possibly null pointer "Predefined" in the case
    where the method is not one of the predefined methods.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b21245a85e62ea7eeb5b7562ce98cf8b0aecbd26
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 12:52:51 2009 +0800

    ACPICA: Fix printf format warnings for 64-bit build
    
    Fix warnings caused by size_t and ACPI_SIZE changing to 64 bits.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 35d7c1cfe5262480d3d8e6ccd7e4caf3a9c8ab39
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 12:41:27 2009 +0800

    ACPICA: Cleanup byte/word/dword extraction macros, fix possible warnings
    
    Removed unnecessary masking. For the 64-bit macros, removed
    the structure overlay. Fixes aliasing warnings seen with gcc 4+
    compilers.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10b6575b5d84d21e2eab01df2284288e5fdf7887
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 11:39:10 2009 +0800

    ACPICA: Fix possible warnings for ACPI_THREAD_ID on 64-bit build
    
    Warnings can be generated for printf-like statements that output
    the ACPI_THREAD_ID on 64-bit builds, since this type can expand
    to 64-bits depending on how it is defined. Use the %p format
    specifier to allow the output to automatically expand to 64 bits.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 41bdd8e9809665d6a13e49137661a8f2e5a7dc51
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 10:51:06 2009 +0800

    ACPICA: Remove unused global variables
    
    Remove two unused/obsolete variables.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33a1d461d294722dd15ffe17651bdd48b5763883
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 10:48:57 2009 +0800

    ACPICA: Change behavior of object copy for mutex/event objects
    
    When copying these internal objects, cannot simply copy the
    underlying OS object. A new OS object must be created.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8eb7b2477c4e4fec4788605e4edb5f7acafb59ff
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 10:28:22 2009 +0800

    ACPICA: Fix a few warnings for gcc 3.4.4
    
    Mostly for acpiexec, one in the core subsystem.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b74be6119e9e38390395f08767b7c84de9023b38
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 22 10:20:23 2009 +0800

    ACPICA: Update error/warning interfaces
    
    Moved the module name and line number to the end of the message.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
