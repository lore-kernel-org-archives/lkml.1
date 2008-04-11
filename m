Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYDKHgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYDKHgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYDKHgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:36:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbYDKHga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:36:30 -0400
Date: Fri, 11 Apr 2008 17:36:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 11
Message-Id: <20080411173622.ea3f3624.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Apr_2008_17_36_22_+1000_krQB=iDqoCcKgWnD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Apr_2008_17_36_22_+1000_krQB=iDqoCcKgWnD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080411:

No need for libata-fix-1 (a typo fixup)
New conflicts in XFS (caused by some XFS patches being merged upstream and
	also existing in the xfs tree - trivial).
Added a small Kconfig patch for powerpc to make allmodconfig build (I expect
	to be added to the powerpc next tree shortly).

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64.

There were a few merge conflicts (fairly trivial) and couple of build
failures (notified).  Below is a summary of the state of the merge.

We are up to 55 trees, more are welcome (even if they are currently
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
CONFLICT (content): Merge conflict in include/asm-x86/ide.h
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
CONFLICT (content): Merge conflict in lib/Kconfig.debug
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in MAINTAINERS
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
CONFLICT (content): Merge conflict in fs/xfs/quota/xfs_qm_syscalls.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_ialloc.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_sb.h
Merging semaphore/semaphore
CONFLICT (delete/modify): include/asm-x86/semaphore_32.h deleted in semapho=
re/semaphore and modified in HEAD. Version HEAD of include/asm-x86/semaphor=
e_32.h left in tree.
CONFLICT (delete/modify): include/asm-x86/semaphore_64.h deleted in semapho=
re/semaphore and modified in HEAD. Version HEAD of include/asm-x86/semaphor=
e_64.h left in tree.
$ git rm include/asm-x86/semaphore_32.h include/asm-x86/semaphore_64.h
Merging quilt/ldp
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
Applying Fix MAX_ORDER config problem

--Signature=_Fri__11_Apr_2008_17_36_22_+1000_krQB=iDqoCcKgWnD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/xT6TgG2atn1QN8RApR4AJ9w1mLvFHgXj0/ucuxf7bBqg1Hk7QCgglVz
8BTfeYYjEnx10BB8zqA1amY=
=w9p7
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Apr_2008_17_36_22_+1000_krQB=iDqoCcKgWnD--
