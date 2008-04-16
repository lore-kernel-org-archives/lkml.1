Return-Path: <linux-kernel-owner+w=401wt.eu-S1761798AbYDPJ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbYDPJ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYDPJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:58:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39094 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYDPJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:58:24 -0400
Date: Wed, 16 Apr 2008 19:58:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 16
Message-Id: <20080416195809.4701a86c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Apr_2008_19_58_09_+1000_2aLp6h5lzFZX+Fj5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Apr_2008_19_58_09_+1000_2aLp6h5lzFZX+Fj5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Overall still getting much better ...

News:

At Randy Dunlap's suggestion, I have added a LATEST-IS- file to
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/. The name
after "LATEST-IS-" is the prefix of the tar files and the tag of the tree.

Stats:

>From origin/master ...
 4293 files changed, 418772 insertions(+), 202656 deletions(-)
$ git rev-list origin/master.. | wc -l
5261

Changes since next-20080415:

A revert was required on the v4l-dvb tree.

Also on the ide tree - as well as a small patch.

The acpi tree lost three merge conflicts but gained another one.  It also
lost two fixup patches.

The x86-latest tree lost three merge conflicts.

I needed to revert the firesat driver from the ldp tree.

The 4xx tree needed to reverts to get the powerpc allyesconfig to build.

A couple of fixup patches were merged into the respective trees but the
galak tree required a small include file fixup.

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
Created commit 384ee47: Revert "V4L/DVB (7584): Fix build that occurs when =
CONFIG_VIDEO_PMS=3Dy and VIDEO_V4L2_COMMON=3Dm"
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in Documentation/ide/ide.txt
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in drivers/ide/ide.c
CONFLICT (content): Merge conflict in include/linux/Kbuild
Created commit 7cea458: Revert "ide: make ide_hwifs[] static"
Applying ide-fix-2
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
CONFLICT (content): Merge conflict in arch/x86/kernel/apm_32.c
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
CONFLICT (content): Merge conflict in MAINTAINERS
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
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in lib/Makefile
$ git rm include/asm-x86/semaphore_32.h include/asm-x86/semaphore_64.h
Applying x86-latest-kvm-fix-1
Merging sched-latest/latest
CONFLICT (content): Merge conflict in drivers/base/topology.c
Merging quilt/ldp
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Created commit 113c3d6: Revert "DVB: add firesat driver"
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
Applying galak-fix-1
Created commit 7533b08: Revert "[POWERPC] ibm_newemac: PowerPC 440EP/440GR =
EMAC PHY clock workaround"
Created commit 2618991: Revert "[POWERPC] ibm_newemac: PowerPC 440GX EMAC P=
HY clock workaround"

--Signature=_Wed__16_Apr_2008_19_58_09_+1000_2aLp6h5lzFZX+Fj5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIBc29TgG2atn1QN8RAtuvAKCGbJH3lTwK35FA/VWdoNjxR/OECACfVWI+
rIT0wPrxivvC6sgdbC1dWm0=
=9eG2
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Apr_2008_19_58_09_+1000_2aLp6h5lzFZX+Fj5--
