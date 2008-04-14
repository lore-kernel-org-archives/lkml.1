Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYDNKej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYDNKej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYDNKeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:34:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44635 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYDNKea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:34:30 -0400
Date: Mon, 14 Apr 2008 20:34:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 14
Message-Id: <20080414203423.22bf99d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Apr_2008_20_34_23_+1000_AY66Dp1o=Cme1Mvh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Apr_2008_20_34_23_+1000_AY66Dp1o=Cme1Mvh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080411:

Several merge conflicts have gone away for various reasons (in the ide,
ieee1394, net, vfs and semaphore trees - thanks guys).

Commit "SELinux: Add network port SID cache" from the selinux tree had to
be reverted due to a build failure.

The net tree gained a few more merge conflicts (Dave is looking at these)
as did the ldp tree (very trivial).

The x86-latest tree managed to get merged (with several conflicts) and
build (after "x86: use explicit timing delay for pit accesses in kernel
and pcspkr driver" was reverted and a patch for a conflict with the kvm
tree was applied).

I reverted "PCI: sparc64: use generic pci_enable_resources()" and am told
that the other architecture patches that are similarly not needed will be
removed as well.

I applied a (temporary and incorrect) patch to the usb tree to get us
building.

I reverted all the wusb patches out of the ldp tree due to build problems.

It would be helpful at this point (close to the new merge window) for
subsystem maintainers to attempt to rebase on/merge with Linus' tree to
see how many of the outstanding merge conflicts can be fixed within their
tree.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64.

There were a few merge conflicts (fairly trivial and/or notified) and
couple of build failures (notified).  Below is a summary of the state of
the merge.

We are up to 56 trees, more are welcome (even if they are currently
empty).  Thanks to those who have contributed, and to those who haven't,
please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ and the guys at http://test.kernel.org/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

Merging origin/master
Merging x86-fixes/for-linus
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging quilt/driver-core
Merging quilt/pci
Merging quilt/usb
Merging x86/for-akpm
Merging sched/for-akpm
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in Documentation/ide/ide.txt
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in drivers/ide/ide.c
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
CONFLICT (content): Merge conflict in fs/xfs/quota/xfs_qm_syscalls.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_ialloc.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_mount.c
Merging infiniband/for-next
CONFLICT (content): Merge conflict in drivers/infiniband/hw/amso1100/c2_pro=
vider.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb3/iwch_prov=
ider.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/nes/nes_verbs.c
Applying infiniband-fix-2
Merging acpi/test
CONFLICT (content): Merge conflict in arch/x86/kernel/setup_64.c
CONFLICT (delete/modify): arch/x86/kernel/smpboot_64.c deleted in HEAD and =
modified in acpi/test. Version acpi/test of arch/x86/kernel/smpboot_64.c le=
ft in tree.
CONFLICT (delete/modify): include/asm-x86/smp_64.h deleted in HEAD and modi=
fied in acpi/test. Version acpi/test of include/asm-x86/smp_64.h left in tr=
ee.
$ git rm arch/x86/kernel/smpboot_64.c include/asm-x86/smp_64.h
Applying acpi-fix-1
Applying acpi-fix-2
Merging blackfin/for-linus
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
Merging kvm/master
CONFLICT (content): Merge conflict in arch/s390/lib/uaccess_pt.c
CONFLICT (add/add): Merge conflict in include/asm-s390/sysinfo.h
CONFLICT (content): Merge conflict in include/asm-x86/kvm_host.h
Merging dlm/next
Merging scsi/master
Merging ia64/test
CONFLICT (content): Merge conflict in arch/ia64/kernel/mca.c
CONFLICT (content): Merge conflict in arch/ia64/mm/tlb.c
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging selinux/for-akpm
Created commit 2a81e96: Revert "SELinux: Add network port SID cache"
Merging quilt/m68k
Merging powerpc/powerpc-next
Merging hrt/mm
Merging lblnet/master
Merging ext4/next
CONFLICT (content): Merge conflict in fs/jbd2/journal.c
CONFLICT (content): Merge conflict in fs/jbd2/revoke.c
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging security-testing/next
Merging net/master
CONFLICT (rename/modify): Merge conflict in net/mac80211/mlme.c
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/Kconfig
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt61pci.c
CONFLICT (content): Merge conflict in net/ipv4/inet_timewait_sock.c
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
Merging semaphore/semaphore
Merging x86-latest/latest
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in arch/um/Kconfig.i386
CONFLICT (content): Merge conflict in arch/um/Kconfig.x86_64
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/Makefile
CONFLICT (add/add): Merge conflict in arch/x86/kernel/acpi/sleep.h
CONFLICT (content): Merge conflict in arch/x86/kernel/tsc_32.c
CONFLICT (content): Merge conflict in arch/x86/pci/acpi.c
CONFLICT (content): Merge conflict in arch/x86/pci/common.c
CONFLICT (content): Merge conflict in arch/x86/pci/pci.h
CONFLICT (content): Merge conflict in include/asm-x86/ide.h
CONFLICT (delete/modify): include/asm-x86/semaphore_32.h deleted in HEAD an=
d modified in x86-latest/latest. Version x86-latest/latest of include/asm-x=
86/semaphore_32.h left in tree.
CONFLICT (delete/modify): include/asm-x86/semaphore_64.h deleted in HEAD an=
d modified in x86-latest/latest. Version x86-latest/latest of include/asm-x=
86/semaphore_64.h left in tree.
CONFLICT (add/add): Merge conflict in include/asm-x86/trampoline.h
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in lib/Makefile
$ git rm include/asm-x86/semaphore_32.h include/asm-x86/semaphore_64.h
Created commit 5886a8a: Revert "x86: use explicit timing delay for pit acce=
sses in kernel and pcspkr driver"
Applying x86-latest-kvm-fix-1
Merging quilt/ldp
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
Applying Fix MAX_ORDER config problem
Created commit cb62044: Revert "PCI: sparc64: use generic pci_enable_resour=
ces()"
Applying usb-fix-1
Created commit a69f405: Revert "wusb: add the wireless usb stack to Linux"
Created commit bcc7485: Revert "wusb: add hwa-hc wireless host controller d=
river"
Created commit a7abe8b: Revert "wusb: add the USB wireless core host contro=
ller helper driver"
Created commit 250c058: Revert "wusb: add the USB wusb-cbaf driver"
Created commit 28c9f52: Revert "wusb: add the USB wireless core code"


--Signature=_Mon__14_Apr_2008_20_34_23_+1000_AY66Dp1o=Cme1Mvh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIAzM0TgG2atn1QN8RApK+AJ46hCJohAL2wKqbdJFWGJQWSMWEjgCffx1d
irOWn3olyXEJp9dnAaEPJ4E=
=TCE0
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Apr_2008_20_34_23_+1000_AY66Dp1o=Cme1Mvh--
