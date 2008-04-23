Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYDWJDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYDWJDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYDWJC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:02:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52917 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYDWJCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:02:54 -0400
Date: Wed, 23 Apr 2008 19:02:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 23
Message-Id: <20080423190248.2f21b33f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Apr_2008_19_02_48_+1000_UqKKnv9FXvlx.9sj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Apr_2008_19_02_48_+1000_UqKKnv9FXvlx.9sj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I am not sure how useful these trees are during the merge window, but I
shall persist for a while.

Changes since next-20080422:

The build bug in infiniband has gone.

One of the drivers merged into Linus' tree from the Arm tree won't build
on x86_64 (at least).  Instead of reverting it, I have just added a
dependency on CONFIG_ARM.

Conflicts continue to disappear due to code being merged upstream and
a few more trivial ones have appeared for the same reason.

The xfs has a bug has gone.  As has the kvm build bug in powerpc's
asm-offsets.

A new build bug in mtd (for which there is a fix, I am told).

I have reverted part of the stack protector patches from x86-latest since
I don't have a new enough compiler.  Ingo is going to change the #error
to #warning for now.

The firesat driver still fails to build and so is still reverted.

I am still carrying the PNP fixup patches.
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

We are up to 58 trees, more are welcome (even if they are currently
empty).  Thanks to those who have contributed, and to those who haven't,
please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/, the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

Merging origin/master
Applying The-HTC-PASIC3-LED-DS1WM-chip-support-is-ARM-only
Merging x86-fixes/for-linus
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/base/power/main.c
CONFLICT (content): Merge conflict in include/linux/pm.h
Merging quilt/pci
CONFLICT (content): Merge conflict in drivers/pci/quirks.c
Merging quilt/usb
Merging x86/for-akpm
Merging sched/for-akpm
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in drivers/ide/ide-cd.c
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
Merging dlm/next
Merging scsi/master
Merging ia64/test
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
Merging galak/powerpc-next
Merging mtd/master
Created commit c93feba: Revert "[MTD] AR7 mtd partition map"
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging semaphore/semaphore
Merging x86-latest/latest
Applying x86-latest-kvm-fix-1
Created commit e52dc54: Revert "stackprotector: turn not having the right g=
cc into an #error"
Merging sched-latest/latest
Merging quilt/ldp
CONFLICT (content): Merge conflict in drivers/misc/Kconfig
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Created commit 7738b77: Revert "DVB: add firesat driver"
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP

--Signature=_Wed__23_Apr_2008_19_02_48_+1000_UqKKnv9FXvlx.9sj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDvs8TgG2atn1QN8RAhwdAJ9yp91e+z/18htM5KRweQZ5Ry+UjQCgh0iI
8JAnndNBRK6j7LmQxz3DD4I=
=lGKq
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Apr_2008_19_02_48_+1000_UqKKnv9FXvlx.9sj--
