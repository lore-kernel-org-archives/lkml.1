Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYEFHeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYEFHeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYEFHem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:34:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38138 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYEFHel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:34:41 -0400
Date: Tue, 6 May 2008 17:34:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 6
Message-Id: <20080506173430.fe2b18fb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_17_34_30_+1000_J6KU8S6=Q8GufTyI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_17_34_30_+1000_J6KU8S6=Q8GufTyI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080505:

New tree: rr (from Rusty Russell).

The v4l/dvb breakage still required a small patch.

The kbuild tree is back but had a commit reverted due build errors
(notified).

The rr tree caused a couple of simple conflicts (notified).

The dev_name edac patch was applied upstream.

The PNP fixup patches have been integrated into the net tree.
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
Created commit ba3607c: Revert "kconfig: add support for stdin (make K=3D- =
...)"
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
Merging quilt/rr
Merging semaphore/semaphore
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/atm/ambassador.c
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
Applying idr.h needs spinlock.h
Merging x86-latest/latest
Merging sched-latest/latest
CONFLICT (content): Merge conflict in include/linux/stop_machine.h
Merging quilt/ldp
$ git rm localversion-sched-devel.git localversion-x86-latest.git

--Signature=_Tue__6_May_2008_17_34_30_+1000_J6KU8S6=Q8GufTyI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIAoOTgG2atn1QN8RAi8dAJ9U49JoCDuLeLnTbrsLF30nDl/I1wCfWMbT
MVda5xT76mrAlfrcidaH4T8=
=OXA9
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_17_34_30_+1000_J6KU8S6=Q8GufTyI--
