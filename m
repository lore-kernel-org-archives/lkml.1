Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYIPHej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYIPHej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYIPHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:34:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51131 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYIPHe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:34:28 -0400
Date: Tue, 16 Sep 2008 17:34:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for September 16
Message-Id: <20080916173415.14012569.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Sep_2008_17_34_15_+1000_Gv1.0tdAANI/5I1e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Sep_2008_17_34_15_+1000_Gv1.0tdAANI/5I1e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

News: I have added a file (Next/SHA1s) that contains the SHA1 of the head
of each merged tree.  Hopefully people will find it useful.

Changes since next-20080913:

New trees: scsi-post-merge and bdev (these are both rebased onto the end
of linux-next as they depend on some constituent trees).

The pxa tree gained a conflict against Linus' tree.

The x86 tree lost two conflicts.

The tip-core tree lost a build fix patch.

The kvm tree gained a conflict against the x86 tree.

The block tree gained a build fix patch.

The sparseirq tree gained a conflict against each of the kvm tree and the
x86 tree.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	fix IXGBE dependencies
	linux-next: net tree build failure (depca)
	linux-next: 3c509 build fix

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

We are up to 116 trees (counting Linus' and 14 trees of patches pending for
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
Merging dwmw2/master
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging quilt/m68k
Merging m68knommu/for-next
Merging mips/mips-for-linux-next
Merging parisc/master
CONFLICT (rename/delete): Renamed include/asm-parisc/a.out.h->arch/parisc/i=
nclude/asm/a.out.h in parisc/master and deleted in HEAD
$ git rm -f arch/parisc/include/asm/a.out.h
Merging powerpc/powerpc-next
Merging 4xx/next
Merging galak/powerpc-next
Merging pxa/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/corgi.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/spitz.c
CONFLICT (content): Merge conflict in drivers/spi/pxa2xx_spi.c
Applying pxa: LCD_CORGI is currently BROKEN
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in include/asm-x86/statfs.h
Applying x86: fix arch/x86/kernel/k8.c
Merging xtensa/master
Merging quilt/driver-core
Applying driver-core: atmel_cs.c fixup
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in include/asm-x86/smp.h
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in kernel/module.c
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in include/asm-x86/pda.h
CONFLICT (content): Merge conflict in kernel/fork.c
Merging timers/auto-timers-next
CONFLICT (delete/modify): arch/x86/kernel/apic_64.c deleted in timers/auto-=
timers-next and modified in HEAD. Version HEAD of arch/x86/kernel/apic_64.c=
 left in tree.
CONFLICT (content): Merge conflict in arch/x86/xen/spinlock.c
CONFLICT (content): Merge conflict in drivers/pci/probe.c
CONFLICT (content): Merge conflict in include/linux/pci_ids.h
$ git rm arch/x86/kernel/apic_64.c
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in drivers/pci/probe.c
Merging quilt/device-mapper
Merging hid/mm
CONFLICT (content): Merge conflict in drivers/hid/usbhid/hid-core.c
Applying HID: fix for warn() removal
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/stable
CONFLICT (content): Merge conflict in drivers/media/video/Kconfig
CONFLICT (content): Merge conflict in drivers/media/video/zr364xx.c
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in drivers/ide/pci/hpt366.c
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in drivers/misc/acer-wmi.c
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in arch/x86/kvm/i8254.c
CONFLICT (content): Merge conflict in include/asm-x86/kvm.h
CONFLICT (content): Merge conflict in include/asm-x86/msr-index.h
Merging dlm/next
Merging scsi/master
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/module.c
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in Documentation/edac.txt
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/base/class.c
CONFLICT (content): Merge conflict in drivers/ide/ide-disk.c
CONFLICT (content): Merge conflict in drivers/md/dm-mpath.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Applying block: fix build of mspro_block
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/scsi/qlogicpti.c
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/reg-for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/char/tty_io.c
CONFLICT (content): Merge conflict in drivers/char/vt.c
CONFLICT (content): Merge conflict in drivers/serial/68328serial.c
CONFLICT (content): Merge conflict in drivers/serial/8250.c
CONFLICT (content): Merge conflict in drivers/usb/serial/aircable.c
CONFLICT (content): Merge conflict in drivers/usb/serial/keyspan_pda.c
CONFLICT (content): Merge conflict in drivers/usb/serial/safe_serial.c
CONFLICT (content): Merge conflict in kernel/auditsc.c
Merging agp/agp-next
Merging creds/next-creds
CONFLICT (content): Merge conflict in drivers/net/wan/sbni.c
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_linux.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_inode.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.c
CONFLICT (content): Merge conflict in include/linux/capability.h
CONFLICT (add/add): Merge conflict in include/linux/cred.h
CONFLICT (content): Merge conflict in include/linux/security.h
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in security/commoncap.c
CONFLICT (content): Merge conflict in security/selinux/hooks.c
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
Merging oprofile/auto-oprofile-next
CONFLICT (content): Merge conflict in arch/x86/oprofile/nmi_int.c
Merging fastboot/auto-fastboot-next
CONFLICT (content): Merge conflict in include/linux/init.h
Merging sparseirq/auto-sparseirq-next
CONFLICT (content): Merge conflict in arch/x86/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/x86/kvm/vmx.h
CONFLICT (content): Merge conflict in drivers/pci/probe.c
CONFLICT (content): Merge conflict in include/asm-x86/msr-index.h
$ git checkout -b temp scsi-post-merge/master
Applying [SCSI] Add helper code so transport classes/driver can control que=
ueing (v3)
Applying [SCSI] qla4xxx: return SCSI_MLQUEUE_TARGET_BUSY when driver has de=
tected session error
Applying [SCSI] qla2xxx: return SCSI_MLQUEUE_TARGET_BUSY when driver has de=
tected rport error or race
Applying [SCSI] libiscsi: Use SCSI_MLQUEUE_TARGET_BUSY
Applying [SCSI] lpfc: use SCSI_MLQUEUE_TARGET_BUSY when catching the rport =
transition race
Applying [SCSI] fc class: unblock target after calling terminate callback (=
take 2)
Applying [SCSI] ibmvfc, qla2xxx, lpfc: remove scsi_target_unblock calls in =
terminate callbacks
Applying [SCSI] scsi: add transport host byte errors (v3)
Applying [SCSI] iscsi class, libiscsi and qla4xxx: convert to new transport=
 host byte values
Applying [SCSI] fc class: Add support for new transport errors
Applying [SCSI] qla2xxx: use new host byte transport errors.
Applying [SCSI] block: separate failfast into multiple bits.
Applying [SCSI] modify scsi to handle new fail fast flags.
Applying [SCSI] lpfc 8.2.8 : Add kernel-doc function headers
Applying [SCSI] lpfc 8.2.8 : Miscellaneous Discovery Fixes
Applying [SCSI] lpfc 8.2.8 : Update driver for new SLI-3 features
Applying [SCSI] lpfc 8.2.8 : Miscellaneous Bug Fixes
Applying [SCSI] lpfc 8.2.8 : Add new FCOE hardware support
Applying [SCSI] lpfc 8.2.8 : Add support for PCI-EEH permanent disabling
Applying [SCSI] lpfc 8.2.8 : Update driver to use new Host byte error code =
DID_TRANSPORT_DISRUPTED
Applying [SCSI] lpfc 8.2.8 : Add MSI-X support
Applying [SCSI] lpfc 8.2.8 : update driver version to 8.2.8
Applying scsi_dh_alua: remove REQ_NOMERGE
Applying lpfc 8.2.8 v2 : Revert target busy in favor of transport disrupted
Applying lpfc 8.2.8 v2 : Add sysfs control of target queue depth handling
Applying lpfc 8.2.8 v2 : Add statistical reporting control and additional f=
c vendor events
$ git checkout master
$ git checkout -b temp bdev/master
Applying [PATCH] introduce fmode_t, do annotations
Applying [PATCH] eliminate use of ->f_flags in block methods
Applying [PATCH] pass mode instead of file to sg_io()
Applying [PATCH] switch sg_scsi_ioctl() to passing fmode_t
Applying [PATCH] switch scsi_cmd_ioctl() to passing fmode_t
Applying [PATCH] lose the unused file argument in generic_ide_ioctl()
Applying [PATCH] lose unused arguments in dm ioctl callbacks
Applying [PATCH] move block_device_operations to blkdev.h
Applying [PATCH] switch cdrom_{open,release,ioctl} to sane APIs
Applying [PATCH] switch pktcdvd to blkdev_driver_ioctl()
Applying [PATCH] introduce __blkdev_driver_ioctl()
Applying [PATCH] don't mess with file in scsi_nonblockable_ioctl()
Applying [PATCH] beginning of methods conversion
Applying [PATCH] switch ubd
Applying [PATCH] switch DAC960
Applying [PATCH] switch amiflop
Applying [PATCH] switch aoeblk
Applying [PATCH] switch ataflop
Applying [PATCH] switch brd
Applying [PATCH] switch cciss
Applying [PATCH] switch cpqarray
Applying [PATCH] switch floppy
Applying [PATCH] switch loop
Applying [PATCH] switch nbd
Applying [PATCH] switch pcd
Applying [PATCH] switch pd
Applying [PATCH] switch pf
Applying [PATCH] switch pktdvdcd
Applying [PATCH] switch swim3
Applying [PATCH] switch ub
Applying [PATCH] switch viodasd
Applying [PATCH] switch virtio_blk
Applying [PATCH] switch xd
Applying [PATCH] switch xen
Applying [PATCH] switch xyspace
Applying [PATCH] switch z2ram
Applying [PATCH] switch gdrom
Applying [PATCH] switch viocd
Applying [PATCH] switch ide-cd
Applying [PATCH] switch ide-disk
Applying [PATCH] switch ide-floppy
Applying [PATCH] switch ide-tape
Applying [PATCH] switch dm
Applying [PATCH] switch md
Applying [PATCH] switch memstick
Applying [PATCH] switch i2o
Applying [PATCH] switch mmc
Applying [PATCH] switch mtd_blkdevs
Applying [PATCH] switch dasd
Applying [PATCH] switch dcssblk
Applying [PATCH] switch tape_block
Applying [PATCH] switch ide-scsi
Applying [PATCH] switch sd
Applying [PATCH] switch sr
Applying [PATCH] end of methods switch: remove the old ones
Applying [PATCH] trim file propagation in block/compat_ioctl.c
Applying [PATCH] kill the unused bsize on the send side of /dev/loop
Applying [PATCH] pass fmode_t to blkdev_put()
Applying [PATCH] propagate mode through open_bdev_excl/close_bdev_excl
Applying [PATCH] propagate mode through swsusp_close()
Applying [PATCH] remember mode of reiserfs journal
Applying [PATCH] sanitize blkdev_get() and friends
$ git checkout master
Applying sparc: qlogicpti fallout from sbus removal
Applying fix IXGBE dependencies
Applying linux-next: net tree build failure (depca)
Applying linux-next: 3c509 build fix

--Signature=_Tue__16_Sep_2008_17_34_15_+1000_Gv1.0tdAANI/5I1e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjPYXcACgkQjjKRsyhoI8zpEQCeJeU7htlieCSIQQGpifk5nwaT
3ZQAoIBRqzjXmNckD+e/hdXJ2tdCwF4S
=k8MO
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Sep_2008_17_34_15_+1000_Gv1.0tdAANI/5I1e--
