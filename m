Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYFEHwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYFEHwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 03:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYFEHw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 03:52:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52513 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbYFEHwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 03:52:24 -0400
Date: Thu, 5 Jun 2008 17:52:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 5
Message-Id: <20080605175217.cee497f3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Jun_2008_17_52_17_+1000_Vxhi0MMxKp5zUbE5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jun_2008_17_52_17_+1000_Vxhi0MMxKp5zUbE5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080604:

The hid tree fixed the conflicts with Linus' tree.

The v4l-dvb tree no longer needed the fixup patch.

The galak tree gained a conflict with the net tree.

The wireless tree now has the same conflict (in the ps3_gelic driver) as
the semaphore-removal tree.

The rr tree gained a conflict with the net-current tree.

The ldp tree suffered from the v4l-dvb struct members renaming.

I have applied the following temporary patch for known build problems:

	"Fix various 8390 builds" - the net tree broke builds on various
architectures - hopefully this patch will go into the net tree shortly.
	"firmware: build fixes 2" - the firmware tree broke some arm builds.

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

We are up to 87 trees (counting Linus' and 13 trees of patches pending for
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
CONFLICT (content): Merge conflict in drivers/s390/kvm/kvm_virtio.c
CONFLICT (content): Merge conflict in drivers/virtio/virtio.c
CONFLICT (content): Merge conflict in drivers/virtio/virtio_pci.c
Merging quilt/usb
Merging x86/auto-x86-next
Merging sched/auto-sched-next
Merging ftrace/auto-ftrace-next
Applying ftrace: fix rculist split fallout
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/base/power/main.c
CONFLICT (content): Merge conflict in include/linux/device.h
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
CONFLICT (content): Merge conflict in drivers/s390/block/dasd.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd_eckd.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd_fba.c
CONFLICT (content): Merge conflict in drivers/s390/char/tape_core.c
CONFLICT (content): Merge conflict in drivers/s390/cio/device_fsm.c
CONFLICT (content): Merge conflict in drivers/s390/net/claw.c
CONFLICT (content): Merge conflict in drivers/s390/net/ctcm_main.c
CONFLICT (content): Merge conflict in drivers/s390/net/lcs.c
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
Applying scsi: fix fallout from KOBJ_NAME_LEN removal
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
CONFLICT (content): Merge conflict in Documentation/powerpc/booting-without=
-of.txt
Merging mtd/master
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas/main.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt2x00dev=
.c
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
Merging arm/devel
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/tosa.c
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
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
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_attr.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mid.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
Merging quilt/ldp.next
Applying ldp: fix fallout from v4l struct element renaming
Merging bkl-removal/bkl-removal
Merging trivial/next
Merging ubifs/for_andrew
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/usb/serial/Kconfig
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_3410.h deleted in firmwa=
re/master and modified in HEAD. Version HEAD of drivers/usb/serial/ti_fw_34=
10.h left in tree.
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_5052.h deleted in firmwa=
re/master and modified in HEAD. Version HEAD of drivers/usb/serial/ti_fw_50=
52.h left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/ti_usb_3410_5052.c
CONFLICT (content): Merge conflict in sound/pci/Kconfig
CONFLICT (content): Merge conflict in sound/pci/maestro3.c
CONFLICT (content): Merge conflict in sound/pci/ymfpci/ymfpci_main.c
Applying Fix various 8390 builds
Applying firmware: build fixes 2

--Signature=_Thu__5_Jun_2008_17_52_17_+1000_Vxhi0MMxKp5zUbE5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhHmzEACgkQTgG2atn1QN+rggCeP6/emgV8lF7sCWWNdS9z/QJ1
84AAnjy5YTuSklAmdwQpdqdMWNrjI6JO
=Mnle
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jun_2008_17_52_17_+1000_Vxhi0MMxKp5zUbE5--
