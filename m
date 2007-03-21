Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXCUSuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXCUSuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbXCUSuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:50:05 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61997 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933622AbXCUSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:50:01 -0400
Message-ID: <46017E56.7050400@lwfinger.net>
Date: Wed, 21 Mar 2007 13:49:58 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc4-mm1 - problem with cpuidle routine
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
In-Reply-To: <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I configure 'CPU Idle PM Support' on my HP dv2125nr notebook with a Turion X64 X2 processor and
X86_64 architecture selected, the computer freezes on bootup. I have included a portion the
configuration file and part of /var/log/boot.msg for my working system. Please let me know if
further info from my system is required. I would be happy to test any patches, etc.

Larry

==============================================================

The console log ends with the following entries:

ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
cpuidle: driver acpi_idle failed to attach to cpu 0
cpuidle: driver acpi_idle failed to attach to cpu 0
cpuidle: using driver acpi_idle
Loading thermal

At this point, the system hangs.

=================================================

The beginning section of my .config is as follows:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21-rc4-mm1
# Wed Mar 21 13:05:07 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION="-mm1"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SWAP_PREFETCH=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_UTS_NS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_CPUSETS=y
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
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set
CONFIG_PAGE_GROUP_BY_MOBILITY=y

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y

#
# Process debugging support
#
CONFIG_UTRACE=y
CONFIG_PTRACE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
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
CONFIG_ADAPTIVE_READAHEAD=y
# CONFIG_DEBUG_READAHEAD is not set
CONFIG_NR_CPUS=128
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_REORDER is not set
CONFIG_K8_NB=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_PENDING_IRQ=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_PM_STD_PARTITION=""
CONFIG_SUSPEND_SMP=y

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
CONFIG_ACPI_SLEEP_PROC_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_ACPI_CPUFREQ=m

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU idle PM support
#
CONFIG_CPU_IDLE=y

#
# Governors
#
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
...

=================================================================

A listing of /var/log/boot.msg (from my running system) to the point at which it fails when cpuidle
is loaded is as follows:

Inspecting /boot/System.map-2.6.21-rc3-L2.6-g61ae474e-dirty
Loaded 23859 symbols from /boot/System.map-2.6.21-rc3-L2.6-g61ae474e-dirty.
Symbols match kernel version 2.6.21.
No module symbols loaded - kernel modules not enabled.

klogd 1.4.1, log source = ksyslog started.
<5>Linux version 2.6.21-rc3-L2.6-g61ae474e-dirty (finger@larrylap2) (gcc version 4.1.2 20061115
(prerelease) (SUSE Linux)) #2 SMP Mon Mar 12 14:51:06 CDT 2007
<6>Command line: root=/dev/sda3 vga=0x317 resume=/dev/sda2 splash=silent
<6>BIOS-provided physical RAM map:
<4> BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
<4> BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
<4> BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
<4> BIOS-e820: 0000000000100000 - 000000005bf10000 (usable)
<4> BIOS-e820: 000000005bf10000 - 000000005bf19000 (ACPI data)
<4> BIOS-e820: 000000005bf19000 - 000000005bf80000 (ACPI NVS)
<4> BIOS-e820: 000000005bf80000 - 0000000060000000 (reserved)
<4> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
<4> BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
<4> BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<4> BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
<7>Entering add_active_range(0, 0, 157) 0 entries of 256 used
<7>Entering add_active_range(0, 256, 376592) 1 entries of 256 used
<4>end_pfn_map = 1048576
<6>DMI present.
<4>ACPI: RSDP 000F87C0, 0014 (r0 HP    )
<4>ACPI: RSDT 5BF131F0, 0038 (r1 HP     30B5      6040000  LTP        0)
<4>ACPI: FACP 5BF18D52, 0074 (r1 HP     30B5      6040000 PTL_    F4240)
<4>ACPI: DSDT 5BF13228, 5B2A (r1 HP       30B5    6040000 MSFT  100000E)
<4>ACPI: FACS 5BF19FC0, 0040
<4>ACPI: MCFG 5BF18DC6, 003C (r1 HP     30B5      6040000  LTP        0)
<4>ACPI: APIC 5BF18E02, 0054 (r1 HP     30B5      6040000  LTP        0)
<4>ACPI: BOOT 5BF18E56, 0028 (r1 HP     30B5      6040000  LTP        1)
<4>ACPI: SSDT 5BF18E7E, 0182 (r1 HP     30B5      6040000  LTP        1)
<7>Entering add_active_range(0, 0, 157) 0 entries of 256 used
<7>Entering add_active_range(0, 256, 376592) 1 entries of 256 used
<4>Zone PFN ranges:
<4>  DMA             0 ->     4096
<4>  DMA32        4096 ->  1048576
<4>  Normal    1048576 ->  1048576
<4>early_node_map[2] active PFN ranges
<4>    0:        0 ->      157
<4>    0:      256 ->   376592
<7>On node 0 totalpages: 376493
<7>  DMA zone: 88 pages used for memmap
<7>  DMA zone: 2241 pages reserved
<7>  DMA zone: 1668 pages, LIFO batch:0
<7>  DMA32 zone: 8002 pages used for memmap
<7>  DMA32 zone: 364494 pages, LIFO batch:31
<7>  Normal zone: 0 pages used for memmap
<6>ACPI: PM-Timer IO Port: 0x1008
<7>ACPI: Local APIC address 0xfee00000
<6>ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>Processor #0 (Bootup-CPU)
<6>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>Processor #1
<6>ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
<7>ACPI: IRQ9 used by override.
<6>Setting APIC routing to physical flat
<6>Using ACPI (MADT) for SMP configuration information
<4>Nosave address range: 000000000009d000 - 000000000009e000
<4>Nosave address range: 000000000009e000 - 00000000000a0000
<4>Nosave address range: 00000000000a0000 - 00000000000d2000
<4>Nosave address range: 00000000000d2000 - 0000000000100000
<6>Allocating PCI resources starting at 68000000 (gap: 60000000:80000000)
<6>SMP: Allowing 2 CPUs, 0 hotplug CPUs
<6>PERCPU: Allocating 49728 bytes of per cpu data
<4>Built 1 zonelists.  Total pages: 366162
<5>Kernel command line: root=/dev/sda3 vga=0x317 resume=/dev/sda2 splash=silent
<4>Initializing CPU#0
<4>PID hash table entries: 4096 (order: 12, 32768 bytes)
<6>time.c: Detected 1607.353 MHz processor.
<4>Console: colour dummy device 80x25
<4>Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
<4>... MAX_LOCKDEP_SUBCLASSES:    8
<4>... MAX_LOCK_DEPTH:          30
<4>... MAX_LOCKDEP_KEYS:        2048
<4>... CLASSHASH_SIZE:           1024
<4>... MAX_LOCKDEP_ENTRIES:     8192
<4>... MAX_LOCKDEP_CHAINS:      16384
<4>... CHAINHASH_SIZE:          8192
<4> memory used by lock dependency info: 1648 kB
<4> per task-struct memory footprint: 1680 bytes
<4>Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
<4>Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
<4>Checking aperture...
<4>CPU 0: aperture @ 8492000000 size 32 MB
<4>Aperture too small (32 MB)
<4>No AGP bridge found
<4>Memory: 1457524k/1506368k available (1886k kernel code, 48008k reserved, 1205k data, 220k init)
<4>Calibrating delay using timer specific routine.. 3218.55 BogoMIPS (lpj=6437119)
<4>Mount-cache hash table entries: 256
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 256K (64 bytes/line)
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 0
<4>lockdep: not fixing up alternatives.
<6>ACPI: Core revision 20070126
<6>Using local APIC timer interrupts.
<4>result 12557461
<6>Detected 12.557 MHz APIC timer.
<4>lockdep: not fixing up alternatives.
<6>Booting processor 1/2 APIC 0x1
<4>Initializing CPU#1
<4>Calibrating delay using timer specific routine.. 3214.91 BogoMIPS (lpj=6429832)
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 256K (64 bytes/line)
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 1
<4>AMD Turion(tm) 64 X2  stepping 02
<6>Brought up 2 CPUs
<6>testing NMI watchdog ... OK.
<4>migration_cost=163
<6>NET: Registered protocol family 16
<6>ACPI: bus type pci registered
<6>PCI: Using MMCONFIG at e0000000 - e02fffff
<5>PCI: No mmconfig possible on device 00:18
<5>PCI: No mmconfig possible on device 03:09
<6>ACPI: Interpreter enabled
<6>ACPI: (supports S0 S3 S4 S5)
<6>ACPI: Using IOAPIC for interrupt routing
<6>ACPI: PCI Root Bridge [PCI0] (0000:00)
<7>PCI: Probing PCI hardware (bus 00)
<7>PCI: Scanning bus 0000:00
<7>PCI: Found 0000:00:00.0 [10de/02f0] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.0
<7>PCI: Found 0000:00:00.1 [10de/02fa] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.1
<7>PCI: Found 0000:00:00.2 [10de/02fe] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.2
<7>PCI: Found 0000:00:00.3 [10de/02f8] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.3
<7>PCI: Found 0000:00:00.4 [10de/02f9] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.4
<7>PCI: Found 0000:00:00.5 [10de/02ff] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.5
<7>PCI: Found 0000:00:00.6 [10de/027f] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.6
<7>PCI: Found 0000:00:00.7 [10de/027e] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:00.7
<7>PCI: Found 0000:00:02.0 [10de/02fc] 000604 01
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:02.0
<7>PCI: Found 0000:00:03.0 [10de/02fd] 000604 01
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:03.0
<7>PCI: Found 0000:00:05.0 [10de/0244] 000300 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:05.0
<7>Boot video device is 0000:00:05.0
<7>PCI: Found 0000:00:09.0 [10de/0270] 000500 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:09.0
<7>PCI: Found 0000:00:0a.0 [10de/0260] 000601 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0a.0
<7>PCI: Found 0000:00:0a.1 [10de/0264] 000c05 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0a.1
<7>PCI: Found 0000:00:0a.3 [10de/0271] 000b40 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0a.3
<7>PCI: Found 0000:00:0b.0 [10de/026d] 000c03 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0b.0
<7>PCI: Found 0000:00:0b.1 [10de/026e] 000c03 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0b.1
<7>PCI: Found 0000:00:0d.0 [10de/0265] 000101 00
<4>0000:00:0d.0: cannot adjust BAR0 (not I/O)
<4>0000:00:0d.0: cannot adjust BAR1 (not I/O)
<4>0000:00:0d.0: cannot adjust BAR2 (not I/O)
<4>0000:00:0d.0: cannot adjust BAR3 (not I/O)
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0d.0
<7>PCI: Found 0000:00:0e.0 [10de/0266] 000101 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:0e.0
<7>PCI: Found 0000:00:10.0 [10de/026f] 000604 01
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:10.0
<7>PCI: Found 0000:00:10.1 [10de/026c] 000403 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:10.1
<7>PCI: Found 0000:00:14.0 [10de/0269] 000680 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:14.0
<7>PCI: Found 0000:00:18.0 [1022/1100] 000600 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:18.0
<7>PCI: Found 0000:00:18.1 [1022/1101] 000600 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:18.1
<7>PCI: Found 0000:00:18.2 [1022/1102] 000600 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:18.2
<7>PCI: Found 0000:00:18.3 [1022/1103] 000600 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:00:18.3
<7>PCI: Fixups for bus 0000:00
<7>PCI: Scanning behind PCI bridge 0000:00:02.0, config 010100, pass 0
<7>PCI: Scanning bus 0000:01
<7>PCI: Found 0000:01:00.0 [14e4/4311] 000280 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:01:00.0
<7>PCI: Fixups for bus 0000:01
<7>PCI: Bus scan for 0000:01 returning with max=01
<7>PCI: Scanning behind PCI bridge 0000:00:03.0, config 020200, pass 0
<7>PCI: Scanning bus 0000:02
<7>PCI: Fixups for bus 0000:02
<7>PCI: Bus scan for 0000:02 returning with max=02
<7>PCI: Scanning behind PCI bridge 0000:00:10.0, config 030300, pass 0
<7>PCI: Scanning bus 0000:03
<7>PCI: Found 0000:03:09.0 [1180/0832] 000c00 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:03:09.0
<7>PCI: Found 0000:03:09.1 [1180/0822] 000805 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:03:09.1
<7>PCI: Found 0000:03:09.2 [1180/0843] 000880 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:03:09.2
<7>PCI: Found 0000:03:09.3 [1180/0592] 000880 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:03:09.3
<7>PCI: Found 0000:03:09.4 [1180/0852] 000880 00
<7>PCI: Calling quirk ffffffff8037061c for 0000:03:09.4
<7>PCI: Fixups for bus 0000:03
<6>PCI: Transparent bridge - 0000:00:10.0
<7>PCI: Bus scan for 0000:03 returning with max=03
<7>PCI: Scanning behind PCI bridge 0000:00:02.0, config 010100, pass 1
<7>PCI: Scanning behind PCI bridge 0000:00:03.0, config 020200, pass 1
<7>PCI: Scanning behind PCI bridge 0000:00:10.0, config 030300, pass 1
<7>PCI: Bus scan for 0000:00 returning with max=03
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
<4>ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19 20 21 22 23) *10
<4>ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 *11 14 15)
<4>ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LK1E] (IRQs 20) *0, disabled.
<4>ACPI: PCI Interrupt Link [LK2E] (IRQs 19) *10
<4>ACPI: PCI Interrupt Link [LK3E] (IRQs 21) *10
<4>ACPI: PCI Interrupt Link [LK4E] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 22 23) *10
<4>ACPI: PCI Interrupt Link [LSMU] (IRQs 16 17 18 19 20 21 22 23) *11
<4>ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 18 19 20 21 22 23) *11
<4>ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 18 19 20 21 22 23) *7
<4>ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 18 19 20 21 22 23) *11
<4>ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [LACI] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [LMCI] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [LTID] (IRQs 16 17 18 19 20 21 22 23) *5
<4>ACPI: PCI Interrupt Link [LSI1] (IRQs 16 17 18 19 20 21 22 23) *0
<6>Linux Plug and Play Support v0.97 (c) Adam Belay
<6>pnp: PnP ACPI init
<7>pnp: ACPI device : hid PNP0C01
<7>pnp: ACPI device : hid PNP0A03
<7>pnp: ACPI device : hid PNP0C02
<7>pnp: ACPI device : hid PNP0C02
<7>pnp: ACPI device : hid PNP0C02
<7>pnp: ACPI device : hid PNP0200
<7>pnp: ACPI device : hid PNP0800
<7>pnp: ACPI device : hid PNP0B00
<7>pnp: ACPI device : hid PNP0C04
<7>pnp: ACPI device : hid PNP0303
<7>pnp: ACPI device : hid SYN0127
<6>pnp: PnP ACPI: found 11 devices
<6>PCI: Using ACPI for IRQ routing
<6>PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
<7>pnp: the driver 'system' has been registered
<7>pnp: match found with the PnP device '00:00' and the driver 'system'
<6>pnp: 00:00: iomem range 0xffc00000-0xffffffff has been reserved
<6>pnp: 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
<6>pnp: 00:00: iomem range 0xfee00000-0xfeefffff has been reserved
<6>pnp: 00:00: iomem range 0x0-0x0 could not be reserved
<7>pnp: match found with the PnP device '00:02' and the driver 'system'
<6>pnp: 00:02: iomem range 0xe0000000-0xefffffff has been reserved
<7>pnp: match found with the PnP device '00:03' and the driver 'system'
<6>pnp: 00:03: ioport range 0x1000-0x107f has been reserved
<6>pnp: 00:03: ioport range 0x1080-0x10ff has been reserved
<6>pnp: 00:03: ioport range 0x1400-0x147f has been reserved
<6>pnp: 00:03: ioport range 0x1480-0x14ff has been reserved
<6>pnp: 00:03: ioport range 0x1800-0x187f has been reserved
<6>pnp: 00:03: ioport range 0x1880-0x18ff has been reserved
<6>pnp: 00:03: ioport range 0x2000-0x203f has been reserved
<7>pnp: match found with the PnP device '00:04' and the driver 'system'
<6>Time: tsc clocksource has been installed.
<7>  got res [68000000:6801ffff] bus [68000000:6801ffff] flags 7202 for BAR 6 of 0000:00:05.0
<6>PCI: Bridge: 0000:00:02.0
<6>  IO window: disabled.
<6>  MEM window: c3000000-c30fffff
<6>  PREFETCH window: disabled.
<6>PCI: Bridge: 0000:00:03.0
<6>  IO window: 4000-4fff
<6>  MEM window: c8000000-c87fffff
<6>  PREFETCH window: disabled.
<6>PCI: Bridge: 0000:00:10.0
<6>  IO window: disabled.
<6>  MEM window: c3100000-c31fffff
<6>  PREFETCH window: disabled.
<7>PCI: Setting latency timer of device 0000:00:02.0 to 64
<7>PCI: Setting latency timer of device 0000:00:03.0 to 64
<7>PCI: Setting latency timer of device 0000:00:10.0 to 64
<6>NET: Registered protocol family 2
<6>Time: acpi_pm clocksource has been installed.
<4>IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
<4>TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
<4>TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
<6>TCP: Hash tables configured (established 65536 bind 65536)
<6>TCP reno registered
<6>checking if image is initramfs... it is
<6>Freeing initrd memory: 3311k freed
<6>Simple Boot Flag at 0x36 set to 0x1
<6>audit: initializing netlink socket (disabled)
<5>audit(1174482018.004:1): initialized
<6>io scheduler noop registered
<6>io scheduler anticipatory registered
<6>io scheduler deadline registered
<6>io scheduler cfq registered (default)
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.1
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.1
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.2
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.2
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.3
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.3
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.4
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.4
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.5
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.5
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.6
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.6
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:00.7
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:00.7
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:02.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:02.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:03.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:03.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:05.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:05.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:09.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:09.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0a.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0a.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0a.1
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0a.1
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0a.3
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0a.3
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0b.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0b.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0b.1
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0b.1
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0d.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0d.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:0e.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:0e.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:10.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:10.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:10.1
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:10.1
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:14.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:14.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:18.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:18.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:18.1
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:18.1
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:18.2
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:18.2
<7>PCI: Calling quirk ffffffff802f3139 for 0000:00:18.3
<7>PCI: Calling quirk ffffffff80358d25 for 0000:00:18.3
<7>PCI: Calling quirk ffffffff802f3139 for 0000:01:00.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:01:00.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:03:09.0
<7>PCI: Calling quirk ffffffff80358d25 for 0000:03:09.0
<7>PCI: Calling quirk ffffffff802f3139 for 0000:03:09.1
<7>PCI: Calling quirk ffffffff80358d25 for 0000:03:09.1
<7>PCI: Calling quirk ffffffff802f3139 for 0000:03:09.2
<7>PCI: Calling quirk ffffffff80358d25 for 0000:03:09.2
<7>PCI: Calling quirk ffffffff802f3139 for 0000:03:09.3
<7>PCI: Calling quirk ffffffff80358d25 for 0000:03:09.3
<7>PCI: Calling quirk ffffffff802f3139 for 0000:03:09.4
<7>PCI: Calling quirk ffffffff80358d25 for 0000:03:09.4
<7>PCI: Setting latency timer of device 0000:00:02.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:02.0:pcie00]
<7>Allocate Port Service[0000:00:02.0:pcie03]
<7>PCI: Setting latency timer of device 0000:00:03.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:03.0:pcie00]
<7>Allocate Port Service[0000:00:03.0:pcie03]
<6>vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000400000, using 3072k, total 65536k
<6>vesafb: mode is 1024x768x16, linelength=2048, pages=1
<6>vesafb: scrolling: redraw
<6>vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
<4>Console: switching to colour frame buffer device 128x48
<6>fb0: VESA VGA frame buffer device
<6>Real Time Clock Driver v1.12ac
<6>Non-volatile memory driver v1.2
<6>Linux agpgart interface v0.102 (c) Dave Jones
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
<7>pnp: the driver 'serial' has been registered
<4>RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
<7>pnp: the driver 'i8042 kbd' has been registered
<7>pnp: match found with the PnP device '00:09' and the driver 'i8042 kbd'
<7>pnp: the driver 'i8042 aux' has been registered
<7>pnp: match found with the PnP device '00:0a' and the driver 'i8042 aux'
<6>PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
<6>i8042.c: Detected active multiplexing controller, rev 1.1.
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>serio: i8042 AUX0 port at 0x60,0x64 irq 12
<6>serio: i8042 AUX1 port at 0x60,0x64 irq 12
<6>serio: i8042 AUX2 port at 0x60,0x64 irq 12
<6>serio: i8042 AUX3 port at 0x60,0x64 irq 12
<6>mice: PS/2 mouse device common for all mice
<6>input: PC Speaker as /class/input/input0
<6>TCP cubic registered
<6>NET: Registered protocol family 1
<6>Freeing unused kernel memory: 220k freed
<6>Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
<6>input: SynPS/2 Synaptics TouchPad as /class/input/input1
<6>input: AT Translated Set 2 keyboard as /class/input/input2
<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<5>SCSI subsystem initialized
<6>ACPI: Processor [CPU0] (supports 8 throttling states)
<6>ACPI: Processor [CPU1] (supports 8 throttling states)
<6>ACPI: Thermal Zone [TZS0] (54 C)
<6>ACPI: Thermal Zone [TZS1] (57 C)
