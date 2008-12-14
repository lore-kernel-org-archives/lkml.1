Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbYLNSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbYLNSk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYLNSkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:40:47 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:52626 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYLNSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:40:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIHADLcRElMROB9/2dsb2JhbACBbJJzuGaCfg
Date: Sun, 14 Dec 2008 13:40:41 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: kmemtrace
Message-ID: <20081214184041.GA21547@Krystal>
References: <20081205112929.GA8497@x200.localdomain> <20081214160717.GA5361@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081214160717.GA5361@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:40:11 up 27 days, 19:20,  1 user,  load average: 0.79, 1.04,
	0.92
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, Dec 05, 2008 at 02:29:29PM +0300, Alexey Dobriyan wrote:
> > 1. It doesn't link
> > 
> > 	  LD      vmlinux
> > 	kernel/built-in.o: In function `add_del_listener':
> > 	taskstats.c:(.text+0x1f869): undefined reference to `.L180'
> > 
> > It is still unclear exactly why. Common pattern is something like:
> 
> Hi,
> 
> Sorry for the delay, I've been a bit too busy.
> 
> This works for me with the config you supplied. I can only conclude
> there is a problem with GCC 3.4, as I'm using version 4.1.2. I'm cc-ing
> Mathieu, since I suspect markers code somehow behaves badly with older
> GCCs.
> 

Have you switched to tracepoints rather than markers for kmemtrace ?

Mathieu

> > 2. markers format strings. Printing pointers as %lu(!).
> 
> That's no problem, it's a de facto assumption that sizeof(unsigned long)
> == sizeof(void *) in GCC. In fact, there's a lot of kernel code that
> makes this assumption.
> 
> > #
> > # Automatically generated make config: don't edit
> > # Linux kernel version: 2.6.28-rc7
> > # Fri Dec  5 14:10:53 2008
> > #
> > CONFIG_64BIT=y
> > # CONFIG_X86_32 is not set
> > CONFIG_X86_64=y
> > CONFIG_X86=y
> > CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> > CONFIG_GENERIC_TIME=y
> > CONFIG_GENERIC_CMOS_UPDATE=y
> > CONFIG_CLOCKSOURCE_WATCHDOG=y
> > CONFIG_GENERIC_CLOCKEVENTS=y
> > CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> > CONFIG_LOCKDEP_SUPPORT=y
> > CONFIG_STACKTRACE_SUPPORT=y
> > CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> > CONFIG_FAST_CMPXCHG_LOCAL=y
> > CONFIG_MMU=y
> > CONFIG_ZONE_DMA=y
> > CONFIG_GENERIC_ISA_DMA=y
> > CONFIG_GENERIC_IOMAP=y
> > CONFIG_GENERIC_HWEIGHT=y
> > CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> > CONFIG_RWSEM_GENERIC_SPINLOCK=y
> > # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
> > CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> > CONFIG_GENERIC_CALIBRATE_DELAY=y
> > CONFIG_GENERIC_TIME_VSYSCALL=y
> > CONFIG_ARCH_HAS_CPU_RELAX=y
> > CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> > CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> > # CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
> > # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> > CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> > CONFIG_ARCH_SUSPEND_POSSIBLE=y
> > CONFIG_ZONE_DMA32=y
> > CONFIG_ARCH_POPULATES_NODE_MAP=y
> > CONFIG_AUDIT_ARCH=y
> > CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> > CONFIG_GENERIC_HARDIRQS=y
> > CONFIG_GENERIC_IRQ_PROBE=y
> > CONFIG_X86_BIOS_REBOOT=y
> > # CONFIG_KTIME_SCALAR is not set
> > CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> > 
> > #
> > # General setup
> > #
> > CONFIG_EXPERIMENTAL=y
> > CONFIG_BROKEN_ON_SMP=y
> > CONFIG_INIT_ENV_ARG_LIMIT=32
> > CONFIG_LOCALVERSION=""
> > # CONFIG_SYSVIPC is not set
> > # CONFIG_POSIX_MQUEUE is not set
> > # CONFIG_BSD_PROCESS_ACCT is not set
> > CONFIG_TASKSTATS=y
> > # CONFIG_TASK_DELAY_ACCT is not set
> > CONFIG_TASK_XACCT=y
> > # CONFIG_TASK_IO_ACCOUNTING is not set
> > # CONFIG_AUDIT is not set
> > # CONFIG_IKCONFIG is not set
> > CONFIG_LOG_BUF_SHIFT=17
> > # CONFIG_CGROUPS is not set
> > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> > # CONFIG_GROUP_SCHED is not set
> > CONFIG_RELAY=y
> > # CONFIG_NAMESPACES is not set
> > # CONFIG_BLK_DEV_INITRD is not set
> > CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> > CONFIG_EMBEDDED=y
> > # CONFIG_SYSCTL_SYSCALL is not set
> > # CONFIG_KALLSYMS is not set
> > # CONFIG_HOTPLUG is not set
> > # CONFIG_PRINTK is not set
> > # CONFIG_BUG is not set
> > # CONFIG_ELF_CORE is not set
> > # CONFIG_PCSPKR_PLATFORM is not set
> > # CONFIG_COMPAT_BRK is not set
> > CONFIG_BASE_FULL=y
> > # CONFIG_FUTEX is not set
> > # CONFIG_EPOLL is not set
> > # CONFIG_SIGNALFD is not set
> > # CONFIG_TIMERFD is not set
> > # CONFIG_EVENTFD is not set
> > CONFIG_SHMEM=y
> > # CONFIG_AIO is not set
> > # CONFIG_VM_EVENT_COUNTERS is not set
> > # CONFIG_SLAB is not set
> > CONFIG_SLUB=y
> > # CONFIG_SLOB is not set
> > # CONFIG_PROFILING is not set
> > CONFIG_TRACEPOINTS=y
> > CONFIG_MARKERS=y
> > CONFIG_HAVE_OPROFILE=y
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> > CONFIG_HAVE_IOREMAP_PROT=y
> > CONFIG_HAVE_KPROBES=y
> > CONFIG_HAVE_KRETPROBES=y
> > CONFIG_HAVE_ARCH_TRACEHOOK=y
> > # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> > # CONFIG_TINY_SHMEM is not set
> > CONFIG_BASE_SMALL=0
> > # CONFIG_MODULES is not set
> > # CONFIG_BLOCK is not set
> > CONFIG_CLASSIC_RCU=y
> > # CONFIG_FREEZER is not set
> > 
> > #
> > # Processor type and features
> > #
> > # CONFIG_NO_HZ is not set
> > # CONFIG_HIGH_RES_TIMERS is not set
> > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> > # CONFIG_SMP is not set
> > CONFIG_X86_FIND_SMP_CONFIG=y
> > CONFIG_X86_MPPARSE=y
> > CONFIG_X86_PC=y
> > # CONFIG_X86_ELAN is not set
> > # CONFIG_X86_VOYAGER is not set
> > # CONFIG_X86_GENERICARCH is not set
> > # CONFIG_X86_VSMP is not set
> > # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> > # CONFIG_PARAVIRT_GUEST is not set
> > # CONFIG_MEMTEST is not set
> > # CONFIG_M386 is not set
> > # CONFIG_M486 is not set
> > # CONFIG_M586 is not set
> > # CONFIG_M586TSC is not set
> > # CONFIG_M586MMX is not set
> > # CONFIG_M686 is not set
> > # CONFIG_MPENTIUMII is not set
> > # CONFIG_MPENTIUMIII is not set
> > # CONFIG_MPENTIUMM is not set
> > # CONFIG_MPENTIUM4 is not set
> > # CONFIG_MK6 is not set
> > # CONFIG_MK7 is not set
> > # CONFIG_MK8 is not set
> > # CONFIG_MCRUSOE is not set
> > # CONFIG_MEFFICEON is not set
> > # CONFIG_MWINCHIPC6 is not set
> > # CONFIG_MWINCHIP3D is not set
> > # CONFIG_MGEODEGX1 is not set
> > # CONFIG_MGEODE_LX is not set
> > # CONFIG_MCYRIXIII is not set
> > # CONFIG_MVIAC3_2 is not set
> > # CONFIG_MVIAC7 is not set
> > # CONFIG_MPSC is not set
> > # CONFIG_MCORE2 is not set
> > CONFIG_GENERIC_CPU=y
> > CONFIG_X86_CPU=y
> > CONFIG_X86_L1_CACHE_BYTES=128
> > CONFIG_X86_INTERNODE_CACHE_BYTES=128
> > CONFIG_X86_CMPXCHG=y
> > CONFIG_X86_L1_CACHE_SHIFT=7
> > CONFIG_X86_WP_WORKS_OK=y
> > CONFIG_X86_TSC=y
> > CONFIG_X86_CMPXCHG64=y
> > CONFIG_X86_CMOV=y
> > CONFIG_X86_MINIMUM_CPU_FAMILY=64
> > CONFIG_X86_DEBUGCTLMSR=y
> > # CONFIG_PROCESSOR_SELECT is not set
> > CONFIG_CPU_SUP_INTEL=y
> > CONFIG_CPU_SUP_AMD=y
> > CONFIG_CPU_SUP_CENTAUR_64=y
> > # CONFIG_X86_DS is not set
> > # CONFIG_X86_PTRACE_BTS is not set
> > CONFIG_HPET_TIMER=y
> > # CONFIG_DMI is not set
> > CONFIG_SWIOTLB=y
> > CONFIG_IOMMU_HELPER=y
> > CONFIG_PREEMPT_NONE=y
> > # CONFIG_PREEMPT_VOLUNTARY is not set
> > # CONFIG_PREEMPT is not set
> > CONFIG_X86_LOCAL_APIC=y
> > CONFIG_X86_IO_APIC=y
> > # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> > # CONFIG_X86_MCE is not set
> > # CONFIG_I8K is not set
> > # CONFIG_MICROCODE is not set
> > # CONFIG_X86_MSR is not set
> > # CONFIG_X86_CPUID is not set
> > CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> > # CONFIG_DIRECT_GBPAGES is not set
> > CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> > CONFIG_ARCH_SPARSEMEM_ENABLE=y
> > CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> > CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> > CONFIG_SELECT_MEMORY_MODEL=y
> > # CONFIG_FLATMEM_MANUAL is not set
> > # CONFIG_DISCONTIGMEM_MANUAL is not set
> > CONFIG_SPARSEMEM_MANUAL=y
> > CONFIG_SPARSEMEM=y
> > CONFIG_HAVE_MEMORY_PRESENT=y
> > CONFIG_SPARSEMEM_EXTREME=y
> > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> > # CONFIG_SPARSEMEM_VMEMMAP is not set
> > CONFIG_PAGEFLAGS_EXTENDED=y
> > CONFIG_SPLIT_PTLOCK_CPUS=4
> > CONFIG_RESOURCES_64BIT=y
> > CONFIG_PHYS_ADDR_T_64BIT=y
> > CONFIG_ZONE_DMA_FLAG=1
> > CONFIG_VIRT_TO_BUS=y
> > # CONFIG_UNEVICTABLE_LRU is not set
> > # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> > # CONFIG_X86_RESERVE_LOW_64K is not set
> > # CONFIG_MTRR is not set
> > # CONFIG_SECCOMP is not set
> > # CONFIG_CC_STACKPROTECTOR is not set
> > # CONFIG_HZ_100 is not set
> > CONFIG_HZ_250=y
> > # CONFIG_HZ_300 is not set
> > # CONFIG_HZ_1000 is not set
> > CONFIG_HZ=250
> > # CONFIG_SCHED_HRTICK is not set
> > # CONFIG_KEXEC is not set
> > # CONFIG_CRASH_DUMP is not set
> > CONFIG_PHYSICAL_START=0x200000
> > # CONFIG_RELOCATABLE is not set
> > CONFIG_PHYSICAL_ALIGN=0x200000
> > # CONFIG_CMDLINE_BOOL is not set
> > CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> > 
> > #
> > # Power management and ACPI options
> > #
> > # CONFIG_PM is not set
> > 
> > #
> > # CPU Frequency scaling
> > #
> > # CONFIG_CPU_FREQ is not set
> > # CONFIG_CPU_IDLE is not set
> > 
> > #
> > # Memory power savings
> > #
> > # CONFIG_I7300_IDLE is not set
> > 
> > #
> > # Bus options (PCI etc.)
> > #
> > # CONFIG_PCI is not set
> > # CONFIG_ARCH_SUPPORTS_MSI is not set
> > CONFIG_ISA_DMA_API=y
> > 
> > #
> > # Executable file formats / Emulations
> > #
> > # CONFIG_BINFMT_ELF is not set
> > # CONFIG_HAVE_AOUT is not set
> > # CONFIG_BINFMT_MISC is not set
> > # CONFIG_IA32_EMULATION is not set
> > # CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
> > CONFIG_NET=y
> > 
> > #
> > # Networking options
> > #
> > CONFIG_COMPAT_NET_DEV_OPS=y
> > # CONFIG_PACKET is not set
> > # CONFIG_UNIX is not set
> > # CONFIG_NET_KEY is not set
> > CONFIG_INET=y
> > # CONFIG_IP_MULTICAST is not set
> > # CONFIG_IP_ADVANCED_ROUTER is not set
> > CONFIG_IP_FIB_HASH=y
> > # CONFIG_IP_PNP is not set
> > # CONFIG_NET_IPIP is not set
> > # CONFIG_NET_IPGRE is not set
> > # CONFIG_ARPD is not set
> > # CONFIG_SYN_COOKIES is not set
> > # CONFIG_INET_AH is not set
> > # CONFIG_INET_ESP is not set
> > # CONFIG_INET_IPCOMP is not set
> > # CONFIG_INET_XFRM_TUNNEL is not set
> > # CONFIG_INET_TUNNEL is not set
> > # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> > # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> > # CONFIG_INET_XFRM_MODE_BEET is not set
> > # CONFIG_INET_LRO is not set
> > # CONFIG_INET_DIAG is not set
> > # CONFIG_TCP_CONG_ADVANCED is not set
> > CONFIG_TCP_CONG_CUBIC=y
> > CONFIG_DEFAULT_TCP_CONG="cubic"
> > # CONFIG_TCP_MD5SIG is not set
> > # CONFIG_IPV6 is not set
> > # CONFIG_NETWORK_SECMARK is not set
> > # CONFIG_NETFILTER is not set
> > # CONFIG_IP_DCCP is not set
> > # CONFIG_IP_SCTP is not set
> > # CONFIG_TIPC is not set
> > # CONFIG_ATM is not set
> > # CONFIG_BRIDGE is not set
> > # CONFIG_NET_DSA is not set
> > # CONFIG_VLAN_8021Q is not set
> > # CONFIG_DECNET is not set
> > # CONFIG_LLC2 is not set
> > # CONFIG_IPX is not set
> > # CONFIG_ATALK is not set
> > # CONFIG_X25 is not set
> > # CONFIG_LAPB is not set
> > # CONFIG_ECONET is not set
> > # CONFIG_WAN_ROUTER is not set
> > # CONFIG_NET_SCHED is not set
> > # CONFIG_DCB is not set
> > 
> > #
> > # Network testing
> > #
> > # CONFIG_HAMRADIO is not set
> > # CONFIG_CAN is not set
> > # CONFIG_IRDA is not set
> > # CONFIG_BT is not set
> > # CONFIG_AF_RXRPC is not set
> > # CONFIG_PHONET is not set
> > # CONFIG_WIRELESS is not set
> > # CONFIG_RFKILL is not set
> > # CONFIG_NET_9P is not set
> > 
> > #
> > # Device Drivers
> > #
> > 
> > #
> > # Generic Driver Options
> > #
> > CONFIG_STANDALONE=y
> > # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> > # CONFIG_DEBUG_DRIVER is not set
> > # CONFIG_DEBUG_DEVRES is not set
> > # CONFIG_SYS_HYPERVISOR is not set
> > # CONFIG_CONNECTOR is not set
> > # CONFIG_MTD is not set
> > # CONFIG_PARPORT is not set
> > # CONFIG_MISC_DEVICES is not set
> > CONFIG_HAVE_IDE=y
> > 
> > #
> > # SCSI device support
> > #
> > # CONFIG_SCSI_DMA is not set
> > # CONFIG_SCSI_NETLINK is not set
> > # CONFIG_MACINTOSH_DRIVERS is not set
> > # CONFIG_NETDEVICES is not set
> > # CONFIG_ISDN is not set
> > # CONFIG_PHONE is not set
> > 
> > #
> > # Input device support
> > #
> > CONFIG_INPUT=y
> > # CONFIG_INPUT_FF_MEMLESS is not set
> > # CONFIG_INPUT_POLLDEV is not set
> > 
> > #
> > # Userland interfaces
> > #
> > # CONFIG_INPUT_MOUSEDEV is not set
> > # CONFIG_INPUT_JOYDEV is not set
> > # CONFIG_INPUT_EVDEV is not set
> > # CONFIG_INPUT_EVBUG is not set
> > 
> > #
> > # Input Device Drivers
> > #
> > # CONFIG_INPUT_KEYBOARD is not set
> > # CONFIG_INPUT_MOUSE is not set
> > # CONFIG_INPUT_JOYSTICK is not set
> > # CONFIG_INPUT_TABLET is not set
> > # CONFIG_INPUT_TOUCHSCREEN is not set
> > # CONFIG_INPUT_MISC is not set
> > 
> > #
> > # Hardware I/O ports
> > #
> > # CONFIG_SERIO is not set
> > # CONFIG_GAMEPORT is not set
> > 
> > #
> > # Character devices
> > #
> > CONFIG_VT=y
> > # CONFIG_CONSOLE_TRANSLATIONS is not set
> > # CONFIG_VT_CONSOLE is not set
> > CONFIG_HW_CONSOLE=y
> > # CONFIG_VT_HW_CONSOLE_BINDING is not set
> > # CONFIG_DEVKMEM is not set
> > # CONFIG_SERIAL_NONSTANDARD is not set
> > 
> > #
> > # Serial drivers
> > #
> > # CONFIG_SERIAL_8250 is not set
> > CONFIG_FIX_EARLYCON_MEM=y
> > 
> > #
> > # Non-8250 serial port support
> > #
> > # CONFIG_UNIX98_PTYS is not set
> > # CONFIG_LEGACY_PTYS is not set
> > # CONFIG_IPMI_HANDLER is not set
> > # CONFIG_HW_RANDOM is not set
> > # CONFIG_NVRAM is not set
> > # CONFIG_RTC is not set
> > # CONFIG_GEN_RTC is not set
> > # CONFIG_R3964 is not set
> > # CONFIG_MWAVE is not set
> > # CONFIG_PC8736x_GPIO is not set
> > # CONFIG_HANGCHECK_TIMER is not set
> > # CONFIG_TCG_TPM is not set
> > # CONFIG_TELCLOCK is not set
> > # CONFIG_I2C is not set
> > # CONFIG_SPI is not set
> > CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> > # CONFIG_GPIOLIB is not set
> > # CONFIG_W1 is not set
> > # CONFIG_POWER_SUPPLY is not set
> > # CONFIG_HWMON is not set
> > # CONFIG_THERMAL is not set
> > CONFIG_THERMAL_HWMON=y
> > # CONFIG_WATCHDOG is not set
> > CONFIG_SSB_POSSIBLE=y
> > 
> > #
> > # Sonics Silicon Backplane
> > #
> > # CONFIG_SSB is not set
> > 
> > #
> > # Multifunction device drivers
> > #
> > # CONFIG_MFD_CORE is not set
> > # CONFIG_MFD_SM501 is not set
> > # CONFIG_HTC_PASIC3 is not set
> > # CONFIG_MFD_TMIO is not set
> > # CONFIG_REGULATOR is not set
> > 
> > #
> > # Multimedia devices
> > #
> > 
> > #
> > # Multimedia core support
> > #
> > # CONFIG_VIDEO_DEV is not set
> > # CONFIG_DVB_CORE is not set
> > # CONFIG_VIDEO_MEDIA is not set
> > 
> > #
> > # Multimedia drivers
> > #
> > # CONFIG_DAB is not set
> > 
> > #
> > # Graphics support
> > #
> > # CONFIG_VGASTATE is not set
> > # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> > # CONFIG_FB is not set
> > # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> > 
> > #
> > # Display device support
> > #
> > # CONFIG_DISPLAY_SUPPORT is not set
> > 
> > #
> > # Console display driver support
> > #
> > CONFIG_VGA_CONSOLE=y
> > # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> > CONFIG_DUMMY_CONSOLE=y
> > # CONFIG_SOUND is not set
> > # CONFIG_HID_SUPPORT is not set
> > # CONFIG_USB_SUPPORT is not set
> > # CONFIG_MMC is not set
> > # CONFIG_MEMSTICK is not set
> > # CONFIG_NEW_LEDS is not set
> > # CONFIG_ACCESSIBILITY is not set
> > # CONFIG_EDAC is not set
> > # CONFIG_RTC_CLASS is not set
> > # CONFIG_DMADEVICES is not set
> > # CONFIG_UIO is not set
> > CONFIG_STAGING_EXCLUDE_BUILD=y
> > # CONFIG_X86_PLATFORM_DEVICES is not set
> > 
> > #
> > # Firmware Drivers
> > #
> > # CONFIG_EDD is not set
> > # CONFIG_FIRMWARE_MEMMAP is not set
> > # CONFIG_DELL_RBU is not set
> > # CONFIG_DCDBAS is not set
> > # CONFIG_ISCSI_IBFT_FIND is not set
> > 
> > #
> > # File systems
> > #
> > # CONFIG_DNOTIFY is not set
> > # CONFIG_INOTIFY is not set
> > # CONFIG_QUOTA is not set
> > # CONFIG_AUTOFS_FS is not set
> > # CONFIG_AUTOFS4_FS is not set
> > # CONFIG_FUSE_FS is not set
> > 
> > #
> > # Pseudo filesystems
> > #
> > # CONFIG_PROC_FS is not set
> > # CONFIG_SYSFS is not set
> > # CONFIG_TMPFS is not set
> > # CONFIG_HUGETLBFS is not set
> > # CONFIG_HUGETLB_PAGE is not set
> > 
> > #
> > # Miscellaneous filesystems
> > #
> > # CONFIG_NETWORK_FILESYSTEMS is not set
> > # CONFIG_NLS is not set
> > 
> > #
> > # Kernel hacking
> > #
> > CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> > # CONFIG_ENABLE_WARN_DEPRECATED is not set
> > # CONFIG_ENABLE_MUST_CHECK is not set
> > CONFIG_FRAME_WARN=2048
> > # CONFIG_MAGIC_SYSRQ is not set
> > # CONFIG_UNUSED_SYMBOLS is not set
> > CONFIG_DEBUG_FS=y
> > # CONFIG_HEADERS_CHECK is not set
> > CONFIG_DEBUG_SECTION_MISMATCH=y
> > CONFIG_DEBUG_KERNEL=y
> > # CONFIG_DEBUG_SHIRQ is not set
> > # CONFIG_DETECT_SOFTLOCKUP is not set
> > # CONFIG_DEBUG_OBJECTS is not set
> > # CONFIG_DEBUG_SPINLOCK is not set
> > # CONFIG_DEBUG_MUTEXES is not set
> > # CONFIG_DEBUG_LOCK_ALLOC is not set
> > # CONFIG_PROVE_LOCKING is not set
> > # CONFIG_LOCK_STAT is not set
> > CONFIG_TRACE_IRQFLAGS=y
> > # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> > # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> > CONFIG_STACKTRACE=y
> > # CONFIG_DEBUG_KOBJECT is not set
> > # CONFIG_DEBUG_VM is not set
> > # CONFIG_DEBUG_VIRTUAL is not set
> > # CONFIG_DEBUG_WRITECOUNT is not set
> > # CONFIG_DEBUG_MEMORY_INIT is not set
> > # CONFIG_DEBUG_LIST is not set
> > # CONFIG_DEBUG_SG is not set
> > # CONFIG_DEBUG_NOTIFIERS is not set
> > CONFIG_FRAME_POINTER=y
> > # CONFIG_RCU_TORTURE_TEST is not set
> > # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> > # CONFIG_BACKTRACE_SELF_TEST is not set
> > # CONFIG_FAULT_INJECTION is not set
> > # CONFIG_LATENCYTOP is not set
> > CONFIG_USER_STACKTRACE_SUPPORT=y
> > CONFIG_NOP_TRACER=y
> > CONFIG_HAVE_FUNCTION_TRACER=y
> > CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> > CONFIG_HAVE_DYNAMIC_FTRACE=y
> > CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> > CONFIG_TRACER_MAX_TRACE=y
> > CONFIG_RING_BUFFER=y
> > CONFIG_TRACING=y
> > 
> > #
> > # Tracers
> > #
> > CONFIG_FUNCTION_TRACER=y
> > CONFIG_IRQSOFF_TRACER=y
> > CONFIG_SYSPROF_TRACER=y
> > # CONFIG_SCHED_TRACER is not set
> > CONFIG_CONTEXT_SWITCH_TRACER=y
> > CONFIG_BOOT_TRACER=y
> > CONFIG_TRACE_BRANCH_PROFILING=y
> > # CONFIG_PROFILE_ALL_BRANCHES is not set
> > # CONFIG_BRANCH_TRACER is not set
> > CONFIG_STACK_TRACER=y
> > CONFIG_DYNAMIC_FTRACE=y
> > CONFIG_FTRACE_MCOUNT_RECORD=y
> > CONFIG_KMEMTRACE=y
> > # CONFIG_SAMPLES is not set
> > CONFIG_HAVE_ARCH_KGDB=y
> > # CONFIG_KGDB is not set
> > # CONFIG_STRICT_DEVMEM is not set
> > # CONFIG_X86_VERBOSE_BOOTUP is not set
> > # CONFIG_EARLY_PRINTK is not set
> > # CONFIG_DEBUG_STACKOVERFLOW is not set
> > # CONFIG_DEBUG_STACK_USAGE is not set
> > # CONFIG_DEBUG_PAGEALLOC is not set
> > # CONFIG_X86_PTDUMP is not set
> > # CONFIG_DEBUG_RODATA is not set
> > CONFIG_IO_DELAY_TYPE_0X80=0
> > CONFIG_IO_DELAY_TYPE_0XED=1
> > CONFIG_IO_DELAY_TYPE_UDELAY=2
> > CONFIG_IO_DELAY_TYPE_NONE=3
> > CONFIG_IO_DELAY_0X80=y
> > # CONFIG_IO_DELAY_0XED is not set
> > # CONFIG_IO_DELAY_UDELAY is not set
> > # CONFIG_IO_DELAY_NONE is not set
> > CONFIG_DEFAULT_IO_DELAY_TYPE=0
> > # CONFIG_DEBUG_BOOT_PARAMS is not set
> > # CONFIG_CPA_DEBUG is not set
> > CONFIG_OPTIMIZE_INLINING=y
> > 
> > #
> > # Security options
> > #
> > # CONFIG_KEYS is not set
> > # CONFIG_SECURITYFS is not set
> > # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> > # CONFIG_CRYPTO is not set
> > CONFIG_HAVE_KVM=y
> > # CONFIG_VIRTUALIZATION is not set
> > 
> > #
> > # Library routines
> > #
> > CONFIG_GENERIC_FIND_FIRST_BIT=y
> > CONFIG_GENERIC_FIND_NEXT_BIT=y
> > # CONFIG_CRC_CCITT is not set
> > # CONFIG_CRC16 is not set
> > # CONFIG_CRC_T10DIF is not set
> > # CONFIG_CRC_ITU_T is not set
> > # CONFIG_CRC32 is not set
> > # CONFIG_CRC7 is not set
> > # CONFIG_LIBCRC32C is not set
> > CONFIG_HAS_IOMEM=y
> > CONFIG_HAS_IOPORT=y
> > CONFIG_HAS_DMA=y
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
