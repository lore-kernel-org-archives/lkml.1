Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbXCJFf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbXCJFf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 00:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXCJFf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 00:35:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:57788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXCJFf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 00:35:57 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.21-rc3
Date: Sat, 10 Mar 2007 00:34:01 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100034.03148.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This should delete a good part of the 2.6.21-rc regression list.
This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.21/acpi-release-20070126-2.6.21-rc3.diff.gz

 Documentation/kernel-parameters.txt |    3 
 arch/i386/kernel/acpi/boot.c        |   23 ++++
 arch/ia64/sn/kernel/io_acpi_init.c  |   44 ++++----
 arch/ia64/sn/kernel/setup.c         |    2 
 drivers/acpi/Kconfig                |   12 ++
 drivers/acpi/blacklist.c            |   10 +-
 drivers/acpi/ec.c                   |   40 ++++----
 drivers/acpi/events/evmisc.c        |   25 ++++-
 drivers/acpi/ibm_acpi.c             |   28 +++++
 drivers/acpi/power.c                |   20 +---
 drivers/acpi/resources/rscreate.c   |   25 ++++-
 drivers/acpi/video.c                |   38 +++----
 drivers/ata/libata-acpi.c           |    7 +
 drivers/misc/asus-laptop.c          |    2 
 drivers/misc/sony-laptop.c          |    2 
 drivers/pnp/pnpacpi/rsparser.c      |  120 ++++++++++++++----------
 16 files changed, 271 insertions(+), 130 deletions(-)

through these commits:

Adrian Bunk (1):
      asus-laptop: make code static

Alexey Starikovskiy (2):
      ACPICA: Fix ACPI Global Lock re-entrancy
      ACPI: ec: fix race in status register access

Andrew Morton (1):
      sony-laptop: fix uninitialised variable

Anthony Godshall, Ampro Computers, Inc (1):
      ACPI: make blacklist more verbose

Bernhard Walle (1):
      ACPI: Add kernel-parameters hint that acpi=off doesn't work on IA64.

Henrique de Moraes Holschuh (3):
      ACPI: ibm-acpi: fix initial status of backlight device
      ACPI: ibm-acpi: make ibm-acpi bay support optional
      ACPI: ibm-acpi: improve backlight power handling

John Keller (2):
      ACPI: Altix: cannot register acpi bus driver before bus scan
      ACPI: Altix: reinitialize acpi tables

Julius Volz (1):
      ACPI: video: Fix spelling and grammar mistakes

Konstantin Karasyov (2):
      ACPI: fix S3 fan resume issue
      ACPI: ThinkPad Z60m: usb mouse stops working after suspend to RAM

Kristen Accardi (1):
      libata-acpi: allow _GTF on SATA, but disable on PATA for now

Len Brown (2):
      ACPI: fix Thinkpad 600/600E/600X interrupts
      ACPI: repair nvidia early quirk breakage on x86_64

Michael Karcher (1):
      ACPI: fix parallel port IRQ after resume from S3

Robert P. J. Day (1):
      ACPI: Kconfig: hide ACPI menu when CONFIG_PM=n

Shaohua Li (1):
      ACPI: fix boot hang w/o "noapic" on MSI MS-6390-L

with this log:

commit 63e34ca93a62f472144db60fa3b81111c0d15721
Merge: 51e7fff... 9327f46...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:19:50 2007 -0500

    Pull misc-for-upstream into release branch

commit 51e7fff1c2b763da910db3a875eac5b992df91d9
Merge: bdf3aaf... 9e19721...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:19:25 2007 -0500

    Pull bugzilla-8110 into release branch

commit bdf3aaf9519ddd8a026b5e04e713d2fa673532e5
Merge: b252630... 610a3d0...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:19:19 2007 -0500

    Pull bugzilla-8066 into release branch

commit b2526300ab242dc31f9006dbf9a4de40797571bc
Merge: cb2ebc5... df33c77...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:18:53 2007 -0500

    Pull bugzilla-7907 into release branch

commit cb2ebc59ff52cee770cfd6ba5f23a6cc3c214648
Merge: 3dfb737... 7292576...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:18:46 2007 -0500

    Pull bugzilla-7570 into release branch

commit 3dfb737998c265d3c8a15b931dc4d72335ab8255
Merge: 63be2d9... 2f894ef...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:18:35 2007 -0500

    Pull bugzilla-6859 into release branch

commit 63be2d9305a5865580c6faee2c1eb477c09eac18
Merge: 653351b... 362ea08...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:18:22 2007 -0500

    Pull bugzilla-6316 into release branch

commit 653351b0b9c97d4ec93aed499b542cbcd85309ca
Merge: 5cb69bc... 74586fc...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:18:05 2007 -0500

    Pull bugzilla-5966 into release branch

commit 5cb69bcacea70024252138a9cb4229a142a93389
Merge: c207908... c9bf296...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:17:46 2007 -0500

    Pull ibm into release branch

commit c207908fcc451e31d7fbba31541bd04f93787eb4
Merge: a967e12... 3fd0b2d...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 9 23:17:39 2007 -0500

    Pull altix into release branch

commit 9e197219605513c14d3eae41039ecf1b82d1920d
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 18:29:35 2007 -0500

    ACPI: ec: fix race in status register access
    
    Delay the read of the EC status register until
    after the event that caused it occurs -- otherwise
    it is possible to read and act on stale status that was
    associated with the previous event.
    
    Do this with a perpetually incrementing "event_count" to detect
    when a new event occurs and it is safe to read status.
    
    There is no workaround for polling mode -- it is inherently
    exposed to reading and acting on stale status, since it
    doesn't have an interrupt to tell it the event completed.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8110
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9327f46ee28116b17f15f6505edd90f905908d62
Author: Robert P. J. Day <rpjday@mindspring.com>
Date:   Sun Mar 4 13:17:43 2007 -0500

    ACPI: Kconfig: hide ACPI menu when CONFIG_PM=n
    
    Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 98fb8fe10f4b88170f578d8c33eaa2315d73b4f7
Author: Julius Volz <julius.volz@s2003.tu-chemnitz.de>
Date:   Tue Feb 20 16:38:40 2007 +0100

    ACPI: video: Fix spelling and grammar mistakes
    
    Correct some of the most obvious spelling and grammar
    mistakes in drivers/acpi/video.c (comments and printk output).
    
    Signed-off-by: Julius Volz <juliusrv@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b27b176da6cc83b0f904c7e0aabd9362d70bf70
Author: Anthony Godshall, Ampro Computers, Inc <agodshall@ampro.com>
Date:   Fri Mar 9 21:19:05 2007 -0500

    ACPI: make blacklist more verbose
    
    IMHO, ACPI disabled due to DMI failure or blacklisted year should be noted,
    as is done with other ACPI blacklisting.
    
    This will help people troubleshoot when ACPI isn't working.  Status quo is
    a mysterious "ACPI Disabled" message without explanation on BIOS that
    implements ACPI but not DMI.  This is actually fairly common on embedded
    x86 boards.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f110ef58e6c9bd562999247c5e8a5b8e722fbd11
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Feb 20 01:07:25 2007 +0100

    asus-laptop: make code static
    
    This patch makes some needlessly global code static.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Cc: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit df33c77e3981e71afc8727ee5c432ba1a1bba68c
Author: Kristen Accardi <kristen.c.accardi@intel.com>
Date:   Fri Mar 9 18:15:33 2007 -0500

    libata-acpi: allow _GTF on SATA, but disable on PATA for now
    
    The ACPI specification states, and BIOS implementations depend on,
    _STM being called before _GTF.
    
    SATA does this, but PATA does not.  So for now, simply
    prevent execution of _GTF on PATA devices.  Longer term we
    should implement ACPI support for PATA devices in libata.
    
    Signed-off-by: Kristen Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d7930085c28d295b573f6862ff863ccbb8a580ce
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 8 18:30:25 2007 -0500

    ACPI: repair nvidia early quirk breakage on x86_64
    
    x86_64 nvidia_bugs() broke when we bailed out on not finding the HPET.
    However, the quirk works by checking for not finding the HPET...
    
    Delete the nvidia_hpet_detected flag and simply test for
    not finding the HPET, which is simple to do now that
    acpi_table_parse returns 1 on failure.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 362ea087db9d99bb0cf79479544dfafa9e18c300
Author: Michael Karcher <bugzilla-kernel@mkarcher.dialup.fu-berlin.de>
Date:   Thu Mar 8 23:29:29 2007 -0500

    ACPI: fix parallel port IRQ after resume from S3
    
    The PNPACPI resource flags were broken.
    This would apply to re-enabling a device any-time after boot,
    not just after resume from S3.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=6316
    
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9bf296b6467968ecb9d988e7ed754a19c2e63d9
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 8 05:28:15 2007 -0300

    ACPI: ibm-acpi: improve backlight power handling
    
    Improve the backlight code to emulate as much as possible the power
    management events, as we are unable to really power on or power off the
    backlight.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Acked-by: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f894ef9c8b36a35d80709bedca276d2fc691941
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Mar 8 03:42:42 2007 -0500

    ACPI: fix boot hang w/o "noapic" on MSI MS-6390-L
    
    This is a workaround to handle a BIOS bug where the
    programmer exchanged the name and index fields of
    a _PRT entry.  Apparently this BIOS error does not
    confuse Windows and thus it lurks in the field
    on various machines.
    
    boot with "acpi=strict" to disable this workaround
    
    http://bugzilla.kernel.org/show_bug.cgi?id=6859
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74586fca38109d2fc75daf678635928f64b4ccec
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 8 02:48:30 2007 -0500

    ACPI: fix Thinkpad 600/600E/600X interrupts
    
    The root cause of this bug shows that this machine
    could not possibly run an ACPI-aware OS without a
    model specific workaround.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5966
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff24ba74b6d3befbfbafa142582211b5a6095d45
Author: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
Date:   Wed Mar 7 03:50:11 2007 -0500

    ACPI: ThinkPad Z60m: usb mouse stops working after suspend to RAM
    
    (http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg05270.html):
    
    References : http://lkml.org/lkml/2007/2/21/413
                 http://lkml.org/lkml/2007/2/28/172
    Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
    Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
                 commit 0a6139027f3986162233adc17285151e78b39cac
    
    Do not disable power resources on resume even if there are no devices referencing it.
    
    Signed-off-by: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03d926f82800f32642b32ba547c7a002a371a78f
Author: Bernhard Walle <bwalle@suse.de>
Date:   Tue Mar 6 02:29:44 2007 -0800

    ACPI: Add kernel-parameters hint that acpi=off doesn't work on IA64.
    
    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8607c673bdd593d4ce439a36412a213a8efb282b
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Mar 6 02:29:42 2007 -0800

    sony-laptop: fix uninitialised variable
    
    drivers/misc/sony-laptop.c: In function 'sony_acpi_add':
    drivers/misc/sony-laptop.c:456: warning: 'result' may be used uninitialized in this function
    
    The compiler seems to actually be telling the truth this time.
    
    Cc: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 610a3d069665ba2b27e42c90129ce640c4d6e515
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Wed Mar 7 00:57:30 2007 -0500

    ACPICA: Fix ACPI Global Lock re-entrancy
    
    patch "Delete recursive feature of ACPI Global Lock"
    broke re-entrancy of the Global Lock.
    The common routine to acquire GL is acpi_ev_acquire_global_lock,
    so check for re-entrancy _must_ be there, and not anywhere else.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8066#c9
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fd0b2d9ad7612f249e5516d887ab7c61b24ddb9
Author: John Keller <jpk@sgi.com>
Date:   Wed Feb 28 17:47:27 2007 -0600

    ACPI: Altix: reinitialize acpi tables
    
    To provide compatibilty with SN kernels that do and do not
    have ACPI IO support, the SN PROM must build different
    versions of some ACPI tables based on which kernel is booting.
    As such, the tables may have to change at kernel boot time.
    By default, prior to kernel boot, the PROM builds an empty
    DSDT (header only) and no SSDTs. If an ACPI capable kernel
    boots, the kernel will notify the PROM, at platform setup time,
    and the PROM will build full DSDT and SSDT tables.
    
    With the latest changes to acpi_table_init(), the table lengths
    are saved, and when our PROM changes them, the changes are not seen,
    and the kernel will crash on boot. Because of issues with kexec support,
    we are not able to create the tables prior to acpi_table_init().
    As a result, we are making a second call to acpi_table_init() to
    process the rebuilt DSDT and SSDTs.
    
    Signed-off-by: John Keller <jpk@sgi.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 690b8d9d54941c90af1d43b0cc24903d20386f5b
Author: John Keller <jpk@sgi.com>
Date:   Fri Feb 23 16:24:16 2007 -0600

    ACPI: Altix: cannot register acpi bus driver before bus scan
    
    SN code to initialize the Hub/TIO infrastructure needs to
    execute before bus scanning. This was previously done with
    an early call to acpi_bus_register_driver().  But now that
    ACPI is using the Linux driver model, a driver cannot be registered
    that early. Make changes to have the init routines invoked via
    calls to acpi_get_devices().
    
    Signed-off-by: John Keller <jpk@sgi.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2bc808a8c4821a8ef4e3dc35b8fc577a9d2c6f0d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Feb 21 13:05:38 2007 -0200

    ACPI: ibm-acpi: make ibm-acpi bay support optional
    
    Make ibm-acpi bay support optional at kernel compile time.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit adb005818b71e9476581a1de5742e2f427ac9e2b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Feb 22 16:04:55 2007 -0200

    ACPI: ibm-acpi: fix initial status of backlight device
    
    The brightness class core does not update the initial status of the
    device's brightness at register time.  Do it by ourselves.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Acked-by: Richard Purdie <rpurdie@rpsys.net>

commit 7292576043666ff39946dee14641fe719ba8c7e8
Author: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
Date:   Wed Feb 21 02:05:58 2007 -0500

    ACPI: fix S3 fan resume issue
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7570#c14
    
    Signed-off-by: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
