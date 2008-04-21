Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYDUKxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYDUKxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYDUKw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:52:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52532 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbYDUKw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:52:56 -0400
Date: Mon, 21 Apr 2008 20:52:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 21
Message-Id: <20080421205249.1b7e6cb6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Apr_2008_20_52_49_+1000_u4JFLWhH0n.a2o28"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Apr_2008_20_52_49_+1000_u4JFLWhH0n.a2o28
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I am not sure how useful these trees are during the merge window, but I
shall persist for a while.

Changes since next-20080416:

A lot of changes caused by so much stuff being merged int Linus' tree
already.  I am to tired to summarise, sorry.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups, it is also built with powerpc allnoconfig,
44x/ebony_defconfig and allyesconfig.

There were a few merge conflicts (fairly trivial and/or notified) and
couple of build failures (notified).  Below is a summary of the state of
the merge.

We are up to 57 trees, more are welcome (even if they are currently
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
Applying linux-x86_64-fix-1
Merging x86-fixes/for-linus
CONFLICT (content): Merge conflict in arch/x86/kernel/kgdb.c
	(This was caused by the above fix I applied to Linus' tree)
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in MAINTAINERS
Applying infiniband-fix-2
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
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/x86/kernel/apm_32.c
Merging blackfin/for-linus
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
Merging kvm/master
Applying kvm-fix-1
Merging dlm/next
CONFLICT (content): Merge conflict in fs/gfs2/locking/dlm/lock_dlm.h
Merging scsi/master
Merging ia64/test
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging selinux/for-akpm
Merging quilt/m68k
Merging powerpc/powerpc-next
CONFLICT (content): Merge conflict in include/asm-powerpc/mmu-44x.h
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
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging semaphore/semaphore
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
CONFLICT (content): Merge conflict in include/linux/memory.h
Merging x86-latest/latest
CONFLICT (content): Merge conflict in arch/x86/pci/acpi.c
CONFLICT (content): Merge conflict in arch/x86/pci/common.c
CONFLICT (content): Merge conflict in arch/x86/pci/pci.h
CONFLICT (content): Merge conflict in include/asm-powerpc/bitops.h
Applying x86-latest-kvm-fix-1
Merging sched-latest/latest
CONFLICT (content): Merge conflict in kernel/kthread.c
Merging quilt/ldp
CONFLICT (content): Merge conflict in drivers/misc/Kconfig
Created commit d7ddd45: Revert "DVB: add firesat driver"
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP

--Signature=_Mon__21_Apr_2008_20_52_49_+1000_u4JFLWhH0n.a2o28
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDHIGTgG2atn1QN8RAvM/AJ4s9ANI/XUw9bhBfYrh9vmon3YnrACgjGfE
1BDNZLndWk9DkKoivW4NFxg=
=armu
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Apr_2008_20_52_49_+1000_u4JFLWhH0n.a2o28--
