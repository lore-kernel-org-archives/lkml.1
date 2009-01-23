Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZAWVsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZAWVsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 16:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZAWVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 16:47:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:17307 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZAWVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 16:47:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=cB80epve5GUiKL2tgE8iIjs2Loo0PkHF7yIqjUzD7yGoRs5ETjuCTQx+CMT3XKeVMt
         U3RTIWSH3tOHZctFYwSLjA4eg9SjpH3JVzSKxS4u8elt+6DKNG7wQSE4Pk4iiHVcsL38
         B46kEmO0iIb1cw+GckQeUwv46N+CICY2FmpLw=
Message-ID: <497A3ABD.5060708@gmail.com>
Date: Fri, 23 Jan 2009 14:46:37 -0700
From: Richard Holden <aciddeath@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 23 (9pnet_rdma)
References: <20090123184826.f2c91472.sfr@canb.auug.org.au>
In-Reply-To: <20090123184826.f2c91472.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------090100060202050504070308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090100060202050504070308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Stephen Rothwell wrote:
> Hi all,
> 
> News:  I will be on leave next week, so there will probably be no
> linux-next release until Feb 2.

Error in net/9p caused by CONFIG_NET_9P =y and CONFIG_NET_9P_RDMA=m:
CONFIG_NET_9P_RDMA is tristate, depending on infiniband which is a module.

Config and log attached.
ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!



--------------090100060202050504070308
Content-Type: text/plain;
 name="make-randconfig-13.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="make-randconfig-13.log"

scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
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
  CC      init/main.o
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  CC      init/do_mounts.o
  CC      init/do_mounts_initrd.o
  LD      init/mounts.o
  CC      init/initramfs.o
  CC      init/calibrate.o
  LD      init/built-in.o
  HOSTCC  usr/gen_init_cpio
  GEN     usr/initramfs_data.cpio.gz
  AS      usr/initramfs_data.o
  LD      usr/built-in.o
  CC      arch/x86/kernel/process_64.o
  CC      arch/x86/kernel/signal_64.o
  AS      arch/x86/kernel/entry_64.o
  CC      arch/x86/kernel/traps.o
  CC      arch/x86/kernel/irq.o
  CC      arch/x86/kernel/irq_64.o
  CC      arch/x86/kernel/dumpstack_64.o
  CC      arch/x86/kernel/time_64.o
  CC      arch/x86/kernel/ioport.o
  CC      arch/x86/kernel/ldt.o
  CC      arch/x86/kernel/dumpstack.o
  CC      arch/x86/kernel/setup.o
  CC      arch/x86/kernel/i8259.o
  CC      arch/x86/kernel/irqinit_64.o
  CC      arch/x86/kernel/setup_percpu.o
  CC      arch/x86/kernel/sys_x86_64.o
  CC      arch/x86/kernel/x8664_ksyms_64.o
  CC      arch/x86/kernel/syscall_64.o
  CC      arch/x86/kernel/vsyscall_64.o
  CC      arch/x86/kernel/bootflag.o
  CC      arch/x86/kernel/e820.o
  CC      arch/x86/kernel/pci-dma.o
  CC      arch/x86/kernel/quirks.o
  CC      arch/x86/kernel/i8237.o
  CC      arch/x86/kernel/topology.o
  CC      arch/x86/kernel/kdebugfs.o
  CC      arch/x86/kernel/alternative.o
  CC      arch/x86/kernel/i8253.o
  CC      arch/x86/kernel/pci-nommu.o
  CC      arch/x86/kernel/tsc.o
  CC      arch/x86/kernel/io_delay.o
  CC      arch/x86/kernel/rtc.o
  CC      arch/x86/kernel/process.o
  CC      arch/x86/kernel/i387.o
  CC      arch/x86/kernel/xsave.o
  CC      arch/x86/kernel/ptrace.o
  CC      arch/x86/kernel/ds.o
  CC      arch/x86/kernel/step.o
  CC      arch/x86/kernel/stacktrace.o
  LD      arch/x86/kernel/acpi/built-in.o
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
  CC      arch/x86/kernel/cpu/addon_cpuid_features.o
  CC      arch/x86/kernel/cpu/proc.o
  MKCAP   arch/x86/kernel/cpu/capflags.c
  CC      arch/x86/kernel/cpu/capflags.o
  CC      arch/x86/kernel/cpu/powerflags.o
  CC      arch/x86/kernel/cpu/common.o
  CC      arch/x86/kernel/cpu/vmware.o
  CC      arch/x86/kernel/cpu/hypervisor.o
  CC      arch/x86/kernel/cpu/bugs_64.o
  CC      arch/x86/kernel/cpu/intel.o
  CC      arch/x86/kernel/cpu/amd.o
  CC      arch/x86/kernel/cpu/centaur_64.o
  CC      arch/x86/kernel/cpu/cpufreq/powernow-k8.o
  CC      arch/x86/kernel/cpu/cpufreq/speedstep-lib.o
  CC      arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
  LD      arch/x86/kernel/cpu/cpufreq/built-in.o
  CC      arch/x86/kernel/cpu/mcheck/mce_64.o
  CC      arch/x86/kernel/cpu/mcheck/therm_throt.o
  CC      arch/x86/kernel/cpu/mcheck/mce_intel_64.o
  LD      arch/x86/kernel/cpu/mcheck/built-in.o
  CC      arch/x86/kernel/cpu/mtrr/main.o
  CC      arch/x86/kernel/cpu/mtrr/if.o
  CC      arch/x86/kernel/cpu/mtrr/generic.o
  CC      arch/x86/kernel/cpu/mtrr/state.o
  LD      arch/x86/kernel/cpu/mtrr/built-in.o
  CC      arch/x86/kernel/cpu/perfctr-watchdog.o
  LD      arch/x86/kernel/cpu/built-in.o
  CC      arch/x86/kernel/reboot.o
  CC      arch/x86/kernel/early-quirks.o
  CC      arch/x86/kernel/mpparse.o
  CC      arch/x86/kernel/apic.o
  CC      arch/x86/kernel/nmi.o
  CC      arch/x86/kernel/io_apic.o
  CC      arch/x86/kernel/ftrace.o
  CC      arch/x86/kernel/machine_kexec_64.o
  AS      arch/x86/kernel/relocate_kernel_64.o
  CC      arch/x86/kernel/crash.o
  CC      arch/x86/kernel/crash_dump_64.o
  CC      arch/x86/kernel/vsmp_64.o
  CC      arch/x86/kernel/kprobes.o
  CC      arch/x86/kernel/module_64.o
  CC      arch/x86/kernel/kgdb.o
  CC      arch/x86/kernel/early_printk.o
  CC      arch/x86/kernel/hpet.o
  CC      arch/x86/kernel/test_rodata.o
  CC      arch/x86/kernel/pcspeaker.o
  CC      arch/x86/kernel/genapic_64.o
  CC      arch/x86/kernel/genapic_flat_64.o
  CC      arch/x86/kernel/genx2apic_uv_x.o
arch/x86/kernel/genx2apic_uv_x.c: In function 'boot_pnode_to_blade':
arch/x86/kernel/genx2apic_uv_x.c:248: warning: control reaches end of non-void function
arch/x86/kernel/genx2apic_uv_x.c: At top level:
arch/x86/kernel/genx2apic_uv_x.c:403: warning: 'uv_heartbeat_disable' defined but not used
arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_system_init':
arch/x86/kernel/genx2apic_uv_x.c:479: warning: 'lowmem_redir_size' may be used uninitialized in this function
arch/x86/kernel/genx2apic_uv_x.c:479: warning: 'lowmem_redir_base' may be used uninitialized in this function
  CC      arch/x86/kernel/tlb_uv.o
  CC      arch/x86/kernel/bios_uv.o
  CC      arch/x86/kernel/uv_irq.o
  CC      arch/x86/kernel/uv_sysfs.o
  CC      arch/x86/kernel/genx2apic_cluster.o
  CC      arch/x86/kernel/genx2apic_phys.o
  CC      arch/x86/kernel/audit_64.o
  CC      arch/x86/kernel/pci-calgary_64.o
  CC      arch/x86/kernel/tce_64.o
  CC      arch/x86/kernel/pci-swiotlb_64.o
  LD      arch/x86/kernel/built-in.o
  AS      arch/x86/kernel/head_64.o
  CC      arch/x86/kernel/head64.o
  CC      arch/x86/kernel/head.o
  CC      arch/x86/kernel/init_task.o
  LDS     arch/x86/kernel/vmlinux.lds
  CC [M]  arch/x86/kernel/cpuid.o
  CC [M]  arch/x86/kernel/test_nx.o
  CC      arch/x86/mm/init_64.o
  CC      arch/x86/mm/fault.o
  CC      arch/x86/mm/ioremap.o
  CC      arch/x86/mm/extable.o
  CC      arch/x86/mm/pageattr.o
  CC      arch/x86/mm/mmap.o
  CC      arch/x86/mm/pat.o
  CC      arch/x86/mm/pgtable.o
  CC      arch/x86/mm/gup.o
  CC      arch/x86/mm/hugetlbpage.o
  CC      arch/x86/mm/kmmio.o
  CC      arch/x86/mm/pf_in.o
  CC      arch/x86/mm/mmio-mod.o
  LD      arch/x86/mm/mmiotrace.o
  CC      arch/x86/mm/memtest.o
  LD      arch/x86/mm/built-in.o
  CC [M]  arch/x86/mm/testmmiotrace.o
  CC      arch/x86/perfmon/perfmon.o
  CC      arch/x86/perfmon/perfmon_intel_arch.o
  LD      arch/x86/perfmon/built-in.o
  AS      arch/x86/crypto/aes-x86_64-asm_64.o
  CC      arch/x86/crypto/aes_glue.o
  LD      arch/x86/crypto/aes-x86_64.o
  LD      arch/x86/crypto/built-in.o
  AS [M]  arch/x86/crypto/twofish-x86_64-asm_64.o
  CC [M]  arch/x86/crypto/twofish_glue.o
  LD [M]  arch/x86/crypto/twofish-x86_64.o
  CC [M]  arch/x86/crypto/crc32c-intel.o
  CC      arch/x86/vdso/vma.o
  LDS     arch/x86/vdso/vdso.lds
  AS      arch/x86/vdso/vdso-note.o
  CC      arch/x86/vdso/vclock_gettime.o
  CC      arch/x86/vdso/vgetcpu.o
  CC      arch/x86/vdso/vvar.o
  VDSO    arch/x86/vdso/vdso.so.dbg
  OBJCOPY arch/x86/vdso/vdso.so
  AS      arch/x86/vdso/vdso.o
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  LD      arch/x86/vdso/built-in.o
  CC      kernel/sched.o
  CC      kernel/fork.o
  CC      kernel/exec_domain.o
  CC      kernel/panic.o
  CC      kernel/printk.o
  CC      kernel/cpu.o
  CC      kernel/exit.o
  CC      kernel/itimer.o
  TIMEC   kernel/timeconst.h
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
  CC      kernel/nsproxy.o
  CC      kernel/srcu.o
  CC      kernel/semaphore.o
  CC      kernel/notifier.o
  CC      kernel/ksysfs.o
  CC      kernel/pm_qos_params.o
  CC      kernel/sched_clock.o
  CC      kernel/freezer.o
  CC      kernel/sysctl_check.o
  CC      kernel/stacktrace.o
  CC      kernel/irq/handle.o
  CC      kernel/irq/manage.o
  CC      kernel/irq/spurious.o
  CC      kernel/irq/resend.o
  CC      kernel/irq/chip.o
  CC      kernel/irq/devres.o
  CC      kernel/irq/autoprobe.o
  LD      kernel/irq/built-in.o
  CC      kernel/power/main.o
  CC      kernel/power/process.o
  CC      kernel/power/console.o
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
  CC      kernel/time/tick-oneshot.o
  CC      kernel/time/tick-sched.o
  LD      kernel/time/built-in.o
  CC      kernel/trace/trace_selftest_dynamic.o
  CC      kernel/trace/ftrace.o
  LD      kernel/trace/libftrace.o
  CC      kernel/trace/ring_buffer.o
  CC      kernel/trace/trace.o
  CC      kernel/trace/trace_sched_switch.o
  CC      kernel/trace/trace_sysprof.o
  CC      kernel/trace/trace_functions.o
  CC      kernel/trace/trace_irqsoff.o
  CC      kernel/trace/trace_sched_wakeup.o
  CC      kernel/trace/trace_nop.o
  CC      kernel/trace/trace_stack.o
  CC      kernel/trace/trace_mmiotrace.o
  CC      kernel/trace/trace_boot.o
  LD      kernel/trace/built-in.o
  CC      kernel/mutex-debug.o
  CC      kernel/lockdep.o
  CC      kernel/futex.o
  CC      kernel/rtmutex.o
  CC      kernel/dma.o
  CC      kernel/spinlock.o
  CC      kernel/module.o
kernel/module.c:668: warning: 'print_unload_info' defined but not used
  CC      kernel/kallsyms.o
  CC      kernel/acct.o
  CC      kernel/kexec.o
  CC      kernel/backtracetest.o
  CC      kernel/test_kprobes.o
  CC      kernel/audit.o
  CC      kernel/auditfilter.o
  CC      kernel/kprobes.o
  CC      kernel/kgdb.o
  CC      kernel/seccomp.o
  CC      kernel/rcuclassic.o
  CC      kernel/relay.o
  CC      kernel/utsname_sysctl.o
  CC      kernel/marker.o
  CC      kernel/tracepoint.o
  LD      kernel/built-in.o
  CC [M]  kernel/rcutorture.o
  CC      mm/bootmem.o
mm/bootmem.c: In function 'mark_bootmem':
mm/bootmem.c:321: warning: control reaches end of non-void function
  CC      mm/filemap.o
  CC      mm/mempool.o
  CC      mm/oom_kill.o
  CC      mm/fadvise.o
  CC      mm/maccess.o
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
  CC      mm/page_isolation.o
  CC      mm/mm_init.o
  CC      mm/cpu_alloc.o
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
  CC      mm/dmapool.o
  CC      mm/hugetlb.o
  CC      mm/sparse.o
  CC      mm/shmem.o
  CC      mm/shmem_acl.o
  CC      mm/slub.o
  CC      mm/memory_hotplug.o
  CC      mm/migrate.o
  CC      mm/kmemtrace.o
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
  CC      fs/dcache.o
fs/dcache.c: In function 'd_materialise_unique':
fs/dcache.c:1888: warning: control reaches end of non-void function
  CC      fs/inode.o
  CC      fs/attr.o
  CC      fs/bad_inode.o
  CC      fs/file.o
  CC      fs/filesystems.o
  CC      fs/namespace.o
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
  CC      fs/no-block.o
  CC      fs/inotify.o
  CC      fs/eventpoll.o
  CC      fs/anon_inodes.o
  CC      fs/signalfd.o
  CC      fs/timerfd.o
  CC      fs/eventfd.o
  CC      fs/aio.o
  CC      fs/binfmt_misc.o
  CC      fs/binfmt_script.o
  CC      fs/posix_acl.o
  CC      fs/xattr_acl.o
  CC      fs/generic_acl.o
  CC      fs/dquot.o
  CC      fs/quota_v1.o
  CC      fs/quota.o
  CC      fs/dnotify.o
  CC      fs/configfs/inode.o
  CC      fs/configfs/file.o
  CC      fs/configfs/dir.o
  CC      fs/configfs/symlink.o
  CC      fs/configfs/mount.o
  CC      fs/configfs/item.o
  LD      fs/configfs/configfs.o
  LD      fs/configfs/built-in.o
  CC      fs/debugfs/inode.o
  CC      fs/debugfs/file.o
  LD      fs/debugfs/debugfs.o
  LD      fs/debugfs/built-in.o
  CC      fs/devpts/inode.o
  LD      fs/devpts/devpts.o
  LD      fs/devpts/built-in.o
  LD      fs/fuse/built-in.o
  CC [M]  fs/fuse/dev.o
  CC [M]  fs/fuse/dir.o
  CC [M]  fs/fuse/file.o
  CC [M]  fs/fuse/inode.o
  CC [M]  fs/fuse/control.o
  LD [M]  fs/fuse/fuse.o
  CC      fs/hugetlbfs/inode.o
  LD      fs/hugetlbfs/hugetlbfs.o
  LD      fs/hugetlbfs/built-in.o
  LD      fs/nls/built-in.o
  CC [M]  fs/nls/nls_base.o
  CC [M]  fs/nls/nls_cp737.o
  CC [M]  fs/nls/nls_cp775.o
  CC [M]  fs/nls/nls_cp855.o
  CC [M]  fs/nls/nls_cp857.o
  CC [M]  fs/nls/nls_cp860.o
  CC [M]  fs/nls/nls_cp861.o
  CC [M]  fs/nls/nls_cp862.o
  CC [M]  fs/nls/nls_cp863.o
  CC [M]  fs/nls/nls_cp865.o
  CC [M]  fs/nls/nls_cp869.o
  CC [M]  fs/nls/nls_cp949.o
  CC [M]  fs/nls/nls_cp1250.o
  CC [M]  fs/nls/nls_iso8859-2.o
  CC [M]  fs/nls/nls_iso8859-3.o
  CC [M]  fs/nls/nls_iso8859-4.o
  CC [M]  fs/nls/nls_iso8859-5.o
  CC [M]  fs/nls/nls_iso8859-6.o
  CC [M]  fs/nls/nls_iso8859-7.o
  CC [M]  fs/nls/nls_iso8859-9.o
  CC [M]  fs/nls/nls_koi8-r.o
  LD      fs/partitions/built-in.o
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
  LD      fs/built-in.o
  CC [M]  fs/quota_v2.o
  CC      ipc/mqueue.o
  CC      ipc/msgutil.o
  LD      ipc/built-in.o
  CC      security/commoncap.o
  LD      security/built-in.o
  CC      crypto/api.o
  CC      crypto/cipher.o
  CC      crypto/digest.o
  CC      crypto/compress.o
  CC      crypto/algapi.o
  CC      crypto/scatterwalk.o
  CC      crypto/ablkcipher.o
  CC      crypto/blkcipher.o
  CC      crypto/hash.o
  CC      crypto/ahash.o
  CC      crypto/algboss.o
  CC      crypto/testmgr.o
  LD      crypto/crypto.o
  CC      crypto/fips.o
  LD      crypto/crypto_algapi.o
  CC      crypto/aead.o
  LD      crypto/crypto_blkcipher.o
  CC      crypto/chainiv.o
  CC      crypto/eseqiv.o
  CC      crypto/seqiv.o
  LD      crypto/crypto_hash.o
  LD      crypto/cryptomgr.o
  CC      crypto/md5.o
  CC      crypto/sha512_generic.o
  CC      crypto/gf128mul.o
  CC      crypto/ecb.o
  CC      crypto/cbc.o
  CC      crypto/ctr.o
  CC      crypto/fcrypt.o
  CC      crypto/twofish.o
  CC      crypto/twofish_common.o
  CC      crypto/aes_generic.o
  CC      crypto/arc4.o
  CC      crypto/tea.o
  CC      crypto/salsa20_generic.o
  CC      crypto/deflate.o
  CC      crypto/michael_mic.o
  CC      crypto/lzo.o
  CC      crypto/rng.o
  CC      crypto/krng.o
  CC      crypto/ansi_cprng.o
  LD      crypto/built-in.o
  CC [M]  crypto/hmac.o
  CC [M]  crypto/xcbc.o
  CC [M]  crypto/md4.o
  CC [M]  crypto/rmd128.o
  CC [M]  crypto/sha1_generic.o
  CC [M]  crypto/sha256_generic.o
  CC [M]  crypto/tgr192.o
  CC [M]  crypto/pcbc.o
  CC [M]  crypto/cryptd.o
  CC [M]  crypto/blowfish.o
  CC [M]  crypto/camellia.o
  CC [M]  crypto/cast5.o
  CC [M]  crypto/khazad.o
  CC [M]  crypto/crc32c.o
  CC [M]  crypto/authenc.o
  CC [M]  crypto/tcrypt.o
  LD      block/built-in.o
  CC      perfmon/perfmon_ctx.o
  CC      perfmon/perfmon_file.o
  CC      perfmon/perfmon_attach.o
  CC      perfmon/perfmon_res.o
  CC      perfmon/perfmon_init.o
  CC      perfmon/perfmon_activate.o
  CC      perfmon/perfmon_intr.o
  CC      perfmon/perfmon_rw.o
  CC      perfmon/perfmon_ctxsw.o
  CC      perfmon/perfmon_pmu.o
  CC      perfmon/perfmon_syscalls.o
  CC      perfmon/perfmon_sysfs.o
  LD      perfmon/built-in.o
  LD      drivers/atm/built-in.o
  CC [M]  drivers/atm/zatm.o
  CC [M]  drivers/atm/uPD98402.o
  CC [M]  drivers/atm/ambassador.o
  CC [M]  drivers/atm/horizon.o
  CC [M]  drivers/atm/iphase.o
  CC [M]  drivers/atm/suni.o
  CC [M]  drivers/atm/eni.o
  CC [M]  drivers/atm/firestream.o
  CC [M]  drivers/atm/lanai.o
  CC [M]  drivers/atm/he.o
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
  CC      drivers/base/power/sysfs.o
  CC      drivers/base/power/main.o
  LD      drivers/base/power/built-in.o
  CC      drivers/base/dma-mapping.o
  CC      drivers/base/firmware_class.o
  CC      drivers/base/memory.o
  CC      drivers/base/module.o
  LD      drivers/base/built-in.o
  LD      drivers/block/built-in.o
  LD      drivers/cdrom/built-in.o
  CC      drivers/char/mem.o
  CC      drivers/char/random.o
  CC      drivers/char/tty_io.o
  CC      drivers/char/n_tty.o
  CC      drivers/char/tty_ioctl.o
  CC      drivers/char/tty_ldisc.o
  CC      drivers/char/tty_buffer.o
  CC      drivers/char/tty_port.o
  CC      drivers/char/pty.o
  CC      drivers/char/misc.o
  CC      drivers/char/vt_ioctl.o
  CC      drivers/char/vc_screen.o
  CC      drivers/char/selection.o
  CC      drivers/char/keyboard.o
  CC      drivers/char/consolemap.o
  CONMK   drivers/char/consolemap_deftbl.c
  CC      drivers/char/consolemap_deftbl.o
  CC      drivers/char/vt.o
  SHIPPED drivers/char/defkeymap.c
  CC      drivers/char/defkeymap.o
  CC      drivers/char/tty_audit.o
  CC      drivers/char/sysrq.o
  CC      drivers/char/rocket.o
drivers/char/rocket.c:1873: warning: 'rocket_pci_ids' defined but not used
  CC      drivers/char/specialix.o
drivers/char/specialix.c:2358: warning: 'specialx_pci_tbl' defined but not used
  CC      drivers/char/synclink.o
  CC      drivers/char/n_hdlc.o
  LD      drivers/char/ip2/built-in.o
  CC [M]  drivers/char/ip2/ip2main.o
  LD [M]  drivers/char/ip2/ip2.o
  CC      drivers/char/ipmi/ipmi_msghandler.o
  CC      drivers/char/ipmi/ipmi_poweroff.o
  LD      drivers/char/ipmi/built-in.o
  CC [M]  drivers/char/ipmi/ipmi_devintf.o
  CC [M]  drivers/char/ipmi/ipmi_si_intf.o
  CC [M]  drivers/char/ipmi/ipmi_kcs_sm.o
  CC [M]  drivers/char/ipmi/ipmi_smic_sm.o
  CC [M]  drivers/char/ipmi/ipmi_bt_sm.o
  LD [M]  drivers/char/ipmi/ipmi_si.o
  CC      drivers/char/mwave/mwavedd.o
  CC      drivers/char/mwave/smapi.o
  CC      drivers/char/mwave/tp3780i.o
  CC      drivers/char/mwave/3780i.o
  LD      drivers/char/mwave/mwave.o
  LD      drivers/char/mwave/built-in.o
  LD      drivers/char/pcmcia/ipwireless/built-in.o
  LD      drivers/char/pcmcia/built-in.o
  CC [M]  drivers/char/pcmcia/cm4000_cs.o
  CC [M]  drivers/char/pcmcia/cm4040_cs.o
  CC      drivers/char/rio/rio_linux.o
  CC      drivers/char/rio/rioinit.o
  CC      drivers/char/rio/rioboot.o
  CC      drivers/char/rio/riocmd.o
  CC      drivers/char/rio/rioctrl.o
  CC      drivers/char/rio/riointr.o
  CC      drivers/char/rio/rioparam.o
  CC      drivers/char/rio/rioroute.o
  CC      drivers/char/rio/riotable.o
  CC      drivers/char/rio/riotty.o
  LD      drivers/char/rio/rio.o
  LD      drivers/char/rio/built-in.o
  CC      drivers/char/generic_serial.o
  CC      drivers/char/nvram.o
  CC      drivers/char/pc8736x_gpio.o
  CC      drivers/char/nsc_gpio.o
  CC      drivers/char/tlclk.o
  LD      drivers/char/built-in.o
  CC [M]  drivers/char/cyclades.o
  CC [M]  drivers/char/istallion.o
  CC [M]  drivers/char/mxser.o
  CC [M]  drivers/char/riscom8.o
  CC [M]  drivers/char/synclinkmp.o
  CC [M]  drivers/char/synclink_gt.o
  CC [M]  drivers/char/applicom.o
  CC [M]  drivers/char/hangcheck-timer.o
  LD      drivers/clocksource/built-in.o
  LD      drivers/connector/built-in.o
  CC [M]  drivers/connector/cn_queue.o
  CC [M]  drivers/connector/connector.o
  LD [M]  drivers/connector/cn.o
  CC      drivers/cpufreq/cpufreq.o
  CC      drivers/cpufreq/cpufreq_stats.o
  CC      drivers/cpufreq/cpufreq_performance.o
  CC      drivers/cpufreq/freq_table.o
  LD      drivers/cpufreq/built-in.o
  CC [M]  drivers/cpufreq/cpufreq_powersave.o
  CC [M]  drivers/cpufreq/cpufreq_userspace.o
  LD      drivers/crypto/built-in.o
  LD      drivers/dca/built-in.o
  CC [M]  drivers/dca/dca-core.o
  CC [M]  drivers/dca/dca-sysfs.o
  LD [M]  drivers/dca/dca.o
  CC      drivers/dma/dmaengine.o
  LD      drivers/dma/built-in.o
  CC [M]  drivers/dma/ioat.o
  CC [M]  drivers/dma/ioat_dma.o
  CC [M]  drivers/dma/ioat_dca.o
  LD [M]  drivers/dma/ioatdma.o
  CC      drivers/edac/edac_stub.o
  LD      drivers/edac/built-in.o
  LD      drivers/firewire/built-in.o
  CC [M]  drivers/firewire/fw-card.o
  CC [M]  drivers/firewire/fw-topology.o
  CC [M]  drivers/firewire/fw-transaction.o
  CC [M]  drivers/firewire/fw-iso.o
  CC [M]  drivers/firewire/fw-device.o
  CC [M]  drivers/firewire/fw-cdev.o
  CC [M]  drivers/firewire/fw-ohci.o
  LD [M]  drivers/firewire/firewire-core.o
  LD [M]  drivers/firewire/firewire-ohci.o
  CC      drivers/firmware/dmi_scan.o
  CC      drivers/firmware/dell_rbu.o
  CC      drivers/firmware/dmi-id.o
  LD      drivers/firmware/built-in.o
  CC [M]  drivers/firmware/edd.o
  CC      drivers/gpio/gpiolib.o
  LD      drivers/gpio/built-in.o
  CC [M]  drivers/gpio/max732x.o
  CC [M]  drivers/gpio/pcf857x.o
  CC [M]  drivers/gpio/bt8xxgpio.o
  CC      drivers/gpu/drm/drm_auth.o
  CC      drivers/gpu/drm/drm_bufs.o
  CC      drivers/gpu/drm/drm_cache.o
  CC      drivers/gpu/drm/drm_context.o
  CC      drivers/gpu/drm/drm_dma.o
  CC      drivers/gpu/drm/drm_drawable.o
  CC      drivers/gpu/drm/drm_drv.o
  CC      drivers/gpu/drm/drm_fops.o
  CC      drivers/gpu/drm/drm_gem.o
  CC      drivers/gpu/drm/drm_ioctl.o
  CC      drivers/gpu/drm/drm_irq.o
  CC      drivers/gpu/drm/drm_lock.o
  CC      drivers/gpu/drm/drm_memory.o
  CC      drivers/gpu/drm/drm_proc.o
  CC      drivers/gpu/drm/drm_stub.o
  CC      drivers/gpu/drm/drm_vm.o
  CC      drivers/gpu/drm/drm_agpsupport.o
  CC      drivers/gpu/drm/drm_scatter.o
  CC      drivers/gpu/drm/ati_pcigart.o
  CC      drivers/gpu/drm/drm_pci.o
  CC      drivers/gpu/drm/drm_sysfs.o
  CC      drivers/gpu/drm/drm_hashtab.o
  CC      drivers/gpu/drm/drm_sman.o
  CC      drivers/gpu/drm/drm_mm.o
  LD      drivers/gpu/drm/drm.o
  LD      drivers/gpu/drm/r128/built-in.o
  CC [M]  drivers/gpu/drm/r128/r128_drv.o
  CC [M]  drivers/gpu/drm/r128/r128_cce.o
  CC [M]  drivers/gpu/drm/r128/r128_state.o
  CC [M]  drivers/gpu/drm/r128/r128_irq.o
  LD [M]  drivers/gpu/drm/r128/r128.o
  CC      drivers/gpu/drm/radeon/radeon_drv.o
  CC      drivers/gpu/drm/radeon/radeon_cp.o
  CC      drivers/gpu/drm/radeon/radeon_state.o
  CC      drivers/gpu/drm/radeon/radeon_mem.o
  CC      drivers/gpu/drm/radeon/radeon_irq.o
  CC      drivers/gpu/drm/radeon/r300_cmdbuf.o
  LD      drivers/gpu/drm/radeon/radeon.o
  LD      drivers/gpu/drm/radeon/built-in.o
  LD      drivers/gpu/drm/savage/built-in.o
  CC [M]  drivers/gpu/drm/savage/savage_drv.o
  CC [M]  drivers/gpu/drm/savage/savage_bci.o
  CC [M]  drivers/gpu/drm/savage/savage_state.o
  LD [M]  drivers/gpu/drm/savage/savage.o
  CC      drivers/gpu/drm/tdfx/tdfx_drv.o
  LD      drivers/gpu/drm/tdfx/tdfx.o
  LD      drivers/gpu/drm/tdfx/built-in.o
  LD      drivers/gpu/drm/built-in.o
  LD      drivers/gpu/built-in.o
  LD      drivers/hwmon/built-in.o
  CC [M]  drivers/hwmon/hwmon.o
  CC [M]  drivers/hwmon/hwmon-vid.o
  CC [M]  drivers/hwmon/asb100.o
  CC [M]  drivers/hwmon/w83627hf.o
  CC [M]  drivers/hwmon/w83792d.o
  CC [M]  drivers/hwmon/w83781d.o
  CC [M]  drivers/hwmon/w83791d.o
  CC [M]  drivers/hwmon/adm1025.o
  CC [M]  drivers/hwmon/adm1026.o
  CC [M]  drivers/hwmon/adm1031.o
  CC [M]  drivers/hwmon/ads7828.o
  CC [M]  drivers/hwmon/adt7470.o
  CC [M]  drivers/hwmon/adt7473.o
drivers/hwmon/adt7473.c: In function 'show_pwm_auto_temp':
drivers/hwmon/adt7473.c:797: warning: control reaches end of non-void function
  CC [M]  drivers/hwmon/atxp1.o
  CC [M]  drivers/hwmon/coretemp.o
  CC [M]  drivers/hwmon/dme1737.o
  CC [M]  drivers/hwmon/ds1621.o
  CC [M]  drivers/hwmon/f71805f.o
  CC [M]  drivers/hwmon/fscher.o
  CC [M]  drivers/hwmon/fscpos.o
  CC [M]  drivers/hwmon/gl518sm.o
  CC [M]  drivers/hwmon/gl520sm.o
  CC [M]  drivers/hwmon/hdaps.o
  CC [M]  drivers/hwmon/i5k_amb.o
drivers/hwmon/i5k_amb.c: In function 'i5k_channel_pci_id':
drivers/hwmon/i5k_amb.c:485: warning: control reaches end of non-void function
  CC [M]  drivers/hwmon/ibmaem.o
  CC [M]  drivers/hwmon/k8temp.o
  CC [M]  drivers/hwmon/lm63.o
  CC [M]  drivers/hwmon/lm77.o
  CC [M]  drivers/hwmon/lm80.o
  CC [M]  drivers/hwmon/lm83.o
  CC [M]  drivers/hwmon/lm87.o
  CC [M]  drivers/hwmon/lm92.o
  CC [M]  drivers/hwmon/lm93.o
  CC [M]  drivers/hwmon/pc87360.o
  CC [M]  drivers/hwmon/pc87427.o
  CC [M]  drivers/hwmon/sis5595.o
  CC [M]  drivers/hwmon/smsc47b397.o
  CC [M]  drivers/hwmon/smsc47m192.o
  CC [M]  drivers/hwmon/vt1211.o
  CC [M]  drivers/hwmon/w83627ehf.o
  CC [M]  drivers/hwmon/w83l785ts.o
  CC [M]  drivers/hwmon/w83l786ng.o
  CC      drivers/i2c/i2c-boardinfo.o
  LD      drivers/i2c/algos/built-in.o
  CC [M]  drivers/i2c/algos/i2c-algo-bit.o
  CC [M]  drivers/i2c/algos/i2c-algo-pcf.o
  CC [M]  drivers/i2c/algos/i2c-algo-pca.o
  LD      drivers/i2c/busses/built-in.o
  CC [M]  drivers/i2c/busses/i2c-ali1535.o
  CC [M]  drivers/i2c/busses/i2c-ali15x3.o
  CC [M]  drivers/i2c/busses/i2c-amd756.o
  CC [M]  drivers/i2c/busses/i2c-amd756-s4882.o
  CC [M]  drivers/i2c/busses/i2c-amd8111.o
  CC [M]  drivers/i2c/busses/i2c-i801.o
  CC [M]  drivers/i2c/busses/i2c-isch.o
  CC [M]  drivers/i2c/busses/i2c-nforce2.o
  CC [M]  drivers/i2c/busses/i2c-nforce2-s4985.o
  CC [M]  drivers/i2c/busses/i2c-piix4.o
  CC [M]  drivers/i2c/busses/i2c-via.o
  CC [M]  drivers/i2c/busses/i2c-viapro.o
  CC [M]  drivers/i2c/busses/i2c-gpio.o
  CC [M]  drivers/i2c/busses/i2c-simtec.o
  CC [M]  drivers/i2c/busses/i2c-tiny-usb.o
  CC [M]  drivers/i2c/busses/i2c-pca-platform.o
  CC [M]  drivers/i2c/busses/i2c-stub.o
  LD      drivers/i2c/chips/built-in.o
  CC [M]  drivers/i2c/chips/ds1682.o
  CC [M]  drivers/i2c/chips/at24.o
  CC [M]  drivers/i2c/chips/eeprom.o
  CC [M]  drivers/i2c/chips/max6875.o
  CC [M]  drivers/i2c/chips/pca9539.o
  CC [M]  drivers/i2c/chips/pcf8591.o
  CC [M]  drivers/i2c/chips/tps65010.o
  CC [M]  drivers/i2c/chips/tsl2550.o
  LD      drivers/i2c/built-in.o
  CC [M]  drivers/i2c/i2c-core.o
  CC [M]  drivers/i2c/i2c-dev.o
  LD      drivers/idle/built-in.o
  LD      drivers/ieee1394/built-in.o
  CC [M]  drivers/ieee1394/ieee1394_core.o
  CC [M]  drivers/ieee1394/ieee1394_transactions.o
  CC [M]  drivers/ieee1394/hosts.o
  CC [M]  drivers/ieee1394/highlevel.o
  CC [M]  drivers/ieee1394/csr.o
  CC [M]  drivers/ieee1394/nodemgr.o
  CC [M]  drivers/ieee1394/dma.o
  CC [M]  drivers/ieee1394/iso.o
  CC [M]  drivers/ieee1394/csr1212.o
  CC [M]  drivers/ieee1394/config_roms.o
  LD [M]  drivers/ieee1394/ieee1394.o
  CC [M]  drivers/ieee1394/ohci1394.o
  CC [M]  drivers/ieee1394/video1394.o
  CC [M]  drivers/ieee1394/raw1394.o
  CC [M]  drivers/ieee1394/dv1394.o
  LD      drivers/infiniband/built-in.o
  LD      drivers/infiniband/core/built-in.o
  CC [M]  drivers/infiniband/core/cm.o
  CC [M]  drivers/infiniband/core/packer.o
  CC [M]  drivers/infiniband/core/ud_header.o
  CC [M]  drivers/infiniband/core/verbs.o
  CC [M]  drivers/infiniband/core/sysfs.o
  CC [M]  drivers/infiniband/core/device.o
  CC [M]  drivers/infiniband/core/fmr_pool.o
  CC [M]  drivers/infiniband/core/cache.o
  CC [M]  drivers/infiniband/core/umem.o
  CC [M]  drivers/infiniband/core/mad.o
  CC [M]  drivers/infiniband/core/smi.o
  CC [M]  drivers/infiniband/core/agent.o
  CC [M]  drivers/infiniband/core/mad_rmpp.o
  CC [M]  drivers/infiniband/core/sa_query.o
  CC [M]  drivers/infiniband/core/multicast.o
  CC [M]  drivers/infiniband/core/ucm.o
  CC [M]  drivers/infiniband/core/user_mad.o
  CC [M]  drivers/infiniband/core/uverbs_main.o
  CC [M]  drivers/infiniband/core/uverbs_cmd.o
  CC [M]  drivers/infiniband/core/uverbs_marshall.o
  CC [M]  drivers/infiniband/core/iwcm.o
  LD [M]  drivers/infiniband/core/ib_core.o
  LD [M]  drivers/infiniband/core/ib_mad.o
  LD [M]  drivers/infiniband/core/ib_sa.o
  LD [M]  drivers/infiniband/core/ib_cm.o
  LD [M]  drivers/infiniband/core/iw_cm.o
  LD [M]  drivers/infiniband/core/ib_umad.o
  LD [M]  drivers/infiniband/core/ib_uverbs.o
  LD [M]  drivers/infiniband/core/ib_ucm.o
  LD      drivers/infiniband/hw/mlx4/built-in.o
  CC [M]  drivers/infiniband/hw/mlx4/ah.o
  CC [M]  drivers/infiniband/hw/mlx4/cq.o
  CC [M]  drivers/infiniband/hw/mlx4/doorbell.o
  CC [M]  drivers/infiniband/hw/mlx4/mad.o
  CC [M]  drivers/infiniband/hw/mlx4/main.o
  CC [M]  drivers/infiniband/hw/mlx4/mr.o
  CC [M]  drivers/infiniband/hw/mlx4/qp.o
  CC [M]  drivers/infiniband/hw/mlx4/srq.o
  LD [M]  drivers/infiniband/hw/mlx4/mlx4_ib.o
  LD      drivers/infiniband/hw/mthca/built-in.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_main.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_cmd.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_profile.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_reset.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_allocator.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_eq.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_pd.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_cq.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_mr.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_qp.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_av.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_mcg.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_mad.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_provider.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_memfree.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_uar.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_srq.o
  CC [M]  drivers/infiniband/hw/mthca/mthca_catas.o
  LD [M]  drivers/infiniband/hw/mthca/ib_mthca.o
  CC      drivers/input/input.o
  CC      drivers/input/input-compat.o
  CC      drivers/input/ff-core.o
  LD      drivers/input/input-core.o
  CC      drivers/input/ff-memless.o
  CC      drivers/input/mousedev.o
  CC      drivers/input/joydev.o
  CC      drivers/input/evbug.o
  CC      drivers/input/joystick/analog.o
  CC      drivers/input/joystick/guillemot.o
  CC      drivers/input/joystick/sidewinder.o
  CC      drivers/input/joystick/spaceorb.o
  LD      drivers/input/joystick/built-in.o
  CC [M]  drivers/input/joystick/a3d.o
  CC [M]  drivers/input/joystick/grip.o
  CC [M]  drivers/input/joystick/tmdc.o
  CC [M]  drivers/input/joystick/zhenhua.o
  LD      drivers/input/joystick/iforce/built-in.o
  CC [M]  drivers/input/joystick/iforce/iforce-ff.o
  CC [M]  drivers/input/joystick/iforce/iforce-main.o
  CC [M]  drivers/input/joystick/iforce/iforce-packets.o
  CC [M]  drivers/input/joystick/iforce/iforce-serio.o
  CC [M]  drivers/input/joystick/iforce/iforce-usb.o
  LD [M]  drivers/input/joystick/iforce/iforce.o
  CC      drivers/input/keyboard/atkbd.o
  CC      drivers/input/keyboard/lkkbd.o
  CC      drivers/input/keyboard/newtonkbd.o
  LD      drivers/input/keyboard/built-in.o
  CC [M]  drivers/input/keyboard/sunkbd.o
  CC      drivers/input/mouse/sermouse.o
  CC      drivers/input/mouse/vsxxxaa.o
  LD      drivers/input/mouse/built-in.o
  CC [M]  drivers/input/mouse/bcm5974.o
  CC [M]  drivers/input/mouse/gpio_mouse.o
  CC      drivers/input/tablet/aiptek.o
  CC      drivers/input/tablet/kbtab.o
  LD      drivers/input/tablet/built-in.o
  CC [M]  drivers/input/tablet/acecad.o
  CC [M]  drivers/input/tablet/gtco.o
  CC [M]  drivers/input/tablet/wacom_wac.o
  CC [M]  drivers/input/tablet/wacom_sys.o
  LD [M]  drivers/input/tablet/wacom.o
  CC      drivers/input/touchscreen/inexio.o
  CC      drivers/input/touchscreen/mtouch.o
  CC      drivers/input/touchscreen/mk712.o
  CC      drivers/input/touchscreen/usbtouchscreen.o
  CC      drivers/input/touchscreen/penmount.o
  LD      drivers/input/touchscreen/built-in.o
  CC [M]  drivers/input/touchscreen/gunze.o
  CC [M]  drivers/input/touchscreen/elo.o
  CC [M]  drivers/input/touchscreen/touchit213.o
  CC [M]  drivers/input/touchscreen/touchright.o
  CC [M]  drivers/input/touchscreen/touchwin.o
  LD      drivers/input/built-in.o
  CC [M]  drivers/input/input-polldev.o
  CC      drivers/input/gameport/gameport.o
  CC      drivers/input/gameport/emu10k1-gp.o
  LD      drivers/input/gameport/built-in.o
  CC [M]  drivers/input/gameport/fm801-gp.o
  CC [M]  drivers/input/gameport/ns558.o
  CC      drivers/input/serio/serio.o
  CC      drivers/input/serio/i8042.o
  CC      drivers/input/serio/ct82c710.o
  CC      drivers/input/serio/libps2.o
  LD      drivers/input/serio/built-in.o
  CC      drivers/isdn/capi/kcapi.o
  CC      drivers/isdn/capi/capiutil.o
  CC      drivers/isdn/capi/capilib.o
  LD      drivers/isdn/capi/kernelcapi.o
  CC      drivers/isdn/capi/capi.o
  LD      drivers/isdn/capi/built-in.o
  LD      drivers/isdn/hardware/eicon/built-in.o
  LD      drivers/isdn/hardware/mISDN/built-in.o
  CC [M]  drivers/isdn/hardware/mISDN/hfcpci.o
  CC [M]  drivers/isdn/hardware/mISDN/hfcmulti.o
  LD      drivers/isdn/hardware/built-in.o
  CC      drivers/isdn/mISDN/core.o
  CC      drivers/isdn/mISDN/fsm.o
  CC      drivers/isdn/mISDN/socket.o
  CC      drivers/isdn/mISDN/hwchannel.o
  CC      drivers/isdn/mISDN/stack.o
  CC      drivers/isdn/mISDN/layer1.o
  CC      drivers/isdn/mISDN/layer2.o
  CC      drivers/isdn/mISDN/tei.o
  CC      drivers/isdn/mISDN/timerdev.o
  LD      drivers/isdn/mISDN/mISDN_core.o
  LD      drivers/isdn/mISDN/built-in.o
  CC [M]  drivers/isdn/mISDN/l1oip_core.o
  CC [M]  drivers/isdn/mISDN/l1oip_codec.o
  CC [M]  drivers/isdn/mISDN/dsp_core.o
  CC [M]  drivers/isdn/mISDN/dsp_cmx.o
  CC [M]  drivers/isdn/mISDN/dsp_tones.o
  CC [M]  drivers/isdn/mISDN/dsp_dtmf.o
  CC [M]  drivers/isdn/mISDN/dsp_audio.o
  CC [M]  drivers/isdn/mISDN/dsp_blowfish.o
  CC [M]  drivers/isdn/mISDN/dsp_pipeline.o
  CC [M]  drivers/isdn/mISDN/dsp_hwec.o
  LD [M]  drivers/isdn/mISDN/mISDN_dsp.o
  LD [M]  drivers/isdn/mISDN/l1oip.o
  LD      drivers/isdn/built-in.o
  CC      drivers/leds/led-core.o
  CC      drivers/leds/led-class.o
  CC      drivers/leds/led-triggers.o
  CC      drivers/leds/ledtrig-backlight.o
  LD      drivers/leds/built-in.o
  CC [M]  drivers/leds/leds-pca9532.o
  CC [M]  drivers/leds/leds-clevo-mail.o
  CC [M]  drivers/leds/leds-pca955x.o
  CC [M]  drivers/leds/ledtrig-heartbeat.o
  CC [M]  drivers/leds/ledtrig-default-on.o
  LD      drivers/lguest/built-in.o
  LD      drivers/macintosh/built-in.o
  LD      drivers/media/common/tuners/built-in.o
  LD      drivers/media/common/built-in.o
  CC      drivers/media/video/dabusb.o
  LD      drivers/media/video/built-in.o
  LD      drivers/media/built-in.o
  LD      drivers/memstick/core/built-in.o
  CC [M]  drivers/memstick/core/memstick.o
  LD      drivers/memstick/host/built-in.o
  CC [M]  drivers/memstick/host/tifm_ms.o
  CC [M]  drivers/memstick/host/jmb38x_ms.o
  LD      drivers/message/fusion/built-in.o
  LD      drivers/message/i2o/built-in.o
  CC [M]  drivers/message/i2o/bus-osm.o
  CC [M]  drivers/message/i2o/config-osm.o
In file included from drivers/message/i2o/config-osm.c:39:
drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
drivers/message/i2o/i2o_config.c:887: warning: cast to pointer from integer of different size
drivers/message/i2o/i2o_config.c:942: warning: cast to pointer from integer of different size
  CC [M]  drivers/message/i2o/iop.o
  CC [M]  drivers/message/i2o/driver.o
  CC [M]  drivers/message/i2o/device.o
  CC [M]  drivers/message/i2o/debug.o
  CC [M]  drivers/message/i2o/pci.o
  CC [M]  drivers/message/i2o/exec-osm.o
  CC [M]  drivers/message/i2o/memory.o
  LD [M]  drivers/message/i2o/i2o_core.o
  LD [M]  drivers/message/i2o/i2o_config.o
  LD [M]  drivers/message/i2o/i2o_bus.o
  CC [M]  drivers/message/i2o/i2o_proc.o
  LD      drivers/message/built-in.o
  LD      drivers/mfd/built-in.o
  CC [M]  drivers/mfd/sm501.o
  CC [M]  drivers/mfd/htc-pasic3.o
  CC [M]  drivers/mfd/wm8400-core.o
  CC [M]  drivers/mfd/wm8350-core.o
  CC [M]  drivers/mfd/wm8350-regmap.o
drivers/mfd/wm8350-regmap.c:1081:2: warning: #warning No WM8350 config modes supported - select at least one of the
drivers/mfd/wm8350-regmap.c:1082:2: warning: #warning MFD_WM8350_CONFIG_MODE_n options from the board driver.
  CC [M]  drivers/mfd/wm8350-gpio.o
  LD [M]  drivers/mfd/wm8350.o
  CC [M]  drivers/mfd/wm8350-i2c.o
  LD      drivers/misc/built-in.o
  CC [M]  drivers/misc/tifm_core.o
  LD      drivers/net/appletalk/built-in.o
  CC [M]  drivers/net/appletalk/ipddp.o
  CC      drivers/net/arcnet/arcnet.o
  CC      drivers/net/arcnet/arc-rawmode.o
  CC      drivers/net/arcnet/capmode.o
  CC      drivers/net/arcnet/com90io.o
  CC      drivers/net/arcnet/arc-rimi.o
  CC      drivers/net/arcnet/com20020.o
  LD      drivers/net/arcnet/built-in.o
  CC [M]  drivers/net/arcnet/rfc1051.o
  CC [M]  drivers/net/arcnet/com20020-pci.o
  LD      drivers/net/atl1e/built-in.o
  CC [M]  drivers/net/atl1e/atl1e_main.o
  CC [M]  drivers/net/atl1e/atl1e_hw.o
  CC [M]  drivers/net/atl1e/atl1e_ethtool.o
  CC [M]  drivers/net/atl1e/atl1e_param.o
  LD [M]  drivers/net/atl1e/atl1e.o
  CC      drivers/net/atlx/atl2.o
drivers/net/atlx/atl2.c: In function 'atl2_request_irq':
drivers/net/atlx/atl2.c:644: warning: unused variable 'err'
  LD      drivers/net/atlx/built-in.o
  CC [M]  drivers/net/atlx/atl1.o
  LD      drivers/net/can/built-in.o
  CC [M]  drivers/net/can/vcan.o
  LD      drivers/net/e1000/built-in.o
  CC [M]  drivers/net/e1000/e1000_main.o
  CC [M]  drivers/net/e1000/e1000_hw.o
  CC [M]  drivers/net/e1000/e1000_ethtool.o
  CC [M]  drivers/net/e1000/e1000_param.o
  LD [M]  drivers/net/e1000/e1000.o
  LD      drivers/net/e1000e/built-in.o
  CC [M]  drivers/net/e1000e/82571.o
  CC [M]  drivers/net/e1000e/ich8lan.o
  CC [M]  drivers/net/e1000e/es2lan.o
  CC [M]  drivers/net/e1000e/lib.o
  CC [M]  drivers/net/e1000e/phy.o
  CC [M]  drivers/net/e1000e/param.o
  CC [M]  drivers/net/e1000e/ethtool.o
  CC [M]  drivers/net/e1000e/netdev.o
  LD [M]  drivers/net/e1000e/e1000e.o
  CC      drivers/net/hamradio/6pack.o
  CC      drivers/net/hamradio/baycom_ser_fdx.o
  CC      drivers/net/hamradio/hdlcdrv.o
  CC      drivers/net/hamradio/baycom_ser_hdx.o
  LD      drivers/net/hamradio/built-in.o
  CC [M]  drivers/net/hamradio/mkiss.o
  CC [M]  drivers/net/hamradio/yam.o
  LD      drivers/net/igb/built-in.o
  CC [M]  drivers/net/igb/igb_main.o
  CC [M]  drivers/net/igb/igb_ethtool.o
  CC [M]  drivers/net/igb/e1000_82575.o
  CC [M]  drivers/net/igb/e1000_mac.o
  CC [M]  drivers/net/igb/e1000_nvm.o
  CC [M]  drivers/net/igb/e1000_phy.o
  LD [M]  drivers/net/igb/igb.o
  LD      drivers/net/irda/built-in.o
  CC [M]  drivers/net/irda/irda-usb.o
  CC [M]  drivers/net/irda/stir4200.o
  CC [M]  drivers/net/irda/nsc-ircc.o
  CC [M]  drivers/net/irda/w83977af_ir.o
  CC [M]  drivers/net/irda/smsc-ircc2.o
  CC [M]  drivers/net/irda/vlsi_ir.o
  CC [M]  drivers/net/irda/irtty-sir.o
  CC [M]  drivers/net/irda/sir_dev.o
  CC [M]  drivers/net/irda/sir_dongle.o
  LD [M]  drivers/net/irda/sir-dev.o
  CC [M]  drivers/net/irda/kingsun-sir.o
  CC [M]  drivers/net/irda/ksdazzle-sir.o
  CC [M]  drivers/net/irda/ks959-sir.o
  LD      drivers/net/ixgb/built-in.o
  CC [M]  drivers/net/ixgb/ixgb_main.o
  CC [M]  drivers/net/ixgb/ixgb_hw.o
  CC [M]  drivers/net/ixgb/ixgb_ee.o
  CC [M]  drivers/net/ixgb/ixgb_ethtool.o
  CC [M]  drivers/net/ixgb/ixgb_param.o
  LD [M]  drivers/net/ixgb/ixgb.o
  LD      drivers/net/mlx4/built-in.o
  CC [M]  drivers/net/mlx4/alloc.o
  CC [M]  drivers/net/mlx4/catas.o
  CC [M]  drivers/net/mlx4/cmd.o
  CC [M]  drivers/net/mlx4/cq.o
  CC [M]  drivers/net/mlx4/eq.o
  CC [M]  drivers/net/mlx4/fw.o
  CC [M]  drivers/net/mlx4/icm.o
  CC [M]  drivers/net/mlx4/intf.o
  CC [M]  drivers/net/mlx4/main.o
  CC [M]  drivers/net/mlx4/mcg.o
  CC [M]  drivers/net/mlx4/mr.o
  CC [M]  drivers/net/mlx4/pd.o
  CC [M]  drivers/net/mlx4/port.o
  CC [M]  drivers/net/mlx4/profile.o
  CC [M]  drivers/net/mlx4/qp.o
  CC [M]  drivers/net/mlx4/reset.o
  CC [M]  drivers/net/mlx4/srq.o
  LD [M]  drivers/net/mlx4/mlx4_core.o
  LD      drivers/net/netxen/built-in.o
  CC [M]  drivers/net/netxen/netxen_nic_hw.o
  CC [M]  drivers/net/netxen/netxen_nic_main.o
  CC [M]  drivers/net/netxen/netxen_nic_init.o
  CC [M]  drivers/net/netxen/netxen_nic_ethtool.o
  CC [M]  drivers/net/netxen/netxen_nic_niu.o
  CC [M]  drivers/net/netxen/netxen_nic_ctx.o
  LD [M]  drivers/net/netxen/netxen_nic.o
  CC      drivers/net/phy/phy.o
  CC      drivers/net/phy/phy_device.o
  CC      drivers/net/phy/mdio_bus.o
  LD      drivers/net/phy/libphy.o
  CC      drivers/net/phy/marvell.o
  CC      drivers/net/phy/davicom.o
  CC      drivers/net/phy/broadcom.o
  CC      drivers/net/phy/realtek.o
  LD      drivers/net/phy/built-in.o
  CC [M]  drivers/net/phy/lxt.o
  CC [M]  drivers/net/phy/qsemi.o
  CC [M]  drivers/net/phy/smsc.o
  CC [M]  drivers/net/phy/vitesse.o
  CC [M]  drivers/net/phy/icplus.o
  CC      drivers/net/qlge/qlge_main.o
  CC      drivers/net/qlge/qlge_dbg.o
  CC      drivers/net/qlge/qlge_mpi.o
  CC      drivers/net/qlge/qlge_ethtool.o
  LD      drivers/net/qlge/qlge.o
  LD      drivers/net/qlge/built-in.o
  LD      drivers/net/skfp/built-in.o
  CC [M]  drivers/net/skfp/skfddi.o
  CC [M]  drivers/net/skfp/hwmtm.o
  CC [M]  drivers/net/skfp/fplustm.o
  CC [M]  drivers/net/skfp/smt.o
  CC [M]  drivers/net/skfp/cfm.o
  CC [M]  drivers/net/skfp/ecm.o
  CC [M]  drivers/net/skfp/pcmplc.o
  CC [M]  drivers/net/skfp/pmf.o
  CC [M]  drivers/net/skfp/queue.o
  CC [M]  drivers/net/skfp/rmt.o
  CC [M]  drivers/net/skfp/smtdef.o
  CC [M]  drivers/net/skfp/smtinit.o
  CC [M]  drivers/net/skfp/smttimer.o
  CC [M]  drivers/net/skfp/srf.o
  CC [M]  drivers/net/skfp/hwt.o
  CC [M]  drivers/net/skfp/drvfbi.o
  CC [M]  drivers/net/skfp/ess.o
  LD [M]  drivers/net/skfp/skfp.o
  CC      drivers/net/tokenring/olympic.o
  LD      drivers/net/tokenring/built-in.o
  CC [M]  drivers/net/tokenring/tms380tr.o
  CC [M]  drivers/net/tokenring/tmspci.o
  CC      drivers/net/usb/catc.o
  CC      drivers/net/usb/cdc_ether.o
  CC      drivers/net/usb/plusb.o
  CC      drivers/net/usb/rndis_host.o
  CC      drivers/net/usb/zaurus.o
  CC      drivers/net/usb/usbnet.o
  LD      drivers/net/usb/built-in.o
  CC [M]  drivers/net/usb/asix.o
  CC [M]  drivers/net/usb/dm9601.o
  CC [M]  drivers/net/usb/gl620a.o
  CC [M]  drivers/net/usb/net1080.o
  CC [M]  drivers/net/usb/cdc_subset.o
  CC [M]  drivers/net/usb/mcs7830.o
  CC      drivers/net/wireless/ipw2100.o
  CC      drivers/net/wireless/orinoco.o
  CC      drivers/net/wireless/hermes.o
  CC      drivers/net/wireless/hermes_dld.o
  CC      drivers/net/wireless/orinoco_pci.o
  CC      drivers/net/wireless/orinoco_tmd.o
  CC      drivers/net/wireless/orinoco_nortel.o
  CC      drivers/net/wireless/hostap/hostap_80211_rx.o
  CC      drivers/net/wireless/hostap/hostap_80211_tx.o
  CC      drivers/net/wireless/hostap/hostap_ap.o
  CC      drivers/net/wireless/hostap/hostap_info.o
  CC      drivers/net/wireless/hostap/hostap_ioctl.o
  CC      drivers/net/wireless/hostap/hostap_main.o
  CC      drivers/net/wireless/hostap/hostap_proc.o
  LD      drivers/net/wireless/hostap/hostap.o
  CC      drivers/net/wireless/hostap/hostap_plx.o
  CC      drivers/net/wireless/hostap/hostap_pci.o
  LD      drivers/net/wireless/hostap/built-in.o
  CC [M]  drivers/net/wireless/hostap/hostap_cs.o
  CC      drivers/net/wireless/libertas/main.o
  CC      drivers/net/wireless/libertas/wext.o
  CC      drivers/net/wireless/libertas/rx.o
  CC      drivers/net/wireless/libertas/tx.o
  CC      drivers/net/wireless/libertas/cmd.o
  CC      drivers/net/wireless/libertas/cmdresp.o
  CC      drivers/net/wireless/libertas/scan.o
  CC      drivers/net/wireless/libertas/11d.o
  CC      drivers/net/wireless/libertas/debugfs.o
  CC      drivers/net/wireless/libertas/persistcfg.o
  CC      drivers/net/wireless/libertas/ethtool.o
  CC      drivers/net/wireless/libertas/assoc.o
  CC      drivers/net/wireless/libertas/if_usb.o
  LD      drivers/net/wireless/libertas/libertas.o
  LD      drivers/net/wireless/libertas/usb8xxx.o
  LD      drivers/net/wireless/libertas/built-in.o
  CC [M]  drivers/net/wireless/libertas/if_cs.o
  LD [M]  drivers/net/wireless/libertas/libertas_cs.o
  CC      drivers/net/wireless/prism54/islpci_eth.o
  CC      drivers/net/wireless/prism54/islpci_mgt.o
  CC      drivers/net/wireless/prism54/isl_38xx.o
  CC      drivers/net/wireless/prism54/isl_ioctl.o
  CC      drivers/net/wireless/prism54/islpci_dev.o
  CC      drivers/net/wireless/prism54/islpci_hotplug.o
  CC      drivers/net/wireless/prism54/oid_mgt.o
  LD      drivers/net/wireless/prism54/prism54.o
  LD      drivers/net/wireless/prism54/built-in.o
  CC      drivers/net/wireless/rndis_wlan.o
  CC      drivers/net/wireless/zd1201.o
  LD      drivers/net/wireless/built-in.o
  CC [M]  drivers/net/wireless/ipw2200.o
  CC [M]  drivers/net/wireless/netwave_cs.o
  CC [M]  drivers/net/wireless/wavelan_cs.o
  CC [M]  drivers/net/wireless/spectrum_cs.o
  CC [M]  drivers/net/wireless/airo.o
  CC [M]  drivers/net/wireless/airo_cs.o
  CC [M]  drivers/net/wireless/wl3501_cs.o
  CC      drivers/net/3c59x.o
  CC      drivers/net/pcnet32.o
  CC      drivers/net/sis190.o
  CC      drivers/net/r6040.o
  CC      drivers/net/bnx2.o
  CC      drivers/net/via-rhine.o
  CC      drivers/net/via-velocity.o
  CC      drivers/net/mii.o
  CC      drivers/net/hamachi.o
  CC      drivers/net/Space.o
  CC      drivers/net/loopback.o
  CC      drivers/net/b44.o
  CC      drivers/net/slip.o
  CC      drivers/net/slhc.o
  CC      drivers/net/dummy.o
  CC      drivers/net/macvlan.o
  CC      drivers/net/8139cp.o
  CC      drivers/net/sc92031.o
  CC      drivers/net/veth.o
  CC      drivers/net/r8169.o
  LD      drivers/net/built-in.o
  CC [M]  drivers/net/typhoon.o
  CC [M]  drivers/net/ne2k-pci.o
  CC [M]  drivers/net/8390.o
  CC [M]  drivers/net/e100.o
  CC [M]  drivers/net/epic100.o
  CC [M]  drivers/net/bnx2x_main.o
  CC [M]  drivers/net/bnx2x_link.o
  LD [M]  drivers/net/bnx2x.o
  CC [M]  drivers/net/sky2.o
drivers/net/sky2.c: In function 'sky2_mhz':
drivers/net/sky2.c:2753: warning: control reaches end of non-void function
  CC [M]  drivers/net/sundance.o
  CC [M]  drivers/net/forcedeth.o
  CC [M]  drivers/net/qla3xxx.o
  CC [M]  drivers/net/ppp_generic.o
  CC [M]  drivers/net/ppp_async.o
  CC [M]  drivers/net/ppp_synctty.o
  CC [M]  drivers/net/ppp_deflate.o
  CC [M]  drivers/net/bsd_comp.o
  CC [M]  drivers/net/ppp_mppe.o
  CC [M]  drivers/net/defxx.o
  CC [M]  drivers/net/8139too.o
  CC [M]  drivers/net/eql.o
  CC [M]  drivers/net/niu.o
  CC      drivers/pci/access.o
  CC      drivers/pci/bus.o
  CC      drivers/pci/probe.o
  CC      drivers/pci/remove.o
  CC      drivers/pci/pci.o
  CC      drivers/pci/quirks.o
  CC      drivers/pci/slot.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/pci/search.o
drivers/pci/search.c:145: warning: 'pci_find_slot' is deprecated (declared at drivers/pci/search.c:134)
drivers/pci/search.c:145: warning: 'pci_find_slot' is deprecated (declared at drivers/pci/search.c:134)
drivers/pci/search.c:174: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:166)
drivers/pci/search.c:174: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:166)
  CC      drivers/pci/pci-sysfs.o
  CC      drivers/pci/rom.o
  CC      drivers/pci/setup-res.o
  CC      drivers/pci/irq.o
  CC      drivers/pci/hotplug/pci_hotplug_core.o
  CC      drivers/pci/hotplug/shpchp_core.o
  CC      drivers/pci/hotplug/shpchp_ctrl.o
  CC      drivers/pci/hotplug/shpchp_pci.o
  CC      drivers/pci/hotplug/shpchp_sysfs.o
  CC      drivers/pci/hotplug/shpchp_hpc.o
  LD      drivers/pci/hotplug/pci_hotplug.o
  LD      drivers/pci/hotplug/shpchp.o
  LD      drivers/pci/hotplug/built-in.o
  CC [M]  drivers/pci/hotplug/pciehp_core.o
  CC [M]  drivers/pci/hotplug/pciehp_ctrl.o
  CC [M]  drivers/pci/hotplug/pciehp_pci.o
  CC [M]  drivers/pci/hotplug/pciehp_hpc.o
  LD [M]  drivers/pci/hotplug/pciehp.o
  CC      drivers/pci/pcie/aspm.o
  CC      drivers/pci/pcie/portdrv_core.o
  CC      drivers/pci/pcie/portdrv_pci.o
  CC      drivers/pci/pcie/portdrv_bus.o
  LD      drivers/pci/pcie/pcieportdrv.o
  LD      drivers/pci/pcie/built-in.o
  CC      drivers/pci/hotplug.o
  CC      drivers/pci/hotplug-pci.o
  CC      drivers/pci/htirq.o
  CC      drivers/pci/setup-bus.o
  LD      drivers/pci/built-in.o
  CC      drivers/pcmcia/cs.o
  CC      drivers/pcmcia/cistpl.o
  CC      drivers/pcmcia/rsrc_mgr.o
  CC      drivers/pcmcia/socket_sysfs.o
  CC      drivers/pcmcia/cardbus.o
  LD      drivers/pcmcia/pcmcia_core.o
  LD      drivers/pcmcia/built-in.o
  CC [M]  drivers/pcmcia/ds.o
  CC [M]  drivers/pcmcia/pcmcia_resource.o
  CC [M]  drivers/pcmcia/pcmcia_ioctl.o
  LD [M]  drivers/pcmcia/pcmcia.o
  CC [M]  drivers/pcmcia/rsrc_nonstatic.o
  CC [M]  drivers/pcmcia/yenta_socket.o
  LD      drivers/rtc/built-in.o
  CC [M]  drivers/rtc/rtc-lib.o
  CC [M]  drivers/rtc/class.o
  CC [M]  drivers/rtc/interface.o
  CC [M]  drivers/rtc/rtc-dev.o
  CC [M]  drivers/rtc/rtc-sysfs.o
  LD [M]  drivers/rtc/rtc-core.o
  CC [M]  drivers/rtc/rtc-cmos.o
  CC [M]  drivers/rtc/rtc-ds1286.o
  CC [M]  drivers/rtc/rtc-ds1307.o
  CC [M]  drivers/rtc/rtc-ds1374.o
  CC [M]  drivers/rtc/rtc-ds1672.o
  CC [M]  drivers/rtc/rtc-ds1742.o
  CC [M]  drivers/rtc/rtc-fm3130.o
  CC [M]  drivers/rtc/rtc-m41t80.o
  CC [M]  drivers/rtc/rtc-m48t35.o
  CC [M]  drivers/rtc/rtc-m48t59.o
  CC [M]  drivers/rtc/rtc-m48t86.o
  CC [M]  drivers/rtc/rtc-bq4802.o
  CC [M]  drivers/rtc/rtc-max6900.o
  CC [M]  drivers/rtc/rtc-pcf8563.o
  CC [M]  drivers/rtc/rtc-test.o
  CC [M]  drivers/rtc/rtc-v3020.o
  CC [M]  drivers/rtc/rtc-x1205.o
  CC      drivers/serial/serial_core.o
  CC      drivers/serial/8250.o
drivers/serial/8250.c: In function 'serial8250_shutdown':
drivers/serial/8250.c:1612: warning: 'i' may be used uninitialized in this function
  CC      drivers/serial/jsm/jsm_driver.o
  CC      drivers/serial/jsm/jsm_neo.o
  CC      drivers/serial/jsm/jsm_tty.o
  LD      drivers/serial/jsm/jsm.o
  LD      drivers/serial/jsm/built-in.o
  CC      drivers/serial/kgdboc.o
  LD      drivers/serial/built-in.o
  CC [M]  drivers/serial/8250_pci.o
  CC [M]  drivers/serial/serial_cs.o
  CC      drivers/ssb/main.o
  CC      drivers/ssb/scan.o
  CC      drivers/ssb/sprom.o
  CC      drivers/ssb/pci.o
  CC      drivers/ssb/pcihost_wrapper.o
  CC      drivers/ssb/driver_chipcommon.o
  CC      drivers/ssb/driver_pcicore.o
  LD      drivers/ssb/ssb.o
  LD      drivers/ssb/built-in.o
  CC      drivers/staging/staging.o
  CC      drivers/staging/me4000/me4000.o
  LD      drivers/staging/me4000/built-in.o
  LD      drivers/staging/poch/built-in.o
  CC [M]  drivers/staging/poch/poch.o
drivers/staging/poch/poch.c: In function 'poch_channel_alloc_groups':
drivers/staging/poch/poch.c:388: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'dma_addr_t'
  CC      drivers/staging/sxg/sxg.o
  LD      drivers/staging/sxg/built-in.o
  CC      drivers/staging/wlan-ng/prism2_usb.o
drivers/staging/wlan-ng/prism2sta.c:144: warning: 'version' defined but not used
drivers/staging/wlan-ng/prism2_usb.c:321: warning: 'prism2_usb_driver' defined but not used
  CC      drivers/staging/wlan-ng/p80211mod.o
  CC      drivers/staging/wlan-ng/p80211conv.o
  CC      drivers/staging/wlan-ng/p80211req.o
  CC      drivers/staging/wlan-ng/p80211wep.o
  CC      drivers/staging/wlan-ng/p80211wext.o
drivers/staging/wlan-ng/p80211wext.c:451:2: warning: #warning "get rid of p2mib here"
  CC      drivers/staging/wlan-ng/p80211netdev.o
  LD      drivers/staging/wlan-ng/p80211.o
  LD      drivers/staging/wlan-ng/built-in.o
  LD      drivers/staging/built-in.o
  CC      drivers/thermal/thermal_sys.o
  LD      drivers/thermal/built-in.o
  LD      drivers/uio/built-in.o
  CC [M]  drivers/uio/uio.o
  CC [M]  drivers/uio/uio_cif.o
  CC [M]  drivers/uio/uio_pdrv.o
  CC [M]  drivers/uio/uio_smx.o
  CC [M]  drivers/uio/uio_sercos3.o
  LD      drivers/usb/atm/built-in.o
  CC [M]  drivers/usb/atm/ueagle-atm.o
  CC [M]  drivers/usb/atm/usbatm.o
  CC [M]  drivers/usb/atm/xusbatm.o
  LD      drivers/usb/c67x00/built-in.o
  CC [M]  drivers/usb/c67x00/c67x00-drv.o
  CC [M]  drivers/usb/c67x00/c67x00-ll-hpi.o
  CC [M]  drivers/usb/c67x00/c67x00-hcd.o
  CC [M]  drivers/usb/c67x00/c67x00-sched.o
  LD [M]  drivers/usb/c67x00/c67x00.o
  LD      drivers/usb/class/built-in.o
  CC [M]  drivers/usb/class/cdc-acm.o
  CC [M]  drivers/usb/class/cdc-wdm.o
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
  LD      drivers/usb/core/usbcore.o
  LD      drivers/usb/core/built-in.o
  CC      drivers/usb/host/pci-quirks.o
  CC      drivers/usb/host/ohci-hcd.o
  CC      drivers/usb/host/hwa-hc.o
  LD      drivers/usb/host/built-in.o
  CC [M]  drivers/usb/host/isp116x-hcd.o
  CC [M]  drivers/usb/host/uhci-hcd.o
  CC [M]  drivers/usb/host/sl811-hcd.o
  CC [M]  drivers/usb/host/sl811_cs.o
  CC [M]  drivers/usb/host/u132-hcd.o
  CC [M]  drivers/usb/host/isp1760-hcd.o
  CC [M]  drivers/usb/host/isp1760-if.o
  LD [M]  drivers/usb/host/isp1760.o
  LD      drivers/usb/image/built-in.o
  CC [M]  drivers/usb/image/mdc800.o
  CC      drivers/usb/misc/adutux.o
  CC      drivers/usb/misc/appledisplay.o
  CC      drivers/usb/misc/berry_charge.o
  CC      drivers/usb/misc/cypress_cy7c63.o
  CC      drivers/usb/misc/ftdi-elan.o
  CC      drivers/usb/misc/isight_firmware.o
  CC      drivers/usb/misc/trancevibrator.o
  CC      drivers/usb/misc/usbsevseg.o
  CC      drivers/usb/misc/vstusb.o
  LD      drivers/usb/misc/built-in.o
  CC [M]  drivers/usb/misc/cytherm.o
  CC [M]  drivers/usb/misc/idmouse.o
  CC [M]  drivers/usb/misc/iowarrior.o
  CC [M]  drivers/usb/misc/usblcd.o
  CC [M]  drivers/usb/misc/legousbtower.o
  CC [M]  drivers/usb/misc/rio500.o
  CC      drivers/usb/mon/mon_main.o
  CC      drivers/usb/mon/mon_stat.o
  CC      drivers/usb/mon/mon_text.o
  CC      drivers/usb/mon/mon_bin.o
  CC      drivers/usb/mon/mon_dma.o
  LD      drivers/usb/mon/usbmon.o
  LD      drivers/usb/mon/built-in.o
  LD      drivers/usb/storage/built-in.o
  CC      drivers/usb/wusbcore/cbaf.o
  CC      drivers/usb/wusbcore/wa-hc.o
  CC      drivers/usb/wusbcore/wa-nep.o
  CC      drivers/usb/wusbcore/wa-rpipe.o
  CC      drivers/usb/wusbcore/wa-xfer.o
  CC      drivers/usb/wusbcore/crypto.o
  CC      drivers/usb/wusbcore/devconnect.o
  CC      drivers/usb/wusbcore/dev-sysfs.o
  CC      drivers/usb/wusbcore/mmc.o
  CC      drivers/usb/wusbcore/pal.o
  CC      drivers/usb/wusbcore/rh.o
  CC      drivers/usb/wusbcore/reservation.o
  CC      drivers/usb/wusbcore/security.o
  CC      drivers/usb/wusbcore/wusbhc.o
  LD      drivers/usb/wusbcore/wusbcore.o
  LD      drivers/usb/wusbcore/wusb-wa.o
  LD      drivers/usb/wusbcore/wusb-cbaf.o
  LD      drivers/usb/wusbcore/built-in.o
  LD      drivers/usb/built-in.o
  LD      drivers/usb/gadget/built-in.o
  CC [M]  drivers/usb/gadget/m66592-udc.o
  CC [M]  drivers/usb/gadget/cdc2.o
  CC [M]  drivers/usb/gadget/printer.o
  CC [M]  drivers/usb/gadget/zero.o
  LD [M]  drivers/usb/gadget/g_zero.o
  LD [M]  drivers/usb/gadget/g_printer.o
  LD [M]  drivers/usb/gadget/g_cdc.o
  CC      drivers/uwb/umc-bus.o
  CC      drivers/uwb/umc-dev.o
  CC      drivers/uwb/umc-drv.o
  CC      drivers/uwb/address.o
  CC      drivers/uwb/beacon.o
  CC      drivers/uwb/driver.o
  CC      drivers/uwb/drp.o
  CC      drivers/uwb/drp-avail.o
  CC      drivers/uwb/drp-ie.o
  CC      drivers/uwb/est.o
  CC      drivers/uwb/ie.o
  CC      drivers/uwb/lc-dev.o
  CC      drivers/uwb/lc-rc.o
  CC      drivers/uwb/neh.o
  CC      drivers/uwb/pal.o
  CC      drivers/uwb/reset.o
  CC      drivers/uwb/rsv.o
  CC      drivers/uwb/scan.o
  CC      drivers/uwb/uwb-debug.o
  CC      drivers/uwb/uwbd.o
  LD      drivers/uwb/uwb.o
  LD      drivers/uwb/umc.o
  CC      drivers/uwb/whci.o
  CC      drivers/uwb/whc-rc.o
drivers/uwb/whc-rc.c:492: warning: 'whcrc_id_table' defined but not used
  CC      drivers/uwb/hwa-rc.o
  LD      drivers/uwb/built-in.o
  LD      drivers/uwb/i1480/built-in.o
  CC [M]  drivers/uwb/i1480/i1480-est.o
  LD      drivers/uwb/i1480/dfu/built-in.o
  CC [M]  drivers/uwb/i1480/dfu/dfu.o
  CC [M]  drivers/uwb/i1480/dfu/mac.o
  CC [M]  drivers/uwb/i1480/dfu/phy.o
  CC [M]  drivers/uwb/i1480/dfu/usb.o
  LD [M]  drivers/uwb/i1480/dfu/i1480-dfu-usb.o
  CC      drivers/video/fb_notify.o
  LD      drivers/video/aty/built-in.o
  CC [M]  drivers/video/aty/atyfb_base.o
  CC [M]  drivers/video/aty/mach64_accel.o
  CC [M]  drivers/video/aty/mach64_cursor.o
  CC [M]  drivers/video/aty/mach64_gx.o
  CC [M]  drivers/video/aty/mach64_ct.o
  LD [M]  drivers/video/aty/atyfb.o
  CC      drivers/video/backlight/backlight.o
  CC      drivers/video/backlight/corgi_bl.o
  CC      drivers/video/backlight/progear_bl.o
  CC      drivers/video/backlight/mbp_nvidia_bl.o
  CC      drivers/video/backlight/kb3886_bl.o
  LD      drivers/video/backlight/built-in.o
  CC [M]  drivers/video/backlight/lcd.o
  CC [M]  drivers/video/backlight/platform_lcd.o
  CC      drivers/video/console/dummycon.o
  LD      drivers/video/console/built-in.o
  CC [M]  drivers/video/console/fbcon.o
  CC [M]  drivers/video/console/bitblit.o
  CC [M]  drivers/video/console/fonts.o
  CC [M]  drivers/video/console/font_sun8x16.o
  CC [M]  drivers/video/console/font_sun12x22.o
  CC [M]  drivers/video/console/font_8x8.o
  CC [M]  drivers/video/console/font_8x16.o
  CC [M]  drivers/video/console/font_7x14.o
  CC [M]  drivers/video/console/font_pearl_8x8.o
  CC [M]  drivers/video/console/font_mini_4x6.o
  LD [M]  drivers/video/console/font.o
  CC [M]  drivers/video/console/softcursor.o
  CC [M]  drivers/video/console/tileblit.o
  CC [M]  drivers/video/console/fbcon_rotate.o
  CC [M]  drivers/video/console/fbcon_cw.o
  CC [M]  drivers/video/console/fbcon_ud.o
  CC [M]  drivers/video/console/fbcon_ccw.o
  LD      drivers/video/display/built-in.o
  CC [M]  drivers/video/display/display-sysfs.o
  LD [M]  drivers/video/display/display.o
  LD      drivers/video/geode/built-in.o
  CC [M]  drivers/video/geode/gx1fb_core.o
  CC [M]  drivers/video/geode/display_gx1.o
  CC [M]  drivers/video/geode/video_cs5530.o
  LD [M]  drivers/video/geode/gx1fb.o
  LD      drivers/video/kyro/built-in.o
  CC [M]  drivers/video/kyro/STG4000Ramdac.o
  CC [M]  drivers/video/kyro/STG4000VTG.o
  CC [M]  drivers/video/kyro/STG4000OverlayDevice.o
  CC [M]  drivers/video/kyro/STG4000InitDevice.o
  CC [M]  drivers/video/kyro/fbdev.o
  LD [M]  drivers/video/kyro/kyrofb.o
  LD      drivers/video/matrox/built-in.o
  CC [M]  drivers/video/matrox/matroxfb_base.o
  CC [M]  drivers/video/matrox/matroxfb_accel.o
  CC [M]  drivers/video/matrox/matroxfb_DAC1064.o
  CC [M]  drivers/video/matrox/matroxfb_Ti3026.o
  CC [M]  drivers/video/matrox/matroxfb_misc.o
  CC [M]  drivers/video/matrox/i2c-matroxfb.o
  LD      drivers/video/nvidia/built-in.o
  CC [M]  drivers/video/nvidia/nvidia.o
  CC [M]  drivers/video/nvidia/nv_hw.o
  CC [M]  drivers/video/nvidia/nv_setup.o
  CC [M]  drivers/video/nvidia/nv_accel.o
  LD [M]  drivers/video/nvidia/nvidiafb.o
  LD      drivers/video/riva/built-in.o
  CC [M]  drivers/video/riva/fbdev.o
  CC [M]  drivers/video/riva/riva_hw.o
  CC [M]  drivers/video/riva/nv_driver.o
  CC [M]  drivers/video/riva/rivafb-i2c.o
  LD [M]  drivers/video/riva/rivafb.o
  LD      drivers/video/savage/built-in.o
  CC [M]  drivers/video/savage/savagefb_driver.o
  CC [M]  drivers/video/savage/savagefb-i2c.o
  CC [M]  drivers/video/savage/savagefb_accel.o
  LD [M]  drivers/video/savage/savagefb.o
  LD      drivers/video/sis/built-in.o
  CC [M]  drivers/video/sis/sis_main.o
  CC [M]  drivers/video/sis/sis_accel.o
  CC [M]  drivers/video/sis/init.o
  CC [M]  drivers/video/sis/init301.o
  CC [M]  drivers/video/sis/initextlfb.o
  LD [M]  drivers/video/sis/sisfb.o
  LD      drivers/video/via/built-in.o
  CC [M]  drivers/video/via/viafbdev.o
  CC [M]  drivers/video/via/hw.o
  CC [M]  drivers/video/via/iface.o
  CC [M]  drivers/video/via/via_i2c.o
  CC [M]  drivers/video/via/dvi.o
  CC [M]  drivers/video/via/lcd.o
  CC [M]  drivers/video/via/ioctl.o
  CC [M]  drivers/video/via/accel.o
  CC [M]  drivers/video/via/via_utility.o
  CC [M]  drivers/video/via/vt1636.o
  CC [M]  drivers/video/via/global.o
  CC [M]  drivers/video/via/tblDPASetting.o
  CC [M]  drivers/video/via/viamode.o
  CC [M]  drivers/video/via/tbl1636.o
  LD [M]  drivers/video/via/viafb.o
  LD      drivers/video/built-in.o
  CC [M]  drivers/video/vgastate.o
  CC [M]  drivers/video/fbmem.o
  CC [M]  drivers/video/fbmon.o
  CC [M]  drivers/video/fbcmap.o
  CC [M]  drivers/video/fbsysfs.o
  CC [M]  drivers/video/modedb.o
  CC [M]  drivers/video/fbcvt.o
  LD [M]  drivers/video/fb.o
  CC [M]  drivers/video/cfbfillrect.o
  CC [M]  drivers/video/cfbcopyarea.o
  CC [M]  drivers/video/cfbimgblt.o
  CC [M]  drivers/video/svgalib.o
  CC [M]  drivers/video/fb_ddc.o
  CC [M]  drivers/video/pm2fb.o
  CC [M]  drivers/video/macmodes.o
  CC [M]  drivers/video/neofb.o
  CC [M]  drivers/video/vt8623fb.o
  CC [M]  drivers/video/tridentfb.o
  CC [M]  drivers/video/s3fb.o
  CC [M]  drivers/video/arkfb.o
  CC [M]  drivers/video/hgafb.o
  CC [M]  drivers/video/cirrusfb.o
  CC [M]  drivers/video/s1d13xxxfb.o
  CC [M]  drivers/video/sm501fb.o
  CC [M]  drivers/video/uvesafb.o
  CC [M]  drivers/video/vga16fb.o
  LD      drivers/w1/masters/built-in.o
  CC [M]  drivers/w1/masters/matrox_w1.o
  CC [M]  drivers/w1/masters/ds2490.o
  CC [M]  drivers/w1/masters/ds2482.o
  CC [M]  drivers/w1/masters/w1-gpio.o
  LD      drivers/w1/slaves/built-in.o
  CC [M]  drivers/w1/slaves/w1_smem.o
  LD      drivers/w1/built-in.o
  CC [M]  drivers/w1/w1.o
  CC [M]  drivers/w1/w1_int.o
  CC [M]  drivers/w1/w1_family.o
  CC [M]  drivers/w1/w1_netlink.o
  CC [M]  drivers/w1/w1_io.o
  LD [M]  drivers/w1/wire.o
  LD      drivers/built-in.o
  LD      sound/built-in.o
  MK_FW   firmware/dabusb/firmware.fw.gen.S
  HOSTCC  firmware/ihex2fw
  IHEX2FW firmware/dabusb/firmware.fw
  AS      firmware/dabusb/firmware.fw.gen.o
  MK_FW   firmware/dabusb/bitstream.bin.gen.S
  IHEX    firmware/dabusb/bitstream.bin
  AS      firmware/dabusb/bitstream.bin.gen.o
  LD      firmware/built-in.o
  CC      arch/x86/pci/i386.o
  CC      arch/x86/pci/init.o
  CC      arch/x86/pci/direct.o
  CC      arch/x86/pci/fixup.o
  CC      arch/x86/pci/legacy.o
  CC      arch/x86/pci/irq.o
  CC      arch/x86/pci/common.o
  CC      arch/x86/pci/early.o
  CC      arch/x86/pci/amd_bus.o
  LD      arch/x86/pci/built-in.o
  CC      arch/x86/power/cpu_64.o
  LD      arch/x86/power/built-in.o
  CC      net/socket.o
  CC      net/802/p8022.o
  CC      net/802/psnap.o
  CC      net/802/tr.o
  CC      net/802/fddi.o
  LD      net/802/built-in.o
  CC [M]  net/802/stp.o
  CC      net/9p/mod.o
  CC      net/9p/client.o
  CC      net/9p/error.o
  CC      net/9p/util.o
  CC      net/9p/protocol.o
  CC      net/9p/trans_fd.o
  LD      net/9p/9pnet.o
  LD      net/9p/built-in.o
  CC [M]  net/9p/trans_rdma.o
  LD [M]  net/9p/9pnet_rdma.o
  LD      net/appletalk/built-in.o
  CC [M]  net/appletalk/aarp.o
  CC [M]  net/appletalk/ddp.o
  CC [M]  net/appletalk/dev.o
  CC [M]  net/appletalk/sysctl_net_atalk.o
  LD [M]  net/appletalk/appletalk.o
  LD      net/atm/built-in.o
  CC [M]  net/atm/addr.o
  CC [M]  net/atm/pvc.o
  CC [M]  net/atm/signaling.o
  CC [M]  net/atm/svc.o
  CC [M]  net/atm/ioctl.o
  CC [M]  net/atm/common.o
  CC [M]  net/atm/atm_misc.o
  CC [M]  net/atm/raw.o
  CC [M]  net/atm/resources.o
  CC [M]  net/atm/atm_sysfs.o
  LD [M]  net/atm/atm.o
  CC [M]  net/atm/lec.o
  CC [M]  net/atm/pppoatm.o
  CC      net/ax25/ax25_addr.o
  CC      net/ax25/ax25_dev.o
  CC      net/ax25/ax25_iface.o
  CC      net/ax25/ax25_in.o
  CC      net/ax25/ax25_ip.o
  CC      net/ax25/ax25_out.o
  CC      net/ax25/ax25_route.o
  CC      net/ax25/ax25_std_in.o
  CC      net/ax25/ax25_std_subr.o
  CC      net/ax25/ax25_std_timer.o
  CC      net/ax25/ax25_subr.o
  CC      net/ax25/ax25_timer.o
  CC      net/ax25/ax25_uid.o
  CC      net/ax25/af_ax25.o
  CC      net/ax25/ax25_ds_in.o
  CC      net/ax25/ax25_ds_subr.o
  CC      net/ax25/ax25_ds_timer.o
  CC      net/ax25/sysctl_net_ax25.o
  LD      net/ax25/ax25.o
  LD      net/ax25/built-in.o
  LD      net/bridge/built-in.o
  CC [M]  net/bridge/br.o
  CC [M]  net/bridge/br_device.o
  CC [M]  net/bridge/br_fdb.o
  CC [M]  net/bridge/br_forward.o
  CC [M]  net/bridge/br_if.o
  CC [M]  net/bridge/br_input.o
  CC [M]  net/bridge/br_ioctl.o
  CC [M]  net/bridge/br_notify.o
  CC [M]  net/bridge/br_stp.o
  CC [M]  net/bridge/br_stp_bpdu.o
  CC [M]  net/bridge/br_stp_if.o
  CC [M]  net/bridge/br_stp_timer.o
  CC [M]  net/bridge/br_netlink.o
  CC [M]  net/bridge/br_sysfs_if.o
  CC [M]  net/bridge/br_sysfs_br.o
  LD [M]  net/bridge/bridge.o
  CC      net/can/af_can.o
  CC      net/can/proc.o
  LD      net/can/can.o
  LD      net/can/built-in.o
  CC [M]  net/can/bcm.o
  LD [M]  net/can/can-bcm.o
  CC      net/core/sock.o
  CC      net/core/request_sock.o
  CC      net/core/skbuff.o
  CC      net/core/iovec.o
  CC      net/core/datagram.o
  CC      net/core/stream.o
  CC      net/core/scm.o
  CC      net/core/gen_stats.o
  CC      net/core/gen_estimator.o
  CC      net/core/net_namespace.o
  CC      net/core/sysctl_net_core.o
  CC      net/core/skb_dma_map.o
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
  CC      net/core/fib_rules.o
  LD      net/core/built-in.o
  LD      net/decnet/netfilter/built-in.o
  CC [M]  net/decnet/netfilter/dn_rtmsg.o
  LD      net/decnet/built-in.o
  CC [M]  net/decnet/af_decnet.o
  CC [M]  net/decnet/dn_nsp_in.o
  CC [M]  net/decnet/dn_nsp_out.o
  CC [M]  net/decnet/dn_route.o
  CC [M]  net/decnet/dn_dev.o
  CC [M]  net/decnet/dn_neigh.o
  CC [M]  net/decnet/dn_timer.o
  CC [M]  net/decnet/dn_fib.o
  CC [M]  net/decnet/dn_rules.o
  CC [M]  net/decnet/dn_table.o
  CC [M]  net/decnet/sysctl_net_decnet.o
  LD [M]  net/decnet/decnet.o
  CC      net/dsa/tag_edsa.o
  CC      net/dsa/tag_trailer.o
  CC      net/dsa/mv88e6xxx.o
  CC      net/dsa/mv88e6060.o
  CC      net/dsa/mv88e6123_61_65.o
  CC      net/dsa/dsa.o
  CC      net/dsa/slave.o
  LD      net/dsa/built-in.o
  CC      net/ethernet/eth.o
  CC      net/ethernet/pe2.o
  LD      net/ethernet/built-in.o
  CC      net/ieee80211/ieee80211_module.o
  CC      net/ieee80211/ieee80211_tx.o
  CC      net/ieee80211/ieee80211_rx.o
  CC      net/ieee80211/ieee80211_wx.o
  CC      net/ieee80211/ieee80211_geo.o
  LD      net/ieee80211/ieee80211.o
  CC      net/ieee80211/ieee80211_crypt.o
  CC      net/ieee80211/ieee80211_crypt_wep.o
  CC      net/ieee80211/ieee80211_crypt_ccmp.o
  CC      net/ieee80211/ieee80211_crypt_tkip.o
  LD      net/ieee80211/built-in.o
  LD      net/irda/built-in.o
  CC [M]  net/irda/iriap.o
  CC [M]  net/irda/iriap_event.o
  CC [M]  net/irda/irlmp.o
  CC [M]  net/irda/irlmp_event.o
  CC [M]  net/irda/irlmp_frame.o
  CC [M]  net/irda/irlap.o
  CC [M]  net/irda/irlap_event.o
  CC [M]  net/irda/irlap_frame.o
  CC [M]  net/irda/timer.o
  CC [M]  net/irda/qos.o
  CC [M]  net/irda/irqueue.o
  CC [M]  net/irda/irttp.o
  CC [M]  net/irda/irda_device.o
  CC [M]  net/irda/irias_object.o
  CC [M]  net/irda/wrapper.o
  CC [M]  net/irda/af_irda.o
  CC [M]  net/irda/discovery.o
  CC [M]  net/irda/parameters.o
  CC [M]  net/irda/irnetlink.o
  CC [M]  net/irda/irmod.o
  CC [M]  net/irda/irsysctl.o
  LD [M]  net/irda/irda.o
  LD      net/irda/ircomm/built-in.o
  CC [M]  net/irda/ircomm/ircomm_tty.o
  CC [M]  net/irda/ircomm/ircomm_tty_attach.o
  CC [M]  net/irda/ircomm/ircomm_tty_ioctl.o
  CC [M]  net/irda/ircomm/ircomm_param.o
  CC [M]  net/irda/ircomm/ircomm_core.o
  CC [M]  net/irda/ircomm/ircomm_event.o
  CC [M]  net/irda/ircomm/ircomm_lmp.o
  CC [M]  net/irda/ircomm/ircomm_ttp.o
  LD [M]  net/irda/ircomm/ircomm.o
  LD [M]  net/irda/ircomm/ircomm-tty.o
  LD      net/irda/irnet/built-in.o
  CC [M]  net/irda/irnet/irnet_ppp.o
  CC [M]  net/irda/irnet/irnet_irda.o
  LD [M]  net/irda/irnet/irnet.o
  CC      net/key/af_key.o
  LD      net/key/built-in.o
  LD      net/lapb/built-in.o
  CC [M]  net/lapb/lapb_in.o
  CC [M]  net/lapb/lapb_out.o
  CC [M]  net/lapb/lapb_subr.o
  CC [M]  net/lapb/lapb_timer.o
  CC [M]  net/lapb/lapb_iface.o
  LD [M]  net/lapb/lapb.o
  CC      net/llc/llc_core.o
  CC      net/llc/llc_input.o
  CC      net/llc/llc_output.o
  CC      net/llc/llc_if.o
  CC      net/llc/llc_c_ev.o
  CC      net/llc/llc_c_ac.o
  CC      net/llc/llc_conn.o
  CC      net/llc/llc_c_st.o
  CC      net/llc/llc_pdu.o
  CC      net/llc/llc_sap.o
  CC      net/llc/llc_s_ac.o
  CC      net/llc/llc_s_ev.o
  CC      net/llc/llc_s_st.o
  CC      net/llc/af_llc.o
  CC      net/llc/llc_station.o
  CC      net/llc/sysctl_net_llc.o
  LD      net/llc/llc.o
  LD      net/llc/llc2.o
  LD      net/llc/built-in.o
  CC      net/netfilter/core.o
  CC      net/netfilter/nf_log.o
  CC      net/netfilter/nf_queue.o
  CC      net/netfilter/nf_sockopt.o
  LD      net/netfilter/netfilter.o
  LD      net/netfilter/built-in.o
  CC      net/netlink/af_netlink.o
  CC      net/netlink/attr.o
  CC      net/netlink/genetlink.o
  LD      net/netlink/built-in.o
  LD      net/netrom/built-in.o
  CC [M]  net/netrom/af_netrom.o
  CC [M]  net/netrom/nr_dev.o
  CC [M]  net/netrom/nr_in.o
  CC [M]  net/netrom/nr_loopback.o
  CC [M]  net/netrom/nr_out.o
  CC [M]  net/netrom/nr_route.o
  CC [M]  net/netrom/nr_subr.o
  CC [M]  net/netrom/nr_timer.o
  CC [M]  net/netrom/sysctl_net_netrom.o
  LD [M]  net/netrom/netrom.o
  CC      net/packet/af_packet.o
net/packet/af_packet.c: In function 'tpacket_rcv':
net/packet/af_packet.c:604: warning: 'hdrlen' may be used uninitialized in this function
  LD      net/packet/built-in.o
  CC      net/phonet/pn_dev.o
  CC      net/phonet/pn_netlink.o
  CC      net/phonet/socket.o
  CC      net/phonet/datagram.o
  CC      net/phonet/sysctl.o
  CC      net/phonet/af_phonet.o
  CC      net/phonet/pep.o
  CC      net/phonet/pep-gprs.o
  LD      net/phonet/phonet.o
  LD      net/phonet/pn_pep.o
  LD      net/phonet/built-in.o
  CC      net/sched/sch_generic.o
net/sched/sch_generic.c: In function 'dev_watchdog':
net/sched/sch_generic.c:224: warning: unused variable 'drivername'
  CC      net/sched/sch_api.o
  CC      net/sched/sch_blackhole.o
  CC      net/sched/cls_api.o
  CC      net/sched/act_api.o
  CC      net/sched/act_simple.o
  CC      net/sched/sch_fifo.o
  CC      net/sched/sch_hfsc.o
  CC      net/sched/sch_red.o
  CC      net/sched/sch_dsmark.o
  CC      net/sched/sch_sfq.o
  CC      net/sched/sch_tbf.o
  CC      net/sched/sch_teql.o
  CC      net/sched/sch_multiq.o
  CC      net/sched/sch_netem.o
  CC      net/sched/cls_tcindex.o
  CC      net/sched/cls_flow.o
  LD      net/sched/built-in.o
  CC [M]  net/sched/act_police.o
  CC [M]  net/sched/act_gact.o
  CC [M]  net/sched/act_mirred.o
  CC [M]  net/sched/act_skbedit.o
  CC [M]  net/sched/sch_cbq.o
  CC [M]  net/sched/sch_ingress.o
  CC [M]  net/sched/sch_prio.o
  CC [M]  net/sched/sch_atm.o
  CC [M]  net/sched/cls_route.o
  CC [M]  net/sched/cls_fw.o
  CC [M]  net/sched/cls_basic.o
  LD      net/unix/built-in.o
  CC [M]  net/unix/af_unix.o
  CC [M]  net/unix/garbage.o
  CC [M]  net/unix/sysctl_net_unix.o
  LD [M]  net/unix/unix.o
  CC      net/wireless/wext.o
  CC      net/wireless/lib80211.o
  LD      net/wireless/built-in.o
  CC      net/xfrm/xfrm_policy.o
  CC      net/xfrm/xfrm_state.o
  CC      net/xfrm/xfrm_hash.o
  CC      net/xfrm/xfrm_input.o
  CC      net/xfrm/xfrm_output.o
  CC      net/xfrm/xfrm_algo.o
  LD      net/xfrm/built-in.o
  CC      net/sysctl_net.o
  LD      net/built-in.o
  CC      lib/bcd.o
  CC      lib/div64.o
  CC      lib/sort.o
  CC      lib/parser.o
  CC      lib/halfmd4.o
  CC      lib/debug_locks.o
  CC      lib/random32.o
  CC      lib/bust_spinlocks.o
  CC      lib/hexdump.o
  CC      lib/kasprintf.o
  CC      lib/bitmap.o
  CC      lib/scatterlist.o
  CC      lib/string_helpers.o
  CC      lib/iomap.o
  CC      lib/iomap_copy.o
  CC      lib/devres.o
  CC      lib/locking-selftest.o
  CC      lib/spinlock_debug.o
  CC      lib/hweight.o
  CC      lib/plist.o
  CC      lib/list_debug.o
  CC      lib/bitrev.o
  CC      lib/crc-ccitt.o
  CC      lib/crc16.o
  CC      lib/crc-t10dif.o
  CC      lib/crc-itu-t.o
  HOSTCC  lib/gen_crc32table
  GEN     lib/crc32table.h
  CC      lib/crc32.o
  CC      lib/lzo/lzo1x_compress.o
  CC      lib/lzo/lzo1x_decompress.o
  LD      lib/lzo/lzo_compress.o
  LD      lib/lzo/lzo_decompress.o
  LD      lib/lzo/built-in.o
  CC      lib/zlib_deflate/deflate.o
  CC      lib/zlib_deflate/deftree.o
  CC      lib/zlib_deflate/deflate_syms.o
  LD      lib/zlib_deflate/zlib_deflate.o
  LD      lib/zlib_deflate/built-in.o
  CC      lib/zlib_inflate/inffast.o
  CC      lib/zlib_inflate/inflate.o
  CC      lib/zlib_inflate/infutil.o
  CC      lib/zlib_inflate/inftrees.o
  CC      lib/zlib_inflate/inflate_syms.o
  LD      lib/zlib_inflate/zlib_inflate.o
  LD      lib/zlib_inflate/built-in.o
  CC      lib/swiotlb.o
  CC      lib/iommu-helper.o
  CC      lib/fault-inject.o
  CC      lib/syscall.o
  CC      lib/dynamic_printk.o
  LD      lib/built-in.o
  CC      lib/argv_split.o
  CC      lib/cmdline.o
  CC      lib/ctype.o
  CC      lib/dec_and_lock.o
  CC      lib/dump_stack.o
  CC      lib/extable.o
  CC      lib/find_next_bit.o
  CC      lib/idr.o
  CC      lib/int_sqrt.o
  CC      lib/ioremap.o
  CC      lib/irq_regs.o
  CC      lib/klist.o
  CC      lib/kobject.o
  CC      lib/kobject_uevent.o
  CC      lib/kref.o
  CC      lib/prio_heap.o
  CC      lib/prio_tree.o
  CC      lib/proportions.o
  CC      lib/radix-tree.o
  CC      lib/ratelimit.o
  CC      lib/rbtree.o
  CC      lib/reciprocal_div.o
  CC      lib/rwsem-spinlock.o
  CC      lib/sha1.o
  CC      lib/show_mem.o
  CC      lib/string.o
  CC      lib/vsprintf.o
  AR      lib/lib.a
  CC [M]  lib/crc7.o
  CC [M]  lib/libcrc32c.o
  CC      arch/x86/lib/io_64.o
  AS      arch/x86/lib/iomap_copy_64.o
  LD      arch/x86/lib/built-in.o
  AS      arch/x86/lib/clear_page_64.o
  AS      arch/x86/lib/copy_page_64.o
  AS      arch/x86/lib/copy_user_64.o
  AS      arch/x86/lib/copy_user_nocache_64.o
  AS      arch/x86/lib/csum-copy_64.o
  CC      arch/x86/lib/csum-partial_64.o
  CC      arch/x86/lib/csum-wrappers_64.o
  CC      arch/x86/lib/delay.o
  AS      arch/x86/lib/getuser.o
  AS      arch/x86/lib/memcpy_64.o
  CC      arch/x86/lib/memmove_64.o
  AS      arch/x86/lib/memset_64.o
  AS      arch/x86/lib/putuser.o
  AS      arch/x86/lib/rwlock_64.o
  AS      arch/x86/lib/thunk_64.o
  CC      arch/x86/lib/usercopy_64.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 6 section mismatch(es).
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
  INSTALL include/drm (11 files)
  INSTALL include/linux/byteorder (4 files)
  INSTALL include/linux/can (3 files)
  INSTALL include/linux/dvb (8 files)
  INSTALL include/linux/hdlc (1 file)
  INSTALL include/linux/isdn (1 file)
  INSTALL include/linux/netfilter (49 files)
  INSTALL include/linux/netfilter_arp (2 files)
  INSTALL include/linux/netfilter_bridge (16 files)
  INSTALL include/linux/netfilter_ipv4 (46 files)
  INSTALL include/linux/netfilter_ipv6 (20 files)
  INSTALL include/linux/nfsd (6 files)
  INSTALL include/linux/raid (2 files)
  INSTALL include/linux/spi (1 file)
  INSTALL include/linux/sunrpc (1 file)
  INSTALL include/linux/tc_act (6 files)
  INSTALL include/linux/tc_ematch (4 files)
  INSTALL include/linux/usb (8 files)
  INSTALL include/linux (351 files)
  INSTALL include/mtd (6 files)
  INSTALL include/rdma (1 file)
  INSTALL include/sound (9 files)
  INSTALL include/video (3 files)
  INSTALL include (0 file)
  INSTALL include/asm (52 files)
  CHECK   include/asm-generic (12 files)
  CHECK   include/drm (11 files)
  CHECK   include/linux/byteorder (4 files)
  CHECK   include/linux/can (3 files)
  CHECK   include/linux/dvb (8 files)
  CHECK   include/linux/hdlc (1 files)
  CHECK   include/linux/isdn (1 files)
  CHECK   include/linux/netfilter (49 files)
  CHECK   include/linux/netfilter_arp (2 files)
  CHECK   include/linux/netfilter_bridge (16 files)
  CHECK   include/linux/netfilter_ipv4 (46 files)
  CHECK   include/linux/netfilter_ipv6 (20 files)
  CHECK   include/linux/nfsd (6 files)
  CHECK   include/linux/raid (2 files)
  CHECK   include/linux/spi (1 files)
  CHECK   include/linux/sunrpc (1 files)
  CHECK   include/linux/tc_act (6 files)
  CHECK   include/linux/tc_ematch (4 files)
  CHECK   include/linux/usb (8 files)
  CHECK   include/linux (351 files)
  CHECK   include/mtd (6 files)
  CHECK   include/rdma (1 files)
  CHECK   include/sound (9 files)
  CHECK   include/video (3 files)
  CHECK   include (0 files)
  CHECK   include/asm (52 files)
  LD      Documentation/DocBook/built-in.o
  CC [M]  Documentation/DocBook/procfs_example.o
  LD      Documentation/accounting/built-in.o
  HOSTCC  Documentation/accounting/getdelays
Documentation/accounting/getdelays.c: In function 'main':
Documentation/accounting/getdelays.c:249: warning: 'cmd_type' may be used uninitialized in this function
  LD      Documentation/auxdisplay/built-in.o
  HOSTCC  Documentation/auxdisplay/cfag12864b-example
  LD      Documentation/connector/built-in.o
  CC [M]  Documentation/connector/cn_test.o
Documentation/connector/cn_test.c:45: warning: 'cn_test_want_notify' defined but not used
  HOSTCC  Documentation/connector/ucon
  LD      Documentation/filesystems/configfs/built-in.o
  CC [M]  Documentation/filesystems/configfs/configfs_example_explicit.o
  CC [M]  Documentation/filesystems/configfs/configfs_example_macros.o
  LD      Documentation/ia64/built-in.o
  HOSTCC  Documentation/ia64/aliasing-test
  LD      Documentation/networking/built-in.o
  HOSTCC  Documentation/networking/ifenslave
  LD      Documentation/pcmcia/built-in.o
  HOSTCC  Documentation/pcmcia/crc32hash
  LD      Documentation/spi/built-in.o
  HOSTCC  Documentation/spi/spidev_test
  HOSTCC  Documentation/spi/spidev_fdx
  LD      Documentation/video4linux/built-in.o
  HOSTCC  Documentation/video4linux/v4lgrab
Documentation/video4linux/v4lgrab.c: In function 'main':
Documentation/video4linux/v4lgrab.c:184: warning: 'src_depth' is used uninitialized in this function
Documentation/video4linux/v4lgrab.c:99: warning: 'b' may be used uninitialized in this function
Documentation/video4linux/v4lgrab.c:99: warning: 'g' may be used uninitialized in this function
Documentation/video4linux/v4lgrab.c:99: warning: 'r' may be used uninitialized in this function
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
  CPUSTR  arch/x86/boot/cpustr.h
  CC      arch/x86/boot/cpu.o
  CC      arch/x86/boot/cpucheck.o
  CC      arch/x86/boot/edd.o
  AS      arch/x86/boot/compressed/head_64.o
  CC      arch/x86/boot/compressed/misc.o
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  LD      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  OFFSETS arch/x86/boot/offsets.h
  AS      arch/x86/boot/header.o
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
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/vmlinux.bin
  HOSTCC  arch/x86/boot/tools/build
  BUILD   arch/x86/boot/bzImage
Root device is (3, 3)
Setup is 12856 bytes (padded to 13312 bytes).
System is 2769 kB
CRC 2c447e3c
Kernel: arch/x86/boot/bzImage is ready  (#215)
  Building modules, stage 2.
  MODPOST 419 modules
ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

--------------090100060202050504070308
Content-Type: text/plain;
 name="randconfig-13.config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="randconfig-13.config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc3
# Fri Jan 23 14:13:17 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
# CONFIG_BUG is not set
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_BLOCK is not set
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
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
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y

#
# Hardware Performance Monitoring support
#
CONFIG_PERFMON=y
CONFIG_PERFMON_DEBUG=y
CONFIG_X86_PERFMON_INTEL_ARCH=y
# CONFIG_X86_PERFMON_AMD64 is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_ACPI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_CPU_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
# CONFIG_BINFMT_ELF is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=m
CONFIG_XFRM=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_ATM=m
CONFIG_ATM_LANE=m
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=m
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=y
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=m
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_PHONET=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set

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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=m
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
# CONFIG_IEEE1394_PCILYNX is not set

#
# SBP-2 support (for storage devices) requires SCSI
#
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
CONFIG_DUMMY=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=m
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=m
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=m
CONFIG_8139CP=y
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
# CONFIG_SIS900 is not set
CONFIG_EPIC100=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_TLAN is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
CONFIG_IGB=m
CONFIG_IGB_DCA=y
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_SIS190=y
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2=y
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_IXGB=m
# CONFIG_S2IO is not set
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_TEHUTI is not set
CONFIG_BNX2X=m
CONFIG_QLGE=y
CONFIG_TR=y
CONFIG_IBMOL=y
# CONFIG_3C359 is not set
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
# CONFIG_ABYSS is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_PCMCIA_WAVELAN=m
CONFIG_PCMCIA_NETWAVE=m
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=m
# CONFIG_IPW2200_MONITOR is not set
CONFIG_IPW2200_QOS=y
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_CS=m
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_AIRO=m
CONFIG_HERMES=y
# CONFIG_PLX_HERMES is not set
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
# CONFIG_PCMCIA_HERMES is not set
CONFIG_PCMCIA_SPECTRUM=m
# CONFIG_ATMEL is not set
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_HOSTAP_CS=m

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
# CONFIG_ATM_ENI_BURST_TX_8W is not set
CONFIG_ATM_ENI_BURST_TX_4W=y
# CONFIG_ATM_ENI_BURST_TX_2W is not set
CONFIG_ATM_ENI_BURST_RX_16W=y
# CONFIG_ATM_ENI_BURST_RX_8W is not set
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_FDDI=y
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
# CONFIG_PPPOE is not set
CONFIG_PPPOATM=m
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_ISDN=y
CONFIG_MISDN=y
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
CONFIG_CAPI_EICON=y
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=m
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
# CONFIG_ISI is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=y
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=y
# CONFIG_SX is not set
CONFIG_RIO=y
CONFIG_RIO_OLDPCI=y
CONFIG_STALDRV=y
# CONFIG_STALLION is not set
CONFIG_ISTALLION=m
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
CONFIG_TPS65010=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m

#
# SPI GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_WM8400=m
CONFIG_MFD_WM8350=m
CONFIG_MFD_WM8350_I2C=m
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
CONFIG_DAB=y
CONFIG_USB_DABUSB=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
# CONFIG_FB_TRIDENT_ACCEL is not set
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_SM501=m
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
CONFIG_BACKLIGHT_SAHARA=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
# CONFIG_FONT_ACORN_8x8 is not set
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1760_PCI is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=m
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_VST=y
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C2410 is not set
CONFIG_USB_GADGET_M66592=y
CONFIG_USB_M66592=m
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
# CONFIG_USB_ETH is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_WLP is not set
CONFIG_UWB_I1480U=m
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_IPATH is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=m
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_SMX=m
CONFIG_UIO_SERCOS3=m
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_SXG=y
CONFIG_ME4000=y
# CONFIG_USB_IP_COMMON is not set
CONFIG_PRISM2_USB=y
# CONFIG_ECHO is not set
# CONFIG_USB_ATMEL is not set
CONFIG_POCH=m

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_FS_POSIX_ACL=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_KOBJECT=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_KPROBES_SANITY_TEST=y
CONFIG_BACKTRACE_SELF_TEST=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_KMEMTRACE=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--------------090100060202050504070308--
