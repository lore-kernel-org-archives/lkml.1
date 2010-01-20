Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158Ab0ATGp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0ATGp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928Ab0ATGpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:45:25 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:53742 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0ATGpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:45:20 -0500
Date: Wed, 20 Jan 2010 01:45:14 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI & driver patches for 2.6.33-rc4
Message-id: <alpine.LFD.2.00.1001200142290.1664@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-2010877674-1263969915=:1664"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2010877674-1263969915=:1664
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

regression fixes, bug fixes, driver specific updates, oh my!

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.33/acpi-release-20091214-2.6.33-rc4.diff.gz

 arch/x86/kernel/acpi/boot.c         |   22 +--
 drivers/acpi/acpi_pad.c             |   37 +++--
 drivers/acpi/bus.c                  |    7 +-
 drivers/acpi/ec.c                   |  126 ++++++++++------
 drivers/acpi/pci_link.c             |    2 +-
 drivers/acpi/pci_root.c             |    2 +-
 drivers/acpi/power.c                |    2 +-
 drivers/acpi/power_meter.c          |    4 +-
 drivers/acpi/processor_idle.c       |   64 +++-----
 drivers/acpi/processor_pdc.c        |   32 ++++-
 drivers/acpi/processor_thermal.c    |    3 +-
 drivers/acpi/sbs.c                  |    3 +
 drivers/acpi/sbshc.c                |    2 +-
 drivers/acpi/video.c                |   43 +++++
 drivers/platform/x86/Kconfig        |    1 +
 drivers/platform/x86/eeepc-laptop.c |  298 +++++++++++++++++++----------------
 drivers/platform/x86/sony-laptop.c  |    9 +-
 include/acpi/platform/aclinux.h     |    2 +-
 include/linux/acpi.h                |    6 +-
 19 files changed, 396 insertions(+), 269 deletions(-)

through these commits:

Alan Jenkins (1):
      eeepc-laptop: disable cpu speed control on EeePC 701

Alex Chiang (1):
      ACPI: processor: restrict early _PDC to opt-in platforms

Alexey Starikovskiy (3):
      ACPI: EC: Accelerate query execution
      ACPI: SBS: Move SBS HC callback to faster Notify queue
      ACPI: EC: Add wait for irq storm

Chen Gong (1):
      acpi_pad: fix error checks

Corentin Chary (3):
      eeepc-laptop: dmi blacklist to disable pci hotplug code
      eeepc-laptop: add hotplug_disable parameter
      eeepc-laptop: disable wireless hotplug for 1201N

Darren Jenkins (1):
      ACPI: power_meter: remove double kfree()

Dmitry Torokhov (2):
      eeepc-laptop: switch to using sparse keymap library
      sony-laptop - fix using of uninitialized variable

H Hartley Sweeten (1):
      ACPI: Remove unnecessary cast.

Len Brown (4):
      x86, ACPI: delete acpi_boot_table_init() return value
      ACPI: enable C2 and Turbo-mode on Nehalem notebooks on A/C
      ACPI: allow C3 > 1000usec
      ACPI: delete acpi_processor_power_verify_c2()

Márton Németh (1):
      acpi: make ACPI device id constant

Rakib Mullick (1):
      ACPI: Fix unused variable warning in sbs.c

Tony Luck (1):
      ACPI: Fix section mismatch error for acpi_early_processor_set_pdc()

Xiaotian Feng (1):
      ACPI: don't cond_resched if irq is disabled

Zhang Rui (1):
      ACPI video: Prune dupe video devices, unless "video.allow_duplicates"

Zhao Yakui (1):
      ACPI: Advertise to BIOS in _OSC: _OST on _PPC changes

with this log:

commit 418521deef3b3dd478a54e4e21d983e010c848f7
Merge: be6066f 2205cbe
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:26:22 2010 -0500

    Merge branch 'bugzilla-14954' into release

commit be6066f34c948ccf4adcc90bbeb1fd335d663303
Merge: b4cdd6a 7f07a60
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:23:27 2010 -0500

    Merge branch 'misc' into release

commit b4cdd6ac4f9b73118542a5c4e796e6b9f287d0dd
Merge: 2984397 6a4e2b7
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:23:18 2010 -0500

    Merge branch 'osc-bugfix' into release

commit 2984397a02caa687fc81f8b8a02244e39e61cf50
Merge: b07f07e 4194e2f
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:23:01 2010 -0500

    Merge branch 'eeepc-laptop' into release

commit b07f07e0c24389c45e42a21b728aaea535b61cba
Merge: 361243f 5407010
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:20:36 2010 -0500

    Merge branch 'ec' into release

commit 361243fd62f22abd6c905f59655e87b062434f71
Merge: 49897de d22edd2
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:15:21 2010 -0500

    Merge branch 'bugzilla-15064' into release

commit 49897deeea85beb51f8093bf325e6fdc781f6b43
Merge: 378fa82 a62e8f1
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:14:57 2010 -0500

    Merge branch 'bugzilla-14858' into release

commit 378fa825f63b026ecb8660370298d74678cac319
Merge: 093e296 c084ca7
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:14:50 2010 -0500

    Merge branch 'bugzilla-14483' into release

commit 093e2961fea5b3b1075dce5b0112c676206988da
Merge: 9c6a6b3 c504f8c
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:14:41 2010 -0500

    Merge branch 'bugzilla-13577-video' into release

commit 9c6a6b3cbcbbe39a018aba7f1b2b76e67cba0e9f
Merge: 24bc734 3b8cb42
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 20 01:14:30 2010 -0500

    Merge branch 'acpi-pad' into release

commit d22edd293ff3f1e2d252f164fe2cf744620cb660
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 19 23:29:09 2010 -0500

    ACPI: delete acpi_processor_power_verify_c2()
    
    no functional change -- cleanup only.
    
    acpi_processor_power_verify_c2() was nearly empty due to a previous patch,
    so expand its remains into its one caller and delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6d72c189f6c4292ba1a323e8af24083790529f8
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 19 23:10:04 2010 -0500

    ACPI: allow C3 > 1000usec
    
    Do for C3 what the previous patch did for C2.
    
    The C2 patch was in response to a highly visible
    and multiply reported C-state/turbo failure,
    while this change has no bug report in-hand.
    
    This will enable C3 in Linux on systems where BIOS
    overstates C3 latency in _CST.  It will also enable
    future systems which may actually have C3 > 1000usec.
    
    Linux has always ignored ACPI BIOS C3 with exit latency > 1000 usec,
    and the ACPI spec is clear that is correct FADT-supplied C3.
    
    However, the ACPI spec explicitly states that _CST-supplied C-states
    have no latency limits.
    
    So move the 1000usec C3 test out of the code shared
    by FADT and _CST code-paths, and into the FADT-specific path.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d76b6f6c17572e662f5c99c2023adae92100855
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 19 22:41:14 2010 -0500

    ACPI: enable C2 and Turbo-mode on Nehalem notebooks on A/C
    
    Linux has always ignored ACPI BIOS C2 with exit latency > 100 usec,
    and the ACPI spec is clear that is correct FADT-supplied C2.
    
    However, the ACPI spec explicitly states that _CST-supplied C-states
    have no latency limits.
    
    So move the 100usec C2 test out of the code shared
    by FADT and _CST code-paths, and into the FADT-specific path.
    
    This bug has not been visible until Nehalem, which advertises
    a CPU-C2 worst case exit latency on servers of 205usec.
    That (incorrect) figure is being used by BIOS writers
    on mobile Nehalem systems for the AC configuration.
    Thus, Linux ignores C2 leaving just C1, which is
    saves less power, and also impacts performance
    by preventing the use of turbo mode.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=15064
    
    Tested-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f07a605a3929d2d94dcbad8ccb7d280958d21f9
Author: Darren Jenkins <darrenrjenkins@gmail.com>
Date:   Tue Jan 12 23:37:07 2010 +1100

    ACPI: power_meter: remove double kfree()
    
    resource->domain_devices can be double kfree()'d in a couple of places.
    Fix this by setting num_domain_devices = 0 after the kfree().
    
    Coverity CID: 13356, 13355, 13354
    
    Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
    Acked-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2205cbe8ecaf5f3ab911cef839c94d05ea5b0c76
Author: Alex Chiang <achiang@hp.com>
Date:   Tue Jan 19 16:55:41 2010 -0700

    ACPI: processor: restrict early _PDC to opt-in platforms
    
    Commit 78f1699 (ACPI: processor: call _PDC early) blindly walks
    the namespace and calls _PDC on every processor object it finds.
    
    This change may cause issues on platforms that declare dummy
    values for SSDTs on non-present processors (disabled in MADT).
    When we call _PDC and dynamically attempt to execute the AML
    Load() op on these dummy SSDTs, there's no telling what might
    happen.
    
    Rather than finding every platform that has bogus SSDTs, restrict
    early _PDC calls to platforms that are known to need early
    evaluation of _PDC.
    
    This is a minimal, temporary fix (given the context of the
    current release cycle). A real solution of checking the MADT for
    non-present processors will be written for the next merge window.
    
    References:
    
    	http://bugzilla.kernel.org/show_bug.cgi?id=14710
    	http://bugzilla.kernel.org/show_bug.cgi?id=14954
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c19bdb6126a5e1f43b4a4fc3c4b09c926667e5ef
Author: Rakib Mullick <rakib.mullick@gmail.com>
Date:   Sun Jan 3 19:27:56 2010 +0600

    ACPI: Fix unused variable warning in sbs.c
    
    When CONFIG_ACPI_SYSFS_POWER=n and CONFIG_ACPI_PROCFS_POWER=n, then
    we're warned by the following warning:
    
    drivers/acpi/sbs.c: In function `acpi_battery_remove':
    drivers/acpi/sbs.c:825: warning: unused variable `battery'
    
    Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c97adf9e7bebf17a86b95e2131bf9ba76c4857c7
Author: Márton Németh <nm127@freemail.hu>
Date:   Sun Jan 10 17:15:36 2010 +0100

    acpi: make ACPI device id constant
    
    The ids field of the struct acpi_driver is constant in <linux/acpi/acpi_bus.h>
    so it is worth to make the initialization data also constant.
    
    The semantic match that finds this kind of pattern is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r@
    disable decl_init,const_decl_init;
    identifier I1, I2, x;
    @@
    	struct I1 {
    	  ...
    	  const struct I2 *x;
    	  ...
    	};
    @s@
    identifier r.I1, y;
    identifier r.x, E;
    @@
    	struct I1 y = {
    	  .x = E,
    	};
    @c@
    identifier r.I2;
    identifier s.E;
    @@
    	const struct I2 E[] = ... ;
    @depends on !c@
    identifier r.I2;
    identifier s.E;
    @@
    +	const
    	struct I2 E[] = ...;
    // </smpl>
    
    Signed-off-by: Márton Németh <nm127@freemail.hu>
    Cc: Julia Lawall <julia@diku.dk>
    Cc: cocci@diku.dk
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c14973f93027500301fc40333e16ae49e58923a7
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sun Jan 10 00:15:44 2010 -0800

    sony-laptop - fix using of uninitialized variable
    
    CC [M]  drivers/platform/x86/sony-laptop.o
    drivers/platform/x86/sony-laptop.c: In function 'sony_nc_rfkill_setup':
    drivers/platform/x86/sony-laptop.c:1162: warning: 'i' may be used uninitialized in this function
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a0b73a49ab56fb1e836675c00d6d0d2ba39a714
Author: Luck, Tony <tony.luck@intel.com>
Date:   Mon Dec 28 10:39:23 2009 -0800

    ACPI: Fix section mismatch error for acpi_early_processor_set_pdc()
    
    Alex Chiang introduced acpi_early_processor_set_pdc() in commit:
     ACPI: processor: call _PDC early
     78f1699659963fff97975df44db6d5dbe7218e55
    
    But this results in a section mismatch:
    
    WARNING: drivers/acpi/acpi.o(.text+0xa9c1): Section mismatch in reference from the
    function acpi_early_processor_set_pdc() to the variable .cpuinit.data:processor_idle_dmi_table
    The function acpi_early_processor_set_pdc() references
    the variable __cpuinitdata processor_idle_dmi_table.
    This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata
    annotation or the annotation of processor_idle_dmi_table is wrong.
    
    The only caller of acpi_early_processor_set_pdc() is acpi_bus_init() which
    is an "__init" function. So the correct fix here is to mark
    acpi_early_processor_set_pdc() "__init" too.
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>
    Acked-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4194e2f551a6308e6ab34ac88210bf54858aa7df
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Wed Jan 6 22:07:41 2010 +0100

    eeepc-laptop: disable wireless hotplug for 1201N
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 322a1356be96bcc4b97e8e370f6468c821330077
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Wed Jan 6 22:07:40 2010 +0100

    eeepc-laptop: add hotplug_disable parameter
    
    Some new models need to disable wireless hotplug.
    For the moment, we don't know excactly what models need that,
    except 1005HA.
    Users will be able to use that param as a workaround.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 642e0447cb910ceabae0b4ea6c0cd3449d5c5abb
Author: Dmitry Torokhov <dtor@mail.ru>
Date:   Wed Jan 6 22:07:39 2010 +0100

    eeepc-laptop: switch to using sparse keymap library
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10ae4b5663ff3092553bfbd867e7bd474ce6c553
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Wed Jan 6 22:07:38 2010 +0100

    eeepc-laptop: dmi blacklist to disable pci hotplug code
    
    This is a short term workaround for Eeepc 1005HA.
    
    refs: <http://bugzilla.kernel.org/show_bug.cgi?id=14570>
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit da8ba01deb98f3dc0558b1f5a37e64f40bba7904
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Jan 6 22:07:37 2010 +0100

    eeepc-laptop: disable cpu speed control on EeePC 701
    
    The EeePC 4G ("701") implements CFVS, but it is not supported by the
    pre-installed OS, and the original option to change it in the BIOS
    setup screen was removed in later versions.  Judging by the lack of
    "Super Hybrid Engine" on Asus product pages, this applies to all "701"
    models (4G/4G Surf/2G Surf).
    
    So Asus made a deliberate decision not to support it on this model.
    We have several reports that using it can cause the system to hang [1].
    That said, it does not happen all the time.  Some users do not
    experience it at all (and apparently wish to continue "right-clocking").
    
    Check for the EeePC 701 using DMI.  If met, then disable writes to the
    "cpufv" sysfs attribute and log an explanatory message.
    
    Add a "cpufv_disabled" attribute which allow users to override this
    policy.  Writing to this attribute will log a second message.
    
    The sysfs attribute is more useful than a module option, because it
    makes it easier for userspace scripts to provide consistent behaviour
    (according to user configuration), regardless of whether the kernel
    includes this change.
    
    [1] <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=559578>
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c084ca704a3661bf77690a05bc6bd2c305d87c34
Author: Xiaotian Feng <dfeng@redhat.com>
Date:   Thu Dec 10 19:56:45 2009 +0800

    ACPI: don't cond_resched if irq is disabled
    
    commit 8bd108d adds preemption point after each opcode parse, then
    a sleeping function called from invalid context bug was founded
    during suspend/resume stage. this was fixed in commit abe1dfa by
    don't cond_resched when irq_disabled. But recent commit 138d156 changes
    the behaviour to don't cond_resched when in_atomic. This makes the
    sleeping function called from invalid context bug happen again, which
    is reported in http://lkml.org/lkml/2009/12/1/371.
    
    This patch also fixes http://bugzilla.kernel.org/show_bug.cgi?id=14483
    
    Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
    Reported-and-bisected-by: Justin P. Mattock <justinmattock@gmail.com>
    Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 070a24f4d238612bede515023893b18f494774c4
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Fri Jan 8 11:12:41 2010 -0700

    ACPI: Remove unnecessary cast.
    
    The struct seq_file 'private' member is a void *, the cast is not needed.
    Also, remove an extra whitespace line.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a4e2b7503d1f630bface040cf0f5a7aac1fabdb
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Jan 8 21:29:58 2010 +0800

    ACPI: Advertise to BIOS in _OSC: _OST on _PPC changes
    
    If the BIOS pokes the system-wide OSC bits to see if Linux
    supports evaluating _OST after a _PPC change notification,
    answer yes.
    
    Also, fix an oversight where we neglected to set the OSC
    bit advertising processor aggregator device support
    when acpi-pad is compiled as a module.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 54070101f86ca9a6e9ba243c999d144721ec3db7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Dec 30 15:53:10 2009 +0300

    ACPI: EC: Add wait for irq storm
    
    Merge of poll and irq modes accelerated EC transaction, so
    that keyboard starts to suffer again. Add msleep(1) into
    transaction path for the storm to allow keyboard controller
    to do its job.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14747
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f5347867c5aea94c625246eaff8f7820b0a4cd8a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Dec 30 15:53:03 2009 +0300

    ACPI: SBS: Move SBS HC callback to faster Notify queue
    
    SBS transactions should happen in Notify work queue, to not create
    a dead lock with GPE execution accessing SBS devices.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8558e3943df1c51c3377cb4e8a52ea484d6f357d
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 6 16:11:06 2010 -0500

    x86, ACPI: delete acpi_boot_table_init() return value
    
    cleanup only.
    
    setup_arch(), doesn't care care if ACPI initialization succeeded
    or failed, so delete acpi_boot_table_init()'s return value.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c504f8cb68eb0d6cde53ba043daff8cb34586493
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 30 15:59:23 2009 +0800

    ACPI video: Prune dupe video devices, unless "video.allow_duplicates"
    
    Some buggy BIOS exports multiple ACPI video bus devices for the same
    VGA controller, and multiple backlight control methods as well.
    This messes up the ACPI video backlight control.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13577
    
    With this patch applied, only the FIRST ACPI video bus device
    under a PCI device node is bind to ACPI video driver by default.
    
    If the first ACPI video bus device doesn't work well, we can use
    video.allow_duplicates=1 to go back to the old behavior.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b8cb427e9281790f36e847e46cb1d005a50cec0
Author: Chen Gong <gong.chen@linux.intel.com>
Date:   Mon Dec 14 09:42:28 2009 +0800

    acpi_pad: fix error checks
    
    There are some fixes listed below:
    1. When met a bogus BIOS, the return value of cpu number maybe is
       a negative value so that acpi_pad_pur get an unexpected result.
    2. the return value of function acpi_pad_idle_cpus is useless.
    3. enhance the process of create_power_saving_task/destroy_power_saving_task
    4. Add more error checks when evaluating _PUR object.
    5. one typo fix
    
    Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a62e8f1978f49e52f87a711ff6711b323d4b12ff
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Dec 24 11:34:16 2009 +0300

    ACPI: EC: Accelerate query execution
    
    Split EC query handling into acknowledge and execution phase.
    This allows much smaller pending query lattency and lowers chances
    of EC going "wild" and losing events.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14858
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-2010877674-1263969915=:1664--
