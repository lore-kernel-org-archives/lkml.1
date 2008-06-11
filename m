Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYFKJi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYFKJi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYFKJis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:38:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37714 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYFKJir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:38:47 -0400
Date: Wed, 11 Jun 2008 19:38:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 11
Message-Id: <20080611193840.08a35b14.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Jun_2008_19_38_40_+1000_xWRUXaYfFMYbMDJJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jun_2008_19_38_40_+1000_xWRUXaYfFMYbMDJJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080610:

Dropped trees (temporary): ldp (it is unfetchable - probably something to
do with the new Staging tree), block (it just has too many conflicts and
breaks the powerpc build).

The kbuild-current tree is now itself again.

The kbuild tree fixed it build problem.

The usb tree lost its hid build problem.

The tip-core tree lost its conflict (since the kbuild tree effectively
moved).

The x86 tree gained two conflicts with the ftrace tree.

The pci tree lost its conflict with the kbuild-current tree but gained
one with the x86 tree and one with the driver-core tree.

The hid tree lost its conflict with the driver-core tree.

The nsfd tree gained a conflict with the cpus4096 tree.

The powerpc tree was fixed up so that it no longer needed a commit
reverted.

The net tree lost its conflict with the net-current tree.

The galak tree gained a conflict with the net tree.

The wireless tree lost all its conflicts.

The rr tree gained a conflict with the net-current tree.

I have applied the following temporary patch for known build problems:

	"Fix various 8390 builds" - the net tree broke builds on various
architectures - hopefully this patch will go into the net tree shortly.

The powerpc64 allyesconfig build is broken, probably by ftrace.
The sparc32 defconfig build is broken, probably by the kbuild tree.

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

We are up to 92 trees (counting Linus' and 13 trees of patches pending for
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
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
CONFLICT (content): Merge conflict in kernel/Makefile
Applying ftrace: fix rculist split fallout
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
Merging pci/linux-next
CONFLICT (content): Merge conflict in arch/x86/pci/irq.c
CONFLICT (content): Merge conflict in drivers/base/power/main.c
CONFLICT (content): Merge conflict in drivers/pci/hotplug/fakephp.c
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
CONFLICT (content): Merge conflict in net/sunrpc/svc.c
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
Merging kvm/master
Merging dlm/next
Merging scsi/master
Applying scsi: fix fallout from the class_find_device API change
Applying scsi: fix fallout from KOBJ_NAME_LEN removal
Merging ia64/test
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging selinux/for-akpm
Merging quilt/m68k
Merging powerpc/powerpc-next
CONFLICT (delete/modify): arch/ppc/platforms/cpci690.c deleted in powerpc/p=
owerpc-next and modified in HEAD. Version HEAD of arch/ppc/platforms/cpci69=
0.c left in tree.
CONFLICT (delete/modify): arch/ppc/platforms/ev64260.c deleted in powerpc/p=
owerpc-next and modified in HEAD. Version HEAD of arch/ppc/platforms/ev6426=
0.c left in tree.
CONFLICT (delete/modify): arch/ppc/platforms/ev64360.c deleted in powerpc/p=
owerpc-next and modified in HEAD. Version HEAD of arch/ppc/platforms/ev6436=
0.c left in tree.
CONFLICT (delete/modify): arch/ppc/platforms/hdpu.c deleted in powerpc/powe=
rpc-next and modified in HEAD. Version HEAD of arch/ppc/platforms/hdpu.c le=
ft in tree.
CONFLICT (delete/modify): arch/ppc/platforms/katana.c deleted in powerpc/po=
werpc-next and modified in HEAD. Version HEAD of arch/ppc/platforms/katana.=
c left in tree.
CONFLICT (delete/modify): arch/ppc/platforms/radstone_ppc7d.c deleted in po=
werpc/powerpc-next and modified in HEAD. Version HEAD of arch/ppc/platforms=
/radstone_ppc7d.c left in tree.
CONFLICT (delete/modify): arch/ppc/syslib/ppc_sys.c deleted in powerpc/powe=
rpc-next and modified in HEAD. Version HEAD of arch/ppc/syslib/ppc_sys.c le=
ft in tree.
Merging lblnet/master
Merging ext4/next
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging security-testing/next
Merging net/master
CONFLICT (content): Merge conflict in Documentation/powerpc/booting-without=
-of.txt
Merging sparc/master
Merging galak/powerpc-next
CONFLICT (content): Merge conflict in Documentation/powerpc/booting-without=
-of.txt
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
Merging arm/devel
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-yl-9200.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/tosa.c
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Merging cifs/master
Merging mmc/next
CONFLICT (content): Merge conflict in drivers/mmc/host/mmc_spi.c
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_attr.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mid.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
Merging bkl-removal/bkl-removal
Merging trivial/next
Merging ubifs/for_andrew
Merging lsm/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/usb/misc/isight_firmware.c
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
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
CONFLICT (content): Merge conflict in drivers/video/backlight/Kconfig
CONFLICT (content): Merge conflict in drivers/video/backlight/Makefile
Applying Fix various 8390 builds

--Signature=_Wed__11_Jun_2008_19_38_40_+1000_xWRUXaYfFMYbMDJJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhPnSAACgkQTgG2atn1QN+vZgCdGeUbA7HYeOVeJN3CLm9KU0VS
7HwAnizf+VKl7X4BwACWXMAWIu7n5Z71
=xFEy
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jun_2008_19_38_40_+1000_xWRUXaYfFMYbMDJJ--
