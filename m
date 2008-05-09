Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYEJIk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYEJIk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 04:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYEJIks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 04:40:48 -0400
Received: from host86-133-226-39.range86-133.btcentralplus.com ([86.133.226.39]:39029
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYEJIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 04:40:40 -0400
X-Greylist: delayed 32638 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 May 2008 04:40:38 EDT
Message-ID: <4824E002.3020704@oak.selfip.net>
Date: Sat, 10 May 2008 00:36:34 +0100
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Build warning g28a4acb: include/asm/string_32.h:65: warning: array
 subscript is above array bounds
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040501050502090100080004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040501050502090100080004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

    Warning I haven't seen before in todays kernel
(2.6.26-rc1-279-g28a4acb) build:

drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':
include/asm/string_32.h:65: warning: array subscript is above array
bounds

    Recently upgraded (?) to gcc 4.3.0.

$ sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux s1 2.6.26-rc1-00179-g3de2403 #149 Thu May 8 08:04:11 BST 2008
i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

Gnu C                  4.3.0
Gnu make               3.81
binutils               2.18
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.40.8
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
oprofile               0.9.3
Sh-utils               6.10
udev                   119

    Full build log below and .config attached.

Fri May  9 13:00:01 BST 2008
Building: /home/tla/git/linux-2.6
Checking out branch: master
Switched to branch "master"
New version detected: v2.6.26-rc1-279-g28a4acb (old:
v2.6.26-rc1-179-g3de2403)
Switched to a new branch "dh-v2.6.26-rc1-279-g28a4acb"
Compiling new version
scripts/kconfig/conf -s arch/x86/Kconfig
#
# configuration written to .config
#
    CHK     include/linux/version.h
    CHK     include/linux/utsrelease.h
    UPD     include/linux/utsrelease.h
    CALL    scripts/checksyscalls.sh
    CC      init/main.o
    CHK     include/linux/compile.h
    CC      init/version.o
    CC      init/do_mounts.o
    CC      init/do_mounts_md.o
    LD      init/mounts.o
    LD      init/built-in.o
    CC      arch/x86/kernel/process_32.o
    CC      arch/x86/kernel/traps_32.o
    CC      arch/x86/kernel/time_32.o
    CC      arch/x86/kernel/ldt.o
    CC      arch/x86/kernel/setup_32.o
    CC      arch/x86/kernel/sys_i386_32.o
    CC      arch/x86/kernel/bootflag.o
    CC      arch/x86/kernel/pci-dma.o
    CC      arch/x86/kernel/kdebugfs.o
    CC      arch/x86/kernel/rtc.o
    CC      arch/x86/kernel/ptrace.o
    CC      arch/x86/kernel/acpi/boot.o
    CC      arch/x86/kernel/acpi/sleep.o
    CC      arch/x86/kernel/acpi/cstate.o
    CC      arch/x86/kernel/acpi/processor.o
    LD      arch/x86/kernel/acpi/built-in.o
    CC      arch/x86/kernel/cpu/common.o
    CC      arch/x86/kernel/cpu/mtrr/if.o
    LD      arch/x86/kernel/cpu/mtrr/built-in.o
    LD      arch/x86/kernel/cpu/built-in.o
    CC      arch/x86/kernel/reboot.o
    CC      arch/x86/kernel/cpuid.o
    CC      arch/x86/kernel/early-quirks.o
    CC      arch/x86/kernel/mpparse.o
    CC      arch/x86/kernel/apic_32.o
    CC      arch/x86/kernel/nmi_32.o
    CC      arch/x86/kernel/io_apic_32.o
    CC      arch/x86/kernel/doublefault_32.o
    CC      arch/x86/kernel/vm86_32.o
    CC      arch/x86/kernel/pcspeaker.o
    LD      arch/x86/kernel/built-in.o
    CC      arch/x86/kernel/init_task.o
    CC      arch/x86/mm/init_32.o
    CC      arch/x86/mm/fault.o
    CC      arch/x86/mm/ioremap.o
    CC      arch/x86/mm/pageattr.o
    CC      arch/x86/mm/pat.o
    CC      arch/x86/mm/pgtable.o
    CC      arch/x86/mm/pgtable_32.o
    LD      arch/x86/mm/built-in.o
    CC      kernel/sched.o
kernel/sched.c:1216: warning: 'init_hrtick' defined but not used
    CC      kernel/fork.o
    CC      kernel/printk.o
    CC      kernel/profile.o
    CC      kernel/exit.o
    CC      kernel/time.o
    CC      kernel/resource.o
    CC      kernel/sysctl.o
    CC      kernel/capability.o
    CC      kernel/ptrace.o
    CC      kernel/signal.o
    CC      kernel/sys.o
    CC      kernel/kmod.o
    CC      kernel/semaphore.o
    CC      kernel/pm_qos_params.o
    CC      kernel/irq/proc.o
    LD      kernel/irq/built-in.o
    CC      kernel/power/console.o
    LD      kernel/power/built-in.o
    CC      kernel/time/timer_list.o
    LD      kernel/time/built-in.o
    CC      kernel/lockdep.o
kernel/lockdep.c:554: warning: 'print_lock_dependencies' defined but
not used
    CC      kernel/lockdep_proc.o
    CC      kernel/futex.o
    CC      kernel/dma.o
    CC      kernel/uid16.o
    CC      kernel/kallsyms.o
    GZIP    kernel/config_data.gz
    IKCFG   kernel/config_data.h
    CC      kernel/configs.o
    LD      kernel/built-in.o
    CC      mm/filemap.o
    CC      mm/mempool.o
    CC      mm/fadvise.o
    CC      mm/page_alloc.o
    CC      mm/page-writeback.o
    CC      mm/pdflush.o
    CC      mm/readahead.o
    CC      mm/swap.o
    CC      mm/truncate.o
    CC      mm/vmscan.o
    CC      mm/backing-dev.o
    CC      mm/fremap.o
    CC      mm/highmem.o
    CC      mm/madvise.o
    CC      mm/memory.o
    CC      mm/mincore.o
    CC      mm/mmap.o
mm/mmap.c: In function 'insert_vm_struct':
mm/mmap.c:2079: warning: 'rb_parent' may be used uninitialized in
this function
mm/mmap.c:2079: warning: 'rb_link' may be used uninitialized in this
function
mm/mmap.c:2078: warning: 'prev' may be used uninitialized in this
function
mm/mmap.c: In function 'copy_vma':
mm/mmap.c:2118: warning: 'rb_parent' may be used uninitialized in
this function
mm/mmap.c:2118: warning: 'rb_link' may be used uninitialized in this
function
mm/mmap.c:2117: warning: 'prev' may be used uninitialized in this
function
mm/mmap.c: In function 'do_brk':
mm/mmap.c:1945: warning: 'rb_parent' may be used uninitialized in
this function
mm/mmap.c:1945: warning: 'rb_link' may be used uninitialized in this
function
mm/mmap.c:1943: warning: 'prev' may be used uninitialized in this
function
mm/mmap.c: In function 'mmap_region':
mm/mmap.c:1086: warning: 'rb_parent' may be used uninitialized in
this function
mm/mmap.c:1086: warning: 'rb_link' may be used uninitialized in this
function
mm/mmap.c:1083: warning: 'prev' may be used uninitialized in this
function
    CC      mm/mprotect.o
    CC      mm/mremap.o
    CC      mm/msync.o
    CC      mm/rmap.o
    CC      mm/vmalloc.o
    CC      mm/pagewalk.o
    CC      mm/bounce.o
    CC      mm/page_io.o
    CC      mm/swap_state.o
    CC      mm/swapfile.o
    CC      mm/shmem.o
    CC      mm/shmem_acl.o
    LD      mm/built-in.o
    CC      fs/open.o
    CC      fs/read_write.o
    CC      fs/file_table.o
    CC      fs/super.o
    CC      fs/char_dev.o
    CC      fs/stat.o
    CC      fs/exec.o
    CC      fs/pipe.o
    CC      fs/namei.o
    CC      fs/fcntl.o
    CC      fs/ioctl.o
    CC      fs/readdir.o
    CC      fs/select.o
    CC      fs/fifo.o
    CC      fs/locks.o
    CC      fs/dcache.o
    CC      fs/inode.o
    CC      fs/attr.o
    CC      fs/bad_inode.o
    CC      fs/file.o
    CC      fs/filesystems.o
    CC      fs/namespace.o
    CC      fs/aio.o
    CC      fs/seq_file.o
    CC      fs/xattr.o
    CC      fs/libfs.o
    CC      fs/fs-writeback.o
    CC      fs/pnode.o
    CC      fs/drop_caches.o
    CC      fs/splice.o
    CC      fs/sync.o
    CC      fs/utimes.o
    CC      fs/stack.o
    CC      fs/buffer.o
    CC      fs/bio.o
    CC      fs/block_dev.o
    CC      fs/direct-io.o
    CC      fs/mpage.o
    CC      fs/ioprio.o
    CC      fs/eventpoll.o
    CC      fs/anon_inodes.o
    CC      fs/signalfd.o
    CC      fs/timerfd.o
    CC      fs/eventfd.o
    CC      fs/binfmt_misc.o
    CC      fs/binfmt_script.o
    CC      fs/binfmt_elf.o
    CC      fs/posix_acl.o
    CC      fs/xattr_acl.o
    CC      fs/generic_acl.o
    CC      fs/cifs/cifsfs.o
    CC      fs/cifs/cifssmb.o
    CC      fs/cifs/cifs_debug.o
    CC      fs/cifs/connect.o
    CC      fs/cifs/dir.o
fs/cifs/dir.c: In function 'cifs_ci_compare':
fs/cifs/dir.c:583: warning: passing argument 1 of
'__constant_memcpy' discards qualifiers from pointer target type
fs/cifs/dir.c:583: warning: passing argument 1 of '__memcpy'
discards qualifiers from pointer target type
    CC      fs/cifs/file.o
    CC      fs/cifs/inode.o
    CC      fs/cifs/link.o
    CC      fs/cifs/misc.o
    CC      fs/cifs/netmisc.o
    CC      fs/cifs/smbencrypt.o
    CC      fs/cifs/transport.o
    CC      fs/cifs/asn1.o
    CC      fs/cifs/md4.o
    CC      fs/cifs/cifs_unicode.o
    CC      fs/cifs/nterr.o
    CC      fs/cifs/xattr.o
    CC      fs/cifs/cifsencrypt.o
    CC      fs/cifs/fcntl.o
    CC      fs/cifs/readdir.o
    CC      fs/cifs/ioctl.o
    CC      fs/cifs/sess.o
    CC      fs/cifs/export.o
    CC      fs/cifs/cifsacl.o
    LD      fs/cifs/cifs.o
    LD      fs/cifs/built-in.o
    CC      fs/configfs/inode.o
    CC      fs/configfs/file.o
    CC      fs/configfs/dir.o
    CC      fs/configfs/symlink.o
    CC      fs/configfs/mount.o
    LD      fs/configfs/configfs.o
    LD      fs/configfs/built-in.o
    CC      fs/devpts/inode.o
    LD      fs/devpts/devpts.o
    LD      fs/devpts/built-in.o
    CC      fs/ext2/balloc.o
    CC      fs/ext2/dir.o
    CC      fs/ext2/file.o
    CC      fs/ext2/fsync.o
    CC      fs/ext2/ialloc.o
    CC      fs/ext2/inode.o
    CC      fs/ext2/ioctl.o
    CC      fs/ext2/namei.o
    CC      fs/ext2/super.o
    CC      fs/ext2/symlink.o
    LD      fs/ext2/ext2.o
    LD      fs/ext2/built-in.o
    CC      fs/ext3/balloc.o
    CC      fs/ext3/bitmap.o
    CC      fs/ext3/dir.o
    CC      fs/ext3/file.o
    CC      fs/ext3/fsync.o
    CC      fs/ext3/ialloc.o
    CC      fs/ext3/inode.o
    CC      fs/ext3/ioctl.o
    CC      fs/ext3/namei.o
    CC      fs/ext3/super.o
    CC      fs/ext3/symlink.o
    CC      fs/ext3/hash.o
    CC      fs/ext3/resize.o
    CC      fs/ext3/ext3_jbd.o
    LD      fs/ext3/ext3.o
    LD      fs/ext3/built-in.o
    CC      fs/isofs/namei.o
    CC      fs/isofs/inode.o
    CC      fs/isofs/dir.o
    CC      fs/isofs/util.o
    CC      fs/isofs/rock.o
    CC      fs/isofs/export.o
    CC      fs/isofs/joliet.o
    LD      fs/isofs/isofs.o
    LD      fs/isofs/built-in.o
    CC      fs/jbd/transaction.o
    CC      fs/jbd/commit.o
    CC      fs/jbd/recovery.o
    CC      fs/jbd/checkpoint.o
    CC      fs/jbd/revoke.o
    CC      fs/jbd/journal.o
    LD      fs/jbd/jbd.o
    LD      fs/jbd/built-in.o
    CC      fs/partitions/check.o
fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:381: warning: ignoring return value of
'device_add', declared with attribute warn_unused_result
    CC      fs/partitions/msdos.o
    LD      fs/partitions/built-in.o
    CC      fs/proc/mmu.o
    CC      fs/proc/task_mmu.o
    CC      fs/proc/inode.o
    CC      fs/proc/root.o
    CC      fs/proc/base.o
    CC      fs/proc/generic.o
    CC      fs/proc/array.o
    CC      fs/proc/proc_tty.o
    CC      fs/proc/proc_misc.o
    CC      fs/proc/proc_sysctl.o
    CC      fs/proc/proc_net.o
    CC      fs/proc/kmsg.o
    LD      fs/proc/proc.o
    LD      fs/proc/built-in.o
    CC      fs/ramfs/inode.o
    CC      fs/ramfs/file-mmu.o
    LD      fs/ramfs/ramfs.o
    LD      fs/ramfs/built-in.o
    CC      fs/sysfs/inode.o
    CC      fs/sysfs/file.o
    CC      fs/sysfs/dir.o
    CC      fs/sysfs/symlink.o
    CC      fs/sysfs/mount.o
    CC      fs/sysfs/bin.o
    LD      fs/sysfs/built-in.o
    CC      fs/udf/balloc.o
    CC      fs/udf/dir.o
    CC      fs/udf/file.o
    CC      fs/udf/ialloc.o
    CC      fs/udf/inode.o
    CC      fs/udf/lowlevel.o
    CC      fs/udf/namei.o
    CC      fs/udf/partition.o
    CC      fs/udf/super.o
    CC      fs/udf/truncate.o
    CC      fs/udf/symlink.o
    CC      fs/udf/fsync.o
    CC      fs/udf/directory.o
    CC      fs/udf/misc.o
    CC      fs/udf/udftime.o
    CC      fs/udf/unicode.o
    LD      fs/udf/udf.o
    LD      fs/udf/built-in.o
    LD      fs/built-in.o
    CC      ipc/util.o
    CC      ipc/msgutil.o
    CC      ipc/msg.o
    CC      ipc/sem.o
    CC      ipc/shm.o
    CC      ipc/mqueue.o
    LD      ipc/built-in.o
    CC      security/commoncap.o
    LD      security/built-in.o
    CC      crypto/api.o
    CC      crypto/cipher.o
    CC      crypto/digest.o
    CC      crypto/compress.o
    CC      crypto/algapi.o
    CC      crypto/scatterwalk.o
    CC      crypto/proc.o
    CC      crypto/ablkcipher.o
    CC      crypto/blkcipher.o
    CC      crypto/eseqiv.o
    CC      crypto/hash.o
    LD      crypto/crypto.o
    LD      crypto/crypto_algapi.o
    CC      crypto/aead.o
    LD      crypto/crypto_blkcipher.o
    LD      crypto/crypto_hash.o
    CC      crypto/cryptomgr.o
    CC      crypto/hmac.o
    CC      crypto/cts.o
    CC      crypto/authenc.o
    LD      crypto/built-in.o
    CC      block/elevator.o
    CC      block/blk-core.o
    CC      block/blk-tag.o
    CC      block/blk-sysfs.o
    CC      block/blk-barrier.o
    CC      block/blk-settings.o
    CC      block/blk-ioc.o
    CC      block/blk-map.o
    CC      block/blk-exec.o
    CC      block/blk-merge.o
    CC      block/ioctl.o
    CC      block/genhd.o
block/genhd.c: In function 'add_disk':
block/genhd.c:195: warning: ignoring return value of
'sysfs_create_link', declared with attribute warn_unused_result
    CC      block/scsi_ioctl.o
    CC      block/bsg.o
    CC      block/noop-iosched.o
    CC      block/deadline-iosched.o
    CC      block/cfq-iosched.o
    LD      block/built-in.o
    CC      drivers/acpi/tables.o
    CC      drivers/acpi/blacklist.o
    CC      drivers/acpi/osl.o
    CC      drivers/acpi/utils.o
    CC      drivers/acpi/sleep/wakeup.o
    CC      drivers/acpi/sleep/main.o
    CC      drivers/acpi/sleep/proc.o
    LD      drivers/acpi/sleep/built-in.o
    CC      drivers/acpi/bus.o
    CC      drivers/acpi/glue.o
    CC      drivers/acpi/scan.o
    CC      drivers/acpi/ec.o
    CC      drivers/acpi/button.o
    CC      drivers/acpi/fan.o
    CC      drivers/acpi/pci_root.o
    CC      drivers/acpi/pci_link.o
    CC      drivers/acpi/pci_irq.o
    CC      drivers/acpi/pci_bind.o
    CC      drivers/acpi/power.o
    CC      drivers/acpi/processor_core.o
    CC      drivers/acpi/processor_throttling.o
    CC      drivers/acpi/processor_idle.o
    CC      drivers/acpi/processor_thermal.o
    LD      drivers/acpi/processor.o
    CC      drivers/acpi/thermal.o
    CC      drivers/acpi/system.o
    CC      drivers/acpi/event.o
    LD      drivers/acpi/built-in.o
    CC      drivers/base/core.o
    CC      drivers/base/class.o
    LD      drivers/base/built-in.o
    CC      drivers/cdrom/cdrom.o
    LD      drivers/cdrom/built-in.o
    CC      drivers/char/mem.o
    CC      drivers/char/random.o
    CC      drivers/char/tty_io.o
    CC      drivers/char/n_tty.o
    CC      drivers/char/tty_ioctl.o
    CC      drivers/char/pty.o
    CC      drivers/char/misc.o
    CC      drivers/char/vt_ioctl.o
    CC      drivers/char/vc_screen.o
    CC      drivers/char/consolemap.o
    CC      drivers/char/selection.o
    CC      drivers/char/keyboard.o
    CC      drivers/char/vt.o
    CC      drivers/char/sysrq.o
    LD      drivers/char/built-in.o
    CC      drivers/firmware/dmi_scan.o
    LD      drivers/firmware/built-in.o
    CC      drivers/ide/ide-cd.o
    CC      drivers/ide/ide-cd_ioctl.o
    CC      drivers/ide/ide-cd_verbose.o
    CC      drivers/ide/ide.o
    CC      drivers/ide/ide-io.o
    CC      drivers/ide/ide-iops.o
    CC      drivers/ide/ide-lib.o
    CC      drivers/ide/ide-probe.o
    CC      drivers/ide/ide-taskfile.o
    CC      drivers/ide/setup-pci.o
    CC      drivers/ide/ide-dma.o
    LD      drivers/ide/ide-core.o
    CC      drivers/ide/pci/piix.o
    CC      drivers/ide/pci/generic.o
    LD      drivers/ide/pci/ide-pci-generic.o
    LD      drivers/ide/pci/built-in.o
    CC      drivers/ide/ide-disk.o
    LD      drivers/ide/ide-cd_mod.o
    LD      drivers/ide/built-in.o
    CC      drivers/input/input.o
    CC      drivers/input/ff-core.o
    LD      drivers/input/input-core.o
    CC      drivers/input/mousedev.o
    CC      drivers/input/evdev.o
    CC      drivers/input/keyboard/atkbd.o
    LD      drivers/input/keyboard/built-in.o
    CC      drivers/input/mouse/psmouse-base.o
    CC      drivers/input/mouse/synaptics.o
    CC      drivers/input/mouse/alps.o
    CC      drivers/input/mouse/logips2pp.o
    CC      drivers/input/mouse/lifebook.o
    CC      drivers/input/mouse/trackpoint.o
    LD      drivers/input/mouse/psmouse.o
    LD      drivers/input/mouse/built-in.o
    LD      drivers/input/built-in.o
    CC      drivers/input/serio/libps2.o
    LD      drivers/input/serio/built-in.o
    CC      drivers/md/raid1.o
    CC      drivers/md/dm-raid1.o
    CC      drivers/md/dm.o
    CC      drivers/md/dm-table.o
    CC      drivers/md/dm-target.o
    CC      drivers/md/dm-linear.o
    CC      drivers/md/dm-stripe.o
    CC      drivers/md/dm-ioctl.o
    CC      drivers/md/dm-io.o
    CC      drivers/md/dm-kcopyd.o
    CC      drivers/md/md.o
    CC      drivers/md/bitmap.o
    LD      drivers/md/md-mod.o
    LD      drivers/md/dm-mod.o
    CC      drivers/md/dm-crypt.o
    LD      drivers/md/dm-mirror.o
    CC      drivers/md/dm-log.o
    LD      drivers/md/built-in.o
    LD      drivers/media/common/tuners/built-in.o
    LD      drivers/media/common/built-in.o
    LD      drivers/media/built-in.o
    CC      drivers/net/loopback.o
    CC      drivers/net/tun.o
    LD      drivers/net/built-in.o
    CC      drivers/pci/bus.o
    CC      drivers/pci/quirks.o
    CC      drivers/pci/proc.o
    CC      drivers/pci/pci-acpi.o
    LD      drivers/pci/built-in.o
    CC      drivers/pnp/isapnp/proc.o
    LD      drivers/pnp/isapnp/built-in.o
    CC      drivers/pnp/pnpacpi/core.o
    CC      drivers/pnp/pnpacpi/rsparser.o
    LD      drivers/pnp/pnpacpi/built-in.o
    CC      drivers/pnp/pnpbios/core.o
    CC      drivers/pnp/pnpbios/proc.o
    LD      drivers/pnp/pnpbios/built-in.o
    LD      drivers/pnp/built-in.o
    CC      drivers/scsi/scsi.o
    CC      drivers/scsi/hosts.o
    CC      drivers/scsi/scsi_ioctl.o
    CC      drivers/scsi/constants.o
    CC      drivers/scsi/scsicam.o
    CC      drivers/scsi/scsi_error.o
    CC      drivers/scsi/scsi_lib.o
    CC      drivers/scsi/scsi_lib_dma.o
    CC      drivers/scsi/scsi_scan.o
    CC      drivers/scsi/scsi_sysfs.o
    CC      drivers/scsi/scsi_devinfo.o
    LD      drivers/scsi/scsi_mod.o
    CC      drivers/scsi/raid_class.o
    CC      drivers/scsi/scsi_transport_spi.o
    LD      drivers/scsi/built-in.o
    CC      drivers/usb/core/usb.o
    CC      drivers/usb/core/hub.o
    CC      drivers/usb/core/hcd.o
drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':
include/asm/string_32.h:65: warning: array subscript is above array
bounds
    CC      drivers/usb/core/urb.o
    CC      drivers/usb/core/message.o
    CC      drivers/usb/core/driver.o
    CC      drivers/usb/core/config.o
    CC      drivers/usb/core/file.o
    CC      drivers/usb/core/buffer.o
    CC      drivers/usb/core/sysfs.o
    CC      drivers/usb/core/endpoint.o
    CC      drivers/usb/core/devio.o
    CC      drivers/usb/core/notify.o
    CC      drivers/usb/core/generic.o
    CC      drivers/usb/core/quirks.o
    CC      drivers/usb/core/hcd-pci.o
    CC      drivers/usb/core/inode.o
    CC      drivers/usb/core/devices.o
    LD      drivers/usb/core/usbcore.o
    LD      drivers/usb/core/built-in.o
    CC      drivers/usb/host/pci-quirks.o
    CC      drivers/usb/host/ehci-hcd.o
    CC      drivers/usb/host/ohci-hcd.o
    CC      drivers/usb/host/uhci-hcd.o
    LD      drivers/usb/host/built-in.o
    CC      drivers/usb/storage/scsiglue.o
    CC      drivers/usb/storage/protocol.o
    CC      drivers/usb/storage/transport.o
    CC      drivers/usb/storage/usb.o
    CC      drivers/usb/storage/initializers.o
    LD      drivers/usb/storage/usb-storage.o
    LD      drivers/usb/storage/built-in.o
    LD      drivers/usb/built-in.o
    CC      drivers/video/fb_notify.o
    CC      drivers/video/console/dummycon.o
    CC      drivers/video/console/vgacon.o
    LD      drivers/video/console/built-in.o
    LD      drivers/video/built-in.o
    LD      drivers/built-in.o
    CC      arch/x86/pci/mmconfig_32.o
    CC      arch/x86/pci/mmconfig-shared.o
    CC      arch/x86/pci/acpi.o
    CC      arch/x86/pci/irq.o
    CC      arch/x86/pci/common.o
    LD      arch/x86/pci/built-in.o
    CC      net/socket.o
    CC      net/8021q/vlan_dev.o
    CC      net/8021q/vlanproc.o
    LD      net/8021q/8021q.o
    LD      net/8021q/built-in.o
    CC      net/bridge/br_forward.o
    CC      net/bridge/br_if.o
    CC      net/bridge/br_input.o
    CC      net/bridge/br_stp_bpdu.o
    CC      net/bridge/br_netlink.o
    CC      net/bridge/br_netfilter.o
    LD      net/bridge/bridge.o
    LD      net/bridge/built-in.o
    CC      net/core/sock.o
    CC      net/core/request_sock.o
    CC      net/core/skbuff.o
    CC      net/core/iovec.o
    CC      net/core/datagram.o
    CC      net/core/stream.o
    CC      net/core/scm.o
    CC      net/core/gen_estimator.o
    CC      net/core/sysctl_net_core.o
    CC      net/core/dev.o
    CC      net/core/dev_mcast.o
    CC      net/core/neighbour.o
    CC      net/core/rtnetlink.o
    CC      net/core/utils.o
    CC      net/core/link_watch.o
    CC      net/core/filter.o
    CC      net/core/flow.o
    CC      net/core/net-sysfs.o
    CC      net/core/netpoll.o
    LD      net/core/built-in.o
    CC      net/ethernet/eth.o
    LD      net/ethernet/built-in.o
    CC      net/ipv4/route.o
    CC      net/ipv4/inetpeer.o
    CC      net/ipv4/protocol.o
    CC      net/ipv4/ip_input.o
    CC      net/ipv4/ip_fragment.o
    CC      net/ipv4/ip_forward.o
    CC      net/ipv4/ip_options.o
    CC      net/ipv4/ip_output.o
    CC      net/ipv4/ip_sockglue.o
    CC      net/ipv4/inet_hashtables.o
    CC      net/ipv4/inet_timewait_sock.o
    CC      net/ipv4/inet_connection_sock.o
    CC      net/ipv4/tcp.o
    CC      net/ipv4/tcp_input.o
    CC      net/ipv4/tcp_output.o
    CC      net/ipv4/tcp_timer.o
    CC      net/ipv4/tcp_ipv4.o
    CC      net/ipv4/tcp_minisocks.o
    CC      net/ipv4/tcp_cong.o
    CC      net/ipv4/datagram.o
    CC      net/ipv4/raw.o
    CC      net/ipv4/udp.o
    CC      net/ipv4/udplite.o
    CC      net/ipv4/arp.o
    CC      net/ipv4/icmp.o
    CC      net/ipv4/devinet.o
    CC      net/ipv4/af_inet.o
    CC      net/ipv4/igmp.o
    CC      net/ipv4/fib_frontend.o
    CC      net/ipv4/fib_semantics.o
    CC      net/ipv4/sysctl_net_ipv4.o
    CC      net/ipv4/fib_hash.o
    CC      net/ipv4/proc.o
    CC      net/ipv4/ipmr.o
    CC      net/ipv4/syncookies.o
    CC      net/ipv4/ah4.o
    CC      net/ipv4/esp4.o
    CC      net/ipv4/ipcomp.o
    CC      net/ipv4/xfrm4_tunnel.o
    CC      net/ipv4/inet_lro.o
    CC      net/ipv4/tunnel4.o
    CC      net/ipv4/xfrm4_mode_transport.o
    CC      net/ipv4/xfrm4_mode_tunnel.o
    CC      net/ipv4/netfilter.o
    CC      net/ipv4/netfilter/nf_nat_rule.o
    CC      net/ipv4/netfilter/nf_nat_standalone.o
    CC      net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o
    CC      net/ipv4/netfilter/nf_conntrack_proto_icmp.o
    CC      net/ipv4/netfilter/nf_nat_core.o
    CC      net/ipv4/netfilter/nf_nat_helper.o
    CC      net/ipv4/netfilter/nf_nat_proto_unknown.o
    CC      net/ipv4/netfilter/nf_nat_proto_common.o
    CC      net/ipv4/netfilter/nf_nat_proto_tcp.o
    CC      net/ipv4/netfilter/nf_nat_proto_udp.o
    CC      net/ipv4/netfilter/nf_nat_proto_icmp.o
    LD      net/ipv4/netfilter/nf_conntrack_ipv4.o
    LD      net/ipv4/netfilter/nf_nat.o
    CC      net/ipv4/netfilter/nf_nat_ftp.o
    CC      net/ipv4/netfilter/ip_tables.o
    CC      net/ipv4/netfilter/iptable_filter.o
    CC      net/ipv4/netfilter/iptable_mangle.o
    LD      net/ipv4/netfilter/iptable_nat.o
    CC      net/ipv4/netfilter/iptable_raw.o
    CC      net/ipv4/netfilter/ipt_addrtype.o
    CC      net/ipv4/netfilter/ipt_ah.o
    CC      net/ipv4/netfilter/ipt_ecn.o
    CC      net/ipv4/netfilter/ipt_recent.o
    CC      net/ipv4/netfilter/ipt_ttl.o
    CC      net/ipv4/netfilter/ipt_LOG.o
    CC      net/ipv4/netfilter/ipt_MASQUERADE.o
    CC      net/ipv4/netfilter/ipt_NETMAP.o
    CC      net/ipv4/netfilter/ipt_REDIRECT.o
    CC      net/ipv4/netfilter/ipt_REJECT.o
    CC      net/ipv4/netfilter/ipt_TTL.o
    CC      net/ipv4/netfilter/ipt_ULOG.o
    CC      net/ipv4/netfilter/arp_tables.o
    CC      net/ipv4/netfilter/arpt_mangle.o
    CC      net/ipv4/netfilter/arptable_filter.o
    LD      net/ipv4/netfilter/built-in.o
    CC      net/ipv4/inet_diag.o
    CC      net/ipv4/tcp_diag.o
    CC      net/ipv4/tcp_bic.o
    CC      net/ipv4/tcp_cubic.o
    CC      net/ipv4/tcp_westwood.o
    CC      net/ipv4/tcp_highspeed.o
    CC      net/ipv4/tcp_htcp.o
    CC      net/ipv4/xfrm4_policy.o
    CC      net/ipv4/xfrm4_state.o
    CC      net/ipv4/xfrm4_input.o
    CC      net/ipv4/xfrm4_output.o
    LD      net/ipv4/built-in.o
    CC      net/ipv6/af_inet6.o
    CC      net/ipv6/anycast.o
    CC      net/ipv6/ip6_output.o
    CC      net/ipv6/ip6_input.o
    CC      net/ipv6/addrconf.o
    CC      net/ipv6/addrlabel.o
    CC      net/ipv6/route.o
    CC      net/ipv6/ip6_fib.o
    CC      net/ipv6/ipv6_sockglue.o
    CC      net/ipv6/ndisc.o
    CC      net/ipv6/udp.o
    CC      net/ipv6/udplite.o
    CC      net/ipv6/raw.o
    CC      net/ipv6/protocol.o
    CC      net/ipv6/icmp.o
    CC      net/ipv6/mcast.o
    CC      net/ipv6/reassembly.o
    CC      net/ipv6/tcp_ipv6.o
    CC      net/ipv6/exthdrs.o
    CC      net/ipv6/datagram.o
    CC      net/ipv6/ip6_flowlabel.o
    CC      net/ipv6/inet6_connection_sock.o
    CC      net/ipv6/sysctl_net_ipv6.o
    CC      net/ipv6/xfrm6_policy.o
    CC      net/ipv6/xfrm6_state.o
    CC      net/ipv6/xfrm6_input.o
    CC      net/ipv6/xfrm6_output.o
    CC      net/ipv6/netfilter.o
    CC      net/ipv6/proc.o
    CC      net/ipv6/syncookies.o
    LD      net/ipv6/ipv6.o
    CC      net/ipv6/ah6.o
    CC      net/ipv6/esp6.o
    CC      net/ipv6/ipcomp6.o
    CC      net/ipv6/xfrm6_tunnel.o
    CC      net/ipv6/tunnel6.o
    CC      net/ipv6/xfrm6_mode_transport.o
    CC      net/ipv6/xfrm6_mode_tunnel.o
    CC      net/ipv6/netfilter/ip6_tables.o
    CC      net/ipv6/netfilter/ip6table_filter.o
    CC      net/ipv6/netfilter/ip6table_mangle.o
    CC      net/ipv6/netfilter/ip6table_raw.o
    CC      net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.o
    CC      net/ipv6/netfilter/nf_conntrack_proto_icmpv6.o
    CC      net/ipv6/netfilter/nf_conntrack_reasm.o
    LD      net/ipv6/netfilter/nf_conntrack_ipv6.o
    CC      net/ipv6/netfilter/ip6t_ah.o
    CC      net/ipv6/netfilter/ip6t_eui64.o
    CC      net/ipv6/netfilter/ip6t_frag.o
    CC      net/ipv6/netfilter/ip6t_hl.o
    CC      net/ipv6/netfilter/ip6t_ipv6header.o
    CC      net/ipv6/netfilter/ip6t_mh.o
    CC      net/ipv6/netfilter/ip6t_hbh.o
    CC      net/ipv6/netfilter/ip6t_rt.o
    CC      net/ipv6/netfilter/ip6t_HL.o
    CC      net/ipv6/netfilter/ip6t_LOG.o
    CC      net/ipv6/netfilter/ip6t_REJECT.o
    LD      net/ipv6/netfilter/built-in.o
    CC      net/ipv6/sit.o
    CC      net/ipv6/addrconf_core.o
    CC      net/ipv6/exthdrs_core.o
    CC      net/ipv6/inet6_hashtables.o
    LD      net/ipv6/built-in.o
    CC      net/key/af_key.o
    LD      net/key/built-in.o
    CC      net/netfilter/core.o
    CC      net/netfilter/nf_log.o
    CC      net/netfilter/nf_queue.o
    CC      net/netfilter/nf_sockopt.o
    CC      net/netfilter/nf_conntrack_core.o
    CC      net/netfilter/nf_conntrack_standalone.o
    CC      net/netfilter/nf_conntrack_expect.o
    CC      net/netfilter/nf_conntrack_helper.o
    CC      net/netfilter/nf_conntrack_proto.o
    CC      net/netfilter/nf_conntrack_l3proto_generic.o
    CC      net/netfilter/nf_conntrack_proto_generic.o
    CC      net/netfilter/nf_conntrack_proto_tcp.o
    CC      net/netfilter/nf_conntrack_proto_udp.o
    CC      net/netfilter/nf_conntrack_extend.o
    CC      net/netfilter/nf_conntrack_ecache.o
    LD      net/netfilter/netfilter.o
    CC      net/netfilter/nfnetlink.o
    CC      net/netfilter/nfnetlink_queue.o
    CC      net/netfilter/nfnetlink_log.o
    LD      net/netfilter/nf_conntrack.o
    CC      net/netfilter/nf_conntrack_netlink.o
    CC      net/netfilter/nf_conntrack_ftp.o
    CC      net/netfilter/x_tables.o
    CC      net/netfilter/xt_tcpudp.o
    CC      net/netfilter/xt_CLASSIFY.o
    CC      net/netfilter/xt_CONNMARK.o
    CC      net/netfilter/xt_CONNSECMARK.o
    CC      net/netfilter/xt_DSCP.o
    CC      net/netfilter/xt_MARK.o
    CC      net/netfilter/xt_NFLOG.o
    CC      net/netfilter/xt_NFQUEUE.o
    CC      net/netfilter/xt_NOTRACK.o
    CC      net/netfilter/xt_RATEEST.o
    CC      net/netfilter/xt_SECMARK.o
    CC      net/netfilter/xt_TCPMSS.o
    CC      net/netfilter/xt_TCPOPTSTRIP.o
    CC      net/netfilter/xt_TRACE.o
    CC      net/netfilter/xt_comment.o
    CC      net/netfilter/xt_connbytes.o
    CC      net/netfilter/xt_connlimit.o
    CC      net/netfilter/xt_connmark.o
    CC      net/netfilter/xt_conntrack.o
    CC      net/netfilter/xt_dccp.o
    CC      net/netfilter/xt_dscp.o
    CC      net/netfilter/xt_esp.o
    CC      net/netfilter/xt_hashlimit.o
    CC      net/netfilter/xt_helper.o
    CC      net/netfilter/xt_iprange.o
    CC      net/netfilter/xt_length.o
    CC      net/netfilter/xt_limit.o
    CC      net/netfilter/xt_mac.o
    CC      net/netfilter/xt_mark.o
    CC      net/netfilter/xt_multiport.o
    CC      net/netfilter/xt_owner.o
    CC      net/netfilter/xt_physdev.o
    CC      net/netfilter/xt_pkttype.o
    CC      net/netfilter/xt_policy.o
    CC      net/netfilter/xt_quota.o
    CC      net/netfilter/xt_rateest.o
    CC      net/netfilter/xt_realm.o
    CC      net/netfilter/xt_sctp.o
    CC      net/netfilter/xt_state.o
    CC      net/netfilter/xt_statistic.o
    CC      net/netfilter/xt_string.o
    CC      net/netfilter/xt_tcpmss.o
    CC      net/netfilter/xt_time.o
    CC      net/netfilter/xt_u32.o
    LD      net/netfilter/built-in.o
    CC      net/netlink/af_netlink.o
    CC      net/netlink/genetlink.o
    LD      net/netlink/built-in.o
    CC      net/packet/af_packet.o
    LD      net/packet/built-in.o
    CC      net/sched/sch_api.o
    CC      net/sched/cls_api.o
    CC      net/sched/sch_red.o
    CC      net/sched/sch_gred.o
    CC      net/sched/sch_dsmark.o
    CC      net/sched/sch_sfq.o
    CC      net/sched/cls_route.o
    CC      net/sched/cls_rsvp.o
    CC      net/sched/cls_rsvp6.o
    CC      net/sched/cls_flow.o
    LD      net/sched/built-in.o
    CC      net/unix/af_unix.o
    CC      net/unix/garbage.o
    CC      net/unix/sysctl_net_unix.o
    LD      net/unix/unix.o
    LD      net/unix/built-in.o
    CC      net/xfrm/xfrm_policy.o
    CC      net/xfrm/xfrm_state.o
    CC      net/xfrm/xfrm_input.o
    CC      net/xfrm/xfrm_output.o
    CC      net/xfrm/xfrm_algo.o
    CC      net/xfrm/xfrm_user.o
    LD      net/xfrm/built-in.o
    CC      net/sysctl_net.o
    LD      net/built-in.o
    CC      lib/bust_spinlocks.o
    CC      lib/scatterlist.o
    LD      lib/built-in.o
    CC      lib/kobject_uevent.o
    AR      lib/lib.a
    CC      arch/x86/lib/usercopy_32.o
    AR      arch/x86/lib/lib.a
    LD      vmlinux.o
    MODPOST vmlinux.o
    GEN     .version
    CHK     include/linux/compile.h
    UPD     include/linux/compile.h
    CC      init/version.o
    LD      init/built-in.o
    LD      .tmp_vmlinux1
    KSYM    .tmp_kallsyms1.S
    AS      .tmp_kallsyms1.o
    LD      .tmp_vmlinux2
    KSYM    .tmp_kallsyms2.S
    AS      .tmp_kallsyms2.o
    LD      vmlinux
    SYSMAP  System.map
    SYSMAP  .tmp_System.map
    OBJCOPY arch/x86/boot/compressed/vmlinux.bin
    GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
    LD      arch/x86/boot/compressed/piggy.o
    LD      arch/x86/boot/compressed/vmlinux
    OFFSETS arch/x86/boot/offsets.h
    AS      arch/x86/boot/header.o
    CC      arch/x86/boot/version.o
    LD      arch/x86/boot/setup.elf
    OBJCOPY arch/x86/boot/setup.bin
    OBJCOPY arch/x86/boot/vmlinux.bin
    BUILD   arch/x86/boot/bzImage
Root device is (9, 4)
Setup is 11164 bytes (padded to 11264 bytes).
System is 2208 kB
CRC ed760340
Kernel: arch/x86/boot/bzImage is ready  (#150)

real	21m38.070s
user	16m37.942s
sys	2m8.308s
-rw-r--r-- 1 tla tla  631840 May  9 13:24 /boot/System.map
-rw-r--r-- 1 tla tla 2272048 May  9 13:24 /boot/kernel-latest





--------------040501050502090100080004
Content-Type: text/plain;
 name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26-rc1
# Fri May  9 13:02:55 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_DEFCONFIG_LIST="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IP_VS is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_RECENT=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_IP_NF_TARGET_NETMAP=y
# CONFIG_NF_NAT_SNMP_BASIC is not set
CONFIG_NF_NAT_FTP=y
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_ECN is not set
CONFIG_IP_NF_TARGET_TTL=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=y
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_RT=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_MH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_TARGET_HL=y
CONFIG_IP6_NF_RAW=y

#
# Bridge: Netfilter Configuration
#
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_RR=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_BLK_DEV_HD_ONLY is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
CONFIG_NET_VENDOR_SMC=y
# CONFIG_WD80x3 is not set
# CONFIG_ULTRA is not set
# CONFIG_SMC9194 is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
# CONFIG_VIDEO_SELECT is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_NONPROMISC_DEVMEM=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y



--------------040501050502090100080004--
