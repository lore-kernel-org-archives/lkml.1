Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYGQP3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYGQP3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYGQP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:28:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43361 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbYGQP2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:28:52 -0400
Date: Fri, 18 Jul 2008 01:28:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 17
Message-Id: <20080718012842.690b8346.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Jul_2008_01_28_42_+1000_LwmwnEe__=hHnLnN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jul_2008_01_28_42_+1000_LwmwnEe__=hHnLnN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080716:

Temporarily dropped tree: ttydev (it gets too many patch failures).

Changed trees: the security-testing tree was moved later in the merge in
anticipation of majo merge problems that have been delayed.
	The vfs tree changed branch names.

Most of the differences were conflicts moving from tree to tree as some
of the trees are now merged into Linus' tree.  Most have been inflicted
on the driver-core and usb trees.  I have not notified these separately.

Because of the moving of conflicts around it is difficult to tell when
they are going away (though I assume some are).

The driver-core tree gained two build fixes from the scsi tree (since
that went into Linus' tree).

The usb tree gained a conflict from the firmware tree (ditto).

The x86 tree gained an expected conflict against the stackprotector and a
build failure that required a revert of a commit.

The pci tree needed another build fix patch.

The ide tree had more conflicts with its parts that have been merged into
Linus' tree.

The acpi had various merge problems - maybe because I am pulling a
different tree than what was merged into Linus' tree.

The galak tree gained a conflict against the net tree.

The ubifs tree also had merge problems because a different version was
sent to Linus.

I have also applied the following patches for known problems:

	sparc64: sysdev API change fallout

This tree fails to build for ARCH=3Dsparc (i.e. 32bit) with a 64bit gcc
v3.4.5 - it tries to use the 64bit header files.  This may be an artifact
of one of my merge fixups, but I don't actually think so.

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
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_aux.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_def.h
CONFLICT (content): Merge conflict in sound/pci/maestro3.c
CONFLICT (content): Merge conflict in sound/pci/ymfpci/ymfpci_main.c
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
Created commit 2546c30: Revert "USB: io_ti: FIrst cut at a big clean up"
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
Created commit 9757c27: Revert "x86: consolidate header guards"
Merging pci/linux-next
CONFLICT (content): Merge conflict in arch/sparc64/kernel/pci.c
CONFLICT (delete/modify): arch/x86/kernel/setup_64.c deleted in HEAD and mo=
dified in pci/linux-next. Version pci/linux-next of arch/x86/kernel/setup_6=
4.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/pci/irq.c
CONFLICT (content): Merge conflict in arch/x86/pci/pci.h
CONFLICT (content): Merge conflict in drivers/acpi/sleep/main.c
CONFLICT (content): Merge conflict in drivers/pci/pci.c
CONFLICT (content): Merge conflict in drivers/pci/pci.h
CONFLICT (content): Merge conflict in include/acpi/acpi_bus.h
CONFLICT (content): Merge conflict in include/linux/device.h
Applying pci: usb fixup 1
Applying pci: fix xen fallout from PM API change
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
Created commit 03e7ffad: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
CONFLICT (content): Merge conflict in drivers/ide/Kconfig
CONFLICT (content): Merge conflict in drivers/ide/arm/icside.c
CONFLICT (content): Merge conflict in drivers/ide/arm/palm_bk3710.c
CONFLICT (content): Merge conflict in drivers/ide/arm/rapide.c
CONFLICT (content): Merge conflict in drivers/ide/h8300/ide-h8300.c
CONFLICT (content): Merge conflict in drivers/ide/ide-pnp.c
CONFLICT (content): Merge conflict in drivers/ide/ide-probe.c
CONFLICT (content): Merge conflict in drivers/ide/ide.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/buddha.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/falconide.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/gayle.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/ide-4drives.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/ide-cs.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/ide_platform.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/macide.c
CONFLICT (content): Merge conflict in drivers/ide/legacy/q40ide.c
CONFLICT (content): Merge conflict in drivers/ide/mips/au1xxx-ide.c
CONFLICT (content): Merge conflict in drivers/ide/mips/swarm.c
CONFLICT (content): Merge conflict in drivers/ide/pci/amd74xx.c
CONFLICT (content): Merge conflict in drivers/ide/pci/cmd640.c
CONFLICT (content): Merge conflict in drivers/ide/pci/cs5535.c
CONFLICT (content): Merge conflict in drivers/ide/pci/delkin_cb.c
CONFLICT (content): Merge conflict in drivers/ide/pci/scc_pata.c
CONFLICT (content): Merge conflict in drivers/ide/pci/sgiioc4.c
CONFLICT (content): Merge conflict in drivers/ide/pci/sis5513.c
CONFLICT (content): Merge conflict in drivers/ide/pci/via82cxxx.c
CONFLICT (content): Merge conflict in drivers/ide/ppc/pmac.c
CONFLICT (content): Merge conflict in drivers/ide/setup-pci.c
CONFLICT (content): Merge conflict in include/linux/ide.h
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (rename/modify): Merge conflict in arch/x86/mm/srat_32.c
CONFLICT (content): Merge conflict in Documentation/ABI/testing/sysfs-firmw=
are-acpi
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/sleep.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
CONFLICT (content): Merge conflict in drivers/acpi/executer/exdump.c
CONFLICT (content): Merge conflict in drivers/acpi/hardware/hwgpe.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_throttling.c
CONFLICT (content): Merge conflict in drivers/acpi/scan.c
CONFLICT (content): Merge conflict in drivers/acpi/sleep/main.c
CONFLICT (content): Merge conflict in drivers/acpi/system.c
CONFLICT (content): Merge conflict in drivers/acpi/video.c
CONFLICT (content): Merge conflict in drivers/char/apm-emulation.c
CONFLICT (content): Merge conflict in drivers/misc/Kconfig
CONFLICT (add/add): Merge conflict in drivers/misc/compal-laptop.c
CONFLICT (content): Merge conflict in drivers/misc/fujitsu-laptop.c
CONFLICT (content): Merge conflict in drivers/pci/pci.c
CONFLICT (content): Merge conflict in drivers/pci/pci.h
CONFLICT (content): Merge conflict in include/acpi/acconfig.h
CONFLICT (content): Merge conflict in include/acpi/acexcep.h
CONFLICT (content): Merge conflict in include/acpi/acmacros.h
CONFLICT (content): Merge conflict in include/acpi/acpi_bus.h
CONFLICT (content): Merge conflict in include/acpi/actbl1.h
CONFLICT (content): Merge conflict in include/acpi/actypes.h
CONFLICT (content): Merge conflict in include/linux/ioport.h
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
CONFLICT (add/add): Merge conflict in fs/ubifs/budget.c
CONFLICT (add/add): Merge conflict in fs/ubifs/debug.c
CONFLICT (add/add): Merge conflict in fs/ubifs/dir.c
CONFLICT (add/add): Merge conflict in fs/ubifs/file.c
CONFLICT (add/add): Merge conflict in fs/ubifs/io.c
CONFLICT (add/add): Merge conflict in fs/ubifs/journal.c
CONFLICT (add/add): Merge conflict in fs/ubifs/shrinker.c
CONFLICT (add/add): Merge conflict in fs/ubifs/tnc.c
CONFLICT (add/add): Merge conflict in fs/ubifs/xattr.c
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
Merging generic-ipi/auto-generic-ipi-next
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
Merging security-testing/next
Applying sparc64: sysdev API change fallout

--Signature=_Fri__18_Jul_2008_01_28_42_+1000_LwmwnEe__=hHnLnN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh/ZSoACgkQjjKRsyhoI8yd1wCglaOWnI3yRj1wynQ2AapxY6Hb
5ggAn2i96X+w2rGcumTt8Nlwi0Aw4P44
=XdFE
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jul_2008_01_28_42_+1000_LwmwnEe__=hHnLnN--
