Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYEEFP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYEEFP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYEEFPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:15:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41698 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbYEEFPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:15:46 -0400
Date: Mon, 5 May 2008 15:15:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 5
Message-Id: <20080505151538.23eb89c5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_May_2008_15_15_38_+1000_ID7IcZ/33478+A6G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2008_15_15_38_+1000_ID7IcZ/33478+A6G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080502:

New tree: v9fs.

The v4l/dvb breakage still required a small patch but the div64_64 to
div64_u64 rename breakage was fixed.

The kbuild tree was dropped due to build errors (notified).

The vfs tree linux/file.h splitup failure was fixed.

Conflicts continue to disappear due to code being merged upstream.  Also
several minor/whitespace conflicts have turned up due to merging slightly
different versions of patches than what is in the linux-next tree.

The s390 build breakage was fixed.

I have applied a fix for the dev_name introduction breaking edac
(notified with patch).

I am still carrying two PNP fixup patches.
----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups, it is also built with powerpc allnoconfig,
44x/ebony_defconfig and allyesconfig.

Below is a summary of the state of the merge.

We are up to 68 trees (counting Linus' and 9 trees of patches pending for
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

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Tnanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git reset --hard stable
Merging origin/master
Applying v4l build fix
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
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/host/Makefile
Merging x86/for-akpm
Merging sched/for-akpm
Merging pci/linux-next
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
CONFLICT (content): Merge conflict in README
$ git reset --hard 502d7147d13b3e9a4705d839fb06533a456d3d3c
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
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
Merging cpufreq/master
Merging v9fs/for-next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/atm/ambassador.c
Applying idr.h needs spinlock.h
Merging x86-latest/latest
Merging sched-latest/latest
Merging quilt/ldp
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
$ git rm localversion-sched-devel.git localversion-x86-latest.git
Applying dev_name introduction fall out fix

--Signature=_Mon__5_May_2008_15_15_38_+1000_ID7IcZ/33478+A6G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHpf/TgG2atn1QN8RAm8HAJ0a67o4cDYvM4db7F7b5fdBQcoYXQCeIv0K
6eKkdVLbN8L4fSU3rnYdGxM=
=k7mI
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2008_15_15_38_+1000_ID7IcZ/33478+A6G--
