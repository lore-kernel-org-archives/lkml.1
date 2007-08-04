Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXHDRuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXHDRuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764919AbXHDRua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:50:30 -0400
Received: from host86-132-227-203.range86-132.btcentralplus.com ([86.132.227.203]:54860
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764893AbXHDRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:50:24 -0400
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Aug 2007 13:50:21 EDT
Message-ID: <46B4B529.5060402@oak.selfip.net>
Date: Sat, 04 Aug 2007 18:19:37 +0100
From: tla <tla@oak.selfip.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc2 compile warnings & 1 section mismatch
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  The following warnings (17) and section mismatch (1) were observed
when compiling linux 2.6.23-rc2.

$ sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux s1 2.6.23-rc2 #1 SMP Sat Aug 4 17:44:22 BST 2007 i686 Pentium III
(Coppermine) GenuineIntel GNU/Linux

Gnu C                  4.2.0
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
PPP                    2.4.4
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   104

$ make
scripts/kconfig/conf -s arch/i386/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-i386
  CC      arch/i386/kernel/asm-offsets.s
  GEN     include/asm-i386/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/conmakehash
  HOSTCC  scripts/bin2c
  CC      init/main.o
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  CC      init/do_mounts.o
  CC      init/do_mounts_initrd.o
  CC      init/do_mounts_md.o
  LD      init/mounts.o
  CC      init/initramfs.o
  CC      init/calibrate.o
  LD      init/built-in.o
  HOSTCC  usr/gen_init_cpio
  GEN     usr/initramfs_data.cpio.gz
  AS      usr/initramfs_data.o
  LD      usr/built-in.o
  CC      arch/i386/mach-generic/probe.o
  CC      arch/i386/mach-generic/summit.o
  CC      arch/i386/mach-generic/bigsmp.o
  CC      arch/i386/mach-generic/es7000.o
  CC      arch/i386/mach-generic/default.o
  CC      arch/i386/mach-generic/../mach-es7000/es7000plat.o
  LD      arch/i386/mach-generic/../mach-es7000/built-in.o
  LD      arch/i386/mach-generic/built-in.o
  CC      arch/i386/kernel/process.o
  CC      arch/i386/kernel/signal.o
  AS      arch/i386/kernel/entry.o
  CC      arch/i386/kernel/traps.o
  CC      arch/i386/kernel/irq.o
  CC      arch/i386/kernel/ptrace.o
  CC      arch/i386/kernel/time.o
  CC      arch/i386/kernel/ioport.o
  CC      arch/i386/kernel/ldt.o
  CC      arch/i386/kernel/setup.o
  CC      arch/i386/kernel/i8259.o
  CC      arch/i386/kernel/sys_i386.o
  CC      arch/i386/kernel/pci-dma.o
  CC      arch/i386/kernel/i386_ksyms.o
  CC      arch/i386/kernel/i387.o
  CC      arch/i386/kernel/bootflag.o
  CC      arch/i386/kernel/e820.o
  CC      arch/i386/kernel/quirks.o
  CC      arch/i386/kernel/i8237.o
  CC      arch/i386/kernel/topology.o
  CC      arch/i386/kernel/alternative.o
  CC      arch/i386/kernel/i8253.o
  CC      arch/i386/kernel/tsc.o
  CC      arch/i386/kernel/acpi/earlyquirk.o
  LD      arch/i386/kernel/acpi/built-in.o
  CC      arch/i386/kernel/cpu/common.o
  CC      arch/i386/kernel/cpu/proc.o
  CC      arch/i386/kernel/cpu/bugs.o
  CC      arch/i386/kernel/cpu/amd.o
  CC      arch/i386/kernel/cpu/cyrix.o
  CC      arch/i386/kernel/cpu/centaur.o
  CC      arch/i386/kernel/cpu/transmeta.o
  CC      arch/i386/kernel/cpu/intel.o
  CC      arch/i386/kernel/cpu/intel_cacheinfo.o
  CC      arch/i386/kernel/cpu/addon_cpuid_features.o
  CC      arch/i386/kernel/cpu/nexgen.o
  CC      arch/i386/kernel/cpu/umc.o
  CC      arch/i386/kernel/cpu/mcheck/mce.o
  CC      arch/i386/kernel/cpu/mcheck/k7.o
  CC      arch/i386/kernel/cpu/mcheck/p4.o
  CC      arch/i386/kernel/cpu/mcheck/p5.o
  CC      arch/i386/kernel/cpu/mcheck/p6.o
  CC      arch/i386/kernel/cpu/mcheck/winchip.o
  CC      arch/i386/kernel/cpu/mcheck/therm_throt.o
  CC      arch/i386/kernel/cpu/mcheck/non-fatal.o
  LD      arch/i386/kernel/cpu/mcheck/built-in.o
  CC      arch/i386/kernel/cpu/mtrr/main.o
  CC      arch/i386/kernel/cpu/mtrr/if.o
  CC      arch/i386/kernel/cpu/mtrr/generic.o
  CC      arch/i386/kernel/cpu/mtrr/state.o
  CC      arch/i386/kernel/cpu/mtrr/amd.o
  CC      arch/i386/kernel/cpu/mtrr/cyrix.o
  CC      arch/i386/kernel/cpu/mtrr/centaur.o
  LD      arch/i386/kernel/cpu/mtrr/built-in.o
  CC      arch/i386/kernel/cpu/perfctr-watchdog.o
  LD      arch/i386/kernel/cpu/built-in.o
  CC      arch/i386/kernel/reboot.o
  CC      arch/i386/kernel/msr.o
  CC      arch/i386/kernel/cpuid.o
  CC      arch/i386/kernel/microcode.o
  CC      arch/i386/kernel/smp.o
  CC      arch/i386/kernel/smpboot.o
  CC      arch/i386/kernel/tsc_sync.o
  CC      arch/i386/kernel/smpcommon.o
  AS      arch/i386/kernel/trampoline.o
  CC      arch/i386/kernel/mpparse.o
  CC      arch/i386/kernel/apic.o
  CC      arch/i386/kernel/nmi.o
  CC      arch/i386/kernel/io_apic.o
  CC      arch/i386/kernel/sysenter.o
  LDS     arch/i386/kernel/vsyscall.lds
  AS      arch/i386/kernel/vsyscall-int80.o
  AS      arch/i386/kernel/vsyscall-note.o
  SYSCALL arch/i386/kernel/vsyscall-int80.so
  AS      arch/i386/kernel/vsyscall-sysenter.o
  SYSCALL arch/i386/kernel/vsyscall-sysenter.so
  AS      arch/i386/kernel/vsyscall.o
  CC      arch/i386/kernel/doublefault.o
  CC      arch/i386/kernel/vm86.o
  CC      arch/i386/kernel/early_printk.o
  CC      arch/i386/kernel/hpet.o
  CC      arch/i386/kernel/../../x86_64/kernel/k8.o
  LD      arch/i386/kernel/k8.o
  CC      arch/i386/kernel/pcspeaker.o
  SYSCALL arch/i386/kernel/vsyscall-syms.o
  LD      arch/i386/kernel/built-in.o
  AS      arch/i386/kernel/head.o
  CC      arch/i386/kernel/init_task.o
  LDS     arch/i386/kernel/vmlinux.lds
  CC      arch/i386/mm/init.o
  CC      arch/i386/mm/pgtable.o
  CC      arch/i386/mm/fault.o
  CC      arch/i386/mm/ioremap.o
  CC      arch/i386/mm/extable.o
  CC      arch/i386/mm/pageattr.o
  CC      arch/i386/mm/mmap.o
  CC      arch/i386/mm/hugetlbpage.o
  CC      arch/i386/mm/highmem.o
  LD      arch/i386/mm/built-in.o
  CC      arch/i386/mach-default/setup.o
  LD      arch/i386/mach-default/built-in.o
  LD      arch/i386/crypto/built-in.o
  CC      kernel/sched.o
  CC      kernel/fork.o
  CC      kernel/exec_domain.o
  CC      kernel/panic.o
  CC      kernel/printk.o
  CC      kernel/profile.o
  CC      kernel/exit.o
  CC      kernel/itimer.o
  CC      kernel/time.o
  CC      kernel/softirq.o
  CC      kernel/resource.o
  CC      kernel/sysctl.o
  CC      kernel/capability.o
  CC      kernel/ptrace.o
  CC      kernel/timer.o
  CC      kernel/user.o
  CC      kernel/user_namespace.o
  CC      kernel/signal.o
  CC      kernel/sys.o
  CC      kernel/kmod.o
  CC      kernel/workqueue.o
  CC      kernel/pid.o
  CC      kernel/rcupdate.o
  CC      kernel/extable.o
  CC      kernel/params.o
  CC      kernel/posix-timers.o
  CC      kernel/kthread.o
  CC      kernel/wait.o
  CC      kernel/kfifo.o
  CC      kernel/sys_ni.o
  CC      kernel/posix-cpu-timers.o
  CC      kernel/mutex.o
  CC      kernel/hrtimer.o
  CC      kernel/rwsem.o
  CC      kernel/latency.o
  CC      kernel/nsproxy.o
  CC      kernel/srcu.o
  CC      kernel/die_notifier.o
  CC      kernel/utsname.o
  CC      kernel/irq/handle.o
  CC      kernel/irq/manage.o
  CC      kernel/irq/spurious.o
  CC      kernel/irq/resend.o
  CC      kernel/irq/chip.o
  CC      kernel/irq/devres.o
  CC      kernel/irq/autoprobe.o
  CC      kernel/irq/proc.o
  CC      kernel/irq/migration.o
  LD      kernel/irq/built-in.o
  CC      kernel/time/timekeeping.o
  CC      kernel/time/ntp.o
  CC      kernel/time/clocksource.o
  CC      kernel/time/jiffies.o
  CC      kernel/time/timer_list.o
  CC      kernel/time/clockevents.o
  CC      kernel/time/tick-common.o
  CC      kernel/time/tick-broadcast.o
  CC      kernel/time/tick-oneshot.o
  CC      kernel/time/tick-sched.o
  LD      kernel/time/built-in.o
  CC      kernel/futex.o
  CC      kernel/rtmutex.o
  CC      kernel/dma.o
  CC      kernel/cpu.o
  CC      kernel/spinlock.o
  CC      kernel/uid16.o
  CC      kernel/kallsyms.o
  GZIP    kernel/config_data.gz
  IKCFG   kernel/config_data.h
  CC      kernel/configs.o
  CC      kernel/stop_machine.o
  CC      kernel/ksysfs.o
  CC      kernel/softlockup.o
  CC      kernel/seccomp.o
  CC      kernel/relay.o
  CC      kernel/utsname_sysctl.o
  LD      kernel/built-in.o
  CC      mm/bootmem.o
  CC      mm/filemap.o
  CC      mm/mempool.o
  CC      mm/oom_kill.o
  CC      mm/fadvise.o
  CC      mm/page_alloc.o
  CC      mm/page-writeback.o
  CC      mm/pdflush.o
  CC      mm/readahead.o
  CC      mm/swap.o
  CC      mm/truncate.o
  CC      mm/vmscan.o
  CC      mm/prio_tree.o
  CC      mm/util.o
  CC      mm/mmzone.o
  CC      mm/vmstat.o
  CC      mm/backing-dev.o
  CC      mm/fremap.o
  CC      mm/highmem.o
  CC      mm/madvise.o
  CC      mm/memory.o
  CC      mm/mincore.o
  CC      mm/mlock.o
  CC      mm/mmap.o
  CC      mm/mprotect.o
  CC      mm/mremap.o
  CC      mm/msync.o
  CC      mm/rmap.o
  CC      mm/vmalloc.o
  CC      mm/bounce.o
  CC      mm/page_io.o
  CC      mm/swap_state.o
  CC      mm/swapfile.o
  CC      mm/thrash.o
  CC      mm/hugetlb.o
  CC      mm/shmem.o
  CC      mm/shmem_acl.o
  CC      mm/slub.o
mm/slub.c: In function 'kfree':
mm/slub.c:2445: warning: passing argument 3 of 'slab_free' discards
qualifiers from pointer target type
  CC      mm/allocpercpu.o
  CC      mm/quicklist.o
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
  CC      fs/inotify.o
  CC      fs/inotify_user.o
  CC      fs/eventpoll.o
  CC      fs/anon_inodes.o
  CC      fs/signalfd.o
  CC      fs/timerfd.o
  CC      fs/eventfd.o
  CC      fs/nfsctl.o
  CC      fs/binfmt_script.o
  CC      fs/binfmt_elf.o
  CC      fs/mbcache.o
  CC      fs/posix_acl.o
  CC      fs/xattr_acl.o
  CC      fs/autofs4/init.o
  CC      fs/autofs4/inode.o
  CC      fs/autofs4/root.o
  CC      fs/autofs4/symlink.o
fs/autofs4/symlink.c: In function 'autofs4_follow_link':
fs/autofs4/symlink.c:18: warning: passing argument 2 of 'nd_set_link'
discards qualifiers from pointer target type
  CC      fs/autofs4/waitq.o
  CC      fs/autofs4/expire.o
  LD      fs/autofs4/autofs4.o
  LD      fs/autofs4/built-in.o
  CC      fs/devpts/inode.o
  LD      fs/devpts/devpts.o
  LD      fs/devpts/built-in.o
  CC      fs/exportfs/expfs.o
  LD      fs/exportfs/exportfs.o
  LD      fs/exportfs/built-in.o
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
  CC      fs/ext2/xattr.o
  CC      fs/ext2/xattr_user.o
  CC      fs/ext2/xattr_trusted.o
  CC      fs/ext2/acl.o
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
  CC      fs/ext3/xattr.o
  CC      fs/ext3/xattr_user.o
  CC      fs/ext3/xattr_trusted.o
  CC      fs/ext3/acl.o
  LD      fs/ext3/ext3.o
  LD      fs/ext3/built-in.o
  CC      fs/fat/cache.o
  CC      fs/fat/dir.o
  CC      fs/fat/fatent.o
  CC      fs/fat/file.o
  CC      fs/fat/inode.o
  CC      fs/fat/misc.o
  LD      fs/fat/fat.o
  LD      fs/fat/built-in.o
  CC      fs/hugetlbfs/inode.o
  LD      fs/hugetlbfs/hugetlbfs.o
  LD      fs/hugetlbfs/built-in.o
  CC      fs/isofs/namei.o
fs/isofs/namei.c: In function 'isofs_lookup':
fs/isofs/namei.c:161: warning: 'offset' may be used uninitialized in
this function
fs/isofs/namei.c:161: warning: 'block' may be used uninitialized in this
function
  CC      fs/isofs/inode.o
  CC      fs/isofs/dir.o
  CC      fs/isofs/util.o
  CC      fs/isofs/rock.o
  CC      fs/isofs/export.o
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
  CC      fs/lockd/clntlock.o
  CC      fs/lockd/clntproc.o
  CC      fs/lockd/host.o
  CC      fs/lockd/svc.o
  CC      fs/lockd/svclock.o
  CC      fs/lockd/svcshare.o
  CC      fs/lockd/svcproc.o
  CC      fs/lockd/svcsubs.o
  CC      fs/lockd/mon.o
  CC      fs/lockd/xdr.o
  CC      fs/lockd/xdr4.o
  CC      fs/lockd/svc4proc.o
  LD      fs/lockd/lockd.o
  LD      fs/lockd/built-in.o
  CC      fs/msdos/namei.o
  LD      fs/msdos/msdos.o
  LD      fs/msdos/built-in.o
  CC      fs/nfs/client.o
  CC      fs/nfs/dir.o
  CC      fs/nfs/file.o
  CC      fs/nfs/getroot.o
  CC      fs/nfs/inode.o
  CC      fs/nfs/super.o
  CC      fs/nfs/nfs2xdr.o
  CC      fs/nfs/pagelist.o
  CC      fs/nfs/proc.o
  CC      fs/nfs/read.o
  CC      fs/nfs/symlink.o
  CC      fs/nfs/unlink.o
  CC      fs/nfs/write.o
  CC      fs/nfs/namespace.o
  CC      fs/nfs/mount_clnt.o
  CC      fs/nfs/nfsroot.o
  CC      fs/nfs/nfs3proc.o
  CC      fs/nfs/nfs3xdr.o
  CC      fs/nfs/sysctl.o
  LD      fs/nfs/nfs.o
  LD      fs/nfs/built-in.o
  LD      fs/nfs_common/built-in.o
  CC      fs/nfsd/nfssvc.o
  CC      fs/nfsd/nfsctl.o
  CC      fs/nfsd/nfsproc.o
  CC      fs/nfsd/nfsfh.o
  CC      fs/nfsd/vfs.o
  CC      fs/nfsd/export.o
  CC      fs/nfsd/auth.o
  CC      fs/nfsd/lockd.o
  CC      fs/nfsd/nfscache.o
  CC      fs/nfsd/nfsxdr.o
  CC      fs/nfsd/stats.o
  CC      fs/nfsd/nfs3proc.o
  CC      fs/nfsd/nfs3xdr.o
  LD      fs/nfsd/nfsd.o
  LD      fs/nfsd/built-in.o
  CC      fs/nls/nls_base.o
  CC      fs/nls/nls_cp437.o
  CC      fs/nls/nls_ascii.o
  CC      fs/nls/nls_iso8859-1.o
  CC      fs/nls/nls_iso8859-15.o
  CC      fs/nls/nls_utf8.o
  LD      fs/nls/built-in.o
  CC      fs/partitions/check.o
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
  CC      fs/proc/kcore.o
  CC      fs/proc/kmsg.o
  LD      fs/proc/proc.o
  LD      fs/proc/built-in.o
  CC      fs/ramfs/inode.o
  CC      fs/ramfs/file-mmu.o
  LD      fs/ramfs/ramfs.o
  LD      fs/ramfs/built-in.o
  CC      fs/reiserfs/bitmap.o
  CC      fs/reiserfs/do_balan.o
  CC      fs/reiserfs/namei.o
  CC      fs/reiserfs/inode.o
  CC      fs/reiserfs/file.o
  CC      fs/reiserfs/dir.o
  CC      fs/reiserfs/fix_node.o
  CC      fs/reiserfs/super.o
  CC      fs/reiserfs/prints.o
  CC      fs/reiserfs/objectid.o
  CC      fs/reiserfs/lbalance.o
  CC      fs/reiserfs/ibalance.o
  CC      fs/reiserfs/stree.o
  CC      fs/reiserfs/hashes.o
  CC      fs/reiserfs/tail_conversion.o
  CC      fs/reiserfs/journal.o
  CC      fs/reiserfs/resize.o
  CC      fs/reiserfs/item_ops.o
  CC      fs/reiserfs/ioctl.o
  CC      fs/reiserfs/procfs.o
  CC      fs/reiserfs/xattr.o
  CC      fs/reiserfs/xattr_user.o
  CC      fs/reiserfs/xattr_trusted.o
  CC      fs/reiserfs/xattr_acl.o
  LD      fs/reiserfs/reiserfs.o
  LD      fs/reiserfs/built-in.o
  CC      fs/sysfs/inode.o
  CC      fs/sysfs/file.o
  CC      fs/sysfs/dir.o
  CC      fs/sysfs/symlink.o
  CC      fs/sysfs/mount.o
  CC      fs/sysfs/bin.o
  CC      fs/sysfs/group.o
  LD      fs/sysfs/built-in.o
  CC      fs/vfat/namei.o
  LD      fs/vfat/vfat.o
  LD      fs/vfat/built-in.o
  CC      fs/generic_acl.o
  CC      fs/dnotify.o
  LD      fs/built-in.o
  CC      ipc/util.o
  CC      ipc/msgutil.o
  CC      ipc/msg.o
  CC      ipc/sem.o
  CC      ipc/shm.o
  CC      ipc/ipc_sysctl.o
  CC      ipc/mqueue.o
  LD      ipc/built-in.o
  CC      security/commoncap.o
  LD      security/built-in.o
  LD      crypto/built-in.o
  CC      block/elevator.o
  CC      block/ll_rw_blk.o
  CC      block/ioctl.o
  CC      block/genhd.o
  CC      block/scsi_ioctl.o
  CC      block/noop-iosched.o
  CC      block/cfq-iosched.o
  LD      block/built-in.o
  LD      drivers/auxdisplay/built-in.o
  CC      drivers/base/core.o
  CC      drivers/base/sys.o
  CC      drivers/base/bus.o
  CC      drivers/base/dd.o
  CC      drivers/base/driver.o
  CC      drivers/base/class.o
  CC      drivers/base/platform.o
  CC      drivers/base/cpu.o
  CC      drivers/base/firmware.o
  CC      drivers/base/init.o
  CC      drivers/base/map.o
  CC      drivers/base/devres.o
  CC      drivers/base/attribute_container.o
  CC      drivers/base/transport_class.o
  CC      drivers/base/power/shutdown.o
  LD      drivers/base/power/built-in.o
  CC      drivers/base/dma-mapping.o
  CC      drivers/base/dmapool.o
  CC      drivers/base/firmware_class.o
  CC      drivers/base/topology.o
  LD      drivers/base/built-in.o
  CC      drivers/block/loop.o
  LD      drivers/block/built-in.o
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
  CONMK   drivers/char/consolemap_deftbl.c
  CC      drivers/char/consolemap_deftbl.o
  CC      drivers/char/selection.o
  CC      drivers/char/keyboard.o
  CC      drivers/char/vt.o
  SHIPPED drivers/char/defkeymap.c
  CC      drivers/char/defkeymap.o
  CC      drivers/char/sysrq.o
  CC      drivers/char/raw.o
  CC      drivers/char/rtc.o
  CC      drivers/char/agp/backend.o
  CC      drivers/char/agp/frontend.o
  CC      drivers/char/agp/generic.o
  CC      drivers/char/agp/isoch.o
  LD      drivers/char/agp/agpgart.o
  CC      drivers/char/agp/amd64-agp.o
  CC      drivers/char/agp/intel-agp.o
  LD      drivers/char/agp/built-in.o
  CC      drivers/char/hw_random/core.o
  LD      drivers/char/hw_random/rng-core.o
  CC      drivers/char/hw_random/intel-rng.o
  CC      drivers/char/hw_random/amd-rng.o
  CC      drivers/char/hw_random/geode-rng.o
  CC      drivers/char/hw_random/via-rng.o
  LD      drivers/char/hw_random/built-in.o
  LD      drivers/char/built-in.o
  CC      drivers/clocksource/cyclone.o
  LD      drivers/clocksource/built-in.o
  CC      drivers/firmware/dmi_scan.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/firmware/dmi-id.o
  LD      drivers/firmware/built-in.o
  CC      drivers/hid/hid-core.o
  CC      drivers/hid/hid-input.o
  LD      drivers/hid/hid.o
  CC      drivers/hid/usbhid/hid-core.o
  CC      drivers/hid/usbhid/hid-quirks.o
  LD      drivers/hid/usbhid/usbhid.o
  LD      drivers/hid/usbhid/built-in.o
  LD      drivers/hid/built-in.o
  LD      drivers/i2c/algos/built-in.o
  LD      drivers/i2c/busses/built-in.o
  LD      drivers/i2c/chips/built-in.o
  LD      drivers/i2c/built-in.o
  LD      drivers/ide/arm/built-in.o
  LD      drivers/ide/legacy/built-in.o
  LD      drivers/ide/mips/built-in.o
  CC      drivers/ide/pci/piix.o
  LD      drivers/ide/pci/built-in.o
  CC      drivers/ide/ide.o
  CC      drivers/ide/ide-io.o
  CC      drivers/ide/ide-iops.o
  CC      drivers/ide/ide-lib.o
  CC      drivers/ide/ide-probe.o
  CC      drivers/ide/ide-taskfile.o
  CC      drivers/ide/setup-pci.o
  CC      drivers/ide/ide-dma.o
  CC      drivers/ide/ide-proc.o
  LD      drivers/ide/ide-core.o
  CC      drivers/ide/ide-generic.o
  CC      drivers/ide/ide-disk.o
  CC      drivers/ide/ide-cd.o
  LD      drivers/ide/built-in.o
  CC      drivers/ieee1394/ieee1394_core.o
  CC      drivers/ieee1394/ieee1394_transactions.o
  CC      drivers/ieee1394/hosts.o
  CC      drivers/ieee1394/highlevel.o
  CC      drivers/ieee1394/csr.o
  CC      drivers/ieee1394/nodemgr.o
  CC      drivers/ieee1394/dma.o
  CC      drivers/ieee1394/iso.o
  CC      drivers/ieee1394/csr1212.o
  CC      drivers/ieee1394/config_roms.o
  LD      drivers/ieee1394/ieee1394.o
  CC      drivers/ieee1394/ohci1394.o
  CC      drivers/ieee1394/raw1394.o
  LD      drivers/ieee1394/built-in.o
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
  CC      drivers/input/serio/serio.o
  CC      drivers/input/serio/i8042.o
  CC      drivers/input/serio/libps2.o
  LD      drivers/input/serio/built-in.o
  LD      drivers/macintosh/built-in.o
  CC      drivers/md/raid1.o
  CC      drivers/md/dm.o
  CC      drivers/md/dm-table.o
drivers/md/dm-table.c: In function 'dm_get_device':
drivers/md/dm-table.c:473: warning: 'dev' may be used uninitialized in
this function
drivers/md/dm-table.c:473: note: 'dev' was declared here
  CC      drivers/md/dm-target.o
  CC      drivers/md/dm-linear.o
  CC      drivers/md/dm-stripe.o
  CC      drivers/md/dm-ioctl.o
drivers/md/dm-ioctl.c: In function 'ctl_ioctl':
drivers/md/dm-ioctl.c:1407: warning: 'param' may be used uninitialized
in this function
  CC      drivers/md/dm-io.o
  CC      drivers/md/kcopyd.o
  CC      drivers/md/md.o
  CC      drivers/md/bitmap.o
  LD      drivers/md/md-mod.o
  LD      drivers/md/dm-mod.o
  LD      drivers/md/built-in.o
  LD      drivers/media/common/built-in.o
  LD      drivers/media/built-in.o
  CC      drivers/message/fusion/mptbase.o
  CC      drivers/message/fusion/mptscsih.o
  CC      drivers/message/fusion/mptspi.o
  LD      drivers/message/fusion/built-in.o
  LD      drivers/message/built-in.o
  LD      drivers/mfd/built-in.o
  LD      drivers/misc/built-in.o
  CC      drivers/net/e1000/e1000_main.o
  CC      drivers/net/e1000/e1000_hw.o
  CC      drivers/net/e1000/e1000_ethtool.o
  CC      drivers/net/e1000/e1000_param.o
  LD      drivers/net/e1000/e1000.o
  LD      drivers/net/e1000/built-in.o
  CC      drivers/net/tulip/eeprom.o
  CC      drivers/net/tulip/interrupt.o
  CC      drivers/net/tulip/media.o
  CC      drivers/net/tulip/timer.o
  CC      drivers/net/tulip/tulip_core.o
  CC      drivers/net/tulip/21142.o
  CC      drivers/net/tulip/pnic.o
  CC      drivers/net/tulip/pnic2.o
  LD      drivers/net/tulip/tulip.o
  LD      drivers/net/tulip/built-in.o
  LD      drivers/net/wireless/built-in.o
  CC      drivers/net/3c59x.o
  CC      drivers/net/e100.o
  CC      drivers/net/tg3.o
  CC      drivers/net/bnx2.o
  CC      drivers/net/sky2.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
include/asm/io.h: In function 'memcpy_toio':
include/asm/io.h:209: warning: passing argument 1 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/net/mii.o
  CC      drivers/net/Space.o
  CC      drivers/net/loopback.o
  CC      drivers/net/b44.o
  CC      drivers/net/forcedeth.o
  CC      drivers/net/8139cp.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/net/8139too.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/net/r8169.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/net/netconsole.o
  LD      drivers/net/built-in.o
  CC      drivers/pci/access.o
  CC      drivers/pci/bus.o
  CC      drivers/pci/probe.o
  CC      drivers/pci/remove.o
  CC      drivers/pci/pci.o
  CC      drivers/pci/quirks.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/pci/search.o
drivers/pci/search.c: In function 'pci_find_slot':
drivers/pci/search.c:99: warning: 'pci_find_device' is deprecated
(declared at include/linux/pci.h:480)
  CC      drivers/pci/pci-sysfs.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/pci/rom.o
include/asm/io.h: In function 'memcpy_fromio':
include/asm/io.h:205: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC      drivers/pci/setup-res.o
  CC      drivers/pci/proc.o
  CC      drivers/pci/hotplug.o
  CC      drivers/pci/msi.o
  CC      drivers/pci/setup-bus.o
  LD      drivers/pci/built-in.o
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
  CC      drivers/scsi/scsi_sysctl.o
  LD      drivers/scsi/scsi_mod.o
  CC      drivers/scsi/scsi_transport_spi.o
  LD      drivers/scsi/built-in.o
  CC      drivers/serial/serial_core.o
  CC      drivers/serial/8250.o
  CC      drivers/serial/8250_pci.o
  CC      drivers/serial/8250_early.o
  LD      drivers/serial/built-in.o
  CC      drivers/usb/class/usblp.o
  LD      drivers/usb/class/built-in.o
  CC      drivers/usb/core/usb.o
  CC      drivers/usb/core/hub.o
  CC      drivers/usb/core/hcd.o
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
  CC      drivers/usb/mon/mon_main.o
  CC      drivers/usb/mon/mon_stat.o
  CC      drivers/usb/mon/mon_text.o
  CC      drivers/usb/mon/mon_bin.o
  CC      drivers/usb/mon/mon_dma.o
  LD      drivers/usb/mon/usbmon.o
  LD      drivers/usb/mon/built-in.o
  CC      drivers/usb/storage/scsiglue.o
  CC      drivers/usb/storage/protocol.o
  CC      drivers/usb/storage/transport.o
  CC      drivers/usb/storage/usb.o
  CC      drivers/usb/storage/initializers.o
  LD      drivers/usb/storage/usb-storage.o
  LD      drivers/usb/storage/built-in.o
  LD      drivers/usb/built-in.o
  CC      drivers/video/fb_notify.o
  LD      drivers/video/backlight/built-in.o
  CC      drivers/video/console/dummycon.o
  CC      drivers/video/console/vgacon.o
  LD      drivers/video/console/built-in.o
  LD      drivers/video/display/built-in.o
  LD      drivers/video/built-in.o
  LD      drivers/built-in.o
  CC      sound/sound_core.o
  LD      sound/soundcore.o
  CC      sound/sound_firmware.o
  LD      sound/oss/built-in.o
  LD      sound/built-in.o
  CC      arch/i386/pci/i386.o
  CC      arch/i386/pci/init.o
  CC      arch/i386/pci/pcbios.o
  CC      arch/i386/pci/direct.o
  CC      arch/i386/pci/fixup.o
  CC      arch/i386/pci/legacy.o
  CC      arch/i386/pci/irq.o
  CC      arch/i386/pci/common.o
  CC      arch/i386/pci/early.o
  LD      arch/i386/pci/built-in.o
  CC      net/socket.o
  CC      net/802/sysctl_net_802.o
  LD      net/802/built-in.o
  CC      net/8021q/vlan.o
  CC      net/8021q/vlan_dev.o
  CC      net/8021q/vlan_netlink.o
  CC      net/8021q/vlanproc.o
  LD      net/8021q/8021q.o
  LD      net/8021q/built-in.o
  CC      net/core/sock.o
  CC      net/core/request_sock.o
  CC      net/core/skbuff.o
  CC      net/core/iovec.o
  CC      net/core/datagram.o
  CC      net/core/stream.o
  CC      net/core/scm.o
  CC      net/core/gen_stats.o
  CC      net/core/gen_estimator.o
  CC      net/core/sysctl_net_core.o
  CC      net/core/dev.o
  CC      net/core/ethtool.o
  CC      net/core/dev_mcast.o
  CC      net/core/dst.o
  CC      net/core/netevent.o
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
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      net/ipv4/fib_frontend.o
  CC      net/ipv4/fib_semantics.o
  CC      net/ipv4/fib_hash.o
  CC      net/ipv4/proc.o
  CC      net/ipv4/syncookies.o
  CC      net/ipv4/tunnel4.o
  CC      net/ipv4/xfrm4_mode_transport.o
  CC      net/ipv4/xfrm4_mode_tunnel.o
  CC      net/ipv4/ipconfig.o
  CC      net/ipv4/netfilter.o
  CC      net/ipv4/netfilter/nf_nat_rule.o
  CC      net/ipv4/netfilter/nf_nat_standalone.o
  CC      net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o
  CC      net/ipv4/netfilter/nf_conntrack_proto_icmp.o
  CC      net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.o
  CC      net/ipv4/netfilter/nf_nat_core.o
  CC      net/ipv4/netfilter/nf_nat_helper.o
  CC      net/ipv4/netfilter/nf_nat_proto_unknown.o
  CC      net/ipv4/netfilter/nf_nat_proto_tcp.o
  CC      net/ipv4/netfilter/nf_nat_proto_udp.o
  CC      net/ipv4/netfilter/nf_nat_proto_icmp.o
  LD      net/ipv4/netfilter/nf_conntrack_ipv4.o
  LD      net/ipv4/netfilter/nf_nat.o
  CC      net/ipv4/netfilter/ip_tables.o
  CC      net/ipv4/netfilter/iptable_filter.o
  CC      net/ipv4/netfilter/iptable_mangle.o
  LD      net/ipv4/netfilter/iptable_nat.o
  CC      net/ipv4/netfilter/iptable_raw.o
  CC      net/ipv4/netfilter/ipt_iprange.o
  CC      net/ipv4/netfilter/ipt_addrtype.o
  CC      net/ipv4/netfilter/ipt_REJECT.o
  CC      net/ipv4/netfilter/ipt_TOS.o
  CC      net/ipv4/netfilter/ipt_MASQUERADE.o
  CC      net/ipv4/netfilter/ipt_REDIRECT.o
  CC      net/ipv4/netfilter/ipt_LOG.o
  LD      net/ipv4/netfilter/built-in.o
  CC      net/ipv4/inet_diag.o
  CC      net/ipv4/tcp_diag.o
  CC      net/ipv4/tcp_cubic.o
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
  CC      net/ipv6/sysctl_net_ipv6.o
  CC      net/ipv6/datagram.o
  CC      net/ipv6/ip6_flowlabel.o
  CC      net/ipv6/inet6_connection_sock.o
  CC      net/ipv6/xfrm6_policy.o
  CC      net/ipv6/xfrm6_state.o
  CC      net/ipv6/xfrm6_input.o
  CC      net/ipv6/xfrm6_output.o
  CC      net/ipv6/netfilter.o
  CC      net/ipv6/proc.o
  LD      net/ipv6/ipv6.o
  CC      net/ipv6/xfrm6_mode_transport.o
  CC      net/ipv6/xfrm6_mode_tunnel.o
  CC      net/ipv6/netfilter/ip6_tables.o
  CC      net/ipv6/netfilter/ip6table_filter.o
  CC      net/ipv6/netfilter/ip6table_mangle.o
  CC      net/ipv6/netfilter/ip6t_LOG.o
  CC      net/ipv6/netfilter/ip6table_raw.o
  CC      net/ipv6/netfilter/ip6t_REJECT.o
  CC      net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.o
  CC      net/ipv6/netfilter/nf_conntrack_proto_icmpv6.o
  CC      net/ipv6/netfilter/nf_conntrack_reasm.o
  LD      net/ipv6/netfilter/nf_conntrack_ipv6.o
  LD      net/ipv6/netfilter/built-in.o
  CC      net/ipv6/sit.o
  CC      net/ipv6/addrconf_core.o
  CC      net/ipv6/exthdrs_core.o
  CC      net/ipv6/inet6_hashtables.o
  LD      net/ipv6/built-in.o
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
  LD      net/netfilter/netfilter.o
  CC      net/netfilter/nf_sysctl.o
  CC      net/netfilter/nfnetlink.o
  CC      net/netfilter/nfnetlink_queue.o
  CC      net/netfilter/nfnetlink_log.o
  LD      net/netfilter/nf_conntrack.o
  CC      net/netfilter/nf_conntrack_netlink.o
  CC      net/netfilter/x_tables.o
  CC      net/netfilter/xt_tcpudp.o
  CC      net/netfilter/xt_CLASSIFY.o
  CC      net/netfilter/xt_CONNMARK.o
  CC      net/netfilter/xt_MARK.o
  CC      net/netfilter/xt_NFQUEUE.o
  CC      net/netfilter/xt_NFLOG.o
  CC      net/netfilter/xt_NOTRACK.o
  CC      net/netfilter/xt_TRACE.o
  CC      net/netfilter/xt_TCPMSS.o
  CC      net/netfilter/xt_connlimit.o
  CC      net/netfilter/xt_connmark.o
  CC      net/netfilter/xt_conntrack.o
  CC      net/netfilter/xt_dscp.o
  CC      net/netfilter/xt_length.o
  CC      net/netfilter/xt_limit.o
  CC      net/netfilter/xt_mark.o
  CC      net/netfilter/xt_multiport.o
  CC      net/netfilter/xt_state.o
  CC      net/netfilter/xt_string.o
  CC      net/netfilter/xt_tcpmss.o
  LD      net/netfilter/built-in.o
  CC      net/netlink/af_netlink.o
  CC      net/netlink/attr.o
  CC      net/netlink/genetlink.o
  LD      net/netlink/built-in.o
  CC      net/packet/af_packet.o
  LD      net/packet/built-in.o
  CC      net/sched/sch_generic.o
  CC      net/sched/sch_api.o
  CC      net/sched/sch_blackhole.o
  CC      net/sched/cls_api.o
  CC      net/sched/act_api.o
  CC      net/sched/act_police.o
  CC      net/sched/act_gact.o
  CC      net/sched/act_ipt.o
  CC      net/sched/act_pedit.o
  CC      net/sched/sch_fifo.o
  CC      net/sched/sch_cbq.o
net/sched/sch_cbq.c: In function 'cbq_enqueue':
net/sched/sch_cbq.c:383: warning: 'ret' may be used uninitialized in
this function
  CC      net/sched/sch_htb.o
  CC      net/sched/sch_red.o
  CC      net/sched/sch_gred.o
  CC      net/sched/sch_ingress.o
  CC      net/sched/sch_dsmark.o
  CC      net/sched/sch_tbf.o
  CC      net/sched/sch_prio.o
  CC      net/sched/cls_fw.o
  CC      net/sched/cls_basic.o
  CC      net/sched/ematch.o
  CC      net/sched/em_cmp.o
  CC      net/sched/em_nbyte.o
  CC      net/sched/em_u32.o
  CC      net/sched/em_meta.o
  CC      net/sched/em_text.o
  LD      net/sched/built-in.o
  CC      net/sunrpc/clnt.o
  CC      net/sunrpc/xprt.o
  CC      net/sunrpc/socklib.o
  CC      net/sunrpc/xprtsock.o
  CC      net/sunrpc/sched.o
  CC      net/sunrpc/auth.o
  CC      net/sunrpc/auth_null.o
  CC      net/sunrpc/auth_unix.o
  CC      net/sunrpc/svc.o
net/sunrpc/svc.c: In function '__svc_create_thread':
net/sunrpc/svc.c:550: warning: 'oldmask.bits[0u]' may be used
uninitialized in this function
  CC      net/sunrpc/svcsock.o
  CC      net/sunrpc/svcauth.o
  CC      net/sunrpc/svcauth_unix.o
  CC      net/sunrpc/rpcb_clnt.o
  CC      net/sunrpc/timer.o
  CC      net/sunrpc/xdr.o
  CC      net/sunrpc/sunrpc_syms.o
  CC      net/sunrpc/cache.o
  CC      net/sunrpc/rpc_pipe.o
  CC      net/sunrpc/stats.o
  CC      net/sunrpc/sysctl.o
  LD      net/sunrpc/sunrpc.o
  LD      net/sunrpc/built-in.o
  CC      net/unix/af_unix.o
  CC      net/unix/garbage.o
  CC      net/unix/sysctl_net_unix.o
  LD      net/unix/unix.o
  LD      net/unix/built-in.o
  LD      net/wireless/built-in.o
  CC      net/xfrm/xfrm_policy.o
  CC      net/xfrm/xfrm_state.o
  CC      net/xfrm/xfrm_hash.o
  CC      net/xfrm/xfrm_input.o
  CC      net/xfrm/xfrm_algo.o
  LD      net/xfrm/built-in.o
  CC      net/sysctl_net.o
  LD      net/built-in.o
  CC      lib/div64.o
  CC      lib/sort.o
  CC      lib/parser.o
  CC      lib/halfmd4.o
  CC      lib/debug_locks.o
  CC      lib/random32.o
  CC      lib/bust_spinlocks.o
  CC      lib/hexdump.o
  CC      lib/iomap.o
  CC      lib/iomap_copy.o
  CC      lib/devres.o
  CC      lib/check_signature.o
  CC      lib/hweight.o
  CC      lib/kernel_lock.o
  CC      lib/plist.o
  CC      lib/bitrev.o
  HOSTCC  lib/gen_crc32table
  GEN     lib/crc32table.h
  CC      lib/crc32.o
  CC      lib/zlib_inflate/inffast.o
  CC      lib/zlib_inflate/inflate.o
  CC      lib/zlib_inflate/inftrees.o
  CC      lib/zlib_inflate/inflate_syms.o
  LD      lib/zlib_inflate/zlib_inflate.o
  LD      lib/zlib_inflate/built-in.o
  CC      lib/textsearch.o
  CC      lib/ts_kmp.o
  CC      lib/ts_bm.o
  CC      lib/ts_fsm.o
  CC      lib/percpu_counter.o
  LD      lib/built-in.o
  CC      lib/argv_split.o
  CC      lib/bitmap.o
  CC      lib/bug.o
  CC      lib/cmdline.o
  CC      lib/cpumask.o
  CC      lib/ctype.o
  CC      lib/dec_and_lock.o
  CC      lib/dump_stack.o
  CC      lib/extable.o
  CC      lib/idr.o
  CC      lib/int_sqrt.o
  CC      lib/ioremap.o
  CC      lib/irq_regs.o
  CC      lib/kasprintf.o
  CC      lib/klist.o
  CC      lib/kobject.o
  CC      lib/kobject_uevent.o
  CC      lib/kref.o
  CC      lib/prio_tree.o
  CC      lib/radix-tree.o
  CC      lib/rbtree.o
  CC      lib/reciprocal_div.o
  CC      lib/rwsem.o
  CC      lib/semaphore-sleepers.o
  CC      lib/sha1.o
  CC      lib/string.o
  CC      lib/vsprintf.o
  AR      lib/lib.a
  CC      arch/i386/lib/msr-on-cpu.o
  LD      arch/i386/lib/built-in.o
  CC      arch/i386/lib/bitops.o
  AS      arch/i386/lib/checksum.o
  CC      arch/i386/lib/delay.o
  AS      arch/i386/lib/getuser.o
  CC      arch/i386/lib/memcpy.o
  AS      arch/i386/lib/putuser.o
  AS      arch/i386/lib/semaphore.o
  CC      arch/i386/lib/string.o
  CC      arch/i386/lib/strstr.o
  CC      arch/i386/lib/usercopy.o
  AR      arch/i386/lib/lib.a
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
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to
.init.text:start_kernel (between 'is386' and 'check_x87')
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  CC      arch/i386/boot/a20.o
  CC      arch/i386/boot/apm.o
  CC      arch/i386/boot/cmdline.o
  AS      arch/i386/boot/copy.o
  CC      arch/i386/boot/cpu.o
  CC      arch/i386/boot/cpucheck.o
  CC      arch/i386/boot/edd.o
  AS      arch/i386/boot/header.o
  CC      arch/i386/boot/main.o
  CC      arch/i386/boot/mca.o
  CC      arch/i386/boot/memory.o
  CC      arch/i386/boot/pm.o
  AS      arch/i386/boot/pmjump.o
  CC      arch/i386/boot/printf.o
  CC      arch/i386/boot/string.o
  CC      arch/i386/boot/tty.o
  CC      arch/i386/boot/video.o
  CC      arch/i386/boot/version.o
  CC      arch/i386/boot/voyager.o
  CC      arch/i386/boot/video-vga.o
  CC      arch/i386/boot/video-vesa.o
  CC      arch/i386/boot/video-bios.o
  LD      arch/i386/boot/setup.elf
  OBJCOPY arch/i386/boot/setup.bin
  AS      arch/i386/boot/compressed/head.o
  CC      arch/i386/boot/compressed/misc.o
  OBJCOPY arch/i386/boot/compressed/vmlinux.bin
  GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
  LD      arch/i386/boot/compressed/piggy.o
  LD      arch/i386/boot/compressed/vmlinux
  OBJCOPY arch/i386/boot/vmlinux.bin
  HOSTCC  arch/i386/boot/tools/build
  BUILD   arch/i386/boot/bzImage
Root device is (9, 4)
Setup is 9684 bytes (padded to 9728 bytes).
System is 2149 kB
Kernel: arch/i386/boot/bzImage is ready  (#1)

$ cat .config
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc2
# Sat Aug  4 17:16:07 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
# CONFIG_PM is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
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
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=y
# CONFIG_IP_NF_MATCH_TOS is not set
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_OWNER is not set
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_REDIRECT=y
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_SAME is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_TOS=y
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_RAW=y
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
CONFIG_NF_CONNTRACK_IPV6=y
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=y
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_OWNER is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_RAW=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_RR=y
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_IPT=y
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_CLS_POLICE is not set
# CONFIG_NET_CLS_IND is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
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
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_SHARE_IRQ is not set
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
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
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
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
# CONFIG_SCSI_SAS_LIBSAS is not set
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
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set

#
# Fusion MPT device support
#
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#

#
# Texas Instruments PCILynx requires I2C
#
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_RAWIO=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000_NAPI is not set
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_R8169_NAPI is not set
# CONFIG_R8169_VLAN is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
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
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

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
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
# CONFIG_SND is not set

#
# Open Sound System
#
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_TRIDENT is not set
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
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
CONFIG_USB_PRINTER=y

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
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
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

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

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
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_DIRECTIO is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_NFSD_TCP=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_SUNRPC_BIND34 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
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
CONFIG_NLS_ASCII=y
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
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
# CONFIG_PROFILING is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
