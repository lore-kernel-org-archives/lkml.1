Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYGCMga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYGCMga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYGCMgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:36:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43143 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbYGCMgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:36:18 -0400
Date: Thu, 3 Jul 2008 19:09:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 3
Message-Id: <20080703190948.8e7bceca.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Jul_2008_19_09_48_+1000_rAtdoS5Rlx6/_eQm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jul_2008_19_09_48_+1000_rAtdoS5Rlx6/_eQm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080702:

New trees:  kmemcheck and generic-ipi.

The pci tree gained a conflict against the driver-core tree.

The powerpc tree gained a conflict against the i2c tree.

The net tree gained a couple of conflicts against Linus' tree and the
wireless-current tree.

The wireless tree gained a couple of conflicts against the
wireless-current tree.

The rr tree lost its two build fixup patches but gained another conflict
against the sched tree.

The blk-removal tree lost its conflict with the s390 tree.

The kmemcheck tree gained conflicts against the ftrace, sched, and x86
trees.

The generic-ipi tree gained conflicts against the powerpc, kmemcheck and
net trees.  And had two build failures requiring a patch and a revert.

I have also applied the following patches for known problems (I assume
that these will be merged into their appropriate trees shortly):

	NFS: Fix the mount protocol defaults for binary mounts
	fix "ftrace: store mcount address in rec->ip"

There are several outstanding build failures due to structural changes in
the ttydev tree (see http://kisskb.ellerman.id.au/linux-next).

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

We are up to 101 trees (counting Linus' and 14 trees of patches pending for
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
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
CONFLICT (content): Merge conflict in kernel/Makefile
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in kernel/sched_rt.c
Applying sched: fix rculist split fallout
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_32.S
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
Applying acpi-acpi_numa_init-build-fix
Applying ia64, acpi: fix Altix boot breakage in ACPI
Applying acpi: fix boot breakage on Altix
Merging pci/linux-next
CONFLICT (delete/modify): arch/x86/kernel/setup_64.c deleted in HEAD and mo=
dified in pci/linux-next. Version pci/linux-next of arch/x86/kernel/setup_6=
4.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/pci/irq.c
CONFLICT (content): Merge conflict in arch/x86/pci/pci.h
CONFLICT (content): Merge conflict in drivers/pci/probe.c
CONFLICT (content): Merge conflict in include/linux/device.h
Applying pci: usb fixup 1
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Applying v4l-dvb: class_for_each_device API change fallout
Merging s390/features
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
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in arch/ia64/kernel/process.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
CONFLICT (content): Merge conflict in arch/x86/kernel/srat_32.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_core.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_throttling.c
CONFLICT (content): Merge conflict in drivers/acpi/sleep/main.c
CONFLICT (content): Merge conflict in include/asm-ia64/processor.h
CONFLICT (content): Merge conflict in include/asm-x86/processor.h
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
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/fsl_soc.c
CONFLICT (content): Merge conflict in drivers/macintosh/mediabay.c
Merging lblnet/master
Merging ext4/next
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging security-testing/next
Merging net/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in Documentation/powerpc/booting-without=
-of.txt
CONFLICT (content): Merge conflict in drivers/net/fs_enet/fs_enet-main.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-4965=
.c
Merging sparc/master
CONFLICT (content): Merge conflict in include/asm-m68k/sbus.h
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-4965=
.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl3945-=
base.c
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging sound/master
Merging arm/devel
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-yl-9200.c
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/char/hvc_console.h
CONFLICT (content): Merge conflict in kernel/stop_machine.c
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
CONFLICT (content): Merge conflict in fs/nfs/file.c
Merging trivial/next
Merging ubifs/for_andrew
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/atm/Makefile
CONFLICT (content): Merge conflict in drivers/char/ip2/ip2main.c
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Makefile
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
Merging kgdb/kgdb-next
Merging slab/for-next
Merging m68knommu/for-next
Merging uclinux/for-next
Merging md/for-next
Merging cris/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in arch/x86/mm/Makefile
CONFLICT (content): Merge conflict in include/asm-x86/pgtable.h
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging generic-ipi/auto-generic-ipi-next
CONFLICT (content): Merge conflict in arch/powerpc/mm/slice.c
CONFLICT (content): Merge conflict in arch/s390/kernel/time.c
CONFLICT (content): Merge conflict in arch/x86/kvm/vmx.c
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/sched_rt.c
CONFLICT (content): Merge conflict in net/iucv/iucv.c
CONFLICT (content): Merge conflict in virt/kvm/kvm_main.c
Applying generic-ipi: powerpc fallout fixes
Created commit 8285f95: Revert "x86, 64-bit: split set_pte_vaddr()"
$ git quiltimport --author "Alan Cox <alan@lxorguk.ukuu.org.uk>" --patches =
"../quilt/ttydev"
Applying NFS: Fix the mount protocol defaults for binary mounts
Applying fix "ftrace: store mcount address in rec->ip"
Applying ttydev: fix pamc_zilog for tty pointer move
Applying ttydev: sparc fix for tty move
Applying ttydev: sparc32 fix for tty move

--Signature=_Thu__3_Jul_2008_19_09_48_+1000_rAtdoS5Rlx6/_eQm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhsl1wACgkQjjKRsyhoI8xtEwCfUAGnMYzkt1fmqBhOriTj7pUD
MOYAn2h0fMcMOcMjvdCxCM7NFVCbbEwQ
=iOHP
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jul_2008_19_09_48_+1000_rAtdoS5Rlx6/_eQm--
