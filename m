Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYBGKqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYBGKqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbYBGKq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:46:29 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29977 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYBGKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:46:24 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: OOPS in sysctl.c
Date: Thu, 7 Feb 2008 11:46:08 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200802050845.58691.hs4233@mail.mn-solutions.de> <20080206002420.91124dab.akpm@linux-foundation.org> <20080206190353.GB1732@martell.zuzino.mipt.ru>
In-Reply-To: <20080206190353.GB1732@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071146.08536.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please, post .config and "ls -lR /proc/sys" output _before_
> suspend/resume.

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24
# Thu Feb  7 11:43:09 2008
#
CONFIG_ARM=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_GENERIC_GPIO=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_MMU=y
# CONFIG_NO_IOPORT is not set
CONFIG_GENERIC_HARDIRQS=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ZONE_DMA=y
CONFIG_ARCH_MTD_XIP=y
CONFIG_VECTORS_BASE=0xffff0000
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=13
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
# CONFIG_BUG is not set
# CONFIG_ELF_CORE is not set
# CONFIG_BASE_FULL is not set
# CONFIG_FUTEX is not set
CONFIG_ANON_INODES=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
CONFIG_TINY_SHMEM=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
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
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"

#
# System Type
#
# CONFIG_ARCH_AAEC2000 is not set
# CONFIG_ARCH_INTEGRATOR is not set
# CONFIG_ARCH_REALVIEW is not set
# CONFIG_ARCH_VERSATILE is not set
# CONFIG_ARCH_AT91 is not set
# CONFIG_ARCH_CLPS7500 is not set
# CONFIG_ARCH_CLPS711X is not set
# CONFIG_ARCH_CO285 is not set
# CONFIG_ARCH_EBSA110 is not set
# CONFIG_ARCH_EP93XX is not set
# CONFIG_ARCH_FOOTBRIDGE is not set
# CONFIG_ARCH_NETX is not set
# CONFIG_ARCH_H720X is not set
# CONFIG_ARCH_IMX is not set
# CONFIG_ARCH_IOP13XX is not set
# CONFIG_ARCH_IOP32X is not set
# CONFIG_ARCH_IOP33X is not set
# CONFIG_ARCH_IXP23XX is not set
# CONFIG_ARCH_IXP2000 is not set
# CONFIG_ARCH_IXP4XX is not set
# CONFIG_ARCH_L7200 is not set
# CONFIG_ARCH_KS8695 is not set
# CONFIG_ARCH_NS9XXX is not set
# CONFIG_ARCH_MXC is not set
# CONFIG_ARCH_PNX4008 is not set
CONFIG_ARCH_PXA=y
# CONFIG_ARCH_RPC is not set
# CONFIG_ARCH_SA1100 is not set
# CONFIG_ARCH_S3C2410 is not set
# CONFIG_ARCH_SHARK is not set
# CONFIG_ARCH_LH7A40X is not set
# CONFIG_ARCH_DAVINCI is not set
# CONFIG_ARCH_OMAP is not set
CONFIG_ARCH_MN=y

#
# Intel PXA2xx/PXA3xx Implementations
#
# CONFIG_ARCH_LUBBOCK is not set
# CONFIG_MACH_LOGICPD_PXA270 is not set
# CONFIG_MACH_MAINSTONE is not set
# CONFIG_ARCH_PXA_IDP is not set
# CONFIG_PXA_SHARPSL is not set
# CONFIG_MACH_TRIZEPS4 is not set
# CONFIG_MACH_EM_X270 is not set
# CONFIG_MACH_ZYLONITE is not set
# CONFIG_MACH_ARMCORE is not set
CONFIG_MACH_RT3000=y
CONFIG_PXA25x=y

#
# Boot options
#

#
# Power management
#

#
# Processor Type
#
CONFIG_CPU_32=y
CONFIG_CPU_XSCALE=y
CONFIG_CPU_32v5=y
CONFIG_CPU_ABRT_EV5T=y
CONFIG_CPU_CACHE_VIVT=y
CONFIG_CPU_TLB_V4WBI=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y

#
# Processor Features
#
# CONFIG_ARM_THUMB is not set
# CONFIG_CPU_DCACHE_DISABLE is not set
# CONFIG_OUTER_CACHE is not set
# CONFIG_IWMMXT is not set
CONFIG_XSCALE_PMU=y

#
# Bus support
#
# CONFIG_PCI_SYSCALL is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_PCMCIA_IOCTL=y

#
# PC-card bridges
#
CONFIG_PCMCIA_PXA2XX=y

#
# Kernel Features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_PREEMPT is not set
CONFIG_HZ=100
# CONFIG_AEABI is not set
# CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4096
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_ALIGNMENT_TRAP=y

#
# Boot options
#
CONFIG_ZBOOT_ROM_TEXT=0x00040000
CONFIG_ZBOOT_ROM_BSS=0xa00c0000
CONFIG_ZBOOT_ROM=y
CONFIG_CMDLINE=""
# CONFIG_KEXEC is not set

#
# Floating point emulation
#

#
# At least one emulation must be selected
#
# CONFIG_FPE_NWFPE is not set
# CONFIG_FPE_FASTFPE is not set

#
# Userspace binary formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_ARTHUR is not set

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_SUSPEND=y
# CONFIG_APM_EMULATION is not set

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
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
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
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
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
# CONFIG_NET_SCHED is not set

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
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
# CONFIG_IEEE80211_CRYPT_WEP is not set
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AFS_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# CONFIG_MTD_XIP is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PXA2XX=y
# CONFIG_MTD_ARM_INTEGRATOR is not set
# CONFIG_MTD_SHARP_SL is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
CONFIG_MISC_DEVICES=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_AX88796 is not set
CONFIG_SMC91X=y
# CONFIG_DM9000 is not set
# CONFIG_SMC911X is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_B44 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_HERMES=m
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_HOSTAP is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_WAN is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ATKBD is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_MN=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
# CONFIG_SERIO is not set
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
CONFIG_SERIAL_PXA=y
CONFIG_SERIAL_PXA_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
# CONFIG_I2C_ALGOBIT is not set
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_PXA=y
# CONFIG_I2C_PXA_SLAVE is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_DS1337=m
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
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

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_PXA=y
# CONFIG_FB_PXA_PARAMETERS is not set
# CONFIG_FB_MBX is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
# CONFIG_FONT_8x16 is not set
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

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
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLB_PAGE is not set
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
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
# CONFIG_DEBUG_USER is not set
CONFIG_DEBUG_ERRORS=y
# CONFIG_DEBUG_LL is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
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
CONFIG_ZLIB_DEFLATE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

/proc/sys:
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 debug
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 dev
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 fs
dr-xr-xr-x    0 root     root            0 Feb  8 11:17 kernel
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 net
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 vm

/proc/sys/debug:

/proc/sys/dev:

/proc/sys/fs:
-rw-r--r--    1 root     root            0 Feb  8 11:18 aio-max-nr
-r--r--r--    1 root     root            0 Feb  8 11:18 aio-nr
-r--r--r--    1 root     root            0 Feb  8 11:18 dentry-state
-rw-r--r--    1 root     root            0 Feb  8 11:18 file-max
-r--r--r--    1 root     root            0 Feb  8 11:18 file-nr
-r--r--r--    1 root     root            0 Feb  8 11:18 inode-nr
-r--r--r--    1 root     root            0 Feb  8 11:18 inode-state
-rw-r--r--    1 root     root            0 Feb  8 11:18 lease-break-time
-rw-r--r--    1 root     root            0 Feb  8 11:18 leases-enable
-rw-r--r--    1 root     root            0 Feb  8 11:18 overflowgid
-rw-r--r--    1 root     root            0 Feb  8 11:18 overflowuid
-rw-r--r--    1 root     root            0 Feb  8 11:18 suid_dumpable

/proc/sys/kernel:
-rw-------    1 root     root            0 Feb  8 11:18 cad_pid
-rw-r--r--    1 root     root            0 Feb  8 11:18 core_pattern
-rw-r--r--    1 root     root            0 Feb  8 11:18 core_uses_pid
-rw-r--r--    1 root     root            0 Feb  8 11:18 ctrl-alt-del
-rw-r--r--    1 root     root            0 Feb  8 11:18 domainname
-rw-r--r--    1 root     root            0 Feb  8 11:18 hostname
-rw-r--r--    1 root     root            0 Feb  8 11:18 hotplug
-rw-r--r--    1 root     root            0 Feb  8 11:18 maps_protect
-rw-r--r--    1 root     root            0 Feb  8 11:18 modprobe
-rw-r--r--    1 root     root            0 Feb  8 11:18 msgmax
-rw-r--r--    1 root     root            0 Feb  8 11:18 msgmnb
-rw-r--r--    1 root     root            0 Feb  8 11:18 msgmni
-r--r--r--    1 root     root            0 Feb  8 11:17 ngroups_max
-r--r--r--    1 root     root            0 Feb  8 11:18 osrelease
-r--r--r--    1 root     root            0 Feb  8 11:18 ostype
-rw-r--r--    1 root     root            0 Feb  8 11:18 overflowgid
-rw-r--r--    1 root     root            0 Feb  8 11:18 overflowuid
-rw-r--r--    1 root     root            0 Feb  8 11:18 panic
-rw-r--r--    1 root     root            0 Feb  8 11:18 panic_on_oops
-rw-r--r--    1 root     root            0 Feb  8 11:18 pid_max
-rw-r--r--    1 root     root            0 Feb  8 11:18 poweroff_cmd
-rw-r--r--    1 root     root            0 Feb  8 11:18 print-fatal-signals
-rw-r--r--    1 root     root            0 Feb  8 11:18 printk
-rw-r--r--    1 root     root            0 Feb  8 11:18 printk_ratelimit
-rw-r--r--    1 root     root            0 Feb  8 11:18 printk_ratelimit_burst
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 pty
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 random
-rw-r--r--    1 root     root            0 Feb  8 11:18 randomize_va_space
-rw-r--r--    1 root     root            0 Feb  8 11:18 sched_compat_yield
-rw-r--r--    1 root     root            0 Feb  8 11:18 sem
-rw-r--r--    1 root     root            0 Feb  8 11:18 shmall
-rw-r--r--    1 root     root            0 Feb  8 11:18 shmmax
-rw-r--r--    1 root     root            0 Feb  8 11:18 shmmni
-rw-r--r--    1 root     root            0 Feb  8 11:18 tainted
-rw-r--r--    1 root     root            0 Feb  8 11:18 threads-max
-r--r--r--    1 root     root            0 Feb  8 11:18 version

/proc/sys/kernel/pty:
-rw-r--r--    1 root     root            0 Feb  8 11:18 max
-r--r--r--    1 root     root            0 Feb  8 11:18 nr

/proc/sys/kernel/random:
-r--r--r--    1 root     root            0 Feb  8 11:18 boot_id
-r--r--r--    1 root     root            0 Feb  8 11:18 entropy_avail
-r--r--r--    1 root     root            0 Feb  8 11:18 poolsize
-rw-r--r--    1 root     root            0 Feb  8 11:18 read_wakeup_threshold
-r--r--r--    1 root     root            0 Feb  8 11:18 uuid
-rw-r--r--    1 root     root            0 Feb  8 11:18 write_wakeup_threshold

/proc/sys/net:
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 core
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 ipv4
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 unix

/proc/sys/net/core:
-rw-r--r--    1 root     root            0 Feb  8 11:18 dev_weight
-rw-r--r--    1 root     root            0 Feb  8 11:18 message_burst
-rw-r--r--    1 root     root            0 Feb  8 11:18 message_cost
-rw-r--r--    1 root     root            0 Feb  8 11:18 netdev_budget
-rw-r--r--    1 root     root            0 Feb  8 11:18 netdev_max_backlog
-rw-r--r--    1 root     root            0 Feb  8 11:18 optmem_max
-rw-r--r--    1 root     root            0 Feb  8 11:18 rmem_default
-rw-r--r--    1 root     root            0 Feb  8 11:18 rmem_max
-rw-r--r--    1 root     root            0 Feb  8 11:18 somaxconn
-rw-r--r--    1 root     root            0 Feb  8 11:18 warnings
-rw-r--r--    1 root     root            0 Feb  8 11:18 wmem_default
-rw-r--r--    1 root     root            0 Feb  8 11:18 wmem_max

/proc/sys/net/ipv4:
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 conf
-rw-r--r--    1 root     root            0 Feb  8 11:18 icmp_echo_ignore_all
-rw-r--r--    1 root     root            0 Feb  8 11:18 icmp_echo_ignore_broadcasts
-rw-r--r--    1 root     root            0 Feb  8 11:18 icmp_errors_use_inbound_ifaddr
-rw-r--r--    1 root     root            0 Feb  8 11:18 icmp_ignore_bogus_error_responses
-rw-r--r--    1 root     root            0 Feb  8 11:18 icmp_ratelimit
-rw-r--r--    1 root     root            0 Feb  8 11:18 icmp_ratemask
-rw-r--r--    1 root     root            0 Feb  8 11:18 igmp_max_msf
-rw-r--r--    1 root     root            0 Feb  8 11:18 inet_peer_gc_maxtime
-rw-r--r--    1 root     root            0 Feb  8 11:18 inet_peer_gc_mintime
-rw-r--r--    1 root     root            0 Feb  8 11:18 inet_peer_maxttl
-rw-r--r--    1 root     root            0 Feb  8 11:18 inet_peer_minttl
-rw-r--r--    1 root     root            0 Feb  8 11:18 inet_peer_threshold
-rw-r--r--    1 root     root            0 Feb  8 11:18 ip_default_ttl
-rw-r--r--    1 root     root            0 Feb  8 11:18 ip_dynaddr
-rw-r--r--    1 root     root            0 Feb  8 11:18 ip_forward
-rw-r--r--    1 root     root            0 Feb  8 11:18 ip_local_port_range
-rw-r--r--    1 root     root            0 Feb  8 11:18 ip_no_pmtu_disc
-rw-r--r--    1 root     root            0 Feb  8 11:18 ip_nonlocal_bind
-rw-r--r--    1 root     root            0 Feb  8 11:18 ipfrag_high_thresh
-rw-r--r--    1 root     root            0 Feb  8 11:18 ipfrag_low_thresh
-rw-r--r--    1 root     root            0 Feb  8 11:18 ipfrag_max_dist
-rw-r--r--    1 root     root            0 Feb  8 11:18 ipfrag_secret_interval
-rw-r--r--    1 root     root            0 Feb  8 11:18 ipfrag_time
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 neigh
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 route
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_abc
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_abort_on_overflow
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_adv_win_scale
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_allowed_congestion_control
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_app_win
-r--r--r--    1 root     root            0 Feb  8 11:18 tcp_available_congestion_control
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_base_mss
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_congestion_control
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_dsack
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_ecn
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_fack
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_fin_timeout
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_frto
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_frto_response
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_keepalive_intvl
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_keepalive_probes
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_keepalive_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_low_latency
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_max_orphans
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_max_ssthresh
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_max_syn_backlog
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_max_tw_buckets
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_mem
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_moderate_rcvbuf
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_mtu_probing
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_no_metrics_save
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_orphan_retries
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_reordering
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_retrans_collapse
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_retries1
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_retries2
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_rfc1337
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_rmem
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_sack
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_slow_start_after_idle
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_stdurg
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_syn_retries
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_synack_retries
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_timestamps
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_tso_win_divisor
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_tw_recycle
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_tw_reuse
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_window_scaling
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_wmem
-rw-r--r--    1 root     root            0 Feb  8 11:18 tcp_workaround_signed_windows

/proc/sys/net/ipv4/conf:
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 all
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 default
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 eth0
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 lo

/proc/sys/net/ipv4/conf/all:
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_source_route
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_accept
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_announce
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_ignore
-rw-r--r--    1 root     root            0 Feb  8 11:18 bootp_relay
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_policy
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_xfrm
-rw-r--r--    1 root     root            0 Feb  8 11:18 force_igmp_version
-rw-r--r--    1 root     root            0 Feb  8 11:18 forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 log_martians
-r--r--r--    1 root     root            0 Feb  8 11:18 mc_forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 medium_id
-rw-r--r--    1 root     root            0 Feb  8 11:18 promote_secondaries
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_arp
-rw-r--r--    1 root     root            0 Feb  8 11:18 rp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 secure_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 send_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 shared_media
-rw-r--r--    1 root     root            0 Feb  8 11:18 tag

/proc/sys/net/ipv4/conf/default:
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_source_route
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_accept
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_announce
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_ignore
-rw-r--r--    1 root     root            0 Feb  8 11:18 bootp_relay
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_policy
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_xfrm
-rw-r--r--    1 root     root            0 Feb  8 11:18 force_igmp_version
-rw-r--r--    1 root     root            0 Feb  8 11:18 forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 log_martians
-r--r--r--    1 root     root            0 Feb  8 11:18 mc_forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 medium_id
-rw-r--r--    1 root     root            0 Feb  8 11:18 promote_secondaries
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_arp
-rw-r--r--    1 root     root            0 Feb  8 11:18 rp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 secure_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 send_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 shared_media
-rw-r--r--    1 root     root            0 Feb  8 11:18 tag

/proc/sys/net/ipv4/conf/eth0:
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_source_route
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_accept
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_announce
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_ignore
-rw-r--r--    1 root     root            0 Feb  8 11:18 bootp_relay
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_policy
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_xfrm
-rw-r--r--    1 root     root            0 Feb  8 11:18 force_igmp_version
-rw-r--r--    1 root     root            0 Feb  8 11:18 forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 log_martians
-r--r--r--    1 root     root            0 Feb  8 11:18 mc_forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 medium_id
-rw-r--r--    1 root     root            0 Feb  8 11:18 promote_secondaries
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_arp
-rw-r--r--    1 root     root            0 Feb  8 11:18 rp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 secure_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 send_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 shared_media
-rw-r--r--    1 root     root            0 Feb  8 11:18 tag

/proc/sys/net/ipv4/conf/lo:
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 accept_source_route
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_accept
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_announce
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 arp_ignore
-rw-r--r--    1 root     root            0 Feb  8 11:18 bootp_relay
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_policy
-rw-r--r--    1 root     root            0 Feb  8 11:18 disable_xfrm
-rw-r--r--    1 root     root            0 Feb  8 11:18 force_igmp_version
-rw-r--r--    1 root     root            0 Feb  8 11:18 forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 log_martians
-r--r--r--    1 root     root            0 Feb  8 11:18 mc_forwarding
-rw-r--r--    1 root     root            0 Feb  8 11:18 medium_id
-rw-r--r--    1 root     root            0 Feb  8 11:18 promote_secondaries
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_arp
-rw-r--r--    1 root     root            0 Feb  8 11:18 rp_filter
-rw-r--r--    1 root     root            0 Feb  8 11:18 secure_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 send_redirects
-rw-r--r--    1 root     root            0 Feb  8 11:18 shared_media
-rw-r--r--    1 root     root            0 Feb  8 11:18 tag

/proc/sys/net/ipv4/neigh:
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 default
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 eth0
dr-xr-xr-x    0 root     root            0 Feb  8 11:18 lo

/proc/sys/net/ipv4/neigh/default:
-rw-r--r--    1 root     root            0 Feb  8 11:18 anycast_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 app_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 base_reachable_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 base_reachable_time_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 delay_first_probe_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_interval
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_stale_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_thresh1
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_thresh2
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_thresh3
-rw-r--r--    1 root     root            0 Feb  8 11:18 locktime
-rw-r--r--    1 root     root            0 Feb  8 11:18 mcast_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_qlen
-rw-r--r--    1 root     root            0 Feb  8 11:18 retrans_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 retrans_time_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 ucast_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 unres_qlen

/proc/sys/net/ipv4/neigh/eth0:
-rw-r--r--    1 root     root            0 Feb  8 11:18 anycast_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 app_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 base_reachable_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 base_reachable_time_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 delay_first_probe_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_stale_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 locktime
-rw-r--r--    1 root     root            0 Feb  8 11:18 mcast_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_qlen
-rw-r--r--    1 root     root            0 Feb  8 11:18 retrans_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 retrans_time_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 ucast_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 unres_qlen

/proc/sys/net/ipv4/neigh/lo:
-rw-r--r--    1 root     root            0 Feb  8 11:18 anycast_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 app_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 base_reachable_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 base_reachable_time_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 delay_first_probe_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_stale_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 locktime
-rw-r--r--    1 root     root            0 Feb  8 11:18 mcast_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 proxy_qlen
-rw-r--r--    1 root     root            0 Feb  8 11:18 retrans_time
-rw-r--r--    1 root     root            0 Feb  8 11:18 retrans_time_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 ucast_solicit
-rw-r--r--    1 root     root            0 Feb  8 11:18 unres_qlen

/proc/sys/net/ipv4/route:
-rw-r--r--    1 root     root            0 Feb  8 11:18 error_burst
-rw-r--r--    1 root     root            0 Feb  8 11:18 error_cost
--w-------    1 root     root            0 Feb  8 11:18 flush
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_elasticity
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_interval
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_min_interval
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_min_interval_ms
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_thresh
-rw-r--r--    1 root     root            0 Feb  8 11:18 gc_timeout
-rw-r--r--    1 root     root            0 Feb  8 11:18 max_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 max_size
-rw-r--r--    1 root     root            0 Feb  8 11:18 min_adv_mss
-rw-r--r--    1 root     root            0 Feb  8 11:18 min_delay
-rw-r--r--    1 root     root            0 Feb  8 11:18 min_pmtu
-rw-r--r--    1 root     root            0 Feb  8 11:18 mtu_expires
-rw-r--r--    1 root     root            0 Feb  8 11:18 redirect_load
-rw-r--r--    1 root     root            0 Feb  8 11:18 redirect_number
-rw-r--r--    1 root     root            0 Feb  8 11:18 redirect_silence
-rw-r--r--    1 root     root            0 Feb  8 11:18 secret_interval

/proc/sys/net/unix:
-rw-r--r--    1 root     root            0 Feb  8 11:18 max_dgram_qlen

/proc/sys/vm:
-rw-r--r--    1 root     root            0 Feb  8 11:18 block_dump
-rw-r--r--    1 root     root            0 Feb  8 11:18 dirty_background_ratio
-rw-r--r--    1 root     root            0 Feb  8 11:18 dirty_expire_centisecs
-rw-r--r--    1 root     root            0 Feb  8 11:18 dirty_ratio
-rw-r--r--    1 root     root            0 Feb  8 11:18 dirty_writeback_centisecs
-rw-r--r--    1 root     root            0 Feb  8 11:18 drop_caches
-rw-r--r--    1 root     root            0 Feb  8 11:18 laptop_mode
-rw-r--r--    1 root     root            0 Feb  8 11:18 lowmem_reserve_ratio
-rw-r--r--    1 root     root            0 Feb  8 11:18 max_map_count
-rw-r--r--    1 root     root            0 Feb  8 11:18 min_free_kbytes
-r--r--r--    1 root     root            0 Feb  8 11:18 nr_pdflush_threads
-rw-r--r--    1 root     root            0 Feb  8 11:18 oom_kill_allocating_task
-rw-r--r--    1 root     root            0 Feb  8 11:18 overcommit_memory
-rw-r--r--    1 root     root            0 Feb  8 11:18 overcommit_ratio
-rw-r--r--    1 root     root            0 Feb  8 11:18 page-cluster
-rw-r--r--    1 root     root            0 Feb  8 11:18 panic_on_oom
-rw-r--r--    1 root     root            0 Feb  8 11:18 percpu_pagelist_fraction
-rw-r--r--    1 root     root            0 Feb  8 11:18 swappiness
-rw-r--r--    1 root     root            0 Feb  8 11:18 vfs_cache_pressure
