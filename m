Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYGPNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYGPNuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYGPNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:50:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46530 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbYGPNuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:50:23 -0400
Date: Wed, 16 Jul 2008 23:50:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 16
Message-Id: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Jul_2008_23_50_11_+1000_OXgDpxwiXTdcYVXv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jul_2008_23_50_11_+1000_OXgDpxwiXTdcYVXv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080715:

Temporarily dropped tree: ttydev (it gets too many patch failures).

Most of the differences were conflicts moving from tree to tree as some
of the trees are now merged into Linus' tree.  Most have been inflicted
on the driver-core and usb trees.  I have not notified these separately.

Because of the moving of conflicts around it is difficult to tell when
they are going away (though I assume some are).

The usb.current tree lost its conflict against Linus' tree.

The usb tree gained a conflict against Linus' tree.

The cpus4096 tree gained a conflict against Linus' tree.

The pci tree lost one of its build fix patches.

The i2c tree lost a conflict against Linus' tree.

The ide tree gained a lot of conflicts against Linus' tree because part
of it was merged into Linus' tree but the remaining pat modified many of
the same files further.

The acpi tree gained a conflict against Linus' tree.

The net tree gained a conflict against each of Linus' tree and the
powerpc tree.

The sparc tree gained conflicts against Linus' tree and the ide and
sparc-current trees.

The rr tree gained conflict against the net tree.

The semaphore tree gained a conflict against the sparc tree.

The generic-ipi tree gained a conflict against the powerpc tree.

The ttydev series had many patches fail to apply, so it was dropped for
today.

I have also applied the following patches for known problems:

	sparc64: sysdev API change fallout

Patches no longer necessary:

	s390: fix compile error due to smp_call_function
	powerpc: mman.h export fixups
	powerpc/stacktrace: EXPORT SYMBOL_GPL needs module.h

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
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in drivers/base/topology.c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd_eckd.c
CONFLICT (content): Merge conflict in drivers/s390/block/dasd_fba.c
CONFLICT (content): Merge conflict in drivers/s390/char/tape_core.c
CONFLICT (content): Merge conflict in drivers/s390/cio/device_fsm.c
CONFLICT (content): Merge conflict in drivers/s390/cio/qdio.c
CONFLICT (content): Merge conflict in drivers/s390/net/claw.c
CONFLICT (content): Merge conflict in drivers/s390/net/ctcm_main.c
CONFLICT (content): Merge conflict in drivers/s390/net/lcs.c
CONFLICT (content): Merge conflict in drivers/s390/net/netiucv.c
CONFLICT (content): Merge conflict in sound/pci/maestro3.c
CONFLICT (content): Merge conflict in sound/pci/ymfpci/ymfpci_main.c
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
Created commit 094e2d2: Revert "USB: io_ti: FIrst cut at a big clean up"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/usb/gadget/ether.c
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_3410.h deleted in HEAD a=
nd modified in tmp. Version tmp of drivers/usb/serial/ti_fw_3410.h left in =
tree.
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_5052.h deleted in HEAD a=
nd modified in tmp. Version tmp of drivers/usb/serial/ti_fw_5052.h left in =
tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/ti_usb_3410_5052.c
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in arch/x86/xen/smp.c
CONFLICT (content): Merge conflict in kernel/sched_rt.c
CONFLICT (content): Merge conflict in net/iucv/iucv.c
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/amd_64.c
CONFLICT (content): Merge conflict in arch/x86/mm/pageattr.c
CONFLICT (content): Merge conflict in arch/x86/mm/pat.c
CONFLICT (content): Merge conflict in arch/x86/pci/i386.c
$ git reset --hard
$ git checkout -b tmp x86/auto-x86-next
Created commit 5a8d263: Revert "Revert "x86: introduce max_low_pfn_mapped f=
or 64-bit""
$ git checkout master
Merging pci/linux-next
CONFLICT (content): Merge conflict in arch/sparc64/kernel/pci.c
CONFLICT (delete/modify): arch/x86/kernel/setup_64.c deleted in HEAD and mo=
dified in pci/linux-next. Version pci/linux-next of arch/x86/kernel/setup_6=
4.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/pci/irq.c
CONFLICT (content): Merge conflict in arch/x86/pci/pci.h
CONFLICT (content): Merge conflict in include/linux/device.h
Applying pci: usb fixup 1
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Applying v4l-dvb: class_for_each_device API change fallout
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
CONFLICT (content): Merge conflict in include/Kbuild
Created commit 10f999b: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
CONFLICT (rename/modify): Merge conflict in drivers/ide/ide-timings.c
CONFLICT (content): Merge conflict in drivers/ide/Kconfig
CONFLICT (content): Merge conflict in drivers/ide/Makefile
CONFLICT (content): Merge conflict in drivers/ide/arm/palm_bk3710.c
CONFLICT (add/add): Merge conflict in drivers/ide/ide-atapi.c
CONFLICT (content): Merge conflict in drivers/ide/ide-cd.c
CONFLICT (content): Merge conflict in drivers/ide/ide-cd_ioctl.c
CONFLICT (content): Merge conflict in drivers/ide/ide-floppy.c
CONFLICT (content): Merge conflict in drivers/ide/ide-io.c
CONFLICT (content): Merge conflict in drivers/ide/ide-iops.c
CONFLICT (content): Merge conflict in drivers/ide/ide-probe.c
CONFLICT (content): Merge conflict in drivers/ide/ide-tape.c
CONFLICT (content): Merge conflict in drivers/ide/ide-taskfile.c
CONFLICT (content): Merge conflict in drivers/ide/ide.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/ali14xx.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/gayle.c
CONFLICT (content): Merge conflict in drivers/ide/pci/aec62xx.c
CONFLICT (content): Merge conflict in drivers/ide/pci/amd74xx.c
CONFLICT (content): Merge conflict in drivers/ide/pci/cmd64x.c
CONFLICT (content): Merge conflict in drivers/ide/pci/scc_pata.c
CONFLICT (content): Merge conflict in drivers/ide/pci/via82cxxx.c
CONFLICT (content): Merge conflict in drivers/ide/ppc/pmac.c
CONFLICT (content): Merge conflict in drivers/ide/setup-pci.c
CONFLICT (content): Merge conflict in drivers/scsi/ide-scsi.c
CONFLICT (content): Merge conflict in include/linux/ide.h
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (rename/modify): Merge conflict in arch/x86/mm/srat_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/sleep.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_throttling.c
CONFLICT (content): Merge conflict in drivers/acpi/sleep/main.c
CONFLICT (content): Merge conflict in drivers/pci/pci.c
CONFLICT (content): Merge conflict in drivers/pci/pci.h
CONFLICT (content): Merge conflict in include/acpi/acpi_bus.h
Merging blackfin/for-linus
Merging nfsd/nfsd-next
CONFLICT (content): Merge conflict in net/sunrpc/svc.c
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
Merging kvm/master
CONFLICT (content): Merge conflict in arch/x86/kvm/vmx.c
CONFLICT (content): Merge conflict in virt/kvm/kvm_main.c
Merging dlm/next
Merging scsi/master
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_aux.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_def.h
Applying scsi: fix fallout from the class_find_device API change
Applying scsi: fix fallout from KOBJ_NAME_LEN removal
Merging ia64/test
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging quilt/m68k
Merging powerpc/next
CONFLICT (content): Merge conflict in drivers/macintosh/mediabay.c
Merging lblnet/master
Merging ext4/next
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging security-testing/next
Merging net/master
CONFLICT (content): Merge conflict in Documentation/powerpc/booting-without=
-of.txt
CONFLICT (content): Merge conflict in drivers/atm/Makefile
CONFLICT (content): Merge conflict in drivers/net/fs_enet/fs_enet-main.c
CONFLICT (content): Merge conflict in drivers/pci/pci-acpi.c
CONFLICT (content): Merge conflict in net/8021q/vlan.c
CONFLICT (content): Merge conflict in net/iucv/iucv.c
Merging sparc/master
CONFLICT (content): Merge conflict in include/asm-sparc/ide.h
CONFLICT (content): Merge conflict in include/asm-sparc/smp.h
CONFLICT (content): Merge conflict in include/asm-sparc64/ide.h
CONFLICT (content): Merge conflict in include/asm-sparc64/mmu.h
CONFLICT (content): Merge conflict in include/asm-sparc64/page.h
CONFLICT (content): Merge conflict in include/asm-sparc64/pgtable.h
Merging galak/powerpc-next
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-yl-9200.c
CONFLICT (delete/modify): drivers/mtd/maps/mtx-1_flash.c deleted in HEAD an=
d modified in mtd/master. Version mtd/master of drivers/mtd/maps/mtx-1_flas=
h.c left in tree.
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
Merging arm/devel
CONFLICT (rename/delete): Renamed arch/arm/configs/em_x270_defconfig->arch/=
sh/configs/sh7763rdp_defconfig in HEAD and deleted in arm/devel
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/char/hvc_console.h
CONFLICT (content): Merge conflict in drivers/net/tun.c
CONFLICT (content): Merge conflict in include/linux/if_tun.h
CONFLICT (content): Merge conflict in kernel/stop_machine.c
CONFLICT (content): Merge conflict in kernel/sysctl.c
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
CONFLICT (content): Merge conflict in drivers/video/backlight/Kconfig
CONFLICT (content): Merge conflict in drivers/video/backlight/Makefile
Merging kgdb/kgdb-next
Merging slab/for-next
Merging m68knommu/for-next
Merging uclinux/for-next
Merging md/for-next
Merging cris/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in arch/x86/mm/Makefile
CONFLICT (content): Merge conflict in include/asm-x86/pgtable.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging generic-ipi/auto-generic-ipi-next
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/x86/kernel/irqinit_64.c
Merging mips/mips-for-linux-next
Merging mfd/for-next
Merging hdlc/hdlc-next
CONFLICT (content): Merge conflict in drivers/net/wan/cosa.c
CONFLICT (content): Merge conflict in drivers/net/wan/hdlc_fr.c
CONFLICT (content): Merge conflict in drivers/net/wan/pc300_drv.c
Merging drm/drm-next
CONFLICT (add/add): Merge conflict in drivers/gpu/Makefile
CONFLICT (add/add): Merge conflict in drivers/gpu/drm/i830/Makefile
CONFLICT (content): Merge conflict in include/Kbuild
CONFLICT (add/add): Merge conflict in include/drm/Kbuild
Merging voltage/reg-for-linus
Applying sparc64: sysdev API change fallout

--Signature=_Wed__16_Jul_2008_23_50_11_+1000_OXgDpxwiXTdcYVXv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh9/JMACgkQjjKRsyhoI8wXZQCfbRH16WOwIVx+Ql8Yzl8P1XHj
gE8Ani3UZjZZsBrj1NtbBqL9fvGp76zK
=sA0X
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jul_2008_23_50_11_+1000_OXgDpxwiXTdcYVXv--
