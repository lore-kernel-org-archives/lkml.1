Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbYE1Hv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbYE1Hv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYE1Hvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:51:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60879 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYE1Hvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:51:50 -0400
Date: Wed, 28 May 2008 17:51:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 28
Message-Id: <20080528175140.ca0da2f8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_May_2008_17_51_40_+1000_5cIanXtAos1V/yBs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_May_2008_17_51_40_+1000_5cIanXtAos1V/yBs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080527:

New tree: ubifs

The pci tree had a conflict with the pci-current tree.

The hid tree was fixed.

The semaphore-removal tree still needed three patches reverted because simi=
lar
patches were merged into upstream and the scsi-rc-fixes trees.

I have applied the following temporary patch for known build problems:

	"Fix various 8390 builds" - the net tree broke builds on various
architectures - hopefully this patch will go into the net tree shortly.
	"block: genhd errors when CONFIG_PROC_FS=3Dn" - this will be merged
into the driver-core tree tomorrow.
	"hil_kbd: restore pci_ids.h" - this is to fix a patch in the
semaphore tree and hopefully will be fixed there shortly.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(patches at
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
44x_defconfig and allyesconfig and i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 81 trees (counting Linus' and 13 trees of patches pending for
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

$ git checkout master
$ git reset --hard stable
Merging origin/master
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
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging quilt/driver-core
Merging quilt/usb
Merging x86/auto-x86-next
Merging sched/auto-sched-next
Merging ftrace/auto-ftrace-next
Applying ftrace: fix rculist split fallout
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/pci/hotplug/pciehp_hpc.c
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
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
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas/main.c
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
Merging arm/devel
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging rcu/core/rcu
Merging locking/core/locking
Merging safe-poison-pointers/safe-poison-pointers
Merging stackprotector/stackprotector
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/atm/ambassador.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_main.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_sysfs.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_attr.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mid.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
CONFLICT (content): Merge conflict in net/9p/trans_virtio.c
$ git reset --hard
$ git checkout -b tmp semaphore-removal/semaphore-removal
Created commit c5e8b8f: Revert "Convert qla_os to use mutex instead of sema=
phore"
Created commit ef54e4f: Revert "9p: Convert from semaphore to spinlock"
Created commit 586bd91: Revert "qla2xxx: Turn vport_sem into vport_mutex"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/atm/ambassador.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_main.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_sysfs.c
Merging quilt/ldp.next
Merging bkl-removal/bkl-removal
Merging trivial/next
Merging ubifs/for_andrew
Applying Fix various 8390 builds
Applying block: genhd errors when CONFIG_PROC_FS=3Dn
Applying hil_kbd: restore pci_ids.h

--Signature=_Wed__28_May_2008_17_51_40_+1000_5cIanXtAos1V/yBs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIPQ8TTgG2atn1QN8RAv2iAKCO1ygY6f0CSyC7JrHAg3DO/jsn8gCcC+JO
ujJbFbaDYTxoWiSW7sYTPhk=
=4Jh4
-----END PGP SIGNATURE-----

--Signature=_Wed__28_May_2008_17_51_40_+1000_5cIanXtAos1V/yBs--
