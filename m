Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbXEZMAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbXEZMAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 08:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXEZMAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 08:00:39 -0400
Received: from host81-129-236-125.range81-129.btcentralplus.com ([81.129.236.125]:4245
	"EHLO mirg.dynu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXEZMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 08:00:34 -0400
X-Greylist: delayed 1504 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 May 2007 08:00:29 EDT
Message-ID: <46581B75.8040604@mirg.dynu.com>
Date: Sat, 26 May 2007 12:35:17 +0100
From: tla <tla@mirg.dynu.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc3 configuration / compile messages
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------000400070709080602070908"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000400070709080602070908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

  System CPU is Coppermine.

  When configuring 2.6.22-rc3 the following messages appear.  Everything
seemed to build OK and -rc3 is running fine :D

  1) Use old .config from -rc2 (attached):

# cp ../linux/.config .
# rm ../linux
# (cd ..;ln -s linux-2.6.22-rc3 linux)
# make menuconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
  HOSTCC  scripts/kconfig/lxdialog/menubox.o
  HOSTCC  scripts/kconfig/lxdialog/textbox.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/yesno.o
  HOSTCC  scripts/kconfig/mconf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol
'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol
'UCC_GETH' refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol
'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

  2) fresh default config from -rc3:

# mv .config .config.tla
# make menuconfig
scripts/kconfig/mconf arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol
'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol
'UCC_GETH' refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol
'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
#
# using defaults found in arch/i386/defconfig
#
arch/i386/defconfig:175:warning: trying to assign nonexistent symbol
X86_MINIMUM_CPU_FAMILY
arch/i386/defconfig:1447:warning: trying to assign nonexistent symbol
UNWIND_INFO
#
# configuration written to .config
#


*** End of Linux kernel configuration.
*** Execute 'make' to build the kernel or try 'make help'.

  3) Compile time messages:

# make && make modules_install
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol
'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol
'UCC_GETH' refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol
'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
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
  CC      init/do_mounts_rd.o
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
  CC      arch/i386/kernel/acpi/boot.o
  CC      arch/i386/kernel/acpi/earlyquirk.o
  CC      arch/i386/kernel/acpi/sleep.o
  AS      arch/i386/kernel/acpi/wakeup.o
  CC      arch/i386/kernel/acpi/cstate.o
  CC      arch/i386/kernel/acpi/processor.o
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
  CC      arch/i386/kernel/cpu/rise.o
  CC      arch/i386/kernel/cpu/nexgen.o
  CC      arch/i386/kernel/cpu/umc.o
  CC      arch/i386/kernel/cpu/cpufreq/powernow-k8.o
  CC      arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.o
  LD      arch/i386/kernel/cpu/cpufreq/built-in.o
  CC      arch/i386/kernel/cpu/mcheck/mce.o
  CC      arch/i386/kernel/cpu/mcheck/k7.o
  CC      arch/i386/kernel/cpu/mcheck/p4.o
  CC      arch/i386/kernel/cpu/mcheck/p5.o
  CC      arch/i386/kernel/cpu/mcheck/p6.o
  CC      arch/i386/kernel/cpu/mcheck/winchip.o
  CC      arch/i386/kernel/cpu/mcheck/therm_throt.o
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
  CC      arch/i386/kernel/mpparse.o
  CC      arch/i386/kernel/apic.o
  CC      arch/i386/kernel/nmi.o
  CC      arch/i386/kernel/io_apic.o
  CC      arch/i386/kernel/kprobes.o
  CC      arch/i386/kernel/module.o
  CC      arch/i386/kernel/sysenter.o
  LDS     arch/i386/kernel/vsyscall.lds
  AS      arch/i386/kernel/vsyscall-int80.o
  AS      arch/i386/kernel/vsyscall-note.o
  SYSCALL arch/i386/kernel/vsyscall-int80.so
  AS      arch/i386/kernel/vsyscall-sysenter.o
  SYSCALL arch/i386/kernel/vsyscall-sysenter.so
  AS      arch/i386/kernel/vsyscall.o
  CC      arch/i386/kernel/doublefault.o
  CC      arch/i386/kernel/legacy_serial.o
  CC      arch/i386/kernel/vm86.o
  CC      arch/i386/kernel/early_printk.o
  CC      arch/i386/kernel/hpet.o
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
  CC      kernel/irq/handle.o
  CC      kernel/irq/manage.o
  CC      kernel/irq/spurious.o
  CC      kernel/irq/resend.o
  CC      kernel/irq/chip.o
  CC      kernel/irq/devres.o
  CC      kernel/irq/autoprobe.o
  CC      kernel/irq/proc.o
  LD      kernel/irq/built-in.o
  CC      kernel/power/main.o
  CC      kernel/power/process.o
  CC      kernel/power/console.o
  CC      kernel/power/pm.o
kernel/power/pm.c:205: warning: 'pm_register' is deprecated (declared at
kernel/power/pm.c:64)
kernel/power/pm.c:205: warning: 'pm_register' is deprecated (declared at
kernel/power/pm.c:64)
kernel/power/pm.c:206: warning: 'pm_send_all' is deprecated (declared at
kernel/power/pm.c:180)
kernel/power/pm.c:206: warning: 'pm_send_all' is deprecated (declared at
kernel/power/pm.c:180)
  CC      kernel/power/poweroff.o
  LD      kernel/power/built-in.o
  CC      kernel/time/timekeeping.o
  CC      kernel/time/ntp.o
  CC      kernel/time/clocksource.o
  CC      kernel/time/jiffies.o
  CC      kernel/time/timer_list.o
  CC      kernel/time/clockevents.o
  CC      kernel/time/tick-common.o
  CC      kernel/time/tick-broadcast.o
  LD      kernel/time/built-in.o
  CC      kernel/futex.o
  CC      kernel/rtmutex.o
  CC      kernel/dma.o
  CC      kernel/uid16.o
  CC      kernel/module.o
  CC      kernel/kallsyms.o
  GZIP    kernel/config_data.gz
  IKCFG   kernel/config_data.h
  CC      kernel/configs.o
  CC      kernel/kprobes.o
  CC      kernel/ksysfs.o
  CC      kernel/softlockup.o
  CC      kernel/seccomp.o
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
  CC      mm/slab.o
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
  CC      fs/binfmt_script.o
  CC      fs/binfmt_elf.o
  CC      fs/mbcache.o
  CC      fs/posix_acl.o
  CC      fs/xattr_acl.o
  CC      fs/generic_acl.o
  CC      fs/dnotify.o
  CC      fs/autofs4/init.o
  CC      fs/autofs4/inode.o
  CC      fs/autofs4/root.o
  CC      fs/autofs4/symlink.o
  CC      fs/autofs4/waitq.o
  CC      fs/autofs4/expire.o
  LD      fs/autofs4/autofs4.o
  LD      fs/autofs4/built-in.o
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
  CC      fs/msdos/namei.o
  LD      fs/msdos/msdos.o
  LD      fs/msdos/built-in.o
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
  CC      fs/dcookies.o
  LD      fs/built-in.o
  CC      ipc/util.o
  CC      ipc/msgutil.o
  CC      ipc/msg.o
ipc/msg.c: In function 'sys_msgctl':
ipc/msg.c:390: warning: 'setbuf.qbytes' may be used uninitialized in
this function
ipc/msg.c:390: warning: 'setbuf.uid' may be used uninitialized in this
function
ipc/msg.c:390: warning: 'setbuf.gid' may be used uninitialized in this
function
ipc/msg.c:390: warning: 'setbuf.mode' may be used uninitialized in this
function
  CC      ipc/sem.o
ipc/sem.c: In function 'sys_semctl':
ipc/sem.c:861: warning: 'setbuf.uid' may be used uninitialized in this
function
ipc/sem.c:861: warning: 'setbuf.gid' may be used uninitialized in this
function
ipc/sem.c:861: warning: 'setbuf.mode' may be used uninitialized in this
function
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
  CC      block/as-iosched.o
  CC      block/deadline-iosched.o
  CC      block/cfq-iosched.o
  LD      block/built-in.o
  CC      drivers/acpi/tables.o
  CC      drivers/acpi/blacklist.o
  CC      drivers/acpi/osl.o
  CC      drivers/acpi/utils.o
  CC      drivers/acpi/dispatcher/dsfield.o
  CC      drivers/acpi/dispatcher/dsmthdat.o
  CC      drivers/acpi/dispatcher/dsopcode.o
  CC      drivers/acpi/dispatcher/dswexec.o
  CC      drivers/acpi/dispatcher/dswscope.o
  CC      drivers/acpi/dispatcher/dsmethod.o
  CC      drivers/acpi/dispatcher/dsobject.o
  CC      drivers/acpi/dispatcher/dsutils.o
  CC      drivers/acpi/dispatcher/dswload.o
  CC      drivers/acpi/dispatcher/dswstate.o
  CC      drivers/acpi/dispatcher/dsinit.o
  LD      drivers/acpi/dispatcher/built-in.o
  CC      drivers/acpi/events/evevent.o
  CC      drivers/acpi/events/evregion.o
  CC      drivers/acpi/events/evsci.o
  CC      drivers/acpi/events/evxfevnt.o
  CC      drivers/acpi/events/evmisc.o
  CC      drivers/acpi/events/evrgnini.o
  CC      drivers/acpi/events/evxface.o
  CC      drivers/acpi/events/evxfregn.o
  CC      drivers/acpi/events/evgpe.o
  CC      drivers/acpi/events/evgpeblk.o
  LD      drivers/acpi/events/built-in.o
  CC      drivers/acpi/executer/exconfig.o
  CC      drivers/acpi/executer/exfield.o
  CC      drivers/acpi/executer/exnames.o
  CC      drivers/acpi/executer/exoparg6.o
  CC      drivers/acpi/executer/exresolv.o
  CC      drivers/acpi/executer/exstorob.o
  CC      drivers/acpi/executer/exconvrt.o
  CC      drivers/acpi/executer/exfldio.o
  CC      drivers/acpi/executer/exoparg1.o
  CC      drivers/acpi/executer/exprep.o
  CC      drivers/acpi/executer/exresop.o
  CC      drivers/acpi/executer/exsystem.o
  CC      drivers/acpi/executer/excreate.o
  CC      drivers/acpi/executer/exmisc.o
  CC      drivers/acpi/executer/exoparg2.o
  CC      drivers/acpi/executer/exregion.o
  CC      drivers/acpi/executer/exstore.o
  CC      drivers/acpi/executer/exutils.o
  CC      drivers/acpi/executer/exdump.o
  CC      drivers/acpi/executer/exmutex.o
  CC      drivers/acpi/executer/exoparg3.o
  CC      drivers/acpi/executer/exresnte.o
  CC      drivers/acpi/executer/exstoren.o
  LD      drivers/acpi/executer/built-in.o
  CC      drivers/acpi/hardware/hwacpi.o
  CC      drivers/acpi/hardware/hwgpe.o
  CC      drivers/acpi/hardware/hwregs.o
  CC      drivers/acpi/hardware/hwsleep.o
  LD      drivers/acpi/hardware/built-in.o
  CC      drivers/acpi/namespace/nsaccess.o
  CC      drivers/acpi/namespace/nsload.o
  CC      drivers/acpi/namespace/nssearch.o
  CC      drivers/acpi/namespace/nsxfeval.o
  CC      drivers/acpi/namespace/nsalloc.o
  CC      drivers/acpi/namespace/nseval.o
  CC      drivers/acpi/namespace/nsnames.o
  CC      drivers/acpi/namespace/nsutils.o
  CC      drivers/acpi/namespace/nsxfname.o
  CC      drivers/acpi/namespace/nsdump.o
  CC      drivers/acpi/namespace/nsinit.o
  CC      drivers/acpi/namespace/nsobject.o
  CC      drivers/acpi/namespace/nswalk.o
  CC      drivers/acpi/namespace/nsxfobj.o
  CC      drivers/acpi/namespace/nsparse.o
  LD      drivers/acpi/namespace/built-in.o
  CC      drivers/acpi/parser/psargs.o
  CC      drivers/acpi/parser/psparse.o
  CC      drivers/acpi/parser/psloop.o
  CC      drivers/acpi/parser/pstree.o
  CC      drivers/acpi/parser/pswalk.o
  CC      drivers/acpi/parser/psopcode.o
  CC      drivers/acpi/parser/psscope.o
  CC      drivers/acpi/parser/psutils.o
  CC      drivers/acpi/parser/psxface.o
  LD      drivers/acpi/parser/built-in.o
  CC      drivers/acpi/resources/rsaddr.o
  CC      drivers/acpi/resources/rscreate.o
  CC      drivers/acpi/resources/rsinfo.o
  CC      drivers/acpi/resources/rsio.o
  CC      drivers/acpi/resources/rslist.o
  CC      drivers/acpi/resources/rsmisc.o
  CC      drivers/acpi/resources/rsxface.o
  CC      drivers/acpi/resources/rscalc.o
  CC      drivers/acpi/resources/rsirq.o
  CC      drivers/acpi/resources/rsmemory.o
  CC      drivers/acpi/resources/rsutils.o
  LD      drivers/acpi/resources/built-in.o
  CC      drivers/acpi/sleep/poweroff.o
  CC      drivers/acpi/sleep/wakeup.o
  CC      drivers/acpi/sleep/main.o
  CC      drivers/acpi/sleep/proc.o
  LD      drivers/acpi/sleep/built-in.o
  CC      drivers/acpi/tables/tbxface.o
  CC      drivers/acpi/tables/tbinstal.o
  CC      drivers/acpi/tables/tbutils.o
  CC      drivers/acpi/tables/tbfind.o
  CC      drivers/acpi/tables/tbfadt.o
  LD      drivers/acpi/tables/built-in.o
  CC      drivers/acpi/utilities/utalloc.o
  CC      drivers/acpi/utilities/utdebug.o
  CC      drivers/acpi/utilities/uteval.o
  CC      drivers/acpi/utilities/utinit.o
  CC      drivers/acpi/utilities/utmisc.o
  CC      drivers/acpi/utilities/utxface.o
  CC      drivers/acpi/utilities/utcopy.o
  CC      drivers/acpi/utilities/utdelete.o
  CC      drivers/acpi/utilities/utglobal.o
  CC      drivers/acpi/utilities/utmath.o
  CC      drivers/acpi/utilities/utobject.o
  CC      drivers/acpi/utilities/utstate.o
  CC      drivers/acpi/utilities/utmutex.o
  CC      drivers/acpi/utilities/utcache.o
  CC      drivers/acpi/utilities/utresrc.o
  LD      drivers/acpi/utilities/built-in.o
  CC      drivers/acpi/bus.o
  CC      drivers/acpi/glue.o
  CC      drivers/acpi/scan.o
  CC      drivers/acpi/ec.o
  CC      drivers/acpi/ac.o
  CC      drivers/acpi/battery.o
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
  CC      drivers/acpi/processor_perflib.o
  LD      drivers/acpi/processor.o
  CC      drivers/acpi/thermal.o
  CC      drivers/acpi/system.o
  CC      drivers/acpi/event.o
  CC      drivers/acpi/debug.o
  CC      drivers/acpi/cm_sbs.o
  LD      drivers/acpi/built-in.o
  LD      drivers/auxdisplay/built-in.o
  CC      drivers/base/core.o
  CC      drivers/base/sys.o
  CC      drivers/base/bus.o
  CC      drivers/base/dd.o
drivers/base/dd.c:211: warning: 'device_probe_drivers' defined but not used
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
  CC      drivers/base/power/main.o
  CC      drivers/base/power/suspend.o
  CC      drivers/base/power/resume.o
  CC      drivers/base/power/runtime.o
  CC      drivers/base/power/sysfs.o
  LD      drivers/base/power/built-in.o
  CC      drivers/base/dma-mapping.o
  CC      drivers/base/dmapool.o
  CC      drivers/base/firmware_class.o
  LD      drivers/base/built-in.o
  CC      drivers/block/floppy.o
  CC      drivers/block/rd.o
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
  CC      drivers/char/rtc.o
  CC      drivers/char/agp/backend.o
  CC      drivers/char/agp/frontend.o
  CC      drivers/char/agp/generic.o
  CC      drivers/char/agp/isoch.o
  LD      drivers/char/agp/agpgart.o
  CC      drivers/char/agp/intel-agp.o
  CC      drivers/char/agp/via-agp.o
  LD      drivers/char/agp/built-in.o
  CC      drivers/char/hw_random/core.o
  LD      drivers/char/hw_random/rng-core.o
  CC      drivers/char/hw_random/intel-rng.o
  CC      drivers/char/hw_random/via-rng.o
  LD      drivers/char/hw_random/built-in.o
  LD      drivers/char/built-in.o
  CC      drivers/clocksource/acpi_pm.o
  LD      drivers/clocksource/built-in.o
  CC      drivers/cpufreq/cpufreq.o
  CC      drivers/cpufreq/cpufreq_stats.o
  CC      drivers/cpufreq/cpufreq_performance.o
  CC      drivers/cpufreq/cpufreq_userspace.o
  CC      drivers/cpufreq/cpufreq_ondemand.o
  CC      drivers/cpufreq/freq_table.o
  LD      drivers/cpufreq/built-in.o
  CC      drivers/firmware/dmi_scan.o
  LD      drivers/firmware/built-in.o
  CC      drivers/hid/hid-core.o
  CC      drivers/hid/hid-input.o
  LD      drivers/hid/hid.o
  CC      drivers/hid/usbhid/hid-core.o
  CC      drivers/hid/usbhid/hid-quirks.o
  LD      drivers/hid/usbhid/usbhid.o
  LD      drivers/hid/usbhid/built-in.o
  LD      drivers/hid/built-in.o
  CC      drivers/hwmon/hwmon.o
  LD      drivers/hwmon/built-in.o
  CC      drivers/i2c/i2c-boardinfo.o
  CC      drivers/i2c/i2c-core.o
  CC      drivers/i2c/i2c-dev.o
  CC      drivers/i2c/algos/i2c-algo-bit.o
  LD      drivers/i2c/algos/built-in.o
  CC      drivers/i2c/busses/i2c-i801.o
  CC      drivers/i2c/busses/i2c-i810.o
  LD      drivers/i2c/busses/built-in.o
  LD      drivers/i2c/chips/built-in.o
  LD      drivers/i2c/built-in.o
  LD      drivers/ide/arm/built-in.o
  LD      drivers/ide/legacy/built-in.o
  LD      drivers/ide/mips/built-in.o
  CC      drivers/ide/pci/amd74xx.o
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
  CC      drivers/md/dm-target.o
  CC      drivers/md/dm-linear.o
  CC      drivers/md/dm-stripe.o
  CC      drivers/md/dm-ioctl.o
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
  CC      drivers/net/mii.o
  CC      drivers/net/Space.o
  CC      drivers/net/loopback.o
  CC      drivers/net/8139too.o
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
(declared at include/linux/pci.h:477)
drivers/pci/search.c: At top level:
drivers/pci/search.c:433: warning: 'pci_find_device' is deprecated
(declared at drivers/pci/search.c:241)
drivers/pci/search.c:433: warning: 'pci_find_device' is deprecated
(declared at drivers/pci/search.c:241)
  CC      drivers/pci/pci-sysfs.o
  CC      drivers/pci/rom.o
  CC      drivers/pci/setup-res.o
  CC      drivers/pci/proc.o
  CC      drivers/pci/hotplug.o
  CC      drivers/pci/msi.o
  CC      drivers/pci/setup-bus.o
  CC      drivers/pci/pci-acpi.o
  LD      drivers/pci/built-in.o
  CC      drivers/pnp/core.o
  CC      drivers/pnp/card.o
  CC      drivers/pnp/driver.o
  CC      drivers/pnp/resource.o
  CC      drivers/pnp/manager.o
  CC      drivers/pnp/support.o
  CC      drivers/pnp/interface.o
  CC      drivers/pnp/quirks.o
  CC      drivers/pnp/system.o
  CC      drivers/pnp/pnpacpi/core.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  LD      drivers/pnp/pnpacpi/built-in.o
  LD      drivers/pnp/built-in.o
  CC      drivers/scsi/scsi.o
  CC      drivers/scsi/hosts.o
  CC      drivers/scsi/scsi_ioctl.o
  CC      drivers/scsi/constants.o
  CC      drivers/scsi/scsicam.o
  CC      drivers/scsi/scsi_error.o
  CC      drivers/scsi/scsi_lib.o
  CC      drivers/scsi/scsi_scan.o
  CC      drivers/scsi/scsi_sysfs.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      drivers/scsi/scsi_netlink.o
  CC      drivers/scsi/scsi_sysctl.o
  CC      drivers/scsi/sd.o
  CC      drivers/scsi/sr.o
  CC      drivers/scsi/sr_ioctl.o
  CC      drivers/scsi/sr_vendor.o
  LD      drivers/scsi/scsi_mod.o
  CC      drivers/scsi/scsi_transport_spi.o
  CC      drivers/scsi/scsi_transport_fc.o
  SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
  SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
  CC      drivers/scsi/aic7xxx/aic79xx_core.o
  CC      drivers/scsi/aic7xxx/aic79xx_pci.o
  CC      drivers/scsi/aic7xxx/aic79xx_osm.o
  CC      drivers/scsi/aic7xxx/aic79xx_proc.o
  CC      drivers/scsi/aic7xxx/aic79xx_osm_pci.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_seq.h
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg.h
  CC      drivers/scsi/aic7xxx/aic7xxx_core.o
  CC      drivers/scsi/aic7xxx/aic7xxx_93cx6.o
  CC      drivers/scsi/aic7xxx/aic7xxx_pci.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg_print.c
  CC      drivers/scsi/aic7xxx/aic7xxx_reg_print.o
  CC      drivers/scsi/aic7xxx/aic7xxx_osm.o
  CC      drivers/scsi/aic7xxx/aic7xxx_proc.o
  CC      drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
  LD      drivers/scsi/aic7xxx/aic7xxx.o
  LD      drivers/scsi/aic7xxx/aic79xx.o
  LD      drivers/scsi/aic7xxx/built-in.o
  CC      drivers/scsi/3w-xxxx.o
  LD      drivers/scsi/sd_mod.o
  LD      drivers/scsi/sr_mod.o
  CC      drivers/scsi/sg.o
  LD      drivers/scsi/built-in.o
  CC [M]  drivers/scsi/scsi_wait_scan.o
  CC      drivers/serial/serial_core.o
  CC      drivers/serial/8250.o
  CC      drivers/serial/8250_pnp.o
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
  LD      sound/built-in.o
  CC      arch/i386/pci/i386.o
  CC      arch/i386/pci/init.o
  CC      arch/i386/pci/pcbios.o
  CC      arch/i386/pci/mmconfig.o
  CC      arch/i386/pci/direct.o
  CC      arch/i386/pci/mmconfig-shared.o
  CC      arch/i386/pci/fixup.o
  CC      arch/i386/pci/acpi.o
  CC      arch/i386/pci/legacy.o
  CC      arch/i386/pci/irq.o
  CC      arch/i386/pci/common.o
  CC      arch/i386/pci/early.o
  LD      arch/i386/pci/built-in.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/oprof.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/cpu_buffer.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/buffer_sync.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/event_buffer.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/oprofile_files.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/oprofilefs.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/oprofile_stats.o
  CC      arch/i386/oprofile/../../../drivers/oprofile/timer_int.o
  CC      arch/i386/oprofile/init.o
  CC      arch/i386/oprofile/backtrace.o
  CC      arch/i386/oprofile/nmi_int.o
  CC      arch/i386/oprofile/op_model_athlon.o
  CC      arch/i386/oprofile/op_model_ppro.o
  CC      arch/i386/oprofile/op_model_p4.o
  CC      arch/i386/oprofile/nmi_timer_int.o
  LD      arch/i386/oprofile/oprofile.o
  LD      arch/i386/oprofile/built-in.o
  CC      arch/i386/power/cpu.o
  LD      arch/i386/power/built-in.o
  CC      net/socket.o
  CC      net/802/sysctl_net_802.o
  LD      net/802/built-in.o
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
  CC      net/ipv4/netfilter/nf_nat_irc.o
  CC      net/ipv4/netfilter/nf_nat_pptp.o
  CC      net/ipv4/netfilter/nf_nat_snmp_basic.o
  CC      net/ipv4/netfilter/nf_nat_proto_gre.o
  CC      net/ipv4/netfilter/ip_tables.o
  CC      net/ipv4/netfilter/iptable_filter.o
  CC      net/ipv4/netfilter/iptable_mangle.o
  LD      net/ipv4/netfilter/iptable_nat.o
  CC      net/ipv4/netfilter/iptable_raw.o
  CC      net/ipv4/netfilter/ipt_iprange.o
  CC      net/ipv4/netfilter/ipt_owner.o
  CC      net/ipv4/netfilter/ipt_tos.o
  CC      net/ipv4/netfilter/ipt_recent.o
  CC      net/ipv4/netfilter/ipt_ecn.o
  CC      net/ipv4/netfilter/ipt_ah.o
  CC      net/ipv4/netfilter/ipt_ttl.o
  CC      net/ipv4/netfilter/ipt_addrtype.o
  CC      net/ipv4/netfilter/ipt_REJECT.o
  CC      net/ipv4/netfilter/ipt_TOS.o
  CC      net/ipv4/netfilter/ipt_ECN.o
  CC      net/ipv4/netfilter/ipt_MASQUERADE.o
  CC      net/ipv4/netfilter/ipt_REDIRECT.o
  CC      net/ipv4/netfilter/ipt_NETMAP.o
  CC      net/ipv4/netfilter/ipt_SAME.o
  CC      net/ipv4/netfilter/ipt_LOG.o
  CC      net/ipv4/netfilter/ipt_ULOG.o
  CC      net/ipv4/netfilter/ipt_TTL.o
  CC      net/ipv4/netfilter/arp_tables.o
  CC      net/ipv4/netfilter/arpt_mangle.o
  CC      net/ipv4/netfilter/arptable_filter.o
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
  CC      net/ipv6/xfrm6_mode_beet.o
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
  LD      net/netfilter/netfilter.o
  CC      net/netfilter/nf_sysctl.o
  LD      net/netfilter/nf_conntrack.o
  CC      net/netfilter/nf_conntrack_proto_gre.o
  CC      net/netfilter/nf_conntrack_irc.o
  CC      net/netfilter/nf_conntrack_pptp.o
  CC      net/netfilter/x_tables.o
  CC      net/netfilter/xt_tcpudp.o
  CC      net/netfilter/xt_CLASSIFY.o
  CC      net/netfilter/xt_DSCP.o
  CC      net/netfilter/xt_MARK.o
  CC      net/netfilter/xt_NFQUEUE.o
  CC      net/netfilter/xt_NFLOG.o
  CC      net/netfilter/xt_comment.o
  CC      net/netfilter/xt_conntrack.o
  CC      net/netfilter/xt_dccp.o
  CC      net/netfilter/xt_dscp.o
  CC      net/netfilter/xt_esp.o
  CC      net/netfilter/xt_helper.o
  CC      net/netfilter/xt_length.o
  CC      net/netfilter/xt_limit.o
  CC      net/netfilter/xt_mac.o
  CC      net/netfilter/xt_mark.o
  CC      net/netfilter/xt_multiport.o
  CC      net/netfilter/xt_policy.o
  CC      net/netfilter/xt_pkttype.o
  CC      net/netfilter/xt_quota.o
  CC      net/netfilter/xt_realm.o
  CC      net/netfilter/xt_sctp.o
  CC      net/netfilter/xt_state.o
  CC      net/netfilter/xt_statistic.o
  CC      net/netfilter/xt_string.o
  CC      net/netfilter/xt_tcpmss.o
  CC      net/netfilter/xt_hashlimit.o
  LD      net/netfilter/built-in.o
  CC      net/netlink/af_netlink.o
  CC      net/netlink/attr.o
  CC      net/netlink/genetlink.o
  LD      net/netlink/built-in.o
  CC      net/packet/af_packet.o
  LD      net/packet/built-in.o
  CC      net/sched/sch_generic.o
  LD      net/sched/built-in.o
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
  CC      lib/hweight.o
  CC      lib/plist.o
  CC      lib/bitrev.o
  HOSTCC  lib/gen_crc32table
  GEN     lib/crc32table.h
  CC      lib/crc32.o
  CC      lib/textsearch.o
  CC      lib/ts_kmp.o
  CC      lib/ts_bm.o
  CC      lib/ts_fsm.o
  LD      lib/built-in.o
  CC      lib/bitmap.o
  CC      lib/bug.o
  CC      lib/cmdline.o
  CC      lib/ctype.o
  CC      lib/dec_and_lock.o
  CC      lib/dump_stack.o
  CC      lib/extable.o
  CC      lib/idr.o
  CC      lib/int_sqrt.o
  CC      lib/ioremap.o
  CC      lib/irq_regs.o
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
  LD      arch/i386/lib/built-in.o
  CC      arch/i386/lib/bitops.o
  AS      arch/i386/lib/checksum.o
  CC      arch/i386/lib/delay.o
  AS      arch/i386/lib/getuser.o
  CC      arch/i386/lib/memcpy.o
  AS      arch/i386/lib/putuser.o
  AS      arch/i386/lib/semaphore.o
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
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0x77b4): Section mismatch:
reference to .init.text:amd_init_mtrr (between 'mtrr_bp_init' and
'mtrr_attrib_to_str')
WARNING: arch/i386/kernel/built-in.o(.text+0x77b9): Section mismatch:
reference to .init.text:cyrix_init_mtrr (between 'mtrr_bp_init' and
'mtrr_attrib_to_str')
WARNING: arch/i386/kernel/built-in.o(.text+0x77be): Section mismatch:
reference to .init.text:centaur_init_mtrr (between 'mtrr_bp_init' and
'mtrr_attrib_to_str')
WARNING: arch/i386/kernel/built-in.o(.text+0x858b): Section mismatch:
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
WARNING: arch/i386/kernel/built-in.o(.text+0x859f): Section mismatch:
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
WARNING: arch/i386/kernel/built-in.o(.text+0x85c3): Section mismatch:
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
  AS      arch/i386/boot/bootsect.o
  LD      arch/i386/boot/bootsect
  AS      arch/i386/boot/setup.o
  LD      arch/i386/boot/setup
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
Boot sector 512 bytes.
Setup is 7146 bytes.
System is 1986 kB
Kernel: arch/i386/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 1 modules
  CC      drivers/scsi/scsi_wait_scan.mod.o
  LD [M]  drivers/scsi/scsi_wait_scan.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko
if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F
System.map  2.6.22-rc3; fi

tla.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)

iD8DBQFGWBt02hOS5G7QWnMRAuadAJ9P+9/EaU69a4YHT/BZXtdkgZ4+ugCdHY2L
Ts8XgHBQ1ZEgLwOvXuJbGVo=
=RdO8
-----END PGP SIGNATURE-----

--------------000400070709080602070908
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22-rc2
# Sun May 20 16:32:30 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
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
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
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
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set

#
# Block layer
#
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
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
# CONFIG_PARAVIRT is not set
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
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_MODEL=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
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
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SYSFS_DEPRECATED=y
# CONFIG_SOFTWARE_SUSPEND is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
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
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
# CONFIG_X86_SPEEDSTEP_LIB is not set

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
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

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

#
# IP: Virtual Server Configuration
#
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
CONFIG_INET6_XFRM_MODE_BEET=y
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
# CONFIG_NETFILTER_NETLINK is not set
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_GRE=y
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_PPTP=y
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=y
CONFIG_IP_NF_MATCH_TOS=y
CONFIG_IP_NF_MATCH_RECENT=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_MATCH_OWNER=y
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
CONFIG_IP_NF_TARGET_SAME=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_NF_NAT_PROTO_GRE=y
# CONFIG_NF_NAT_FTP is not set
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_PPTP=y
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_TOS=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
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
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
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

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=y
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
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_BLINK is not set
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
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
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
CONFIG_BLK_DEV_AMD74XX=y
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
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=4000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_ESP_CORE is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_ATA is not set

#
# Multi-device support (RAID and LVM)
#
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
# CONFIG_IEEE1394_PCILYNX is not set
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

#
# I2O device support
#
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set

#
# Tulip family network device support
#
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
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
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
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
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

#
# Token Ring devices
#
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

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1024
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
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
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

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
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
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_I810=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

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
# CONFIG_SOUND is not set

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB support
#
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
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

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

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
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

#
# Virtualization
#
# CONFIG_KVM is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
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
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

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

#
# Instrumentation Support
#
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y

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
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
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

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_LIBCRC32C is not set
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
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y

--------------000400070709080602070908--
