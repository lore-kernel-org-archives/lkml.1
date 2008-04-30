Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYD3Hb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYD3Hb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYD3HbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:31:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33316 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760173AbYD3HbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:31:11 -0400
Date: Wed, 30 Apr 2008 17:31:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 30
Message-Id: <20080430173104.39897492.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_17_31_04_+1000_13eqc_nnmQRfFO/u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_17_31_04_+1000_13eqc_nnmQRfFO/u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080429:

New tree: pci (has a "current" and "next" part).

There was a build break in Linus' tree (pasemic_edac - patch supplied and
applied). Also a build breakage in the v4l/dvb code - but this seems to
have been caused by not cleaning my tree before the build.

Conflicts continue to disappear due to code being merged upstream.  Also
several minor/whitespace conflicts have turned up due to merging slightly
different versions of patches than what is in the linux-next tree.

[Notably a conflict in the v4l-dvb merge that was really just git being
confused and thinking that a new file in one branch of the merge was a
rename of a file in the other branch when it really wasn't.  Both files
were mostly the GPL stuff.]

The nfsd tree merge duplication of code has gone.

The sched-latest tree section mismatch errors have gone.

The novfs and the go7007 driver build problems have gone.

I am carrying one less PNP fixup patches.
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

We are up to 66 trees (counting Linus' and 9 trees of patches pending for
Linus' tree (which are mostly empty)), more are welcome (even if they are
currently empty).  Thanks to those who have contributed, and to those who
haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

Merging origin/master
Applying pasemi_edac needs to include linux/edac.h
Created commit 0c134fe: Revert "Rename common tuner Kconfig names to use th=
e same"
Merging x86-fixes/for-linus
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sparc-current/master
Merging sound-current/for-linus
Merging arm-current/master
Merging pci-current/for-linus
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/pci/pci-driver.c
Merging quilt/usb
Merging x86/for-akpm
Merging sched/for-akpm
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-ds1374.c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
CONFLICT (rename/rename): Rename "drivers/media/dvb/frontends/xc5000_priv.h=
"->"include/asm-mips/ds1287.h" in branch "HEAD" rename "drivers/media/dvb/f=
rontends/xc5000_priv.h"->"drivers/media/common/tuners/xc5000_priv.h" in "v4=
l-dvb/stable"
CONFLICT (content): Merge conflict in drivers/media/Kconfig
CONFLICT (content): Merge conflict in drivers/media/Makefile
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
CONFLICT (content): Merge conflict in drivers/misc/intel_menlow.c
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
$ git rm arch/arm/common/rtctime.c arch/arm/mach-integrator/time.c
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
Applying idr.h needs spinlock.h
Merging x86-latest/latest
Merging sched-latest/latest
Merging quilt/ldp
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
$ git rm localversion-sched-devel.git localversion-x86-latest.git

--Signature=_Wed__30_Apr_2008_17_31_04_+1000_13eqc_nnmQRfFO/u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGCA8TgG2atn1QN8RAqnJAKCLTmZgvuwVZk15FXSPiCPHcLrmcQCdFYDG
dVP0MaLuuFtpe6i81vLHiBE=
=xtdM
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_17_31_04_+1000_13eqc_nnmQRfFO/u--
