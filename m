Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYEOHb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYEOHb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYEOHbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:31:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55345 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbYEOHbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:31:15 -0400
Date: Thu, 15 May 2008 17:31:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 15
Message-Id: <20080515173104.54bd9668.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_May_2008_17_31_04_+1000_Cms/Zi5irBeFtIkp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_May_2008_17_31_04_+1000_Cms/Zi5irBeFtIkp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

It appears that people are starting to work on 2.6.27 as the conflict
and build breakage rate is slowly rising.

Changes since next-20080514:

Applied a patch for a build bug in upstream (already fixed there).

There is a trivial conflict between the i2c tree and the driver-core tree.

The i2c, semaphore-removal and powerpc trees all needed a patch reverted
due to build problems (all notified).  The semaphore-removal one was
instead of the previous idr.h patch I had been applying.

Applied a patch to fix an m68k build breakage.

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
44x_defconfig and allyesconfig and i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 74 trees (counting Linus' and 13 trees of patches pending for
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
Applying irnet_irda.c must #include <asm/unaligned.h>
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
CONFLICT (content): Merge conflict in drivers/usb/gadget/serial.c
Merging quilt/driver-core
Merging quilt/usb
Merging x86/for-akpm
Merging sched/for-akpm
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
CONFLICT (content): Merge conflict in include/linux/i2c.h
Created commit 937525f: Revert "i2c: Kill the old driver matching scheme"
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
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-4965=
-rs.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt61pci.c
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
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/atm/ambassador.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_main.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_sysfs.c
Created commit 2fdef6f: Revert "9p: Convert from semaphore to spinlock"
Merging quilt/ldp.next
Created commit 52f6ecd: Revert "[POWERPC] Create modalias file in sysfs for=
 of_platform bus"
Applying m68k_zorro_fix

--Signature=_Thu__15_May_2008_17_31_04_+1000_Cms/Zi5irBeFtIkp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIK+bATgG2atn1QN8RAqLrAKCNCyiJAB8y125oGiKzV+R0HaDsTACfdwar
MP3fAAzvZ3dWdc4YI+6jxCI=
=5j6A
-----END PGP SIGNATURE-----

--Signature=_Thu__15_May_2008_17_31_04_+1000_Cms/Zi5irBeFtIkp--
