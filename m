Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYD2FsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYD2FsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYD2FsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:48:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58140 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbYD2FsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:48:00 -0400
Date: Tue, 29 Apr 2008 15:47:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 29
Message-Id: <20080429154750.9e4a93bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Apr_2008_15_47_50_+1000_2H9LewHOiG1XVuNH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Apr_2008_15_47_50_+1000_2H9LewHOiG1XVuNH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

i all,

Changes since next-20080428a:

New trees: sparc, sound and arm (all have a "current" and "next" part).

Conflicts continue to disappear due to code being merged upstream.  Also
several minor/whitespace conflicts have turned up due to merging slightly
different versions of patches than what is in the linux-next tree.

The nfsd tree merge produced a build problem yesterday which I ignored as
I hoped it would just go away quickly:  the merge produces two versions
of ipv6_addr_set_v4mapped in include/net/ipv6.h so I have created a patch
to remove one.  This should go away when nfsd is merged upstream ...

The sched-latest tree needs a fixup for some section mismatch errors it
produced on powerpc.

The appleir driver now builds ok, but novfs and the go7007 driver have
build problems and have been reverted.

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

Below is a summary of the state of the merge.

We are up to 64 trees (counting Linus' and 8 trees of patches pending for
Linus' tree (which are mostly empty)), more are welcome (even if they are
currently empty).  Thanks to those who have contributed, and to those who
haven't, please do.

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
Merging x86-fixes/for-linus
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sparc-current/master
Merging sound-current/for-linus
Merging arm-current/master
Merging quilt/driver-core
Merging quilt/usb
Merging x86/for-akpm
Merging sched/for-akpm
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
CONFLICT (rename/delete): Renamed Documentation/smart-config.txt->Documenta=
tion/kbuild/smart-config.txt in quilt/kernel-doc and deleted in HEAD
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/x86/kernel/apm_32.c
Merging blackfin/for-linus
Merging nfsd/nfsd-next
CONFLICT (add/add): Merge conflict in Documentation/filesystems/nfs-rdma.txt
Applying nfsd merge duplication fix
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
Merging sparc/master
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
Merging arm/devel
CONFLICT (delete/modify): arch/arm/common/rtctime.c deleted in arm/devel an=
d modified in HEAD. Version HEAD of arch/arm/common/rtctime.c left in tree.
CONFLICT (delete/modify): arch/arm/mach-integrator/time.c deleted in arm/de=
vel and modified in HEAD. Version HEAD of arch/arm/mach-integrator/time.c l=
eft in tree.
$git rm arch/arm/common/rtctime.c arch/arm/mach-integrator/time.c
Merging semaphore/semaphore
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
Merging semaphore-removal/semaphore-removal
Applying idr.h needs spinlock.h
Merging x86-latest/latest
CONFLICT (delete/modify): drivers/video/geode/display_gx.h deleted in HEAD =
and modified in x86-latest/latest. Version x86-latest/latest of drivers/vid=
eo/geode/display_gx.h left in tree.
CONFLICT (content): Merge conflict in drivers/video/geode/lxfb.h
CONFLICT (content): Merge conflict in drivers/video/geode/lxfb_ops.c
CONFLICT (content): Merge conflict in drivers/video/geode/video_gx.c
CONFLICT (delete/modify): drivers/video/geode/video_gx.h deleted in HEAD an=
d modified in x86-latest/latest. Version x86-latest/latest of drivers/video=
/geode/video_gx.h left in tree.
CONFLICT (content): Merge conflict in fs/proc/proc_misc.c
CONFLICT (content): Merge conflict in include/asm-x86/geode.h
CONFLICT (content): Merge conflict in include/asm-x86/reboot.h
$ git rm drivers/video/geode/display_gx.h drivers/video/geode/video_gx.h
Merging sched-latest/latest
CONFLICT (content): Merge conflict in arch/x86/kernel/e820_64.c
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
CONFLICT (content): Merge conflict in arch/x86/mm/init_64.c
CONFLICT (content): Merge conflict in arch/x86/mm/numa_64.c
CONFLICT (content): Merge conflict in arch/x86/pci/k8-bus_64.c
CONFLICT (content): Merge conflict in arch/x86/pci/mmconfig-shared.c
CONFLICT (delete/modify): drivers/video/geode/display_gx.h deleted in HEAD =
and modified in sched-latest/latest. Version sched-latest/latest of drivers=
/video/geode/display_gx.h left in tree.
CONFLICT (content): Merge conflict in drivers/video/geode/lxfb.h
CONFLICT (content): Merge conflict in drivers/video/geode/lxfb_ops.c
CONFLICT (content): Merge conflict in drivers/video/geode/video_gx.c
CONFLICT (delete/modify): drivers/video/geode/video_gx.h deleted in HEAD an=
d modified in sched-latest/latest. Version sched-latest/latest of drivers/v=
ideo/geode/video_gx.h left in tree.
CONFLICT (content): Merge conflict in fs/proc/proc_misc.c
CONFLICT (content): Merge conflict in include/asm-x86/geode.h
CONFLICT (content): Merge conflict in include/asm-x86/reboot.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in mm/bootmem.c
Applying sched-latest-fix-1
Merging quilt/ldp
Created commit ec806a3: Revert "novfs: Add the Novell filesystem client ker=
nel module"
Created commit a17e803: Revert "Video: add the go7007 driver"
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
$ git rm localversion-sched-devel.git localversion-x86-latest.git

--Signature=_Tue__29_Apr_2008_15_47_50_+1000_2H9LewHOiG1XVuNH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIFraLTgG2atn1QN8RAi3oAJ4sfDrDJUbF6LiVSNBhwJYDgUIGeQCeLk3T
8QMBPhxtjW5/+ijWdfO7ViU=
=GSJy
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Apr_2008_15_47_50_+1000_2H9LewHOiG1XVuNH--
