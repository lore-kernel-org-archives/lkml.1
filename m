Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYGOOkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYGOOkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbYGOOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:39:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56070 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbYGOOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:39:48 -0400
Date: Wed, 16 Jul 2008 00:39:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 15
Message-Id: <20080716003937.7b72cefb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Jul_2008_00_39_37_+1000_GazQ+0uAUC3jVaAm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jul_2008_00_39_37_+1000_GazQ+0uAUC3jVaAm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080714:

Removed tree: selinux (it is now contained in the security-testing tree).

Most of the differences were conflicts moving from tree to tree as some
of the tress are now merged into Linus' tree.  Most have been inflicted
on the driver-core tree.  I have not notified these separately.

The x86 tree gained a conflict against Linus' tree.

The sound tree gained a conflict against Linus' tree.

The mips tree gained a conflict against the mtd tree.

I have also applied the following patches for known problems:

	sparc64: sysdev API change fallout
	s390: fix compile error due to smp_call_function
	powerpc: mman.h export fixups
	powerpc/stacktrace: EXPORT SYMBOL_GPL needs module.h

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
CONFLICT (content): Merge conflict in drivers/usb/core/hcd.c
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging quilt/driver-core
CONFLICT (content): Merge conflict in arch/arm/kernel/time.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in drivers/base/topology.c
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
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/core/hub.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/ether.c
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in kernel/sched_rt.c
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
Created commit 29e0e1c: Revert "Revert "x86: introduce max_low_pfn_mapped f=
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
Applying pci: include linux/pm_wakeup.h for device_set_wakeup_capable
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Applying v4l-dvb: class_for_each_device API change fallout
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
CONFLICT (content): Merge conflict in include/Kbuild
Created commit ae498e5: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
CONFLICT (content): Merge conflict in fs/nfs/file.c
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (rename/modify): Merge conflict in arch/x86/mm/srat_32.c
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
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
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
CONFLICT (content): Merge conflict in drivers/net/fs_enet/fs_enet-main.c
CONFLICT (content): Merge conflict in drivers/pci/pci-acpi.c
CONFLICT (content): Merge conflict in net/netfilter/nf_conntrack_proto_tcp.c
Merging sparc/master
Merging galak/powerpc-next
CONFLICT (content): Merge conflict in Documentation/powerpc/booting-without=
-of.txt
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-yl-9200.c
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
CONFLICT (content): Merge conflict in sound/soc/pxa/pxa2xx-i2s.c
Merging arm/devel
CONFLICT (rename/delete): Renamed arch/arm/configs/em_x270_defconfig->arch/=
sh/configs/sh7763rdp_defconfig in HEAD and deleted in arm/devel
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/char/hvc_console.h
CONFLICT (content): Merge conflict in kernel/stop_machine.c
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging cifs/master
Merging mmc/next
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
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/for_andrew
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/atm/Makefile
CONFLICT (content): Merge conflict in drivers/char/dsp56k.c
CONFLICT (content): Merge conflict in drivers/char/ip2/ip2main.c
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Makefile
CONFLICT (delete/modify): drivers/usb/serial/io_fw_down3.h deleted in firmw=
are/master and modified in HEAD. Version HEAD of drivers/usb/serial/io_fw_d=
own3.h left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/io_ti.c
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_3410.h deleted in firmwa=
re/master and modified in HEAD. Version HEAD of drivers/usb/serial/ti_fw_34=
10.h left in tree.
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_5052.h deleted in firmwa=
re/master and modified in HEAD. Version HEAD of drivers/usb/serial/ti_fw_50=
52.h left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/ti_usb_3410_5052.c
CONFLICT (content): Merge conflict in sound/pci/maestro3.c
CONFLICT (content): Merge conflict in sound/pci/ymfpci/ymfpci_main.c
$ git reset --hard
$ git checkout -b tmp firmware/master
CONFLICT (content): Merge conflict in firmware/WHENCE
mark the corrected paths with 'git add <paths>' or 'git rm <paths>' and com=
mit the result.
Created commit fd72133: Revert "edgeport-ti: use request_firmware()"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/atm/Makefile
CONFLICT (content): Merge conflict in drivers/char/dsp56k.c
CONFLICT (content): Merge conflict in drivers/char/ip2/ip2main.c
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Makefile
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_3410.h deleted in tmp an=
d modified in HEAD. Version HEAD of drivers/usb/serial/ti_fw_3410.h left in=
 tree.
CONFLICT (delete/modify): drivers/usb/serial/ti_fw_5052.h deleted in tmp an=
d modified in HEAD. Version HEAD of drivers/usb/serial/ti_fw_5052.h left in=
 tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/ti_usb_3410_5052.c
CONFLICT (content): Merge conflict in sound/pci/maestro3.c
CONFLICT (content): Merge conflict in sound/pci/ymfpci/ymfpci_main.c
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
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging generic-ipi/auto-generic-ipi-next
CONFLICT (content): Merge conflict in arch/powerpc/mm/slice.c
CONFLICT (content): Merge conflict in arch/s390/kernel/time.c
CONFLICT (content): Merge conflict in arch/x86/kvm/vmx.c
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in net/iucv/iucv.c
CONFLICT (content): Merge conflict in virt/kvm/kvm_main.c
Applying generic-ipi: powerpc fallout fixes
Merging mips/mips-for-linux-next
CONFLICT (delete/modify): drivers/mtd/maps/mtx-1_flash.c deleted in mips/mi=
ps-for-linux-next and modified in HEAD. Version HEAD of drivers/mtd/maps/mt=
x-1_flash.c left in tree.
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
$ git quiltimport --author "Alan Cox <alan@lxorguk.ukuu.org.uk>" --patches =
"../quilt/ttydev"
Applying sparc64: sysdev API change fallout
Applying s390: fix compile error due to smp_call_function
Applying powerpc: mman.h export fixups
Applying powerpc/stacktrace: EXPORT SYMBOL_GPL needs module.h

--Signature=_Wed__16_Jul_2008_00_39_37_+1000_GazQ+0uAUC3jVaAm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh8tqkACgkQjjKRsyhoI8yDagCfUBytxK7FhnvnDkg1M/2otx4b
LlYAn3HdBtBQunAGRZxPMJZVGIBR+JCM
=eknH
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jul_2008_00_39_37_+1000_GazQ+0uAUC3jVaAm--
