Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYELFFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYELFFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 01:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759580AbYELFEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 01:04:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33788 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbYELFEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 01:04:35 -0400
Date: Mon, 12 May 2008 15:04:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 12
Message-Id: <20080512150418.603e29cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_May_2008_15_04_18_+1000_vo.RT2=EefQK_j/v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_May_2008_15_04_18_+1000_vo.RT2=EefQK_j/v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

News:  I am now providing patches relative to the latest tag in Linus'
tree.  I propose to stop providing complete tar balls as they are so
large and people will have recent versions of Linus's tree anyway (I
assume).  The patches will be named "patch-<upstream tag>-<next tag>".

Changes since next-20080509:

New Tree: kbuild-current

Renamed Trees: driver-core.next to driver-core.current
	usb.next to usb.current

The kbuild tree is back.

The arm tree had a conflict with upstream (notified).

The rr tree had a conflict with the vfs tree (notified).

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls and patches at
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
44x_defconfig and allyesconfig and i386 defconfig.

Below is a summary of the state of the merge.

We are up to 71 trees (counting Linus' and 13 trees of patches pending for
Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git reset --hard stable
Merging origin/master
Merging x86-fixes/for-linus
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sparc-current/master
Merging sound-current/for-linus
Merging arm-current/master
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/master
Merging quilt/driver-core.current
Merging quilt/usb.current
Merging quilt/driver-core
Merging quilt/usb
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
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/Makefile
Merging cpufreq/master
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/atm/ambassador.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_main.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_sysfs.c
Applying idr.h needs spinlock.h
Merging quilt/ldp.next

--Signature=_Mon__12_May_2008_15_04_18_+1000_vo.RT2=EefQK_j/v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIJ8/XTgG2atn1QN8RAj5UAJsFl4R+oFDPXJmeQ5kslD8SXQbQpACgmDw5
IISgohdIcdNHTOWnKR9AaFk=
=l/zi
-----END PGP SIGNATURE-----

--Signature=_Mon__12_May_2008_15_04_18_+1000_vo.RT2=EefQK_j/v--
