Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYBLIpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYBLIpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761618AbYBLIov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:44:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:36223 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761615AbYBLIoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:44:46 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19jT0Qt1t5jP8g+xblBEwA4golAvT9x6iWYab546y
	lQu09PjdW7mTfh
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Date: Tue, 12 Feb 2008 09:44:42 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Subject: build #349 issue for v2.6.25-rc1 : Section mismatch from arch_register_cpu() to .cpuinit.text:register_cpu()
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed;
  boundary="nextPart2288458.Iek11LiafI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802120944.42850.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2288458.Iek11LiafI
Content-Type: multipart/mixed;
  boundary="Boundary-01=_6xVsHADERpAmpt0"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_6xVsHADERpAmpt0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

the build with the attached .config failed, make ends with:
=2E..
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x7cae): Section mismatch in reference from the fu=
nction arch_register_cpu() to the function .cpuinit.text:register_cpu()
The function arch_register_cpu() references
the function __cpuinit register_cpu().
This is often because arch_register_cpu lacks a __cpuinit=20
annotation or the annotation of register_cpu is wrong.

WARNING: vmlinux.o(.text+0x14ae7): Section mismatch in reference from the f=
unction cpu_exit_clear() to the function .cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit=20
annotation or the annotation of cpu_uninit is wrong.

WARNING: vmlinux.o(.text+0x4ecb9): Section mismatch in reference from the f=
unction take_cpu_down() to the variable .cpuinit.data:cpu_chain
The function take_cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because take_cpu_down lacks a __cpuinitdata=20
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4ed46): Section mismatch in reference from the f=
unction _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata=20
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4edbc): Section mismatch in reference from the f=
unction _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata=20
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4ee1f): Section mismatch in reference from the f=
unction _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata=20
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4ee4b): Section mismatch in reference from the f=
unction _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata=20
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4ef6e): Section mismatch in reference from the f=
unction unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain
The function unregister_cpu_notifier() references
the variable __cpuinitdata cpu_chain.
This is often because unregister_cpu_notifier lacks a __cpuinitdata=20
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x1a2051): Section mismatch in reference from the =
function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_b=
us()
The function pci_scan_child_bus() references
the function __devinit pcibios_fixup_bus().
This is often because pci_scan_child_bus lacks a __devinit=20
annotation or the annotation of pcibios_fixup_bus is wrong.

WARNING: vmlinux.o(.text+0x1d33cf): Section mismatch in reference from the =
function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_ro=
ot()
The function acpi_pci_root_add() references
the function __devinit pci_acpi_scan_root().
This is often because acpi_pci_root_add lacks a __devinit=20
annotation or the annotation of pci_acpi_scan_root is wrong.

WARNING: vmlinux.o(.text+0x20d764): Section mismatch in reference from the =
function store_online() to the function .cpuinit.text:cpu_up()
The function store_online() references
the function __cpuinit cpu_up().
This is often because store_online lacks a __cpuinit=20
annotation or the annotation of cpu_up is wrong.

WARNING: vmlinux.o(.text+0x2efd08): Section mismatch in reference from the =
function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_=
cpu_notifier
The function cpufreq_unregister_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_unregister_driver lacks a __cpuinitdata=20
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: vmlinux.o(.text+0x2f156b): Section mismatch in reference from the =
function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cp=
u_notifier
The function cpufreq_register_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_register_driver lacks a __cpuinitdata=20
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: vmlinux.o(.text+0x2f1570): Section mismatch in reference from the =
function cpufreq_register_driver() to the function .cpuinit.text:register_c=
pu_notifier()
The function cpufreq_register_driver() references
the function __cpuinit register_cpu_notifier().
This is often because cpufreq_register_driver lacks a __cpuinit=20
annotation or the annotation of register_cpu_notifier is wrong.

WARNING: vmlinux.o(.meminit.text+0x8b2): Section mismatch in reference from=
 the function free_area_init_core() to the function .init.text:setup_usemap=
()
The function __meminit free_area_init_core() references
a function __init setup_usemap().
If free_area_init_core is only used by setup_usemap then
annotate free_area_init_core with a matching annotation.

WARNING: vmlinux.o(.data+0x3e74): Section mismatch in reference from the va=
riable profile_cpu_callback_nb.19618 to the function .devinit.text:profile_=
cpu_callback()
The variable profile_cpu_callback_nb.19618 references
the function __devinit profile_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x5714): Section mismatch in reference from the va=
riable workqueue_cpu_callback_nb.13987 to the function .devinit.text:workqu=
eue_cpu_callback()
The variable workqueue_cpu_callback_nb.13987 references
the function __devinit workqueue_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x77a4): Section mismatch in reference from the va=
riable cpu_callback_nb.24120 to the function .devinit.text:cpu_callback()
The variable cpu_callback_nb.24120 references
the function __devinit cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x118bc): Section mismatch in reference from the v=
ariable percpu_counter_hotcpu_callback_nb.10103 to the function .cpuinit.te=
xt:percpu_counter_hotcpu_callback()
The variable percpu_counter_hotcpu_callback_nb.10103 references
the function __cpuinit percpu_counter_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x19b20): Section mismatch in reference from the v=
ariable topology_cpu_callback_nb.11595 to the function .cpuinit.text:topolo=
gy_cpu_callback()
The variable topology_cpu_callback_nb.11595 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x25774): Section mismatch in reference from the v=
ariable pccard_sysfs_interface to the function .devinit.text:pccard_sysfs_a=
dd_socket()
The variable pccard_sysfs_interface references
the function __devinit pccard_sysfs_add_socket()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x25778): Section mismatch in reference from the v=
ariable pccard_sysfs_interface to the function .devexit.text:pccard_sysfs_r=
emove_socket()
The variable pccard_sysfs_interface references
the function __devexit pccard_sysfs_remove_socket()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `apanel_detach_client':
apanel.c:(.text+0x14302c): undefined reference to `__led_classdev_unregiste=
r'
drivers/built-in.o: In function `apanel_probe':
apanel.c:(.text+0x143282): undefined reference to `led_classdev_register'
make: *** [.tmp_vmlinux1] Error 1


The build was made with :
$> make mrproper && make rndconfig && <tweak config file> && make oldconfig=
 && make

Here's the config:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc1
# Mon Feb 11 17:19:52 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=3Dy
# CONFIG_X86_64 is not set
CONFIG_X86=3Dy
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_FAST_CMPXCHG_LOCAL=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_QUICKLIST=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_GENERIC_GPIO=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_DMI=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_X86_SMP=3Dy
CONFIG_X86_32_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
CONFIG_KTIME_SCALAR=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D""
CONFIG_LOCALVERSION_AUTO=3Dy
CONFIG_SWAP=3Dy
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=3Dy
# CONFIG_AUDITSYSCALL is not set
CONFIG_IKCONFIG=3Dy
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=3D14
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=3Dy
CONFIG_FAIR_USER_SCHED=3Dy
# CONFIG_FAIR_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=3Dy
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_SYSCTL=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_MARKERS=3Dy
CONFIG_HAVE_OPROFILE=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_LBD=3Dy
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=3Dy
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"deadline"
CONFIG_CLASSIC_RCU=3Dy
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
CONFIG_X86_RDC321X=3Dy
# CONFIG_X86_VSMP is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=3Dy
# CONFIG_XEN is not set
CONFIG_VMI=3Dy
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=3Dy
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
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
CONFIG_MVIAC3_2=3Dy
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D5
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_ALIGNMENT_16=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D4
CONFIG_X86_DEBUGCTLMSR=3Dy
# CONFIG_HPET_TIMER is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=3D8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_RCU_TRACE=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_MCE=3Dy
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=3Dy
CONFIG_TOSHIBA=3Dy
CONFIG_I8K=3Dy
CONFIG_X86_REBOOTFIXUPS=3Dy
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=3Dy
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=3D0xC0000000
CONFIG_HIGHMEM=3Dy
CONFIG_FLATMEM=3Dy
CONFIG_FLAT_NODE_MEM_MAP=3Dy
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=3D4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_NR_QUICK=3D1
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
CONFIG_EFI=3Dy
CONFIG_IRQBALANCE=3Dy
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=3Dy
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D300
CONFIG_SCHED_HRTICK=3Dy
CONFIG_KEXEC=3Dy
CONFIG_PHYSICAL_START=3D0x100000
CONFIG_PHYSICAL_ALIGN=3D0x100000
CONFIG_HOTPLUG_CPU=3Dy
CONFIG_COMPAT_VDSO=3Dy
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management options
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_VIDEO=3Dy
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_ASUS=3Dy
CONFIG_ACPI_TOSHIBA=3Dy
CONFIG_ACPI_CUSTOM_DSDT_INITRD=3Dy
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=3Dy
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=3Dy
CONFIG_X86_POWERNOW_K8=3Dy
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=3Dy
CONFIG_X86_P4_CLOCKMOD=3Dy
CONFIG_X86_LONGRUN=3Dy

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=3Dy
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=3Dy
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=3Dy
CONFIG_HT_IRQ=3Dy
CONFIG_ISA_DMA_API=3Dy
# CONFIG_ISA is not set
CONFIG_MCA=3Dy
# CONFIG_MCA_LEGACY is not set
CONFIG_SCx200=3Dy
CONFIG_SCx200HR_TIMER=3Dy
CONFIG_PCCARD=3Dy
# CONFIG_PCMCIA_DEBUG is not set
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=3Dy
CONFIG_HOTPLUG_PCI_FAKE=3Dy
CONFIG_HOTPLUG_PCI_ACPI=3Dy
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dy
CONFIG_HOTPLUG_PCI_CPCI=3Dy
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=3Dy
CONFIG_HOTPLUG_PCI_SHPC=3Dy

#
# Executable file formats / Emulations
#
# CONFIG_BINFMT_ELF is not set
CONFIG_BINFMT_AOUT=3Dy
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_PACKET_MMAP=3Dy
# CONFIG_UNIX is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=3Dy
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=3Dy
CONFIG_DECNET=3Dy
CONFIG_LLC=3Dy
# CONFIG_LLC2 is not set
CONFIG_IPX=3Dy
CONFIG_IPX_INTERN=3Dy
CONFIG_ATALK=3Dy
CONFIG_DEV_APPLETALK=3Dy
CONFIG_IPDDP=3Dy
CONFIG_IPDDP_ENCAP=3Dy
CONFIG_IPDDP_DECAP=3Dy
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=3Dy

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=3Dy

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=3Dy
CONFIG_CAN_RAW=3Dy
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dy
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set

#
# Wireless
#
CONFIG_CFG80211=3Dy
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=3Dy
CONFIG_MAC80211=3Dy

#
# Rate control algorithm selection
#
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_SIMPLE=3Dy
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT=3D"simple"
CONFIG_MAC80211_RC_PID=3Dy
CONFIG_MAC80211_RC_SIMPLE=3Dy
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=3Dy
# CONFIG_IEEE80211_DEBUG is not set
# CONFIG_IEEE80211_CRYPT_WEP is not set
# CONFIG_IEEE80211_CRYPT_CCMP is not set
CONFIG_IEEE80211_CRYPT_TKIP=3Dy
CONFIG_RFKILL=3Dy
CONFIG_RFKILL_INPUT=3Dy

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
CONFIG_STANDALONE=3Dy
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=3Dy
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dy
CONFIG_PROC_EVENTS=3Dy
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dy
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dy
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=3Dy
CONFIG_CISS_SCSI_TAPE=3Dy
CONFIG_BLK_DEV_DAC960=3Dy
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=3Dy
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy
CONFIG_BLK_DEV_IDE=3Dy

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
CONFIG_BLK_DEV_IDE_SATA=3Dy
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=3Dy
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=3Dy
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEFLOPPY=3Dy
CONFIG_BLK_DEV_IDESCSI=3Dy
CONFIG_BLK_DEV_IDEACPI=3Dy
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dy
CONFIG_BLK_DEV_PLATFORM=3Dy
CONFIG_BLK_DEV_CMD640=3Dy
CONFIG_BLK_DEV_CMD640_ENHANCED=3Dy
CONFIG_BLK_DEV_IDEPNP=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=3Dy
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
CONFIG_BLK_DEV_AEC62XX=3Dy
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=3Dy
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=3Dy
# CONFIG_BLK_DEV_HPT34X is not set
CONFIG_BLK_DEV_HPT366=3Dy
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=3Dy
CONFIG_BLK_DEV_PIIX=3Dy
CONFIG_BLK_DEV_IT8213=3Dy
CONFIG_BLK_DEV_IT821X=3Dy
CONFIG_BLK_DEV_NS87415=3Dy
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=3Dy
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=3Dy
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=3Dy
CONFIG_BLK_DEV_TC86C001=3Dy
CONFIG_BLK_DEV_IDEDMA=3Dy
CONFIG_IDE_ARCH_OBSOLETE_INIT=3Dy
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=3Dy
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=3Dy
CONFIG_CHR_DEV_SCH=3Dy

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
CONFIG_SCSI_SCAN_ASYNC=3Dy

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=3Dy
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=3Dy
CONFIG_SCSI_SRP_TGT_ATTRS=3Dy
CONFIG_SCSI_LOWLEVEL=3Dy
CONFIG_BLK_DEV_3W_XXXX_RAID=3Dy
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_ACARD=3Dy
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=3Dy
CONFIG_MEGARAID_NEWGEN=3Dy
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=3Dy
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IBMMCA is not set
CONFIG_SCSI_IPS=3Dy
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR_D700=3Dy
CONFIG_SCSI_STEX=3Dy
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=3Dy
CONFIG_SCSI_IPR_TRACE=3Dy
CONFIG_SCSI_IPR_DUMP=3Dy
# CONFIG_SCSI_NCR_Q720 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=3Dy
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_NSP32=3Dy
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=3Dy
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=3Dy
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=3Dy
CONFIG_SATA_NV=3Dy
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=3Dy
CONFIG_SATA_PROMISE=3Dy
CONFIG_SATA_SIL=3Dy
# CONFIG_SATA_SIL24 is not set
CONFIG_SATA_SIS=3Dy
CONFIG_SATA_ULI=3Dy
CONFIG_SATA_VIA=3Dy
# CONFIG_SATA_VITESSE is not set
CONFIG_PATA_ACPI=3Dy
CONFIG_PATA_AMD=3Dy
CONFIG_PATA_ARTOP=3Dy
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD64X=3Dy
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_EFAR=3Dy
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=3Dy
CONFIG_PATA_TRIFLEX=3Dy
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=3Dy
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SERVERWORKS=3Dy
CONFIG_PATA_PDC2027X=3Dy
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=3Dy
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=3Dy
# CONFIG_MD is not set
CONFIG_FUSION=3Dy
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=3D128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# An alternative FireWire stack is available with EXPERIMENTAL=3Dy
#
CONFIG_IEEE1394=3Dy

#
# Subsystem Options
#
CONFIG_IEEE1394_VERBOSEDEBUG=3Dy

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=3Dy

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=3Dy
CONFIG_IEEE1394_SBP2=3Dy
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=3Dy
CONFIG_MAC_EMUMOUSEBTN=3Dy
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dy
CONFIG_INPUT_POLLDEV=3Dy

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=3Dy
CONFIG_INPUT_EVBUG=3Dy

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
CONFIG_KEYBOARD_SUNKBD=3Dy
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=3Dy
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_GPIO=3Dy
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dy
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_INPUT_JOYSTICK=3Dy
CONFIG_JOYSTICK_ANALOG=3Dy
CONFIG_JOYSTICK_A3D=3Dy
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=3Dy
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=3Dy
CONFIG_JOYSTICK_GUILLEMOT=3Dy
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=3Dy
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=3Dy
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=3Dy
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=3Dy
CONFIG_JOYSTICK_JOYDUMP=3Dy
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_FUJITSU=3Dy
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_MK712=3Dy
CONFIG_TOUCHSCREEN_PENMOUNT=3Dy
CONFIG_TOUCHSCREEN_TOUCHRIGHT=3Dy
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_UCB1400=3Dy
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dy
CONFIG_INPUT_APANEL=3Dy
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=3Dy
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dy
CONFIG_GAMEPORT=3Dy
CONFIG_GAMEPORT_NS558=3Dy
CONFIG_GAMEPORT_L4=3Dy
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_JSM=3Dy
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
CONFIG_PRINTER=3Dy
CONFIG_LP_CONSOLE=3Dy
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dy
CONFIG_HW_RANDOM_GEODE=3Dy
CONFIG_HW_RANDOM_VIA=3Dy
# CONFIG_NVRAM is not set
CONFIG_RTC=3Dy
CONFIG_R3964=3Dy
CONFIG_APPLICOM=3Dy
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=3Dy
CONFIG_NSC_GPIO=3Dy
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=3Dy
CONFIG_MAX_RAW_DEVS=3D256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dy

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dy
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=3Dy

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=3Dy
CONFIG_I2C_ALI15X3=3Dy
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=3Dy
CONFIG_I2C_GPIO=3Dy
CONFIG_I2C_I801=3Dy
# CONFIG_I2C_I810 is not set
CONFIG_I2C_PIIX4=3Dy
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_PARPORT=3Dy
CONFIG_I2C_PARPORT_LIGHT=3Dy
CONFIG_I2C_PROSAVAGE=3Dy
CONFIG_I2C_SAVAGE4=3Dy
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=3Dy
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=3Dy
CONFIG_I2C_VIAPRO=3Dy
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_PCF8575 is not set
# CONFIG_TPS65010 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=3Dy
CONFIG_W1_CON=3Dy

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=3Dy
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2433=3Dy
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=3Dy
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=3Dy
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=3Dy
CONFIG_SSB=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_DEBUG is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DAB=3Dy

#
# Graphics support
#
CONFIG_AGP=3Dy
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=3Dy
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=3Dy
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=3Dy
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dy
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
CONFIG_BACKLIGHT_CORGI=3Dy
CONFIG_BACKLIGHT_PROGEAR=3Dy

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=3Dy

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=3D64
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=3Dy

#
# Sound
#
CONFIG_SOUND=3Dy

#
# Advanced Linux Sound Architecture
#
# CONFIG_SND is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dy
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
CONFIG_MMC=3Dy
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set

#
# MMC/SD Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MEMSTICK=3Dy
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=3Dy
CONFIG_MSPRO_BLOCK=3Dy

#
# MemoryStick Host Controller Drivers
#
# CONFIG_NEW_LEDS is not set
CONFIG_LEDS_CLASS=3Dy
CONFIG_LEDS_GPIO=3Dy
# CONFIG_INFINIBAND is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=3Dy

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=3Dy
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_REISERFS_FS=3Dy
CONFIG_REISERFS_CHECK=3Dy
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=3Dy
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=3Dy
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=3Dy
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=3Dy
CONFIG_AUTOFS4_FS=3Dy
CONFIG_FUSE_FS=3Dy

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
CONFIG_HFSPLUS_FS=3Dy
CONFIG_CRAMFS=3Dy
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=3Dy
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=3Dy
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NCP_FS=3Dy
CONFIG_NCPFS_PACKET_SIGNING=3Dy
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=3Dy
CONFIG_NCPFS_OS2_NS=3Dy
CONFIG_NCPFS_SMALLDOS=3Dy
CONFIG_NCPFS_NLS=3Dy
CONFIG_NCPFS_EXTRAS=3Dy

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
CONFIG_ACORN_PARTITION=3Dy
CONFIG_ACORN_PARTITION_CUMANA=3Dy
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=3Dy
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=3Dy
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=3Dy
CONFIG_ATARI_PARTITION=3Dy
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
CONFIG_MINIX_SUBPARTITION=3Dy
CONFIG_SOLARIS_X86_PARTITION=3Dy
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=3Dy
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=3Dy
CONFIG_NLS_CODEPAGE_855=3Dy
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=3Dy
CONFIG_NLS_CODEPAGE_861=3Dy
CONFIG_NLS_CODEPAGE_862=3Dy
CONFIG_NLS_CODEPAGE_863=3Dy
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=3Dy
CONFIG_NLS_CODEPAGE_866=3Dy
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=3Dy
CONFIG_NLS_CODEPAGE_932=3Dy
CONFIG_NLS_CODEPAGE_949=3Dy
CONFIG_NLS_CODEPAGE_874=3Dy
CONFIG_NLS_ISO8859_8=3Dy
CONFIG_NLS_CODEPAGE_1250=3Dy
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=3Dy
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=3Dy
CONFIG_NLS_ISO8859_6=3Dy
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=3Dy
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=3Dy
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=3Dy
CONFIG_SCHEDSTATS=3Dy
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_STACKTRACE=3Dy
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_FRAME_POINTER=3Dy
CONFIG_LATENCYTOP=3Dy
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_SAMPLES=3Dy
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_EARLY_PRINTK=3Dy
CONFIG_X86_FIND_SMP_CONFIG=3Dy
CONFIG_X86_MPPARSE=3Dy
CONFIG_DOUBLEFAULT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_SEQIV=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_NULL=3Dy
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dy
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_ECB=3Dy
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_CTR=3Dy
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_CCM=3Dy
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dy
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_TWOFISH=3Dy
CONFIG_CRYPTO_TWOFISH_COMMON=3Dy
CONFIG_CRYPTO_TWOFISH_586=3Dy
CONFIG_CRYPTO_SERPENT=3Dy
CONFIG_CRYPTO_AES=3Dy
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=3Dy
CONFIG_CRYPTO_TEA=3Dy
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_MICHAEL_MIC=3Dy
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_AUTHENC=3Dy
CONFIG_CRYPTO_LZO=3Dy
# CONFIG_CRYPTO_HW is not set
CONFIG_VIRTUALIZATION=3Dy
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dy
CONFIG_AUDIT_GENERIC=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy


=2D------------------------------------------------------

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--Boundary-01=_6xVsHADERpAmpt0
Content-Type: text/plain;
  name="build #349 issue for v2.6.25-rc1 in linux/"
Content-Transfer-Encoding: quoted-printable

Hello,

the build with the attached .config failed, make ends with:
=2E..
WARNING: vmlinux.o(.data+0x19b20): Section mismatch in reference from the v=
ariable topology_cpu_callback_nb.11595 to the function .cpuinit.text:topolo=
gy_cpu_callback()
The variable topology_cpu_callback_nb.11595 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x25774): Section mismatch in reference from the v=
ariable pccard_sysfs_interface to the function .devinit.text:pccard_sysfs_a=
dd_socket()
The variable pccard_sysfs_interface references
the function __devinit pccard_sysfs_add_socket()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

WARNING: vmlinux.o(.data+0x25778): Section mismatch in reference from the v=
ariable pccard_sysfs_interface to the function .devexit.text:pccard_sysfs_r=
emove_socket()
The variable pccard_sysfs_interface references
the function __devexit pccard_sysfs_remove_socket()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `apanel_detach_client':
apanel.c:(.text+0x14302c): undefined reference to `__led_classdev_unregiste=
r'
drivers/built-in.o: In function `apanel_probe':
apanel.c:(.text+0x143282): undefined reference to `led_classdev_register'
make: *** [.tmp_vmlinux1] Error 1

The build was made with :
$> make mrproper && make rndconfig && <tweak config file> && make oldconfig=
 && make

Here's the config:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc1
# Mon Feb 11 17:19:52 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=3Dy
# CONFIG_X86_64 is not set
CONFIG_X86=3Dy
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_FAST_CMPXCHG_LOCAL=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_QUICKLIST=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_GENERIC_GPIO=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_DMI=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_X86_SMP=3Dy
CONFIG_X86_32_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
CONFIG_KTIME_SCALAR=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D""
CONFIG_LOCALVERSION_AUTO=3Dy
CONFIG_SWAP=3Dy
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=3Dy
# CONFIG_AUDITSYSCALL is not set
CONFIG_IKCONFIG=3Dy
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=3D14
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=3Dy
CONFIG_FAIR_USER_SCHED=3Dy
# CONFIG_FAIR_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=3Dy
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_SYSCTL=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_MARKERS=3Dy
CONFIG_HAVE_OPROFILE=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_LBD=3Dy
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=3Dy
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"deadline"
CONFIG_CLASSIC_RCU=3Dy
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
CONFIG_X86_RDC321X=3Dy
# CONFIG_X86_VSMP is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=3Dy
# CONFIG_XEN is not set
CONFIG_VMI=3Dy
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=3Dy
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
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
CONFIG_MVIAC3_2=3Dy
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D5
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_ALIGNMENT_16=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D4
CONFIG_X86_DEBUGCTLMSR=3Dy
# CONFIG_HPET_TIMER is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=3D8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_RCU_TRACE=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_MCE=3Dy
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=3Dy
CONFIG_TOSHIBA=3Dy
CONFIG_I8K=3Dy
CONFIG_X86_REBOOTFIXUPS=3Dy
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=3Dy
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=3D0xC0000000
CONFIG_HIGHMEM=3Dy
CONFIG_FLATMEM=3Dy
CONFIG_FLAT_NODE_MEM_MAP=3Dy
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=3D4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_NR_QUICK=3D1
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
CONFIG_EFI=3Dy
CONFIG_IRQBALANCE=3Dy
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=3Dy
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D300
CONFIG_SCHED_HRTICK=3Dy
CONFIG_KEXEC=3Dy
CONFIG_PHYSICAL_START=3D0x100000
CONFIG_PHYSICAL_ALIGN=3D0x100000
CONFIG_HOTPLUG_CPU=3Dy
CONFIG_COMPAT_VDSO=3Dy
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management options
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_VIDEO=3Dy
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_ASUS=3Dy
CONFIG_ACPI_TOSHIBA=3Dy
CONFIG_ACPI_CUSTOM_DSDT_INITRD=3Dy
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=3Dy
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=3Dy
CONFIG_X86_POWERNOW_K8=3Dy
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=3Dy
CONFIG_X86_P4_CLOCKMOD=3Dy
CONFIG_X86_LONGRUN=3Dy

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=3Dy
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=3Dy
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=3Dy
CONFIG_HT_IRQ=3Dy
CONFIG_ISA_DMA_API=3Dy
# CONFIG_ISA is not set
CONFIG_MCA=3Dy
# CONFIG_MCA_LEGACY is not set
CONFIG_SCx200=3Dy
CONFIG_SCx200HR_TIMER=3Dy
CONFIG_PCCARD=3Dy
# CONFIG_PCMCIA_DEBUG is not set
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=3Dy
CONFIG_HOTPLUG_PCI_FAKE=3Dy
CONFIG_HOTPLUG_PCI_ACPI=3Dy
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dy
CONFIG_HOTPLUG_PCI_CPCI=3Dy
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=3Dy
CONFIG_HOTPLUG_PCI_SHPC=3Dy

#
# Executable file formats / Emulations
#
# CONFIG_BINFMT_ELF is not set
CONFIG_BINFMT_AOUT=3Dy
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_PACKET_MMAP=3Dy
# CONFIG_UNIX is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=3Dy
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=3Dy
CONFIG_DECNET=3Dy
CONFIG_LLC=3Dy
# CONFIG_LLC2 is not set
CONFIG_IPX=3Dy
CONFIG_IPX_INTERN=3Dy
CONFIG_ATALK=3Dy
CONFIG_DEV_APPLETALK=3Dy
CONFIG_IPDDP=3Dy
CONFIG_IPDDP_ENCAP=3Dy
CONFIG_IPDDP_DECAP=3Dy
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=3Dy

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=3Dy

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=3Dy
CONFIG_CAN_RAW=3Dy
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dy
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set

#
# Wireless
#
CONFIG_CFG80211=3Dy
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=3Dy
CONFIG_MAC80211=3Dy

#
# Rate control algorithm selection
#
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_SIMPLE=3Dy
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT=3D"simple"
CONFIG_MAC80211_RC_PID=3Dy
CONFIG_MAC80211_RC_SIMPLE=3Dy
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=3Dy
# CONFIG_IEEE80211_DEBUG is not set
# CONFIG_IEEE80211_CRYPT_WEP is not set
# CONFIG_IEEE80211_CRYPT_CCMP is not set
CONFIG_IEEE80211_CRYPT_TKIP=3Dy
CONFIG_RFKILL=3Dy
CONFIG_RFKILL_INPUT=3Dy

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
CONFIG_STANDALONE=3Dy
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=3Dy
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dy
CONFIG_PROC_EVENTS=3Dy
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dy
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dy
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=3Dy
CONFIG_CISS_SCSI_TAPE=3Dy
CONFIG_BLK_DEV_DAC960=3Dy
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=3Dy
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy
CONFIG_BLK_DEV_IDE=3Dy

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
CONFIG_BLK_DEV_IDE_SATA=3Dy
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=3Dy
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=3Dy
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEFLOPPY=3Dy
CONFIG_BLK_DEV_IDESCSI=3Dy
CONFIG_BLK_DEV_IDEACPI=3Dy
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dy
CONFIG_BLK_DEV_PLATFORM=3Dy
CONFIG_BLK_DEV_CMD640=3Dy
CONFIG_BLK_DEV_CMD640_ENHANCED=3Dy
CONFIG_BLK_DEV_IDEPNP=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=3Dy
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
CONFIG_BLK_DEV_AEC62XX=3Dy
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=3Dy
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=3Dy
# CONFIG_BLK_DEV_HPT34X is not set
CONFIG_BLK_DEV_HPT366=3Dy
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=3Dy
CONFIG_BLK_DEV_PIIX=3Dy
CONFIG_BLK_DEV_IT8213=3Dy
CONFIG_BLK_DEV_IT821X=3Dy
CONFIG_BLK_DEV_NS87415=3Dy
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=3Dy
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=3Dy
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=3Dy
CONFIG_BLK_DEV_TC86C001=3Dy
CONFIG_BLK_DEV_IDEDMA=3Dy
CONFIG_IDE_ARCH_OBSOLETE_INIT=3Dy
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=3Dy
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=3Dy
CONFIG_CHR_DEV_SCH=3Dy

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
CONFIG_SCSI_SCAN_ASYNC=3Dy

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=3Dy
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=3Dy
CONFIG_SCSI_SRP_TGT_ATTRS=3Dy
CONFIG_SCSI_LOWLEVEL=3Dy
CONFIG_BLK_DEV_3W_XXXX_RAID=3Dy
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_ACARD=3Dy
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=3Dy
CONFIG_MEGARAID_NEWGEN=3Dy
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=3Dy
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IBMMCA is not set
CONFIG_SCSI_IPS=3Dy
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR_D700=3Dy
CONFIG_SCSI_STEX=3Dy
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=3Dy
CONFIG_SCSI_IPR_TRACE=3Dy
CONFIG_SCSI_IPR_DUMP=3Dy
# CONFIG_SCSI_NCR_Q720 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=3Dy
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_NSP32=3Dy
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=3Dy
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=3Dy
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=3Dy
CONFIG_SATA_NV=3Dy
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=3Dy
CONFIG_SATA_PROMISE=3Dy
CONFIG_SATA_SIL=3Dy
# CONFIG_SATA_SIL24 is not set
CONFIG_SATA_SIS=3Dy
CONFIG_SATA_ULI=3Dy
CONFIG_SATA_VIA=3Dy
# CONFIG_SATA_VITESSE is not set
CONFIG_PATA_ACPI=3Dy
CONFIG_PATA_AMD=3Dy
CONFIG_PATA_ARTOP=3Dy
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD64X=3Dy
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_EFAR=3Dy
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=3Dy
CONFIG_PATA_TRIFLEX=3Dy
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=3Dy
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SERVERWORKS=3Dy
CONFIG_PATA_PDC2027X=3Dy
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=3Dy
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=3Dy
# CONFIG_MD is not set
CONFIG_FUSION=3Dy
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=3D128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# An alternative FireWire stack is available with EXPERIMENTAL=3Dy
#
CONFIG_IEEE1394=3Dy

#
# Subsystem Options
#
CONFIG_IEEE1394_VERBOSEDEBUG=3Dy

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=3Dy

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=3Dy
CONFIG_IEEE1394_SBP2=3Dy
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=3Dy
CONFIG_MAC_EMUMOUSEBTN=3Dy
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dy
CONFIG_INPUT_POLLDEV=3Dy

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=3Dy
CONFIG_INPUT_EVBUG=3Dy

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
CONFIG_KEYBOARD_SUNKBD=3Dy
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=3Dy
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_GPIO=3Dy
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dy
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_INPUT_JOYSTICK=3Dy
CONFIG_JOYSTICK_ANALOG=3Dy
CONFIG_JOYSTICK_A3D=3Dy
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=3Dy
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=3Dy
CONFIG_JOYSTICK_GUILLEMOT=3Dy
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=3Dy
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=3Dy
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=3Dy
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=3Dy
CONFIG_JOYSTICK_JOYDUMP=3Dy
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_FUJITSU=3Dy
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_MK712=3Dy
CONFIG_TOUCHSCREEN_PENMOUNT=3Dy
CONFIG_TOUCHSCREEN_TOUCHRIGHT=3Dy
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_UCB1400=3Dy
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dy
CONFIG_INPUT_APANEL=3Dy
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=3Dy
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dy
CONFIG_GAMEPORT=3Dy
CONFIG_GAMEPORT_NS558=3Dy
CONFIG_GAMEPORT_L4=3Dy
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_JSM=3Dy
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
CONFIG_PRINTER=3Dy
CONFIG_LP_CONSOLE=3Dy
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dy
CONFIG_HW_RANDOM_GEODE=3Dy
CONFIG_HW_RANDOM_VIA=3Dy
# CONFIG_NVRAM is not set
CONFIG_RTC=3Dy
CONFIG_R3964=3Dy
CONFIG_APPLICOM=3Dy
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=3Dy
CONFIG_NSC_GPIO=3Dy
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=3Dy
CONFIG_MAX_RAW_DEVS=3D256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dy

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dy
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=3Dy

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=3Dy
CONFIG_I2C_ALI15X3=3Dy
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=3Dy
CONFIG_I2C_GPIO=3Dy
CONFIG_I2C_I801=3Dy
# CONFIG_I2C_I810 is not set
CONFIG_I2C_PIIX4=3Dy
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_PARPORT=3Dy
CONFIG_I2C_PARPORT_LIGHT=3Dy
CONFIG_I2C_PROSAVAGE=3Dy
CONFIG_I2C_SAVAGE4=3Dy
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=3Dy
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=3Dy
CONFIG_I2C_VIAPRO=3Dy
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_PCF8575 is not set
# CONFIG_TPS65010 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=3Dy
CONFIG_W1_CON=3Dy

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=3Dy
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2433=3Dy
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=3Dy
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=3Dy
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=3Dy
CONFIG_SSB=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_DEBUG is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DAB=3Dy

#
# Graphics support
#
CONFIG_AGP=3Dy
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=3Dy
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=3Dy
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=3Dy
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dy
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
CONFIG_BACKLIGHT_CORGI=3Dy
CONFIG_BACKLIGHT_PROGEAR=3Dy

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=3Dy

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=3D64
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=3Dy

#
# Sound
#
CONFIG_SOUND=3Dy

#
# Advanced Linux Sound Architecture
#
# CONFIG_SND is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dy
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
CONFIG_MMC=3Dy
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set

#
# MMC/SD Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MEMSTICK=3Dy
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=3Dy
CONFIG_MSPRO_BLOCK=3Dy

#
# MemoryStick Host Controller Drivers
#
# CONFIG_NEW_LEDS is not set
CONFIG_LEDS_CLASS=3Dy
CONFIG_LEDS_GPIO=3Dy
# CONFIG_INFINIBAND is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=3Dy

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=3Dy
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_REISERFS_FS=3Dy
CONFIG_REISERFS_CHECK=3Dy
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=3Dy
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=3Dy
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=3Dy
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=3Dy
CONFIG_AUTOFS4_FS=3Dy
CONFIG_FUSE_FS=3Dy

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
CONFIG_HFSPLUS_FS=3Dy
CONFIG_CRAMFS=3Dy
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=3Dy
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=3Dy
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NCP_FS=3Dy
CONFIG_NCPFS_PACKET_SIGNING=3Dy
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=3Dy
CONFIG_NCPFS_OS2_NS=3Dy
CONFIG_NCPFS_SMALLDOS=3Dy
CONFIG_NCPFS_NLS=3Dy
CONFIG_NCPFS_EXTRAS=3Dy

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
CONFIG_ACORN_PARTITION=3Dy
CONFIG_ACORN_PARTITION_CUMANA=3Dy
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=3Dy
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=3Dy
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=3Dy
CONFIG_ATARI_PARTITION=3Dy
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
CONFIG_MINIX_SUBPARTITION=3Dy
CONFIG_SOLARIS_X86_PARTITION=3Dy
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=3Dy
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=3Dy
CONFIG_NLS_CODEPAGE_855=3Dy
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=3Dy
CONFIG_NLS_CODEPAGE_861=3Dy
CONFIG_NLS_CODEPAGE_862=3Dy
CONFIG_NLS_CODEPAGE_863=3Dy
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=3Dy
CONFIG_NLS_CODEPAGE_866=3Dy
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=3Dy
CONFIG_NLS_CODEPAGE_932=3Dy
CONFIG_NLS_CODEPAGE_949=3Dy
CONFIG_NLS_CODEPAGE_874=3Dy
CONFIG_NLS_ISO8859_8=3Dy
CONFIG_NLS_CODEPAGE_1250=3Dy
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=3Dy
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=3Dy
CONFIG_NLS_ISO8859_6=3Dy
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=3Dy
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=3Dy
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=3Dy
CONFIG_SCHEDSTATS=3Dy
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_STACKTRACE=3Dy
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_FRAME_POINTER=3Dy
CONFIG_LATENCYTOP=3Dy
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_SAMPLES=3Dy
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_EARLY_PRINTK=3Dy
CONFIG_X86_FIND_SMP_CONFIG=3Dy
CONFIG_X86_MPPARSE=3Dy
CONFIG_DOUBLEFAULT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_SEQIV=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_NULL=3Dy
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dy
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_ECB=3Dy
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_CTR=3Dy
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_CCM=3Dy
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dy
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_TWOFISH=3Dy
CONFIG_CRYPTO_TWOFISH_COMMON=3Dy
CONFIG_CRYPTO_TWOFISH_586=3Dy
CONFIG_CRYPTO_SERPENT=3Dy
CONFIG_CRYPTO_AES=3Dy
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=3Dy
CONFIG_CRYPTO_TEA=3Dy
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_MICHAEL_MIC=3Dy
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_AUTHENC=3Dy
CONFIG_CRYPTO_LZO=3Dy
# CONFIG_CRYPTO_HW is not set
CONFIG_VIRTUALIZATION=3Dy
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dy
CONFIG_AUDIT_GENERIC=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy


--Boundary-01=_6xVsHADERpAmpt0--

--nextPart2288458.Iek11LiafI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHsVx6hyrlCH22naMRAmuFAJ4ko628T+qobiHKkQ+AP20SWk+DMACfaT0H
Z594mgU2qQYe1erwesd8wyE=
=W/dn
-----END PGP SIGNATURE-----

--nextPart2288458.Iek11LiafI--
