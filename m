Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXKPLTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXKPLTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbXKPLTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:19:44 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:40558 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbXKPLTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:19:43 -0500
Date: Fri, 16 Nov 2007 06:15:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: even *more* unused CONFIG variables at no extra charge
Message-ID: <alpine.LFD.0.9999.0711160555530.13454@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  due to an embarrassing brain fart on my part, my script to find
unused CONFIG variables in the source tree missed a whole whack of
them.  (FYI, when checking Kconfig variable FUBAR, the fact that the
corresponding reference to CONFIG_FUBAR is being used in a defconfig
file somewhere does *not* count.  *sigh*.)

  so i'll update the wiki page shortly but here's the abridged version
for just the arch/* directories if you want to poke around yourself.
as always, false positives are a distinct possibility.

==== alpha ====
>>>>> ALPHA_CORE_AGP
>>>>> ALPHA_EV7
>>>>> DEBUG_RWLOCK
==== arm ====
>>>>> ARCH_AT91SAM9260_SAM9XE
>>>>> ARCH_CINTEGRATOR
>>>>> ARCH_EBSA285_ADDIN
>>>>> ARCH_IXCDP1100
>>>>> CPU_CP15_MPU
>>>>> DEBUG_ERRORS
>>>>> DEBUG_S3C_PORT
>>>>> H3600_SLEEVE
>>>>> MACH_EP80219
>>>>> MACH_IXDP28X5
>>>>> MACH_S3C2413
>>>>> MACH_SMDK2412
>>>>> MACH_TRIZEPS4_ANY
>>>>> OMAP_MCBSP
>>>>> SMDK2440_CPU2440
>>>>> SMDK2440_CPU2442
==== avr32 ====
>>>>> AP7000_8_BIT_SMC
==== blackfin ====
>>>>> BFIN_ALIVE_LED_DPORT
>>>>> BFIN_ALIVE_LED_PORT
>>>>> BFIN_IDLE_LED_DPORT
>>>>> BFIN_IDLE_LED_PORT
>>>>> LARGE_ALLOCS
>>>>> SCHEDULE_L1
==== cris ====
>>>>> ETRAX_ETHERNET_HW_CSUM
>>>>> ETRAX_ETHERNET_IFACE0
>>>>> ETRAX_ETHERNET_IFACE1
>>>>> ETRAX_IDE_DELAY
>>>>> ETRAX_PA_BUTTON_BITMASK
>>>>> ETRAX_PA_BUTTON_BITMASK
>>>>> ETRAX_SER0_CD_BIT
>>>>> ETRAX_SER0_DSR_BIT
>>>>> ETRAX_SER0_DTR_BIT
>>>>> ETRAX_SER0_RI_BIT
>>>>> ETRAX_SER1_CD_BIT
>>>>> ETRAX_SER1_DSR_BIT
>>>>> ETRAX_SER1_DTR_BIT
>>>>> ETRAX_SER1_RI_BIT
>>>>> ETRAX_SER2_CD_BIT
>>>>> ETRAX_SER2_DSR_BIT
>>>>> ETRAX_SER2_DTR_BIT
>>>>> ETRAX_SER2_RI_BIT
>>>>> ETRAX_SER3_CD_BIT
>>>>> ETRAX_SER3_DSR_BIT
>>>>> ETRAX_SER3_DTR_BIT
>>>>> ETRAX_SER3_RI_BIT
>>>>> ETRAX_SERIAL_PORT1_DMA4_OUT
>>>>> ETRAX_SERIAL_PORT1_DMA5_IN
>>>>> ETRAX_SERIAL_PORT3_DMA8_OUT
>>>>> ETRAX_SERIAL_PORT3_DMA9_IN
>>>>> ETRAX_USB_HOST_PORT1
>>>>> ETRAX_USB_HOST_PORT2
==== frv ====
>>>>> FRV_DEFL_CACHE_DISABLED
>>>>> MB93091_NO_MB
>>>>> UCPAGE_OFFSET_20000000
>>>>> UCPAGE_OFFSET_40000000
>>>>> UCPAGE_OFFSET_60000000
>>>>> UCPAGE_OFFSET_80000000
>>>>> UCPAGE_OFFSET_A0000000
==== h8300 ====
>>>>> UNIX98_PTY_COUNT
==== m32r ====
>>>>> NOHIGHMEM
==== m68k ====
>>>>> ADB_KEYBOARD
>>>>> ATARI_SCC_DMA
>>>>> GVPIOEXT_LP
>>>>> GVPIOEXT_PLIP
>>>>> MAC_ADBKEYCODES
>>>>> MAC_HID
>>>>> WHIPPET_SERIAL
==== m68knommu ====
>>>>> BDM_DISABLE
>>>>> COBRA5329
>>>>> DUMPTOFLASH
>>>>> EMAC_INC
>>>>> RAM16BIT
>>>>> RAM32BIT
>>>>> RAM8BIT
>>>>> ROMFS_FROM_ROM
>>>>> WILDFIREMOD
==== mips ====
>>>>> 64BIT_CONTEXT
>>>>> ACER_PICA_61
>>>>> CPU_SB1_PASS_2_112x
>>>>> CPU_SB1_PASS_2_1250
>>>>> CPU_SB1_PASS_3
>>>>> CPU_SB1_PASS_4
>>>>> DMA_IP32
>>>>> MIPS_DISABLE_OBSOLETE_IDE
>>>>> MIPS_INSANE_LARGE
>>>>> MIPS_MT_DISABLED
>>>>> MIPS_RM9122
>>>>> SIBYTE_BCM1120
>>>>> SIBYTE_BCM1125
>>>>> SIBYTE_BCM1125H
>>>>> SIBYTE_ENABLE_LDT_IF_PCI
==== parisc ====
>>>>> DEBUG_RWLOCK
==== powerpc ====
>>>>> MPC8XXFADS
>>>>> PPC_MPC836x
>>>>> XILINX_VIRTEX_II_PRO
==== ppc ====
>>>>> MPC8XXFADS
>>>>> NONMONARCH_SUPPORT
>>>>> PC_KEYBOARD
>>>>> SPRUCE_BAUD_33M
>>>>> UART1_DFLT_CONSOLE
>>>>> UART1_DFLT_CONSOLE
>>>>> WANT_EARLY_SERIAL
>>>>> WINCEPT
>>>>> XILINX_VIRTEX_II_PRO
==== sh64 ====
>>>>> DEVICE_MEMORY_START
>>>>> FLASH_MEMORY_START
>>>>> HDSP253_LED
>>>>> PCI_BLOCK_START
>>>>> PCIDEVICE_MEMORY_START
==== sparc ====
>>>>> UNIX98_PTY_COUNT
==== um ====
>>>>> DEFCONFIG_LIST
>>>>> STDIO_CONSOLE
==== x86 ====
>>>>> NOHIGHMEM
==== xtensa ====
>>>>> KCORE_ELF
>>>>> XTENSA_ISS_NETWORK
>>>>> XTENSA_UNALIGNED_USER

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
