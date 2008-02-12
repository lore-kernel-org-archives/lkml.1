Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbYBLHFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbYBLHFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYBLHFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:05:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbYBLHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:05:32 -0500
Date: Tue, 12 Feb 2008 08:04:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.25-rc1, weird build error
Message-ID: <20080212070448.GA20033@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


i've got a build log from a weird build error below:

  LD      init/built-in.o
distcc[12023] ERROR: compile (null) on localhost failed
make: *** [vmlinux.o] Error 1
make: *** Waiting for unfinished jobs....
  LD      .tmp_vmlinux1

but there's no actual error visible in the logs. On a second attempt, it 
built just fine. (unfortunately erasing most evidence of the previous 
failure.) This happened after a rather long randconfig build series so i 
doubt it's readily reprodicible.

any ideas? Is this something benign? Or should i start doing all builds 
with V=1, in the hope of catching more information?

	Ingo

--------------------------->
Tue Feb 12 01:48:38 CET 2008
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/conmakehash
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm-x86/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      init/main.o
  CHK     include/linux/compile.h
  CC      init/do_mounts.o
  CC      init/do_mounts_rd.o
  CC      init/noinitramfs.o
  CC      init/calibrate.o
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      usr/built-in.o
  CC      arch/x86/mach-generic/probe.o
  CC      arch/x86/mach-generic/summit.o
  CC      arch/x86/mach-generic/bigsmp.o
  CC      arch/x86/mach-generic/es7000.o
  CC      arch/x86/mach-generic/default.o
  CC      arch/x86/mach-generic/../../x86/mach-es7000/es7000plat.o
  CC      arch/x86/kernel/process_32.o
  CC      arch/x86/kernel/signal_32.o
  AS      arch/x86/kernel/entry_32.o
  CC      arch/x86/kernel/traps_32.o
  CC      arch/x86/mm/init_32.o
  CC      arch/x86/kernel/irq_32.o
  CC      arch/x86/mm/fault.o
  CC      arch/x86/mm/ioremap.o
  CC      arch/x86/mm/extable.o
  CC      arch/x86/mm/pageattr.o
  CC      arch/x86/mm/mmap.o
  CC      arch/x86/mm/pgtable_32.o
  CC      arch/x86/mm/highmem_32.o
  CC      arch/x86/mm/pf_in.o
  CC      arch/x86/kernel/time_32.o
  CC      arch/x86/mm/kmmio.o
  CC      arch/x86/kernel/ioport.o
  CC      arch/x86/mm/mmio-mod.o
  CC      arch/x86/kernel/ldt.o
  CC      arch/x86/kernel/setup_32.o
  CC      arch/x86/kernel/i8259_32.o
  CC      arch/x86/mach-default/setup.o
  CC      arch/x86/kernel/sys_i386_32.o
  CC      arch/x86/kernel/i386_ksyms_32.o
  CC      arch/x86/kernel/pci-dma_32.o
  CC      arch/x86/kernel/bootflag.o
  AS      arch/x86/crypto/salsa20-i586-asm_32.o
  CC      arch/x86/kernel/e820_32.o
  CC      arch/x86/kernel/quirks.o
  CC      arch/x86/crypto/salsa20_glue.o
  CC      arch/x86/kernel/i8237.o
  AS      arch/x86/crypto/twofish-i586-asm_32.o
  CC      arch/x86/crypto/twofish_glue.o
  CC      arch/x86/kernel/topology.o
  CC      arch/x86/kernel/kdebugfs.o
  CC      arch/x86/kernel/alternative.o
  LDS     arch/x86/vdso/vdso32/vdso32.lds
  CC      arch/x86/kernel/i8253.o
  AS      arch/x86/vdso/vdso32/note.o
  AS      arch/x86/vdso/vdso32/int80.o
  CC      arch/x86/kernel/tsc_32.o
  AS      arch/x86/vdso/vdso32/sysenter.o
  CC      arch/x86/vdso/vdso32-setup.o
  CC      arch/x86/kernel/rtc.o
  CC      arch/x86/kernel/io_delay.o
  CC      arch/x86/kernel/i387.o
  CC      arch/x86/kernel/ptrace.o
  CC      arch/x86/kernel/ds.o
  CC      arch/x86/kernel/tls.o
  CC      arch/x86/kernel/step.o
  CC      kernel/sched.o
  CC      arch/x86/kernel/stacktrace.o
  CC      kernel/fork.o
  CC      kernel/exec_domain.o
  CC      kernel/panic.o
  CC      kernel/printk.o
  CC      arch/x86/kernel/reboot.o
  CC      arch/x86/kernel/acpi/boot.o
  CC      mm/bootmem.o
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
  CC      arch/x86/kernel/cpu/addon_cpuid_features.o
  CC      arch/x86/kernel/cpu/feature_names.o
  CC      mm/filemap.o
  CC      arch/x86/kernel/acpi/sleep.o
  CC      kernel/profile.o
  CC      kernel/exit.o
  CC      mm/mempool.o
  CC      arch/x86/kernel/msr.o
  CC      arch/x86/kernel/microcode.o
  CC      mm/oom_kill.o
  AS      arch/x86/kernel/acpi/wakeup_32.o
  CC      arch/x86/kernel/cpu/common.o
  CC      kernel/itimer.o
  TIMEC   kernel/timeconst.h
  CC      mm/fadvise.o
  CC      arch/x86/kernel/early-quirks.o
  CC      arch/x86/kernel/acpi/cstate.o
  CC      kernel/softirq.o
  CC      arch/x86/kernel/cpu/proc.o
  CC      mm/maccess.o
  CC      arch/x86/kernel/apm_32.o
  CC      arch/x86/kernel/acpi/processor.o
  CC      arch/x86/kernel/cpu/bugs.o
  CC      mm/page_alloc.o
  CC      kernel/resource.o
  CC      arch/x86/kernel/scx200_32.o
  CC      mm/page-writeback.o
  CC      arch/x86/kernel/cpu/amd.o
  CC      kernel/sysctl.o
  CC      arch/x86/kernel/mpparse_32.o
  CC      mm/pdflush.o
  CC      kernel/capability.o
  CC      arch/x86/kernel/cpu/cyrix.o
  CC      mm/readahead.o
  CC      kernel/ptrace.o
  CC      arch/x86/kernel/apic_32.o
  CC      arch/x86/kernel/nmi_32.o
  CC      kernel/timer.o
  CC      fs/open.o
  CC      arch/x86/kernel/cpu/centaur.o
  CC      fs/read_write.o
  CC      mm/swap.o
  CC      arch/x86/kernel/io_apic_32.o
  CC      kernel/user.o
  CC      fs/file_table.o
  LD      arch/x86/crypto/twofish-i586.o
  CC      arch/x86/kernel/machine_kexec_32.o
  CC      fs/super.o
  CC      kernel/signal.o
  LD      arch/x86/mach-default/built-in.o
  CC      arch/x86/kernel/cpu/transmeta.o
  CC      mm/truncate.o
  LD      arch/x86/crypto/salsa20-i586.o
  VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
  AS      arch/x86/kernel/relocate_kernel_32.o
  LD      arch/x86/mm/mmiotrace.o
  LD      init/mounts.o
  CC      fs/char_dev.o
  CC      arch/x86/kernel/crash.o
  CC      arch/x86/kernel/cpu/intel.o
  CC      mm/vmscan.o
  CC      fs/stat.o
  CC      kernel/sys.o
  LD      init/built-in.o
  LD      arch/x86/crypto/built-in.o
  CC      arch/x86/kernel/crash_dump_32.o
  CC      mm/prio_tree.o
  CC      arch/x86/kernel/cpu/nexgen.o
  CC      kernel/kmod.o
  CC      fs/exec.o
  CC      arch/x86/kernel/doublefault_32.o
  CC      arch/x86/kernel/cpu/umc.o
  CC      mm/util.o
  CC      fs/pipe.o
  CC      arch/x86/kernel/kgdb.o
  CC      mm/mmzone.o
  CC      arch/x86/kernel/cpu/mcheck/mce_32.o
  CC      kernel/workqueue.o
  CC      arch/x86/kernel/cpu/perfctr-watchdog.o
  CC      arch/x86/kernel/cpu/mcheck/therm_throt.o
  CC      arch/x86/kernel/cpu/mcheck/k7.o
  CC      fs/namei.o
  CC      arch/x86/kernel/early_printk.o
  CC      arch/x86/kernel/cpu/mcheck/p4.o
  CC      mm/vmstat.o
  CC      kernel/pid.o
  CC      fs/fcntl.o
  CC      arch/x86/kernel/cpu/mcheck/p5.o
  CC      arch/x86/kernel/hpet.o
  CC      mm/backing-dev.o
  CC      arch/x86/kernel/cpu/mcheck/p6.o
  CC      kernel/rcupdate.o
  CC      fs/ioctl.o
  CC      arch/x86/kernel/k8.o
  CC      arch/x86/kernel/cpu/mcheck/winchip.o
  CC      fs/readdir.o
  CC      fs/select.o
  CC      arch/x86/kernel/paravirt_patch_32.o
  CC      fs/fifo.o
  CC      arch/x86/kernel/pcspeaker.o
  CC      arch/x86/kernel/paravirt.o
  CC      mm/page_isolation.o
  CC      ipc/mqueue.o
  CC      arch/x86/kernel/cpu/mcheck/non-fatal.o
  CC      ipc/msgutil.o
  AS      arch/x86/kernel/head_32.o
  CC      fs/locks.o
  CC      mm/fremap.o
  CC      kernel/extable.o
  CC      fs/dcache.o
  CC      arch/x86/kernel/init_task.o
  CC      mm/highmem.o
  CC      kernel/params.o
  CC      fs/inode.o
  LDS     arch/x86/kernel/vmlinux.lds
  CC      kernel/posix-timers.o
  CC      fs/attr.o
  CC      fs/bad_inode.o
  CC      kernel/kthread.o
  CC      mm/madvise.o
  CC      mm/memory.o
  CC      kernel/wait.o
  CC      fs/file.o
  CC      fs/filesystems.o
  CC      mm/mincore.o
  CC      kernel/kfifo.o
  LD      arch/x86/kernel/acpi/built-in.o
  CC      kernel/sys_ni.o
  CC      fs/namespace.o
  CC      mm/mlock.o
  CC      mm/mmap.o
  CC      fs/aio.o
  CC      kernel/posix-cpu-timers.o
  CC      mm/mprotect.o
  CC      fs/seq_file.o
  CC      mm/mremap.o
  CC      kernel/mutex.o
  CC      security/keys/key.o
  CC      kernel/hrtimer.o
  CC      fs/xattr.o
  CC      mm/msync.o
  CC      security/selinux/avc.o
  CC      security/keys/keyring.o
  CC      security/selinux/hooks.o
  CC      kernel/rwsem.o
  CC      mm/rmap.o
  CC      fs/libfs.o
  CC      security/security.o
  CC      mm/vmalloc.o
  CC      security/keys/keyctl.o
  CC      kernel/nsproxy.o
  CC      security/selinux/selinuxfs.o
  CC      security/dummy.o
  CC      security/keys/permission.o
  CC      kernel/srcu.o
  CC      fs/fs-writeback.o
  CC      security/inode.o
  CC      security/selinux/netlink.o
  CC      mm/pagewalk.o
  CC      kernel/notifier.o
  CC      security/keys/process_keys.o
  CC      mm/bounce.o
  CC      security/selinux/nlmsgtab.o
  CC      security/commoncap.o
  CC      kernel/ksysfs.o
  CC      fs/pnode.o
  CC      security/keys/request_key.o
  LD      arch/x86/kernel/apm.o
  CC      mm/page_io.o
  CC      security/selinux/netif.o
  CC      kernel/pm_qos_params.o
  LD      arch/x86/kernel/scx200.o
  VDSO    arch/x86/vdso/vdso32-int80.so.dbg
  CC      security/keys/request_key_auth.o
  CC      mm/swap_state.o
  CC      security/selinux/netnode.o
  CC      security/capability.o
  CC      kernel/sysctl_check.o
  CC      kernel/stacktrace.o
  CC      fs/drop_caches.o
  CC      kernel/irq/handle.o
  CC      kernel/power/main.o
  CC      fs/splice.o
  OBJCOPY arch/x86/vdso/vdso32-int80.so
  CC      fs/sync.o
  CC      crypto/api.o
  CC      security/selinux/exports.o
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  CC      fs/utimes.o
  OBJCOPY arch/x86/vdso/vdso32-sysenter.so
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  CC      mm/swapfile.o
  AS      arch/x86/vdso/vdso32.o
  CC      fs/stack.o
  CC      kernel/irq/manage.o
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  CC      security/selinux/xfrm.o
  CC      mm/thrash.o
  CC      kernel/time/timekeeping.o
  CC      fs/buffer.o
  CC      mm/dmapool.o
  CC      kernel/time/ntp.o
  CC      fs/bio.o
  LD      arch/x86/vdso/built-in.o
  CC      kernel/trace/ftrace.o
  CC      kernel/mutex-debug.o
  CC      mm/tiny-shmem.o
  CC      kernel/lockdep.o
  CC      fs/block_dev.o
  CC      block/elevator.o
  CC      kernel/lockdep_proc.o
  CC      mm/slab.o
  CC      security/keys/user_defined.o
  CC      drivers/acpi/tables.o
  CC      drivers/ata/libata-core.o
  CC      mm/filemap_xip.o
  LD      arch/x86/mm/built-in.o
  CC      mm/quicklist.o
  LD      arch/x86/mach-generic/../../x86/mach-es7000/built-in.o
  LD      arch/x86/mach-generic/built-in.o
  CC      drivers/ata/libata-scsi.o
  CC      sound/sound_core.o
  CC      kernel/futex.o
  CC      drivers/ata/libata-sff.o
  CC      kernel/rtmutex.o
  CC      arch/x86/pci/i386.o
  CC      fs/direct-io.o
  CC      fs/mpage.o
  CC      fs/ioprio.o
  CC      fs/inotify.o
  CC      kernel/rtmutex-debug.o
  CC      kernel/dma.o
  CC      fs/inotify_user.o
  LD      arch/x86/kernel/cpu/mcheck/built-in.o
  CC      security/selinux/netlabel.o
  CC      kernel/spinlock.o
  CC      security/selinux/ss/ebitmap.o
  CC      kernel/uid16.o
  CC      kernel/kallsyms.o
  CC      fs/eventpoll.o
  CC      kernel/kexec.o
  CC      fs/anon_inodes.o
  CC      drivers/ata/libata-eh.o
  CC      fs/signalfd.o
  CC      fs/eventfd.o
  CC      fs/binfmt_script.o
  CC      kernel/audit.o
  CC      kernel/auditfilter.o
  CC      kernel/kgdb.o
  CC      fs/binfmt_elf.o
  CC      drivers/ata/libata-pmp.o
  CC      kernel/seccomp.o
  CC      kernel/rcuclassic.o
  CC      kernel/irq/spurious.o
  CC      kernel/relay.o
  CC      fs/mbcache.o
  CC      kernel/utsname_sysctl.o
  CC      fs/posix_acl.o
  CC      kernel/marker.o
  CC      drivers/acpi/blacklist.o
  CC      kernel/power/process.o
  CC      drivers/acpi/osl.o
  CC      kernel/latencytop.o
  CC      drivers/acpi/utils.o
  CC      kernel/power/console.o
  CC      kernel/time.o
  CC      fs/xattr_acl.o
  CC      kernel/power/poweroff.o
  CC      fs/adfs/dir.o
  CC      fs/adfs/dir_f.o
  CC      drivers/acpi/dispatcher/dsfield.o
  CC      drivers/acpi/dispatcher/dsmthdat.o
  LD      drivers/atm/built-in.o
  LD      drivers/auxdisplay/built-in.o
  CC      drivers/block/brd.o
  CC      drivers/base/core.o
  CC      drivers/base/sys.o
  CC      drivers/base/bus.o
  CC      drivers/base/dd.o
  CC      kernel/irq/resend.o
  CC      kernel/irq/chip.o
  CC      security/keys/proc.o
  CC      fs/autofs/dirhash.o
  CC      drivers/block/cpqarray.o
  CC      kernel/irq/devres.o
  CC      fs/configfs/inode.o
  CC      kernel/time/clocksource.o
security/selinux/netnode.c: In function 'sel_netnode_find':
security/selinux/netnode.c:126: warning: 'idx' may be used uninitialized in this function
security/selinux/netnode.c: In function 'sel_netnode_sid':
security/selinux/netnode.c:225: warning: 'ret' may be used uninitialized in this function
security/selinux/netnode.c:225: note: 'ret' was declared here
security/selinux/netnode.c:168: warning: 'idx' may be used uninitialized in this function
security/selinux/netnode.c:168: note: 'idx' was declared here
  CC      kernel/time/jiffies.o
  CC      fs/cramfs/inode.o
  CC      fs/cramfs/uncompress.o
  CC      kernel/trace/trace.o
  CC      kernel/trace/trace_sched_switch.o
  CC      fs/debugfs/inode.o
  CC      kernel/trace/trace_functions.o
  CC      kernel/irq/autoprobe.o
  CC      kernel/irq/proc.o
  CC      fs/configfs/file.o
  CC      fs/devpts/inode.o
  CC      drivers/acpi/dispatcher/dsopcode.o
  CC      block/blk-core.o
  CC      kernel/time/timer_list.o
  CC      drivers/acpi/events/evevent.o
  CC      fs/configfs/dir.o
  LD      arch/x86/kernel/cpu/built-in.o
  CC      drivers/acpi/events/evregion.o
  CC      drivers/ata/libata-acpi.o
  CC      drivers/acpi/events/evsci.o
  CC      kernel/time/clockevents.o
  CC      fs/configfs/symlink.o
  CC      fs/configfs/mount.o
  CC      crypto/cipher.o
  CC      kernel/time/tick-common.o
  CC      fs/dlm/ast.o
  CC      drivers/acpi/dispatcher/dswexec.o
  CC      drivers/base/driver.o
  CC      drivers/acpi/dispatcher/dswscope.o
  CC      drivers/acpi/dispatcher/dsmethod.o
  CC      drivers/acpi/dispatcher/dsobject.o
  CC      fs/configfs/item.o
  CC      sound/sound_firmware.o
  CC      fs/efs/super.o
  CC      drivers/acpi/executer/exconfig.o
  CC      drivers/acpi/dispatcher/dsutils.o
  CC      drivers/acpi/dispatcher/dswload.o
  CC      fs/ext3/balloc.o
  CC      fs/ext2/balloc.o
  CC      fs/fat/cache.o
  CC      fs/fat/dir.o
  CC      fs/debugfs/file.o
  CC      drivers/acpi/events/evxfevnt.o
  CC      security/selinux/ss/hashtab.o
  CC      fs/gfs2/acl.o
  CC      drivers/base/class.o
  CC      drivers/base/platform.o
  CC      fs/gfs2/bmap.o
  CC      drivers/base/cpu.o
  CC      drivers/base/firmware.o
  CC      drivers/base/init.o
  CC      drivers/acpi/dispatcher/dswstate.o
  CC      fs/hpfs/alloc.o
  CC      crypto/digest.o
  CC      crypto/compress.o
  CC      drivers/base/map.o
  CC      crypto/algapi.o
  CC      drivers/base/devres.o
  CC      fs/dlm/config.o
  CC      drivers/base/attribute_container.o
  CC      drivers/acpi/hardware/hwacpi.o
  CC      crypto/scatterwalk.o
  CC      drivers/acpi/hardware/hwgpe.o
  CC      fs/jbd/transaction.o
  CC      fs/isofs/namei.o
  CC      drivers/base/transport_class.o
  CC      fs/jfs/super.o
  CC      fs/minix/bitmap.o
  CC      fs/msdos/namei.o
  CC      drivers/acpi/dispatcher/dsinit.o
  CC      drivers/acpi/events/evmisc.o
  CC      fs/dlm/dir.o
  LD      sound/arm/built-in.o
  CC      fs/jfs/file.o
  CC      sound/core/hwdep.o
  CC      security/selinux/ss/symtab.o
  CC      fs/nls/nls_base.o
  CC      fs/nls/nls_cp775.o
  CC      fs/ntfs/aops.o
  LD      fs/devpts/devpts.o
  CC      kernel/time/tick-broadcast.o
  LD      fs/devpts/built-in.o
  CC      fs/adfs/dir_fplus.o
  CC      kernel/time/tick-oneshot.o
  CC      fs/partitions/check.o
  CC      fs/adfs/file.o
  CC      fs/adfs/inode.o
  CC      fs/proc/mmu.o
  CC      kernel/time/tick-sched.o
  CC      crypto/proc.o
  CC      fs/ramfs/inode.o
  CC      fs/partitions/acorn.o
  CC      crypto/ablkcipher.o
  CC      crypto/blkcipher.o
  CC      block/blk-tag.o
  CC      block/blk-sysfs.o
  CC      block/blk-barrier.o
  CC      fs/reiserfs/bitmap.o
  CC      drivers/acpi/hardware/hwregs.o
  CC      fs/reiserfs/do_balan.o
  CC      kernel/trace/trace_irqsoff.o
  CC      kernel/time/timer_stats.o
  CC      fs/reiserfs/namei.o
  CC      fs/nls/nls_cp852.o
  CC      fs/romfs/inode.o
  CC      drivers/acpi/namespace/nsaccess.o
  CC      kernel/trace/trace_sched_wakeup.o
  CC      drivers/base/power/sysfs.o
  CC      drivers/base/power/main.o
  CC      drivers/base/dma-mapping.o
  CC      fs/sysfs/inode.o
  CC      fs/sysfs/file.o
  CC      fs/sysfs/dir.o
  CC      fs/sysv/ialloc.o
  CC      drivers/ata/ahci.o
  CC      fs/dcookies.o
  LD      kernel/power/built-in.o
  CC      drivers/ata/sata_svw.o
  CC      fs/efs/inode.o
  CC      fs/jfs/inode.o
  CC      drivers/base/firmware_class.o
  CC      fs/jfs/namei.o
  CC      fs/fat/fatent.o
  CC      drivers/acpi/executer/exfield.o
  CC      drivers/acpi/parser/psargs.o
  CC      drivers/acpi/executer/exnames.o
  CC      fs/autofs/init.o
  CC      fs/partitions/msdos.o
  CC      fs/adfs/map.o
  CC      fs/nls/nls_cp857.o
  CC      fs/adfs/super.o
  CC      drivers/acpi/executer/exoparg6.o
  CC      crypto/hash.o
  CC      fs/nls/nls_cp860.o
  CC      fs/nls/nls_cp861.o
  CC      fs/nls/nls_cp865.o
  CC      security/selinux/ss/sidtab.o
  CC      fs/proc/task_mmu.o
  CC      drivers/base/power/trace.o
  CC      fs/ext3/bitmap.o
  CC      drivers/acpi/events/evrgnini.o
  CC      drivers/acpi/events/evxface.o
  CC      drivers/acpi/events/evxfregn.o
  CC      fs/partitions/sgi.o
  CC      fs/partitions/sysv68.o
  LD      fs/msdos/msdos.o
  LD      fs/msdos/built-in.o
  CC      drivers/acpi/events/evgpe.o
  CC      fs/ext3/dir.o
  CC      fs/nls/nls_cp866.o
  LD      fs/debugfs/debugfs.o
  CC      fs/nls/nls_cp936.o
  CC      fs/nls/nls_cp950.o
  LD      fs/debugfs/built-in.o
  CC      crypto/aead.o
  CC      fs/ext3/file.o
  LD      kernel/irq/built-in.o
  CC      fs/fat/file.o
  CC      crypto/chainiv.o
  CC      drivers/block/aoe/aoeblk.o
  CC      fs/ext3/fsync.o
  CC      fs/minix/itree_v1.o
  CC      drivers/block/aoe/aoechr.o
  CC      drivers/acpi/namespace/nsload.o
  CC      drivers/bluetooth/hci_usb.o
  CC      crypto/eseqiv.o
  CC      drivers/acpi/namespace/nssearch.o
  CC      drivers/acpi/namespace/nsxfeval.o
  CC      drivers/acpi/executer/exresolv.o
  CC      drivers/acpi/executer/exstorob.o
  CC      drivers/acpi/executer/exconvrt.o
  CC      drivers/acpi/hardware/hwsleep.o
  LD      kernel/time/built-in.o
  CC      drivers/acpi/executer/exfldio.o
  LD      security/keys/built-in.o
  CC      crypto/seqiv.o
  CC      fs/autofs/inode.o
  CC      fs/autofs/root.o
  CC      fs/autofs/symlink.o
  LD      kernel/trace/libftrace.o
  LD      drivers/cdrom/built-in.o
  CC      fs/nls/nls_ascii.o
  CC      drivers/char/mem.o
  CC      block/blk-settings.o
  CC      drivers/acpi/events/evgpeblk.o
  CC      block/blk-ioc.o
  LD      ipc/built-in.o
  CC      drivers/clocksource/cyclone.o
  CC      sound/core/memalloc.o
  CC      sound/core/sgbuf.o
  CC      arch/x86/power/cpu_32.o
  CC      fs/gfs2/daemon.o
  CC      fs/gfs2/dir.o
  CC      fs/ntfs/attrib.o
  CC      drivers/acpi/namespace/nsalloc.o
  CC      crypto/cryptomgr.o
  CC      fs/autofs/waitq.o
  CC      drivers/ata/ata_piix.o
  CC      fs/nls/nls_iso8859-2.o
  CC      drivers/ata/sata_qstor.o
  CC      drivers/acpi/namespace/nseval.o
  CC      fs/ntfs/collate.o
  CC      drivers/ata/sata_sil.o
  CC      crypto/hmac.o
  CC      fs/efs/namei.o
  CC      fs/jfs/jfs_mount.o
  CC      fs/sysfs/symlink.o
  CC      fs/ext3/ialloc.o
  CC      drivers/acpi/executer/exoparg1.o
  CC      fs/nls/nls_iso8859-3.o
  CC      fs/efs/dir.o
  CC      sound/core/pcm.o
  CC      drivers/acpi/executer/exprep.o
  CC      fs/ext3/inode.o
  CC      fs/nls/nls_cp1255.o
  CC      fs/nls/nls_iso8859-9.o
  CC      fs/ext3/ioctl.o
  CC      fs/isofs/inode.o
  CC      drivers/acpi/namespace/nsnames.o
  CC      drivers/acpi/namespace/nsutils.o
  CC      fs/ext2/dir.o
  CC      fs/ext3/namei.o
  CC      fs/ext2/file.o
  CC      crypto/xcbc.o
  CC      crypto/crypto_null.o
  CC      drivers/acpi/executer/exresop.o
  CC      fs/ext2/fsync.o
  CC      crypto/md5.o
  CC      drivers/acpi/namespace/nsxfname.o
  CC      fs/sysfs/mount.o
  CC      arch/x86/pci/init.o
  CC      drivers/acpi/namespace/nsdump.o
  CC      drivers/acpi/namespace/nsinit.o
  CC      drivers/acpi/namespace/nsobject.o
  CC      drivers/acpi/parser/psparse.o
  CC      drivers/acpi/namespace/nswalk.o
  CC      drivers/acpi/namespace/nsxfobj.o
  CC      fs/ramfs/file-mmu.o
  CC      drivers/acpi/namespace/nsparse.o
  CC      drivers/acpi/parser/psloop.o
  CC      drivers/acpi/executer/exsystem.o
  LD      arch/x86/kernel/built-in.o
  CC      drivers/acpi/executer/excreate.o
  CC      fs/fat/inode.o
  CC      fs/sysfs/bin.o
  CC      drivers/acpi/resources/rsaddr.o
  CC      drivers/acpi/resources/rscreate.o
  CC      fs/ntfs/compress.o
  CC      net/socket.o
  CC      block/blk-map.o
  CC      block/blk-exec.o
  CC      drivers/block/aoe/aoecmd.o
  CC      fs/gfs2/eaops.o
  CC      drivers/acpi/executer/exmisc.o
  CC      crypto/sha1_generic.o
  LD      drivers/base/power/built-in.o
  CC      arch/x86/pci/pcbios.o
  CC      crypto/sha256_generic.o
  CC      drivers/char/random.o
  CC      fs/gfs2/eattr.o
  CC      fs/efs/file.o
  CC      fs/fat/misc.o
  CC      block/blk-merge.o
  CC      block/ioctl.o
  CC      fs/efs/symlink.o
  CC      block/genhd.o
  CC      block/scsi_ioctl.o
  LD      fs/cramfs/cramfs.o
  LD      fs/cramfs/built-in.o
  CC      fs/ext3/super.o
  CC      block/noop-iosched.o
  CC      fs/ext3/symlink.o
  CC      fs/ext3/hash.o
  CC      drivers/acpi/executer/exoparg2.o
  CC      crypto/sha512.o
  CC      crypto/tgr192.o
  CC      fs/ext2/ialloc.o
  CC      lib/div64.o
  CC      drivers/acpi/executer/exregion.o
  CC      drivers/acpi/executer/exstore.o
  CC      fs/sysfs/group.o
  CC      sound/core/pcm_native.o
  CC      drivers/acpi/executer/exutils.o
  CC      sound/core/pcm_lib.o
  CC      sound/core/pcm_timer.o
  CC      fs/ext3/resize.o
  LD      fs/partitions/built-in.o
  CC      fs/ext3/ext3_jbd.o
  CC      fs/ext3/xattr.o
  CC      drivers/acpi/executer/exdump.o
  CC      lib/sort.o
  CC      lib/parser.o
  CC      drivers/block/aoe/aoedev.o
  CC      lib/halfmd4.o
  CC      arch/x86/pci/fixup.o
  CC      block/deadline-iosched.o
  CC      arch/x86/pci/acpi.o
  CC      drivers/ata/sata_sis.o
  CC      crypto/gf128mul.o
  CC      crypto/ecb.o
  LD      arch/x86/power/built-in.o
  CC      drivers/block/cciss.o
  CC      block/cfq-iosched.o
  CC      sound/core/pcm_misc.o
  CC      fs/ext2/inode.o
  CC      crypto/cbc.o
  LD      fs/ramfs/ramfs.o
  CC      crypto/pcbc.o
  CC      fs/gfs2/glock.o
  CC      fs/ext3/xattr_user.o
  CC      fs/ext2/ioctl.o
  CC      drivers/acpi/executer/exmutex.o
  LD      fs/ramfs/built-in.o
  CC      fs/jfs/jfs_umount.o
  LD      fs/configfs/configfs.o
  LD      fs/romfs/romfs.o
  LD      arch/x86/lib/built-in.o
  LD      fs/romfs/built-in.o
  CC      arch/x86/lib/bitops_32.o
  CC      drivers/acpi/executer/exoparg3.o
  LD      fs/configfs/built-in.o
  CC      drivers/acpi/resources/rsinfo.o
  CC      drivers/ata/sata_sx4.o
  AS      arch/x86/lib/checksum_32.o
  CC      drivers/acpi/executer/exresnte.o
  CC      arch/x86/lib/delay_32.o
  CC      drivers/acpi/executer/exstoren.o
  CC      block/blktrace.o
  CC      security/selinux/ss/avtab.o
  CC      drivers/acpi/resources/rsio.o
  AS      arch/x86/lib/getuser_32.o
  CC      arch/x86/lib/memcpy_32.o
  CC      drivers/acpi/resources/rslist.o
  CC      drivers/acpi/parser/pstree.o
  CC      drivers/acpi/resources/rsmisc.o
  AS      arch/x86/lib/putuser_32.o
  CC      drivers/ata/sata_uli.o
  CC      drivers/acpi/resources/rsxface.o
  AS      arch/x86/lib/semaphore_32.o
mm/slab.c: In function 'kfree':
mm/slab.c:3795: warning: passing argument 2 of '__cache_free' discards qualifiers from pointer target type
  CC      drivers/acpi/resources/rscalc.o
  CC      drivers/acpi/parser/pswalk.o
  CC      arch/x86/lib/string_32.o
  CC      drivers/acpi/resources/rsirq.o
  CC      drivers/acpi/resources/rsmemory.o
  CC      fs/ext3/xattr_trusted.o
  CC      crypto/ctr.o
  CC      drivers/ata/sata_mv.o
  CC      drivers/acpi/resources/rsutils.o
  LD      drivers/base/built-in.o
  CC      fs/ext3/acl.o
  CC      lib/debug_locks.o
  CC      drivers/cpuidle/cpuidle.o
  CC      drivers/acpi/parser/psopcode.o
  CC      fs/ext3/xattr_security.o
  LD      drivers/acpi/dispatcher/built-in.o
  CC      drivers/crypto/padlock-aes.o
  LD      fs/adfs/adfs.o
  CC      crypto/cryptd.o
  CC      fs/gfs2/glops.o
  LD      mm/built-in.o
  CC      fs/dlm/lock.o
  CC      fs/hpfs/anode.o
kernel/audit.c: In function 'audit_log_start':
kernel/audit.c:1041: warning: 't.tv_nsec' may be used uninitialized in this function
kernel/audit.c:1041: warning: 't.tv_sec' may be used uninitialized in this function
  CC      fs/gfs2/inode.o
  CC      fs/dlm/lockspace.o
  LD      fs/adfs/built-in.o
  CC      drivers/acpi/parser/psscope.o
  CC      crypto/des_generic.o
  CC      fs/hpfs/buffer.o
  CC      drivers/acpi/sleep/wakeup.o
  CC      drivers/crypto/padlock-sha.o
  LD      drivers/acpi/events/built-in.o
  CC      drivers/cpuidle/driver.o
  CC      fs/dlm/main.o
  CC      fs/hpfs/dentry.o
  CC      sound/core/pcm_memory.o
  CC      drivers/acpi/parser/psutils.o
  CC      fs/ext2/namei.o
  CC      sound/core/rawmidi.o
  CC      drivers/acpi/parser/psxface.o
  CC      drivers/acpi/tables/tbxface.o
  CC      drivers/acpi/tables/tbinstal.o
  CC      drivers/char/tty_io.o
  CC      crypto/fcrypt.o
  CC      drivers/bluetooth/hci_ldisc.o
  CC      fs/ext2/super.o
  CC      lib/random32.o
  CC      fs/jfs/jfs_xtree.o
  CC      fs/ext2/symlink.o
  CC      drivers/clocksource/acpi_pm.o
  CC      arch/x86/pci/legacy.o
  CC      fs/dlm/member.o
  CC      fs/ext2/xattr.o
  LD      fs/efs/efs.o
  CC      crypto/twofish.o
  LD      fs/efs/built-in.o
  CC      fs/ext2/xattr_user.o
  CC      crypto/twofish_common.o
  CC      arch/x86/lib/strstr_32.o
  AS      arch/x86/lib/thunk_32.o
  CC      drivers/cpuidle/governor.o
  CC      drivers/cpuidle/sysfs.o
  CC      crypto/camellia.o
  CC      arch/x86/lib/usercopy_32.o
  CC      drivers/ata/pdc_adma.o
  CC      fs/reiserfs/inode.o
fs/jfs/namei.c: In function 'jfs_ci_compare':
fs/jfs/namei.c:1597: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
fs/jfs/namei.c:1597: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      fs/reiserfs/file.o
  CC      sound/core/timer.o
  CC      drivers/block/aoe/aoemain.o
  CC      drivers/ata/pata_ali.o
  CC      fs/sysv/balloc.o
  LD      fs/autofs/autofs.o
  LD      fs/autofs/built-in.o
  CC      sound/core/sound.o
  CC      drivers/char/n_tty.o
  CC      drivers/char/tty_ioctl.o
  CC      lib/bust_spinlocks.o
  CC      fs/minix/itree_v2.o
  CC      fs/jfs/jfs_imap.o
  CC      fs/minix/namei.o
  CC      fs/jfs/jfs_debug.o
  CC      drivers/cpuidle/governors/ladder.o
  CC      fs/jfs/jfs_dmap.o
  CC      drivers/cpuidle/governors/menu.o
  CC      drivers/acpi/tables/tbutils.o
  CC      fs/proc/inode.o
  CC      drivers/ata/pata_amd.o
  LD      drivers/acpi/namespace/built-in.o
  CC      drivers/ata/pata_cs5520.o
  CC      drivers/acpi/utilities/utalloc.o
  CC      drivers/ata/pata_cs5530.o
  LD      drivers/acpi/executer/built-in.o
  CC      fs/ext2/xattr_trusted.o
  CC      drivers/acpi/bus.o
  CC      drivers/block/aoe/aoenet.o
  CC      drivers/acpi/tables/tbfind.o
  CC      fs/isofs/dir.o
  CC      fs/isofs/util.o
  CC      fs/jbd/commit.o
  CC      fs/hpfs/dir.o
  CC      fs/hpfs/dnode.o
  CC      fs/jbd/recovery.o
  CC      fs/jbd/checkpoint.o
  CC      fs/jbd/revoke.o
  LD      kernel/trace/built-in.o
  CC      lib/hexdump.o
  CC      fs/hpfs/ea.o
  CC      fs/jfs/jfs_unicode.o
  CC      fs/hpfs/file.o
  CC      sound/core/init.o
  CC      crypto/arc4.o
  CC      fs/hpfs/inode.o
  CC      sound/core/memory.o
  CC      fs/jfs/jfs_dtree.o
  CC      drivers/char/pty.o
  CC      security/selinux/ss/policydb.o
  CC      fs/jfs/jfs_inode.o
  CC      fs/hpfs/map.o
  CC      drivers/crypto/geode-aes.o
  CC      lib/kasprintf.o
  CC      arch/x86/pci/irq.o
  CC      crypto/khazad.o
  CC      fs/ext2/acl.o
  CC      arch/x86/pci/common.o
  CC      arch/x86/pci/early.o
  LD      fs/nls/built-in.o
  CC      lib/bitmap.o
  CC      fs/gfs2/lm.o
  LD      drivers/acpi/hardware/built-in.o
  CC      drivers/acpi/glue.o
  CC      crypto/seed.o
  CC      drivers/acpi/tables/tbfadt.o
  CC      fs/ntfs/debug.o
  CC      fs/ntfs/dir.o
  CC      fs/dlm/memory.o
  CC      fs/ext2/xip.o
  LD      fs/fat/fat.o
  LD      fs/fat/built-in.o
  CC      drivers/acpi/tables/tbxfroot.o
  CC      fs/dlm/midcomms.o
  CC      drivers/crypto/hifn_795x.o
  LD      fs/sysfs/built-in.o
  CC      crypto/salsa20_generic.o
  CC      lib/scatterlist.o
  CC      lib/iomap.o
  CC      fs/reiserfs/dir.o
  CC      drivers/bluetooth/hci_h4.o
  CC      sound/core/info.o
  CC      sound/core/control.o
  CC      crypto/deflate.o
  CC      drivers/acpi/sleep/main.o
  CC      fs/sysv/inode.o
  CC      drivers/ata/pata_cs5535.o
  CC      drivers/ata/pata_cypress.o
  CC      crypto/crc32c.o
  CC      fs/jfs/jfs_extent.o
  LD      crypto/crypto_algapi.o
  CC      fs/ntfs/file.o
  LD      crypto/crypto_blkcipher.o
  CC      drivers/bluetooth/hci_ll.o
  CC      fs/reiserfs/fix_node.o
  CC      fs/hpfs/name.o
  CC      fs/hpfs/namei.o
  LD      crypto/crypto_hash.o
  CC      drivers/block/DAC960.o
  LD      drivers/block/aoe/aoe.o
  CC      fs/proc/root.o
  LD      drivers/block/aoe/built-in.o
  CC      drivers/block/umem.o
  CC      drivers/ata/pata_efar.o
  CC      fs/hpfs/super.o
  CC      drivers/clocksource/scx200_hrt.o
  CC      drivers/ata/pata_hpt3x2n.o
  CC      lib/iomap_copy.o
  CC      drivers/acpi/scan.o
  CC      drivers/firewire/fw-card.o
  CC      drivers/firmware/dmi_scan.o
  CC      drivers/block/nbd.o
  CC      drivers/ata/pata_it821x.o
  CC      fs/dlm/netlink.o
  CC      drivers/ata/pata_jmicron.o
  CC      lib/devres.o
  CC      fs/dlm/lowcomms.o
  CC      lib/spinlock_debug.o
  CC      lib/hweight.o
  LD      drivers/acpi/tables/built-in.o
  CC      drivers/acpi/ec.o
  CC      drivers/acpi/ac.o
  CC      fs/dlm/rcom.o
  CC      fs/dlm/recover.o
  CC      fs/dlm/recoverd.o
  CC      fs/isofs/rock.o
  CC      lib/plist.o
  CC      drivers/ata/pata_netcell.o
  CC      sound/core/misc.o
  LD      drivers/acpi/resources/built-in.o
  CC      drivers/acpi/button.o
  AR      arch/x86/lib/lib.a
  CC      sound/core/device.o
  CC      drivers/acpi/fan.o
  CC      drivers/ata/pata_ninja32.o
  CC      fs/ntfs/index.o
  CC      fs/jbd/journal.o
  CC      drivers/firmware/edd.o
  CC      drivers/ata/pata_ns87415.o
  CC      fs/ntfs/inode.o
  CC      fs/dlm/requestqueue.o
  CC      drivers/ata/pata_oldpiix.o
  CC      drivers/ata/pata_pdc202xx_old.o
  CC      lib/list_debug.o
  CC      fs/jfs/symlink.o
  CC      fs/minix/inode.o
  CC      sound/core/isadma.o
  CC      sound/core/sound_oss.o
  LD      drivers/acpi/parser/built-in.o
  CC      drivers/acpi/pci_root.o
  CC      drivers/acpi/pci_link.o
  CC      net/802/p8022.o
  CC      drivers/acpi/pci_irq.o
  CC      drivers/ata/pata_sc1200.o
  CC      fs/reiserfs/super.o
  CC      fs/proc/base.o
  CC      fs/minix/file.o
  CC      fs/reiserfs/prints.o
  CC      sound/core/info_oss.o
  CC      lib/bitrev.o
  CC      lib/crc16.o
  CC      fs/proc/generic.o
  CC      fs/proc/array.o
  CC      fs/dlm/user.o
  CC      fs/jfs/jfs_metapage.o
  CC      drivers/ata/pata_serverworks.o
  CC      sound/core/oss/pcm_oss.o
  CC      fs/reiserfs/objectid.o
  CC      fs/jfs/jfs_logmgr.o
  CC      drivers/ata/pata_sil680.o
  CC      lib/crc-itu-t.o
  CC      fs/jfs/jfs_txnmgr.o
  CC      drivers/acpi/pci_bind.o
  HOSTCC  lib/gen_crc32table
  CC      lib/crc7.o
  CC      lib/libcrc32c.o
  CC      drivers/acpi/sleep/proc.o
  LD      drivers/cpuidle/governors/built-in.o
  LD      drivers/cpuidle/built-in.o
  CC      drivers/hwmon/hwmon.o
  CC      lib/genalloc.o
  CC      drivers/acpi/power.o
  CC      fs/sysv/itree.o
  CC      lib/zlib_deflate/deflate.o
  CC      lib/zlib_deflate/deftree.o
  CC      drivers/char/misc.o
  CC      drivers/char/vt_ioctl.o
  CC      drivers/char/vc_screen.o
  CC      lib/zlib_deflate/deflate_syms.o
  LD      arch/x86/pci/built-in.o
  CC      drivers/char/consolemap.o
  CC      lib/zlib_inflate/inffast.o
  CC      lib/audit.o
  CC      lib/argv_split.o
  CC      lib/cmdline.o
  CC      drivers/acpi/processor_core.o
  CC      drivers/ata/pata_sis.o
  CC      fs/gfs2/log.o
  CC      drivers/hwmon/hwmon-vid.o
  CC      fs/gfs2/lops.o
  CC      drivers/hwmon/abituguru.o
  CC      fs/dlm/util.o
  CC      drivers/hwmon/abituguru3.o
  CC      fs/minix/dir.o
  CC      drivers/acpi/utilities/utdebug.o
  CC      net/802/psnap.o
  CC      drivers/acpi/utilities/uteval.o
  CC      drivers/firewire/fw-topology.o
  CC      lib/zlib_inflate/inflate.o
  CONMK   drivers/char/consolemap_deftbl.c
  CC      drivers/char/selection.o
  CC      drivers/firewire/fw-transaction.o
  CC      lib/ctype.o
  CC      lib/dec_and_lock.o
  CC      drivers/acpi/processor_throttling.o
  CC      drivers/acpi/processor_idle.o
  CC      lib/dump_stack.o
  CC      drivers/acpi/processor_thermal.o
  CC      lib/extable.o
  CC      lib/idr.o
  CC      fs/ntfs/mft.o
  CC      drivers/hwmon/applesmc.o
  CC      fs/reiserfs/lbalance.o
  CC      lib/int_sqrt.o
  CC      lib/ioremap.o
  CC      fs/ntfs/mst.o
  CC      fs/ntfs/namei.o
  CC      fs/ntfs/runlist.o
  CC      fs/reiserfs/ibalance.o
  CC      lib/irq_regs.o
  CC      lib/klist.o
  CC      drivers/bluetooth/bcm203x.o
  CC      fs/ntfs/super.o
  CC      lib/kobject.o
  LD      fs/ext3/ext3.o
  CC      fs/ntfs/sysctl.o
  CC      drivers/acpi/utilities/utinit.o
  LD      fs/ext3/built-in.o
  CC      drivers/acpi/utilities/utmisc.o
  CC      drivers/bluetooth/bpa10x.o
  LD      drivers/clocksource/built-in.o
  CC      lib/kobject_uevent.o
  LD      drivers/i2c/algos/built-in.o
  CC      drivers/ieee1394/ieee1394_core.o
  LD      drivers/i2c/busses/built-in.o
  CC      drivers/ieee1394/ieee1394_transactions.o
  LD      drivers/i2c/chips/built-in.o
  CC      drivers/ieee1394/hosts.o
  LD      drivers/i2c/built-in.o
  CC      fs/proc/proc_tty.o
  CC      fs/proc/proc_misc.o
  CC      lib/kref.o
  CC      drivers/infiniband/core/addr.o
  CC      drivers/acpi/container.o
  CC      lib/prio_heap.o
  CC      fs/isofs/export.o
  CC      drivers/infiniband/hw/cxgb3/iwch_cm.o
  CC      drivers/acpi/thermal.o
  CC      fs/gfs2/locking.o
  CC      fs/gfs2/main.o
  CC      lib/prio_tree.o
  CC      lib/proportions.o
  CC      fs/ntfs/unistr.o
  CC      fs/ntfs/upcase.o
  CC      lib/radix-tree.o
  CC      lib/rbtree.o
  CC      fs/ntfs/bitmap.o
  CC      fs/ntfs/lcnalloc.o
  CC      drivers/acpi/system.o
  CC      lib/reciprocal_div.o
  CC      drivers/acpi/event.o
  CC      lib/rwsem.o
  CC      drivers/acpi/utilities/utxface.o
  CC      lib/semaphore-sleepers.o
  CC      drivers/acpi/asus_acpi.o
  CC      fs/reiserfs/stree.o
  LD      drivers/acpi/sleep/built-in.o
  CC      drivers/acpi/cm_sbs.o
  LD      drivers/bluetooth/hci_uart.o
  CC      fs/ntfs/logfile.o
  CC      fs/ntfs/quota.o
  CC      fs/proc/proc_net.o
  CC      fs/proc/kmsg.o
  CC      drivers/ieee1394/highlevel.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/firmware/dell_rbu.o
  CC      drivers/firmware/dmi-id.o
  CC      lib/sha1.o
  CC      lib/string.o
  LD      fs/jbd/jbd.o
  LD      fs/jbd/built-in.o
  CC      lib/vsprintf.o
  CC      fs/ntfs/usnjrnl.o
  CC      drivers/ieee1394/csr.o
  GEN     lib/crc32table.h
  CC      drivers/char/keyboard.o
  CC      drivers/char/vt.o
  CC      lib/crc32.o
  SHIPPED drivers/char/defkeymap.c
  CC      drivers/char/tty_audit.o
  CC      drivers/firewire/fw-iso.o
  CC      drivers/acpi/utilities/utcopy.o
  CC      drivers/infiniband/hw/cxgb3/iwch_ev.o
  CC      drivers/firewire/fw-device.o
  CC      drivers/firewire/fw-cdev.o
  CC      fs/sysv/file.o
  CC      net/8021q/vlan.o
  LD      kernel/built-in.o
  CC      fs/sysv/dir.o
  CC      net/8021q/vlan_dev.o
  CC      net/8021q/vlan_netlink.o
  CC      net/8021q/vlanproc.o
  CC      net/9p/mod.o
  CC      net/9p/client.o
  CC      drivers/infiniband/core/cm.o
  CC      drivers/infiniband/core/packer.o
  CC      drivers/infiniband/core/ud_header.o
  CC      drivers/char/sysrq.o
  CC      net/9p/conv.o
block/cfq-iosched.c: In function 'cfq_async_queue_prio':
block/cfq-iosched.c:1444: warning: control reaches end of non-void function
  CC      net/9p/error.o
  LD      block/built-in.o
  CC      net/9p/fcprint.o
  CC      net/9p/util.o
  LD      fs/ext2/ext2.o
  LD      fs/ext2/built-in.o
  CC      net/9p/trans_virtio.o
  CC      drivers/infiniband/core/verbs.o
  CC      drivers/infiniband/core/sysfs.o
  CC      drivers/infiniband/core/device.o
  CC      drivers/char/nozomi.o
  CC      fs/jfs/jfs_uniupr.o
  CC      fs/jfs/resize.o
  CC      fs/jfs/xattr.o
  CC      fs/jfs/ioctl.o
  CC      drivers/firewire/fw-ohci.o
  CC      drivers/char/raw.o
  CC      drivers/char/applicom.o
  CC      drivers/infiniband/core/fmr_pool.o
  CC      drivers/infiniband/core/cache.o
  CC      drivers/char/hpet.o
  CC      drivers/char/genrtc.o
  CC      drivers/infiniband/core/mad.o
  CC      drivers/infiniband/core/smi.o
  CC      drivers/infiniband/core/agent.o
  CC      drivers/infiniband/core/mad_rmpp.o
  CC      drivers/infiniband/core/sa_query.o
  CC      drivers/char/nvram.o
  CC      drivers/char/toshiba.o
  LD      fs/isofs/isofs.o
  LD      fs/isofs/built-in.o
  CC      drivers/char/i8k.o
  CC      drivers/char/scx200_gpio.o
  CC      drivers/ieee1394/nodemgr.o
  CC      lib/zlib_inflate/infutil.o
  CC      drivers/firewire/fw-sbp2.o
  CC      drivers/char/pc8736x_gpio.o
  CC      drivers/char/nsc_gpio.o
  CC      fs/gfs2/meta_io.o
  LD      drivers/bluetooth/built-in.o
  CC      drivers/input/input.o
  CC      drivers/char/cs5535_gpio.o
  CC      drivers/char/agp/backend.o
  CC      fs/reiserfs/hashes.o
  CC      fs/gfs2/mount.o
  CC      fs/gfs2/ops_address.o
  CC      drivers/char/drm/drm_auth.o
  CC      fs/sysv/namei.o
  CC      lib/zlib_inflate/inftrees.o
  CC      drivers/char/hangcheck-timer.o
  CC      drivers/hwmon/coretemp.o
  CC      drivers/hwmon/f71805f.o
  CC      drivers/acpi/utilities/utdelete.o
  CC      drivers/infiniband/core/multicast.o
  CC      drivers/infiniband/core/user_mad.o
  CC      drivers/infiniband/core/iwcm.o
  CC      drivers/infiniband/core/cma.o
  CC      drivers/hwmon/f71882fg.o
  CC      lib/zlib_inflate/inflate_syms.o
  CC      drivers/ieee1394/dma.o
  CC      drivers/block/virtio_blk.o
  CC      drivers/input/ff-core.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/input/ff-memless.o
  CC      fs/gfs2/ops_dentry.o
  CC      drivers/char/agp/frontend.o
  CC      fs/reiserfs/tail_conversion.o
  CC      drivers/input/input-polldev.o
  CC      drivers/char/consolemap_deftbl.o
  CC      drivers/char/defkeymap.o
  CC      fs/reiserfs/journal.o
  CC      drivers/hwmon/hdaps.o
  CC      drivers/char/agp/generic.o
  CC      drivers/input/mousedev.o
  CC      drivers/infiniband/hw/mlx4/ah.o
  LD      lib/zlib_inflate/zlib_inflate.o
  CC      drivers/input/evdev.o
  CC      drivers/infiniband/hw/mlx4/cq.o
  CC      drivers/ieee1394/iso.o
  LD      lib/zlib_inflate/built-in.o
  CC      drivers/ieee1394/csr1212.o
  CC      drivers/ieee1394/config_roms.o
  CC      drivers/infiniband/hw/cxgb3/iwch_cq.o
  CC      drivers/infiniband/hw/mthca/mthca_main.o
  CC      fs/reiserfs/resize.o
  CC      fs/gfs2/ops_export.o
  CC      fs/gfs2/ops_file.o
  CC      drivers/input/evbug.o
  CC      fs/gfs2/ops_fstype.o
  CC      fs/gfs2/ops_inode.o
  CC      drivers/input/joystick/a3d.o
  CC      drivers/input/keyboard/atkbd.o
  CC      drivers/input/keyboard/sunkbd.o
  CC      drivers/char/drm/drm_bufs.o
  CC      fs/gfs2/ops_super.o
  CC      fs/gfs2/quota.o
  CC      fs/gfs2/recovery.o
  CC      fs/gfs2/rgrp.o
  CC      fs/gfs2/super.o
  CC      drivers/char/drm/drm_context.o
  CC      fs/gfs2/sys.o
  CC      drivers/input/misc/pcspkr.o
  CC      drivers/char/drm/drm_dma.o
  CC      fs/reiserfs/item_ops.o
  CC      fs/reiserfs/ioctl.o
  CC      fs/reiserfs/procfs.o
  CC      drivers/char/drm/drm_drawable.o
  CC      drivers/input/misc/atlas_btns.o
  CC      drivers/hwmon/i5k_amb.o
  CC      drivers/input/misc/ati_remote2.o
  CC      drivers/char/agp/isoch.o
  CC      drivers/char/agp/amd64-agp.o
  LD      sound/core/snd.o
  LD      sound/core/snd-hwdep.o
  LD      sound/core/snd-timer.o
  LD      sound/core/snd-pcm.o
  LD      sound/core/snd-page-alloc.o
  LD      sound/core/snd-rawmidi.o
  CC      drivers/input/keyboard/lkkbd.o
  CC      drivers/input/keyboard/xtkbd.o
  CC      drivers/input/keyboard/newtonkbd.o
  CC      security/selinux/ss/services.o
  LD      lib/zlib_deflate/zlib_deflate.o
  LD      lib/zlib_deflate/built-in.o
  LD      lib/built-in.o
  CC      security/selinux/ss/conditional.o
  CC      security/selinux/ss/mls.o
  CC      drivers/infiniband/hw/cxgb3/iwch_qp.o
  CC      drivers/char/agp/intel-agp.o
  CC      drivers/infiniband/hw/mlx4/doorbell.o
  CC      drivers/infiniband/hw/mlx4/mad.o
  LD      drivers/acpi/processor.o
  CC      drivers/infiniband/hw/mlx4/main.o
  CC      fs/gfs2/trans.o
  CC      drivers/acpi/utilities/utglobal.o
  CC      drivers/input/mouse/appletouch.o
  CC      drivers/input/misc/keyspan_remote.o
  CC      fs/gfs2/util.o
  CC      fs/gfs2/locking/dlm/lock.o
  CC      drivers/input/mouse/psmouse-base.o
  CC      drivers/input/mouse/synaptics.o
  CC      drivers/input/mouse/alps.o
  CC      drivers/input/misc/powermate.o
  CC      drivers/hwmon/it87.o
  CC      drivers/hwmon/sis5595.o
  CC      drivers/hwmon/smsc47b397.o
  CC      drivers/hwmon/smsc47m1.o
  CC      drivers/hwmon/via686a.o
  CC      drivers/char/agp/sworks-agp.o
  CC      drivers/hwmon/vt1211.o
  CC      drivers/hwmon/w83627ehf.o
  CC      fs/sysv/super.o
  CC      drivers/infiniband/hw/mlx4/mr.o
  CC      fs/reiserfs/xattr.o
  CC      drivers/infiniband/hw/mlx4/qp.o
  LD      drivers/firmware/built-in.o
  CC      sound/drivers/serial-u16550.o
  CC      drivers/acpi/utilities/utmath.o
  CC      drivers/acpi/utilities/utobject.o
  CC      net/802/fc.o
  CC      sound/drivers/mpu401/mpu401_uart.o
  CC      drivers/input/gameport/gameport.o
  CC      net/802/fddi.o
  CC      drivers/input/serio/serio.o
  CC      drivers/input/serio/i8042.o
  CC      drivers/input/serio/serport.o
  CC      drivers/char/drm/drm_drv.o
  CC      drivers/leds/led-core.o
  CC      net/802/p8023.o
  CC      drivers/infiniband/ulp/srp/ib_srp.o
  CC      drivers/input/touchscreen/ads7846.o
  CC      drivers/input/touchscreen/gunze.o
  CC      drivers/input/touchscreen/elo.o
  CC      drivers/input/touchscreen/mtouch.o
  CC      drivers/char/drm/drm_fops.o
  CC      drivers/infiniband/hw/mlx4/srq.o
  CC      drivers/acpi/utilities/utstate.o
  CC      drivers/input/joystick/adi.o
  CC      fs/sysv/symlink.o
  LD      drivers/lguest/built-in.o
  LD      drivers/macintosh/built-in.o
  LD      fs/proc/proc.o
  LD      drivers/media/common/built-in.o
  LD      fs/proc/built-in.o
  CC      drivers/char/drm/drm_ioctl.o
  CC      drivers/input/misc/uinput.o
  AR      lib/lib.a
  CC      drivers/char/drm/drm_irq.o
  CC      drivers/memstick/core/memstick.o
  CC      drivers/input/joystick/analog.o
  CC      drivers/memstick/host/tifm_ms.o
  LD      drivers/media/dvb/b2c2/built-in.o
  LD      fs/hpfs/hpfs.o
  CC      drivers/input/joystick/grip_mp.o
  LD      drivers/media/dvb/bt8xx/built-in.o
  CC      drivers/input/joystick/guillemot.o
  LD      fs/hpfs/built-in.o
  LD      drivers/media/dvb/cinergyT2/built-in.o
  LD      drivers/media/video/built-in.o
  CC      drivers/input/gameport/lightning.o
  CC      drivers/media/dvb/dvb-core/dvbdev.o
  CC      drivers/acpi/utilities/utmutex.o
  CC      drivers/input/joystick/interact.o
  CC      drivers/input/joystick/magellan.o
  CC      drivers/acpi/utilities/utcache.o
  LD      crypto/built-in.o
  CC      drivers/acpi/utilities/utresrc.o
  CC      drivers/input/joystick/spaceball.o
  CC      drivers/input/joystick/stinger.o
  CC      drivers/input/joystick/twidjoy.o
  CC      drivers/input/joystick/xpad.o
  CC      drivers/input/gameport/ns558.o
  LD      drivers/media/dvb/dvb-usb/built-in.o
  LD      drivers/media/dvb/frontends/built-in.o
  LD      drivers/media/dvb/pluto2/built-in.o
  CC      drivers/infiniband/hw/cxgb3/iwch_mem.o
  LD      drivers/media/dvb/ttpci/built-in.o
  LD      drivers/media/dvb/ttusb-budget/built-in.o
  LD      drivers/media/dvb/ttusb-dec/built-in.o
  CC      drivers/infiniband/hw/cxgb3/iwch_provider.o
  CC      drivers/input/serio/ct82c710.o
  CC      drivers/infiniband/hw/cxgb3/iwch.o
  CC      drivers/input/serio/libps2.o
  CC      drivers/input/touchscreen/usbtouchscreen.o
  CC      drivers/infiniband/hw/cxgb3/cxio_hal.o
  CC      drivers/input/touchscreen/ucb1400_ts.o
  CC      drivers/char/drm/drm_lock.o
  CC      drivers/char/drm/drm_memory.o
  CC      fs/reiserfs/xattr_user.o
  CC      drivers/input/joystick/iforce/iforce-ff.o
  CC      drivers/input/joystick/iforce/iforce-main.o
  CC      drivers/char/drm/drm_proc.o
  CC      drivers/infiniband/hw/cxgb3/cxio_resource.o
  CC      fs/reiserfs/xattr_trusted.o
  CC      fs/reiserfs/xattr_acl.o
  CC      drivers/input/joystick/iforce/iforce-packets.o
  CC      drivers/input/joystick/iforce/iforce-serio.o
  CC      drivers/input/mouse/lifebook.o
  CC      drivers/input/mouse/vsxxxaa.o
  CC      drivers/char/drm/drm_stub.o
  LD      fs/dlm/dlm.o
  CC      drivers/char/drm/drm_vm.o
  LD      fs/dlm/built-in.o
  CC      drivers/char/drm/drm_agpsupport.o
  LD      fs/minix/minix.o
  LD      fs/minix/built-in.o
  CC      drivers/char/drm/drm_scatter.o
  CC      drivers/leds/led-class.o
  CC      drivers/leds/led-triggers.o
  CC      drivers/leds/leds-wrap.o
  CC      drivers/char/drm/ati_pcigart.o
  CC      drivers/media/dvb/dvb-core/dmxdev.o
  LD      net/9p/9pnet.o
  LD      net/9p/9pnet_virtio.o
  CC      drivers/leds/ledtrig-timer.o
  CC      drivers/message/i2o/config-osm.o
  LD      net/9p/built-in.o
  CC      drivers/mfd/sm501.o
  CC      net/appletalk/aarp.o
  CC      drivers/misc/msi-laptop.o
  CC      net/appletalk/ddp.o
  CC      drivers/leds/ledtrig-heartbeat.o
  CC      drivers/misc/tifm_core.o
  CC      net/appletalk/dev.o
  CC      net/appletalk/atalk_proc.o
  CC      net/atm/addr.o
  LD      net/8021q/8021q.o
  LD      net/8021q/built-in.o
  CC      net/bluetooth/af_bluetooth.o
  CC      drivers/net/atl1/atl1_main.o
  CC      drivers/net/atl1/atl1_hw.o
  CC      drivers/net/atl1/atl1_ethtool.o
  CC      drivers/net/atl1/atl1_param.o
  CC      drivers/message/i2o/iop.o
  CC      drivers/message/i2o/driver.o
  CC      drivers/char/drm/drm_pci.o
security/selinux/hooks.c: In function 'task_has_capability':
security/selinux/hooks.c:1285: warning: 'sclass' may be used uninitialized in this function
  CC      drivers/net/cxgb3/cxgb3_main.o
  CC      sound/i2c/other/ak4xxx-adda.o
  CC      drivers/net/cxgb3/ael1002.o
  LD      security/selinux/selinux.o
  CC      fs/gfs2/locking/dlm/main.o
  CC      drivers/net/cxgb3/vsc8211.o
  CC      fs/gfs2/locking/dlm/mount.o
  CC      drivers/net/cxgb3/t3_hw.o
  CC      drivers/message/i2o/device.o
  CC      drivers/net/cxgb3/mc5.o
  CC      drivers/net/cxgb3/xgmac.o
  CC      sound/drivers/opl3/opl3_lib.o
  CC      sound/drivers/opl3/opl3_synth.o
  CC      sound/i2c/cs8427.o
  CC      fs/gfs2/locking/dlm/sysfs.o
  CC      fs/gfs2/locking/dlm/thread.o
  LD      sound/isa/ad1816a/built-in.o
  CC      fs/gfs2/locking/dlm/plock.o
  LD      sound/isa/ad1848/built-in.o
  LD      drivers/ieee1394/ieee1394.o
  LD      sound/isa/cs423x/built-in.o
  LD      drivers/ieee1394/built-in.o
  LD      sound/isa/es1688/built-in.o
  CC      drivers/pci/access.o
  CC      drivers/pnp/core.o
  LD      sound/isa/gus/built-in.o
  CC      sound/isa/sb/sb_common.o
  CC      drivers/pnp/card.o
  LD      sound/isa/opti9xx/built-in.o
  CC      net/atm/pvc.o
  LD      sound/isa/wavefront/built-in.o
  CC      drivers/char/drm/drm_sysfs.o
  CC      drivers/pnp/driver.o
  CC      drivers/pnp/resource.o
  CC      drivers/pnp/manager.o
  CC      drivers/pnp/support.o
  CC      net/atm/signaling.o
  LD      drivers/crypto/built-in.o
  CC      drivers/pnp/interface.o
  CC      drivers/pnp/quirks.o
  CC      sound/isa/sb/sb_mixer.o
  CC      drivers/power/power_supply_core.o
  CC      drivers/power/power_supply_sysfs.o
  CC      net/appletalk/sysctl_net_atalk.o
  CC      drivers/scsi/scsi.o
  CC      drivers/net/e1000/e1000_main.o
  CC      drivers/net/e1000/e1000_hw.o
  CC      net/atm/svc.o
  CC      drivers/net/e1000/e1000_ethtool.o
  CC      drivers/char/drm/drm_hashtab.o
  CC      drivers/char/drm/drm_sman.o
  CC      drivers/char/drm/drm_mm.o
  CC      drivers/char/drm/i830_drv.o
drivers/infiniband/hw/cxgb3/iwch_qp.c: In function 'iwch_post_send':
drivers/infiniband/hw/cxgb3/iwch_qp.c:232: warning: 't3_wr_flit_cnt' may be used uninitialized in this function
  CC      drivers/char/drm/i830_dma.o
  CC      net/atm/ioctl.o
  CC      net/atm/common.o
  CC      net/atm/atm_misc.o
  CC      drivers/char/drm/i830_irq.o
  CC      drivers/char/drm/mga_drv.o
  CC      net/atm/raw.o
  LD      drivers/hwmon/built-in.o
  CC      drivers/pnp/system.o
  CC      net/atm/resources.o
  CC      net/atm/atm_sysfs.o
  LD      fs/jfs/jfs.o
  CC      drivers/pnp/pnpacpi/core.o
  CC      drivers/serial/serial_core.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  LD      fs/jfs/built-in.o
  CC      net/core/sock.o
  CC      drivers/char/drm/mga_dma.o
  CC      drivers/char/drm/mga_state.o
  CC      drivers/char/drm/mga_warp.o
  LD      drivers/input/mouse/psmouse.o
  LD      sound/drivers/mpu401/snd-mpu401-uart.o
  LD      drivers/input/mouse/built-in.o
  CC      drivers/char/drm/mga_irq.o
  LD      sound/drivers/mpu401/built-in.o
  LD      sound/drivers/opl4/built-in.o
  LD      drivers/input/serio/built-in.o
  CC      sound/drivers/vx/vx_core.o
  LD      sound/drivers/snd-serial-u16550.o
  CC      drivers/message/i2o/debug.o
  CC      drivers/spi/spi.o
  LD      drivers/memstick/host/built-in.o
  CC      drivers/spi/spi_bitbang.o
  LD      drivers/mfd/built-in.o
  CC      drivers/spi/at25.o
  CC      drivers/ssb/main.o
  CC      drivers/ssb/scan.o
  CC      drivers/char/drm/r128_drv.o
  CC      drivers/pci/bus.o
  CC      net/atm/proc.o
  CC      drivers/power/power_supply_leds.o
  CC      drivers/pci/probe.o
  CC      net/atm/clip.o
  LD      drivers/acpi/utilities/built-in.o
  LD      drivers/acpi/built-in.o
  CC      drivers/telephony/phonedev.o
  CC      drivers/thermal/thermal.o
  CC      drivers/ssb/pci.o
  CC      sound/isa/sb/sb16_main.o
  CC      net/bluetooth/hci_core.o
  CC      drivers/ssb/pcihost_wrapper.o
  CC      drivers/char/drm/r128_cce.o
  CC      drivers/ssb/driver_chipcommon.o
  LD      sound/drivers/opl3/snd-opl3-lib.o
  CC      drivers/ssb/b43_pci_bridge.o
  LD      sound/drivers/opl3/built-in.o
  CC      drivers/char/drm/r128_state.o
  CC      drivers/char/drm/r128_irq.o
  CC      drivers/uio/uio.o
  CC      drivers/usb/atm/cxacru.o
  CC      drivers/net/cxgb3/sge.o
  CC      drivers/video/fb_notify.o
  LD      drivers/input/gameport/built-in.o
  CC      drivers/char/drm/radeon_drv.o
  CC      drivers/char/drm/radeon_cp.o
  LD      drivers/memstick/core/built-in.o
  CC      drivers/virtio/virtio.o
  CC      drivers/media/dvb/dvb-core/dvb_demux.o
  CC      drivers/usb/class/cdc-acm.o
  CC      drivers/char/drm/radeon_state.o
  LD      drivers/leds/built-in.o
  LD      drivers/memstick/built-in.o
  CC      drivers/w1/w1.o
  CC      drivers/watchdog/wdt_pci.o
  CC      drivers/message/i2o/pci.o
  CC      drivers/watchdog/pcwd_usb.o
  CC      drivers/char/drm/radeon_mem.o
  LD      drivers/infiniband/ulp/srp/built-in.o
  CC      drivers/char/drm/radeon_irq.o
  CC      drivers/message/i2o/exec-osm.o
  CC      drivers/watchdog/acquirewdt.o
  CC      drivers/watchdog/advantechwdt.o
  CC      drivers/char/drm/r300_cmdbuf.o
  CC      drivers/char/drm/sis_drv.o
  CC      sound/i2c/i2c.o
  LD      drivers/input/joystick/iforce/iforce.o
  CC      drivers/message/i2o/i2o_block.o
  CC      net/core/request_sock.o
  CC      drivers/char/drm/sis_mm.o
  LD      drivers/input/joystick/iforce/built-in.o
  CC      sound/drivers/vx/vx_hwdep.o
  CC      drivers/char/drm/tdfx_drv.o
  LD      drivers/input/joystick/built-in.o
  LD      drivers/input/misc/built-in.o
  CC      drivers/char/drm/via_irq.o
  CC      sound/drivers/vx/vx_pcm.o
  CC      net/dccp/ccid.o
  CC      drivers/telephony/ixj.o
  CC      net/dccp/feat.o
  CC      sound/drivers/vx/vx_mixer.o
  CC      drivers/pci/remove.o
  CC      net/ethernet/eth.o
  CC      drivers/char/drm/via_drv.o
  CC      drivers/video/backlight/backlight.o
  CC      net/ipv4/route.o
  CC      net/ieee80211/ieee80211_module.o
  CC      net/ipv4/inetpeer.o
  CC      net/ipv4/protocol.o
  CC      net/ipv6/af_inet6.o
  CC      net/ipv6/anycast.o
  CC      drivers/char/drm/via_map.o
  CC      drivers/misc/tifm_7xx1.o
  CC      drivers/misc/phantom.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/scsi/hosts.o
  CC      drivers/misc/thinkpad_acpi.o
  LD      sound/core/oss/snd-pcm-oss.o
  CC      net/ipx/af_ipx.o
  LD      sound/core/oss/built-in.o
  CC      drivers/char/drm/via_mm.o
  LD      sound/core/built-in.o
  CC      drivers/char/drm/via_dma.o
  LD      sound/mips/built-in.o
  LD      sound/oss/built-in.o
  CC      drivers/net/cxgb3/l2t.o
  LD      net/802/built-in.o
  LD      sound/parisc/built-in.o
  CC      sound/pci/ad1889.o
  LD      sound/pcmcia/pdaudiocf/built-in.o
  CC      net/key/af_key.o
  CC      net/llc/llc_core.o
  CC      drivers/watchdog/alim7101_wdt.o
  LD      sound/pcmcia/vx/built-in.o
  LD      sound/ppc/built-in.o
  LD      drivers/spi/built-in.o
  LD      sound/pcmcia/built-in.o
  CC      drivers/net/cxgb3/cxgb3_offload.o
  LD      sound/sh/built-in.o
  LD      sound/soc/built-in.o
  LD      sound/sparc/built-in.o
  LD      sound/spi/built-in.o
  CC      drivers/char/drm/via_verifier.o
  CC      drivers/char/drm/via_video.o
  CC      drivers/watchdog/sc520_wdt.o
  CC      sound/synth/util_mem.o
  LD      sound/usb/caiaq/built-in.o
  LD      sound/usb/usx2y/built-in.o
  LD      sound/usb/built-in.o
  CC      sound/ac97_bus.o
  CC      sound/last.o
  LD      fs/sysv/sysv.o
  CC      drivers/char/drm/via_dmablit.o
  LD      fs/sysv/built-in.o
  CC      net/ipx/ipx_route.o
  CC      drivers/infiniband/hw/mthca/mthca_cmd.o
  LD      drivers/pnp/pnpacpi/built-in.o
  CC      drivers/infiniband/hw/mthca/mthca_profile.o
  CC      drivers/infiniband/hw/mthca/mthca_reset.o
  CC      drivers/infiniband/hw/mthca/mthca_allocator.o
  CC      drivers/infiniband/hw/mthca/mthca_eq.o
  CC      drivers/infiniband/hw/mthca/mthca_pd.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/infiniband/hw/mthca/mthca_cq.o
  CC      drivers/infiniband/hw/mthca/mthca_mr.o
  LD      sound/i2c/snd-cs8427.o
  LD      sound/i2c/snd-i2c.o
  LD      sound/i2c/other/snd-ak4xxx-adda.o
  CC      drivers/media/dvb/dvb-core/dvb_filter.o
  CC      drivers/scsi/scsi_ioctl.o
  CC      drivers/watchdog/ibmasr.o
  LD      drivers/input/input-core.o
  CC      drivers/scsi/constants.o
  CC      drivers/net/e1000/e1000_param.o
  LD      sound/soundcore.o
  CC      drivers/misc/fujitsu-laptop.o
  LD      sound/i2c/other/built-in.o
  CC      drivers/misc/enclosure.o
  LD      sound/i2c/built-in.o
  CC      sound/drivers/vx/vx_cmd.o
  CC      sound/drivers/vx/vx_uer.o
  CC      drivers/scsi/scsicam.o
  CC      net/ipx/ipx_proc.o
  LD      drivers/pnp/built-in.o
  CC      net/ipx/sysctl_net_ipx.o
  CC      drivers/usb/atm/usbatm.o
  CC      drivers/scsi/scsi_error.o
  CC      drivers/virtio/virtio_ring.o
  CC      drivers/virtio/virtio_pci.o
  LD      drivers/ssb/ssb.o
  LD      sound/isa/sb/snd-sb-common.o
  CC      drivers/scsi/scsi_lib.o
  LD      drivers/ssb/built-in.o
  LD      sound/isa/sb/snd-sb16-dsp.o
  CC      drivers/scsi/scsi_lib_dma.o
  LD      sound/isa/sb/built-in.o
  LD      sound/synth/snd-util-mem.o
  LD      sound/synth/built-in.o
  LD      sound/isa/built-in.o
  CC      drivers/scsi/scsi_scan.o
  CC      net/ipv4/ip_input.o
  CC      drivers/w1/w1_int.o
  CC      drivers/w1/w1_family.o
  CC      net/llc/llc_input.o
  LD      fs/gfs2/locking/dlm/lock_dlm.o
  LD      fs/gfs2/locking/dlm/built-in.o
  LD      drivers/uio/built-in.o
  CC      net/llc/llc_output.o
  CC      drivers/pci/pci.o
  CC      drivers/w1/w1_netlink.o
  CC      net/netfilter/core.o
drivers/watchdog/alim7101_wdt.c:412: warning: 'alim7101_pci_tbl' defined but not used
  CC      drivers/watchdog/i6300esb.o
  CC      net/netlabel/netlabel_user.o
  CC      drivers/pci/quirks.o
  CC      drivers/watchdog/iTCO_wdt.o
  LD      fs/gfs2/gfs2.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/watchdog/iTCO_vendor_support.o
  LD      drivers/char/agp/agpgart.o
  LD      fs/gfs2/built-in.o
  LD      drivers/char/agp/built-in.o
  CC      drivers/watchdog/it8712f_wdt.o
  CC      drivers/pci/search.o
  CC      net/netlabel/netlabel_kapi.o
  CC      net/ipv4/ip_fragment.o
  CC      net/netlink/af_netlink.o
  CC      net/packet/af_packet.o
  CC      net/netlink/attr.o
  CC      net/netlink/genetlink.o
  CC      net/ipv4/ip_forward.o
  CC      drivers/infiniband/hw/mthca/mthca_qp.o
  CC      drivers/media/dvb/dvb-core/dvb_ca_en50221.o
  CC      drivers/w1/w1_io.o
  LD      security/selinux/ss/ss.o
  LD      drivers/input/keyboard/built-in.o
  LD      drivers/w1/masters/built-in.o
  LD      security/selinux/ss/built-in.o
  LD      security/selinux/built-in.o
  CC      net/ieee80211/ieee80211_tx.o
  LD      security/built-in.o
  CC      drivers/w1/slaves/w1_smem.o
  CC      drivers/watchdog/sc1200wdt.o
  CC      drivers/media/dvb/dvb-core/dvb_frontend.o
  CC      drivers/media/dvb/dvb-core/dvb_net.o
  CC      net/ipv4/ip_options.o
  CC      net/ipv4/ip_output.o
  CC      net/ipv4/ip_sockglue.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      net/ipv4/inet_hashtables.o
  CC      drivers/watchdog/scx200_wdt.o
  CC      drivers/media/dvb/dvb-core/dvb_ringbuffer.o
  CC      drivers/watchdog/pc87413_wdt.o
  CC      net/ieee80211/ieee80211_rx.o
  CC      drivers/infiniband/hw/mthca/mthca_av.o
  CC      net/netfilter/nf_log.o
  CC      drivers/infiniband/hw/mthca/mthca_mcg.o
  CC      net/netfilter/nf_queue.o
  LD      drivers/video/backlight/built-in.o
  CC      drivers/video/console/dummycon.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/video/console/vgacon.o
  CC      drivers/scsi/scsi_sysfs.o
  LD      drivers/input/touchscreen/built-in.o
  LD      drivers/input/built-in.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      drivers/infiniband/hw/mthca/mthca_mad.o
  LD      fs/ntfs/ntfs.o
  LD      net/appletalk/appletalk.o
  LD      drivers/video/display/built-in.o
  LD      fs/ntfs/built-in.o
  LD      net/appletalk/built-in.o
  CC      drivers/watchdog/smsc37b787_wdt.o
  CC      net/rxrpc/af_rxrpc.o
  CC      net/rxrpc/ar-accept.o
  CC      net/netfilter/nf_sockopt.o
  CC      drivers/watchdog/w83627hf_wdt.o
  CC      net/ieee80211/ieee80211_wx.o
  LD      drivers/message/i2o/i2o_core.o
  LD      drivers/message/i2o/i2o_config.o
  LD      drivers/message/i2o/built-in.o
  LD      drivers/message/built-in.o
  CC      drivers/watchdog/w83877f_wdt.o
  CC      drivers/watchdog/machzwd.o
  CC      net/core/skbuff.o
  LD      drivers/power/power_supply.o
  CC      net/core/iovec.o
  LD      drivers/power/built-in.o
  CC      net/ieee80211/ieee80211_geo.o
  CC      drivers/scsi/scsi_netlink.o
  CC      drivers/media/dvb/dvb-core/dvb_math.o
  CC      net/ieee80211/ieee80211_crypt.o
  LD      drivers/virtio/built-in.o
  CC      drivers/infiniband/hw/mthca/mthca_provider.o
  CC      net/core/datagram.o
  CC      drivers/watchdog/sbc_epx_c3.o
  CC      net/core/stream.o
  LD      drivers/w1/wire.o
  CC      net/ipv4/inet_timewait_sock.o
  CC      net/core/scm.o
  CC      drivers/pci/pci-sysfs.o
  CC      drivers/infiniband/hw/mthca/mthca_memfree.o
drivers/pci/search.c: In function 'pci_find_slot':
drivers/pci/search.c:135: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)
  CC      drivers/pci/rom.o
  CC      net/bluetooth/hci_conn.o
  CC      net/netfilter/nfnetlink.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/infiniband/hw/mthca/mthca_uar.o
  CC      drivers/pci/setup-res.o
  CC      net/dccp/input.o
  CC      net/dccp/minisocks.o
  CC      net/dccp/options.o
  CC      drivers/scsi/scsi_sysctl.o
  CC      net/dccp/output.o
  CC      net/dccp/proto.o
  CC      drivers/infiniband/hw/mthca/mthca_srq.o
  CC      drivers/infiniband/hw/mthca/mthca_catas.o
  CC      net/llc/llc_if.o
  CC      net/ipv6/ip6_output.o
  LD      sound/drivers/vx/snd-vx-lib.o
  CC      net/ipv6/ip6_input.o
  LD      sound/drivers/vx/built-in.o
  LD      sound/drivers/built-in.o
  LD      drivers/w1/slaves/built-in.o
  CC      net/ipv6/addrconf.o
  LD      drivers/w1/built-in.o
  CC      net/ipv6/addrlabel.o
  CC      drivers/scsi/sd.o
  CC      drivers/scsi/scsi_transport_spi.o
  CC      drivers/pci/proc.o
  CC      net/ipv4/inet_connection_sock.o
  CC      drivers/scsi/scsi_transport_fc.o
  CC      net/llc/llc_c_ev.o
  CC      drivers/scsi/scsi_transport_sas.o
  CC      drivers/scsi/aacraid/linit.o
  CC      drivers/scsi/aacraid/aachba.o
  CC      drivers/scsi/aacraid/commctrl.o
  CC      net/ipv4/tcp.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_seq.h
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg.h
  CC      drivers/scsi/aic7xxx/aic7xxx_core.o
  CC      drivers/serial/8250.o
  CC      drivers/serial/8250_pci.o
  CC      drivers/serial/8250_early.o
  CC      drivers/pci/hotplug/acpiphp_core.o
  CC      drivers/pci/hotplug/acpiphp_glue.o
  CC      drivers/pci/hotplug/pci_hotplug_core.o
  CC      net/netfilter/nfnetlink_log.o
  CC      net/netfilter/x_tables.o
  CC      drivers/pci/hotplug/acpi_pcihp.o
  CC      net/ipv4/tcp_input.o
  CC      drivers/usb/atm/xusbatm.o
  CC      net/netfilter/xt_tcpudp.o
  CC      drivers/pci/pcie/portdrv_core.o
  CC      drivers/pci/pcie/portdrv_pci.o
  CC      drivers/pci/pcie/portdrv_bus.o
  LD      fs/reiserfs/reiserfs.o
  LD      fs/reiserfs/built-in.o
  CC      drivers/scsi/aic94xx/aic94xx_init.o
  LD      fs/built-in.o
  CC      drivers/scsi/aic94xx/aic94xx_hwi.o
  CC      net/llc/llc_c_ac.o
  CC      drivers/pci/pcie/aer/aerdrv_errprint.o
  CC      drivers/pci/pcie/aer/aerdrv_core.o
  CC      net/ethernet/pe2.o
  CC      net/core/gen_stats.o
  CC      net/ipv4/tcp_output.o
  CC      net/ipv4/tcp_timer.o
  CC      net/ipv4/tcp_ipv4.o
  CC      net/ipv4/tcp_minisocks.o
  CC      net/netlabel/netlabel_domainhash.o
  CC      net/netlabel/netlabel_mgmt.o
  CC      net/bluetooth/hci_event.o
  CC      net/bluetooth/hci_sock.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/pci/hotplug.o
  CC      drivers/pci/hotplug-pci.o
  CC      net/core/gen_estimator.o
  CC      net/core/net_namespace.o
  CC      net/core/sysctl_net_core.o
  CC      net/core/dev.o
  CC      net/core/ethtool.o
  CC      drivers/pci/setup-bus.o
  CC      drivers/pci/pci-acpi.o
  CC      sound/pci/als4000.o
  CC      net/ipv4/tcp_cong.o
  CC      net/ipv4/datagram.o
  CC      net/ipv4/raw.o
  CC      net/ipv4/udp.o
  CC      drivers/usb/class/usblp.o
  CC      net/ipv6/route.o
  CC      net/ipv6/ip6_fib.o
  CC      net/ipv4/udplite.o
  CC      net/ipv4/arp.o
  CC      net/dccp/timer.o
  LD      drivers/firewire/firewire-core.o
  CC      net/netfilter/xt_MARK.o
  LD      drivers/firewire/firewire-ohci.o
  CC      net/core/dev_mcast.o
  LD      drivers/firewire/firewire-sbp2.o
  LD      drivers/firewire/built-in.o
  CC      net/core/dst.o
  CC      net/core/netevent.o
  CC      drivers/pci/pcie/aer/aerdrv.o
  CC      net/dccp/ackvec.o
  CC      net/dccp/sysctl.o
  CC      net/ipv6/ipv6_sockglue.o
  CC      net/dccp/diag.o
  CC      net/netfilter/xt_SECMARK.o
  CC      drivers/scsi/aic94xx/aic94xx_reg.o
  CC      net/bluetooth/hci_sysfs.o
  CC      drivers/scsi/libsas/sas_init.o
  CC      net/netfilter/xt_mark.o
  CC      drivers/scsi/libsas/sas_phy.o
  LD      drivers/thermal/built-in.o
  LD      net/ipx/ipx.o
  CC      net/bluetooth/lib.o
  LD      net/ipx/built-in.o
  CC      net/ipv4/icmp.o
  LD      drivers/media/dvb/dvb-core/dvb-core.o
  CC      net/sched/sch_generic.o
  LD      drivers/media/dvb/dvb-core/built-in.o
  LD      drivers/media/dvb/built-in.o
  LD      drivers/media/built-in.o
  CC      net/sctp/sm_statetable.o
  CC      net/dccp/ipv4.o
  LD      drivers/block/built-in.o
  CC      net/dccp/ipv6.o
  CC      net/sctp/sm_statefuns.o
  LD      net/netfilter/netfilter.o
  CC      net/tipc/addr.o
  LD      drivers/infiniband/core/ib_core.o
  LD      drivers/infiniband/core/ib_mad.o
  LD      drivers/infiniband/core/ib_sa.o
  LD      drivers/infiniband/core/ib_cm.o
  LD      drivers/infiniband/core/iw_cm.o
  CC      net/ipv4/devinet.o
  LD      drivers/infiniband/core/ib_addr.o
  LD      drivers/infiniband/core/rdma_cm.o
  LD      drivers/infiniband/core/ib_umad.o
  LD      drivers/infiniband/core/built-in.o
  CC      net/ipv4/af_inet.o
  CC      net/core/neighbour.o
  CC      drivers/pci/pcie/aer/aerdrv_acpi.o
  CC      net/ipv4/igmp.o
  CC      net/ipv4/fib_frontend.o
  CC      net/ipv4/fib_semantics.o
  CC      drivers/serial/kgdboc.o
  CC      net/llc/llc_conn.o
  CC      net/tipc/bcast.o
  CC      net/core/rtnetlink.o
  CC      drivers/scsi/aacraid/comminit.o
  CC      net/dccp/ccids/ccid2.o
  CC      drivers/scsi/aacraid/commsup.o
  LD      net/atm/atm.o
  LD      net/ethernet/built-in.o
  CC      drivers/scsi/aacraid/dpcsup.o
  LD      net/atm/built-in.o
  CC      net/unix/af_unix.o
  LD      net/dccp/ccids/lib/built-in.o
  CC      net/rxrpc/ar-ack.o
  CC      net/bluetooth/sco.o
  CC      net/wireless/wext.o
  CC      net/ipv4/inet_fragment.o
  CC      drivers/scsi/aacraid/rx.o
  CC      net/xfrm/xfrm_policy.o
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      net/ipv4/fib_hash.o
  CC      drivers/scsi/aacraid/sa.o
  LD      net/packet/built-in.o
  CC      net/ipv4/proc.o
  CC      net/sysctl_net.o
  CC      net/unix/garbage.o
  LD      drivers/pci/pcie/pcieportdrv.o
  CC      drivers/scsi/aic94xx/aic94xx_sds.o
  CC      net/unix/sysctl_net_unix.o
  CC      net/core/utils.o
  CC      net/ipv4/ipmr.o
  CC      net/tipc/bearer.o
  CC      net/tipc/config.o
  CC      net/core/link_watch.o
  CC      drivers/scsi/aacraid/rkt.o
  CC      net/llc/llc_c_st.o
  CC      net/llc/llc_pdu.o
  CC      drivers/scsi/lpfc/lpfc_mem.o
  CC      drivers/scsi/libsas/sas_port.o
  CC      net/llc/llc_sap.o
  CC      drivers/scsi/libsas/sas_event.o
  LD      drivers/ata/libata.o
  CC      drivers/scsi/libsas/sas_dump.o
  LD      drivers/ata/built-in.o
  CC      net/llc/llc_s_ac.o
  CC      drivers/scsi/libsas/sas_discover.o
  CC      net/llc/llc_s_ev.o
  CC      drivers/scsi/libsas/sas_expander.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      net/ipv6/ndisc.o
  LD      drivers/net/cxgb3/cxgb3.o
  LD      drivers/net/cxgb3/built-in.o
  CC      net/ipv6/udp.o
  CC      drivers/net/e1000e/82571.o
  CC      drivers/net/e1000e/ich8lan.o
  LD      drivers/infiniband/hw/cxgb3/iw_cxgb3.o
  LD      drivers/infiniband/hw/cxgb3/built-in.o
  CC      drivers/net/e1000e/es2lan.o
  CC      net/ipv4/ipip.o
  CC      drivers/scsi/aacraid/nark.o
  CC      net/rxrpc/ar-call.o
  CC      net/rxrpc/ar-connection.o
  CC      net/core/filter.o
  CC      net/ipv4/ip_gre.o
  CC      net/ipv4/inet_lro.o
net/bluetooth/hci_sysfs.c: In function 'del_conn':
net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value
  CC      net/ipv4/tunnel4.o
  CC      net/rxrpc/ar-connevent.o
  CC      net/ipv6/udplite.o
  LD      net/bluetooth/bluetooth.o
  CC      net/ipv6/raw.o
  LD      drivers/watchdog/built-in.o
  LD      drivers/usb/class/built-in.o
  CC      drivers/usb/core/usb.o
  CC      drivers/scsi/aic94xx/aic94xx_seq.o
  CC      net/netlabel/netlabel_unlabeled.o
  CC      net/core/flow.o
  CC      net/core/net-sysfs.o
  CC      net/core/netpoll.o
  CC      net/core/fib_rules.o
  CC      net/netlabel/netlabel_cipso_v4.o
  LD      drivers/pci/pcie/aer/aerdriver.o
  CC      drivers/net/ixgbe/ixgbe_main.o
  LD      drivers/pci/pcie/aer/built-in.o
  CC      drivers/net/ixgbe/ixgbe_common.o
  CC      drivers/net/ixgbe/ixgbe_ethtool.o
  LD      drivers/pci/pcie/built-in.o
  CC      drivers/scsi/aic94xx/aic94xx_dump.o
  CC      drivers/net/ixgbe/ixgbe_82598.o
  CC      drivers/net/mlx4/alloc.o
  LD      drivers/pci/hotplug/pci_hotplug.o
  LD      drivers/pci/hotplug/acpiphp.o
  CC      net/rxrpc/ar-error.o
  LD      drivers/pci/hotplug/built-in.o
  LD      drivers/pci/built-in.o
  CC      net/rxrpc/ar-input.o
  CC      net/rxrpc/ar-key.o
  CC      net/llc/llc_s_st.o
  LD      drivers/usb/atm/built-in.o
  CC      net/ipv6/protocol.o
  CC      drivers/usb/host/pci-quirks.o
  CC      net/llc/af_llc.o
  CC      drivers/usb/host/ehci-hcd.o
  CC      drivers/usb/image/mdc800.o
  CC      drivers/scsi/libsas/sas_scsi_host.o
  CC      net/ipv4/xfrm4_mode_tunnel.o
  CC      net/ipv4/netfilter.o
  CC      net/llc/llc_station.o
  CC      drivers/scsi/libsas/sas_task.o
  CC      drivers/scsi/lpfc/lpfc_sli.o
  CC      drivers/scsi/libsas/sas_ata.o
  CC      drivers/scsi/libsas/sas_host_smp.o
  CC      net/llc/llc_proc.o
  CC      drivers/scsi/sym53c8xx_2/sym_fw.o
  LD      net/ipv4/netfilter/built-in.o
  CC      net/ipv4/inet_diag.o
  CC      net/ipv4/tcp_diag.o
  CC      drivers/scsi/sym53c8xx_2/sym_glue.o
  CC      net/ipv4/tcp_cubic.o
  CC      drivers/scsi/scsi_transport_srp.o
  CC      drivers/scsi/BusLogic.o
  CC      net/ipv4/tcp_westwood.o
  CC      net/llc/sysctl_net_llc.o
  CC      net/sctp/sm_sideeffect.o
  CC      net/ipv4/tcp_htcp.o
  CC      drivers/scsi/dpt_i2o.o
  CC      net/ipv4/tcp_vegas.o
  CC      sound/pci/atiixp.o
  CC      drivers/scsi/ips.o
  CC      net/ipv6/icmp.o
  LD      drivers/serial/built-in.o
  CC      net/tipc/cluster.o
  CC      drivers/net/mlx4/catas.o
  CC      sound/pci/cs5530.o
  CC      sound/pci/es1938.o
  CC      sound/pci/es1968.o
  CC      sound/pci/fm801.o
  CC      net/sctp/protocol.o
  LD      net/sched/built-in.o
  CC      net/sctp/endpointola.o
  CC      net/ipv4/cipso_ipv4.o
  LD      net/wireless/built-in.o
  CC      net/ipv4/xfrm4_policy.o
  CC      net/ipv4/xfrm4_state.o
  CC      net/ipv4/xfrm4_input.o
  CC      net/tipc/core.o
  CC      net/ipv4/xfrm4_output.o
  CC      drivers/usb/host/isp116x-hcd.o
  CC      net/rxrpc/ar-local.o
  CC      drivers/usb/core/hub.o
  CC      net/ipv6/mcast.o
  CC      net/tipc/handler.o
  CC      net/tipc/link.o
  CC      drivers/scsi/qla1280.o
  CC      drivers/scsi/eata.o
  CC      net/tipc/discover.o
net/sctp/sm_statefuns.c: In function 'sctp_sf_do_prm_asoc':
net/sctp/sm_statefuns.c:4375: warning: passing argument 1 of 'SCTP_ASOC' discards qualifiers from pointer target type
  CC      net/tipc/msg.o
  CC      net/sctp/associola.o
  CC      net/sctp/transport.o
  CC      net/rxrpc/ar-output.o
  LD      drivers/video/console/built-in.o
  CC      drivers/scsi/aic94xx/aic94xx_scb.o
  LD      drivers/video/built-in.o
  CC      drivers/net/mlx4/cmd.o
  CC      drivers/net/mlx4/cq.o
  CC      drivers/net/mlx4/eq.o
  CC      drivers/net/mlx4/fw.o
  CC      drivers/scsi/sym53c8xx_2/sym_hipd.o
  CC      drivers/scsi/sym53c8xx_2/sym_malloc.o
  CC      drivers/scsi/sym53c8xx_2/sym_nvram.o
  CC      drivers/scsi/aic94xx/aic94xx_dev.o
  CC      drivers/scsi/aic94xx/aic94xx_tmf.o
  CC      drivers/scsi/aic94xx/aic94xx_task.o
  CC      drivers/net/mlx4/icm.o
  CC      drivers/net/mlx4/intf.o
  CC      sound/pci/intel8x0m.o
  CC      net/ipv6/reassembly.o
  CC      net/ipv6/tcp_ipv6.o
  CC      drivers/net/e1000e/lib.o
  CC      net/ipv6/exthdrs.o
  CC      drivers/net/mlx4/main.o
  CC      net/ipv6/datagram.o
  CC      net/tipc/name_distr.o
  LD      net/key/built-in.o
  CC      drivers/scsi/dc395x.o
  CC      drivers/net/e1000e/phy.o
  LD      drivers/usb/image/built-in.o
  CC      net/sctp/chunk.o
  CC      net/tipc/subscr.o
  CC      drivers/usb/misc/appledisplay.o
  CC      net/tipc/name_table.o
  CC      net/ipv6/ip6_flowlabel.o
  LD      net/ieee80211/ieee80211.o
  LD      net/ieee80211/built-in.o
  LD      net/dccp/dccp.o
  CC      net/tipc/net.o
  LD      net/dccp/dccp_ipv4.o
  LD      net/dccp/dccp_ipv6.o
  CC      net/tipc/netlink.o
  CC      net/rxrpc/ar-peer.o
  LD      net/dccp/dccp_diag.o
  CC      net/rxrpc/ar-recvmsg.o
  CC      net/sctp/sm_make_chunk.o
  CC      drivers/usb/serial/usb-serial.o
  CC      drivers/net/ixgbe/ixgbe_phy.o
  CC      drivers/net/e1000e/param.o
  CC      drivers/net/e1000e/ethtool.o
  CC      drivers/net/e1000e/netdev.o
  CC      net/rxrpc/ar-security.o
  CC      drivers/scsi/tmscsim.o
  CC      drivers/scsi/atp870u.o
  CC      net/tipc/node.o
  CC      net/tipc/node_subscr.o
  LD      net/dccp/ccids/dccp_ccid2.o
  LD      net/dccp/ccids/built-in.o
  LD      net/dccp/built-in.o
  CC      net/tipc/port.o
  CC      net/tipc/ref.o
  CC      drivers/net/mlx4/mcg.o
  LD      net/bluetooth/built-in.o
  CC      drivers/net/mlx4/mr.o
  CC      net/rxrpc/ar-skbuff.o
  CC      net/rxrpc/ar-transport.o
  CC      net/rxrpc/ar-proc.o
  CC      net/sctp/ulpevent.o
  CC      drivers/scsi/3w-xxxx.o
  CC      net/rxrpc/rxkad.o
  CC      drivers/net/mlx4/pd.o
  CC      net/sctp/inqueue.o
  CC      drivers/usb/serial/generic.o
  CC      drivers/usb/serial/bus.o
  CC      net/tipc/socket.o
  CC      net/tipc/user_reg.o
  CC      sound/pci/maestro3.o
  LD      drivers/infiniband/hw/mlx4/mlx4_ib.o
  LD      drivers/infiniband/hw/mthca/ib_mthca.o
  LD      drivers/infiniband/hw/mthca/built-in.o
  LD      net/netlink/built-in.o
  CC      net/ipv6/inet6_connection_sock.o
  CC      drivers/scsi/aic7xxx/aic7xxx_93cx6.o
  CC      net/ipv6/sysctl_net_ipv6.o
  CC      net/ipv6/xfrm6_policy.o
  CC      drivers/scsi/aic7xxx/aic7xxx_pci.o
  CC      net/tipc/zone.o
  LD      drivers/infiniband/hw/mlx4/built-in.o
  CC      drivers/scsi/ipr.o
  CC      drivers/scsi/aic7xxx/aic7xxx_osm.o
  LD      drivers/infiniband/built-in.o
  LD      net/netfilter/built-in.o
  CC      drivers/scsi/aic7xxx/aic7xxx_proc.o
  CC      net/ipv6/xfrm6_state.o
  CC      drivers/net/mlx4/profile.o
  CC      drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
  CC      drivers/net/mlx4/qp.o
  CC      drivers/net/mlx4/reset.o
  LD      net/unix/unix.o
  LD      net/unix/built-in.o
  CC      drivers/net/mlx4/srq.o
  CC      net/ipv6/xfrm6_input.o
  CC      net/ipv6/xfrm6_output.o
  CC      net/tipc/dbg.o
  CC      drivers/scsi/stex.o
  CC      drivers/scsi/osst.o
  LD      drivers/scsi/sd_mod.o
drivers/scsi/dpt_i2o.c:169: warning: 'dptids' defined but not used
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      net/ipv6/netfilter.o
  CC      drivers/scsi/sg.o
  CC      drivers/scsi/ses.o
  CC      net/tipc/eth_media.o
  CC      net/ipv6/fib6_rules.o
  CC      net/ipv6/proc.o
  CC      net/xfrm/xfrm_state.o
  LD      drivers/net/atl1/atl1.o
  LD      drivers/net/atl1/built-in.o
  CC      net/ipv6/ah6.o
  CC      drivers/net/myri10ge/myri10ge.o
  CC      drivers/net/phy/phy.o
  CC      drivers/usb/misc/emi26.o
  CC      drivers/net/sk98lin/skge.o
  CC      net/sctp/outqueue.o
  CC      net/sctp/ulpqueue.o
  CC      sound/pci/rme32.o
  CC      drivers/usb/serial/console.o
  CC      drivers/usb/serial/ezusb.o
  CC      drivers/usb/serial/airprime.o
  CC      drivers/usb/serial/cp2101.o
  LD      drivers/scsi/aacraid/aacraid.o
  CC      drivers/usb/serial/cyberjack.o
  LD      drivers/scsi/aacraid/built-in.o
  CC      drivers/usb/serial/cypress_m8.o
  CC      drivers/net/phy/phy_device.o
  LD      drivers/scsi/scsi_mod.o
  CC      drivers/net/phy/mdio_bus.o
  CC      net/ipv6/esp6.o
  CC      drivers/usb/serial/io_edgeport.o
  CC      net/ipv6/xfrm6_mode_transport.o
  CC      drivers/usb/serial/io_ti.o
drivers/scsi/qla1280.c: In function 'qla1280_isr':
drivers/scsi/qla1280.c:3530: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
  CC      drivers/usb/serial/empeg.o
  CC      net/ipv6/xfrm6_mode_tunnel.o
  CC      net/ipv6/xfrm6_mode_ro.o
  CC      net/ipv6/netfilter/ip6_tables.o
  CC      drivers/usb/misc/idmouse.o
  CC      drivers/usb/serial/garmin_gps.o
  CC      net/ipv6/sit.o
  CC      net/ipv6/addrconf_core.o
  CC      net/ipv6/exthdrs_core.o
  CC      net/ipv6/inet6_hashtables.o
  CC      drivers/usb/serial/hp4x.o
  CC      sound/pci/rme96.o
  CC      drivers/usb/misc/usblcd.o
  CC      drivers/usb/serial/ipaq.o
  CC      sound/pci/sonicvibes.o
  CC      net/sctp/command.o
  CC      sound/pci/ac97/ac97_codec.o
  CC      sound/pci/ac97/ac97_pcm.o
  CC      net/sctp/tsnmap.o
  CC      sound/pci/ac97/ac97_proc.o
  CC      sound/pci/ali5451/ali5451.o
  CC      drivers/usb/serial/iuu_phoenix.o
  CC      drivers/usb/misc/ldusb.o
  CC      net/ipv6/netfilter/ip6table_mangle.o
  CC      drivers/usb/misc/rio500.o
  CC      drivers/net/phy/lxt.o
  CC      drivers/net/skfp/skfddi.o
  CC      drivers/usb/host/ohci-hcd.o
  CC      net/sctp/bind_addr.o
  LD      drivers/usb/storage/built-in.o
  CC      net/sctp/socket.o
  CC      drivers/usb/serial/ir-usb.o
  CC      drivers/usb/serial/kobil_sct.o
  CC      drivers/usb/serial/omninet.o
  CC      drivers/usb/serial/sierra.o
  CC      drivers/usb/serial/visor.o
  CC      drivers/usb/host/uhci-hcd.o
  CC      drivers/usb/host/sl811-hcd.o
  CC      drivers/net/phy/smsc.o
  CC      drivers/net/phy/vitesse.o
  LD      drivers/scsi/libsas/libsas.o
  LD      drivers/scsi/libsas/built-in.o
  CC      net/xfrm/xfrm_hash.o
  CC      net/xfrm/xfrm_input.o
  CC      drivers/net/phy/broadcom.o
  CC      drivers/net/sk98lin/skethtool.o
  CC      drivers/net/sk98lin/skdim.o
  CC      net/sctp/primitive.o
  CC      drivers/net/sk98lin/skaddr.o
  CC      drivers/net/sk98lin/skgehwt.o
  CC      drivers/usb/misc/usbtest.o
net/core/dev.c: In function 'net_rx_action':
net/core/dev.c:2211: warning: passing argument 2 of 'print_symbol' makes integer from pointer without a cast
  CC      drivers/net/sk98lin/skgeinit.o
  CC      drivers/net/sk98lin/skgepnmi.o
  CC      drivers/net/sk98lin/skgesirq.o
  CC      drivers/net/usb/pegasus.o
  CC      net/xfrm/xfrm_output.o
  LD      sound/pci/au88x0/built-in.o
  CC      sound/pci/ca0106/ca0106_main.o
  LD      sound/pci/cs46xx/built-in.o
  CC      sound/pci/cs5535audio/cs5535audio.o
  CC      sound/pci/cs5535audio/cs5535audio_pcm.o
  CC      net/xfrm/xfrm_algo.o
  CC      sound/pci/ca0106/ca0106_proc.o
  CC      sound/pci/cs5535audio/cs5535audio_pm.o
  CC      net/sctp/output.o
  CC      net/sctp/input.o
  CC      sound/pci/echoaudio/darla20.o
  CC      sound/pci/emu10k1/emu10k1.o
  CC      drivers/usb/misc/sisusbvga/sisusb.o
  CC      drivers/usb/misc/sisusbvga/sisusb_init.o
  CC      drivers/usb/misc/sisusbvga/sisusb_con.o
  CC      sound/pci/echoaudio/echo3g.o
  CC      sound/pci/echoaudio/gina20.o
  CC      drivers/net/usb/cdc_ether.o
  LD      drivers/misc/built-in.o
  CC      sound/pci/echoaudio/gina24.o
  CC      drivers/net/usb/net1080.o
  CC      net/sctp/debug.o
  CC      net/sctp/ssnmap.o
  CC      drivers/net/skfp/hwmtm.o
  CC      drivers/net/skfp/fplustm.o
  CC      drivers/net/sk98lin/ski2c.o
  CC      drivers/net/sk98lin/sklm80.o
  CC      drivers/net/skfp/smt.o
  CC      net/sctp/proc.o
  CC      drivers/net/wan/hdlc.o
  CC      drivers/net/wan/hdlc_fr.o
  LD      drivers/net/e1000/e1000.o
  LD      drivers/net/e1000/built-in.o
  CC      drivers/net/wireless/ipw2100.o
  CC      drivers/net/wireless/orinoco.o
  CC      drivers/net/wireless/hermes.o
  CC      net/sctp/auth.o
  CC      drivers/net/wireless/orinoco_plx.o
  CC      drivers/net/wireless/orinoco_pci.o
  CC      drivers/net/wireless/orinoco_nortel.o
  CC      sound/pci/ca0106/ca0106_mixer.o
  CC      sound/pci/ca0106/ca_midi.o
  CC      net/sctp/sysctl.o
  CC      drivers/net/skfp/cfm.o
  CC      drivers/net/skfp/ecm.o
  CC      drivers/net/skfp/pcmplc.o
  CC      drivers/net/skfp/pmf.o
  CC      net/sctp/ipv6.o
  CC      drivers/net/skfp/queue.o
  CC      drivers/net/sk98lin/skqueue.o
  CC      drivers/net/skfp/rmt.o
  CC      sound/pci/echoaudio/indigo.o
  CC      sound/pci/echoaudio/indigodj.o
  CC      drivers/net/usb/plusb.o
  LD      drivers/net/mlx4/mlx4_core.o
  LD      drivers/net/mlx4/built-in.o
  CC      drivers/net/ipg.o
  CC      drivers/net/sunhme.o
  CC      drivers/net/usb/rndis_host.o
  LD      drivers/net/phy/libphy.o
  CC      drivers/net/usb/cdc_subset.o
  CC      drivers/net/sk98lin/skrlmt.o
  LD      drivers/net/phy/built-in.o
  CC      drivers/net/sk98lin/sktimer.o
  CC      drivers/net/cassini.o
  CC      drivers/net/typhoon.o
  CC      drivers/net/sk98lin/skvpd.o
  CC      drivers/net/sk98lin/skxmac2.o
  CC      drivers/net/ne2k-pci.o
  CC      drivers/net/8390.o
net/sctp/ulpevent.c: In function 'sctp_ulpevent_get_notification_type':
net/sctp/ulpevent.c:862: warning: passing argument 1 of 'sctp_event2skb' discards qualifiers from pointer target type
  CC      drivers/net/eepro100.o
  CC      drivers/net/e100.o
  CC      drivers/net/tlan.o
  CC      sound/pci/emu10k1/emu10k1_main.o
  CC      drivers/net/epic100.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memset_io':
include/asm/io_32.h:210: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
  LD      net/llc/llc.o
  LD      net/llc/llc2.o
  LD      sound/pci/hda/built-in.o
  LD      net/llc/built-in.o
  CC      sound/pci/korg1212/korg1212.o
  CC      sound/pci/mixart/mixart.o
  LD      sound/pci/nm256/built-in.o
  CC      sound/pci/ice1712/ice1712.o
  CC      drivers/net/wan/hdlc_ppp.o
  LD      sound/pci/oxygen/built-in.o
  CC      drivers/net/wan/syncppp.o
  CC      sound/pci/pcxhr/pcxhr.o
  CC      drivers/net/usb/zaurus.o
  CC      sound/pci/pcxhr/pcxhr_hwdep.o
  CC      sound/pci/pcxhr/pcxhr_mixer.o
  CC      sound/pci/pcxhr/pcxhr_core.o
  CC      drivers/net/wireless/airo.o
  CC      drivers/net/wireless/atmel.o
  CC      drivers/net/usb/usbnet.o
  CC      drivers/net/wan/farsync.o
  CC      drivers/net/skfp/smtdef.o
  LD      sound/pci/riptide/built-in.o
  CC      drivers/net/wireless/atmel_pci.o
  CC      drivers/net/wireless/libertas/main.o
  CC      sound/pci/rme9652/hdsp.o
  CC      sound/pci/trident/trident.o
  CC      sound/pci/trident/trident_main.o
  CC      sound/pci/trident/trident_memory.o
  LD      drivers/usb/serial/usbserial.o
  CC      drivers/net/wireless/prism54/islpci_eth.o
  CC      drivers/net/wireless/rndis_wlan.o
  CC      drivers/net/wireless/prism54/islpci_mgt.o
  CC      drivers/net/wireless/prism54/isl_38xx.o
  CC      sound/pci/rme9652/hdspm.o
  CC      sound/pci/rme9652/rme9652.o
  CC      drivers/net/wireless/prism54/isl_ioctl.o
  LD      net/ipv4/built-in.o
  CC      drivers/net/wireless/prism54/islpci_dev.o
  LD      sound/pci/ca0106/snd-ca0106.o
  CC      drivers/net/skfp/smtinit.o
include/asm/io_32.h: In function 'memset_io':
include/asm/io_32.h:210: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
  LD      sound/pci/ca0106/built-in.o
  CC      drivers/net/sis900.o
  CC      sound/pci/ymfpci/ymfpci.o
  CC      sound/pci/ymfpci/ymfpci_main.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/net/skfp/smttimer.o
  CC      drivers/net/skfp/srf.o
  CC      sound/pci/vx222/vx222.o
  LD      net/core/built-in.o
  CC      sound/pci/vx222/vx222_ops.o
  CC      drivers/net/r6040.o
  CC      drivers/net/acenic.o
  CC      drivers/net/natsemi.o
  CC      drivers/net/ns83820.o
  CC      drivers/net/fealnx.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/net/wan/sbni.o
  LD      sound/pci/ali5451/snd-ali5451.o
  CC      sound/pci/ice1712/delta.o
  LD      sound/pci/ali5451/built-in.o
  CC      sound/pci/ice1712/hoontech.o
  CC      sound/pci/mixart/mixart_core.o
  CC      drivers/scsi/lpfc/lpfc_ct.o
  CC      drivers/scsi/lpfc/lpfc_els.o
  CC      drivers/net/skfp/hwt.o
  CC      drivers/net/skfp/drvfbi.o
  CC      drivers/net/skfp/ess.o
  CC      sound/pci/echoaudio/layla24.o
  CC      drivers/net/wireless/prism54/islpci_hotplug.o
  CC      drivers/net/wireless/prism54/oid_mgt.o
  CC      drivers/scsi/lpfc/lpfc_hbadisc.o
  CC      drivers/scsi/lpfc/lpfc_init.o
  CC      drivers/scsi/lpfc/lpfc_mbox.o
  LD      sound/pci/snd-ad1889.o
  LD      sound/pci/snd-als4000.o
  CC      drivers/scsi/lpfc/lpfc_nportdisc.o
  LD      sound/pci/snd-atiixp.o
  LD      sound/pci/snd-cs5530.o
  CC      drivers/scsi/lpfc/lpfc_scsi.o
  LD      sound/pci/snd-es1938.o
  LD      sound/pci/snd-es1968.o
  LD      sound/pci/snd-fm801.o
  CC      sound/pci/echoaudio/mia.o
  LD      sound/pci/snd-intel8x0m.o
  LD      sound/pci/snd-maestro3.o
  CC      sound/pci/mixart/mixart_hwdep.o
  LD      sound/pci/snd-rme32.o
  LD      sound/pci/snd-rme96.o
  LD      sound/pci/snd-sonicvibes.o
  CC      sound/pci/mixart/mixart_mixer.o
  CC      drivers/net/wan/pci200syn.o
  CC      drivers/scsi/lpfc/lpfc_attr.o
  CC      drivers/scsi/lpfc/lpfc_vport.o
  CC      drivers/scsi/lpfc/lpfc_debugfs.o
  CC      drivers/net/tg3.o
  CC      drivers/net/bnx2.o
  CC      drivers/net/wireless/libertas/wext.o
  LD      net/rxrpc/af-rxrpc.o
  CC      sound/pci/ice1712/ews.o
  LD      net/rxrpc/built-in.o
  CC      drivers/net/bnx2x.o
  CC      drivers/net/skge.o
  CC      sound/pci/ice1712/ak4xxx.o
  CC      drivers/net/sky2.o
  CC      drivers/net/starfire.o
  CC      drivers/net/mii.o
  CC      drivers/net/sundance.o
  CC      drivers/net/Space.o
  CC      drivers/net/loopback.o
  CC      sound/pci/emu10k1/irq.o
  LD      net/netlabel/built-in.o
  CC      sound/pci/emu10k1/memory.o
  CC      drivers/net/sb1000.o
  CC      drivers/net/forcedeth.o
  CC      sound/pci/emu10k1/voice.o
  CC      drivers/net/dummy.o
  CC      sound/pci/emu10k1/emumpu401.o
  CC      drivers/net/8139too.o
  CC      drivers/net/sc92031.o
  CC      drivers/net/dl2k.o
drivers/net/skfp/ess.c: In function 'ess_send_response':
drivers/net/skfp/ess.c:513: warning: cast from pointer to integer of different size
drivers/net/skfp/ess.c: In function 'ess_send_alc_req':
drivers/net/skfp/ess.c:609: warning: cast from pointer to integer of different size
drivers/net/skfp/ess.c:639: warning: cast from pointer to integer of different size
  CC      drivers/net/r8169.o
  CC      sound/pci/emu10k1/emupcm.o
  CC      sound/pci/emu10k1/io.o
  CC      drivers/net/wireless/libertas/rx.o
  CC      drivers/net/wireless/libertas/tx.o
  CC      drivers/net/wireless/libertas/cmd.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/net/wireless/libertas/cmdresp.o
  CC      drivers/net/wireless/libertas/scan.o
  CC      sound/pci/emu10k1/emuproc.o
  CC      sound/pci/emu10k1/emumixer.o
  CC      drivers/net/amd8111e.o
  LD      drivers/net/e1000e/e1000e.o
  LD      drivers/net/e1000e/built-in.o
  CC      drivers/net/s2io.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/net/enc28j60.o
  LD      sound/pci/cs5535audio/snd-cs5535audio.o
  LD      sound/pci/cs5535audio/built-in.o
  CC      drivers/net/netconsole.o
  CC      drivers/net/virtio_net.o
  CC      drivers/usb/core/hcd.o
  CC      drivers/net/wireless/libertas/join.o
  CC      sound/pci/emu10k1/emufx.o
  LD      sound/pci/pcxhr/snd-pcxhr.o
  LD      sound/pci/pcxhr/built-in.o
  CC      sound/pci/emu10k1/timer.o
  LD      net/ipv6/netfilter/built-in.o
  LD      drivers/scsi/aic94xx/aic94xx.o
  CC      drivers/net/wireless/libertas/11d.o
  CC      sound/pci/emu10k1/p16v.o
  LD      drivers/scsi/aic94xx/built-in.o
  CC      sound/pci/emu10k1/emu10k1x.o
  CC      drivers/usb/core/urb.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/net/wireless/libertas/debugfs.o
  CC      drivers/usb/core/message.o
  CC      drivers/usb/core/driver.o
  CC      drivers/net/wireless/libertas/ethtool.o
  CC      drivers/usb/core/config.o
  CC      drivers/usb/core/file.o
  CC      drivers/usb/core/buffer.o
  CC      drivers/net/wireless/libertas/assoc.o
  CC      drivers/usb/core/sysfs.o
  CC      drivers/usb/core/endpoint.o
  LD      sound/pci/korg1212/snd-korg1212.o
  CC      drivers/usb/core/devio.o
  LD      sound/pci/korg1212/built-in.o
  CC      drivers/usb/core/notify.o
  LD      drivers/usb/serial/built-in.o
  CC      drivers/usb/core/generic.o
  CC      drivers/usb/core/quirks.o
  CC      drivers/usb/core/hcd-pci.o
  LD      drivers/usb/misc/sisusbvga/sisusbvga.o
  LD      drivers/usb/misc/sisusbvga/built-in.o
  CC      drivers/usb/core/inode.o
  LD      net/ipv6/ipv6.o
  CC      drivers/usb/core/devices.o
  LD      net/ipv6/built-in.o
  LD      sound/pci/vx222/snd-vx222.o
  LD      sound/pci/vx222/built-in.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/net/myri10ge/built-in.o
  LD      drivers/net/usb/built-in.o
drivers/telephony/ixj.c:287: warning: 'ixj_pci_tbl' defined but not used
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/char/drm/drm.o
  LD      drivers/char/drm/tdfx.o
  LD      drivers/char/drm/r128.o
  LD      drivers/char/drm/radeon.o
  LD      drivers/char/drm/mga.o
  LD      drivers/char/drm/i830.o
  LD      drivers/char/drm/sis.o
  LD      drivers/char/drm/via.o
  LD      drivers/telephony/built-in.o
  LD      drivers/usb/misc/built-in.o
  LD      sound/pci/ymfpci/snd-ymfpci.o
  LD      sound/pci/ymfpci/built-in.o
  LD      drivers/char/drm/built-in.o
  LD      drivers/char/built-in.o
  LD      sound/pci/trident/snd-trident.o
  LD      sound/pci/trident/built-in.o
  LD      drivers/net/wan/built-in.o
  LD      sound/pci/mixart/snd-mixart.o
  LD      sound/pci/mixart/built-in.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      sound/pci/ac97/snd-ac97-codec.o
  LD      sound/pci/ac97/built-in.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/scsi/aic7xxx/aic7xxx.o
  LD      drivers/scsi/aic7xxx/built-in.o
  LD      net/xfrm/built-in.o
  LD      drivers/net/skfp/skfp.o
  LD      drivers/net/skfp/built-in.o
drivers/net/wireless/libertas/cmd.c: In function 'lbs_set_channel':
drivers/net/wireless/libertas/cmd.c:802: warning: unused variable 'old_channel'
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/net/ixgbe/ixgbe.o
  LD      drivers/net/ixgbe/built-in.o
  LD      drivers/usb/host/built-in.o
  LD      sound/pci/rme9652/snd-rme9652.o
  LD      sound/pci/rme9652/snd-hdsp.o
  LD      sound/pci/rme9652/snd-hdspm.o
  LD      sound/pci/rme9652/built-in.o
  LD      drivers/net/wireless/prism54/prism54.o
  LD      drivers/net/wireless/prism54/built-in.o
drivers/net/sky2.c: In function 'sky2_mhz':
drivers/net/sky2.c:2699: warning: control reaches end of non-void function
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      net/tipc/tipc.o
  LD      net/tipc/built-in.o
drivers/net/acenic.c: In function 'ace_free_descriptors':
drivers/net/acenic.c:760: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type
drivers/net/acenic.c:765: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type
drivers/net/acenic.c:771: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type
  LD      drivers/scsi/lpfc/lpfc.o
  LD      drivers/scsi/lpfc/built-in.o
  LD      drivers/net/sk98lin/sk98lin.o
  LD      drivers/net/sk98lin/built-in.o
net/sctp/socket.c: In function 'sctp_msghdr_parse':
net/sctp/socket.c:5819: warning: passing argument 1 of 'cmsg_nxthdr' discards qualifiers from pointer target type
  LD      net/sctp/sctp.o
  LD      net/sctp/built-in.o
  LD      net/built-in.o
  LD      sound/pci/echoaudio/snd-darla20.o
  LD      sound/pci/echoaudio/snd-gina20.o
  LD      sound/pci/echoaudio/snd-gina24.o
  LD      sound/pci/echoaudio/snd-layla24.o
  LD      sound/pci/echoaudio/snd-mia.o
  LD      sound/pci/echoaudio/snd-echo3g.o
  LD      sound/pci/echoaudio/snd-indigo.o
  LD      sound/pci/echoaudio/snd-indigodj.o
  LD      sound/pci/echoaudio/built-in.o
  LD      drivers/usb/core/usbcore.o
  LD      drivers/usb/core/built-in.o
  LD      drivers/usb/built-in.o
  LD      sound/pci/ice1712/snd-ice1712.o
  LD      sound/pci/ice1712/snd-ice17xx-ak4xxx.o
  LD      sound/pci/ice1712/built-in.o
  LD      drivers/net/wireless/libertas/libertas.o
  LD      drivers/net/wireless/libertas/built-in.o
  LD      drivers/net/wireless/built-in.o
  LD      sound/pci/emu10k1/snd-emu10k1.o
  LD      sound/pci/emu10k1/snd-emu10k1x.o
  LD      sound/pci/emu10k1/built-in.o
  LD      sound/pci/built-in.o
  LD      sound/built-in.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/scsi/sym53c8xx_2/sym53c8xx.o
  LD      drivers/scsi/sym53c8xx_2/built-in.o
  LD      drivers/scsi/built-in.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/net/built-in.o
  LD      drivers/built-in.o
  LD      vmlinux.o
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
distcc[12023] ERROR: compile (null) on localhost failed
make: *** [vmlinux.o] Error 1
make: *** Waiting for unfinished jobs....
  LD      .tmp_vmlinux1
Command exited with non-zero status 2
89.55user 75.30system 1:14.43elapsed 221%CPU (0avgtext+0avgdata 0maxresident)k
13264inputs+2838456outputs (5major+7166794minor)pagefaults 0swaps
build ERRORS!

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc1
# Tue Feb 12 01:48:36 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BOOTPARAM_MAXCPUS_1=y
# CONFIG_BOOTPARAM_NOSMP is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
# CONFIG_BUG is not set
# CONFIG_ELF_CORE is not set
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_KPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_TINY_SHMEM=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

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
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_BOOTPARAM_NO_HZ_OFF is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_BOOTPARAM_HIGHRES_OFF is not set
# CONFIG_SMP is not set
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_VMI is not set
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
CONFIG_M486=y
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
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
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_RCU_TRACE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1=y
CONFIG_BOOTPARAM_NOAPIC=y
# CONFIG_BOOTPARAM_NOLAPIC is not set
# CONFIG_BOOTPARAM_NOLAPIC_TIMER is not set
CONFIG_BOOTPARAM_LAPIC=y
CONFIG_BOOTPARAM_HPET_DISABLE=y
CONFIG_BOOTPARAM_IDLE_MWAIT=y
# CONFIG_BOOTPARAM_IDLE_POLL is not set
CONFIG_BOOTPARAM_HIGHMEM_512M=y
# CONFIG_BOOTPARAM_NOPAT is not set
# CONFIG_BOOTPARAM_NOTSC is not set
CONFIG_BOOTPARAM_ACPI_OFF=y
# CONFIG_BOOTPARAM_PCI_NOACPI is not set
# CONFIG_BOOTPARAM_PCI_NOMSI is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_ASUS=y
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
CONFIG_APM_CPU_IDLE=y
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set
CONFIG_APM_REAL_MODE_POWER_OFF=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
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
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
# CONFIG_IP_VS is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set

#
# IP: Netfilter Configuration
#
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_IPTABLES=y
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=y
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set
# CONFIG_IP_DCCP_TFRC_LIB is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_L2CAP is not set
CONFIG_BT_SCO=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=y
# CONFIG_BT_HCIUSB_SCO is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
# CONFIG_IEEE80211_CRYPT_WEP is not set
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_FD is not set
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_MSI_LAPTOP=y
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_DOCK=y
# CONFIG_THINKPAD_ACPI_BAY is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y

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
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIL24 is not set
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
# CONFIG_PATA_CS5536 is not set
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT821X=y
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_NS87415=y
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=y
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_IEEE1394=y

#
# Subsystem Options
#
CONFIG_IEEE1394_VERBOSEDEBUG=y

#
# Controllers
#

#
# Texas Instruments PCILynx requires I2C
#
# CONFIG_IEEE1394_OHCI1394 is not set

#
# Protocols
#
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_NET_SB1000=y
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=y
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
CONFIG_AMD8111_ETH=y
CONFIG_AMD8111E_NAPI=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_ADAPTEC_STARFIRE_NAPI=y
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_EEPRO100=y
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
CONFIG_NE2K_PCI=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=y
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=y
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=y
CONFIG_E1000=y
# CONFIG_E1000_NAPI is not set
CONFIG_E1000_DISABLE_PACKET_SPLIT=y
CONFIG_E1000E=y
CONFIG_E1000E_ENABLED=y
CONFIG_IP1000=y
# CONFIG_IGB is not set
CONFIG_NS83820=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_R8169_NAPI=y
# CONFIG_R8169_VLAN is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_SK98LIN=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=y
CONFIG_IXGBE=y
# CONFIG_IXGB is not set
CONFIG_S2IO=y
# CONFIG_S2IO_NAPI is not set
CONFIG_MYRI10GE=y
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
# CONFIG_TEHUTI is not set
CONFIG_BNX2X=y
# CONFIG_TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
CONFIG_WLAN_80211=y
CONFIG_IPW2100=y
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
# CONFIG_IPW2200 is not set
CONFIG_LIBERTAS=y
# CONFIG_LIBERTAS_USB is not set
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_AIRO=y
CONFIG_HERMES=y
CONFIG_PLX_HERMES=y
# CONFIG_TMD_HERMES is not set
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_PRISM54=y
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
# CONFIG_WANXL is not set
# CONFIG_PC300 is not set
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=y
# CONFIG_DLCI is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
# CONFIG_ATM_DRIVERS is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_ISDN is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=y
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_SC520_WDT=y
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=y

#
# Multimedia devices
#
CONFIG_DVB_CORE=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=y
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I830=y
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_SERIAL_U16550=y
# CONFIG_SND_MPU401 is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y

#
# PCI devices
#
CONFIG_SND_AD1889=y
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
CONFIG_SND_ALI5451=y
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=y
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=y
CONFIG_SND_CS5535AUDIO=y
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
CONFIG_SND_INDIGO=y
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
CONFIG_SND_FM801=y
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=y
CONFIG_SND_HDSPM=y
# CONFIG_SND_HIFIER is not set
CONFIG_SND_ICE1712=y
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
# CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL is not set
CONFIG_SND_MAESTRO3=y
# CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL is not set
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
# CONFIG_SND_SIS7019 is not set
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
# CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# SPI devices
#

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_TRIDENT is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
CONFIG_USB_PERSIST=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_AIRPRIME=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_HP4X=y
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=y
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_CXGB3=y
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_IPOIB is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_NOLOCK is not set
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

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
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_HAVE_FTRACE=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACING=y
CONFIG_FTRACE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_KOBJECT=y
CONFIG_KGDB=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_NONPROMISC_DEVMEM=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_PAGE_FAULT_HANDLERS=y
CONFIG_MMIOTRACE=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_VIRTUALIZATION=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--VbJkn9YxBvnuCH5J--
