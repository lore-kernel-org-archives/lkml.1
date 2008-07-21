Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYGUIRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYGUIRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYGUIRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:17:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45533 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYGUIRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:17:33 -0400
Date: Mon, 21 Jul 2008 18:17:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 21
Message-Id: <20080721181725.9269fac4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Jul_2008_18_17_25_+1000_ZyEiaEcfmFiJMXgj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jul_2008_18_17_25_+1000_ZyEiaEcfmFiJMXgj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

It looks like Greg KH is collecting all the conflicts into the
driver-core tree and we should thank him for his sacrifice.  :-)

Changes since next-20080718:

Temporarily dropped tree: acpi (confusion about its source).

The s390 tree was not able to be fetched (network problem).

The net-current tree gained a build failure which has already been fixed
upstream.

The x86 tree lost a conflicts and its build problem.

The v4l-dvb tree lost a conflict.

The ide tree lost a large number of conflicts against Lunus' tree but
inherited a couple from the sparc tree.

The kvm tree lost a couple of conflicts.

The ocfs2 tree lost its conflicts against Linus' tree.

The net tree lost its conflicts.

The sparc tree lost its conflicts.

The vfs tree lost its conflicts with the mips and security-testing trees.

The rr tree lost tree of its conflicts.

The kmemcheck tree gained a conflict against the rr tree.

The ttydev tree gained a conflict against the usb tree.

I have also applied the following patches for known problems:

	sparc64: sysdev API change fallout

This tree fails to build for ARCH=3Dsparc (i.e. 32bit) with a 64bit gcc
v3.4.5 - it tries to use the 64bit header files.  This may be an artifact
of one of my merge fixups, but I don't actually think so.

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

We are up to 105 trees (counting Linus' and 14 trees of patches pending for
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
Applying net: fix schedule breakage
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
Merging md-current/for-2.6.26
Merging quilt/driver-core
CONFLICT (content): Merge conflict in arch/arm/kernel/time.c
CONFLICT (content): Merge conflict in arch/sparc64/kernel/pci.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in drivers/base/topology.c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd_eckd.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd_fba.c
CONFLICT (content): Merge conflict in drivers/s390/char/tape_core.c
CONFLICT (content): Merge conflict in drivers/s390/cio/device_fsm.c
CONFLICT (delete/modify): drivers/s390/cio/qdio.c deleted in HEAD and modif=
ied in quilt/driver-core. Version quilt/driver-core of drivers/s390/cio/qdi=
o.c left in tree.
CONFLICT (content): Merge conflict in drivers/s390/net/claw.c
CONFLICT (content): Merge conflict in drivers/s390/net/ctcm_main.c
CONFLICT (content): Merge conflict in drivers/s390/net/lcs.c
CONFLICT (content): Merge conflict in drivers/s390/net/netiucv.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_aux.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_def.h
CONFLICT (content): Merge conflict in include/linux/device.h
CONFLICT (content): Merge conflict in sound/pci/maestro3.c
CONFLICT (content): Merge conflict in sound/pci/ymfpci/ymfpci_main.c
$ git rm drivers/s390/cio/qdio.c
Applying scsi: fix fallout from the class_find_device API change
Applying scsi: fix fallout from KOBJ_NAME_LEN removal
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/gadget/ether.c
CONFLICT (delete/modify): drivers/usb/serial/io_fw_down3.h deleted in HEAD =
and modified in quilt/usb. Version quilt/usb of drivers/usb/serial/io_fw_do=
wn3.h left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/io_ti.c
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_3410.h deleted in HEAD a=
nd modified in quilt/usb. Version quilt/usb of drivers/usb/serial/ti_fw_341=
0.h left in tree.
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_5052.h deleted in HEAD a=
nd modified in quilt/usb. Version quilt/usb of drivers/usb/serial/ti_fw_505=
2.h left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/ti_usb_3410_5052.c
$ git reset --hard
$ git checkout -b tmp quilt/usb
Created commit d286310: Revert "USB: io_ti: FIrst cut at a big clean up"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/usb/gadget/ether.c
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_3410.h deleted in HEAD a=
nd modified in tmp. Version tmp of drivers/usb/serial/ti_fw_3410.h left in =
tree.
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_5052.h deleted in HEAD a=
nd modified in tmp. Version tmp of drivers/usb/serial/ti_fw_5052.h left in =
tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/ti_usb_3410_5052.c
$ git rm drivers/usb/serial/ti_fw_3410.h drivers/usb/serial/ti_fw_5052.h
Applying pci: usb fixup 1
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in drivers/acpi/processor_throttling.c
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
Applying pci: fix xen fallout from PM API change
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
CONFLICT (content): Merge conflict in include/Kbuild
Created commit 82e726b: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
CONFLICT (content): Merge conflict in include/asm-sparc/ide.h
CONFLICT (content): Merge conflict in include/asm-sparc64/ide.h
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging blackfin/for-linus
Merging nfsd/nfsd-next
CONFLICT (content): Merge conflict in net/sunrpc/svc.c
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
Merging quilt/m68k
Merging powerpc/next
Merging lblnet/master
Merging ext4/next
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging sparc/master
Merging galak/powerpc-next
CONFLICT (content): Merge conflict in drivers/net/fs_enet/fs_enet-main.c
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-yl-9200.c
CONFLICT (delete/modify): drivers/mtd/maps/mtx-1_flash.c deleted in HEAD an=
d modified in mtd/master. Version mtd/master of drivers/mtd/maps/mtx-1_flas=
h.c left in tree.
$ git rm drivers/mtd/maps/mtx-1_flash.c
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
CONFLICT (delete/modify): include/asm-sparc/namei.h deleted in vfs/for-next=
 and modified in HEAD. Version HEAD of include/asm-sparc/namei.h left in tr=
ee.
CONFLICT (delete/modify): include/asm-sparc64/namei.h deleted in vfs/for-ne=
xt and modified in HEAD. Version HEAD of include/asm-sparc64/namei.h left i=
n tree.
$ git rm include/asm-sparc/namei.h include/asm-sparc64/namei.h
Merging sound/master
Merging arm/devel
CONFLICT (rename/delete): Renamed arch/arm/configs/em_x270_defconfig->arch/=
sh/configs/sh7785lcr_defconfig in HEAD and deleted in arm/devel
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/net/tun.c
CONFLICT (content): Merge conflict in include/linux/if_tun.h
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
CONFLICT (content): Merge conflict in include/asm-sparc64/semaphore.h
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_attr.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mid.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
$ git reset --hard
$ git checkout -b tmp semaphore-removal/semaphore-removal
Created commit 8983ae6: Revert "Convert qla_os to use mutex instead of sema=
phore"
Created commit b4916b9: Revert "qla2xxx: Turn vport_sem into vport_mutex"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/for_andrew
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Makefile
Merging pcmcia/master
Merging battery/master
CONFLICT (content): Merge conflict in drivers/power/Kconfig
CONFLICT (content): Merge conflict in drivers/power/Makefile
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging m68knommu/for-next
Merging uclinux/for-next
Merging md/for-next
Merging cris/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging generic-ipi/auto-generic-ipi-next
Merging mips/mips-for-linux-next
Merging mfd/for-next
Merging hdlc/hdlc-next
CONFLICT (content): Merge conflict in drivers/net/wan/cosa.c
CONFLICT (content): Merge conflict in drivers/net/wan/pc300_drv.c
Merging drm/drm-next
CONFLICT (add/add): Merge conflict in drivers/gpu/Makefile
CONFLICT (add/add): Merge conflict in drivers/gpu/drm/i830/Makefile
CONFLICT (content): Merge conflict in include/Kbuild
CONFLICT (add/add): Merge conflict in include/drm/Kbuild
Merging voltage/reg-for-linus
Merging security-testing/next
Merging quilt/ttydev
CONFLICT (content): Merge conflict in drivers/usb/gadget/serial.c
CONFLICT (delete/modify): drivers/usb/serial/airprime.c deleted in HEAD and=
 modified in quilt/ttydev. Version quilt/ttydev of drivers/usb/serial/airpr=
ime.c left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/cp2101.c
CONFLICT (content): Merge conflict in drivers/usb/serial/ir-usb.c
CONFLICT (content): Merge conflict in drivers/usb/serial/usb-serial.c
$ git rm drivers/usb/serial/airprime.c
Applying usb: tty API change fallout
Applying sparc64: sysdev API change fallout

--Signature=_Mon__21_Jul_2008_18_17_25_+1000_ZyEiaEcfmFiJMXgj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiERhUACgkQjjKRsyhoI8wQBACfb8xCXPpMKeTpPrKAM6cMSr07
uW8AniLycL3JcrnviKEJGiG8PwiHocoh
=P7ip
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jul_2008_18_17_25_+1000_ZyEiaEcfmFiJMXgj--
