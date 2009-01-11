Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZAKRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZAKRab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZAKRaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:30:17 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:46316 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZAKR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:29:59 -0500
Date: Sun, 11 Jan 2009 12:29:41 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.29-rc1
In-reply-to: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200901111229.41964.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, Linus Torvalds wrote:
>The merge window is over, and while it is quite possible that I missed a
[...]
Some possibly interesting output from my 'makeit' script is presented here.  
I've been seeing the section miss-matches all the way through the 2.6.28 
cycle, but it runs ok ANAICT.  I haven't booted this yet, but it does seem to 
be noisy even for an -rc1.  System is a quad core Phenom, ASUS mobo. Tools 
are Fedora 8 issue, up2date.  'makeit' is a script that builds and installs a 
new, configured kernel etc that I've used for years here.

Comments please.
================================
root@coyote linux-2.6.29-rc1]# time ./makeit
now making kernel 2.6.29-rc1, if not right, hit ctl+c now
(short pause)

makeing bzImage
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
#
# configuration written to .config
#
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  HOSTCC  scripts/ihex2fw
  HOSTCC  scripts/kallsyms
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  HOSTCC  scripts/pnmtologo
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTCC  scripts/conmakehash
  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  KSYM    .tmp_kallsyms0.S
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  AS      .tmp_kallsyms0.o
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      init/main.o
  CHK     include/linux/compile.h
  HOSTCC  usr/gen_init_cpio
  UPD     include/linux/compile.h
  CC      init/do_mounts.o
  GEN     usr/initramfs_data.cpio.gz
  AS      usr/initramfs_data.o
  LD      usr/built-in.o
  CC      init/do_mounts_initrd.o
  CC      init/initramfs.o
  CC      init/calibrate.o
  CC      arch/x86/kernel/process_32.o
  CC      arch/x86/mm/init_32.o
  CC      arch/x86/kernel/signal.o
  CC      init/version.o
  CC      arch/x86/mm/fault.o
  LD      init/mounts.o
  LD      init/built-in.o
  CC      arch/x86/mach-default/setup.o
  AS      arch/x86/kernel/entry_32.o
  CC      arch/x86/kernel/traps.o
  LD      arch/x86/mach-default/built-in.o
  CC      arch/x86/mm/ioremap.o
  LD      arch/x86/crypto/built-in.o
  CC      arch/x86/kernel/irq.o
  CC      arch/x86/kernel/irq_32.o
  CC      arch/x86/mm/extable.o
  CC      arch/x86/kernel/dumpstack_32.o
  CC      arch/x86/kernel/time_32.o
  CC      arch/x86/mm/pageattr.o
  CC      arch/x86/kernel/ioport.o
  LDS     arch/x86/vdso/vdso32/vdso32.lds
  AS      arch/x86/vdso/vdso32/note.o
  AS      arch/x86/vdso/vdso32/int80.o
  CC      arch/x86/kernel/ldt.o
  AS      arch/x86/vdso/vdso32/sysenter.o
  CC      arch/x86/vdso/vdso32-setup.o
  CC      arch/x86/mm/mmap.o
  CC      arch/x86/kernel/dumpstack.o
  CC      arch/x86/mm/pat.o
  VDSO    arch/x86/vdso/vdso32-int80.so.dbg
  VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  OBJCOPY arch/x86/vdso/vdso32-int80.so
  CC      arch/x86/kernel/setup.o
  OBJCOPY arch/x86/vdso/vdso32-sysenter.so
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  AS      arch/x86/vdso/vdso32.o
  LD      arch/x86/vdso/built-in.o
  CC      kernel/sched.o
  CC      arch/x86/mm/pgtable.o
  CC      arch/x86/kernel/i8259.o
  CC      arch/x86/mm/gup.o
  CC      arch/x86/kernel/irqinit_32.o
  CC      arch/x86/mm/pgtable_32.o
  CC      arch/x86/kernel/setup_percpu.o
  CC      arch/x86/mm/iomap_32.o
  CC      arch/x86/kernel/probe_roms_32.o
  CC      arch/x86/mm/hugetlbpage.o
  CC      arch/x86/kernel/sys_i386_32.o
  CC      arch/x86/mm/highmem_32.o
  CC      arch/x86/kernel/i386_ksyms_32.o
  CC      arch/x86/kernel/bootflag.o
  LD      arch/x86/mm/built-in.o
  CC      mm/bootmem.o
  CC      arch/x86/kernel/e820.o
  CC      mm/filemap.o
  CC      kernel/fork.o
  CC      arch/x86/kernel/pci-dma.o
  CC      arch/x86/kernel/quirks.o
  CC      kernel/exec_domain.o
  CC      mm/mempool.o
  CC      arch/x86/kernel/i8237.o
  CC      kernel/panic.o
  CC      arch/x86/kernel/topology.o
  CC      mm/oom_kill.o
  CC      arch/x86/kernel/kdebugfs.o
  CC      kernel/printk.o
  CC      arch/x86/kernel/alternative.o
  CC      mm/fadvise.o
  CC      arch/x86/kernel/i8253.o
  CC      mm/maccess.o
  CC      kernel/cpu.o
  CC      mm/page_alloc.o
  CC      arch/x86/kernel/pci-nommu.o
  CC      kernel/exit.o
  CC      arch/x86/kernel/tsc.o
  CC      arch/x86/kernel/io_delay.o
  CC      kernel/itimer.o
  CC      arch/x86/kernel/rtc.o
  CC      mm/page-writeback.o
  TIMEC   kernel/timeconst.h
  CC      arch/x86/kernel/trampoline.o
  CC      kernel/softirq.o
  CC      arch/x86/kernel/process.o
  CC      arch/x86/kernel/i387.o
  CC      kernel/resource.o
  CC      mm/pdflush.o
  CC      mm/readahead.o
  CC      arch/x86/kernel/xsave.o
  CC      kernel/sysctl.o
  CC      arch/x86/kernel/ptrace.o
  CC      mm/swap.o
  CC      arch/x86/kernel/ds.o
  CC      kernel/capability.o
  CC      mm/truncate.o
  CC      kernel/ptrace.o
  CC      arch/x86/kernel/tls.o
  CC      mm/vmscan.o
  CC      arch/x86/kernel/step.o
  CC      kernel/timer.o
  CC      arch/x86/kernel/acpi/boot.o
  CC      kernel/user.o
  CC      arch/x86/kernel/acpi/cstate.o
  CC      mm/shmem.o
  CC      kernel/signal.o
  CC      arch/x86/kernel/acpi/processor.o
  LD      arch/x86/kernel/acpi/built-in.o
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
  CC      mm/prio_tree.o
  CC      kernel/sys.o
  CC      arch/x86/kernel/cpu/addon_cpuid_features.o
  CC      mm/util.o
  CC      arch/x86/kernel/cpu/proc.o
  MKCAP   arch/x86/kernel/cpu/capflags.c
  CC      mm/mmzone.o
  CC      arch/x86/kernel/cpu/powerflags.o
  CC      arch/x86/kernel/cpu/common.o
  CC      mm/vmstat.o
  CC      kernel/kmod.o
  CC      arch/x86/kernel/cpu/vmware.o
  CC      mm/backing-dev.o
  CC      kernel/workqueue.o
  CC      arch/x86/kernel/cpu/hypervisor.o
  CC      arch/x86/kernel/cpu/bugs.o
  CC      mm/page_isolation.o
  CC      arch/x86/kernel/cpu/cmpxchg.o
  CC      kernel/pid.o
  CC      mm/mm_init.o
  CC      arch/x86/kernel/cpu/intel.o
  CC      mm/fremap.o
  CC      arch/x86/kernel/cpu/amd.o
  CC      kernel/rcupdate.o
  CC      arch/x86/kernel/cpu/cyrix.o
  CC      mm/highmem.o
  CC      kernel/extable.o
  CC      arch/x86/kernel/cpu/centaur.o
  CC      kernel/params.o
  CC      arch/x86/kernel/cpu/transmeta.o
  CC      mm/madvise.o
  CC      arch/x86/kernel/cpu/umc.o
  CC      kernel/posix-timers.o
  CC      arch/x86/kernel/cpu/mtrr/main.o
  CC      mm/memory.o
  CC      kernel/kthread.o
  CC      arch/x86/kernel/cpu/mtrr/if.o
  CC      kernel/wait.o
  CC      arch/x86/kernel/cpu/mtrr/generic.o
  CC      kernel/kfifo.o
  CC      kernel/sys_ni.o
  CC      kernel/posix-cpu-timers.o
  CC      arch/x86/kernel/cpu/mtrr/state.o
  CC      mm/mincore.o
  CC      arch/x86/kernel/cpu/mtrr/amd.o
  CC      arch/x86/kernel/cpu/mtrr/cyrix.o
  CC      mm/mlock.o
  CC      kernel/mutex.o
  CC      arch/x86/kernel/cpu/mtrr/centaur.o
  CC      kernel/hrtimer.o
  LD      arch/x86/kernel/cpu/mtrr/built-in.o
  CC      arch/x86/kernel/cpu/perfctr-watchdog.o
  CC      mm/mmap.o
  CC      arch/x86/kernel/cpu/capflags.o
  LD      arch/x86/kernel/cpu/built-in.o
  CC      arch/x86/kernel/reboot.o
  CC      kernel/rwsem.o
  CC      kernel/nsproxy.o
  CC      arch/x86/kernel/msr.o
  CC      mm/mprotect.o
  CC      kernel/srcu.o
  CC      arch/x86/kernel/cpuid.o
  CC      kernel/semaphore.o
  CC      mm/mremap.o
  CC      arch/x86/kernel/early-quirks.o
  CC      kernel/notifier.o
  CC      kernel/ksysfs.o
  CC      arch/x86/kernel/smp.o
  CC      kernel/pm_qos_params.o
  CC      kernel/sched_clock.o
  CC      mm/msync.o
  CC      arch/x86/kernel/smpboot.o
  CC      kernel/cred.o
  CC      mm/rmap.o
  CC      kernel/async.o
  CC      arch/x86/kernel/tsc_sync.o
  CC      kernel/sysctl_check.o
  CC      mm/vmalloc.o
  CC      arch/x86/kernel/ipi.o
  CC      arch/x86/kernel/tlb_32.o
  CC      kernel/irq/handle.o
  CC      arch/x86/kernel/smpcommon.o
  CC      mm/pagewalk.o
  CC      kernel/irq/manage.o
  AS      arch/x86/kernel/trampoline_32.o
  CC      arch/x86/kernel/apic.o
  CC      mm/bounce.o
  CC      kernel/irq/spurious.o
  CC      mm/page_io.o
  CC      kernel/irq/resend.o
  CC      arch/x86/kernel/nmi.o
  CC      kernel/irq/chip.o
  CC      mm/swap_state.o
  CC      kernel/irq/devres.o
  CC      arch/x86/kernel/io_apic.o
  CC      mm/swapfile.o
  CC      kernel/irq/autoprobe.o
  CC      kernel/irq/proc.o
  CC      kernel/irq/migration.o
  LD      kernel/irq/built-in.o
  CC      kernel/power/main.o
  CC      mm/thrash.o
  CC      arch/x86/kernel/reboot_fixups_32.o
  CC      kernel/power/poweroff.o
  LD      kernel/power/built-in.o
  CC      kernel/time/timekeeping.o
  CC      mm/dmapool.o
  CC      arch/x86/kernel/vsmp_64.o
  CC      arch/x86/kernel/module_32.o
  CC      kernel/time/ntp.o
  CC      mm/hugetlb.o
  CC      arch/x86/kernel/doublefault_32.o
  CC      kernel/time/clocksource.o
  CC      arch/x86/kernel/vm86_32.o
  CC      kernel/time/jiffies.o
  CC      mm/shmem_acl.o
  CC      arch/x86/kernel/early_printk.o
  CC      kernel/time/timer_list.o
  CC      mm/slab.o
  CC      arch/x86/kernel/hpet.o
  CC      kernel/time/clockevents.o
  CC      kernel/time/tick-common.o
  CC      arch/x86/kernel/k8.o
  CC      kernel/time/tick-broadcast.o
  CC      arch/x86/kernel/pcspeaker.o
  CC      mm/filemap_xip.o
  CC      arch/x86/kernel/check.o
  CC      kernel/time/tick-oneshot.o
  AS      arch/x86/kernel/head_32.o
  CC      arch/x86/kernel/head32.o
  CC      mm/allocpercpu.o
  CC      kernel/time/tick-sched.o
  CC      arch/x86/kernel/head.o
  LD      mm/built-in.o
  CC      arch/x86/kernel/init_task.o
  CC      kernel/futex.o
  LD      kernel/time/built-in.o
  CC      kernel/rtmutex.o
  LDS     arch/x86/kernel/vmlinux.lds
  LD      arch/x86/kernel/built-in.o
  CC      kernel/dma.o
  CC      fs/open.o
  CC      kernel/smp.o
  CC      ipc/util.o
  CC      kernel/spinlock.o
  CC      fs/read_write.o
  CC      ipc/msgutil.o
  CC      kernel/uid16.o
  CC      ipc/msg.o
  CC      kernel/module.o
  CC      fs/file_table.o
  CC      ipc/sem.o
  CC      fs/super.o
  CC      ipc/shm.o
  CC      fs/char_dev.o
  CC      kernel/kallsyms.o
  CC      fs/stat.o
  CC      ipc/ipcns_notifier.o
  CC      kernel/acct.o
  CC      ipc/ipc_sysctl.o
  CC      fs/exec.o
  CC      ipc/mqueue.o
  CC      kernel/utsname.o
  CC      kernel/stop_machine.o
  CC      fs/pipe.o
  CC      ipc/namespace.o
  CC      kernel/audit.o
  LD      ipc/built-in.o
  CC      security/commoncap.o
  CC      fs/namei.o
  LD      security/built-in.o
  CC      kernel/auditfilter.o
  CC      kernel/auditsc.o
  CC      fs/fcntl.o
  CC      fs/ioctl.o
  CC      kernel/audit_tree.o
  CC      kernel/seccomp.o
  CC      fs/readdir.o
  CC      crypto/api.o
  CC      kernel/rcupreempt.o
  CC      fs/select.o
  CC      crypto/cipher.o
  CC      kernel/utsname_sysctl.o
  CC      fs/fifo.o
  CC      kernel/dma-coherent.o
  CC      crypto/digest.o
  CC      fs/dcache.o
  CC      kernel/sched_cpupri.o
  CC      crypto/compress.o
  CC      kernel/time.o
  CC      crypto/algapi.o
  LD      kernel/built-in.o
  CC      fs/inode.o
  CC      block/elevator.o
  CC      crypto/scatterwalk.o
  CC      fs/attr.o
  CC      crypto/proc.o
  CC      block/blk-core.o
  CC      crypto/ablkcipher.o
  CC      fs/bad_inode.o
  CC      fs/file.o
  CC      crypto/blkcipher.o
  CC      block/blk-tag.o
  CC      fs/filesystems.o
  CC      fs/namespace.o
  CC      block/blk-sysfs.o
  CC      crypto/hash.o
  CC      block/blk-barrier.o
  CC      crypto/ahash.o
  CC      block/blk-settings.o
  CC      crypto/shash.o
  CC      fs/seq_file.o
  CC      block/blk-ioc.o
  CC      fs/xattr.o
  CC      crypto/algboss.o
  CC      block/blk-map.o
  CC      crypto/testmgr.o
  CC      fs/libfs.o
  CC      block/blk-exec.o
  CC      fs/fs-writeback.o
  CC      block/blk-merge.o
  CC      crypto/aead.o
  CC      fs/pnode.o
  CC      block/blk-softirq.o
  CC      fs/drop_caches.o
  CC      block/blk-timeout.o
  LD      crypto/crypto_blkcipher.o
  CC      crypto/chainiv.o
  CC      fs/splice.o
  CC      block/ioctl.o
  CC      crypto/eseqiv.o
  LD      crypto/crypto_hash.o
  LD      crypto/cryptomgr.o
  CC      crypto/hmac.o
  CC      block/genhd.o
  CC      fs/sync.o
  CC      crypto/md5.o
  CC      fs/utimes.o
  CC      block/scsi_ioctl.o
  CC      crypto/sha1_generic.o
  CC      fs/stack.o
  CC      crypto/crc32c.o
  CC      crypto/rng.o
  CC      block/cmd-filter.o
  CC      fs/buffer.o
  CC      block/bsg.o
  CC      crypto/krng.o
  LD      crypto/crypto.o
  LD      crypto/crypto_algapi.o
  LD      crypto/built-in.o
  CC      block/noop-iosched.o
  CC      drivers/acpi/tables.o
  CC      block/cfq-iosched.o
  CC      drivers/acpi/blacklist.o
  CC      fs/bio.o
  CC      drivers/acpi/osl.o
  CC      drivers/acpi/utils.o
  LD      block/built-in.o
  LD      sound/built-in.o
  LD      sound/arm/built-in.o
  LD      sound/core/oss/built-in.o
  CC      fs/block_dev.o
  LD      sound/core/seq/built-in.o
  LD      sound/core/seq/oss/built-in.o
  LD      sound/core/built-in.o
  LD      sound/drivers/built-in.o
  LD      sound/drivers/mpu401/built-in.o
  LD      sound/drivers/opl3/built-in.o
  LD      sound/drivers/opl4/built-in.o
  LD      sound/drivers/pcsp/built-in.o
  LD      sound/drivers/vx/built-in.o
  LD      sound/i2c/built-in.o
  LD      sound/i2c/other/built-in.o
  LD      sound/isa/built-in.o
  LD      sound/isa/ad1816a/built-in.o
  CC      drivers/acpi/reboot.o
  LD      sound/isa/ad1848/built-in.o
  LD      sound/isa/cs423x/built-in.o
  LD      sound/isa/es1688/built-in.o
  LD      sound/isa/gus/built-in.o
  LD      sound/isa/opti9xx/built-in.o
  LD      sound/isa/sb/built-in.o
  LD      sound/isa/wavefront/built-in.o
  LD      sound/isa/wss/built-in.o
  LD      sound/mips/built-in.o
  LD      sound/parisc/built-in.o
  LD      sound/pci/built-in.o
  LD      sound/pci/ac97/built-in.o
  LD      sound/pci/ali5451/built-in.o
  LD      sound/pci/au88x0/built-in.o
  LD      sound/pci/aw2/built-in.o
  LD      sound/pci/ca0106/built-in.o
  LD      sound/pci/cs46xx/built-in.o
  LD      sound/pci/cs5535audio/built-in.o
  LD      sound/pci/echoaudio/built-in.o
  LD      sound/pci/emu10k1/built-in.o
  LD      sound/pci/hda/built-in.o
  LD      sound/pci/ice1712/built-in.o
  LD      sound/pci/korg1212/built-in.o
  LD      sound/pci/mixart/built-in.o
  LD      sound/pci/nm256/built-in.o
  LD      sound/pci/oxygen/built-in.o
  LD      sound/pci/pcxhr/built-in.o
  CC      drivers/acpi/acpica/dsfield.o
  LD      sound/pci/riptide/built-in.o
  LD      sound/pci/rme9652/built-in.o
  LD      sound/pci/trident/built-in.o
  LD      sound/pci/vx222/built-in.o
  LD      sound/pci/ymfpci/built-in.o
  LD      sound/pcmcia/pdaudiocf/built-in.o
  LD      sound/pcmcia/vx/built-in.o
  LD      sound/ppc/built-in.o
  LD      sound/sh/built-in.o
  LD      sound/soc/built-in.o
  LD      sound/sparc/built-in.o
  LD      sound/spi/built-in.o
  CC      fs/direct-io.o
  LD      sound/synth/built-in.o
  LD      sound/synth/emux/built-in.o
  LD      sound/usb/built-in.o
  LD      sound/usb/caiaq/built-in.o
  LD      sound/usb/usx2y/built-in.o
  CC      drivers/acpi/acpica/dsmthdat.o
  CC      drivers/acpi/wakeup.o
  CC      drivers/acpi/acpica/dsopcode.o
  CC      drivers/acpi/main.o
  CC      fs/mpage.o
  CC      drivers/acpi/acpica/dswexec.o
  CC      drivers/acpi/acpica/dswscope.o
  CC      drivers/acpi/bus.o
  CC      drivers/acpi/acpica/dsmethod.o
  CC      fs/ioprio.o
  CC      drivers/acpi/acpica/dsobject.o
  CC      drivers/acpi/glue.o
  LD      fs/autofs4/built-in.o
  LD      fs/cifs/built-in.o
  LD      fs/configfs/built-in.o
  CC      fs/debugfs/inode.o
  CC      drivers/acpi/acpica/dsutils.o
  CC      fs/devpts/inode.o
  CC      fs/debugfs/file.o
  CC      drivers/acpi/acpica/dswload.o
  LD      fs/devpts/devpts.o
  LD      fs/devpts/built-in.o
  MK_FW   firmware/radeon/R100_cp.bin.ihex.gen.S
  MK_FW   firmware/radeon/R200_cp.bin.ihex.gen.S
  MK_FW   firmware/radeon/R300_cp.bin.ihex.gen.S
  MK_FW   firmware/radeon/R420_cp.bin.ihex.gen.S
  MK_FW   firmware/radeon/R520_cp.bin.ihex.gen.S
  MK_FW   firmware/radeon/RS600_cp.bin.ihex.gen.S
  MK_FW   firmware/radeon/RS690_cp.bin.ihex.gen.S
  AS      firmware/radeon/R100_cp.bin.ihex.gen.o
  AS      firmware/radeon/R200_cp.bin.ihex.gen.o
  AS      firmware/radeon/R300_cp.bin.ihex.gen.o
  AS      firmware/radeon/R420_cp.bin.ihex.gen.o
  AS      firmware/radeon/R520_cp.bin.ihex.gen.o
  AS      firmware/radeon/RS600_cp.bin.ihex.gen.o
  LD      fs/debugfs/debugfs.o
  AS      firmware/radeon/RS690_cp.bin.ihex.gen.o
  LD      fs/debugfs/built-in.o
  LD      fs/dlm/built-in.o
  LD      firmware/built-in.o
  LD      fs/exportfs/built-in.o
  CC      drivers/acpi/acpica/dswstate.o
  LD      fs/ext2/built-in.o
  LD      fs/ext3/built-in.o
  LD      fs/fat/built-in.o
  LD      fs/fuse/built-in.o
  CC      arch/x86/pci/i386.o
  CC      fs/hugetlbfs/inode.o
  CC      drivers/acpi/acpica/dsinit.o
  CC      arch/x86/pci/init.o
  CC      drivers/acpi/acpica/evevent.o
  CC      arch/x86/pci/pcbios.o
  LD      fs/hugetlbfs/hugetlbfs.o
  LD      fs/hugetlbfs/built-in.o
  CC      fs/isofs/namei.o
  CC      drivers/acpi/acpica/evregion.o
  CC      arch/x86/pci/mmconfig_32.o
  CC      fs/isofs/inode.o
  CC      drivers/acpi/acpica/evsci.o
  CC      fs/isofs/dir.o
  CC      arch/x86/pci/direct.o
  CC      drivers/acpi/acpica/evxfevnt.o
  CC      drivers/acpi/acpica/evmisc.o
  CC      fs/isofs/util.o
  CC      arch/x86/pci/mmconfig-shared.o
  CC      drivers/acpi/acpica/evrgnini.o
  CC      fs/isofs/rock.o
  CC      arch/x86/pci/fixup.o
  CC      drivers/acpi/acpica/evxface.o
  CC      arch/x86/pci/acpi.o
  CC      fs/isofs/export.o
  CC      drivers/acpi/acpica/evxfregn.o
  CC      drivers/acpi/acpica/evgpe.o
  CC      fs/isofs/joliet.o
  CC      arch/x86/pci/legacy.o
  CC      drivers/acpi/acpica/evgpeblk.o
  CC      arch/x86/pci/irq.o
  CC      fs/isofs/compress.o
  CC      drivers/acpi/acpica/exconfig.o
  LD      fs/isofs/isofs.o
  LD      fs/isofs/built-in.o
  LD      fs/jbd/built-in.o
  LD      fs/lockd/built-in.o
  LD      fs/nfs/built-in.o
  LD      fs/nfs_common/built-in.o
  LD      fs/nfsd/built-in.o
  CC      fs/nls/nls_base.o
  CC      arch/x86/pci/common.o
  CC      drivers/acpi/acpica/exfield.o
  CC      fs/nls/nls_cp437.o
  CC      drivers/acpi/acpica/exnames.o
  CC      fs/nls/nls_ascii.o
  CC      arch/x86/pci/early.o
  LD      fs/nls/built-in.o
  CC      fs/notify/dnotify/dnotify.o
  CC      drivers/acpi/acpica/exoparg6.o
  CC      arch/x86/pci/amd_bus.o
  CC      drivers/acpi/acpica/exresolv.o
  LD      fs/notify/dnotify/built-in.o
  CC      fs/notify/inotify/inotify.o
  LD      arch/x86/pci/built-in.o
  LD      arch/x86/power/built-in.o
  CC      fs/notify/inotify/inotify_user.o
  CC      drivers/acpi/acpica/exstorob.o
  LD      drivers/ata/built-in.o
  LD      arch/x86/video/built-in.o
  CC      fs/partitions/check.o
  LD      fs/notify/inotify/built-in.o
  LD      fs/notify/built-in.o
  CC      net/socket.o
  CC      drivers/acpi/acpica/exconvrt.o
  CC      drivers/acpi/acpica/exfldio.o
  CC      fs/partitions/msdos.o
  CC      drivers/acpi/acpica/exoparg1.o
  LD      fs/partitions/built-in.o
  CC      fs/proc/mmu.o
  LD      net/802/built-in.o
  CC      net/core/sock.o
  CC      drivers/acpi/acpica/exprep.o
  CC      fs/proc/task_mmu.o
  CC      drivers/acpi/acpica/exresop.o
  CC      drivers/acpi/acpica/exsystem.o
  CC      net/core/request_sock.o
  CC      drivers/acpi/acpica/excreate.o
  CC      fs/proc/inode.o
  CC      drivers/acpi/acpica/exmisc.o
  CC      net/core/skbuff.o
  CC      fs/proc/root.o
  CC      drivers/acpi/acpica/exoparg2.o
  CC      fs/proc/base.o
  CC      drivers/acpi/acpica/exregion.o
  CC      drivers/acpi/acpica/exstore.o
  CC      drivers/acpi/acpica/exutils.o
  CC      fs/proc/generic.o
  CC      drivers/acpi/acpica/exdump.o
  CC      net/core/iovec.o
  CC      drivers/acpi/acpica/exmutex.o
  CC      fs/proc/array.o
  CC      drivers/acpi/acpica/exoparg3.o
  CC      net/core/datagram.o
  CC      fs/proc/proc_tty.o
  CC      drivers/acpi/acpica/exresnte.o
  CC      net/core/stream.o
  CC      fs/proc/cmdline.o
  CC      drivers/acpi/acpica/exstoren.o
  CC      fs/proc/cpuinfo.o
  CC      fs/proc/devices.o
  CC      drivers/acpi/acpica/hwacpi.o
  CC      net/core/scm.o
  CC      fs/proc/interrupts.o
  CC      drivers/acpi/acpica/hwgpe.o
  CC      fs/proc/loadavg.o
  CC      drivers/acpi/acpica/hwregs.o
  CC      net/core/gen_stats.o
  CC      fs/proc/meminfo.o
  CC      drivers/acpi/acpica/hwsleep.o
  CC      net/core/gen_estimator.o
  CC      fs/proc/stat.o
  CC      drivers/acpi/acpica/hwxface.o
  CC      fs/proc/uptime.o
  CC      net/core/net_namespace.o
  CC      drivers/acpi/acpica/nsaccess.o
  CC      fs/proc/version.o
  CC      drivers/acpi/acpica/nsload.o
  CC      fs/proc/proc_sysctl.o
  CC      net/core/sysctl_net_core.o
  CC      drivers/acpi/acpica/nssearch.o
  CC      fs/proc/proc_net.o
  CC      net/core/skb_dma_map.o
  CC      drivers/acpi/acpica/nsxfeval.o
  CC      net/core/dev.o
  CC      fs/proc/kcore.o
  CC      drivers/acpi/acpica/nsalloc.o
  CC      drivers/acpi/acpica/nseval.o
  CC      fs/proc/kmsg.o
  CC      drivers/acpi/acpica/nsnames.o
  CC      fs/proc/page.o
  CC      drivers/acpi/acpica/nsutils.o
  LD      fs/proc/proc.o
  LD      fs/proc/built-in.o
  CC      fs/ramfs/inode.o
  CC      drivers/acpi/acpica/nsxfname.o
  CC      fs/ramfs/file-mmu.o
  CC      drivers/acpi/acpica/nsdump.o
  LD      fs/ramfs/ramfs.o
  LD      fs/ramfs/built-in.o
  CC      fs/sysfs/inode.o
  CC      net/core/ethtool.o
  CC      drivers/acpi/acpica/nsinit.o
  CC      fs/sysfs/file.o
  CC      drivers/acpi/acpica/nsobject.o
  CC      net/core/dev_mcast.o
  CC      fs/sysfs/dir.o
  CC      drivers/acpi/acpica/nswalk.o
  CC      drivers/acpi/acpica/nsxfobj.o
  CC      fs/sysfs/symlink.o
  CC      net/core/dst.o
  CC      drivers/acpi/acpica/nsparse.o
  CC      fs/sysfs/mount.o
  CC      drivers/acpi/acpica/nspredef.o
  CC      net/core/netevent.o
  CC      fs/sysfs/bin.o
  CC      drivers/acpi/acpica/psargs.o
  CC      net/core/neighbour.o
  CC      drivers/acpi/acpica/psparse.o
  CC      fs/sysfs/group.o
  CC      drivers/acpi/acpica/psloop.o
  LD      fs/sysfs/built-in.o
  LD      fs/udf/built-in.o
  CC      fs/eventpoll.o
  CC      drivers/acpi/acpica/pstree.o
  CC      net/core/rtnetlink.o
  CC      drivers/acpi/acpica/pswalk.o
  CC      fs/anon_inodes.o
  CC      drivers/acpi/acpica/psopcode.o
  CC      fs/signalfd.o
  CC      drivers/acpi/acpica/psscope.o
  CC      net/core/utils.o
  CC      fs/timerfd.o
  CC      drivers/acpi/acpica/psutils.o
  CC      drivers/acpi/acpica/psxface.o
  CC      fs/eventfd.o
  CC      net/core/link_watch.o
  CC      drivers/acpi/acpica/rsaddr.o
  CC      fs/aio.o
  CC      drivers/acpi/acpica/rscreate.o
  CC      net/core/filter.o
  CC      drivers/acpi/acpica/rsinfo.o
  CC      drivers/acpi/acpica/rsio.o
  CC      net/core/flow.o
  CC      fs/locks.o
  CC      drivers/acpi/acpica/rslist.o
  CC      net/core/net-sysfs.o
  CC      drivers/acpi/acpica/rsmisc.o
  CC      drivers/acpi/acpica/rsxface.o
  LD      net/core/built-in.o
  CC      fs/nfsctl.o
  CC      net/ethernet/eth.o
  CC      drivers/acpi/acpica/rscalc.o
  CC      fs/binfmt_misc.o
  CC      drivers/acpi/acpica/rsirq.o
  LD      net/ethernet/built-in.o
  CC      net/ipv4/route.o
  CC      drivers/acpi/acpica/rsmemory.o
  CC      drivers/acpi/acpica/rsutils.o
  CC      fs/binfmt_script.o
  CC      fs/binfmt_elf.o
  CC      drivers/acpi/acpica/tbxface.o
  CC      drivers/acpi/acpica/tbinstal.o
  CC      drivers/acpi/acpica/tbutils.o
  CC      fs/posix_acl.o
  CC      drivers/acpi/acpica/tbfind.o
  CC      net/ipv4/inetpeer.o
  CC      fs/xattr_acl.o
  CC      drivers/acpi/acpica/tbfadt.o
  CC      net/ipv4/protocol.o
  CC      fs/generic_acl.o
  CC      drivers/acpi/acpica/tbxfroot.o
  LD      fs/built-in.o
  CC      net/ipv4/ip_input.o
  CC      drivers/acpi/acpica/utalloc.o
  CC      lib/bcd.o
  CC      drivers/acpi/acpica/utdebug.o
  CC      lib/div64.o
  CC      lib/sort.o
  CC      drivers/acpi/acpica/uteval.o
  CC      net/ipv4/ip_fragment.o
  CC      lib/parser.o
  CC      drivers/acpi/acpica/utinit.o
  CC      lib/halfmd4.o
  CC      lib/debug_locks.o
  CC      drivers/acpi/acpica/utmisc.o
  CC      net/ipv4/ip_forward.o
  CC      lib/random32.o
  CC      lib/bust_spinlocks.o
  CC      drivers/acpi/acpica/utxface.o
  CC      net/ipv4/ip_options.o
  CC      drivers/acpi/acpica/utcopy.o
  CC      lib/hexdump.o
  CC      lib/kasprintf.o
  CC      drivers/acpi/acpica/utdelete.o
  CC      lib/bitmap.o
  CC      drivers/acpi/acpica/utglobal.o
  CC      net/ipv4/ip_output.o
  CC      lib/scatterlist.o
  CC      drivers/acpi/acpica/utmath.o
  CC      drivers/acpi/acpica/utobject.o
  CC      lib/string_helpers.o
  CC      drivers/acpi/acpica/utstate.o
  CC      lib/iomap.o
  CC      drivers/acpi/acpica/utmutex.o
  CC      net/ipv4/ip_sockglue.o
  CC      lib/iomap_copy.o
  CC      drivers/acpi/acpica/utresrc.o
  CC      lib/devres.o
  LD      drivers/acpi/acpica/built-in.o
  CC      drivers/acpi/scan.o
  CC      lib/hweight.o
  CC      lib/kernel_lock.o
  CC      net/ipv4/inet_hashtables.o
  CC      lib/plist.o
  CC      lib/bitrev.o
  CC      drivers/acpi/ec.o
  HOSTCC  lib/gen_crc32table
  CC      lib/libcrc32c.o
  CC      net/ipv4/inet_timewait_sock.o
  LD      lib/zlib_deflate/built-in.o
  CC      lib/zlib_inflate/inffast.o
  CC      drivers/acpi/fan.o
  CC      lib/zlib_inflate/inflate.o
  CC      drivers/acpi/dock.o
  CC      net/ipv4/inet_connection_sock.o
  CC      net/ipv4/tcp.o
  CC      drivers/acpi/pci_root.o
  CC      lib/zlib_inflate/infutil.o
  CC      lib/zlib_inflate/inftrees.o
  CC      lib/zlib_inflate/inflate_syms.o
  LD      lib/zlib_inflate/zlib_inflate.o
  LD      lib/zlib_inflate/built-in.o
  CC      lib/percpu_counter.o
  CC      drivers/acpi/pci_link.o
  CC      lib/audit.o
  CC      lib/syscall.o
  CC      drivers/acpi/pci_irq.o
  CC      lib/argv_split.o
  CC      lib/bug.o
  CC      drivers/acpi/pci_bind.o
  CC      net/ipv4/tcp_input.o
  CC      lib/cmdline.o
  CC      lib/cpumask.o
  CC      drivers/acpi/pci_slot.o
  CC      lib/ctype.o
  CC      lib/dec_and_lock.o
  CC      drivers/acpi/processor_core.o
  CC      lib/dump_stack.o
  CC      lib/extable.o
  CC      lib/find_last_bit.o
  CC      drivers/acpi/processor_throttling.o
  CC      lib/find_next_bit.o
  CC      lib/idr.o
  CC      drivers/acpi/processor_idle.o
  CC      lib/int_sqrt.o
  CC      lib/ioremap.o
  CC      lib/irq_regs.o
  CC      drivers/acpi/processor_thermal.o
  CC      net/ipv4/tcp_output.o
  CC      lib/is_single_threaded.o
  CC      drivers/acpi/thermal.o
  CC      lib/klist.o
  CC      lib/kobject.o
  CC      lib/kobject_uevent.o
  CC      drivers/acpi/power.o
  CC      net/ipv4/tcp_timer.o
  CC      drivers/acpi/system.o
  CC      lib/kref.o
  CC      lib/prio_heap.o
  CC      lib/prio_tree.o
  CC      drivers/acpi/event.o
  CC      net/ipv4/tcp_ipv4.o
  CC      lib/proportions.o
  LD      drivers/acpi/processor.o
  LD      drivers/acpi/built-in.o
  LD      drivers/auxdisplay/built-in.o
  CC      drivers/base/core.o
  CC      drivers/base/sys.o
  CC      lib/radix-tree.o
  CC      drivers/base/bus.o
  CC      net/ipv4/tcp_minisocks.o
  CC      lib/ratelimit.o
  CC      drivers/base/dd.o
  CC      lib/rbtree.o
  CC      drivers/base/driver.o
  CC      net/ipv4/tcp_cong.o
  CC      lib/reciprocal_div.o
  CC      drivers/base/class.o
  CC      lib/rwsem.o
  CC      lib/sha1.o
  CC      drivers/base/platform.o
  CC      net/ipv4/datagram.o
  CC      lib/show_mem.o
  CC      lib/string.o
  CC      net/ipv4/raw.o
  CC      drivers/base/cpu.o
  CC      lib/vsprintf.o
  CC      drivers/base/firmware.o
  CC      drivers/base/init.o
  GEN     lib/crc32table.h
  AR      lib/lib.a
  CC      net/ipv4/udp.o
  CC      lib/crc32.o
  CC      drivers/base/map.o
  LD      lib/built-in.o
  CC      drivers/base/devres.o
  LD      drivers/block/built-in.o
  LD      net/key/built-in.o
  CC      arch/x86/lib/msr-on-cpu.o
  CC      drivers/base/attribute_container.o
  AS      arch/x86/lib/checksum_32.o
  CC      arch/x86/lib/delay.o
  CC      drivers/base/transport_class.o
  AS      arch/x86/lib/getuser.o
  CC      arch/x86/lib/memcpy_32.o
  CC      drivers/base/power/sysfs.o
  CC      net/ipv4/udplite.o
  AS      arch/x86/lib/putuser.o
  AS      arch/x86/lib/semaphore_32.o
  LD      drivers/base/power/built-in.o
  CC      drivers/base/dma-mapping.o
  CC      arch/x86/lib/string_32.o
  CC      arch/x86/lib/strstr_32.o
  AS      arch/x86/lib/thunk_32.o
  CC      arch/x86/lib/usercopy_32.o
  CC      drivers/base/firmware_class.o
  CC      net/ipv4/arp.o
  LD      arch/x86/lib/built-in.o
  AR      arch/x86/lib/lib.a
  CC      drivers/base/topology.o
  LD      drivers/cdrom/built-in.o
  CC      drivers/char/mem.o
  CC      drivers/base/module.o
  LD      drivers/base/built-in.o
  CC      net/netlink/af_netlink.o
  CC      drivers/char/random.o
  CC      net/ipv4/icmp.o
  CC      drivers/char/tty_io.o
  CC      net/netlink/attr.o
  CC      net/ipv4/devinet.o
  CC      drivers/char/n_tty.o
  CC      net/netlink/genetlink.o
  CC      net/ipv4/af_inet.o
  LD      net/netlink/built-in.o
  CC      net/ipv4/igmp.o
  CC      drivers/char/tty_ioctl.o
  CC      drivers/char/tty_ldisc.o
  CC      drivers/clocksource/acpi_pm.o
  CC      net/ipv4/fib_frontend.o
  CC      drivers/char/tty_buffer.o
  LD      drivers/clocksource/built-in.o
  CC      net/ipv4/fib_semantics.o
  CC      drivers/char/tty_port.o
  CC      drivers/char/pty.o
  CC      drivers/connector/cn_queue.o
  CC      net/ipv4/inet_fragment.o
  CC      drivers/char/misc.o
  CC      drivers/connector/connector.o
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      drivers/char/vt_ioctl.o
  CC      drivers/connector/cn_proc.o
  CC      net/ipv4/fib_hash.o
  CC      drivers/char/vc_screen.o
  LD      drivers/connector/cn.o
  LD      drivers/connector/built-in.o
  CC      net/ipv4/proc.o
  CC      drivers/char/selection.o
  CC      net/ipv4/tcp_cubic.o
  CC      net/ipv4/xfrm4_policy.o
  CC      drivers/char/keyboard.o
  CC      net/packet/af_packet.o
  CC      net/ipv4/xfrm4_state.o
  CC      drivers/char/consolemap.o
  CC      net/ipv4/xfrm4_input.o
  CONMK   drivers/char/consolemap_deftbl.c
  CC      drivers/char/vt.o
  LD      net/packet/built-in.o
  CC      net/ipv4/xfrm4_output.o
  SHIPPED drivers/char/defkeymap.c
  CC      net/sched/sch_generic.o
  LD      net/ipv4/built-in.o
  CC      drivers/cpuidle/cpuidle.o
  LD      net/sched/built-in.o
  LD      net/sctp/built-in.o
  LD      net/sunrpc/built-in.o
  LD      net/sunrpc/auth_gss/built-in.o
  CC      net/unix/af_unix.o
  CC      drivers/cpuidle/driver.o
  CC      drivers/cpuidle/governor.o
  CC      drivers/cpuidle/sysfs.o
  CC      drivers/char/tty_audit.o
  CC      drivers/cpuidle/governors/ladder.o
  LD      drivers/cpuidle/governors/built-in.o
  LD      drivers/cpuidle/built-in.o
  LD      drivers/crypto/built-in.o
  CC      drivers/char/sysrq.o
  LD      drivers/firewire/built-in.o
  CC      drivers/char/rtc.o
  CC      net/unix/garbage.o
  CC      net/unix/sysctl_net_unix.o
  CC      drivers/char/hpet.o
  CC      drivers/char/nvram.o
  LD      net/unix/unix.o
  LD      net/unix/built-in.o
  LD      net/wireless/built-in.o
  CC      net/xfrm/xfrm_policy.o
  CC      net/xfrm/xfrm_state.o
  LD      drivers/char/agp/built-in.o
  CC      drivers/char/hw_random/core.o
  LD      drivers/char/hw_random/rng-core.o
  LD      drivers/char/hw_random/built-in.o
  LD      drivers/char/ipmi/built-in.o
  CC      drivers/char/consolemap_deftbl.o
  CC      drivers/char/defkeymap.o
  CC      net/xfrm/xfrm_hash.o
  CC      drivers/firmware/dmi_scan.o
  LD      drivers/char/built-in.o
  CC      drivers/firmware/dmi-id.o
  CC      net/xfrm/xfrm_input.o
  CC      drivers/firmware/memmap.o
  CC      net/xfrm/xfrm_output.o
  LD      drivers/firmware/built-in.o
  LD      drivers/gpio/built-in.o
  LD      drivers/gpu/drm/built-in.o
  LD      drivers/gpu/drm/radeon/built-in.o
  LD      drivers/gpu/built-in.o
  CC      drivers/hid/hid-lg.o
  CC      drivers/hid/hid-core.o
  CC      net/xfrm/xfrm_algo.o
  CC      net/xfrm/xfrm_sysctl.o
  CC      drivers/hid/hid-input.o
  LD      drivers/hwmon/built-in.o
  CC      net/xfrm/xfrm_user.o
  CC      drivers/i2c/i2c-boardinfo.o
  LD      drivers/i2c/algos/built-in.o
  LD      drivers/i2c/busses/built-in.o
  LD      drivers/i2c/chips/built-in.o
  LD      drivers/i2c/built-in.o
  CC      net/sysctl_net.o
  CC      drivers/hid/hidraw.o
  LD      drivers/idle/built-in.o
  LD      drivers/ieee1394/built-in.o
  CC      drivers/hid/hid-a4tech.o
  CC      drivers/hid/hid-apple.o
  CC      drivers/input/input.o
  LD      net/xfrm/built-in.o
  LD      net/built-in.o
  CC      drivers/hid/hid-belkin.o
  LD      drivers/input/gameport/built-in.o
  CC      drivers/hid/hid-cherry.o
  CC      drivers/input/serio/serio.o
  CC      drivers/hid/hid-chicony.o
  CC      drivers/hid/hid-cypress.o
  CC      drivers/input/input-compat.o
  CC      drivers/input/serio/i8042.o
  CC      drivers/input/ff-core.o
  CC      drivers/hid/hid-ezkey.o
  CC      drivers/hid/hid-gyration.o
  CC      drivers/input/mousedev.o
  CC      drivers/input/serio/serport.o
  LD      drivers/hid/hid-logitech.o
  CC      drivers/hid/hid-microsoft.o
  CC      drivers/input/serio/libps2.o
  CC      drivers/hid/hid-monterey.o
  CC      drivers/input/keyboard/atkbd.o
  CC      drivers/hid/hid-ntrig.o
  LD      drivers/input/serio/built-in.o
  LD      drivers/input/misc/built-in.o
  CC      drivers/hid/hid-pl.o
  CC      drivers/input/mouse/psmouse-base.o
  CC      drivers/hid/hid-petalynx.o
  LD      drivers/input/keyboard/built-in.o
  CC      drivers/input/mouse/synaptics.o
  CC      drivers/hid/hid-samsung.o
  CC      drivers/hid/hid-sony.o
  LD      drivers/input/input-core.o
  CC      drivers/input/mouse/alps.o
  CC      drivers/input/mouse/logips2pp.o
  CC      drivers/hid/hid-sunplus.o
  CC      drivers/input/mouse/lifebook.o
  CC      drivers/input/mouse/trackpoint.o
  CC      drivers/hid/hid-topseed.o
  LD      drivers/lguest/built-in.o
  CC      drivers/hid/usbhid/hid-core.o
  LD      drivers/macintosh/built-in.o
  LD      drivers/media/common/tuners/built-in.o
  LD      drivers/input/mouse/psmouse.o
  LD      drivers/media/common/built-in.o
  LD      drivers/input/mouse/built-in.o
  LD      drivers/input/built-in.o
  LD      drivers/media/dvb/b2c2/built-in.o
  CC      drivers/hid/usbhid/hid-quirks.o
  LD      drivers/media/dvb/bt8xx/built-in.o
  LD      drivers/media/dvb/dm1105/built-in.o
  LD      drivers/media/dvb/dvb-core/built-in.o
  LD      drivers/media/dvb/dvb-usb/built-in.o
  LD      drivers/media/dvb/frontends/built-in.o
  LD      drivers/media/dvb/pluto2/built-in.o
  LD      drivers/media/dvb/siano/built-in.o
  LD      drivers/media/dvb/ttpci/built-in.o
  LD      drivers/media/dvb/ttusb-budget/built-in.o
  LD      drivers/media/dvb/ttusb-dec/built-in.o
  LD      drivers/media/dvb/built-in.o
  LD      drivers/media/radio/built-in.o
  LD      drivers/media/video/built-in.o
  LD      drivers/media/video/au0828/built-in.o
  LD      drivers/media/video/cx18/built-in.o
  LD      drivers/media/video/cx23885/built-in.o
  LD      drivers/media/video/cx25840/built-in.o
  LD      drivers/media/video/cx88/built-in.o
  LD      drivers/media/video/gspca/built-in.o
  LD      drivers/media/video/ivtv/built-in.o
  LD      drivers/media/video/saa7134/built-in.o
  LD      drivers/message/built-in.o
  LD      drivers/media/built-in.o
  LD      drivers/message/i2o/built-in.o
  CC      drivers/hid/usbhid/hiddev.o
  LD      drivers/mfd/built-in.o
  LD      drivers/misc/built-in.o
  LD      drivers/mmc/card/built-in.o
  LD      drivers/mmc/core/built-in.o
  LD      drivers/mmc/host/built-in.o
  CC      drivers/net/Space.o
  CC      drivers/net/loopback.o
  LD      drivers/net/wireless/built-in.o
  LD      drivers/parport/built-in.o
  CC      drivers/pci/access.o
  LD      drivers/hid/usbhid/usbhid.o
  LD      drivers/hid/usbhid/built-in.o
  LD      drivers/hid/hid.o
  LD      drivers/hid/built-in.o
  LD      drivers/platform/x86/built-in.o
  LD      drivers/platform/built-in.o
  CC      drivers/pnp/core.o
  LD      drivers/net/built-in.o
  CC      drivers/pnp/card.o
  CC      drivers/pci/bus.o
  CC      drivers/power/power_supply_core.o
  CC      drivers/pnp/driver.o
  CC      drivers/pci/probe.o
  CC      drivers/power/power_supply_sysfs.o
  CC      drivers/pnp/resource.o
  LD      drivers/power/power_supply.o
  LD      drivers/power/built-in.o
  CC      drivers/pci/remove.o
  CC      drivers/pci/pci.o
  LD      drivers/scsi/built-in.o
  LD      drivers/scsi/libsas/built-in.o
  CC      drivers/pci/quirks.o
  CC      drivers/pnp/manager.o
  CC      drivers/pnp/support.o
  CC      drivers/pnp/interface.o
  CC      drivers/pci/slot.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/pnp/quirks.o
  CC      drivers/pci/search.o
  CC      drivers/pci/pci-sysfs.o
  CC      drivers/pnp/pnpacpi/core.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  CC      drivers/pnp/system.o
  CC      drivers/pci/rom.o
  CC      drivers/pci/setup-res.o
  CC      drivers/serial/serial_core.o
  LD      drivers/pnp/pnpacpi/built-in.o
  LD      drivers/pnp/built-in.o
  CC      drivers/serial/8250.o
  CC      drivers/pci/irq.o
  CC      drivers/pci/proc.o
  CC      drivers/pci/pcie/aspm.o
  CC      drivers/pci/hotplug.o
drivers/serial/8250.c: In function ‘serial8250_shutdown’:
drivers/serial/8250.c:1681: warning: ‘i’ may be used uninitialized in this 
function
  CC      drivers/serial/8250_pnp.o
  CC      drivers/pci/htirq.o
  CC      drivers/serial/8250_pci.o
  CC      drivers/pci/pcie/portdrv_core.o
  CC      drivers/pci/setup-bus.o
  CC      drivers/pci/pcie/portdrv_pci.o
  CC      drivers/pci/pci-acpi.o
  CC      drivers/serial/8250_early.o
  CC      drivers/pci/pcie/portdrv_bus.o
  LD      drivers/pci/pcie/pcieportdrv.o
  LD      drivers/pci/pcie/built-in.o
  CC      drivers/spi/spi.o
  LD      drivers/pci/built-in.o
  CC      drivers/thermal/thermal_sys.o
  LD      drivers/serial/built-in.o
  LD      drivers/usb/class/built-in.o
  CC      drivers/usb/core/usb.o
  LD      drivers/spi/built-in.o
  CC      drivers/video/fb_notify.o
  LD      drivers/thermal/built-in.o
  LD      drivers/video/aty/built-in.o
  LD      drivers/video/backlight/built-in.o
  CC      drivers/video/console/dummycon.o
  CC      drivers/video/console/vgacon.o
  CC      drivers/usb/core/hub.o
  CC      drivers/video/display/display-sysfs.o
  LD      drivers/video/display/display.o
  LD      drivers/video/display/built-in.o
  CC      drivers/video/logo/logo.o
  LOGO    drivers/video/logo/logo_linux_clut224.c
  LOGO    drivers/video/logo/logo_linux_mono.c
  LOGO    drivers/video/logo/logo_superh_mono.c
  LOGO    drivers/video/logo/clut_vga16.c
  LOGO    drivers/video/logo/logo_blackfin_vga16.c
  LOGO    drivers/video/logo/logo_linux_vga16.c
  LOGO    drivers/video/logo/logo_superh_vga16.c
  LOGO    drivers/video/logo/logo_blackfin_clut224.c
  LOGO    drivers/video/logo/logo_dec_clut224.c
  LOGO    drivers/video/logo/logo_m32r_clut224.c
  LOGO    drivers/video/logo/logo_mac_clut224.c
  LOGO    drivers/video/logo/logo_parisc_clut224.c
  LOGO    drivers/video/logo/logo_sgi_clut224.c
  LOGO    drivers/video/logo/logo_spe_clut224.c
  LOGO    drivers/video/logo/logo_sun_clut224.c
  LOGO    drivers/video/logo/logo_superh_clut224.c
  CC      drivers/video/logo/logo_linux_clut224.o
  LD      drivers/video/console/built-in.o
  LD      drivers/video/logo/built-in.o
  CC      drivers/video/output.o
  CC      drivers/usb/host/pci-quirks.o
  LD      drivers/video/built-in.o
  CC      drivers/usb/core/hcd.o
  CC      drivers/usb/core/urb.o
  LD      drivers/usb/host/built-in.o
  LD      drivers/usb/misc/built-in.o
  CC      drivers/usb/mon/mon_main.o
  CC      drivers/usb/core/message.o
  CC      drivers/usb/mon/mon_stat.o
  CC      drivers/usb/core/driver.o
  CC      drivers/usb/mon/mon_text.o
  CC      drivers/usb/mon/mon_bin.o
  CC      drivers/usb/core/config.o
  CC      drivers/usb/mon/mon_dma.o
  LD      drivers/usb/serial/built-in.o
  LD      drivers/usb/storage/built-in.o
  CC      drivers/usb/core/file.o
  LD      drivers/usb/mon/usbmon.o
  LD      drivers/usb/mon/built-in.o
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
  LD      drivers/usb/built-in.o
  LD      drivers/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
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
  LD      .tmp_vmlinux3
  KSYM    .tmp_kallsyms3.S
  AS      .tmp_kallsyms3.o
  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
  INSTALL include/asm-generic (12 files)
  INSTALL include/drm (12 files)
  INSTALL include/linux/byteorder (2 files)
  INSTALL include/linux/can (3 files)
  INSTALL include/linux/dvb (8 files)
  INSTALL include/mtd (6 files)
  INSTALL include/linux/hdlc (1 file)
  INSTALL include/linux/isdn (1 file)
  INSTALL include/linux/netfilter (49 files)
  INSTALL include/linux/netfilter_arp (2 files)
  INSTALL include/linux/netfilter_bridge (16 files)
  INSTALL include/rdma (1 file)
  INSTALL include/sound (9 files)
  INSTALL include/video (3 files)
  INSTALL include (0 file)
  INSTALL include/linux/netfilter_ipv4 (46 files)
  INSTALL include/linux/netfilter_ipv6 (20 files)
  INSTALL include/linux/nfsd (6 files)
  INSTALL include/linux/raid (2 files)
  INSTALL include/linux/spi (1 file)
  INSTALL include/linux/sunrpc (1 file)
  INSTALL include/linux/tc_act (6 files)
  INSTALL include/linux/tc_ematch (4 files)
  INSTALL include/linux/usb (8 files)
  INSTALL include/linux/wimax (1 file)
  INSTALL include/linux (348 files)
  INSTALL include/asm (52 files)
  CHECK   include/asm-generic (12 files)
  CHECK   include/drm (12 files)
/usr/src/linux-2.6.29-rc1/usr/include/asm-generic/fcntl.h:127: leaks 
CONFIG_64BIT to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm-generic/fcntl.h:149: leaks 
CONFIG_64BIT to userspace where it is not valid
  CHECK   include/linux/byteorder (2 files)
  CHECK   include/linux/dvb (8 files)
  CHECK   include/linux/can (3 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/audio.h:133: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/dmx.h:27: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/can/bcm.h:29: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/dmx.h:90: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/frontend.h:29: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/frontend.h:76: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/mtd (6 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/net.h:27: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/net.h:31: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/mtd/inftl-user.h:61: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/mtd/jffs2-user.h:20: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/video.h:29: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dvb/video.h:102: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/hdlc (1 files)
  CHECK   include/rdma (1 files)
  CHECK   include/linux/isdn (1 files)
  CHECK   include/sound (9 files)
  CHECK   include/linux/netfilter (49 files)
  CHECK   include/video (3 files)
/usr/src/linux-2.6.29-rc1/usr/include/video/edid.h:4: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/video/sisfb.h:25: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/video/sisfb.h:78: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/video/uvesafb.h:5: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/netfilter_arp (2 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/netfilter/xt_conntrack.h:40: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include (0 files)
/usr/src/linux-2.6.29-rc1/usr/include/sound/hdsp.h:33: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/netfilter_bridge (16 files)
  CHECK   include/linux/netfilter_ipv4 (46 files)
  CHECK   include/linux/netfilter_ipv6 (20 files)
  CHECK   include/linux/nfsd (6 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfsd/export.h:13: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfsd/nfsfh.h:17: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfsd/nfsfh.h:28: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfsd/stats.h:32: leaks CONFIG_NFSD 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfsd/syscall.h:12: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfsd/syscall.h:104: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/raid (2 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/raid/md_p.h:85: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/spi (1 files)
  CHECK   include/linux/sunrpc (1 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/spi/spidev.h:83: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/tc_act (6 files)
  CHECK   include/linux/tc_ematch (4 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_act/tc_gact.h:19: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_act/tc_mirred.h:16: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_ematch/tc_em_cmp.h:8: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_ematch/tc_em_meta.h:18: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/usb (8 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_act/tc_pedit.h:19: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_ematch/tc_em_nbyte.h:8: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/tc_ematch/tc_em_text.h:11: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/usb/cdc.h:50: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/wimax (1 files)
  CHECK   include/linux (348 files)
/usr/src/linux-2.6.29-rc1/usr/include/linux/usb/gadgetfs.h:21: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/acct.h:62: leaks CONFIG_M68K to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/agpgart.h:54: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/aio_abi.h:58: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/atalk.h:15: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/atm_idt77105.h:10: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/atm_idt77105.h:19: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/atmbr2684.h:88: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/atmdev.h:103: leaks CONFIG_COMPAT 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/auto_fs4.h:132: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/bfs_fs.h:24: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/blktrace_api.h:96: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/capability.h:72: leaks 
CONFIG_SECURITY to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/capability.h:73: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/capi.h:15: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/capi.h:24: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/cdrom.h:155: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/cgroupstats.h:31: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/cm4000_cs.h:22: leaks 
CONFIG_COMPAT to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/coda_psdev.h:90: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/connector.h:25: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/connector.h:57: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/cyclades.h:153: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dlm_plock.h:25: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/dn.h:75: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/edd.h:70: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/efs_fs_sb.h:49: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/elf-fdpic.h:61: leaks CONFIG_MMU 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/elf-fdpic.h:62: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/elf.h:379: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/elf.h:387: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/elf.h:401: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/elf.h:402: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/elfcore.h:59: leaks CONFIG_BINFMT 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/errqueue.h:6: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/fb.h:4: include of <linux/types.h> 
is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/fb.h:152: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/fb.h:381: leaks CONFIG_FB to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/flat.h:16: leaks CONFIG_BINFMT to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/genetlink.h:12: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/gfs2_ondisk.h:109: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/hid.h:66: leaks CONFIG_HID to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/hid.h:69: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/hid.h:76: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/hiddev.h:40: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/icmpv6.h:8: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_addr.h:8: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_addrlabel.h:15: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_fc.h:37: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_frad.h:29: leaks CONFIG_DLCI to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_frad.h:129: leaks CONFIG_DLCI 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_hippi.h:82: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_link.h:9: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_ppp.h:96: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_pppol2tp.h:18: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_pppol2tp.h:32: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_pppox.h:20: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_pppox.h:105: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_strip.h:22: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/if_tr.h:37: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/igmp.h:31: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/in6.h:47: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/in6.h:49: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/inet_diag.h:16: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/input.h:15: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/input.h:23: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/ip6_tunnel.h:21: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/ipv6.h:26: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/ipv6_route.h:42: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/ipx.h:13: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/irda.h:127: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/joystick.h:30: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/joystick.h:48: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/kernel.h:39: leaks CONFIG_NUMA to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kernel.h:40: leaks CONFIG_NUMA to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kernel.h:46: leaks CONFIG_FTRACE 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kernel.h:47: leaks CONFIG_FTRACE 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:10: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:19: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:61: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:64: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:387: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:391: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/kvm.h:396: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/loop.h:27: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/loop.h:27: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/matroxfb.h:5: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/matroxfb.h:9: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/minix_fs.h:34: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/msdos_fs.h:100: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/neighbour.h:8: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nfs_idmap.h:55: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nubus.h:232: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/nubus.h:296: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/nubus.h:298: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/nubus.h:302: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/phantom.h:13: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/phantom.h:17: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/phonet.h:50: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/pkt_cls.h:122: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/pkt_cls.h:306: leaks CONFIG_NET to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/pkt_cls.h:307: leaks CONFIG_NET to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/pkt_sched.h:32: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/pktcdvd.h:36: leaks CONFIG_CDROM 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/ppp_defs.h:50: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/radeonfb.h:5: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/random.h:39: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/raw.h:16: leaks CONFIG_MAX to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:64: leaks 
CONFIG_REISERFS to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:81: leaks 
CONFIG_REISERFS to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:687: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:995: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:997: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1467: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1587: leaks 
CONFIG_QUOTA to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1760: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1764: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1766: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1769: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1771: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1805: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1908: leaks 
CONFIG_PROC to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1948: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1949: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1950: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1951: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1962: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1963: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/reiserfs_fs.h:1964: extern's make 
no sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/rtnetlink.h:328: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/signalfd.h:19: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/socket.h:27: leaks CONFIG_PROC to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/socket.h:29: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/socket.h:262: leaks CONFIG_COMPAT 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:33: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:34: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:35: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:36: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:37: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:39: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:40: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:41: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/sound.h:42: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1047: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1048: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1049: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1050: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1051: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1053: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1055: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1056: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1061: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1062: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1078: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/soundcard.h:1079: extern's make no 
sense in userspace
/usr/src/linux-2.6.29-rc1/usr/include/linux/synclink.h:209: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/taskstats.h:44: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/types.h:114: leaks CONFIG_LBD to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/video_decoder.h:7: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/video_encoder.h:5: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/videodev.h:18: leaks CONFIG_VIDEO 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/videodev.h:53: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/videodev.h:313: leaks CONFIG_VIDEO 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/videodev2.h:1477: leaks 
CONFIG_VIDEO to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/linux/virtio_blk.h:21: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/virtio_console.h:15: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/linux/virtio_net.h:28: found __[us]
{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/asm (52 files)
/usr/src/linux-2.6.29-rc1/usr/include/asm/boot.h:14: leaks CONFIG_PHYSICAL to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/boot.h:15: leaks CONFIG_PHYSICAL to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/boot.h:16: leaks CONFIG_PHYSICAL to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/boot.h:18: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/e820.h:13: leaks CONFIG_NODES to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/e820.h:27: leaks CONFIG_EFI to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/e820.h:44: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/kvm.h:9: include of <linux/types.h> 
is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/kvm.h:16: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/mce.h:7: include of <linux/types.h> 
is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/mce.h:29: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/prctl.h:9: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/prctl.h:10: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/prctl.h:11: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/ptrace-abi.h:83: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/ptrace-abi.h:86: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/ptrace-abi.h:93: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/ptrace-abi.h:143: leaks CONFIG_X86 
to userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:15: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:16: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:17: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:23: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:24: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:51: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:52: extern's make no sense 
in userspace
/usr/src/linux-2.6.29-rc1/usr/include/asm/setup.h:54: leaks CONFIG_PARAVIRT to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/sigcontext.h:5: include of 
<linux/types.h> is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/sigcontext.h:24: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/sigcontext32.h:20: found __[us]
{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/swab.h:4: include of <linux/types.h> 
is preferred over <asm/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/swab.h:7: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/usr/src/linux-2.6.29-rc1/usr/include/asm/swab.h:10: leaks CONFIG_X86 to 
userspace where it is not valid
/usr/src/linux-2.6.29-rc1/usr/include/asm/swab.h:40: leaks CONFIG_X86 to 
userspace where it is not valid
  LD      Documentation/accounting/built-in.o
  LD      Documentation/auxdisplay/built-in.o
  HOSTCC  Documentation/auxdisplay/cfag12864b-example
  LD      Documentation/DocBook/built-in.o
  HOSTCC  Documentation/accounting/getdelays
  LD      Documentation/connector/built-in.o
  HOSTCC  Documentation/connector/ucon
  LD      Documentation/filesystems/configfs/built-in.o
  LD      Documentation/ia64/built-in.o
  HOSTCC  Documentation/ia64/aliasing-test
Documentation/accounting/getdelays.c: In function ‘main’:
Documentation/accounting/getdelays.c:249: warning: ‘cmd_type’ may be used 
uninitialized in this function
  LD      Documentation/networking/built-in.o
  HOSTCC  Documentation/networking/ifenslave
  LD      Documentation/pcmcia/built-in.o
  HOSTCC  Documentation/pcmcia/crc32hash
  LD      Documentation/spi/built-in.o
  HOSTCC  Documentation/spi/spidev_test
  LD      Documentation/video4linux/built-in.o
  HOSTCC  Documentation/video4linux/v4lgrab
  HOSTCC  Documentation/spi/spidev_fdx
Documentation/spi/spidev_fdx.c: In function ‘do_msg’:
Documentation/spi/spidev_fdx.c:61: warning: cast from pointer to integer of 
different size
Documentation/spi/spidev_fdx.c:64: warning: cast from pointer to integer of 
different size
Documentation/video4linux/v4lgrab.c: In function ‘main’:
Documentation/video4linux/v4lgrab.c:184: warning: ‘src_depth’ is used 
uninitialized in this function
Documentation/video4linux/v4lgrab.c:99: warning: ‘b’ may be used uninitialized 
in this function
Documentation/video4linux/v4lgrab.c:99: warning: ‘g’ may be used uninitialized 
in this function
Documentation/video4linux/v4lgrab.c:99: warning: ‘r’ may be used uninitialized 
in this function
  LD      Documentation/vm/built-in.o
  HOSTCC  Documentation/vm/slabinfo
  LD      Documentation/watchdog/src/built-in.o
  HOSTCC  Documentation/watchdog/src/watchdog-simple
  HOSTCC  Documentation/watchdog/src/watchdog-test
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  CC      arch/x86/boot/a20.o
  CC      arch/x86/boot/cmdline.o
  AS      arch/x86/boot/copy.o
  HOSTCC  arch/x86/boot/mkcpustr
  CC      arch/x86/boot/cpucheck.o
  CC      arch/x86/boot/edd.o
  AS      arch/x86/boot/compressed/head_32.o
  CC      arch/x86/boot/compressed/misc.o
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  CC      arch/x86/boot/main.o
  CC      arch/x86/boot/mca.o
  CC      arch/x86/boot/memory.o
  CC      arch/x86/boot/pm.o
  AS      arch/x86/boot/pmjump.o
  CC      arch/x86/boot/printf.o
  CC      arch/x86/boot/string.o
  CC      arch/x86/boot/tty.o
  CC      arch/x86/boot/video.o
  CC      arch/x86/boot/video-mode.o
  CC      arch/x86/boot/version.o
  CC      arch/x86/boot/video-vga.o
  CC      arch/x86/boot/video-vesa.o
  CC      arch/x86/boot/video-bios.o
  HOSTCC  arch/x86/boot/tools/build
  CPUSTR  arch/x86/boot/cpustr.h
  CC      arch/x86/boot/cpu.o
  LD      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  OFFSETS arch/x86/boot/offsets.h
  OBJCOPY arch/x86/boot/vmlinux.bin
  AS      arch/x86/boot/header.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  BUILD   arch/x86/boot/bzImage
Root device is (8, 19)
Setup is 12184 bytes (padded to 12288 bytes).
System is 1588 kB
CRC 651085bb
Kernel: arch/x86/boot/bzImage is ready  (#1)


Now making modules


  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  AS [M]  arch/x86/crypto/aes-i586-asm_32.o
  CC [M]  arch/x86/crypto/aes_glue.o
  AS [M]  arch/x86/crypto/twofish-i586-asm_32.o
  CC [M]  arch/x86/crypto/twofish_glue.o
  LD [M]  arch/x86/crypto/aes-i586.o
  LD [M]  arch/x86/crypto/twofish-i586.o
  CC [M]  fs/mbcache.o
  CC [M]  fs/autofs4/init.o
  CC [M]  fs/cifs/cifsfs.o
  CC [M]  fs/autofs4/inode.o
  CC [M]  fs/cifs/cifssmb.o
  CC [M]  fs/autofs4/root.o
  CC [M]  fs/cifs/cifs_debug.o
  CC [M]  fs/autofs4/symlink.o
  CC [M]  fs/autofs4/waitq.o
  CC [M]  crypto/xcbc.o
  CC [M]  fs/autofs4/expire.o
  CC [M]  fs/autofs4/dev-ioctl.o
  CC [M]  crypto/crypto_null.o
  CC [M]  crypto/md4.o
  LD [M]  fs/autofs4/autofs4.o
  CC [M]  crypto/sha256_generic.o
  CC [M]  fs/cifs/connect.o
  CC [M]  crypto/sha512_generic.o
  CC [M]  crypto/wp512.o
  CC [M]  crypto/tgr192.o
  CC [M]  crypto/gf128mul.o
  CC [M]  fs/cifs/dir.o
  CC [M]  crypto/ecb.o
  CC [M]  crypto/cbc.o
  CC [M]  crypto/pcbc.o
  CC [M]  fs/cifs/file.o
  CC [M]  crypto/lrw.o
  CC [M]  crypto/des_generic.o
  CC [M]  fs/configfs/inode.o
  CC [M]  crypto/fcrypt.o
  CC [M]  fs/cifs/inode.o
  CC [M]  fs/configfs/file.o
  CC [M]  fs/configfs/dir.o
  CC [M]  crypto/blowfish.o
  CC [M]  crypto/twofish.o
  CC [M]  fs/configfs/symlink.o
  CC [M]  fs/cifs/link.o
  CC [M]  crypto/twofish_common.o
  CC [M]  fs/configfs/mount.o
  CC [M]  fs/cifs/misc.o
  CC [M]  crypto/serpent.o
  CC [M]  fs/configfs/item.o
  LD [M]  fs/configfs/configfs.o
  CC [M]  crypto/aes_generic.o
  CC [M]  fs/cifs/netmisc.o
  CC [M]  crypto/camellia.o
  CC [M]  fs/cifs/smbdes.o
  CC [M]  fs/cifs/smbencrypt.o
  CC [M]  drivers/acpi/button.o
  CC [M]  fs/cifs/transport.o
  CC [M]  crypto/cast5.o
  CC [M]  drivers/ata/libata-core.o
  CC [M]  crypto/cast6.o
  CC [M]  fs/cifs/asn1.o
  CC [M]  crypto/arc4.o
  CC [M]  crypto/tea.o
  CC [M]  fs/cifs/md4.o
  CC [M]  crypto/khazad.o
  CC [M]  fs/cifs/md5.o
  CC [M]  crypto/anubis.o
  CC [M]  fs/cifs/cifs_unicode.o
  CC [M]  crypto/deflate.o
  CC [M]  drivers/ata/libata-scsi.o
  CC [M]  fs/cifs/nterr.o
  CC [M]  crypto/michael_mic.o
  CC [M]  fs/cifs/xattr.o
  CC [M]  crypto/authenc.o
  CC [M]  fs/cifs/cifsencrypt.o
  CC [M]  crypto/tcrypt.o
  CC [M]  drivers/ata/libata-eh.o
  CC [M]  fs/cifs/readdir.o
  CC [M]  fs/cifs/ioctl.o
  CC [M]  fs/cifs/sess.o
  CC [M]  fs/cifs/export.o
  CC [M]  drivers/ata/libata-sff.o
  CC [M]  fs/cifs/cifsacl.o
  CC [M]  drivers/block/floppy.o
  LD [M]  fs/cifs/cifs.o
  CC [M]  fs/dlm/ast.o
  CC [M]  drivers/ata/libata-pmp.o
  CC [M]  fs/dlm/config.o
  CC [M]  drivers/ata/libata-acpi.o
  CC [M]  fs/dlm/dir.o
  CC [M]  drivers/ata/ahci.o
  CC [M]  fs/dlm/lock.o
  CC [M]  drivers/block/loop.o
  CC [M]  drivers/ata/sata_sil.o
  CC [M]  drivers/block/pktcdvd.o
  CC [M]  drivers/ata/sata_nv.o
  CC [M]  fs/dlm/lockspace.o
  CC [M]  fs/dlm/main.o
  CC [M]  drivers/block/nbd.o
  CC [M]  fs/dlm/member.o
  CC [M]  drivers/ata/pata_amd.o
  CC [M]  fs/dlm/memory.o
  CC [M]  drivers/block/cryptoloop.o
  CC [M]  fs/dlm/midcomms.o
  CC [M]  drivers/ata/pata_jmicron.o
  CC [M]  fs/dlm/netlink.o
  CC [M]  fs/dlm/lowcomms.o
  CC [M]  drivers/ata/pata_sil680.o
  CC [M]  drivers/ata/pata_acpi.o
  CC [M]  fs/dlm/plock.o
  CC [M]  drivers/ata/ata_generic.o
  LD [M]  drivers/ata/libata.o
  CC [M]  fs/dlm/rcom.o
  CC [M]  fs/dlm/recover.o
  CC [M]  drivers/cdrom/cdrom.o
  CC [M]  fs/dlm/recoverd.o
  CC [M]  fs/dlm/requestqueue.o
  CC [M]  fs/dlm/user.o
  CC [M]  fs/exportfs/expfs.o
  LD [M]  fs/exportfs/exportfs.o
  CC [M]  fs/dlm/util.o
  CC [M]  sound/sound_core.o
  LD [M]  fs/dlm/dlm.o
  CC [M]  fs/ext2/balloc.o
  CC [M]  drivers/char/agp/backend.o
  CC [M]  sound/ac97_bus.o
  CC [M]  sound/core/hwdep.o
  CC [M]  drivers/char/agp/frontend.o
  CC [M]  fs/ext2/dir.o
  CC [M]  sound/core/memalloc.o
  CC [M]  drivers/char/agp/generic.o
  CC [M]  fs/ext2/file.o
  CC [M]  sound/core/sgbuf.o
  CC [M]  fs/ext2/fsync.o
  CC [M]  sound/core/pcm.o
  CC [M]  fs/ext2/ialloc.o
  CC [M]  drivers/char/agp/isoch.o
  CC [M]  drivers/char/agp/ati-agp.o
  CC [M]  fs/ext2/inode.o
  CC [M]  sound/core/pcm_native.o
  CC [M]  drivers/char/agp/amd-k7-agp.o
  CC [M]  fs/ext2/ioctl.o
  CC [M]  drivers/char/agp/amd64-agp.o
  CC [M]  fs/ext2/namei.o
  CC [M]  drivers/char/agp/nvidia-agp.o
  CC [M]  sound/core/pcm_lib.o
  CC [M]  fs/ext2/super.o
  CC [M]  drivers/char/agp/via-agp.o
  LD [M]  drivers/char/agp/agpgart.o
  CC [M]  drivers/char/hw_random/amd-rng.o
  CC [M]  fs/ext2/symlink.o
  CC [M]  drivers/char/ipmi/ipmi_msghandler.o
  CC [M]  fs/ext2/xattr.o
  CC [M]  sound/core/pcm_timer.o
  CC [M]  sound/core/pcm_misc.o
  CC [M]  fs/ext2/xattr_user.o
  CC [M]  drivers/char/ipmi/ipmi_devintf.o
  CC [M]  fs/ext2/xattr_trusted.o
  CC [M]  sound/core/pcm_memory.o
  CC [M]  fs/ext2/acl.o
  CC [M]  drivers/char/ipmi/ipmi_si_intf.o
  CC [M]  sound/core/rawmidi.o
  CC [M]  fs/ext2/xattr_security.o
  CC [M]  fs/ext2/xip.o
  CC [M]  drivers/char/ipmi/ipmi_kcs_sm.o
  LD [M]  fs/ext2/ext2.o
  CC [M]  fs/ext3/balloc.o
  CC [M]  sound/core/rtctimer.o
  CC [M]  drivers/char/ipmi/ipmi_smic_sm.o
  CC [M]  sound/core/timer.o
  CC [M]  drivers/char/ipmi/ipmi_bt_sm.o
  CC [M]  fs/ext3/bitmap.o
  CC [M]  drivers/char/ipmi/ipmi_watchdog.o
  CC [M]  fs/ext3/dir.o
  CC [M]  sound/core/sound.o
  CC [M]  drivers/char/ipmi/ipmi_poweroff.o
  CC [M]  fs/ext3/file.o
  CC [M]  sound/core/init.o
  CC [M]  fs/ext3/fsync.o
  LD [M]  drivers/char/ipmi/ipmi_si.o
  CC [M]  drivers/firewire/fw-card.o
  CC [M]  fs/ext3/ialloc.o
  CC [M]  sound/core/memory.o
  CC [M]  drivers/firewire/fw-topology.o
  CC [M]  sound/core/info.o
  CC [M]  fs/ext3/inode.o
  CC [M]  drivers/firewire/fw-transaction.o
  CC [M]  sound/core/control.o
  CC [M]  drivers/firewire/fw-iso.o
  CC [M]  drivers/firewire/fw-device.o
  CC [M]  sound/core/misc.o
  CC [M]  fs/ext3/ioctl.o
  CC [M]  sound/core/device.o
  CC [M]  drivers/firewire/fw-cdev.o
  CC [M]  fs/ext3/namei.o
  CC [M]  drivers/firewire/fw-ohci.o
  CC [M]  sound/core/isadma.o
  CC [M]  fs/ext3/super.o
  CC [M]  sound/core/sound_oss.o
  CC [M]  sound/core/info_oss.o
  CC [M]  sound/core/vmaster.o
  CC [M]  drivers/firewire/fw-sbp2.o
  CC [M]  fs/ext3/symlink.o
  CC [M]  sound/core/jack.o
  CC [M]  fs/ext3/hash.o
  CC [M]  sound/core/oss/mixer_oss.o
  CC [M]  fs/ext3/resize.o
  LD [M]  drivers/firewire/firewire-core.o
  LD [M]  drivers/firewire/firewire-ohci.o
  LD [M]  drivers/firewire/firewire-sbp2.o
  CC [M]  drivers/firmware/edd.o
  CC [M]  sound/core/oss/pcm_oss.o
  CC [M]  fs/ext3/ext3_jbd.o
  CC [M]  drivers/gpu/drm/drm_auth.o
  CC [M]  fs/ext3/xattr.o
  CC [M]  drivers/gpu/drm/drm_bufs.o
  CC [M]  sound/core/oss/pcm_plugin.o
  CC [M]  fs/ext3/xattr_user.o
  CC [M]  fs/ext3/xattr_trusted.o
  CC [M]  drivers/gpu/drm/drm_cache.o
  CC [M]  sound/core/oss/io.o
  CC [M]  fs/ext3/acl.o
  CC [M]  drivers/gpu/drm/drm_context.o
  CC [M]  sound/core/oss/copy.o
  CC [M]  fs/ext3/xattr_security.o
  CC [M]  sound/core/oss/linear.o
  CC [M]  drivers/gpu/drm/drm_dma.o
  LD [M]  fs/ext3/ext3.o
  CC [M]  fs/fat/cache.o
  CC [M]  sound/core/oss/mulaw.o
  CC [M]  drivers/gpu/drm/drm_drawable.o
  CC [M]  fs/fat/dir.o
  CC [M]  sound/core/oss/route.o
  CC [M]  drivers/gpu/drm/drm_drv.o
  CC [M]  sound/core/oss/rate.o
  LD [M]  sound/core/oss/snd-mixer-oss.o
  LD [M]  sound/core/oss/snd-pcm-oss.o
  CC [M]  sound/core/seq/seq_device.o
  CC [M]  drivers/gpu/drm/drm_fops.o
  CC [M]  fs/fat/fatent.o
  CC [M]  drivers/gpu/drm/drm_gem.o
  CC [M]  sound/core/seq/seq_dummy.o
  CC [M]  fs/fat/file.o
  CC [M]  drivers/gpu/drm/drm_ioctl.o
  CC [M]  sound/core/seq/seq_midi_emul.o
  CC [M]  fs/fat/inode.o
  CC [M]  sound/core/seq/seq_midi_event.o
  CC [M]  drivers/gpu/drm/drm_irq.o
  CC [M]  sound/core/seq/seq_midi.o
  CC [M]  fs/fat/misc.o
  CC [M]  drivers/gpu/drm/drm_lock.o
  CC [M]  sound/core/seq/seq_virmidi.o
  CC [M]  fs/fat/namei_msdos.o
  CC [M]  drivers/gpu/drm/drm_memory.o
  CC [M]  sound/core/seq/seq.o
  CC [M]  sound/core/seq/seq_lock.o
  CC [M]  fs/fat/namei_vfat.o
  CC [M]  drivers/gpu/drm/drm_proc.o
  CC [M]  sound/core/seq/seq_clientmgr.o
  CC [M]  drivers/gpu/drm/drm_stub.o
  LD [M]  fs/fat/fat.o
  LD [M]  fs/fat/vfat.o
  LD [M]  fs/fat/msdos.o
  CC [M]  fs/fuse/dev.o
  CC [M]  drivers/gpu/drm/drm_vm.o
  CC [M]  sound/core/seq/seq_memory.o
  CC [M]  fs/fuse/dir.o
  CC [M]  sound/core/seq/seq_queue.o
  CC [M]  drivers/gpu/drm/drm_agpsupport.o
  CC [M]  sound/core/seq/seq_fifo.o
  CC [M]  drivers/gpu/drm/drm_scatter.o
  CC [M]  fs/fuse/file.o
  CC [M]  sound/core/seq/seq_prioq.o
  CC [M]  drivers/gpu/drm/ati_pcigart.o
  CC [M]  sound/core/seq/seq_timer.o
  CC [M]  drivers/gpu/drm/drm_pci.o
  CC [M]  sound/core/seq/seq_system.o
  CC [M]  fs/fuse/inode.o
  CC [M]  drivers/gpu/drm/drm_sysfs.o
  CC [M]  drivers/gpu/drm/drm_hashtab.o
  CC [M]  sound/core/seq/seq_ports.o
  CC [M]  fs/fuse/control.o
  CC [M]  sound/core/seq/seq_info.o
  CC [M]  drivers/gpu/drm/drm_sman.o
  LD [M]  fs/fuse/fuse.o
  CC [M]  fs/jbd/transaction.o
  CC [M]  sound/core/seq/oss/seq_oss.o
  CC [M]  drivers/gpu/drm/drm_mm.o
  CC [M]  sound/core/seq/oss/seq_oss_init.o
  CC [M]  drivers/gpu/drm/drm_crtc.o
  CC [M]  sound/core/seq/oss/seq_oss_timer.o
  CC [M]  fs/jbd/commit.o
  CC [M]  sound/core/seq/oss/seq_oss_ioctl.o
  CC [M]  fs/jbd/recovery.o
  CC [M]  sound/core/seq/oss/seq_oss_event.o
  CC [M]  drivers/gpu/drm/drm_crtc_helper.o
  CC [M]  fs/jbd/checkpoint.o
  CC [M]  sound/core/seq/oss/seq_oss_rw.o
  CC [M]  drivers/gpu/drm/drm_modes.o
  CC [M]  sound/core/seq/oss/seq_oss_synth.o
  CC [M]  fs/jbd/revoke.o
  CC [M]  sound/core/seq/oss/seq_oss_midi.o
  CC [M]  drivers/gpu/drm/drm_edid.o
  CC [M]  fs/jbd/journal.o
  CC [M]  sound/core/seq/oss/seq_oss_readq.o
  CC [M]  drivers/gpu/drm/radeon/radeon_drv.o
  CC [M]  drivers/gpu/drm/radeon/radeon_cp.o
  LD [M]  fs/jbd/jbd.o
  CC [M]  sound/core/seq/oss/seq_oss_writeq.o
  CC [M]  fs/lockd/clntlock.o
  LD [M]  sound/core/seq/oss/snd-seq-oss.o
  LD [M]  sound/core/seq/snd-seq.o
  LD [M]  sound/core/seq/snd-seq-device.o
  LD [M]  sound/core/seq/snd-seq-midi-event.o
  LD [M]  sound/core/seq/snd-seq-dummy.o
  LD [M]  sound/core/seq/snd-seq-virmidi.o
  LD [M]  sound/core/seq/snd-seq-midi.o
  LD [M]  sound/core/seq/snd-seq-midi-emul.o
  LD [M]  sound/core/snd.o
  LD [M]  sound/core/snd-hwdep.o
  LD [M]  sound/core/snd-timer.o
  LD [M]  sound/core/snd-rtctimer.o
  LD [M]  sound/core/snd-pcm.o
  LD [M]  sound/core/snd-page-alloc.o
  LD [M]  sound/core/snd-rawmidi.o
  CC [M]  sound/drivers/dummy.o
  CC [M]  fs/lockd/clntproc.o
  CC [M]  drivers/gpu/drm/radeon/radeon_state.o
  CC [M]  sound/drivers/serial-u16550.o
  CC [M]  fs/lockd/host.o
  CC [M]  sound/drivers/virmidi.o
  CC [M]  sound/drivers/mpu401/mpu401_uart.o
  CC [M]  fs/lockd/svc.o
  CC [M]  sound/drivers/mpu401/mpu401.o
  LD [M]  sound/drivers/mpu401/snd-mpu401-uart.o
  LD [M]  sound/drivers/mpu401/snd-mpu401.o
  CC [M]  sound/drivers/opl3/opl3_lib.o
  CC [M]  fs/lockd/svclock.o
  CC [M]  sound/drivers/opl3/opl3_synth.o
  CC [M]  fs/lockd/svcshare.o
  CC [M]  sound/drivers/opl3/opl3_seq.o
  CC [M]  drivers/gpu/drm/radeon/radeon_mem.o
  CC [M]  sound/drivers/opl3/opl3_midi.o
  CC [M]  fs/lockd/svcproc.o
  CC [M]  drivers/gpu/drm/radeon/radeon_irq.o
  CC [M]  sound/drivers/opl3/opl3_drums.o
  CC [M]  sound/drivers/opl3/opl3_oss.o
  CC [M]  fs/lockd/svcsubs.o
  CC [M]  drivers/gpu/drm/radeon/r300_cmdbuf.o
  LD [M]  sound/drivers/opl3/snd-opl3-lib.o
  LD [M]  sound/drivers/opl3/snd-opl3-synth.o
  LD [M]  sound/drivers/snd-dummy.o
  LD [M]  sound/drivers/snd-virmidi.o
  LD [M]  sound/drivers/snd-serial-u16550.o
  CC [M]  fs/lockd/mon.o
  CC [M]  sound/pci/atiixp.o
  CC [M]  fs/lockd/xdr.o
  CC [M]  sound/pci/bt87x.o
  CC [M]  sound/pci/intel8x0.o
  LD [M]  drivers/gpu/drm/radeon/radeon.o
  LD [M]  drivers/gpu/drm/drm.o
  CC [M]  drivers/hid/hid-dummy.o
  CC [M]  drivers/hwmon/hwmon.o
  CC [M]  fs/lockd/grace.o
  CC [M]  drivers/hwmon/hwmon-vid.o
  CC [M]  drivers/hwmon/w83627hf.o
  CC [M]  fs/lockd/xdr4.o
  CC [M]  sound/pci/ac97/ac97_codec.o
  CC [M]  fs/lockd/svc4proc.o
  CC [M]  drivers/hwmon/it87.o
  LD [M]  fs/lockd/lockd.o
  CC [M]  fs/nfs/client.o
  CC [M]  drivers/i2c/i2c-core.o
  CC [M]  sound/pci/ac97/ac97_pcm.o
  CC [M]  drivers/i2c/i2c-dev.o
  CC [M]  fs/nfs/dir.o
  CC [M]  sound/pci/ac97/ac97_proc.o
  CC [M]  drivers/i2c/algos/i2c-algo-bit.o
  LD [M]  sound/pci/ac97/snd-ac97-codec.o
  CC [M]  sound/pci/emu10k1/emu10k1_synth.o
  CC [M]  drivers/i2c/busses/i2c-amd756.o
  CC [M]  sound/pci/emu10k1/emu10k1_callback.o
  CC [M]  fs/nfs/file.o
  CC [M]  drivers/i2c/busses/i2c-nforce2.o
  CC [M]  sound/pci/emu10k1/emu10k1_patch.o
  CC [M]  fs/nfs/getroot.o
  CC [M]  drivers/i2c/chips/eeprom.o
  CC [M]  sound/pci/emu10k1/emu10k1.o
  CC [M]  drivers/input/joydev.o
  CC [M]  fs/nfs/inode.o
  CC [M]  sound/pci/emu10k1/emu10k1_main.o
  CC [M]  drivers/input/evdev.o
  CC [M]  fs/nfs/super.o
  CC [M]  drivers/input/misc/pcspkr.o
  CC [M]  sound/pci/emu10k1/irq.o
  CC [M]  drivers/input/gameport/gameport.o
  CC [M]  sound/pci/emu10k1/memory.o
  CC [M]  fs/nfs/nfs2xdr.o
  CC [M]  drivers/input/gameport/emu10k1-gp.o
  CC [M]  sound/pci/emu10k1/voice.o
  CC [M]  drivers/input/gameport/ns558.o
  CC [M]  fs/nfs/direct.o
  CC [M]  sound/pci/emu10k1/emumpu401.o
  CC [M]  drivers/media/common/ir-functions.o
  CC [M]  sound/pci/emu10k1/emupcm.o
  CC [M]  drivers/media/common/ir-keymaps.o
  CC [M]  fs/nfs/pagelist.o
  CC [M]  drivers/media/common/saa7146_i2c.o
  CC [M]  fs/nfs/proc.o
  CC [M]  drivers/media/common/saa7146_core.o
  CC [M]  sound/pci/emu10k1/io.o
  CC [M]  fs/nfs/read.o
  CC [M]  drivers/media/common/saa7146_fops.o
  CC [M]  sound/pci/emu10k1/emuproc.o
  CC [M]  fs/nfs/symlink.o
  CC [M]  sound/pci/emu10k1/emumixer.o
  CC [M]  drivers/media/common/saa7146_video.o
  CC [M]  fs/nfs/unlink.o
  CC [M]  fs/nfs/write.o
  CC [M]  sound/pci/emu10k1/emufx.o
  CC [M]  drivers/media/common/saa7146_hlp.o
  CC [M]  drivers/media/common/saa7146_vbi.o
  CC [M]  fs/nfs/namespace.o
  CC [M]  fs/nfs/mount_clnt.o
  CC [M]  drivers/media/common/tuners/tuner-xc2028.o
  CC [M]  sound/pci/emu10k1/timer.o
  CC [M]  fs/nfs/nfs3proc.o
  CC [M]  sound/pci/emu10k1/p16v.o
  CC [M]  fs/nfs/nfs3xdr.o
  CC [M]  drivers/media/common/tuners/tuner-simple.o
  LD [M]  sound/pci/emu10k1/snd-emu10k1.o
  LD [M]  sound/pci/emu10k1/snd-emu10k1-synth.o
  CC [M]  sound/pci/hda/patch_analog.o
  CC [M]  drivers/media/common/tuners/tuner-types.o
  CC [M]  fs/nfs/nfs3acl.o
  CC [M]  drivers/media/common/tuners/tda8290.o
  CC [M]  fs/nfs/nfs4proc.o
  CC [M]  sound/pci/hda/patch_atihdmi.o
  CC [M]  drivers/media/common/tuners/tda9887.o
  CC [M]  sound/pci/hda/patch_cmedia.o
  CC [M]  drivers/media/common/tuners/tda827x.o
  CC [M]  sound/pci/hda/patch_conexant.o
  CC [M]  drivers/media/common/tuners/tda18271-maps.o
  CC [M]  sound/pci/hda/patch_sigmatel.o
  CC [M]  fs/nfs/nfs4xdr.o
  CC [M]  drivers/media/common/tuners/tda18271-common.o
  CC [M]  drivers/media/common/tuners/tda18271-fe.o
  CC [M]  sound/pci/hda/patch_intelhdmi.o
  CC [M]  drivers/media/common/tuners/xc5000.o
  CC [M]  sound/pci/hda/hda_eld.o
  CC [M]  drivers/media/common/tuners/mxl5007t.o
  CC [M]  fs/nfs/nfs4state.o
  CC [M]  sound/pci/hda/patch_nvhdmi.o
  LD [M]  drivers/media/common/tuners/tda18271.o
  LD [M]  drivers/media/common/saa7146.o
  LD [M]  drivers/media/common/saa7146_vv.o
  LD [M]  drivers/media/common/ir-common.o
  CC [M]  drivers/media/dvb/dvb-core/dvbdev.o
  CC [M]  sound/pci/hda/patch_realtek.o
  CC [M]  fs/nfs/nfs4renewd.o
  CC [M]  drivers/media/dvb/dvb-core/dmxdev.o
  CC [M]  fs/nfs/delegation.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_demux.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_filter.o
  CC [M]  fs/nfs/idmap.o
  CC [M]  sound/pci/hda/patch_si3054.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_ca_en50221.o
  CC [M]  fs/nfs/callback.o
  CC [M]  sound/pci/hda/patch_via.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_frontend.o
  CC [M]  fs/nfs/callback_xdr.o
  CC [M]  sound/pci/hda/hda_codec.o
  CC [M]  fs/nfs/callback_proc.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_net.o
  CC [M]  fs/nfs/nfs4namespace.o
  CC [M]  fs/nfs/sysctl.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_ringbuffer.o
  LD [M]  fs/nfs/nfs.o
  CC [M]  fs/nfs_common/nfsacl.o
  CC [M]  sound/pci/hda/hda_generic.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_math.o
  LD [M]  fs/nfs_common/nfs_acl.o
  CC [M]  fs/nfsd/nfssvc.o
  LD [M]  drivers/media/dvb/dvb-core/dvb-core.o
  CC [M]  drivers/media/dvb/frontends/dvb-pll.o
  CC [M]  sound/pci/hda/hda_proc.o
  CC [M]  drivers/media/dvb/frontends/s921_module.o
  CC [M]  fs/nfsd/nfsctl.o
  CC [M]  drivers/media/dvb/frontends/s921_core.o
  CC [M]  sound/pci/hda/hda_hwdep.o
  CC [M]  drivers/media/dvb/frontends/stb0899_drv.o
  CC [M]  fs/nfsd/nfsproc.o
  CC [M]  sound/pci/hda/hda_intel.o
  CC [M]  fs/nfsd/nfsfh.o
  CC [M]  drivers/media/dvb/frontends/stb0899_algo.o
  CC [M]  fs/nfsd/vfs.o
  LD [M]  sound/pci/hda/snd-hda-codec.o
  LD [M]  sound/pci/hda/snd-hda-codec-realtek.o
  LD [M]  sound/pci/hda/snd-hda-codec-cmedia.o
  LD [M]  sound/pci/hda/snd-hda-codec-analog.o
  LD [M]  sound/pci/hda/snd-hda-codec-idt.o
  LD [M]  sound/pci/hda/snd-hda-codec-si3054.o
  LD [M]  sound/pci/hda/snd-hda-codec-atihdmi.o
  LD [M]  sound/pci/hda/snd-hda-codec-conexant.o
drivers/media/dvb/frontends/stb0899_algo.c:58: warning: ‘stb0899_get_srate’ 
defined but not used
  LD [M]  sound/pci/hda/snd-hda-codec-via.o
  LD [M]  sound/pci/hda/snd-hda-codec-nvhdmi.o
  CC [M]  drivers/media/dvb/frontends/stb6100.o
  LD [M]  sound/pci/hda/snd-hda-codec-intelhdmi.o
  LD [M]  sound/pci/hda/snd-hda-intel.o
  CC [M]  sound/pci/oxygen/oxygen_io.o
  CC [M]  sound/pci/oxygen/oxygen_lib.o
  CC [M]  drivers/media/dvb/frontends/tda8083.o
  CC [M]  drivers/media/dvb/frontends/tda1004x.o
  CC [M]  drivers/media/dvb/frontends/tda10021.o
  CC [M]  fs/nfsd/export.o
  CC [M]  sound/pci/oxygen/oxygen_mixer.o
  CC [M]  drivers/media/dvb/frontends/tda10023.o
  CC [M]  drivers/media/dvb/frontends/or51132.o
  CC [M]  sound/pci/oxygen/oxygen_pcm.o
  CC [M]  fs/nfsd/auth.o
  CC [M]  drivers/media/dvb/frontends/bcm3510.o
  CC [M]  fs/nfsd/lockd.o
  CC [M]  sound/pci/oxygen/virtuoso.o
  CC [M]  fs/nfsd/nfscache.o
  CC [M]  drivers/media/dvb/frontends/lgdt330x.o
  LD [M]  sound/pci/oxygen/snd-oxygen-lib.o
  LD [M]  sound/pci/oxygen/snd-virtuoso.o
  CC [M]  sound/pci/riptide/riptide.o
  CC [M]  fs/nfsd/nfsxdr.o
  CC [M]  drivers/media/dvb/frontends/lgdt3304.o
  CC [M]  drivers/media/dvb/frontends/lnbp21.o
  CC [M]  fs/nfsd/stats.o
  CC [M]  drivers/media/dvb/frontends/isl6405.o
  LD [M]  sound/pci/riptide/snd-riptide.o
  CC [M]  fs/nfsd/nfs2acl.o
  LD [M]  sound/pci/snd-atiixp.o
  LD [M]  sound/pci/snd-bt87x.o
  LD [M]  sound/pci/snd-intel8x0.o
  CC [M]  drivers/media/dvb/frontends/isl6421.o
  CC [M]  sound/synth/util_mem.o
  CC [M]  fs/nfsd/nfs3proc.o
  CC [M]  drivers/media/dvb/frontends/tda10086.o
  CC [M]  sound/synth/emux/emux.o
  CC [M]  sound/synth/emux/emux_synth.o
  CC [M]  drivers/media/dvb/frontends/tda8261.o
  CC [M]  fs/nfsd/nfs3xdr.o
  CC [M]  drivers/media/dvb/frontends/dib0070.o
  CC [M]  sound/synth/emux/emux_seq.o
  CC [M]  sound/synth/emux/emux_nrpn.o
  CC [M]  drivers/media/dvb/frontends/tua6100.o
  CC [M]  fs/nfsd/nfs3acl.o
  CC [M]  sound/synth/emux/emux_effect.o
  CC [M]  drivers/media/dvb/frontends/s5h1409.o
  CC [M]  fs/nfsd/nfs4proc.o
  CC [M]  sound/synth/emux/emux_proc.o
  CC [M]  drivers/media/dvb/frontends/au8522.o
  CC [M]  sound/synth/emux/emux_hwdep.o
  CC [M]  fs/nfsd/nfs4xdr.o
  CC [M]  drivers/media/dvb/frontends/tda10048.o
  CC [M]  sound/synth/emux/soundfont.o
  CC [M]  sound/synth/emux/emux_oss.o
  CC [M]  drivers/media/dvb/frontends/cx24113.o
  LD [M]  sound/synth/emux/snd-emux-synth.o
  LD [M]  sound/synth/snd-util-mem.o
  LD [M]  sound/soundcore.o
  CC [M]  drivers/media/dvb/frontends/s5h1411.o
  CC [M]  drivers/media/dvb/frontends/lgs8gl5.o
  CC [M]  fs/nfsd/nfs4state.o
  CC [M]  drivers/message/i2o/bus-osm.o
  CC [M]  drivers/media/dvb/frontends/af9013.o
  CC [M]  drivers/message/i2o/iop.o
  LD [M]  drivers/media/dvb/frontends/s921.o
  LD [M]  drivers/media/dvb/frontends/stb0899.o
  CC [M]  drivers/message/i2o/driver.o
  CC [M]  drivers/media/dvb/ttpci/ttpci-eeprom.o
  CC [M]  drivers/media/dvb/ttpci/av7110_hw.o
  CC [M]  drivers/message/i2o/device.o
  CC [M]  fs/nfsd/nfs4idmap.o
  CC [M]  drivers/message/i2o/debug.o
  CC [M]  drivers/message/i2o/pci.o
  CC [M]  fs/nfsd/nfs4acl.o
  CC [M]  drivers/media/dvb/ttpci/av7110_v4l.o
  CC [M]  drivers/message/i2o/exec-osm.o
  CC [M]  fs/nfsd/nfs4callback.o
  CC [M]  drivers/media/dvb/ttpci/av7110_av.o
  CC [M]  drivers/message/i2o/memory.o
  CC [M]  fs/nfsd/nfs4recover.o
  CC [M]  drivers/message/i2o/i2o_block.o
  LD [M]  fs/nfsd/nfsd.o
  CC [M]  fs/nls/nls_cp737.o
  CC [M]  fs/nls/nls_cp775.o
  CC [M]  drivers/message/i2o/i2o_scsi.o
  CC [M]  fs/nls/nls_cp850.o
  CC [M]  drivers/media/dvb/ttpci/av7110_ca.o
  CC [M]  fs/nls/nls_cp852.o
  CC [M]  drivers/message/i2o/i2o_proc.o
  CC [M]  fs/nls/nls_cp855.o
  CC [M]  drivers/media/dvb/ttpci/av7110.o
  CC [M]  fs/nls/nls_cp857.o
  CC [M]  fs/nls/nls_cp860.o
  CC [M]  fs/nls/nls_cp861.o
  LD [M]  drivers/message/i2o/i2o_core.o
  LD [M]  drivers/message/i2o/i2o_bus.o
  CC [M]  fs/nls/nls_cp862.o
  CC [M]  fs/nls/nls_cp863.o
  CC [M]  drivers/misc/tifm_core.o
  CC [M]  fs/nls/nls_cp864.o
  CC [M]  drivers/mmc/card/block.o
  CC [M]  drivers/media/dvb/ttpci/av7110_ipack.o
  CC [M]  fs/nls/nls_cp865.o
  CC [M]  drivers/media/dvb/ttpci/av7110_ir.o
  CC [M]  fs/nls/nls_cp866.o
  CC [M]  fs/nls/nls_cp869.o
  CC [M]  drivers/mmc/card/queue.o
  CC [M]  fs/nls/nls_cp874.o
  LD [M]  drivers/media/dvb/ttpci/dvb-ttpci.o
  CC [M]  drivers/media/video/msp3400-driver.o
  CC [M]  fs/nls/nls_cp932.o
  LD [M]  drivers/mmc/card/mmc_block.o
  CC [M]  drivers/mmc/core/core.o
  CC [M]  fs/nls/nls_euc-jp.o
  CC [M]  drivers/media/video/msp3400-kthreads.o
  CC [M]  drivers/mmc/core/bus.o
  CC [M]  fs/nls/nls_cp936.o
  CC [M]  drivers/mmc/core/host.o
  CC [M]  fs/nls/nls_cp949.o
  CC [M]  drivers/media/video/tuner-core.o
  CC [M]  drivers/mmc/core/mmc.o
  CC [M]  drivers/mmc/core/mmc_ops.o
  CC [M]  fs/nls/nls_cp950.o
  CC [M]  drivers/media/video/v4l2-dev.o
  CC [M]  drivers/mmc/core/sd.o
  CC [M]  fs/nls/nls_cp1250.o
  CC [M]  fs/nls/nls_cp1251.o
  CC [M]  drivers/mmc/core/sd_ops.o
  CC [M]  drivers/media/video/v4l2-ioctl.o
  CC [M]  fs/nls/nls_iso8859-1.o
  CC [M]  fs/nls/nls_iso8859-2.o
  CC [M]  drivers/mmc/core/sdio.o
  CC [M]  fs/nls/nls_iso8859-3.o
  CC [M]  drivers/mmc/core/sdio_ops.o
  CC [M]  fs/nls/nls_iso8859-4.o
  CC [M]  fs/nls/nls_iso8859-5.o
  CC [M]  drivers/mmc/core/sdio_bus.o
  CC [M]  drivers/media/video/v4l2-device.o
  CC [M]  fs/nls/nls_iso8859-6.o
  CC [M]  fs/nls/nls_iso8859-7.o
  CC [M]  drivers/mmc/core/sdio_cis.o
  CC [M]  drivers/media/video/v4l2-subdev.o
  CC [M]  fs/nls/nls_cp1255.o
  CC [M]  fs/nls/nls_iso8859-9.o
  CC [M]  drivers/mmc/core/sdio_io.o
  CC [M]  drivers/media/video/v4l2-int-device.o
  CC [M]  fs/nls/nls_iso8859-13.o
  CC [M]  drivers/mmc/core/sdio_irq.o
  CC [M]  fs/nls/nls_iso8859-14.o
  CC [M]  drivers/media/video/v4l2-common.o
  CC [M]  fs/nls/nls_iso8859-15.o
  CC [M]  drivers/mmc/core/debugfs.o
  CC [M]  fs/nls/nls_koi8-r.o
  CC [M]  fs/nls/nls_koi8-u.o
  LD [M]  drivers/mmc/core/mmc_core.o
  CC [M]  drivers/mmc/host/sdhci.o
  CC [M]  drivers/media/video/v4l1-compat.o
  CC [M]  fs/nls/nls_koi8-ru.o
  CC [M]  fs/nls/nls_utf8.o
  LD [M]  drivers/media/video/tuner.o
  CC [M]  drivers/media/video/ir-kbd-i2c.o
  CC [M]  fs/udf/balloc.o
  CC [M]  drivers/mmc/host/wbsd.o
  CC [M]  drivers/media/video/tvaudio.o
  CC [M]  fs/udf/dir.o
  CC [M]  drivers/media/video/tda7432.o
  CC [M]  drivers/mmc/host/tifm_sd.o
  CC [M]  fs/udf/file.o
  CC [M]  drivers/media/video/tda9875.o
  CC [M]  fs/udf/ialloc.o
  CC [M]  fs/udf/inode.o
  CC [M]  drivers/media/video/saa5246a.o
  CC [M]  fs/udf/lowlevel.o
  CC [M]  fs/udf/namei.o
  CC [M]  drivers/media/video/saa5249.o
  CC [M]  fs/udf/partition.o
  CC [M]  drivers/media/video/tda9840.o
  CC [M]  fs/udf/super.o
  CC [M]  fs/udf/truncate.o
  CC [M]  drivers/media/video/tea6415c.o
  CC [M]  drivers/media/video/tea6420.o
  CC [M]  arch/x86/video/fbdev.o
  CC [M]  drivers/media/video/saa7115.o
  CC [M]  fs/udf/symlink.o
  CC [M]  net/ipv4/ah4.o
  CC [M]  fs/udf/fsync.o
  CC [M]  drivers/media/video/saa717x.o
  CC [M]  fs/udf/directory.o
  CC [M]  net/ipv4/esp4.o
  CC [M]  fs/udf/misc.o
  CC [M]  drivers/media/video/saa7127.o
  CC [M]  drivers/media/video/tvp5150.o
  CC [M]  fs/udf/udftime.o
  CC [M]  net/ipv4/ipcomp.o
  CC [M]  fs/udf/unicode.o
  CC [M]  net/ipv4/xfrm4_tunnel.o
  LD [M]  drivers/media/video/msp3400.o
  CC [M]  drivers/media/video/cs5345.o
  LD [M]  fs/udf/udf.o
  CC [M]  drivers/media/video/cs53l32a.o
  CC [M]  net/ipv4/xfrm4_mode_beet.o
  CC [M]  drivers/media/video/m52790.o
  CC [M]  drivers/media/video/tlv320aic23b.o
  CC [M]  net/ipv4/inet_lro.o
  CC [M]  drivers/net/ne2k-pci.o
  CC [M]  drivers/media/video/wm8775.o
  CC [M]  drivers/media/video/wm8739.o
  CC [M]  drivers/net/8390.o
  CC [M]  net/ipv4/tunnel4.o
  CC [M]  drivers/media/video/vp27smpx.o
  CC [M]  net/ipv4/xfrm4_mode_transport.o
  CC [M]  drivers/media/video/hexium_orion.o
  CC [M]  drivers/net/tlan.o
  CC [M]  net/ipv4/xfrm4_mode_tunnel.o
  CC [M]  drivers/media/video/hexium_gemini.o
  CC [M]  drivers/media/video/videobuf-core.o
  CC [M]  net/ipv4/inet_diag.o
  CC [M]  drivers/net/epic100.o
  CC [M]  drivers/media/video/videobuf-dma-sg.o
  CC [M]  net/ipv4/tcp_diag.o
  CC [M]  drivers/net/sis900.o
  CC [M]  drivers/media/video/videobuf-vmalloc.o
  CC [M]  net/key/af_key.o
  CC [M]  drivers/media/video/videobuf-dvb.o
  CC [M]  drivers/media/video/btcx-risc.o
  CC [M]  drivers/net/via-rhine.o
  CC [M]  drivers/media/video/tveeprom.o
  CC [M]  net/sctp/sm_statetable.o
  CC [M]  drivers/net/mii.o
  CC [M]  drivers/media/video/upd64031a.o
  CC [M]  drivers/net/sundance.o
  CC [M]  net/sctp/sm_statefuns.o
  CC [M]  drivers/media/video/upd64083.o
  CC [M]  drivers/media/video/cx2341x.o
  CC [M]  drivers/net/forcedeth.o
  CC [M]  drivers/media/video/cafe_ccic.o
  CC [M]  drivers/media/video/ov7670.o
  CC [M]  net/sctp/sm_sideeffect.o
  CC [M]  drivers/media/video/tcm825x.o
  CC [M]  drivers/media/video/dabusb.o
  CC [M]  net/sctp/protocol.o
  CC [M]  drivers/net/dummy.o
  CC [M]  drivers/media/video/vivi.o
  CC [M]  drivers/net/8139cp.o
  CC [M]  net/sctp/endpointola.o
  CC [M]  drivers/media/video/soc_camera.o
  CC [M]  net/sctp/associola.o
  CC [M]  drivers/net/8139too.o
  CC [M]  drivers/media/video/au0828/au0828-core.o
  CC [M]  net/sctp/transport.o
  CC [M]  drivers/media/video/au0828/au0828-i2c.o
  CC [M]  drivers/net/sc92031.o
  CC [M]  drivers/media/video/au0828/au0828-cards.o
  CC [M]  net/sctp/chunk.o
  CC [M]  drivers/media/video/au0828/au0828-dvb.o
  CC [M]  net/sctp/sm_make_chunk.o
  LD [M]  drivers/media/video/au0828/au0828.o
  CC [M]  drivers/media/video/cx18/cx18-driver.o
  CC [M]  lib/crc-ccitt.o
  CC [M]  lib/crc16.o
  CC [M]  drivers/media/video/cx18/cx18-cards.o
  CC [M]  net/sctp/ulpevent.o
  CC [M]  lib/crc-t10dif.o
  CC [M]  lib/crc-itu-t.o
  CC [M]  drivers/media/video/cx18/cx18-i2c.o
  CC [M]  lib/zlib_deflate/deflate.o
  CC [M]  net/sctp/inqueue.o
  CC [M]  drivers/media/video/cx18/cx18-firmware.o
  CC [M]  lib/zlib_deflate/deftree.o
  CC [M]  net/sctp/outqueue.o
  CC [M]  lib/zlib_deflate/deflate_syms.o
  CC [M]  drivers/media/video/cx18/cx18-gpio.o
  LD [M]  lib/zlib_deflate/zlib_deflate.o
  CC [M]  drivers/media/video/cx18/cx18-queue.o
  CC [M]  drivers/media/video/cx18/cx18-streams.o
  CC [M]  net/sctp/ulpqueue.o
  CC [M]  drivers/media/video/cx23885/cx23885-cards.o
  CC [M]  drivers/media/video/cx18/cx18-fileops.o
  CC [M]  drivers/media/video/cx23885/cx23885-video.o
  CC [M]  net/sctp/command.o
  CC [M]  drivers/media/video/cx18/cx18-ioctl.o
  CC [M]  net/sctp/tsnmap.o
  CC [M]  drivers/media/video/cx23885/cx23885-vbi.o
  CC [M]  net/sctp/bind_addr.o
  CC [M]  drivers/media/video/cx18/cx18-controls.o
  CC [M]  drivers/media/video/cx23885/cx23885-core.o
  CC [M]  drivers/media/video/cx18/cx18-mailbox.o
  CC [M]  net/sctp/socket.o
  CC [M]  drivers/media/video/cx18/cx18-vbi.o
  CC [M]  drivers/media/video/cx23885/cx23885-i2c.o
  CC [M]  drivers/media/video/cx18/cx18-audio.o
  CC [M]  drivers/media/video/cx23885/cx23885-dvb.o
  CC [M]  drivers/media/video/cx18/cx18-video.o
  CC [M]  drivers/media/video/cx23885/cx23885-417.o
  CC [M]  net/sctp/primitive.o
  CC [M]  drivers/media/video/cx18/cx18-irq.o
  CC [M]  drivers/media/video/cx18/cx18-av-core.o
  LD [M]  drivers/media/video/cx23885/cx23885.o
  CC [M]  net/sctp/output.o
  CC [M]  drivers/media/video/cx18/cx18-av-audio.o
  CC [M]  net/sunrpc/clnt.o
  CC [M]  net/sctp/input.o
  CC [M]  drivers/media/video/cx18/cx18-av-firmware.o
  CC [M]  drivers/media/video/cx18/cx18-av-vbi.o
  CC [M]  net/sunrpc/xprt.o
  CC [M]  net/sctp/debug.o
  CC [M]  drivers/media/video/cx18/cx18-scb.o
  CC [M]  net/sunrpc/socklib.o
  CC [M]  net/sctp/ssnmap.o
  CC [M]  drivers/media/video/cx18/cx18-dvb.o
  CC [M]  net/sunrpc/xprtsock.o
  CC [M]  net/sctp/auth.o
  CC [M]  drivers/media/video/cx18/cx18-io.o
  CC [M]  net/sctp/proc.o
  LD [M]  drivers/media/video/cx18/cx18.o
  CC [M]  drivers/media/video/cx25840/cx25840-core.o
  CC [M]  net/sunrpc/sched.o
  CC [M]  net/sctp/sysctl.o
  CC [M]  net/sunrpc/auth.o
  CC [M]  drivers/media/video/cx25840/cx25840-audio.o
  LD [M]  net/sctp/sctp.o
  CC [M]  drivers/parport/share.o
  CC [M]  drivers/media/video/cx25840/cx25840-firmware.o
  CC [M]  net/sunrpc/auth_null.o
  CC [M]  drivers/media/video/cx25840/cx25840-vbi.o
  CC [M]  net/sunrpc/auth_unix.o
  CC [M]  drivers/parport/ieee1284.o
  LD [M]  drivers/media/video/cx25840/cx25840.o
  CC [M]  drivers/media/video/cx88/cx88-video.o
  CC [M]  net/sunrpc/auth_generic.o
  CC [M]  drivers/parport/ieee1284_ops.o
  CC [M]  net/sunrpc/svc.o
  CC [M]  drivers/parport/procfs.o
  CC [M]  net/sunrpc/svcsock.o
  CC [M]  drivers/media/video/cx88/cx88-vbi.o
  CC [M]  drivers/parport/daisy.o
  CC [M]  drivers/media/video/cx88/cx88-mpeg.o
  CC [M]  drivers/parport/probe.o
  CC [M]  net/sunrpc/svcauth.o
  CC [M]  drivers/media/video/cx88/cx88-cards.o
  CC [M]  drivers/parport/parport_pc.o
  CC [M]  net/sunrpc/svcauth_unix.o
  CC [M]  drivers/media/video/cx88/cx88-core.o
  CC [M]  net/sunrpc/rpcb_clnt.o
  LD [M]  drivers/parport/parport.o
  CC [M]  drivers/media/video/cx88/cx88-i2c.o
  CC [M]  drivers/media/video/gspca/gspca.o
  CC [M]  drivers/media/video/cx88/cx88-tvaudio.o
  CC [M]  net/sunrpc/timer.o
  CC [M]  net/sunrpc/xdr.o
  CC [M]  drivers/media/video/cx88/cx88-input.o
  LD [M]  drivers/media/video/gspca/gspca_main.o
  CC [M]  net/sunrpc/sunrpc_syms.o
  CC [M]  drivers/media/video/cx88/cx88-alsa.o
  CC [M]  net/xfrm/xfrm_ipcomp.o
  CC [M]  net/sunrpc/cache.o
  CC [M]  drivers/media/video/cx88/cx88-blackbird.o
  CC [M]  drivers/media/video/cx88/cx88-dvb.o
  CC [M]  net/sunrpc/rpc_pipe.o
  LD [M]  drivers/media/video/cx88/cx88xx.o
  CC [M]  net/sunrpc/svc_xprt.o
  CC [M]  net/sunrpc/stats.o
drivers/media/dvb/frontends/cx24123.h:55: 
warning: ‘cx24123_get_tuner_i2c_adapter’ defined but not used
  LD [M]  drivers/media/video/cx88/cx8800.o
  LD [M]  drivers/media/video/cx88/cx8802.o
  CC [M]  drivers/media/video/ivtv/ivtv-routing.o
  CC [M]  net/sunrpc/sysctl.o
  CC [M]  drivers/media/video/ivtv/ivtv-cards.o
  LD [M]  net/sunrpc/sunrpc.o
  CC [M]  net/sunrpc/auth_gss/auth_gss.o
  CC [M]  drivers/media/video/saa7134/saa7134-cards.o
  CC [M]  drivers/media/video/ivtv/ivtv-controls.o
  CC [M]  drivers/media/video/ivtv/ivtv-driver.o
  CC [M]  drivers/media/video/saa7134/saa7134-core.o
  CC [M]  net/sunrpc/auth_gss/gss_generic_token.o
  CC [M]  net/sunrpc/auth_gss/gss_mech_switch.o
  CC [M]  drivers/media/video/ivtv/ivtv-fileops.o
  CC [M]  net/sunrpc/auth_gss/svcauth_gss.o
  CC [M]  drivers/media/video/saa7134/saa7134-i2c.o
  CC [M]  drivers/media/video/ivtv/ivtv-firmware.o
  CC [M]  drivers/media/video/saa7134/saa7134-ts.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_mech.o
  CC [M]  drivers/media/video/ivtv/ivtv-gpio.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_seal.o
  CC [M]  drivers/media/video/saa7134/saa7134-tvaudio.o
  CC [M]  drivers/media/video/ivtv/ivtv-i2c.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_unseal.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_seqnum.o
  CC [M]  drivers/media/video/saa7134/saa7134-vbi.o
  CC [M]  drivers/media/video/ivtv/ivtv-ioctl.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_wrap.o
  CC [M]  drivers/media/video/saa7134/saa7134-video.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_crypto.o
  CC [M]  drivers/media/video/ivtv/ivtv-irq.o
  CC [M]  net/sunrpc/auth_gss/gss_spkm3_mech.o
  CC [M]  net/sunrpc/auth_gss/gss_spkm3_seal.o
  CC [M]  drivers/media/video/saa7134/saa7134-input.o
  CC [M]  net/sunrpc/auth_gss/gss_spkm3_unseal.o
  CC [M]  drivers/media/video/ivtv/ivtv-mailbox.o
  CC [M]  net/sunrpc/auth_gss/gss_spkm3_token.o
  CC [M]  drivers/media/video/saa7134/saa7134-empress.o
  CC [M]  drivers/media/video/ivtv/ivtv-queue.o
  LD [M]  net/sunrpc/auth_gss/auth_rpcgss.o
  LD [M]  net/sunrpc/auth_gss/rpcsec_gss_krb5.o
  LD [M]  net/sunrpc/auth_gss/rpcsec_gss_spkm3.o
  CC [M]  drivers/media/video/saa7134/saa6752hs.o
  CC [M]  drivers/media/video/ivtv/ivtv-streams.o
  CC [M]  drivers/media/video/ivtv/ivtv-udma.o
  CC [M]  drivers/media/video/saa7134/saa7134-alsa.o
  CC [M]  drivers/media/video/saa7134/saa7134-dvb.o
  CC [M]  drivers/media/video/ivtv/ivtv-vbi.o
  CC [M]  drivers/media/video/ivtv/ivtv-yuv.o
  LD [M]  drivers/media/video/saa7134/saa7134.o
  CC [M]  drivers/media/video/ivtv/ivtvfb.o
  LD [M]  drivers/media/video/videodev.o
  CC [M]  drivers/scsi/scsi.o
  CC [M]  drivers/scsi/hosts.o
  LD [M]  drivers/media/video/ivtv/ivtv.o
  CC [M]  drivers/spi/spi_bitbang.o
  CC [M]  drivers/scsi/scsi_ioctl.o
  CC [M]  drivers/spi/at25.o
  CC [M]  drivers/scsi/constants.o
  CC [M]  drivers/scsi/scsicam.o
  CC [M]  drivers/usb/class/usblp.o
  CC [M]  drivers/scsi/scsi_error.o
  CC [M]  drivers/scsi/scsi_lib.o
  CC [M]  drivers/usb/host/ehci-hcd.o
  CC [M]  drivers/video/fbmem.o
  CC [M]  drivers/scsi/scsi_lib_dma.o
  CC [M]  drivers/scsi/scsi_scan.o
  CC [M]  drivers/video/fbmon.o
  CC [M]  drivers/usb/host/ohci-hcd.o
  CC [M]  drivers/scsi/scsi_sysfs.o
  CC [M]  drivers/video/fbcmap.o
  CC [M]  drivers/video/fbsysfs.o
  CC [M]  drivers/scsi/scsi_devinfo.o
  CC [M]  drivers/video/modedb.o
  CC [M]  drivers/scsi/scsi_sysctl.o
  CC [M]  drivers/usb/host/uhci-hcd.o
  CC [M]  drivers/scsi/scsi_proc.o
  CC [M]  drivers/video/fbcvt.o
  CC [M]  drivers/scsi/sd.o
  CC [M]  drivers/video/cfbfillrect.o
  CC [M]  drivers/video/cfbcopyarea.o
  CC [M]  drivers/usb/serial/usb-serial.o
  CC [M]  drivers/scsi/sr.o
  CC [M]  drivers/video/cfbimgblt.o
  CC [M]  drivers/usb/serial/generic.o
  CC [M]  drivers/video/fb_ddc.o
  CC [M]  drivers/scsi/sr_ioctl.o
  CC [M]  drivers/usb/serial/bus.o
  CC [M]  drivers/video/aty/radeon_base.o
  CC [M]  drivers/usb/serial/belkin_sa.o
  CC [M]  drivers/scsi/sr_vendor.o
  CC [M]  drivers/usb/serial/ftdi_sio.o
  CC [M]  drivers/scsi/scsi_transport_spi.o
  CC [M]  drivers/usb/serial/garmin_gps.o
  CC [M]  drivers/video/aty/radeon_pm.o
  CC [M]  drivers/scsi/scsi_transport_iscsi.o
  CC [M]  drivers/usb/serial/ipaq.o
  CC [M]  drivers/usb/serial/pl2303.o
  CC [M]  drivers/scsi/scsi_transport_sas.o
  LD [M]  drivers/usb/serial/usbserial.o
  CC [M]  drivers/usb/storage/scsiglue.o
  CC [M]  drivers/usb/storage/protocol.o
  CC [M]  drivers/scsi/scsi_transport_srp.o
  CC [M]  drivers/usb/storage/transport.o
  LD [M]  drivers/scsi/sd_mod.o
  LD [M]  drivers/scsi/sr_mod.o
  CC [M]  drivers/scsi/sg.o
  CC [M]  drivers/usb/storage/usb.o
  CC [M]  drivers/video/aty/radeon_monitor.o
  CC [M]  drivers/usb/storage/initializers.o
  CC [M]  drivers/scsi/scsi_wait_scan.o
  CC [M]  drivers/video/aty/radeon_accel.o
  CC [M]  drivers/usb/storage/sierra_ms.o
  CC [M]  drivers/scsi/libsas/sas_init.o
  CC [M]  drivers/video/aty/radeon_i2c.o
  CC [M]  drivers/usb/storage/option_ms.o
  CC [M]  drivers/scsi/libsas/sas_phy.o
  LD [M]  drivers/video/aty/radeonfb.o
  CC [M]  drivers/video/console/fbcon.o
  CC [M]  drivers/usb/storage/shuttle_usbat.o
  CC [M]  drivers/scsi/libsas/sas_port.o
  CC [M]  drivers/usb/storage/sddr09.o
  CC [M]  drivers/scsi/libsas/sas_event.o
  CC [M]  drivers/scsi/libsas/sas_dump.o
  CC [M]  drivers/video/console/bitblit.o
  CC [M]  drivers/usb/storage/sddr55.o
  CC [M]  drivers/scsi/libsas/sas_discover.o
  CC [M]  drivers/video/console/fonts.o
  CC [M]  drivers/scsi/libsas/sas_expander.o
  CC [M]  drivers/video/console/font_8x8.o
  CC [M]  drivers/usb/storage/freecom.o
  CC [M]  drivers/video/console/font_8x16.o
  CC [M]  drivers/video/console/softcursor.o
  CC [M]  drivers/usb/storage/datafab.o
  CC [M]  drivers/video/console/tileblit.o
  CC [M]  drivers/usb/storage/jumpshot.o
  LD [M]  drivers/video/console/font.o
  LD [M]  drivers/video/fb.o
  CC [M]  drivers/scsi/libsas/sas_scsi_host.o
  CC [M]  drivers/scsi/libsas/sas_task.o
  CC [M]  drivers/usb/storage/alauda.o
  CC [M]  drivers/scsi/libsas/sas_ata.o
  CC [M]  drivers/scsi/libsas/sas_host_smp.o
  LD [M]  drivers/usb/storage/usb-storage.o
  LD [M]  drivers/scsi/libsas/libsas.o
  LD [M]  drivers/scsi/scsi_mod.o
  Building modules, stage 2.
  MODPOST 374 modules
  CC      arch/x86/crypto/aes-i586.mod.o
  CC      arch/x86/crypto/twofish-i586.mod.o
  CC      arch/x86/video/fbdev.mod.o
  CC      crypto/aes_generic.mod.o
  CC      crypto/anubis.mod.o
  CC      crypto/arc4.mod.o
  CC      crypto/authenc.mod.o
  CC      crypto/camellia.mod.o
  CC      crypto/blowfish.mod.o
  CC      crypto/cast5.mod.o
  CC      crypto/cast6.mod.o
  CC      crypto/cbc.mod.o
  CC      crypto/crypto_null.mod.o
  CC      crypto/deflate.mod.o
  CC      crypto/des_generic.mod.o
  CC      crypto/ecb.mod.o
  CC      crypto/fcrypt.mod.o
  CC      crypto/gf128mul.mod.o
  CC      crypto/khazad.mod.o
  CC      crypto/lrw.mod.o
  CC      crypto/md4.mod.o
  CC      crypto/michael_mic.mod.o
  CC      crypto/pcbc.mod.o
  CC      crypto/serpent.mod.o
  CC      crypto/sha256_generic.mod.o
  CC      crypto/sha512_generic.mod.o
  CC      crypto/tcrypt.mod.o
  CC      crypto/tea.mod.o
  CC      crypto/tgr192.mod.o
  CC      crypto/twofish.mod.o
  CC      crypto/twofish_common.mod.o
  CC      crypto/wp512.mod.o
  CC      crypto/xcbc.mod.o
  CC      drivers/acpi/button.mod.o
  CC      drivers/ata/ahci.mod.o
  CC      drivers/ata/ata_generic.mod.o
  CC      drivers/ata/libata.mod.o
  CC      drivers/ata/pata_acpi.mod.o
  CC      drivers/ata/pata_amd.mod.o
  CC      drivers/ata/pata_jmicron.mod.o
  CC      drivers/ata/pata_sil680.mod.o
  CC      drivers/ata/sata_nv.mod.o
  CC      drivers/ata/sata_sil.mod.o
  CC      drivers/block/cryptoloop.mod.o
  CC      drivers/block/floppy.mod.o
  CC      drivers/block/loop.mod.o
  CC      drivers/block/nbd.mod.o
  CC      drivers/block/pktcdvd.mod.o
  CC      drivers/cdrom/cdrom.mod.o
  CC      drivers/char/agp/agpgart.mod.o
  CC      drivers/char/agp/amd-k7-agp.mod.o
  CC      drivers/char/agp/amd64-agp.mod.o
  CC      drivers/char/agp/ati-agp.mod.o
  CC      drivers/char/agp/nvidia-agp.mod.o
  CC      drivers/char/agp/via-agp.mod.o
  CC      drivers/char/hw_random/amd-rng.mod.o
  CC      drivers/char/ipmi/ipmi_devintf.mod.o
  CC      drivers/char/ipmi/ipmi_msghandler.mod.o
  CC      drivers/char/ipmi/ipmi_poweroff.mod.o
  CC      drivers/char/ipmi/ipmi_si.mod.o
  CC      drivers/char/ipmi/ipmi_watchdog.mod.o
  CC      drivers/firewire/firewire-core.mod.o
  CC      drivers/firewire/firewire-ohci.mod.o
  CC      drivers/firewire/firewire-sbp2.mod.o
  CC      drivers/firmware/edd.mod.o
  CC      drivers/gpu/drm/drm.mod.o
  CC      drivers/gpu/drm/radeon/radeon.mod.o
  CC      drivers/hid/hid-dummy.mod.o
  CC      drivers/hwmon/hwmon-vid.mod.o
  CC      drivers/hwmon/hwmon.mod.o
  CC      drivers/hwmon/it87.mod.o
  CC      drivers/hwmon/w83627hf.mod.o
  CC      drivers/i2c/algos/i2c-algo-bit.mod.o
  CC      drivers/i2c/busses/i2c-amd756.mod.o
  CC      drivers/i2c/busses/i2c-nforce2.mod.o
  CC      drivers/i2c/chips/eeprom.mod.o
  CC      drivers/i2c/i2c-core.mod.o
  CC      drivers/i2c/i2c-dev.mod.o
  CC      drivers/input/evdev.mod.o
  CC      drivers/input/gameport/emu10k1-gp.mod.o
  CC      drivers/input/gameport/gameport.mod.o
  CC      drivers/input/gameport/ns558.mod.o
  CC      drivers/input/joydev.mod.o
  CC      drivers/input/misc/pcspkr.mod.o
  CC      drivers/media/common/ir-common.mod.o
  CC      drivers/media/common/saa7146.mod.o
  CC      drivers/media/common/saa7146_vv.mod.o
  CC      drivers/media/common/tuners/mxl5007t.mod.o
  CC      drivers/media/common/tuners/tda18271.mod.o
  CC      drivers/media/common/tuners/tda827x.mod.o
  CC      drivers/media/common/tuners/tda8290.mod.o
  CC      drivers/media/common/tuners/tda9887.mod.o
  CC      drivers/media/common/tuners/tuner-simple.mod.o
  CC      drivers/media/common/tuners/tuner-types.mod.o
  CC      drivers/media/common/tuners/tuner-xc2028.mod.o
  CC      drivers/media/common/tuners/xc5000.mod.o
  CC      drivers/media/dvb/dvb-core/dvb-core.mod.o
  CC      drivers/media/dvb/frontends/af9013.mod.o
  CC      drivers/media/dvb/frontends/au8522.mod.o
  CC      drivers/media/dvb/frontends/bcm3510.mod.o
  CC      drivers/media/dvb/frontends/cx24113.mod.o
  CC      drivers/media/dvb/frontends/dib0070.mod.o
  CC      drivers/media/dvb/frontends/dvb-pll.mod.o
  CC      drivers/media/dvb/frontends/isl6405.mod.o
  CC      drivers/media/dvb/frontends/isl6421.mod.o
  CC      drivers/media/dvb/frontends/lgdt3304.mod.o
  CC      drivers/media/dvb/frontends/lgdt330x.mod.o
  CC      drivers/media/dvb/frontends/lgs8gl5.mod.o
  CC      drivers/media/dvb/frontends/lnbp21.mod.o
  CC      drivers/media/dvb/frontends/or51132.mod.o
  CC      drivers/media/dvb/frontends/s5h1409.mod.o
  CC      drivers/media/dvb/frontends/s5h1411.mod.o
  CC      drivers/media/dvb/frontends/s921.mod.o
  CC      drivers/media/dvb/frontends/stb0899.mod.o
  CC      drivers/media/dvb/frontends/stb6100.mod.o
  CC      drivers/media/dvb/frontends/tda10021.mod.o
  CC      drivers/media/dvb/frontends/tda10023.mod.o
  CC      drivers/media/dvb/frontends/tda10048.mod.o
  CC      drivers/media/dvb/frontends/tda1004x.mod.o
  CC      drivers/media/dvb/frontends/tda10086.mod.o
  CC      drivers/media/dvb/frontends/tda8083.mod.o
  CC      drivers/media/dvb/frontends/tda8261.mod.o
  CC      drivers/media/dvb/frontends/tua6100.mod.o
  CC      drivers/media/dvb/ttpci/dvb-ttpci.mod.o
  CC      drivers/media/dvb/ttpci/ttpci-eeprom.mod.o
  CC      drivers/media/video/au0828/au0828.mod.o
  CC      drivers/media/video/btcx-risc.mod.o
  CC      drivers/media/video/cafe_ccic.mod.o
  CC      drivers/media/video/cs5345.mod.o
  CC      drivers/media/video/cs53l32a.mod.o
  CC      drivers/media/video/cx18/cx18.mod.o
  CC      drivers/media/video/cx2341x.mod.o
  CC      drivers/media/video/cx23885/cx23885.mod.o
  CC      drivers/media/video/cx25840/cx25840.mod.o
  CC      drivers/media/video/cx88/cx88-alsa.mod.o
  CC      drivers/media/video/cx88/cx88-blackbird.mod.o
  CC      drivers/media/video/cx88/cx88-dvb.mod.o
  CC      drivers/media/video/cx88/cx8800.mod.o
  CC      drivers/media/video/cx88/cx8802.mod.o
  CC      drivers/media/video/cx88/cx88xx.mod.o
  CC      drivers/media/video/dabusb.mod.o
  CC      drivers/media/video/gspca/gspca_main.mod.o
  CC      drivers/media/video/hexium_gemini.mod.o
  CC      drivers/media/video/hexium_orion.mod.o
  CC      drivers/media/video/ir-kbd-i2c.mod.o
  CC      drivers/media/video/ivtv/ivtv.mod.o
  CC      drivers/media/video/ivtv/ivtvfb.mod.o
  CC      drivers/media/video/m52790.mod.o
  CC      drivers/media/video/msp3400.mod.o
  CC      drivers/media/video/ov7670.mod.o
  CC      drivers/media/video/saa5246a.mod.o
  CC      drivers/media/video/saa5249.mod.o
  CC      drivers/media/video/saa7115.mod.o
  CC      drivers/media/video/saa7127.mod.o
  CC      drivers/media/video/saa7134/saa6752hs.mod.o
  CC      drivers/media/video/saa7134/saa7134-alsa.mod.o
  CC      drivers/media/video/saa7134/saa7134-dvb.mod.o
  CC      drivers/media/video/saa7134/saa7134-empress.mod.o
  CC      drivers/media/video/saa7134/saa7134.mod.o
  CC      drivers/media/video/saa717x.mod.o
  CC      drivers/media/video/soc_camera.mod.o
  CC      drivers/media/video/tcm825x.mod.o
  CC      drivers/media/video/tda7432.mod.o
  CC      drivers/media/video/tda9840.mod.o
  CC      drivers/media/video/tda9875.mod.o
  CC      drivers/media/video/tea6415c.mod.o
  CC      drivers/media/video/tea6420.mod.o
  CC      drivers/media/video/tlv320aic23b.mod.o
  CC      drivers/media/video/tuner.mod.o
  CC      drivers/media/video/tvaudio.mod.o
  CC      drivers/media/video/tveeprom.mod.o
  CC      drivers/media/video/tvp5150.mod.o
  CC      drivers/media/video/upd64031a.mod.o
  CC      drivers/media/video/v4l1-compat.mod.o
  CC      drivers/media/video/upd64083.mod.o
  CC      drivers/media/video/v4l2-common.mod.o
  CC      drivers/media/video/v4l2-int-device.mod.o
  CC      drivers/media/video/videobuf-core.mod.o
  CC      drivers/media/video/videobuf-dma-sg.mod.o
  CC      drivers/media/video/videobuf-dvb.mod.o
  CC      drivers/media/video/videobuf-vmalloc.mod.o
  CC      drivers/media/video/videodev.mod.o
  CC      drivers/media/video/vivi.mod.o
  CC      drivers/media/video/vp27smpx.mod.o
  CC      drivers/media/video/wm8739.mod.o
  CC      drivers/media/video/wm8775.mod.o
  CC      drivers/message/i2o/i2o_block.mod.o
  CC      drivers/message/i2o/i2o_bus.mod.o
  CC      drivers/message/i2o/i2o_core.mod.o
  CC      drivers/message/i2o/i2o_proc.mod.o
  CC      drivers/message/i2o/i2o_scsi.mod.o
  CC      drivers/misc/tifm_core.mod.o
  CC      drivers/mmc/card/mmc_block.mod.o
  CC      drivers/mmc/core/mmc_core.mod.o
  CC      drivers/mmc/host/sdhci.mod.o
  CC      drivers/mmc/host/tifm_sd.mod.o
  CC      drivers/mmc/host/wbsd.mod.o
  CC      drivers/net/8139cp.mod.o
  CC      drivers/net/8139too.mod.o
  CC      drivers/net/8390.mod.o
  CC      drivers/net/dummy.mod.o
  CC      drivers/net/epic100.mod.o
  CC      drivers/net/forcedeth.mod.o
  CC      drivers/net/mii.mod.o
  CC      drivers/net/ne2k-pci.mod.o
  CC      drivers/net/sc92031.mod.o
  CC      drivers/net/sis900.mod.o
  CC      drivers/net/sundance.mod.o
  CC      drivers/net/tlan.mod.o
  CC      drivers/net/via-rhine.mod.o
  CC      drivers/parport/parport.mod.o
  CC      drivers/parport/parport_pc.mod.o
  CC      drivers/scsi/libsas/libsas.mod.o
  CC      drivers/scsi/scsi_mod.mod.o
  CC      drivers/scsi/scsi_transport_iscsi.mod.o
  CC      drivers/scsi/scsi_transport_sas.mod.o
  CC      drivers/scsi/scsi_transport_spi.mod.o
  CC      drivers/scsi/scsi_transport_srp.mod.o
  CC      drivers/scsi/scsi_wait_scan.mod.o
  CC      drivers/scsi/sd_mod.mod.o
  CC      drivers/scsi/sg.mod.o
  CC      drivers/scsi/sr_mod.mod.o
  CC      drivers/spi/at25.mod.o
  CC      drivers/spi/spi_bitbang.mod.o
  CC      drivers/usb/class/usblp.mod.o
  CC      drivers/usb/host/ehci-hcd.mod.o
  CC      drivers/usb/host/ohci-hcd.mod.o
  CC      drivers/usb/host/uhci-hcd.mod.o
  CC      drivers/usb/serial/belkin_sa.mod.o
  CC      drivers/usb/serial/ftdi_sio.mod.o
  CC      drivers/usb/serial/garmin_gps.mod.o
  CC      drivers/usb/serial/ipaq.mod.o
  CC      drivers/usb/serial/pl2303.mod.o
  CC      drivers/usb/serial/usbserial.mod.o
  CC      drivers/usb/storage/usb-storage.mod.o
  CC      drivers/video/aty/radeonfb.mod.o
  CC      drivers/video/cfbcopyarea.mod.o
  CC      drivers/video/cfbfillrect.mod.o
  CC      drivers/video/cfbimgblt.mod.o
  CC      drivers/video/console/bitblit.mod.o
  CC      drivers/video/console/fbcon.mod.o
  CC      drivers/video/console/font.mod.o
  CC      drivers/video/console/softcursor.mod.o
  CC      drivers/video/console/tileblit.mod.o
  CC      drivers/video/fb.mod.o
  CC      drivers/video/fb_ddc.mod.o
  CC      fs/autofs4/autofs4.mod.o
  CC      fs/cifs/cifs.mod.o
  CC      fs/configfs/configfs.mod.o
  CC      fs/dlm/dlm.mod.o
  CC      fs/exportfs/exportfs.mod.o
  CC      fs/ext2/ext2.mod.o
  CC      fs/ext3/ext3.mod.o
  CC      fs/fat/fat.mod.o
  CC      fs/fat/msdos.mod.o
  CC      fs/fat/vfat.mod.o
  CC      fs/fuse/fuse.mod.o
  CC      fs/jbd/jbd.mod.o
  CC      fs/lockd/lockd.mod.o
  CC      fs/mbcache.mod.o
  CC      fs/nfs/nfs.mod.o
  CC      fs/nfs_common/nfs_acl.mod.o
  CC      fs/nfsd/nfsd.mod.o
  CC      fs/nls/nls_cp1250.mod.o
  CC      fs/nls/nls_cp1251.mod.o
  CC      fs/nls/nls_cp1255.mod.o
  CC      fs/nls/nls_cp737.mod.o
  CC      fs/nls/nls_cp775.mod.o
  CC      fs/nls/nls_cp850.mod.o
  CC      fs/nls/nls_cp852.mod.o
  CC      fs/nls/nls_cp855.mod.o
  CC      fs/nls/nls_cp857.mod.o
  CC      fs/nls/nls_cp860.mod.o
  CC      fs/nls/nls_cp861.mod.o
  CC      fs/nls/nls_cp862.mod.o
  CC      fs/nls/nls_cp863.mod.o
  CC      fs/nls/nls_cp864.mod.o
  CC      fs/nls/nls_cp865.mod.o
  CC      fs/nls/nls_cp866.mod.o
  CC      fs/nls/nls_cp869.mod.o
  CC      fs/nls/nls_cp874.mod.o
  CC      fs/nls/nls_cp932.mod.o
  CC      fs/nls/nls_cp936.mod.o
  CC      fs/nls/nls_cp949.mod.o
  CC      fs/nls/nls_cp950.mod.o
  CC      fs/nls/nls_euc-jp.mod.o
  CC      fs/nls/nls_iso8859-1.mod.o
  CC      fs/nls/nls_iso8859-13.mod.o
  CC      fs/nls/nls_iso8859-14.mod.o
  CC      fs/nls/nls_iso8859-15.mod.o
  CC      fs/nls/nls_iso8859-2.mod.o
  CC      fs/nls/nls_iso8859-3.mod.o
  CC      fs/nls/nls_iso8859-4.mod.o
  CC      fs/nls/nls_iso8859-5.mod.o
  CC      fs/nls/nls_iso8859-6.mod.o
  CC      fs/nls/nls_iso8859-7.mod.o
  CC      fs/nls/nls_iso8859-9.mod.o
  CC      fs/nls/nls_koi8-r.mod.o
  CC      fs/nls/nls_koi8-ru.mod.o
  CC      fs/nls/nls_koi8-u.mod.o
  CC      fs/nls/nls_utf8.mod.o
  CC      fs/udf/udf.mod.o
  CC      lib/crc-ccitt.mod.o
  CC      lib/crc-itu-t.mod.o
  CC      lib/crc-t10dif.mod.o
  CC      lib/crc16.mod.o
  CC      lib/zlib_deflate/zlib_deflate.mod.o
  CC      net/ipv4/ah4.mod.o
  CC      net/ipv4/esp4.mod.o
  CC      net/ipv4/inet_diag.mod.o
  CC      net/ipv4/inet_lro.mod.o
  CC      net/ipv4/ipcomp.mod.o
  CC      net/ipv4/tcp_diag.mod.o
  CC      net/ipv4/tunnel4.mod.o
  CC      net/ipv4/xfrm4_mode_beet.mod.o
  CC      net/ipv4/xfrm4_mode_transport.mod.o
  CC      net/ipv4/xfrm4_mode_tunnel.mod.o
  CC      net/ipv4/xfrm4_tunnel.mod.o
  CC      net/key/af_key.mod.o
  CC      net/sctp/sctp.mod.o
  CC      net/sunrpc/auth_gss/auth_rpcgss.mod.o
  CC      net/sunrpc/auth_gss/rpcsec_gss_krb5.mod.o
  CC      net/sunrpc/auth_gss/rpcsec_gss_spkm3.mod.o
  CC      net/sunrpc/sunrpc.mod.o
  CC      net/xfrm/xfrm_ipcomp.mod.o
  CC      sound/ac97_bus.mod.o
  CC      sound/core/oss/snd-mixer-oss.mod.o
  CC      sound/core/oss/snd-pcm-oss.mod.o
  CC      sound/core/seq/oss/snd-seq-oss.mod.o
  CC      sound/core/seq/snd-seq-device.mod.o
  CC      sound/core/seq/snd-seq-dummy.mod.o
  CC      sound/core/seq/snd-seq-midi-emul.mod.o
  CC      sound/core/seq/snd-seq-midi-event.mod.o
  CC      sound/core/seq/snd-seq-midi.mod.o
  CC      sound/core/seq/snd-seq-virmidi.mod.o
  CC      sound/core/seq/snd-seq.mod.o
  CC      sound/core/snd-hwdep.mod.o
  CC      sound/core/snd-page-alloc.mod.o
  CC      sound/core/snd-pcm.mod.o
  CC      sound/core/snd-rawmidi.mod.o
  CC      sound/core/snd-rtctimer.mod.o
  CC      sound/core/snd-timer.mod.o
  CC      sound/core/snd.mod.o
  CC      sound/drivers/mpu401/snd-mpu401-uart.mod.o
  CC      sound/drivers/mpu401/snd-mpu401.mod.o
  CC      sound/drivers/opl3/snd-opl3-lib.mod.o
  CC      sound/drivers/opl3/snd-opl3-synth.mod.o
  CC      sound/drivers/snd-dummy.mod.o
  CC      sound/drivers/snd-serial-u16550.mod.o
  CC      sound/drivers/snd-virmidi.mod.o
  CC      sound/pci/ac97/snd-ac97-codec.mod.o
  CC      sound/pci/emu10k1/snd-emu10k1-synth.mod.o
  CC      sound/pci/emu10k1/snd-emu10k1.mod.o
  CC      sound/pci/hda/snd-hda-codec-analog.mod.o
  CC      sound/pci/hda/snd-hda-codec-atihdmi.mod.o
  CC      sound/pci/hda/snd-hda-codec-cmedia.mod.o
  CC      sound/pci/hda/snd-hda-codec-conexant.mod.o
  CC      sound/pci/hda/snd-hda-codec-idt.mod.o
  CC      sound/pci/hda/snd-hda-codec-intelhdmi.mod.o
  CC      sound/pci/hda/snd-hda-codec-nvhdmi.mod.o
  CC      sound/pci/hda/snd-hda-codec-realtek.mod.o
  CC      sound/pci/hda/snd-hda-codec-si3054.mod.o
  CC      sound/pci/hda/snd-hda-codec-via.mod.o
  CC      sound/pci/hda/snd-hda-codec.mod.o
  CC      sound/pci/hda/snd-hda-intel.mod.o
  CC      sound/pci/oxygen/snd-oxygen-lib.mod.o
  CC      sound/pci/oxygen/snd-virtuoso.mod.o
  CC      sound/pci/riptide/snd-riptide.mod.o
  CC      sound/pci/snd-atiixp.mod.o
  CC      sound/pci/snd-bt87x.mod.o
  CC      sound/pci/snd-intel8x0.mod.o
  CC      sound/soundcore.mod.o
  CC      sound/synth/emux/snd-emux-synth.mod.o
  CC      sound/synth/snd-util-mem.mod.o
  LD [M]  arch/x86/crypto/aes-i586.ko
  LD [M]  arch/x86/crypto/twofish-i586.ko
  LD [M]  arch/x86/video/fbdev.ko
  LD [M]  crypto/aes_generic.ko
  LD [M]  crypto/anubis.ko
  LD [M]  crypto/arc4.ko
  LD [M]  crypto/authenc.ko
  LD [M]  crypto/blowfish.ko
  LD [M]  crypto/camellia.ko
  LD [M]  crypto/cast5.ko
  LD [M]  crypto/cast6.ko
  LD [M]  crypto/cbc.ko
  LD [M]  crypto/crypto_null.ko
  LD [M]  crypto/deflate.ko
  LD [M]  crypto/ecb.ko
  LD [M]  crypto/des_generic.ko
  LD [M]  crypto/fcrypt.ko
  LD [M]  crypto/gf128mul.ko
  LD [M]  crypto/khazad.ko
  LD [M]  crypto/lrw.ko
  LD [M]  crypto/md4.ko
  LD [M]  crypto/michael_mic.ko
  LD [M]  crypto/pcbc.ko
  LD [M]  crypto/serpent.ko
  LD [M]  crypto/sha256_generic.ko
  LD [M]  crypto/sha512_generic.ko
  LD [M]  crypto/tcrypt.ko
  LD [M]  crypto/tea.ko
  LD [M]  crypto/tgr192.ko
  LD [M]  crypto/twofish.ko
  LD [M]  crypto/wp512.ko
  LD [M]  crypto/twofish_common.ko
  LD [M]  crypto/xcbc.ko
  LD [M]  drivers/acpi/button.ko
  LD [M]  drivers/ata/ahci.ko
  LD [M]  drivers/ata/ata_generic.ko
  LD [M]  drivers/ata/libata.ko
  LD [M]  drivers/ata/pata_acpi.ko
  LD [M]  drivers/ata/pata_amd.ko
  LD [M]  drivers/ata/pata_jmicron.ko
  LD [M]  drivers/ata/pata_sil680.ko
  LD [M]  drivers/ata/sata_nv.ko
  LD [M]  drivers/ata/sata_sil.ko
  LD [M]  drivers/block/cryptoloop.ko
  LD [M]  drivers/block/floppy.ko
  LD [M]  drivers/block/loop.ko
  LD [M]  drivers/block/nbd.ko
  LD [M]  drivers/block/pktcdvd.ko
  LD [M]  drivers/cdrom/cdrom.ko
  LD [M]  drivers/char/agp/agpgart.ko
  LD [M]  drivers/char/agp/amd-k7-agp.ko
  LD [M]  drivers/char/agp/amd64-agp.ko
  LD [M]  drivers/char/agp/ati-agp.ko
  LD [M]  drivers/char/agp/nvidia-agp.ko
  LD [M]  drivers/char/agp/via-agp.ko
  LD [M]  drivers/char/hw_random/amd-rng.ko
  LD [M]  drivers/char/ipmi/ipmi_devintf.ko
  LD [M]  drivers/char/ipmi/ipmi_msghandler.ko
  LD [M]  drivers/char/ipmi/ipmi_poweroff.ko
  LD [M]  drivers/char/ipmi/ipmi_si.ko
  LD [M]  drivers/char/ipmi/ipmi_watchdog.ko
  LD [M]  drivers/firewire/firewire-core.ko
  LD [M]  drivers/firewire/firewire-ohci.ko
  LD [M]  drivers/firewire/firewire-sbp2.ko
  LD [M]  drivers/firmware/edd.ko
  LD [M]  drivers/gpu/drm/drm.ko
  LD [M]  drivers/gpu/drm/radeon/radeon.ko
  LD [M]  drivers/hid/hid-dummy.ko
  LD [M]  drivers/hwmon/hwmon-vid.ko
  LD [M]  drivers/hwmon/hwmon.ko
  LD [M]  drivers/hwmon/it87.ko
  LD [M]  drivers/hwmon/w83627hf.ko
  LD [M]  drivers/i2c/algos/i2c-algo-bit.ko
  LD [M]  drivers/i2c/busses/i2c-amd756.ko
  LD [M]  drivers/i2c/busses/i2c-nforce2.ko
  LD [M]  drivers/i2c/chips/eeprom.ko
  LD [M]  drivers/i2c/i2c-core.ko
  LD [M]  drivers/i2c/i2c-dev.ko
  LD [M]  drivers/input/evdev.ko
  LD [M]  drivers/input/gameport/emu10k1-gp.ko
  LD [M]  drivers/input/gameport/gameport.ko
  LD [M]  drivers/input/gameport/ns558.ko
  LD [M]  drivers/input/joydev.ko
  LD [M]  drivers/input/misc/pcspkr.ko
  LD [M]  drivers/media/common/ir-common.ko
  LD [M]  drivers/media/common/saa7146.ko
  LD [M]  drivers/media/common/saa7146_vv.ko
  LD [M]  drivers/media/common/tuners/mxl5007t.ko
  LD [M]  drivers/media/common/tuners/tda18271.ko
  LD [M]  drivers/media/common/tuners/tda827x.ko
  LD [M]  drivers/media/common/tuners/tda8290.ko
  LD [M]  drivers/media/common/tuners/tda9887.ko
  LD [M]  drivers/media/common/tuners/tuner-simple.ko
  LD [M]  drivers/media/common/tuners/tuner-types.ko
  LD [M]  drivers/media/common/tuners/tuner-xc2028.ko
  LD [M]  drivers/media/common/tuners/xc5000.ko
  LD [M]  drivers/media/dvb/dvb-core/dvb-core.ko
  LD [M]  drivers/media/dvb/frontends/af9013.ko
  LD [M]  drivers/media/dvb/frontends/au8522.ko
  LD [M]  drivers/media/dvb/frontends/bcm3510.ko
  LD [M]  drivers/media/dvb/frontends/cx24113.ko
  LD [M]  drivers/media/dvb/frontends/dib0070.ko
  LD [M]  drivers/media/dvb/frontends/dvb-pll.ko
  LD [M]  drivers/media/dvb/frontends/isl6405.ko
  LD [M]  drivers/media/dvb/frontends/isl6421.ko
  LD [M]  drivers/media/dvb/frontends/lgdt3304.ko
  LD [M]  drivers/media/dvb/frontends/lgdt330x.ko
  LD [M]  drivers/media/dvb/frontends/lgs8gl5.ko
  LD [M]  drivers/media/dvb/frontends/lnbp21.ko
  LD [M]  drivers/media/dvb/frontends/or51132.ko
  LD [M]  drivers/media/dvb/frontends/s5h1409.ko
  LD [M]  drivers/media/dvb/frontends/s5h1411.ko
  LD [M]  drivers/media/dvb/frontends/s921.ko
  LD [M]  drivers/media/dvb/frontends/stb0899.ko
  LD [M]  drivers/media/dvb/frontends/stb6100.ko
  LD [M]  drivers/media/dvb/frontends/tda10021.ko
  LD [M]  drivers/media/dvb/frontends/tda10023.ko
  LD [M]  drivers/media/dvb/frontends/tda10048.ko
  LD [M]  drivers/media/dvb/frontends/tda1004x.ko
  LD [M]  drivers/media/dvb/frontends/tda10086.ko
  LD [M]  drivers/media/dvb/frontends/tda8083.ko
  LD [M]  drivers/media/dvb/frontends/tda8261.ko
  LD [M]  drivers/media/dvb/frontends/tua6100.ko
  LD [M]  drivers/media/dvb/ttpci/dvb-ttpci.ko
  LD [M]  drivers/media/dvb/ttpci/ttpci-eeprom.ko
  LD [M]  drivers/media/video/au0828/au0828.ko
  LD [M]  drivers/media/video/btcx-risc.ko
  LD [M]  drivers/media/video/cafe_ccic.ko
  LD [M]  drivers/media/video/cs5345.ko
  LD [M]  drivers/media/video/cs53l32a.ko
  LD [M]  drivers/media/video/cx18/cx18.ko
  LD [M]  drivers/media/video/cx2341x.ko
  LD [M]  drivers/media/video/cx23885/cx23885.ko
  LD [M]  drivers/media/video/cx25840/cx25840.ko
  LD [M]  drivers/media/video/cx88/cx88-alsa.ko
  LD [M]  drivers/media/video/cx88/cx88-blackbird.ko
  LD [M]  drivers/media/video/cx88/cx88-dvb.ko
  LD [M]  drivers/media/video/cx88/cx8800.ko
  LD [M]  drivers/media/video/cx88/cx8802.ko
  LD [M]  drivers/media/video/cx88/cx88xx.ko
  LD [M]  drivers/media/video/dabusb.ko
  LD [M]  drivers/media/video/gspca/gspca_main.ko
  LD [M]  drivers/media/video/hexium_gemini.ko
  LD [M]  drivers/media/video/hexium_orion.ko
  LD [M]  drivers/media/video/ir-kbd-i2c.ko
  LD [M]  drivers/media/video/ivtv/ivtv.ko
  LD [M]  drivers/media/video/ivtv/ivtvfb.ko
  LD [M]  drivers/media/video/m52790.ko
  LD [M]  drivers/media/video/msp3400.ko
  LD [M]  drivers/media/video/ov7670.ko
  LD [M]  drivers/media/video/saa5246a.ko
  LD [M]  drivers/media/video/saa5249.ko
  LD [M]  drivers/media/video/saa7115.ko
  LD [M]  drivers/media/video/saa7127.ko
  LD [M]  drivers/media/video/saa7134/saa6752hs.ko
  LD [M]  drivers/media/video/saa7134/saa7134-alsa.ko
  LD [M]  drivers/media/video/saa7134/saa7134-dvb.ko
  LD [M]  drivers/media/video/saa7134/saa7134-empress.ko
  LD [M]  drivers/media/video/saa7134/saa7134.ko
  LD [M]  drivers/media/video/saa717x.ko
  LD [M]  drivers/media/video/soc_camera.ko
  LD [M]  drivers/media/video/tcm825x.ko
  LD [M]  drivers/media/video/tda7432.ko
  LD [M]  drivers/media/video/tda9840.ko
  LD [M]  drivers/media/video/tda9875.ko
  LD [M]  drivers/media/video/tea6415c.ko
  LD [M]  drivers/media/video/tlv320aic23b.ko
  LD [M]  drivers/media/video/tuner.ko
  LD [M]  drivers/media/video/tea6420.ko
  LD [M]  drivers/media/video/tvaudio.ko
  LD [M]  drivers/media/video/tveeprom.ko
  LD [M]  drivers/media/video/tvp5150.ko
  LD [M]  drivers/media/video/upd64031a.ko
  LD [M]  drivers/media/video/upd64083.ko
  LD [M]  drivers/media/video/v4l1-compat.ko
  LD [M]  drivers/media/video/v4l2-common.ko
  LD [M]  drivers/media/video/v4l2-int-device.ko
  LD [M]  drivers/media/video/videobuf-core.ko
  LD [M]  drivers/media/video/videobuf-dma-sg.ko
  LD [M]  drivers/media/video/videobuf-dvb.ko
  LD [M]  drivers/media/video/videobuf-vmalloc.ko
  LD [M]  drivers/media/video/videodev.ko
  LD [M]  drivers/media/video/vivi.ko
  LD [M]  drivers/media/video/vp27smpx.ko
  LD [M]  drivers/media/video/wm8739.ko
  LD [M]  drivers/media/video/wm8775.ko
  LD [M]  drivers/message/i2o/i2o_block.ko
  LD [M]  drivers/message/i2o/i2o_bus.ko
  LD [M]  drivers/message/i2o/i2o_core.ko
  LD [M]  drivers/message/i2o/i2o_proc.ko
  LD [M]  drivers/message/i2o/i2o_scsi.ko
  LD [M]  drivers/misc/tifm_core.ko
  LD [M]  drivers/mmc/card/mmc_block.ko
  LD [M]  drivers/mmc/core/mmc_core.ko
  LD [M]  drivers/mmc/host/sdhci.ko
  LD [M]  drivers/mmc/host/tifm_sd.ko
  LD [M]  drivers/mmc/host/wbsd.ko
  LD [M]  drivers/net/8139cp.ko
  LD [M]  drivers/net/8139too.ko
  LD [M]  drivers/net/8390.ko
  LD [M]  drivers/net/dummy.ko
  LD [M]  drivers/net/epic100.ko
  LD [M]  drivers/net/forcedeth.ko
  LD [M]  drivers/net/mii.ko
  LD [M]  drivers/net/ne2k-pci.ko
  LD [M]  drivers/net/sc92031.ko
  LD [M]  drivers/net/sis900.ko
  LD [M]  drivers/net/sundance.ko
  LD [M]  drivers/net/tlan.ko
  LD [M]  drivers/net/via-rhine.ko
  LD [M]  drivers/parport/parport.ko
  LD [M]  drivers/parport/parport_pc.ko
  LD [M]  drivers/scsi/libsas/libsas.ko
  LD [M]  drivers/scsi/scsi_mod.ko
  LD [M]  drivers/scsi/scsi_transport_iscsi.ko
  LD [M]  drivers/scsi/scsi_transport_sas.ko
  LD [M]  drivers/scsi/scsi_transport_spi.ko
  LD [M]  drivers/scsi/scsi_transport_srp.ko
  LD [M]  drivers/scsi/scsi_wait_scan.ko
  LD [M]  drivers/scsi/sd_mod.ko
  LD [M]  drivers/scsi/sg.ko
  LD [M]  drivers/scsi/sr_mod.ko
  LD [M]  drivers/spi/at25.ko
  LD [M]  drivers/spi/spi_bitbang.ko
  LD [M]  drivers/usb/class/usblp.ko
  LD [M]  drivers/usb/host/ehci-hcd.ko
  LD [M]  drivers/usb/host/ohci-hcd.ko
  LD [M]  drivers/usb/host/uhci-hcd.ko
  LD [M]  drivers/usb/serial/belkin_sa.ko
  LD [M]  drivers/usb/serial/ftdi_sio.ko
  LD [M]  drivers/usb/serial/garmin_gps.ko
  LD [M]  drivers/usb/serial/ipaq.ko
  LD [M]  drivers/usb/serial/pl2303.ko
  LD [M]  drivers/usb/serial/usbserial.ko
  LD [M]  drivers/usb/storage/usb-storage.ko
  LD [M]  drivers/video/aty/radeonfb.ko
  LD [M]  drivers/video/cfbcopyarea.ko
  LD [M]  drivers/video/cfbfillrect.ko
  LD [M]  drivers/video/cfbimgblt.ko
  LD [M]  drivers/video/console/bitblit.ko
  LD [M]  drivers/video/console/fbcon.ko
  LD [M]  drivers/video/console/font.ko
  LD [M]  drivers/video/console/softcursor.ko
  LD [M]  drivers/video/console/tileblit.ko
  LD [M]  drivers/video/fb.ko
  LD [M]  drivers/video/fb_ddc.ko
  LD [M]  fs/autofs4/autofs4.ko
  LD [M]  fs/cifs/cifs.ko
  LD [M]  fs/configfs/configfs.ko
  LD [M]  fs/dlm/dlm.ko
  LD [M]  fs/exportfs/exportfs.ko
  LD [M]  fs/ext2/ext2.ko
  LD [M]  fs/ext3/ext3.ko
  LD [M]  fs/fat/fat.ko
  LD [M]  fs/fat/msdos.ko
  LD [M]  fs/fat/vfat.ko
  LD [M]  fs/fuse/fuse.ko
  LD [M]  fs/jbd/jbd.ko
  LD [M]  fs/lockd/lockd.ko
  LD [M]  fs/mbcache.ko
  LD [M]  fs/nfs/nfs.ko
  LD [M]  fs/nfs_common/nfs_acl.ko
  LD [M]  fs/nfsd/nfsd.ko
  LD [M]  fs/nls/nls_cp1250.ko
  LD [M]  fs/nls/nls_cp1251.ko
  LD [M]  fs/nls/nls_cp1255.ko
  LD [M]  fs/nls/nls_cp737.ko
  LD [M]  fs/nls/nls_cp775.ko
  LD [M]  fs/nls/nls_cp850.ko
  LD [M]  fs/nls/nls_cp852.ko
  LD [M]  fs/nls/nls_cp855.ko
  LD [M]  fs/nls/nls_cp857.ko
  LD [M]  fs/nls/nls_cp861.ko
  LD [M]  fs/nls/nls_cp860.ko
  LD [M]  fs/nls/nls_cp862.ko
  LD [M]  fs/nls/nls_cp863.ko
  LD [M]  fs/nls/nls_cp864.ko
  LD [M]  fs/nls/nls_cp865.ko
  LD [M]  fs/nls/nls_cp866.ko
  LD [M]  fs/nls/nls_cp869.ko
  LD [M]  fs/nls/nls_cp874.ko
  LD [M]  fs/nls/nls_cp932.ko
  LD [M]  fs/nls/nls_cp936.ko
  LD [M]  fs/nls/nls_cp949.ko
  LD [M]  fs/nls/nls_cp950.ko
  LD [M]  fs/nls/nls_euc-jp.ko
  LD [M]  fs/nls/nls_iso8859-1.ko
  LD [M]  fs/nls/nls_iso8859-13.ko
  LD [M]  fs/nls/nls_iso8859-14.ko
  LD [M]  fs/nls/nls_iso8859-15.ko
  LD [M]  fs/nls/nls_iso8859-2.ko
  LD [M]  fs/nls/nls_iso8859-3.ko
  LD [M]  fs/nls/nls_iso8859-4.ko
  LD [M]  fs/nls/nls_iso8859-5.ko
  LD [M]  fs/nls/nls_iso8859-6.ko
  LD [M]  fs/nls/nls_iso8859-7.ko
  LD [M]  fs/nls/nls_iso8859-9.ko
  LD [M]  fs/nls/nls_koi8-r.ko
  LD [M]  fs/nls/nls_koi8-u.ko
  LD [M]  fs/nls/nls_koi8-ru.ko
  LD [M]  fs/nls/nls_utf8.ko
  LD [M]  lib/crc-ccitt.ko
  LD [M]  fs/udf/udf.ko
  LD [M]  lib/crc-itu-t.ko
  LD [M]  lib/crc-t10dif.ko
  LD [M]  lib/crc16.ko
  LD [M]  lib/zlib_deflate/zlib_deflate.ko
  LD [M]  net/ipv4/ah4.ko
  LD [M]  net/ipv4/esp4.ko
  LD [M]  net/ipv4/inet_diag.ko
  LD [M]  net/ipv4/inet_lro.ko
  LD [M]  net/ipv4/ipcomp.ko
  LD [M]  net/ipv4/tcp_diag.ko
  LD [M]  net/ipv4/tunnel4.ko
  LD [M]  net/ipv4/xfrm4_mode_beet.ko
  LD [M]  net/ipv4/xfrm4_mode_transport.ko
  LD [M]  net/ipv4/xfrm4_mode_tunnel.ko
  LD [M]  net/ipv4/xfrm4_tunnel.ko
  LD [M]  net/key/af_key.ko
  LD [M]  net/sctp/sctp.ko
  LD [M]  net/sunrpc/auth_gss/auth_rpcgss.ko
  LD [M]  net/sunrpc/auth_gss/rpcsec_gss_krb5.ko
  LD [M]  net/sunrpc/auth_gss/rpcsec_gss_spkm3.ko
  LD [M]  net/sunrpc/sunrpc.ko
  LD [M]  net/xfrm/xfrm_ipcomp.ko
  LD [M]  sound/ac97_bus.ko
  LD [M]  sound/core/oss/snd-mixer-oss.ko
  LD [M]  sound/core/oss/snd-pcm-oss.ko
  LD [M]  sound/core/seq/oss/snd-seq-oss.ko
  LD [M]  sound/core/seq/snd-seq-device.ko
  LD [M]  sound/core/seq/snd-seq-dummy.ko
  LD [M]  sound/core/seq/snd-seq-midi-emul.ko
  LD [M]  sound/core/seq/snd-seq-midi-event.ko
  LD [M]  sound/core/seq/snd-seq-midi.ko
  LD [M]  sound/core/seq/snd-seq-virmidi.ko
  LD [M]  sound/core/snd-hwdep.ko
  LD [M]  sound/core/seq/snd-seq.ko
  LD [M]  sound/core/snd-page-alloc.ko
  LD [M]  sound/core/snd-pcm.ko
  LD [M]  sound/core/snd-rawmidi.ko
  LD [M]  sound/core/snd-rtctimer.ko
  LD [M]  sound/core/snd-timer.ko
  LD [M]  sound/core/snd.ko
  LD [M]  sound/drivers/mpu401/snd-mpu401-uart.ko
  LD [M]  sound/drivers/mpu401/snd-mpu401.ko
  LD [M]  sound/drivers/opl3/snd-opl3-lib.ko
  LD [M]  sound/drivers/opl3/snd-opl3-synth.ko
  LD [M]  sound/drivers/snd-dummy.ko
  LD [M]  sound/drivers/snd-serial-u16550.ko
  LD [M]  sound/drivers/snd-virmidi.ko
  LD [M]  sound/pci/ac97/snd-ac97-codec.ko
  LD [M]  sound/pci/emu10k1/snd-emu10k1-synth.ko
  LD [M]  sound/pci/emu10k1/snd-emu10k1.ko
  LD [M]  sound/pci/hda/snd-hda-codec-analog.ko
  LD [M]  sound/pci/hda/snd-hda-codec-atihdmi.ko
  LD [M]  sound/pci/hda/snd-hda-codec-cmedia.ko
  LD [M]  sound/pci/hda/snd-hda-codec-conexant.ko
  LD [M]  sound/pci/hda/snd-hda-codec-idt.ko
  LD [M]  sound/pci/hda/snd-hda-codec-intelhdmi.ko
  LD [M]  sound/pci/hda/snd-hda-codec-nvhdmi.ko
  LD [M]  sound/pci/hda/snd-hda-codec-realtek.ko
  LD [M]  sound/pci/hda/snd-hda-codec-si3054.ko
  LD [M]  sound/pci/hda/snd-hda-codec-via.ko
  LD [M]  sound/pci/hda/snd-hda-codec.ko
  LD [M]  sound/pci/hda/snd-hda-intel.ko
  LD [M]  sound/pci/oxygen/snd-oxygen-lib.ko
  LD [M]  sound/pci/oxygen/snd-virtuoso.ko
  LD [M]  sound/pci/riptide/snd-riptide.ko
  LD [M]  sound/pci/snd-atiixp.ko
  LD [M]  sound/pci/snd-bt87x.ko
  LD [M]  sound/pci/snd-intel8x0.ko
  LD [M]  sound/soundcore.ko
  LD [M]  sound/synth/emux/snd-emux-synth.ko
  LD [M]  sound/synth/snd-util-mem.ko
  IHEX2FW firmware/dabusb/firmware.fw
  IHEX    firmware/dabusb/bitstream.bin

removeing /boot/vmlinuz-2.6.29-rc1-old
touching vmlinuz-2.6.29-rc1
mv-ing /boot/vmlinuz-2.6.29-rc1 /boot/vmlinuz-2.6.29-rc1-old
copying bzImage to /boot/vmlinuz-2.6.29-rc1
removeing old lib/modules/2.6.29-rc1.old
touching /lib/modules/2.6.29-rc1
moving /lib/modules/2.6.29-rc1 to /lib/modules/2.6.29-rc1.old
cleaning up in /boot
saveing the System.map-2.6.29-rc1 to System.map-2.6.29-rc1.old
copying in new System.map
cd-ing to /boot
doing the link of System.map-2.6.29-rc1 to System.map
cd-ing back to /usr/src/linux-2.6.29-rc1 to do the modules_install
make modules_install
  INSTALL arch/x86/crypto/aes-i586.ko
  INSTALL arch/x86/crypto/twofish-i586.ko
  INSTALL arch/x86/video/fbdev.ko
  INSTALL crypto/aes_generic.ko
  INSTALL crypto/anubis.ko
  INSTALL crypto/arc4.ko
  INSTALL crypto/authenc.ko
  INSTALL crypto/blowfish.ko
  INSTALL crypto/camellia.ko
  INSTALL crypto/cast5.ko
  INSTALL crypto/cast6.ko
  INSTALL crypto/cbc.ko
  INSTALL crypto/crypto_null.ko
  INSTALL crypto/deflate.ko
  INSTALL crypto/des_generic.ko
  INSTALL crypto/ecb.ko
  INSTALL crypto/fcrypt.ko
  INSTALL crypto/gf128mul.ko
  INSTALL crypto/khazad.ko
  INSTALL crypto/lrw.ko
  INSTALL crypto/md4.ko
  INSTALL crypto/michael_mic.ko
  INSTALL crypto/pcbc.ko
  INSTALL crypto/serpent.ko
  INSTALL crypto/sha256_generic.ko
  INSTALL crypto/sha512_generic.ko
  INSTALL crypto/tcrypt.ko
  INSTALL crypto/tea.ko
  INSTALL crypto/tgr192.ko
  INSTALL crypto/twofish_common.ko
  INSTALL crypto/twofish.ko
  INSTALL crypto/wp512.ko
  INSTALL crypto/xcbc.ko
  INSTALL drivers/acpi/button.ko
  INSTALL drivers/ata/ahci.ko
  INSTALL drivers/ata/ata_generic.ko
  INSTALL drivers/ata/libata.ko
  INSTALL drivers/ata/pata_acpi.ko
  INSTALL drivers/ata/pata_amd.ko
  INSTALL drivers/ata/pata_jmicron.ko
  INSTALL drivers/ata/pata_sil680.ko
  INSTALL drivers/ata/sata_nv.ko
  INSTALL drivers/ata/sata_sil.ko
  INSTALL drivers/block/cryptoloop.ko
  INSTALL drivers/block/floppy.ko
  INSTALL drivers/block/loop.ko
  INSTALL drivers/block/nbd.ko
  INSTALL drivers/block/pktcdvd.ko
  INSTALL drivers/cdrom/cdrom.ko
  INSTALL drivers/char/agp/agpgart.ko
  INSTALL drivers/char/agp/amd-k7-agp.ko
  INSTALL drivers/char/agp/amd64-agp.ko
  INSTALL drivers/char/agp/ati-agp.ko
  INSTALL drivers/char/agp/nvidia-agp.ko
  INSTALL drivers/char/agp/via-agp.ko
  INSTALL drivers/char/hw_random/amd-rng.ko
  INSTALL drivers/char/ipmi/ipmi_devintf.ko
  INSTALL drivers/char/ipmi/ipmi_msghandler.ko
  INSTALL drivers/char/ipmi/ipmi_poweroff.ko
  INSTALL drivers/char/ipmi/ipmi_si.ko
  INSTALL drivers/char/ipmi/ipmi_watchdog.ko
  INSTALL drivers/firewire/firewire-core.ko
  INSTALL drivers/firewire/firewire-ohci.ko
  INSTALL drivers/firewire/firewire-sbp2.ko
  INSTALL drivers/firmware/edd.ko
  INSTALL drivers/gpu/drm/drm.ko
  INSTALL drivers/gpu/drm/radeon/radeon.ko
  INSTALL drivers/hid/hid-dummy.ko
  INSTALL drivers/hwmon/hwmon-vid.ko
  INSTALL drivers/hwmon/hwmon.ko
  INSTALL drivers/hwmon/it87.ko
  INSTALL drivers/hwmon/w83627hf.ko
  INSTALL drivers/i2c/algos/i2c-algo-bit.ko
  INSTALL drivers/i2c/busses/i2c-amd756.ko
  INSTALL drivers/i2c/busses/i2c-nforce2.ko
  INSTALL drivers/i2c/chips/eeprom.ko
  INSTALL drivers/i2c/i2c-core.ko
  INSTALL drivers/i2c/i2c-dev.ko
  INSTALL drivers/input/evdev.ko
  INSTALL drivers/input/gameport/emu10k1-gp.ko
  INSTALL drivers/input/gameport/gameport.ko
  INSTALL drivers/input/joydev.ko
  INSTALL drivers/input/gameport/ns558.ko
  INSTALL drivers/input/misc/pcspkr.ko
  INSTALL drivers/media/common/ir-common.ko
  INSTALL drivers/media/common/saa7146.ko
  INSTALL drivers/media/common/saa7146_vv.ko
  INSTALL drivers/media/common/tuners/mxl5007t.ko
  INSTALL drivers/media/common/tuners/tda18271.ko
  INSTALL drivers/media/common/tuners/tda827x.ko
  INSTALL drivers/media/common/tuners/tda8290.ko
  INSTALL drivers/media/common/tuners/tda9887.ko
  INSTALL drivers/media/common/tuners/tuner-simple.ko
  INSTALL drivers/media/common/tuners/tuner-types.ko
  INSTALL drivers/media/common/tuners/tuner-xc2028.ko
  INSTALL drivers/media/common/tuners/xc5000.ko
  INSTALL drivers/media/dvb/dvb-core/dvb-core.ko
  INSTALL drivers/media/dvb/frontends/af9013.ko
  INSTALL drivers/media/dvb/frontends/au8522.ko
  INSTALL drivers/media/dvb/frontends/bcm3510.ko
  INSTALL drivers/media/dvb/frontends/cx24113.ko
  INSTALL drivers/media/dvb/frontends/dib0070.ko
  INSTALL drivers/media/dvb/frontends/dvb-pll.ko
  INSTALL drivers/media/dvb/frontends/isl6405.ko
  INSTALL drivers/media/dvb/frontends/isl6421.ko
  INSTALL drivers/media/dvb/frontends/lgdt3304.ko
  INSTALL drivers/media/dvb/frontends/lgdt330x.ko
  INSTALL drivers/media/dvb/frontends/lgs8gl5.ko
  INSTALL drivers/media/dvb/frontends/lnbp21.ko
  INSTALL drivers/media/dvb/frontends/or51132.ko
  INSTALL drivers/media/dvb/frontends/s5h1409.ko
  INSTALL drivers/media/dvb/frontends/s5h1411.ko
  INSTALL drivers/media/dvb/frontends/s921.ko
  INSTALL drivers/media/dvb/frontends/stb0899.ko
  INSTALL drivers/media/dvb/frontends/stb6100.ko
  INSTALL drivers/media/dvb/frontends/tda10021.ko
  INSTALL drivers/media/dvb/frontends/tda10023.ko
  INSTALL drivers/media/dvb/frontends/tda10048.ko
  INSTALL drivers/media/dvb/frontends/tda1004x.ko
  INSTALL drivers/media/dvb/frontends/tda10086.ko
  INSTALL drivers/media/dvb/frontends/tda8083.ko
  INSTALL drivers/media/dvb/frontends/tda8261.ko
  INSTALL drivers/media/dvb/frontends/tua6100.ko
  INSTALL drivers/media/dvb/ttpci/dvb-ttpci.ko
  INSTALL drivers/media/dvb/ttpci/ttpci-eeprom.ko
  INSTALL drivers/media/video/au0828/au0828.ko
  INSTALL drivers/media/video/btcx-risc.ko
  INSTALL drivers/media/video/cafe_ccic.ko
  INSTALL drivers/media/video/cs53l32a.ko
  INSTALL drivers/media/video/cx18/cx18.ko
  INSTALL drivers/media/video/cs5345.ko
  INSTALL drivers/media/video/cx2341x.ko
  INSTALL drivers/media/video/cx23885/cx23885.ko
  INSTALL drivers/media/video/cx25840/cx25840.ko
  INSTALL drivers/media/video/cx88/cx88-alsa.ko
  INSTALL drivers/media/video/cx88/cx88-blackbird.ko
  INSTALL drivers/media/video/cx88/cx88-dvb.ko
  INSTALL drivers/media/video/cx88/cx8800.ko
  INSTALL drivers/media/video/cx88/cx8802.ko
  INSTALL drivers/media/video/cx88/cx88xx.ko
  INSTALL drivers/media/video/dabusb.ko
  INSTALL drivers/media/video/gspca/gspca_main.ko
  INSTALL drivers/media/video/hexium_gemini.ko
  INSTALL drivers/media/video/hexium_orion.ko
  INSTALL drivers/media/video/ir-kbd-i2c.ko
  INSTALL drivers/media/video/ivtv/ivtv.ko
  INSTALL drivers/media/video/ivtv/ivtvfb.ko
  INSTALL drivers/media/video/m52790.ko
  INSTALL drivers/media/video/msp3400.ko
  INSTALL drivers/media/video/ov7670.ko
  INSTALL drivers/media/video/saa5246a.ko
  INSTALL drivers/media/video/saa5249.ko
  INSTALL drivers/media/video/saa7115.ko
  INSTALL drivers/media/video/saa7127.ko
  INSTALL drivers/media/video/saa7134/saa6752hs.ko
  INSTALL drivers/media/video/saa7134/saa7134-alsa.ko
  INSTALL drivers/media/video/saa7134/saa7134-dvb.ko
  INSTALL drivers/media/video/saa7134/saa7134-empress.ko
  INSTALL drivers/media/video/saa7134/saa7134.ko
  INSTALL drivers/media/video/saa717x.ko
  INSTALL drivers/media/video/soc_camera.ko
  INSTALL drivers/media/video/tcm825x.ko
  INSTALL drivers/media/video/tda7432.ko
  INSTALL drivers/media/video/tda9840.ko
  INSTALL drivers/media/video/tda9875.ko
  INSTALL drivers/media/video/tea6415c.ko
  INSTALL drivers/media/video/tea6420.ko
  INSTALL drivers/media/video/tlv320aic23b.ko
  INSTALL drivers/media/video/tuner.ko
  INSTALL drivers/media/video/tvaudio.ko
  INSTALL drivers/media/video/tveeprom.ko
  INSTALL drivers/media/video/tvp5150.ko
  INSTALL drivers/media/video/upd64031a.ko
  INSTALL drivers/media/video/upd64083.ko
  INSTALL drivers/media/video/v4l1-compat.ko
  INSTALL drivers/media/video/v4l2-common.ko
  INSTALL drivers/media/video/v4l2-int-device.ko
  INSTALL drivers/media/video/videobuf-core.ko
  INSTALL drivers/media/video/videobuf-dma-sg.ko
  INSTALL drivers/media/video/videobuf-dvb.ko
  INSTALL drivers/media/video/videobuf-vmalloc.ko
  INSTALL drivers/media/video/videodev.ko
  INSTALL drivers/media/video/vivi.ko
  INSTALL drivers/media/video/vp27smpx.ko
  INSTALL drivers/media/video/wm8739.ko
  INSTALL drivers/media/video/wm8775.ko
  INSTALL drivers/message/i2o/i2o_block.ko
  INSTALL drivers/message/i2o/i2o_bus.ko
  INSTALL drivers/message/i2o/i2o_core.ko
  INSTALL drivers/message/i2o/i2o_proc.ko
  INSTALL drivers/message/i2o/i2o_scsi.ko
  INSTALL drivers/misc/tifm_core.ko
  INSTALL drivers/mmc/card/mmc_block.ko
  INSTALL drivers/mmc/core/mmc_core.ko
  INSTALL drivers/mmc/host/sdhci.ko
  INSTALL drivers/mmc/host/tifm_sd.ko
  INSTALL drivers/mmc/host/wbsd.ko
  INSTALL drivers/net/8139cp.ko
  INSTALL drivers/net/8139too.ko
  INSTALL drivers/net/8390.ko
  INSTALL drivers/net/dummy.ko
  INSTALL drivers/net/epic100.ko
  INSTALL drivers/net/forcedeth.ko
  INSTALL drivers/net/mii.ko
  INSTALL drivers/net/ne2k-pci.ko
  INSTALL drivers/net/sc92031.ko
  INSTALL drivers/net/sis900.ko
  INSTALL drivers/net/sundance.ko
  INSTALL drivers/net/tlan.ko
  INSTALL drivers/net/via-rhine.ko
  INSTALL drivers/parport/parport.ko
  INSTALL drivers/parport/parport_pc.ko
  INSTALL drivers/scsi/libsas/libsas.ko
  INSTALL drivers/scsi/scsi_mod.ko
  INSTALL drivers/scsi/scsi_transport_iscsi.ko
  INSTALL drivers/scsi/scsi_transport_sas.ko
  INSTALL drivers/scsi/scsi_transport_spi.ko
  INSTALL drivers/scsi/scsi_transport_srp.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko
  INSTALL drivers/scsi/sd_mod.ko
  INSTALL drivers/scsi/sg.ko
  INSTALL drivers/scsi/sr_mod.ko
  INSTALL drivers/spi/at25.ko
  INSTALL drivers/spi/spi_bitbang.ko
  INSTALL drivers/usb/class/usblp.ko
  INSTALL drivers/usb/host/ehci-hcd.ko
  INSTALL drivers/usb/host/ohci-hcd.ko
  INSTALL drivers/usb/host/uhci-hcd.ko
  INSTALL drivers/usb/serial/belkin_sa.ko
  INSTALL drivers/usb/serial/ftdi_sio.ko
  INSTALL drivers/usb/serial/garmin_gps.ko
  INSTALL drivers/usb/serial/ipaq.ko
  INSTALL drivers/usb/serial/pl2303.ko
  INSTALL drivers/usb/serial/usbserial.ko
  INSTALL drivers/usb/storage/usb-storage.ko
  INSTALL drivers/video/aty/radeonfb.ko
  INSTALL drivers/video/cfbcopyarea.ko
  INSTALL drivers/video/cfbfillrect.ko
  INSTALL drivers/video/cfbimgblt.ko
  INSTALL drivers/video/console/bitblit.ko
  INSTALL drivers/video/console/fbcon.ko
  INSTALL drivers/video/console/font.ko
  INSTALL drivers/video/console/softcursor.ko
  INSTALL drivers/video/console/tileblit.ko
  INSTALL drivers/video/fb.ko
  INSTALL drivers/video/fb_ddc.ko
  INSTALL fs/autofs4/autofs4.ko
  INSTALL fs/cifs/cifs.ko
  INSTALL fs/configfs/configfs.ko
  INSTALL fs/dlm/dlm.ko
  INSTALL fs/exportfs/exportfs.ko
  INSTALL fs/ext2/ext2.ko
  INSTALL fs/ext3/ext3.ko
  INSTALL fs/fat/fat.ko
  INSTALL fs/fat/msdos.ko
  INSTALL fs/fat/vfat.ko
  INSTALL fs/fuse/fuse.ko
  INSTALL fs/jbd/jbd.ko
  INSTALL fs/lockd/lockd.ko
  INSTALL fs/mbcache.ko
  INSTALL fs/nfs/nfs.ko
  INSTALL fs/nfs_common/nfs_acl.ko
  INSTALL fs/nfsd/nfsd.ko
  INSTALL fs/nls/nls_cp1250.ko
  INSTALL fs/nls/nls_cp1251.ko
  INSTALL fs/nls/nls_cp737.ko
  INSTALL fs/nls/nls_cp1255.ko
  INSTALL fs/nls/nls_cp775.ko
  INSTALL fs/nls/nls_cp850.ko
  INSTALL fs/nls/nls_cp852.ko
  INSTALL fs/nls/nls_cp855.ko
  INSTALL fs/nls/nls_cp857.ko
  INSTALL fs/nls/nls_cp860.ko
  INSTALL fs/nls/nls_cp861.ko
  INSTALL fs/nls/nls_cp862.ko
  INSTALL fs/nls/nls_cp863.ko
  INSTALL fs/nls/nls_cp864.ko
  INSTALL fs/nls/nls_cp865.ko
  INSTALL fs/nls/nls_cp866.ko
  INSTALL fs/nls/nls_cp869.ko
  INSTALL fs/nls/nls_cp874.ko
  INSTALL fs/nls/nls_cp932.ko
  INSTALL fs/nls/nls_cp936.ko
  INSTALL fs/nls/nls_cp949.ko
  INSTALL fs/nls/nls_cp950.ko
  INSTALL fs/nls/nls_euc-jp.ko
  INSTALL fs/nls/nls_iso8859-1.ko
  INSTALL fs/nls/nls_iso8859-13.ko
  INSTALL fs/nls/nls_iso8859-14.ko
  INSTALL fs/nls/nls_iso8859-15.ko
  INSTALL fs/nls/nls_iso8859-2.ko
  INSTALL fs/nls/nls_iso8859-3.ko
  INSTALL fs/nls/nls_iso8859-5.ko
  INSTALL fs/nls/nls_iso8859-4.ko
  INSTALL fs/nls/nls_iso8859-6.ko
  INSTALL fs/nls/nls_iso8859-9.ko
  INSTALL fs/nls/nls_iso8859-7.ko
  INSTALL fs/nls/nls_koi8-r.ko
  INSTALL fs/nls/nls_koi8-ru.ko
  INSTALL fs/nls/nls_koi8-u.ko
  INSTALL fs/nls/nls_utf8.ko
  INSTALL fs/udf/udf.ko
  INSTALL lib/crc-ccitt.ko
  INSTALL lib/crc-itu-t.ko
  INSTALL lib/crc-t10dif.ko
  INSTALL lib/crc16.ko
  INSTALL lib/zlib_deflate/zlib_deflate.ko
  INSTALL net/ipv4/ah4.ko
  INSTALL net/ipv4/esp4.ko
  INSTALL net/ipv4/inet_diag.ko
  INSTALL net/ipv4/ipcomp.ko
  INSTALL net/ipv4/inet_lro.ko
  INSTALL net/ipv4/tcp_diag.ko
  INSTALL net/ipv4/tunnel4.ko
  INSTALL net/ipv4/xfrm4_mode_beet.ko
  INSTALL net/ipv4/xfrm4_mode_transport.ko
  INSTALL net/ipv4/xfrm4_mode_tunnel.ko
  INSTALL net/ipv4/xfrm4_tunnel.ko
  INSTALL net/key/af_key.ko
  INSTALL net/sctp/sctp.ko
  INSTALL net/sunrpc/auth_gss/auth_rpcgss.ko
  INSTALL net/sunrpc/auth_gss/rpcsec_gss_krb5.ko
  INSTALL net/sunrpc/auth_gss/rpcsec_gss_spkm3.ko
  INSTALL net/sunrpc/sunrpc.ko
  INSTALL net/xfrm/xfrm_ipcomp.ko
  INSTALL sound/ac97_bus.ko
  INSTALL sound/core/oss/snd-mixer-oss.ko
  INSTALL sound/core/oss/snd-pcm-oss.ko
  INSTALL sound/core/seq/oss/snd-seq-oss.ko
  INSTALL sound/core/seq/snd-seq-device.ko
  INSTALL sound/core/seq/snd-seq-dummy.ko
  INSTALL sound/core/seq/snd-seq-midi-emul.ko
  INSTALL sound/core/seq/snd-seq-midi-event.ko
  INSTALL sound/core/seq/snd-seq-midi.ko
  INSTALL sound/core/seq/snd-seq-virmidi.ko
  INSTALL sound/core/seq/snd-seq.ko
  INSTALL sound/core/snd-hwdep.ko
  INSTALL sound/core/snd-page-alloc.ko
  INSTALL sound/core/snd-pcm.ko
  INSTALL sound/core/snd-rawmidi.ko
  INSTALL sound/core/snd-rtctimer.ko
  INSTALL sound/core/snd-timer.ko
  INSTALL sound/core/snd.ko
  INSTALL sound/drivers/mpu401/snd-mpu401-uart.ko
  INSTALL sound/drivers/mpu401/snd-mpu401.ko
  INSTALL sound/drivers/opl3/snd-opl3-synth.ko
  INSTALL sound/drivers/opl3/snd-opl3-lib.ko
  INSTALL sound/drivers/snd-dummy.ko
  INSTALL sound/drivers/snd-serial-u16550.ko
  INSTALL sound/drivers/snd-virmidi.ko
  INSTALL sound/pci/ac97/snd-ac97-codec.ko
  INSTALL sound/pci/emu10k1/snd-emu10k1-synth.ko
  INSTALL sound/pci/emu10k1/snd-emu10k1.ko
  INSTALL sound/pci/hda/snd-hda-codec-analog.ko
  INSTALL sound/pci/hda/snd-hda-codec-atihdmi.ko
  INSTALL sound/pci/hda/snd-hda-codec-cmedia.ko
  INSTALL sound/pci/hda/snd-hda-codec-conexant.ko
  INSTALL sound/pci/hda/snd-hda-codec-idt.ko
  INSTALL sound/pci/hda/snd-hda-codec-intelhdmi.ko
  INSTALL sound/pci/hda/snd-hda-codec-nvhdmi.ko
  INSTALL sound/pci/hda/snd-hda-codec-realtek.ko
  INSTALL sound/pci/hda/snd-hda-codec-si3054.ko
  INSTALL sound/pci/hda/snd-hda-codec-via.ko
  INSTALL sound/pci/hda/snd-hda-codec.ko
  INSTALL sound/pci/hda/snd-hda-intel.ko
  INSTALL sound/pci/oxygen/snd-oxygen-lib.ko
  INSTALL sound/pci/oxygen/snd-virtuoso.ko
  INSTALL sound/pci/riptide/snd-riptide.ko
  INSTALL sound/pci/snd-atiixp.ko
  INSTALL sound/pci/snd-bt87x.ko
  INSTALL sound/pci/snd-intel8x0.ko
  INSTALL sound/soundcore.ko
  INSTALL sound/synth/emux/snd-emux-synth.ko
  INSTALL sound/synth/snd-util-mem.ko
  INSTALL /lib/firmware/dabusb/firmware.fw
  INSTALL /lib/firmware/dabusb/bitstream.bin
  DEPMOD  2.6.29-rc1
now making a new initrd.2.6.29-rc1.img
and copying it to /boot/initrd-2.6.29-rc1.img
  IHEX    firmware/acenic/tg1.bin
  MKDIR   /lib/firmware/acenic
  INSTALL /lib/firmware/acenic/tg1.bin
  IHEX    firmware/acenic/tg2.bin
  INSTALL /lib/firmware/acenic/tg2.bin
  IHEX    firmware/adaptec/starfire_rx.bin
  MKDIR   /lib/firmware/adaptec
  INSTALL /lib/firmware/adaptec/starfire_rx.bin
  IHEX    firmware/adaptec/starfire_tx.bin
  INSTALL /lib/firmware/adaptec/starfire_tx.bin
  IHEX    firmware/dsp56k/bootstrap.bin
  INSTALL /lib/firmware/dsp56k/bootstrap.bin
  IHEX2FW firmware/atmsar11.fw
  INSTALL /lib/firmware/atmsar11.fw
  IHEX    firmware/sun/cassini.bin
  INSTALL /lib/firmware/sun/cassini.bin
  IHEX    firmware/intelliport2.bin
  INSTALL /lib/firmware/intelliport2.bin
  IHEX    firmware/cxgb3/t3b_psram-1.1.0.bin
  MKDIR   /lib/firmware/cxgb3
  INSTALL /lib/firmware/cxgb3/t3b_psram-1.1.0.bin
  IHEX    firmware/cxgb3/t3c_psram-1.1.0.bin
  INSTALL /lib/firmware/cxgb3/t3c_psram-1.1.0.bin
  IHEX    firmware/cxgb3/t3fw-7.0.0.bin
  INSTALL /lib/firmware/cxgb3/t3fw-7.0.0.bin
  IHEX    firmware/ttusb-budget/dspbootcode.bin
  INSTALL /lib/firmware/ttusb-budget/dspbootcode.bin
  IHEX    firmware/e100/d101m_ucode.bin
  MKDIR   /lib/firmware/e100
  INSTALL /lib/firmware/e100/d101m_ucode.bin
  IHEX    firmware/e100/d101s_ucode.bin
  INSTALL /lib/firmware/e100/d101s_ucode.bin
  IHEX    firmware/e100/d102e_ucode.bin
  INSTALL /lib/firmware/e100/d102e_ucode.bin
  IHEX    firmware/tr_smctr.bin
  INSTALL /lib/firmware/tr_smctr.bin
  IHEX    firmware/korg/k1212.dsp
  INSTALL /lib/firmware/korg/k1212.dsp
  IHEX    firmware/ess/maestro3_assp_kernel.fw
  INSTALL /lib/firmware/ess/maestro3_assp_kernel.fw
  IHEX    firmware/ess/maestro3_assp_minisrc.fw
  INSTALL /lib/firmware/ess/maestro3_assp_minisrc.fw
  IHEX    firmware/sb16/mulaw_main.csp
  INSTALL /lib/firmware/sb16/mulaw_main.csp
  IHEX    firmware/sb16/alaw_main.csp
  INSTALL /lib/firmware/sb16/alaw_main.csp
  IHEX    firmware/sb16/ima_adpcm_init.csp
  INSTALL /lib/firmware/sb16/ima_adpcm_init.csp
  IHEX    firmware/sb16/ima_adpcm_playback.csp
  INSTALL /lib/firmware/sb16/ima_adpcm_playback.csp
  IHEX    firmware/sb16/ima_adpcm_capture.csp
  INSTALL /lib/firmware/sb16/ima_adpcm_capture.csp
  IHEX    firmware/yamaha/ds1_ctrl.fw
  INSTALL /lib/firmware/yamaha/ds1_ctrl.fw
  IHEX    firmware/yamaha/ds1_dsp.fw
  INSTALL /lib/firmware/yamaha/ds1_dsp.fw
  IHEX    firmware/yamaha/ds1e_ctrl.fw
  INSTALL /lib/firmware/yamaha/ds1e_ctrl.fw
  IHEX    firmware/tigon/tg3.bin
  MKDIR   /lib/firmware/tigon
  INSTALL /lib/firmware/tigon/tg3.bin
  IHEX    firmware/tigon/tg3_tso.bin
  INSTALL /lib/firmware/tigon/tg3_tso.bin
  IHEX    firmware/tigon/tg3_tso5.bin
  INSTALL /lib/firmware/tigon/tg3_tso5.bin
  IHEX2FW firmware/emi26/loader.fw
  INSTALL /lib/firmware/emi26/loader.fw
  IHEX2FW firmware/emi26/firmware.fw
  INSTALL /lib/firmware/emi26/firmware.fw
  IHEX2FW firmware/emi26/bitstream.fw
  INSTALL /lib/firmware/emi26/bitstream.fw
  IHEX2FW firmware/emi62/loader.fw
  INSTALL /lib/firmware/emi62/loader.fw
  IHEX2FW firmware/emi62/bitstream.fw
  INSTALL /lib/firmware/emi62/bitstream.fw
  IHEX2FW firmware/emi62/spdif.fw
  INSTALL /lib/firmware/emi62/spdif.fw
  IHEX2FW firmware/emi62/midi.fw
  INSTALL /lib/firmware/emi62/midi.fw
  IHEX    firmware/kaweth/new_code.bin
  INSTALL /lib/firmware/kaweth/new_code.bin
  IHEX    firmware/kaweth/trigger_code.bin
  INSTALL /lib/firmware/kaweth/trigger_code.bin
  IHEX    firmware/kaweth/new_code_fix.bin
  INSTALL /lib/firmware/kaweth/new_code_fix.bin
  IHEX    firmware/kaweth/trigger_code_fix.bin
  INSTALL /lib/firmware/kaweth/trigger_code_fix.bin
  IHEX2FW firmware/keyspan/mpr.fw
  INSTALL /lib/firmware/keyspan/mpr.fw
  IHEX2FW firmware/keyspan/usa18x.fw
  INSTALL /lib/firmware/keyspan/usa18x.fw
  IHEX2FW firmware/keyspan/usa19.fw
  INSTALL /lib/firmware/keyspan/usa19.fw
  IHEX2FW firmware/keyspan/usa19qi.fw
  INSTALL /lib/firmware/keyspan/usa19qi.fw
  IHEX2FW firmware/keyspan/usa19qw.fw
  INSTALL /lib/firmware/keyspan/usa19qw.fw
  IHEX2FW firmware/keyspan/usa19w.fw
  INSTALL /lib/firmware/keyspan/usa19w.fw
  IHEX2FW firmware/keyspan/usa28.fw
  INSTALL /lib/firmware/keyspan/usa28.fw
  IHEX2FW firmware/keyspan/usa28xa.fw
  INSTALL /lib/firmware/keyspan/usa28xa.fw
  IHEX2FW firmware/keyspan/usa28xb.fw
  INSTALL /lib/firmware/keyspan/usa28xb.fw
  IHEX2FW firmware/keyspan/usa28x.fw
  INSTALL /lib/firmware/keyspan/usa28x.fw
  IHEX2FW firmware/keyspan/usa49w.fw
  INSTALL /lib/firmware/keyspan/usa49w.fw
  IHEX2FW firmware/keyspan/usa49wlc.fw
  INSTALL /lib/firmware/keyspan/usa49wlc.fw
  IHEX    firmware/ti_3410.fw
  INSTALL /lib/firmware/ti_3410.fw
  IHEX    firmware/ti_5052.fw
  INSTALL /lib/firmware/ti_5052.fw
  H16TOFW firmware/edgeport/boot.fw
  INSTALL /lib/firmware/edgeport/boot.fw
  H16TOFW firmware/edgeport/boot2.fw
  INSTALL /lib/firmware/edgeport/boot2.fw
  H16TOFW firmware/edgeport/down.fw
  INSTALL /lib/firmware/edgeport/down.fw
  H16TOFW firmware/edgeport/down2.fw
  INSTALL /lib/firmware/edgeport/down2.fw
  IHEX    firmware/edgeport/down3.bin
  INSTALL /lib/firmware/edgeport/down3.bin
  IHEX2FW firmware/whiteheat_loader.fw
  INSTALL /lib/firmware/whiteheat_loader.fw
  IHEX2FW firmware/whiteheat.fw
  INSTALL /lib/firmware/whiteheat.fw
  IHEX2FW firmware/keyspan_pda/keyspan_pda.fw
  INSTALL /lib/firmware/keyspan_pda/keyspan_pda.fw
  IHEX2FW firmware/keyspan_pda/xircom_pgs.fw
  INSTALL /lib/firmware/keyspan_pda/xircom_pgs.fw
  H16TOFW firmware/vicam/firmware.fw
  INSTALL /lib/firmware/vicam/firmware.fw
  IHEX    firmware/cpia2/stv0672_vp4.bin
  INSTALL /lib/firmware/cpia2/stv0672_vp4.bin
-rw-r--r-- 1 root root   13607 2009-01-11 11:57 config-2.6.29-rc1.gz
-rw-r--r-- 1 root root       0 2009-01-11 11:57 config-2.6.29-rc1.gz.old
All done! Edit grub.conf, reboot and chose your kernel at the grub prompt

real    4m46.587s
user    10m31.006s
sys     1m13.060s
==========================

Gotta love ccache :-)
I note that it is no longer installing firmware/radeon/stuff but it isn't 
loading whats there from previous builds either.  I'm not building it in.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Ada is PL/I trying to be Smalltalk.
-- Codoso diBlini
