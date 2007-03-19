Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXCSNUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXCSNUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965846AbXCSNUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:20:22 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:42731 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565AbXCSNUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:20:18 -0400
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 09:20:17 EDT
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Suspend to RAM doesn't work anymore in 2.6.21
Date: Mon, 19 Mar 2007 13:50:39 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1545148.u7O9nPUgND";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703191350.44105.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.1.8 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	0.0 UPPERCASE_25_50        Nachrichtentext besteht zu 25-50% aus Grossbuchstaben
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 34211d21a4b91654be5c599c74847e2e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1545148.u7O9nPUgND
Content-Type: multipart/mixed;
  boundary="Boundary-01=_gco/F0WOpCwlLx3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_gco/F0WOpCwlLx3
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Suspend to RAM used to work fine on my computer (Intel Core Duo, 1 GB RAM,=
=20
Intel 82801G (ICH7-chipset) mainboard, NVIDIA-gfx-card, tg3-ethernet) up to=
=20
2.6.20.3. But no matter which rc of 2.6.21 I use, suspend to RAM doesn't wo=
rk=20
anymore. Up to rc3 even suspending stopped at "suspending console" which=20
appearently seems to be fixed in rc4. I tried rc4-git4 with minimal config=
=20
(no dyndicks, no HRT, no MSI, no sound, no bluetooth, no PCMCIA, no WLAN, n=
o=20
USB, no cpufreq) but still I can't resume properly. Caps works and I can=20
login through SSH. Back to a more complete config (sound, MMC, WLAN, PCMCIA=
 -=20
still no dynticks or HRT - see attachment "config") I get exactly the same=
=20
behaviour.

When logged in through SSH after resume I saved output of dmesg (which=20
includes full power management debug messages), see=20
attachement "dmesg-resume". The system basically seems to be back but lot o=
f=20
things do not work such as loading/unloading e.g. my WLAN-driver (ipw3945),=
=20
running "top" or "dstat" etc.   "uptime" always returns 0 min, even with=20
power management debug disabled.

Kernel:
Linux version 2.6.21-rc4 (gcc version 4.1.2 20061115 (prerelease) (Debian=20
4.1.1-21)) #23 SMP PREEMPT Mon Mar 19 12:27:56 CET 2007



How can I help with further debugging or things like that? Please add me to=
 Cc=20
as I'm not subscribed.

Tobias

--Boundary-01=_gco/F0WOpCwlLx3
Content-Type: text/plain;
  charset="utf-8";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21-rc4
# Mon Mar 19 12:34:48 2007
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
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_CPUSETS is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
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

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

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
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_SMP=y
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
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
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
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
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
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
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
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
CONFIG_PM_DEBUG=y
# CONFIG_DISABLE_CONSOLE_SUSPEND is not set
CONFIG_PM_TRACE=y
CONFIG_PM_SYSFS_DEPRECATED=y
# CONFIG_SOFTWARE_SUSPEND is not set
CONFIG_SUSPEND_SMP=y

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
CONFIG_ACPI_SLEEP_PROC_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y

#
# APM (Advanced Power Management) BIOS Support
#
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_SPEEDSTEP_CENTRINO_ACPI is not set
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
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
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCI_MSI=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
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
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set

#
# IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK is not set
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK_SUPPORT=y
# CONFIG_IP_NF_CONNTRACK_SUPPORT is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
# CONFIG_IP_NF_MATCH_TOS is not set
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_OWNER is not set
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_REDIRECT is not set
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
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

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
CONFIG_VLAN_8021Q=m
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

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
# CONFIG_IEEE80211_SOFTMAC is not set
CONFIG_WIRELESS_EXT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
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

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set

#
# ATA/ATAPI/MFM/RLL support
#
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
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
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
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
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# PCMCIA SCSI adapter support
#
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_NINJA_SCSI is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACPI=y
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Macintosh device drivers
#
# CONFIG_MAC_EMUMOUSEBTN is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set

#
# Ethernet (1000 Mbit)
#
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
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
CONFIG_NET_RADIO=y
# CONFIG_NET_WIRELESS_RTNETLINK is not set

#
# Obsolete Wireless cards support (pre-802.11)
#
# CONFIG_STRIP is not set
# CONFIG_PCMCIA_WAVELAN is not set
# CONFIG_PCMCIA_NETWAVE is not set

#
# Wireless 802.11 Frequency Hopping cards support
#
# CONFIG_PCMCIA_RAYCS is not set

#
# Wireless 802.11b ISA/PCI cards support
#
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set

#
# Wireless 802.11b Pcmcia/Cardbus cards support
#
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set

#
# Prism GT/Duette 802.11(a/b/g) PCI/Cardbus support
#
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
CONFIG_NET_WIRELESS=y

#
# PCMCIA network device support
#
# CONFIG_NET_PCMCIA is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=800
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
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
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
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
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
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
# CONFIG_HWMON is not set
# CONFIG_HWMON_VID is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frambuffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set

#
# Logo configuration
#
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y

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
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# SoC audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

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
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

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
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_ACECAD is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_TOUCHSCREEN is not set
# CONFIG_USB_YEALINK is not set
# CONFIG_USB_XPAD is not set
# CONFIG_USB_ATI_REMOTE is not set
# CONFIG_USB_ATI_REMOTE2 is not set
# CONFIG_USB_KEYSPAN_REMOTE is not set
# CONFIG_USB_APPLETOUCH is not set
# CONFIG_USB_GTCO is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_MON is not set

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

#
# MMC/SD Card support
#
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_BLOCK=y
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set

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
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y

#
# Auxiliary Display support
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
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
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_DIRECTIO=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
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
CONFIG_NLS_DEFAULT="iso8859-15"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
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
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
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
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

--Boundary-01=_gco/F0WOpCwlLx3
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-resume"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-resume"

=2E..

Allocate Port Service[0000:00:1c.1:pcie03]
PM: Adding info for pci_express:0000:00:1c.1:pcie03
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
PM: Adding info for pci_express:0000:00:1c.2:pcie00
Allocate Port Service[0000:00:1c.2:pcie02]
PM: Adding info for pci_express:0000:00:1c.2:pcie02
Allocate Port Service[0000:00:1c.2:pcie03]
PM: Adding info for pci_express:0000:00:1c.2:pcie03
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
PM: Adding info for pci_express:0000:00:1c.3:pcie00
Allocate Port Service[0000:00:1c.3:pcie02]
PM: Adding info for pci_express:0000:00:1c.3:pcie02
Allocate Port Service[0000:00:1c.3:pcie03]
PM: Adding info for pci_express:0000:00:1c.3:pcie03
PM: Adding info for platform:vesafb.0
vesafb: framebuffer at 0xc0000000, mapped to 0xf8880000, using 3072k, total=
 262144k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D1
vesafb: protected mode interface info at c000:c4e0
vesafb: pmi: set display start =3D c00cc516, set palette =3D c00cc580
vesafb: pmi: ports =3D 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce =
3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da=20
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
PM: Adding info for No Bus:fb0
PM: Adding info for No Bus:vtcon1
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ACAD] (off-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT 3FE85F02, 0238 (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
ACPI: SSDT 3FE859BB, 04C2 (r1  PmRef  Cpu0Cst     3001 INTL 20050228)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3FE8613A, 00C8 (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
ACPI: SSDT 3FE85E7D, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050228)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [TZ00] (37 C)
ACPI: Thermal Zone [TZ01] (37 C)
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
hpet_resources: 0xfed00000 is busy
loop: loaded (max 8 devices)
PM: Adding info for No Bus:lo
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
PM: Adding info for No Bus:tun
ata_piix 0000:00:1f.2: version 2.10ac1
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00015440 irq =
14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00015448 irq =
15
scsi0 : ata_piix
PM: Adding info for No Bus:host0
Clocksource tsc unstable (delta =3D -154102037 ns)
ata1.00: ATA-7: TOSHIBA MK1234GSX, AH001A, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
scsi1 : ata_piix
PM: Adding info for No Bus:host1
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1234GS AH00 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
 sda: sda1 < sda5 sda6 > sda2 sda3 sda4
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-845S  D201 PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:0:0
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:08' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:09' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio0
serio: i8042 AUX0 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio1
serio: i8042 AUX1 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio2
serio: i8042 AUX2 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio3
serio: i8042 AUX3 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio4
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:2=
5:50 2007 UTC).
PM: Adding info for No Bus:timer
PM: Adding info for No Bus:sequencer
PM: Adding info for No Bus:sequencer2
PM: Adding info for No Bus:seq
ALSA device list:
  No soundcards found.
IPv4 over IPv4 tunneling driver
PM: Adding info for No Bus:tunl0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI No-Shortcut mode
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x12a0b1, caps: 0xa04713/0x204000
input: SynPS/2 Synaptics TouchPad as /class/input/input5
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: replayed 7 transactions in 0 seconds
ReiserFS: sda3: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
=46reeing unused kernel memory: 188k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
tg3.c:v3.74 (February 20, 2007)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:04:00.0 to 64
PM: Adding info for No Bus:eth0
eth0: Tigon3 [partno(BCM95789) rev 4201 PHY(5750)] (PCI Express) 10/100/100=
0Base-T Ethernet 00:16:d4:10:9a:b1
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap=
[1]=20
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Adding 3004112k swap on /dev/sda6.  Priority:-1 extents:1 across:3004112k
ReiserFS: sda4: found reiserfs format "3.6" with standard journal
ReiserFS: sda4: using ordered data mode
ReiserFS: sda4: journal params: device sda4, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda4: checking transaction log (sda4)
ReiserFS: sda4: replayed 4 transactions in 0 seconds
ReiserFS: sda4: Using r5 hash to sort names
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 10050=
6, writing 100106)
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
PM: Preparing system for mem sleep
Stopping tasks ... done.
Suspending console(s)
psmouse serio4: suspend
serio serio3: suspend
serio serio2: suspend
serio serio1: suspend
atkbd serio0: suspend
i8042 i8042: suspend
sr 1:0:0:0: suspend
sd 0:0:0:0: suspend
vesafb vesafb.0: suspend
pci_express 0000:00:1c.3:pcie03: suspend
pci_express 0000:00:1c.3:pcie02: suspend
pci_express 0000:00:1c.3:pcie00: suspend
pci_express 0000:00:1c.2:pcie03: suspend
pci_express 0000:00:1c.2:pcie02: suspend
pci_express 0000:00:1c.2:pcie00: suspend
pci_express 0000:00:1c.1:pcie03: suspend
pci_express 0000:00:1c.1:pcie02: suspend
pci_express 0000:00:1c.1:pcie00: suspend
pci_express 0000:00:1c.0:pcie03: suspend
pci_express 0000:00:1c.0:pcie02: suspend
pci_express 0000:00:1c.0:pcie00: suspend
pci_express 0000:00:01.0:pcie03: suspend
pci_express 0000:00:01.0:pcie00: suspend
platform pcspkr: suspend
pnp 00:0a: suspend
i8042 aux 00:09: suspend
i8042 kbd 00:08: suspend
pnp 00:07: suspend
system 00:06: suspend
pnp 00:05: suspend
system 00:04: suspend
pnp 00:03: suspend
pnp 00:02: suspend
system 00:01: suspend
pnp 00:00: suspend
pci 0000:06:04.4: suspend
pci 0000:06:04.3: suspend
pci 0000:06:04.2: suspend
pci 0000:06:04.1: suspend
pci 0000:06:04.0: suspend
pci 0000:06:00.0: suspend
pci 0000:05:00.0: suspend
tg3 0000:04:00.0: suspend
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 10050=
6, writing 100106)
pci 0000:01:00.0: suspend
pci 0000:00:1f.3: suspend
ata_piix 0000:00:1f.2: suspend
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
pci 0000:00:1f.0: suspend
pci 0000:00:1e.0: suspend
pci 0000:00:1d.7: suspend
pci 0000:00:1d.3: suspend
pci 0000:00:1d.2: suspend
pci 0000:00:1d.1: suspend
pci 0000:00:1d.0: suspend
pcieport-driver 0000:00:1c.3: suspend
pcieport-driver 0000:00:1c.2: suspend
pcieport-driver 0000:00:1c.1: suspend
pcieport-driver 0000:00:1c.0: suspend
pci 0000:00:1b.0: suspend
pcieport-driver 0000:00:01.0: suspend
pci 0000:00:00.0: suspend
thermal thermal:02: suspend
thermal thermal:01: suspend
acpi thermal:00: suspend
acpi device:38: suspend
acpi device:37: suspend
acpi device:36: suspend
acpi device:35: suspend
acpi device:34: suspend
acpi device:33: suspend
acpi device:32: suspend
acpi device:31: suspend
acpi device:30: suspend
acpi device:2f: suspend
acpi device:2e: suspend
acpi device:2d: suspend
acpi device:2c: suspend
acpi SMCF010:00: suspend
container PNP0A05:00: suspend
ac ACPI0003:00: suspend
acpi SYN0703:00: suspend
acpi PNP0303:00: suspend
acpi PNP0100:00: suspend
acpi PNP0B00:00: suspend
acpi PNP0C02:01: suspend
acpi PNP0C04:00: suspend
acpi PNP0000:00: suspend
acpi PNP0103:00: suspend
acpi INT0800:00: suspend
acpi PNP0200:00: suspend
battery PNP0C0A:00: suspend
ec PNP0C09:00: suspend
pci_link PNP0C0F:07: suspend
pci_link PNP0C0F:06: suspend
pci_link PNP0C0F:05: suspend
pci_link PNP0C0F:04: suspend
pci_link PNP0C0F:03: suspend
pci_link PNP0C0F:02: suspend
pci_link PNP0C0F:01: suspend
pci_link PNP0C0F:00: suspend
acpi device:2b: suspend
acpi device:2a: suspend
acpi device:29: suspend
acpi device:28: suspend
acpi device:27: suspend
acpi device:26: suspend
acpi device:25: suspend
acpi device:24: suspend
acpi device:23: suspend
acpi device:22: suspend
acpi device:21: suspend
acpi device:20: suspend
acpi device:1f: suspend
acpi device:1e: suspend
acpi device:1d: suspend
acpi device:1c: suspend
acpi device:1b: suspend
acpi device:1a: suspend
acpi device:19: suspend
acpi device:18: suspend
acpi device:17: suspend
acpi device:16: suspend
acpi device:15: suspend
acpi device:14: suspend
acpi device:13: suspend
acpi device:12: suspend
acpi device:11: suspend
acpi device:10: suspend
acpi device:0f: suspend
acpi device:0e: suspend
acpi device:0d: suspend
acpi device:0c: suspend
acpi device:0b: suspend
acpi device:0a: suspend
acpi device:09: suspend
acpi device:08: suspend
acpi device:07: suspend
acpi device:06: suspend
acpi device:05: suspend
acpi video:01: suspend
acpi device:04: suspend
acpi device:03: suspend
acpi device:02: suspend
acpi video:00: suspend
acpi device:01: suspend
acpi PNP0C02:00: suspend
pci_root PNP0A08:00: suspend
button PNP0C0C:00: suspend
button PNP0C0E:00: suspend
acpi PNP0C14:00: suspend
button PNP0C0D:00: suspend
acpi device:00: suspend
processor ACPI0007:01: suspend
processor ACPI0007:00: suspend
button button_power:00: suspend
acpi acpi_system:00: suspend
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
PM: Removing info for No Bus:msr1
PM: Removing info for No Bus:cpu1
CPU1 is down
PM: Entering mem sleep
vesafb vesafb.0: LATE suspend
platform pcspkr: LATE suspend
pci 0000:06:04.4: LATE suspend
pci 0000:06:04.3: LATE suspend
pci 0000:06:04.2: LATE suspend
pci 0000:06:04.1: LATE suspend
pci 0000:06:04.0: LATE suspend
pci 0000:06:00.0: LATE suspend
pci 0000:05:00.0: LATE suspend
tg3 0000:04:00.0: LATE suspend
pci 0000:01:00.0: LATE suspend
pci 0000:00:1f.3: LATE suspend
pci 0000:00:1f.0: LATE suspend
pci 0000:00:1e.0: LATE suspend
pci 0000:00:1d.7: LATE suspend
pci 0000:00:1d.3: LATE suspend
pci 0000:00:1d.2: LATE suspend
pci 0000:00:1d.1: LATE suspend
pci 0000:00:1d.0: LATE suspend
pcieport-driver 0000:00:1c.3: LATE suspend
pcieport-driver 0000:00:1c.2: LATE suspend
pcieport-driver 0000:00:1c.1: LATE suspend
pcieport-driver 0000:00:1c.0: LATE suspend
pci 0000:00:1b.0: LATE suspend
pcieport-driver 0000:00:01.0: LATE suspend
pci 0000:00:00.0: LATE suspend
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Back to C!
pci 0000:00:00.0: EARLY resume
pcieport-driver 0000:00:01.0: EARLY resume
pci 0000:00:1b.0: EARLY resume
pcieport-driver 0000:00:1c.0: EARLY resume
pcieport-driver 0000:00:1c.1: EARLY resume
pcieport-driver 0000:00:1c.2: EARLY resume
pcieport-driver 0000:00:1c.3: EARLY resume
pci 0000:00:1d.0: EARLY resume
pci 0000:00:1d.1: EARLY resume
pci 0000:00:1d.2: EARLY resume
pci 0000:00:1d.3: EARLY resume
pci 0000:00:1d.7: EARLY resume
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
ata_piix 0000:00:1f.2: EARLY resume
pci 0000:00:1f.3: EARLY resume
pci 0000:01:00.0: EARLY resume
tg3 0000:04:00.0: EARLY resume
pci 0000:05:00.0: EARLY resume
pci 0000:06:00.0: EARLY resume
pci 0000:06:04.0: EARLY resume
pci 0000:06:04.1: EARLY resume
pci 0000:06:04.2: EARLY resume
pci 0000:06:04.3: EARLY resume
pci 0000:06:04.4: EARLY resume
platform pcspkr: EARLY resume
vesafb vesafb.0: EARLY resume
i8042 i8042: EARLY resume
PM: Finishing wakeup.
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 189932.25 BogoMIPS (lpj=3D=
94966129)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000=
c189 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c189 00=
000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Genuine Intel(R) CPU           T2250  @ 1.73GHz stepping 08
PM: Adding info for No Bus:msr1
PM: Adding info for No Bus:cpu1
CPU1 is up
acpi acpi_system:00: resuming
button button_power:00: resuming
processor ACPI0007:00: resuming
processor ACPI0007:01: resuming
acpi device:00: resuming
button PNP0C0D:00: resuming
acpi PNP0C14:00: resuming
button PNP0C0E:00: resuming
button PNP0C0C:00: resuming
pci_root PNP0A08:00: resuming
acpi PNP0C02:00: resuming
acpi device:01: resuming
acpi video:00: resuming
acpi device:02: resuming
acpi device:03: resuming
acpi device:04: resuming
acpi video:01: resuming
acpi device:05: resuming
acpi device:06: resuming
acpi device:07: resuming
acpi device:08: resuming
acpi device:09: resuming
acpi device:0a: resuming
acpi device:0b: resuming
acpi device:0c: resuming
acpi device:0d: resuming
acpi device:0e: resuming
acpi device:0f: resuming
acpi device:10: resuming
acpi device:11: resuming
acpi device:12: resuming
acpi device:13: resuming
acpi device:14: resuming
acpi device:15: resuming
acpi device:16: resuming
acpi device:17: resuming
acpi device:18: resuming
acpi device:19: resuming
acpi device:1a: resuming
acpi device:1b: resuming
acpi device:1c: resuming
acpi device:1d: resuming
acpi device:1e: resuming
acpi device:1f: resuming
acpi device:20: resuming
acpi device:21: resuming
acpi device:22: resuming
acpi device:23: resuming
acpi device:24: resuming
acpi device:25: resuming
acpi device:26: resuming
acpi device:27: resuming
acpi device:28: resuming
acpi device:29: resuming
acpi device:2a: resuming
acpi device:2b: resuming
pci_link PNP0C0F:00: resuming
pci_link PNP0C0F:01: resuming
pci_link PNP0C0F:02: resuming
pci_link PNP0C0F:03: resuming
pci_link PNP0C0F:04: resuming
pci_link PNP0C0F:05: resuming
pci_link PNP0C0F:06: resuming
pci_link PNP0C0F:07: resuming
ec PNP0C09:00: resuming
battery PNP0C0A:00: resuming
acpi PNP0200:00: resuming
acpi INT0800:00: resuming
acpi PNP0103:00: resuming
acpi PNP0000:00: resuming
acpi PNP0C04:00: resuming
acpi PNP0C02:01: resuming
acpi PNP0B00:00: resuming
acpi PNP0100:00: resuming
acpi PNP0303:00: resuming
acpi SYN0703:00: resuming
ac ACPI0003:00: resuming
container PNP0A05:00: resuming
acpi SMCF010:00: resuming
acpi device:2c: resuming
acpi device:2d: resuming
acpi device:2e: resuming
acpi device:2f: resuming
acpi device:30: resuming
acpi device:31: resuming
acpi device:32: resuming
acpi device:33: resuming
acpi device:34: resuming
acpi device:35: resuming
acpi device:36: resuming
acpi device:37: resuming
acpi device:38: resuming
acpi thermal:00: resuming
thermal thermal:01: resuming
thermal thermal:02: resuming
pci 0000:00:00.0: resuming
pcieport-driver 0000:00:01.0: resuming
PM: Writing back config space on device 0000:00:01.0 at offset f (was 100, =
writing 1a0106)
PM: Writing back config space on device 0000:00:01.0 at offset a (was f, wr=
iting 0)
PM: Writing back config space on device 0000:00:01.0 at offset 9 (was 1fff1=
, writing cff1c001)
PM: Writing back config space on device 0000:00:01.0 at offset 8 (was fff0,=
 writing d1f0d000)
PM: Writing back config space on device 0000:00:01.0 at offset 7 (was f0, w=
riting 6060)
PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000=
, writing 10010)
PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 10000=
7, writing 100507)
PCI: Setting latency timer of device 0000:00:01.0 to 64
pci 0000:00:1b.0: resuming
pcieport-driver 0000:00:1c.0: resuming
PM: Writing back config space on device 0000:00:1c.0 at offset f (was 40100=
, writing 4010b)
PM: Writing back config space on device 0000:00:1c.0 at offset 9 (was 10001=
, writing 1fff1)
PM: Writing back config space on device 0000:00:1c.0 at offset 8 (was 0, wr=
iting fff0)
PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was 20000=
000, writing 200000f0)
PM: Writing back config space on device 0000:00:1c.0 at offset 6 (was 0, wr=
iting 20200)
PM: Writing back config space on device 0000:00:1c.0 at offset 3 (was 81000=
0, writing 810010)
PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 10000=
0, writing 100504)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pcieport-driver 0000:00:1c.1: resuming
PM: Writing back config space on device 0000:00:1c.1 at offset f (was 40200=
, writing 40206)
PM: Writing back config space on device 0000:00:1c.1 at offset 9 (was 10001=
, writing 1fff1)
PM: Writing back config space on device 0000:00:1c.1 at offset 8 (was 0, wr=
iting fff0)
PM: Writing back config space on device 0000:00:1c.1 at offset 7 (was 20000=
000, writing 200000f0)
PM: Writing back config space on device 0000:00:1c.1 at offset 3 (was 81000=
0, writing 810010)
PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 10000=
0, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pcieport-driver 0000:00:1c.2: resuming
PM: Writing back config space on device 0000:00:1c.2 at offset f (was 40300=
, writing 4030b)
PM: Writing back config space on device 0000:00:1c.2 at offset 9 (was 10001=
, writing 1fff1)
PM: Writing back config space on device 0000:00:1c.2 at offset 8 (was 0, wr=
iting d200d200)
PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was 20000=
000, writing 200000f0)
PM: Writing back config space on device 0000:00:1c.2 at offset 3 (was 81000=
0, writing 810010)
PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 10000=
0, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.2 to 64
pcieport-driver 0000:00:1c.3: resuming
PM: Writing back config space on device 0000:00:1c.3 at offset f (was 40400=
, writing 4040a)
PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001=
, writing 1fff1)
PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, wr=
iting d210d210)
PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 20000=
000, writing 200000f0)
PM: Writing back config space on device 0000:00:1c.3 at offset 6 (was 0, wr=
iting 50500)
PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 81000=
0, writing 810010)
PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 10000=
0, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.3 to 64
pci 0000:00:1d.0: resuming
pci 0000:00:1d.1: resuming
pci 0000:00:1d.2: resuming
pci 0000:00:1d.3: resuming
pci 0000:00:1d.7: resuming
pci 0000:00:1e.0: resuming
PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001=
, writing 53f15001)
PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0, wr=
iting d220d220)
PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 22800=
000, writing 22807070)
PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 10000=
4, writing 100007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
pci 0000:00:1f.0: resuming
PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 21000=
07, writing 2100107)
ata_piix 0000:00:1f.2: resuming
PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, =
writing 2ff)
PM: Writing back config space on device 0000:00:1f.2 at offset 7 (was 1, wr=
iting 375)
PM: Writing back config space on device 0000:00:1f.2 at offset 6 (was 1, wr=
iting 171)
PM: Writing back config space on device 0000:00:1f.2 at offset 5 (was 1, wr=
iting 3f5)
PM: Writing back config space on device 0000:00:1f.2 at offset 4 (was 1, wr=
iting 1f1)
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b000=
05, writing 2b80005)
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
pci 0000:00:1f.3: resuming
pci 0000:01:00.0: resuming
PM: Writing back config space on device 0000:01:00.0 at offset f (was 100, =
writing 106)
PM: Writing back config space on device 0000:01:00.0 at offset 9 (was 1, wr=
iting 6001)
PM: Writing back config space on device 0000:01:00.0 at offset 7 (was 4, wr=
iting d0000004)
PM: Writing back config space on device 0000:01:00.0 at offset 5 (was c, wr=
iting c000000c)
PM: Writing back config space on device 0000:01:00.0 at offset 4 (was 0, wr=
iting d1000000)
PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, wr=
iting 10)
PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 10000=
0, writing 100107)
tg3 0000:04:00.0: resuming
PM: Writing back config space on device 0000:04:00.0 at offset 3 (was 0, wr=
iting 10)
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 10000=
0, writing 100506)
tg3: eth0: Link is down.
pci 0000:05:00.0: resuming
PM: Writing back config space on device 0000:05:00.0 at offset f (was 100, =
writing 10a)
PM: Writing back config space on device 0000:05:00.0 at offset 4 (was 0, wr=
iting d2100000)
PM: Writing back config space on device 0000:05:00.0 at offset 3 (was 0, wr=
iting 10)
PM: Writing back config space on device 0000:05:00.0 at offset 1 (was 10000=
0, writing 100106)
pci 0000:06:00.0: resuming
pci 0000:06:04.0: resuming
PM: Writing back config space on device 0000:06:04.0 at offset f (was 74001=
ff, writing 7400106)
PM: Writing back config space on device 0000:06:04.0 at offset e (was 0, wr=
iting 78fc)
PM: Writing back config space on device 0000:06:04.0 at offset d (was 0, wr=
iting 7800)
PM: Writing back config space on device 0000:06:04.0 at offset c (was 0, wr=
iting 74fc)
PM: Writing back config space on device 0000:06:04.0 at offset b (was 0, wr=
iting 7400)
PM: Writing back config space on device 0000:06:04.0 at offset a (was 0, wr=
iting 57fff000)
PM: Writing back config space on device 0000:06:04.0 at offset 9 (was 0, wr=
iting 54000000)
PM: Writing back config space on device 0000:06:04.0 at offset 8 (was 0, wr=
iting 53fff000)
PM: Writing back config space on device 0000:06:04.0 at offset 7 (was 0, wr=
iting 50000000)
PM: Writing back config space on device 0000:06:04.0 at offset 6 (was 20000=
000, writing b00a0706)
PM: Writing back config space on device 0000:06:04.0 at offset 4 (was 0, wr=
iting d2200000)
ACPI: PCI Interrupt 0000:06:04.0[A] -> GSI 16 (level, low) -> IRQ 16
pci 0000:06:04.1: resuming
PM: Writing back config space on device 0000:06:04.1 at offset f (was 40102=
ff, writing 401020b)
PM: Writing back config space on device 0000:06:04.1 at offset 4 (was 0, wr=
iting d2201800)
pci 0000:06:04.2: resuming
pci 0000:06:04.3: resuming
pci 0000:06:04.4: resuming
PM: Writing back config space on device 0000:06:04.4 at offset 4 (was 0, wr=
iting d2201900)
pnp 00:00: resuming
system 00:01: resuming
pnp 00:02: resuming
pnp 00:03: resuming
system 00:04: resuming
pnp 00:05: resuming
system 00:06: resuming
pnp 00:07: resuming
i8042 kbd 00:08: resuming
pnp: Res cnt 3
pnp: res cnt 3
pnp: Encode io
pnp: Encode io
pnp: Encode irq
pnp: Failed to activate device 00:08.
i8042 aux 00:09: resuming
pnp: Res cnt 1
pnp: res cnt 1
pnp: Encode irq
pnp: Failed to activate device 00:09.
pnp 00:0a: resuming
platform pcspkr: resuming
pci_express 0000:00:01.0:pcie00: resuming
pci_express 0000:00:01.0:pcie03: resuming
pci_express 0000:00:1c.0:pcie00: resuming
pci_express 0000:00:1c.0:pcie02: resuming
pci_express 0000:00:1c.0:pcie03: resuming
pci_express 0000:00:1c.1:pcie00: resuming
pci_express 0000:00:1c.1:pcie02: resuming
pci_express 0000:00:1c.1:pcie03: resuming
pci_express 0000:00:1c.2:pcie00: resuming
pci_express 0000:00:1c.2:pcie02: resuming
pci_express 0000:00:1c.2:pcie03: resuming
pci_express 0000:00:1c.3:pcie00: resuming
pci_express 0000:00:1c.3:pcie02: resuming
pci_express 0000:00:1c.3:pcie03: resuming
vesafb vesafb.0: resuming
sd 0:0:0:0: resuming
sr 1:0:0:0: resuming
i8042 i8042: resuming
atkbd serio0: resuming
serio serio1: resuming
serio serio2: resuming
serio serio3: resuming
psmouse serio4: resuming
Restarting tasks ... done.
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
ata1.00: configured for UDMA/100
SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
ata2.00: configured for UDMA/33

--Boundary-01=_gco/F0WOpCwlLx3--

--nextPart1545148.u7O9nPUgND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF/ockHsjdpw2OaacRAnl6AKDCVV9x9wcqOjGuGWoYUewU4hc2QACfWZvA
1tCm700D+vgQe643YO2KVrg=
=FQel
-----END PGP SIGNATURE-----

--nextPart1545148.u7O9nPUgND--
