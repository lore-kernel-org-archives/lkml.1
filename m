Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXHONt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXHONt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXHONtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:49:13 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:56747 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755632AbXHONtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:49:04 -0400
Date: Wed, 15 Aug 2007 15:48:46 +0200
From: Andreas Radke <a.radke@arcor.de>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata drive loosing connection/resetting port
Message-ID: <20070815154846.28b6b462@workstation64.home>
In-Reply-To: <46C29AE8.5070903@gmail.com>
References: <20070813220241.3f4b8df5@workstation64.home>
	<6bffcb0e0708131311k51238bb0l63eeb2fce53e3481@mail.gmail.com>
	<46C180D8.9060005@gmail.com>
	<20070814221928.243949b6@workstation64.home>
	<46C29AE8.5070903@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_+VLyjDs9LUDe+GNTZ=vYw5m"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_+VLyjDs9LUDe+GNTZ=vYw5m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Wed, 15 Aug 2007 15:19:20 +0900
schrieb Tejun Heo <htejun@gmail.com>:

> Can you post full boot log and the result of 'lspci -nn'?

attached one logfile for ICH9R in AHCI mode and one for IDE mode. 

[root@workstation64 andyrtr]# lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Unknown device [8086:29c0] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation Unknown device [8086:29c1] (rev 02)
00:1a.0 USB Controller [0c03]: Intel Corporation Unknown device [8086:2937] (rev 02)
00:1a.1 USB Controller [0c03]: Intel Corporation Unknown device [8086:2938] (rev 02)
00:1a.2 USB Controller [0c03]: Intel Corporation Unknown device [8086:2939] (rev 02)
00:1a.7 USB Controller [0c03]: Intel Corporation Unknown device [8086:293c] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation Unknown device [8086:2940] (rev 02)
00:1c.4 PCI bridge [0604]: Intel Corporation Unknown device [8086:2948] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation Unknown device [8086:2934] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation Unknown device [8086:2935] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation Unknown device [8086:2936] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation Unknown device [8086:293a] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 92)
00:1f.0 ISA bridge [0601]: Intel Corporation Unknown device [8086:2916] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation Unknown device [8086:2920] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation Unknown device [8086:2930] (rev 02)
00:1f.5 IDE interface [0101]: Intel Corporation Unknown device [8086:2926] (rev 02)
01:00.0 VGA compatible controller [0300]: nVidia Corporation NV44 [GeForce 6200 TurboCache(TM)] [10de:0161] (rev a1)
03:00.0 SATA controller [0106]: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller [197b:2363] (rev 02)
03:00.1 IDE interface [0101]: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller [197b:2363] (rev 02)
04:01.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8169SC Gigabit Ethernet [10ec:8167] (rev 10)
04:02.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) [104c:8023]
04:03.0 Network controller [0280]: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / Technisat SkyStar2 DVB card [13d0:2103] (rev 02)
04:05.0 Multimedia audio controller [0401]: Creative Labs SB Audigy [1102:0004] (rev 03)
04:05.1 Input device controller [0980]: Creative Labs SB Audigy Game Port [1102:7003] (rev 03)
04:05.2 FireWire (IEEE 1394) [0c00]: Creative Labs SB Audigy FireWire Port [1102:4001]


anything else? i'm thinking about changing the mainboard sata drive combination back.
but to fix it would be the better way.

Andy
--MP_+VLyjDs9LUDe+GNTZ=vYw5m
Content-Type: text/x-log; name=ahci.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ahci.log

Aug 13 17:23:18 workstation64 syslog-ng[6162]: syslog-ng starting up; version='2.0.5'
Aug 13 17:23:18 workstation64 Linux version 2.6.22-ARCH (root@artin) (gcc version 4.2.1) #1 SMP PREEMPT Sun Aug 12 17:44:17 CEST 2007
Aug 13 17:23:18 workstation64 Command line: root=/dev/sda2 ro vga=794
Aug 13 17:23:18 workstation64 BIOS-provided physical RAM map:
Aug 13 17:23:18 workstation64 BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
Aug 13 17:23:18 workstation64 BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
Aug 13 17:23:18 workstation64 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Aug 13 17:23:18 workstation64 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
Aug 13 17:23:18 workstation64 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
Aug 13 17:23:18 workstation64 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
Aug 13 17:23:18 workstation64 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
Aug 13 17:23:18 workstation64 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Aug 13 17:23:18 workstation64 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Aug 13 17:23:18 workstation64 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Aug 13 17:23:18 workstation64 Entering add_active_range(0, 0, 158) 0 entries of 256 used
Aug 13 17:23:18 workstation64 Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Aug 13 17:23:18 workstation64 Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
Aug 13 17:23:18 workstation64 end_pfn_map = 1245184
Aug 13 17:23:18 workstation64 DMI 2.5 present.
Aug 13 17:23:18 workstation64 ACPI: RSDP 000F7800, 0014 (r0 IntelR)
Aug 13 17:23:18 workstation64 ACPI: RSDT CFEE3000, 0034 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Aug 13 17:23:18 workstation64 ACPI: FACP CFEE3080, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Aug 13 17:23:18 workstation64 ACPI: DSDT CFEE3100, 4D0B (r1 INTELR AWRDACPI     1000 MSFT  3000000)
Aug 13 17:23:18 workstation64 ACPI: FACS CFEE0000, 0040
Aug 13 17:23:18 workstation64 ACPI: MCFG CFEE7F00, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Aug 13 17:23:18 workstation64 ACPI: APIC CFEE7E40, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Aug 13 17:23:18 workstation64 ACPI: SSDT CFEE8860, 0380 (r1  PmRef    CpuPm     3000 INTL 20041203)
Aug 13 17:23:18 workstation64 Entering add_active_range(0, 0, 158) 0 entries of 256 used
Aug 13 17:23:18 workstation64 Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Aug 13 17:23:18 workstation64 Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
Aug 13 17:23:18 workstation64 Zone PFN ranges:
Aug 13 17:23:18 workstation64 DMA             0 ->     4096
Aug 13 17:23:18 workstation64 DMA32        4096 ->  1048576
Aug 13 17:23:18 workstation64 Normal    1048576 ->  1245184
Aug 13 17:23:18 workstation64 early_node_map[3] active PFN ranges
Aug 13 17:23:18 workstation64 0:        0 ->      158
Aug 13 17:23:18 workstation64 0:      256 ->   851680
Aug 13 17:23:18 workstation64 0:  1048576 ->  1245184
Aug 13 17:23:18 workstation64 On node 0 totalpages: 1048190
Aug 13 17:23:18 workstation64 DMA zone: 56 pages used for memmap
Aug 13 17:23:18 workstation64 DMA zone: 1131 pages reserved
Aug 13 17:23:18 workstation64 DMA zone: 2811 pages, LIFO batch:0
Aug 13 17:23:18 workstation64 DMA32 zone: 14280 pages used for memmap
Aug 13 17:23:18 workstation64 DMA32 zone: 833304 pages, LIFO batch:31
Aug 13 17:23:18 workstation64 Normal zone: 2688 pages used for memmap
Aug 13 17:23:18 workstation64 Normal zone: 193920 pages, LIFO batch:31
Aug 13 17:23:18 workstation64 ACPI: PM-Timer IO Port: 0x408
Aug 13 17:23:18 workstation64 ACPI: Local APIC address 0xfee00000
Aug 13 17:23:18 workstation64 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Aug 13 17:23:18 workstation64 Processor #0 (Bootup-CPU)
Aug 13 17:23:18 workstation64 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
Aug 13 17:23:18 workstation64 Processor #3
Aug 13 17:23:18 workstation64 ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Aug 13 17:23:18 workstation64 Processor #1
Aug 13 17:23:18 workstation64 ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Aug 13 17:23:18 workstation64 Processor #2
Aug 13 17:23:18 workstation64 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Aug 13 17:23:18 workstation64 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Aug 13 17:23:18 workstation64 ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Aug 13 17:23:18 workstation64 ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Aug 13 17:23:18 workstation64 ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Aug 13 17:23:18 workstation64 IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
Aug 13 17:23:18 workstation64 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Aug 13 17:23:18 workstation64 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Aug 13 17:23:18 workstation64 ACPI: IRQ0 used by override.
Aug 13 17:23:18 workstation64 ACPI: IRQ2 used by override.
Aug 13 17:23:18 workstation64 ACPI: IRQ9 used by override.
Aug 13 17:23:18 workstation64 Setting APIC routing to flat
Aug 13 17:23:18 workstation64 Using ACPI (MADT) for SMP configuration information
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000cfee0000 - 00000000cfee3000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000cfee3000 - 00000000cfef0000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000cfef0000 - 00000000cff00000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000cff00000 - 00000000e0000000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
Aug 13 17:23:18 workstation64 swsusp: Registered nosave memory region: 00000000fec00000 - 0000000100000000
Aug 13 17:23:18 workstation64 Allocating PCI resources starting at d0000000 (gap: cff00000:10100000)
Aug 13 17:23:18 workstation64 SMP: Allowing 4 CPUs, 0 hotplug CPUs
Aug 13 17:23:18 workstation64 PERCPU: Allocating 33800 bytes of per cpu data
Aug 13 17:23:18 workstation64 Built 1 zonelists.  Total pages: 1030035
Aug 13 17:23:18 workstation64 Kernel command line: root=/dev/sda2 ro vga=794
Aug 13 17:23:18 workstation64 Initializing CPU#0
Aug 13 17:23:18 workstation64 PID hash table entries: 4096 (order: 12, 32768 bytes)
Aug 13 17:23:18 workstation64 time.c: Detected 3375.077 MHz processor.
Aug 13 17:23:18 workstation64 Console: colour dummy device 80x25
Aug 13 17:23:18 workstation64 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Aug 13 17:23:18 workstation64 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Aug 13 17:23:18 workstation64 Checking aperture...
Aug 13 17:23:18 workstation64 Calgary: detecting Calgary via BIOS EBDA area
Aug 13 17:23:18 workstation64 Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Aug 13 17:23:18 workstation64 PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Aug 13 17:23:18 workstation64 Placing software IO TLB between 0x58d0000 - 0x98d0000
Aug 13 17:23:18 workstation64 Memory: 4046820k/4980736k available (2695k kernel code, 145528k reserved, 1008k data, 248k init)
Aug 13 17:23:18 workstation64 Calibrating delay using timer specific routine.. 6755.41 BogoMIPS (lpj=11255069)
Aug 13 17:23:18 workstation64 Security Framework v1.0.0 initialized
Aug 13 17:23:18 workstation64 Mount-cache hash table entries: 256
Aug 13 17:23:18 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 13 17:23:18 workstation64 CPU: L2 cache: 4096K
Aug 13 17:23:18 workstation64 using mwait in idle threads.
Aug 13 17:23:18 workstation64 CPU: Physical Processor ID: 0
Aug 13 17:23:18 workstation64 CPU: Processor Core ID: 0
Aug 13 17:23:18 workstation64 CPU0: Thermal monitoring enabled (TM1)
Aug 13 17:23:18 workstation64 SMP alternatives: switching to UP code
Aug 13 17:23:18 workstation64 Early unpacking initramfs... done
Aug 13 17:23:18 workstation64 ACPI: Core revision 20070126
Aug 13 17:23:18 workstation64 ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
Aug 13 17:23:18 workstation64 Using local APIC timer interrupts.
Aug 13 17:23:18 workstation64 result 23438017
Aug 13 17:23:18 workstation64 Detected 23.438 MHz APIC timer.
Aug 13 17:23:18 workstation64 SMP alternatives: switching to SMP code
Aug 13 17:23:18 workstation64 Booting processor 1/4 APIC 0x3
Aug 13 17:23:18 workstation64 Initializing CPU#1
Aug 13 17:23:18 workstation64 Calibrating delay using timer specific routine.. 6752.88 BogoMIPS (lpj=11249416)
Aug 13 17:23:18 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 13 17:23:18 workstation64 CPU: L2 cache: 4096K
Aug 13 17:23:18 workstation64 CPU: Physical Processor ID: 0
Aug 13 17:23:18 workstation64 CPU: Processor Core ID: 3
Aug 13 17:23:18 workstation64 CPU1: Thermal monitoring enabled (TM1)
Aug 13 17:23:18 workstation64 Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Aug 13 17:23:18 workstation64 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Aug 13 17:23:18 workstation64 SMP alternatives: switching to SMP code
Aug 13 17:23:18 workstation64 Booting processor 2/4 APIC 0x1
Aug 13 17:23:18 workstation64 Initializing CPU#2
Aug 13 17:23:18 workstation64 Calibrating delay using timer specific routine.. 6752.90 BogoMIPS (lpj=11249451)
Aug 13 17:23:18 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 13 17:23:18 workstation64 CPU: L2 cache: 4096K
Aug 13 17:23:18 workstation64 CPU: Physical Processor ID: 0
Aug 13 17:23:18 workstation64 CPU: Processor Core ID: 1
Aug 13 17:23:18 workstation64 CPU2: Thermal monitoring enabled (TM1)
Aug 13 17:23:18 workstation64 Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Aug 13 17:23:18 workstation64 checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Aug 13 17:23:18 workstation64 SMP alternatives: switching to SMP code
Aug 13 17:23:18 workstation64 Booting processor 3/4 APIC 0x2
Aug 13 17:23:18 workstation64 Initializing CPU#3
Aug 13 17:23:18 workstation64 Calibrating delay using timer specific routine.. 6752.87 BogoMIPS (lpj=11249395)
Aug 13 17:23:18 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 13 17:23:18 workstation64 CPU: L2 cache: 4096K
Aug 13 17:23:18 workstation64 CPU: Physical Processor ID: 0
Aug 13 17:23:18 workstation64 CPU: Processor Core ID: 2
Aug 13 17:23:18 workstation64 CPU3: Thermal monitoring enabled (TM1)
Aug 13 17:23:18 workstation64 Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Aug 13 17:23:18 workstation64 checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Aug 13 17:23:18 workstation64 Brought up 4 CPUs
Aug 13 17:23:18 workstation64 migration_cost=14,2216
Aug 13 17:23:18 workstation64 NET: Registered protocol family 16
Aug 13 17:23:18 workstation64 ACPI: bus type pci registered
Aug 13 17:23:18 workstation64 PCI: Using MMCONFIG at e0000000 - efffffff
Aug 13 17:23:18 workstation64 ACPI: Interpreter enabled
Aug 13 17:23:18 workstation64 ACPI: (supports S0 S3 S4 S5)
Aug 13 17:23:18 workstation64 ACPI: Using IOAPIC for interrupt routing
Aug 13 17:23:18 workstation64 ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 13 17:23:18 workstation64 PCI: Probing PCI hardware (bus 00)
Aug 13 17:23:18 workstation64 PCI: Transparent bridge - 0000:00:1e.0
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 9 *10 11 12)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 9 10 11 12) *0, disabled.
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 9 *10 11 12)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 9 10 *11 12)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 *7 9 10 11 12)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNKF] (IRQs *4 5 7 9 10 11 12)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNK0] (IRQs 4 *5 7 9 10 11 12)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt Link [LNK1] (IRQs 4 5 7 9 10 *11 12)
Aug 13 17:23:18 workstation64 Linux Plug and Play Support v0.97 (c) Adam Belay
Aug 13 17:23:18 workstation64 pnp: PnP ACPI init
Aug 13 17:23:18 workstation64 ACPI: bus type pnp registered
Aug 13 17:23:18 workstation64 pnp: PnP ACPI: found 11 devices
Aug 13 17:23:18 workstation64 ACPI: ACPI bus type pnp unregistered
Aug 13 17:23:18 workstation64 SCSI subsystem initialized
Aug 13 17:23:18 workstation64 PCI: Using ACPI for IRQ routing
Aug 13 17:23:18 workstation64 PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Aug 13 17:23:18 workstation64 NetLabel: Initializing
Aug 13 17:23:18 workstation64 NetLabel:  domain hash size = 128
Aug 13 17:23:18 workstation64 NetLabel:  protocols = UNLABELED CIPSOv4
Aug 13 17:23:18 workstation64 NetLabel:  unlabeled traffic allowed by default
Aug 13 17:23:18 workstation64 PCI-GART: No AMD northbridge found.
Aug 13 17:23:18 workstation64 ACPI: RTC can wake from S4
Aug 13 17:23:18 workstation64 pnp: 00:06: ioport range 0x400-0x4bf has been reserved
Aug 13 17:23:18 workstation64 pnp: 00:09: iomem range 0xe0000000-0xefffffff could not be reserved
Aug 13 17:23:18 workstation64 pnp: 00:0a: iomem range 0xf0000-0xfffff could not be reserved
Aug 13 17:23:18 workstation64 pnp: 00:0a: iomem range 0xcff00000-0xcfffffff has been reserved
Aug 13 17:23:18 workstation64 pnp: 00:0a: iomem range 0xcfee0000-0xcfefffff could not be reserved
Aug 13 17:23:18 workstation64 pnp: 00:0a: iomem range 0x0-0x9ffff could not be reserved
Aug 13 17:23:18 workstation64 PCI: Bridge: 0000:00:01.0
Aug 13 17:23:18 workstation64 IO window: d000-dfff
Aug 13 17:23:18 workstation64 MEM window: fa000000-fcffffff
Aug 13 17:23:18 workstation64 PREFETCH window: d0000000-dfffffff
Aug 13 17:23:18 workstation64 PCI: Bridge: 0000:00:1c.0
Aug 13 17:23:18 workstation64 IO window: c000-cfff
Aug 13 17:23:18 workstation64 MEM window: fde00000-fdefffff
Aug 13 17:23:18 workstation64 PREFETCH window: fdb00000-fdbfffff
Aug 13 17:23:18 workstation64 PCI: Bridge: 0000:00:1c.4
Aug 13 17:23:18 workstation64 IO window: b000-bfff
Aug 13 17:23:18 workstation64 MEM window: fda00000-fdafffff
Aug 13 17:23:18 workstation64 PREFETCH window: fd900000-fd9fffff
Aug 13 17:23:18 workstation64 PCI: Bridge: 0000:00:1e.0
Aug 13 17:23:18 workstation64 IO window: a000-afff
Aug 13 17:23:18 workstation64 MEM window: fdd00000-fddfffff
Aug 13 17:23:18 workstation64 PREFETCH window: fdc00000-fdcfffff
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:01.0 to 64
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1c.0 to 64
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1c.4 to 64
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1e.0 to 64
Aug 13 17:23:18 workstation64 NET: Registered protocol family 2
Aug 13 17:23:18 workstation64 Time: tsc clocksource has been installed.
Aug 13 17:23:18 workstation64 IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Aug 13 17:23:18 workstation64 TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
Aug 13 17:23:18 workstation64 TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Aug 13 17:23:18 workstation64 TCP: Hash tables configured (established 131072 bind 65536)
Aug 13 17:23:18 workstation64 TCP reno registered
Aug 13 17:23:18 workstation64 checking if image is initramfs... it is
Aug 13 17:23:18 workstation64 Freeing initrd memory: 547k freed
Aug 13 17:23:18 workstation64 VFS: Disk quotas dquot_6.5.1
Aug 13 17:23:18 workstation64 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Aug 13 17:23:18 workstation64 Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Aug 13 17:23:18 workstation64 io scheduler noop registered
Aug 13 17:23:18 workstation64 io scheduler anticipatory registered
Aug 13 17:23:18 workstation64 io scheduler deadline registered
Aug 13 17:23:18 workstation64 io scheduler cfq registered (default)
Aug 13 17:23:18 workstation64 Boot video device is 0000:01:00.0
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:01.0 to 64
Aug 13 17:23:18 workstation64 assign_interrupt_mode Found MSI capability
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:01.0:pcie00]
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:01.0:pcie03]
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1c.0 to 64
Aug 13 17:23:18 workstation64 assign_interrupt_mode Found MSI capability
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:1c.0:pcie00]
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:1c.0:pcie02]
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:1c.0:pcie03]
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1c.4 to 64
Aug 13 17:23:18 workstation64 assign_interrupt_mode Found MSI capability
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:1c.4:pcie00]
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:1c.4:pcie02]
Aug 13 17:23:18 workstation64 Allocate Port Service[0000:00:1c.4:pcie03]
Aug 13 17:23:18 workstation64 vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20010100000, using 5120k, total 131072k
Aug 13 17:23:18 workstation64 vesafb: mode is 1280x1024x16, linelength=2560, pages=1
Aug 13 17:23:18 workstation64 vesafb: scrolling: redraw
Aug 13 17:23:18 workstation64 vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Aug 13 17:23:18 workstation64 Console: switching to colour frame buffer device 160x64
Aug 13 17:23:18 workstation64 fb0: VESA VGA frame buffer device
Aug 13 17:23:18 workstation64 Real Time Clock Driver v1.12ac
Aug 13 17:23:18 workstation64 Linux agpgart interface v0.102 (c) Dave Jones
Aug 13 17:23:18 workstation64 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Aug 13 17:23:18 workstation64 RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Aug 13 17:23:18 workstation64 loop: module loaded
Aug 13 17:23:18 workstation64 input: Macintosh mouse button emulation as /class/input/input0
Aug 13 17:23:18 workstation64 PNP: No PS/2 controller found. Probing ports directly.
Aug 13 17:23:18 workstation64 serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 13 17:23:18 workstation64 serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 13 17:23:18 workstation64 mice: PS/2 mouse device common for all mice
Aug 13 17:23:18 workstation64 TCP cubic registered
Aug 13 17:23:18 workstation64 NET: Registered protocol family 1
Aug 13 17:23:18 workstation64 NET: Registered protocol family 17
Aug 13 17:23:18 workstation64 Freeing unused kernel memory: 248k freed
Aug 13 17:23:18 workstation64 libata version 2.21 loaded.
Aug 13 17:23:18 workstation64 ahci 0000:00:1f.2: version 2.2
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
Aug 13 17:23:18 workstation64 ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Aug 13 17:23:18 workstation64 ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1f.2 to 64
Aug 13 17:23:18 workstation64 scsi0 : ahci
Aug 13 17:23:18 workstation64 scsi1 : ahci
Aug 13 17:23:18 workstation64 scsi2 : ahci
Aug 13 17:23:18 workstation64 scsi3 : ahci
Aug 13 17:23:18 workstation64 scsi4 : ahci
Aug 13 17:23:18 workstation64 scsi5 : ahci
Aug 13 17:23:18 workstation64 ata1: SATA max UDMA/133 cmd 0xffffc2000000c100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
Aug 13 17:23:18 workstation64 ata2: SATA max UDMA/133 cmd 0xffffc2000000c180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
Aug 13 17:23:18 workstation64 ata3: SATA max UDMA/133 cmd 0xffffc2000000c200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
Aug 13 17:23:18 workstation64 ata4: SATA max UDMA/133 cmd 0xffffc2000000c280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
Aug 13 17:23:18 workstation64 ata5: SATA max UDMA/133 cmd 0xffffc2000000c300 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
Aug 13 17:23:18 workstation64 ata6: SATA max UDMA/133 cmd 0xffffc2000000c380 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
Aug 13 17:23:18 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 17:23:18 workstation64 ata1.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
Aug 13 17:23:18 workstation64 ata1.00: 145226112 sectors, multi 0: LBA48 NCQ (not used)
Aug 13 17:23:18 workstation64 ata1.00: configured for UDMA/133
Aug 13 17:23:18 workstation64 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 13 17:23:18 workstation64 ata2.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
Aug 13 17:23:18 workstation64 ata2.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
Aug 13 17:23:18 workstation64 ata2.00: configured for UDMA/133
Aug 13 17:23:18 workstation64 ata3: SATA link down (SStatus 0 SControl 300)
Aug 13 17:23:18 workstation64 ata4: SATA link down (SStatus 0 SControl 300)
Aug 13 17:23:18 workstation64 ata5: SATA link down (SStatus 0 SControl 300)
Aug 13 17:23:18 workstation64 ata6: SATA link down (SStatus 0 SControl 300)
Aug 13 17:23:18 workstation64 scsi 0:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
Aug 13 17:23:18 workstation64 scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Aug 13 17:23:18 workstation64 ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
Aug 13 17:23:18 workstation64 ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:03:00.0 to 64
Aug 13 17:23:18 workstation64 scsi6 : ahci
Aug 13 17:23:18 workstation64 scsi7 : ahci
Aug 13 17:23:18 workstation64 ata7: SATA max UDMA/133 cmd 0xffffc20000010100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
Aug 13 17:23:18 workstation64 ata8: SATA max UDMA/133 cmd 0xffffc20000010180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
Aug 13 17:23:18 workstation64 ata7: SATA link down (SStatus 0 SControl 300)
Aug 13 17:23:18 workstation64 ata8: SATA link down (SStatus 0 SControl 300)
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:23:18 workstation64 sda: sda1 sda2 sda3
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Attached SCSI disk
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Write Protect is off
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Write Protect is off
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:23:18 workstation64 sdb: sdb1
Aug 13 17:23:18 workstation64 sd 1:0:0:0: [sdb] Attached SCSI disk
Aug 13 17:23:18 workstation64 ReiserFS: sda2: found reiserfs format "3.6" with standard journal
Aug 13 17:23:18 workstation64 ReiserFS: sda2: using ordered data mode
Aug 13 17:23:18 workstation64 ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 13 17:23:18 workstation64 ReiserFS: sda2: checking transaction log (sda2)
Aug 13 17:23:18 workstation64 ReiserFS: sda2: replayed 116 transactions in 1 seconds
Aug 13 17:23:18 workstation64 ReiserFS: sda2: Using r5 hash to sort names
Aug 13 17:23:18 workstation64 usbcore: registered new interface driver usbfs
Aug 13 17:23:18 workstation64 usbcore: registered new interface driver hub
Aug 13 17:23:18 workstation64 usbcore: registered new device driver usb
Aug 13 17:23:18 workstation64 coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
Aug 13 17:23:18 workstation64 coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
Aug 13 17:23:18 workstation64 coretemp coretemp.2: Using undocumented features, absolute temperature might be wrong!
Aug 13 17:23:18 workstation64 coretemp coretemp.3: Using undocumented features, absolute temperature might be wrong!
Aug 13 17:23:18 workstation64 input: Power Button (FF) as /class/input/input1
Aug 13 17:23:18 workstation64 ACPI: Power Button (FF) [PWRF]
Aug 13 17:23:18 workstation64 input: Power Button (CM) as /class/input/input2
Aug 13 17:23:18 workstation64 ACPI: Power Button (CM) [PWRB]
Aug 13 17:23:18 workstation64 ACPI: SSDT CFEE7F80, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
Aug 13 17:23:18 workstation64 ACPI: SSDT CFEE8440, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
Aug 13 17:23:18 workstation64 ACPI: SSDT CFEE85A0, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 20041203)
Aug 13 17:23:18 workstation64 ACPI: SSDT CFEE8700, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20041203)
Aug 13 17:23:18 workstation64 ACPI Error (dswstate-0226): No result objects! State=ffff81012f884400 [20070126]
Aug 13 17:23:18 workstation64 ACPI Exception (dsutils-0642): AE_AML_NO_RETURN_VALUE, Missing or null operand [20070126]
Aug 13 17:23:18 workstation64 ACPI Exception (dsutils-0735): AE_AML_NO_RETURN_VALUE, While creating Arg 1 [20070126]
Aug 13 17:23:18 workstation64 ACPI Error (psparse-0537): Method parse/execution failed [\_TZ_.THRM._TMP] (Node ffff81012fe20750), AE_AML_NO_RETURN_VALUE
Aug 13 17:23:18 workstation64 USB Universal Host Controller Interface driver v3.0
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1a.0 to 64
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.0: UHCI Host Controller
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
Aug 13 17:23:18 workstation64 usb usb1: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 1-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 1-0:1.0: 2 ports detected
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1a.1 to 64
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.1: UHCI Host Controller
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
Aug 13 17:23:18 workstation64 usb usb2: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 2-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 2-0:1.0: 2 ports detected
Aug 13 17:23:18 workstation64 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Aug 13 17:23:18 workstation64 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Aug 13 17:23:18 workstation64 rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Aug 13 17:23:18 workstation64 rtc_cmos: probe of 00:03 failed with error -16
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1a.2[D] -> GSI 19 (level, low) -> IRQ 19
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1a.2 to 64
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.2: UHCI Host Controller
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fd00
Aug 13 17:23:18 workstation64 usb usb3: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 3-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 3-0:1.0: 2 ports detected
Aug 13 17:23:18 workstation64 input: PC Speaker as /class/input/input3
Aug 13 17:23:18 workstation64 b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1d.0 to 64
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.0: UHCI Host Controller
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
Aug 13 17:23:18 workstation64 usb usb4: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 4-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 4-0:1.0: 2 ports detected
Aug 13 17:23:18 workstation64 usb 1-1: new full speed USB device using uhci_hcd and address 2
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1d.1 to 64
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.1: UHCI Host Controller
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
Aug 13 17:23:18 workstation64 usb usb5: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 5-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 5-0:1.0: 2 ports detected
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1d.2 to 64
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.2: UHCI Host Controller
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
Aug 13 17:23:18 workstation64 uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
Aug 13 17:23:18 workstation64 usb usb6: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 6-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 6-0:1.0: 2 ports detected
Aug 13 17:23:18 workstation64 usb 1-1: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1a.7 to 64
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1a.7: EHCI Host Controller
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
Aug 13 17:23:18 workstation64 PCI: cache line size of 32 is not supported by device 0000:00:1a.7
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Aug 13 17:23:18 workstation64 usb usb7: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 7-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 7-0:1.0: 6 ports detected
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 21 (level, low) -> IRQ 21
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:04:02.0 to 64
Aug 13 17:23:18 workstation64 JMB363: IDE controller at PCI slot 0000:03:00.1
Aug 13 17:23:18 workstation64 PCI: Enabling device 0000:03:00.1 (0000 -> 0001)
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
Aug 13 17:23:18 workstation64 JMB363: chipset revision 2
Aug 13 17:23:18 workstation64 JMB363: 100% native mode on irq 17
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:03:00.1 to 64
Aug 13 17:23:18 workstation64 ide0: BM-DMA at 0xbb00-0xbb07, BIOS settings: hda:pio, hdb:pio
Aug 13 17:23:18 workstation64 ide1: BM-DMA at 0xbb08-0xbb0f, BIOS settings: hdc:pio, hdd:pio
Aug 13 17:23:18 workstation64 Probing IDE interface ide0...
Aug 13 17:23:18 workstation64 gameport: EMU10K1 is pci0000:04:05.1/gameport0, io 0xad00, speed 1041kHz
Aug 13 17:23:18 workstation64 ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[fddfe000-fddfe7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:04:05.2[B] -> GSI 21 (level, low) -> IRQ 21
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1f.3[B] -> <7>PCI: Setting latency timer of device 0000:04:05.2 to 64
Aug 13 17:23:18 workstation64 GSI 18 (level, low) -> IRQ 18
Aug 13 17:23:18 workstation64 ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[fddfd000-fddfd7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Aug 13 17:23:18 workstation64 hda: HDS722525VLAT80, ATA DISK drive
Aug 13 17:23:18 workstation64 hdb: HL-DT-ST DVDRAM GSA-4160B, ATAPI CD/DVD-ROM drive
Aug 13 17:23:18 workstation64 usb 1-1: USB disconnect, address 2
Aug 13 17:23:18 workstation64 hda: selected mode 0x45
Aug 13 17:23:18 workstation64 hdb: selected mode 0x44
Aug 13 17:23:18 workstation64 ide0 at 0xbf00-0xbf07,0xbe02 on irq 17
Aug 13 17:23:18 workstation64 Probing IDE interface ide1...
Aug 13 17:23:18 workstation64 usb 1-1: new full speed USB device using uhci_hcd and address 3
Aug 13 17:23:18 workstation64 usb 1-1: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:00:1d.7 to 64
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1d.7: EHCI Host Controller
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
Aug 13 17:23:18 workstation64 PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
Aug 13 17:23:18 workstation64 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Aug 13 17:23:18 workstation64 usb usb8: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 hub 8-0:1.0: USB hub found
Aug 13 17:23:18 workstation64 hub 8-0:1.0: 6 ports detected
Aug 13 17:23:18 workstation64 ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00508d000099f7ea]
Aug 13 17:23:18 workstation64 r8169 Gigabit Ethernet driver 2.2LK loaded
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22 (level, low) -> IRQ 22
Aug 13 17:23:18 workstation64 eth0: RTL8169sc/8110sc at 0xffffc20000054000, 00:50:8d:9f:9a:05, IRQ 22
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 20
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:04:05.0 to 64
Aug 13 17:23:18 workstation64 usb 2-1: new low speed USB device using uhci_hcd and address 2
Aug 13 17:23:18 workstation64 flexcop-pci: will use the HW PID filter.
Aug 13 17:23:18 workstation64 flexcop-pci: card revision 2
Aug 13 17:23:18 workstation64 ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 22 (level, low) -> IRQ 22
Aug 13 17:23:18 workstation64 PCI: Setting latency timer of device 0000:04:03.0 to 64
Aug 13 17:23:18 workstation64 DVB: registering new adapter (FlexCop Digital TV device).
Aug 13 17:23:18 workstation64 b2c2-flexcop: MAC address = 00:d0:d7:0d:0d:9e
Aug 13 17:23:18 workstation64 Linux video capture interface: v2.00
Aug 13 17:23:18 workstation64 ieee1394: The root node is not cycle master capable; selecting a new root node and resetting...
Aug 13 17:23:18 workstation64 usb 2-1: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 b2c2-flexcop: found the stv0299 at i2c address: 0x68
Aug 13 17:23:18 workstation64 DVB: registering frontend 0 (ST STV0299 DVB-S)...
Aug 13 17:23:18 workstation64 b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
Aug 13 17:23:18 workstation64 hda: max request size: 512KiB
Aug 13 17:23:18 workstation64 hda: Host Protected Area detected.
Aug 13 17:23:18 workstation64 	current capacity is 488395055 sectors (250058 MB)
Aug 13 17:23:18 workstation64 	native  capacity is 488397168 sectors (250059 MB)
Aug 13 17:23:18 workstation64 hda: Host Protected Area disabled.
Aug 13 17:23:18 workstation64 hda: 488397168 sectors (250059 MB) w/7938KiB Cache, CHS=30401/255/63, UDMA(100)
Aug 13 17:23:18 workstation64 hda: cache flushes supported
Aug 13 17:23:18 workstation64 hda: hda1
Aug 13 17:23:18 workstation64 hdb: ATAPI 40X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(66)
Aug 13 17:23:18 workstation64 Uniform CD-ROM driver Revision: 3.20
Aug 13 17:23:18 workstation64 usb 2-2: new low speed USB device using uhci_hcd and address 3
Aug 13 17:23:18 workstation64 ieee1394: Host added: ID:BUS[1-01:1023]  GUID[00023c0021039053]
Aug 13 17:23:18 workstation64 usb 2-2: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 usb 2-1: USB disconnect, address 2
Aug 13 17:23:18 workstation64 drivers/media/video/stv680.c: [stv680_probe:1422] STV(i): STV0680 camera found.
Aug 13 17:23:18 workstation64 drivers/media/video/stv680.c: [stv680_probe:1462] STV(i): registered new video device: video0
Aug 13 17:23:18 workstation64 usbcore: registered new interface driver stv680
Aug 13 17:23:18 workstation64 drivers/media/video/stv680.c: [usb_stv680_init:1543] STV(i): usb camera driver version v0.25 registering
Aug 13 17:23:18 workstation64 drivers/media/video/stv680.c: STV0680 USB Camera Driver v0.25
Aug 13 17:23:18 workstation64 usbcore: registered new interface driver hiddev
Aug 13 17:23:18 workstation64 input: Logitech USB RECEIVER as /class/input/input4
Aug 13 17:23:18 workstation64 input: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1a.1-2
Aug 13 17:23:18 workstation64 usbcore: registered new interface driver usbhid
Aug 13 17:23:18 workstation64 drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Aug 13 17:23:18 workstation64 usb 2-1: new low speed USB device using uhci_hcd and address 4
Aug 13 17:23:18 workstation64 usb 2-1: configuration #1 chosen from 1 choice
Aug 13 17:23:18 workstation64 input: Microsoft Comfort Curve Keyboard 2000 as /class/input/input5
Aug 13 17:23:18 workstation64 input: USB HID v1.11 Keyboard [Microsoft Comfort Curve Keyboard 2000] on usb-0000:00:1a.1-1
Aug 13 17:23:18 workstation64 input: Microsoft Comfort Curve Keyboard 2000 as /class/input/input6
Aug 13 17:23:18 workstation64 input: USB HID v1.11 Device [Microsoft Comfort Curve Keyboard 2000] on usb-0000:00:1a.1-1
Aug 13 17:23:18 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 17:23:18 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 17:23:18 workstation64 ata1.00: cmd ca/00:08:38:33:0f/00:00:00:00:00/e6 tag 0 cdb 0x0 data 4096 out
Aug 13 17:23:18 workstation64 res 50/00:00:ef:af:1f/00:00:00:00:00/e8 Emask 0x10 (ATA bus error)
Aug 13 17:23:18 workstation64 ata1: soft resetting port
Aug 13 17:23:18 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 17:23:18 workstation64 ata1.00: configured for UDMA/133
Aug 13 17:23:18 workstation64 ata1: EH complete
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:23:18 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:23:18 workstation64 ReiserFS: sda2: Removing [7282282 7282121 0x0 SD]..done
Aug 13 17:23:18 workstation64 ReiserFS: sda2: Removing [7143704 7144671 0x0 SD]..done
Aug 13 17:23:18 workstation64 ReiserFS: sda2: Removing [2 7206 0x0 SD]..done
Aug 13 17:23:18 workstation64 ReiserFS: sda2: Removing [2 5708 0x0 SD]..done
Aug 13 17:23:18 workstation64 ReiserFS: sda2: There were 4 uncompleted unlinks/truncates. Completed
Aug 13 17:23:18 workstation64 ReiserFS: sda3: found reiserfs format "3.6" with standard journal
Aug 13 17:23:18 workstation64 ReiserFS: sda3: using ordered data mode
Aug 13 17:23:18 workstation64 ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 13 17:23:18 workstation64 ReiserFS: sda3: checking transaction log (sda3)
Aug 13 17:23:18 workstation64 ReiserFS: sda3: Using r5 hash to sort names
Aug 13 17:23:18 workstation64 ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
Aug 13 17:23:18 workstation64 ReiserFS: sdb1: using ordered data mode
Aug 13 17:23:18 workstation64 ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 13 17:23:18 workstation64 ReiserFS: sdb1: checking transaction log (sdb1)
Aug 13 17:23:18 workstation64 ReiserFS: sdb1: Using r5 hash to sort names
Aug 13 17:23:18 workstation64 Adding 2000052k swap on /dev/sda1.  Priority:-1 extents:1 across:2000052k
Aug 13 17:23:18 workstation64 r8169: eth0: link up
Aug 13 17:23:18 workstation64 ntpd[6200]: ntpd 4.2.4p3@1.1502-o Tue Jul  3 17:33:51 UTC 2007 (1)
Aug 13 17:23:18 workstation64 ntpd[6205]: precision = 1.000 usec
Aug 13 17:23:18 workstation64 NET: Registered protocol family 10
Aug 13 17:23:18 workstation64 lo: Disabled Privacy Extensions
Aug 13 17:23:18 workstation64 Mobile IPv6
Aug 13 17:23:18 workstation64 ntpd[6205]: ntp_io: estimated max descriptors: 1024, initial socket boundary: 16
Aug 13 17:23:18 workstation64 ntpd[6205]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
Aug 13 17:23:18 workstation64 ntpd[6205]: Listening on interface #1 wildcard, ::#123 Disabled
Aug 13 17:23:18 workstation64 ntpd[6205]: Listening on interface #2 lo, ::1#123 Enabled
Aug 13 17:23:18 workstation64 ntpd[6205]: bind() fd 19, family 10, port 123, scope 2, addr fe80::250:8dff:fe9f:9a05, in6_is_addr_multicast=0 flags=0x11 fails: Cannot assign requested address
Aug 13 17:23:18 workstation64 ntpd[6205]: unable to create socket on eth0 (3) for fe80::250:8dff:fe9f:9a05#123
Aug 13 17:23:18 workstation64 ntpd[6205]: failed to initialize interface for address fe80::250:8dff:fe9f:9a05
Aug 13 17:23:18 workstation64 ntpd[6205]: Listening on interface #4 lo, 127.0.0.1#123 Enabled
Aug 13 17:23:18 workstation64 ntpd[6205]: Listening on interface #5 eth0, 192.168.0.2#123 Enabled
Aug 13 17:23:18 workstation64 ntpd[6205]: kernel time sync status 0040
Aug 13 17:23:19 workstation64 ntpd[6205]: frequency initialized 90.799 PPM from /var/lib/ntp/ntp.drift
Aug 13 17:23:19 workstation64 ntpd[6205]: bind() fd 21, family 10, port 123, scope 2, addr fe80::250:8dff:fe9f:9a05, in6_is_addr_multicast=0 flags=0x11 fails: Cannot assign requested address
Aug 13 17:23:19 workstation64 ntpd[6205]: unable to create socket on eth0 (6) for fe80::250:8dff:fe9f:9a05#123
Aug 13 17:23:19 workstation64 ntpd[6205]: failed to initialize interface for address fe80::250:8dff:fe9f:9a05
Aug 13 17:23:21 workstation64 acpid: starting up
Aug 13 17:23:21 workstation64 acpid: 1 rule loaded
Aug 13 17:23:22 workstation64 acpid: client connected from 6303[82:82]
Aug 13 17:23:22 workstation64 acpid: 1 client rule loaded
Aug 13 17:23:22 workstation64 clamd[6335]: clamd daemon 0.91.1 (OS: linux-gnu, ARCH: x86_64, CPU: x86_64)
Aug 13 17:23:22 workstation64 clamd[6335]: Running as user clamav (UID 64, GID 64)
Aug 13 17:23:22 workstation64 clamd[6335]: Log file size limited to 2097152 bytes.
Aug 13 17:23:22 workstation64 clamd[6335]: Reading databases from /var/lib/clamav
Aug 13 17:23:23 workstation64 postfix/postfix-script[6377]: starting the Postfix mail system
Aug 13 17:23:23 workstation64 clamd[6335]: Loaded 145915 signatures.
Aug 13 17:23:23 workstation64 clamd[6335]: Socket file /var/lib/clamav/clamd.sock exists. Unclean shutdown? Removing...
Aug 13 17:23:23 workstation64 clamd[6335]: Unix socket file /var/lib/clamav/clamd.sock
Aug 13 17:23:23 workstation64 clamd[6335]: Setting connection queue length to 15
Aug 13 17:23:23 workstation64 clamd[6335]: Archive: Archived file size limit set to 524288000 bytes.
Aug 13 17:23:23 workstation64 clamd[6335]: Archive: Recursion level limit set to 8.
Aug 13 17:23:23 workstation64 clamd[6335]: Archive: Files limit set to 1000.
Aug 13 17:23:23 workstation64 clamd[6335]: Archive: Compression ratio limit set to 250.
Aug 13 17:23:23 workstation64 clamd[6335]: Archive support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: Algorithmic detection enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: Portable Executable support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: ELF support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: Mail files support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: Mail: Recursion level limit set to 64.
Aug 13 17:23:23 workstation64 clamd[6335]: OLE2 support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: PDF support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: HTML support enabled.
Aug 13 17:23:23 workstation64 clamd[6335]: Self checking every 1800 seconds.
Aug 13 17:23:23 workstation64 postfix/master[6378]: daemon started -- version 2.4.3, configuration /etc/postfix
Aug 13 17:23:23 workstation64 freshclam[6383]: freshclam daemon 0.91.1 (OS: linux-gnu, ARCH: x86_64, CPU: x86_64)
Aug 13 17:23:23 workstation64 freshclam[6383]: ClamAV update process started at Mon Aug 13 17:23:23 2007
Aug 13 17:23:23 workstation64 freshclam[6383]: main.inc is up to date (version: 44, sigs: 133163, f-level: 20, builder: sven)
Aug 13 17:23:24 workstation64 freshclam[6383]: Downloading daily-3945.cdiff [100%]
Aug 13 17:23:24 workstation64 freshclam[6383]: Downloading daily-3946.cdiff [100%]
Aug 13 17:23:24 workstation64 freshclam[6383]: daily.inc updated (version: 3946, sigs: 12761, f-level: 20, builder: ccordes)
Aug 13 17:23:24 workstation64 freshclam[6383]: Database updated (145924 signatures) from database.clamav.net (IP: 217.160.141.39)
Aug 13 17:23:24 workstation64 freshclam[6383]: Clamd successfully notified about the update.
Aug 13 17:23:24 workstation64 freshclam[6383]: --------------------------------------
Aug 13 17:23:24 workstation64 acpid: client connected from 6408[0:0]
Aug 13 17:23:24 workstation64 acpid: 1 client rule loaded
Aug 13 17:23:25 workstation64 nvidia: module license 'NVIDIA' taints kernel.
Aug 13 17:23:25 workstation64 ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Aug 13 17:23:25 workstation64 PCI: Setting latency timer of device 0000:01:00.0 to 64
Aug 13 17:23:25 workstation64 NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13 16:33:22 PDT 2007
Aug 13 17:23:26 workstation64 acpid: client connected from 6408[0:0]
Aug 13 17:23:26 workstation64 acpid: 1 client rule loaded
Aug 13 17:23:27 workstation64 drivers/media/video/stv680.c: [stv_init:374] STV(i): CIF is supported
Aug 13 17:23:27 workstation64 drivers/media/video/stv680.c: [stv_init:392] STV(i): Camera has 0 pictures.
Aug 13 17:23:27 workstation64 drivers/media/video/stv680.c: [stv_init:419] STV(i): Video Mode set to CIF
Aug 13 17:23:28 workstation64 drivers/media/video/stv680.c: [stv_stop_video:247] STV(e): Stop_video: problem setting original mode
Aug 13 17:23:28 workstation64 eth0: no IPv6 routers present
Aug 13 17:26:32 workstation64 ntpd[6205]: synchronized to 212.82.32.26, stratum 2
Aug 13 17:26:32 workstation64 ntpd[6205]: kernel time sync status change 0001
Aug 13 17:28:19 workstation64 ntpd[6205]: Listening on interface #7 eth0, fe80::250:8dff:fe9f:9a05#123 Enabled
Aug 13 17:33:18 workstation64 syslog-ng[6162]: Log statistics; processed='center(queued)=2312', processed='center(received)=607', processed='destination(console)=0', processed='destination(mail)=11', processed='destination(user)=0', processed='destination(uucp)=0', processed='destination(messages)=510', processed='destination(news)=0', processed='destination(iptables)=0', processed='destination(everything)=603', processed='destination(lpr)=0', processed='destination(cron)=0', processed='destination(syslog)=1', processed='destination(authlog)=4', processed='destination(errors)=7', processed='destination(kernel)=542', processed='destination(daemon)=27', processed='destination(console_all)=607', processed='source(src)=607'
Aug 13 17:36:05 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 17:36:05 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 17:36:05 workstation64 ata1.00: cmd 35/00:08:a9:ea:3d/00:02:00:00:00/e0 tag 0 cdb 0x0 data 266240 out
Aug 13 17:36:05 workstation64 res 50/00:00:67:ac:0f/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
Aug 13 17:36:05 workstation64 ata1: soft resetting port
Aug 13 17:36:05 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 17:36:05 workstation64 ata1.00: configured for UDMA/133
Aug 13 17:36:05 workstation64 ata1: EH complete
Aug 13 17:36:05 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:36:05 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:36:05 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:36:05 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:37:23 workstation64 ntpd[6205]: synchronized to 141.82.30.251, stratum 2
Aug 13 17:42:34 workstation64 ntpd[6205]: synchronized to 212.82.32.26, stratum 2
Aug 13 17:43:18 workstation64 syslog-ng[6162]: Log statistics; processed='center(queued)=2370', processed='center(received)=622', processed='destination(console)=0', processed='destination(mail)=11', processed='destination(user)=0', processed='destination(uucp)=0', processed='destination(messages)=520', processed='destination(news)=0', processed='destination(iptables)=0', processed='destination(everything)=618', processed='destination(lpr)=0', processed='destination(cron)=0', processed='destination(syslog)=2', processed='destination(authlog)=4', processed='destination(errors)=10', processed='destination(kernel)=554', processed='destination(daemon)=29', processed='destination(console_all)=622', processed='source(src)=622'
Aug 13 17:48:43 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 17:48:43 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 17:48:43 workstation64 ata1.00: cmd ca/00:f8:98:f0:0f/00:00:00:00:00/e6 tag 0 cdb 0x0 data 126976 out
Aug 13 17:48:43 workstation64 res 50/00:00:0f:94:17/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
Aug 13 17:48:43 workstation64 ata1: soft resetting port
Aug 13 17:48:43 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 17:48:43 workstation64 ata1.00: configured for UDMA/133
Aug 13 17:48:43 workstation64 ata1: EH complete
Aug 13 17:48:43 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:48:43 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:48:43 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:48:43 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:50:18 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 17:50:18 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 17:50:18 workstation64 ata1.00: cmd 35/00:00:f0:1e:10/00:04:06:00:00/e0 tag 0 cdb 0x0 data 524288 out
Aug 13 17:50:18 workstation64 res 50/00:00:37:c1:c3/00:00:00:00:00/e7 Emask 0x10 (ATA bus error)
Aug 13 17:50:19 workstation64 ata1: soft resetting port
Aug 13 17:50:19 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 17:50:19 workstation64 ata1.00: configured for UDMA/133
Aug 13 17:50:19 workstation64 ata1: EH complete
Aug 13 17:50:19 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:50:19 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:50:19 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:50:19 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:50:24 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 17:50:24 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 17:50:24 workstation64 ata1.00: cmd ca/00:10:91:a6:6d/00:00:00:00:00/e1 tag 0 cdb 0x0 data 8192 out
Aug 13 17:50:24 workstation64 res 50/00:00:88:a6:6d/00:00:00:00:00/e1 Emask 0x10 (ATA bus error)
Aug 13 17:50:24 workstation64 ata1: soft resetting port
Aug 13 17:50:24 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 17:50:24 workstation64 ata1.00: configured for UDMA/133
Aug 13 17:50:24 workstation64 ata1: EH complete
Aug 13 17:50:24 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 17:50:24 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 17:50:24 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 17:50:24 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 17:53:18 workstation64 syslog-ng[6162]: Log statistics; processed='center(queued)=2514', processed='center(received)=659', processed='destination(console)=0', processed='destination(mail)=11', processed='destination(user)=0', processed='destination(uucp)=0', processed='destination(messages)=544', processed='destination(news)=0', processed='destination(iptables)=0', processed='destination(everything)=655', processed='destination(lpr)=0', processed='destination(cron)=0', processed='destination(syslog)=3', processed='destination(authlog)=4', processed='destination(errors)=19', processed='destination(kernel)=590', processed='destination(daemon)=29', processed='destination(console_all)=659', processed='source(src)=659'
Aug 13 18:00:33 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400101 action 0x2 frozen
Aug 13 18:00:33 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 18:00:33 workstation64 ata1.00: cmd ca/00:08:a0:cb:07/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Aug 13 18:00:33 workstation64 res 50/00:00:bf:32:07/00:00:00:00:00/e8 Emask 0x10 (ATA bus error)
Aug 13 18:00:33 workstation64 ata1: soft resetting port
Aug 13 18:00:33 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 18:00:33 workstation64 ata1.00: configured for UDMA/133
Aug 13 18:00:33 workstation64 ata1: EH complete
Aug 13 18:00:33 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 18:00:33 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 18:00:33 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 18:00:33 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 18:03:18 workstation64 syslog-ng[6162]: Log statistics; processed='center(queued)=2564', processed='center(received)=672', processed='destination(console)=0', processed='destination(mail)=11', processed='destination(user)=0', processed='destination(uucp)=0', processed='destination(messages)=552', processed='destination(news)=0', processed='destination(iptables)=0', processed='destination(everything)=668', processed='destination(lpr)=0', processed='destination(cron)=0', processed='destination(syslog)=4', processed='destination(authlog)=4', processed='destination(errors)=22', processed='destination(kernel)=602', processed='destination(daemon)=29', processed='destination(console_all)=672', processed='source(src)=672'
Aug 13 18:12:03 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 18:12:03 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 18:12:03 workstation64 ata1.00: cmd ca/00:08:d1:09:b9/00:00:00:00:00/e4 tag 0 cdb 0x0 data 4096 out
Aug 13 18:12:03 workstation64 res 50/00:00:78:8d:a5/00:00:00:00:00/e4 Emask 0x10 (ATA bus error)
Aug 13 18:12:04 workstation64 ata1: soft resetting port
Aug 13 18:12:04 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 18:12:04 workstation64 ata1.00: configured for UDMA/133
Aug 13 18:12:04 workstation64 ata1: EH complete
Aug 13 18:12:04 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 18:12:04 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 18:12:04 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 18:12:04 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 18:12:09 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 18:12:09 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 18:12:09 workstation64 ata1.00: cmd 35/00:50:58:80:a5/00:03:07:00:00/e0 tag 0 cdb 0x0 data 434176 out
Aug 13 18:12:09 workstation64 res 50/00:00:ef:7f:a5/00:00:00:00:00/e7 Emask 0x10 (ATA bus error)
Aug 13 18:12:09 workstation64 ata1: soft resetting port
Aug 13 18:12:10 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 18:12:10 workstation64 ata1.00: configured for UDMA/133
Aug 13 18:12:10 workstation64 ata1: EH complete
Aug 13 18:12:10 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 18:12:10 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 18:12:10 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 18:12:10 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 18:12:10 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 18:12:10 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 18:12:10 workstation64 ata1.00: cmd 35/00:00:10:50:90/00:04:08:00:00/e0 tag 0 cdb 0x0 data 524288 out
Aug 13 18:12:10 workstation64 res 50/00:00:cf:0c:5e/00:00:00:00:00/e8 Emask 0x10 (ATA bus error)
Aug 13 18:12:10 workstation64 ata1: soft resetting port
Aug 13 18:12:11 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 18:12:11 workstation64 ata1.00: configured for UDMA/133
Aug 13 18:12:11 workstation64 ata1: EH complete
Aug 13 18:12:11 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 18:12:11 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 18:12:11 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 18:12:11 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 18:13:18 workstation64 syslog-ng[6162]: Log statistics; processed='center(queued)=2708', processed='center(received)=709', processed='destination(console)=0', processed='destination(mail)=11', processed='destination(user)=0', processed='destination(uucp)=0', processed='destination(messages)=576', processed='destination(news)=0', processed='destination(iptables)=0', processed='destination(everything)=705', processed='destination(lpr)=0', processed='destination(cron)=0', processed='destination(syslog)=5', processed='destination(authlog)=4', processed='destination(errors)=31', processed='destination(kernel)=638', processed='destination(daemon)=29', processed='destination(console_all)=709', processed='source(src)=709'
Aug 13 18:14:01 workstation64 ata1.00: limiting speed to UDMA/100:PIO4
Aug 13 18:14:01 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 18:14:01 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 18:14:01 workstation64 ata1.00: cmd 35/00:c8:59:41:3d/00:01:00:00:00/e0 tag 0 cdb 0x0 data 233472 out
Aug 13 18:14:01 workstation64 res 50/00:00:47:47:68/00:00:00:00:00/e8 Emask 0x10 (ATA bus error)
Aug 13 18:14:01 workstation64 ata1: soft resetting port
Aug 13 18:14:01 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 18:14:01 workstation64 ata1.00: configured for UDMA/100
Aug 13 18:14:01 workstation64 ata1: EH complete
Aug 13 18:14:01 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 18:14:01 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 18:14:01 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 18:14:01 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 13 18:17:19 workstation64 ntpd[6205]: synchronized to 141.82.30.251, stratum 2
Aug 13 18:17:21 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x2 frozen
Aug 13 18:17:21 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
Aug 13 18:17:21 workstation64 ata1.00: cmd ca/00:10:61:3b:6d/00:00:00:00:00/e1 tag 0 cdb 0x0 data 8192 out
Aug 13 18:17:21 workstation64 res 50/00:00:48:12:6d/00:00:00:00:00/e1 Emask 0x10 (ATA bus error)
Aug 13 18:17:22 workstation64 ata1: soft resetting port
Aug 13 18:17:22 workstation64 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 13 18:17:22 workstation64 ata1.00: configured for UDMA/100
Aug 13 18:17:22 workstation64 ata1: EH complete
Aug 13 18:17:22 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
Aug 13 18:17:22 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 13 18:17:22 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 13 18:17:22 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--MP_+VLyjDs9LUDe+GNTZ=vYw5m
Content-Type: text/x-log; name=ide_ck.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=ide_ck.log

Aug 14 22:51:08 workstation64 syslog-ng[6304]: syslog-ng starting up; versi=
on=3D'2.0.5'
Aug 14 22:51:08 workstation64 Linux version 2.6.22-ck (root@workstation64) =
(gcc version 4.2.1) #1 SMP PREEMPT Sat Aug 11 06:11:16 UTC 2007
Aug 14 22:51:08 workstation64 Command line: root=3D/dev/sda2 ro vga=3D794=20
Aug 14 22:51:08 workstation64 BIOS-provided physical RAM map:
Aug 14 22:51:08 workstation64 BIOS-e820: 0000000000000000 - 000000000009f40=
0 (usable)
Aug 14 22:51:08 workstation64 BIOS-e820: 000000000009f400 - 00000000000a000=
0 (reserved)
Aug 14 22:51:08 workstation64 BIOS-e820: 00000000000f0000 - 000000000010000=
0 (reserved)
Aug 14 22:51:08 workstation64 BIOS-e820: 0000000000100000 - 00000000cfee000=
0 (usable)
Aug 14 22:51:08 workstation64 BIOS-e820: 00000000cfee0000 - 00000000cfee300=
0 (ACPI NVS)
Aug 14 22:51:08 workstation64 BIOS-e820: 00000000cfee3000 - 00000000cfef000=
0 (ACPI data)
Aug 14 22:51:08 workstation64 BIOS-e820: 00000000cfef0000 - 00000000cff0000=
0 (reserved)
Aug 14 22:51:08 workstation64 BIOS-e820: 00000000e0000000 - 00000000f000000=
0 (reserved)
Aug 14 22:51:08 workstation64 BIOS-e820: 00000000fec00000 - 000000010000000=
0 (reserved)
Aug 14 22:51:08 workstation64 BIOS-e820: 0000000100000000 - 000000013000000=
0 (usable)
Aug 14 22:51:08 workstation64 Entering add_active_range(0, 0, 159) 0 entrie=
s of 256 used
Aug 14 22:51:08 workstation64 Entering add_active_range(0, 256, 851680) 1 e=
ntries of 256 used
Aug 14 22:51:08 workstation64 Entering add_active_range(0, 1048576, 1245184=
) 2 entries of 256 used
Aug 14 22:51:08 workstation64 end_pfn_map =3D 1245184
Aug 14 22:51:08 workstation64 DMI 2.5 present.
Aug 14 22:51:08 workstation64 ACPI: RSDP 000F7800, 0014 (r0 IntelR)
Aug 14 22:51:08 workstation64 ACPI: RSDT CFEE3000, 0034 (r1 IntelR AWRDACPI=
 42302E31 AWRD        0)
Aug 14 22:51:08 workstation64 ACPI: FACP CFEE3080, 0074 (r1 IntelR AWRDACPI=
 42302E31 AWRD        0)
Aug 14 22:51:08 workstation64 ACPI: DSDT CFEE3100, 4D0B (r1 INTELR AWRDACPI=
     1000 MSFT  3000000)
Aug 14 22:51:08 workstation64 ACPI: FACS CFEE0000, 0040
Aug 14 22:51:08 workstation64 ACPI: MCFG CFEE7F00, 003C (r1 IntelR AWRDACPI=
 42302E31 AWRD        0)
Aug 14 22:51:08 workstation64 ACPI: APIC CFEE7E40, 0084 (r1 IntelR AWRDACPI=
 42302E31 AWRD        0)
Aug 14 22:51:08 workstation64 ACPI: SSDT CFEE8860, 0380 (r1  PmRef    CpuPm=
     3000 INTL 20041203)
Aug 14 22:51:08 workstation64 Entering add_active_range(0, 0, 159) 0 entrie=
s of 256 used
Aug 14 22:51:08 workstation64 Entering add_active_range(0, 256, 851680) 1 e=
ntries of 256 used
Aug 14 22:51:08 workstation64 Entering add_active_range(0, 1048576, 1245184=
) 2 entries of 256 used
Aug 14 22:51:08 workstation64 Zone PFN ranges:
Aug 14 22:51:08 workstation64 DMA             0 ->     4096
Aug 14 22:51:08 workstation64 DMA32        4096 ->  1048576
Aug 14 22:51:08 workstation64 Normal    1048576 ->  1245184
Aug 14 22:51:08 workstation64 early_node_map[3] active PFN ranges
Aug 14 22:51:08 workstation64 0:        0 ->      159
Aug 14 22:51:08 workstation64 0:      256 ->   851680
Aug 14 22:51:08 workstation64 0:  1048576 ->  1245184
Aug 14 22:51:08 workstation64 On node 0 totalpages: 1048191
Aug 14 22:51:08 workstation64 DMA zone: 56 pages used for memmap
Aug 14 22:51:08 workstation64 DMA zone: 1144 pages reserved
Aug 14 22:51:08 workstation64 DMA zone: 2799 pages, LIFO batch:0
Aug 14 22:51:08 workstation64 DMA32 zone: 14280 pages used for memmap
Aug 14 22:51:08 workstation64 DMA32 zone: 833304 pages, LIFO batch:31
Aug 14 22:51:08 workstation64 Normal zone: 2688 pages used for memmap
Aug 14 22:51:08 workstation64 Normal zone: 193920 pages, LIFO batch:31
Aug 14 22:51:08 workstation64 ACPI: PM-Timer IO Port: 0x408
Aug 14 22:51:08 workstation64 ACPI: Local APIC address 0xfee00000
Aug 14 22:51:08 workstation64 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] ena=
bled)
Aug 14 22:51:08 workstation64 Processor #0 (Bootup-CPU)
Aug 14 22:51:08 workstation64 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] ena=
bled)
Aug 14 22:51:08 workstation64 Processor #1
Aug 14 22:51:08 workstation64 ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] ena=
bled)
Aug 14 22:51:08 workstation64 Processor #3
Aug 14 22:51:08 workstation64 ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] ena=
bled)
Aug 14 22:51:08 workstation64 Processor #2
Aug 14 22:51:08 workstation64 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint=
[0x1])
Aug 14 22:51:08 workstation64 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint=
[0x1])
Aug 14 22:51:08 workstation64 ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint=
[0x1])
Aug 14 22:51:08 workstation64 ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint=
[0x1])
Aug 14 22:51:08 workstation64 ACPI: IOAPIC (id[0x04] address[0xfec00000] gs=
i_base[0])
Aug 14 22:51:08 workstation64 IOAPIC[0]: apic_id 4, address 0xfec00000, GSI=
 0-23
Aug 14 22:51:08 workstation64 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq=
 2 dfl dfl)
Aug 14 22:51:08 workstation64 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq=
 9 high level)
Aug 14 22:51:08 workstation64 ACPI: IRQ0 used by override.
Aug 14 22:51:08 workstation64 ACPI: IRQ2 used by override.
Aug 14 22:51:08 workstation64 ACPI: IRQ9 used by override.
Aug 14 22:51:08 workstation64 Setting APIC routing to flat
Aug 14 22:51:08 workstation64 Using ACPI (MADT) for SMP configuration infor=
mation
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
00000009f000 - 00000000000a0000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000000a0000 - 00000000000f0000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000000f0000 - 0000000000100000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000cfee0000 - 00000000cfee3000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000cfee3000 - 00000000cfef0000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000cfef0000 - 00000000cff00000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000cff00000 - 00000000e0000000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000e0000000 - 00000000f0000000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000f0000000 - 00000000fec00000
Aug 14 22:51:08 workstation64 swsusp: Registered nosave memory region: 0000=
0000fec00000 - 0000000100000000
Aug 14 22:51:08 workstation64 Allocating PCI resources starting at d0000000=
 (gap: cff00000:10100000)
Aug 14 22:51:08 workstation64 SMP: Allowing 4 CPUs, 0 hotplug CPUs
Aug 14 22:51:08 workstation64 PERCPU: Allocating 34184 bytes of per cpu data
Aug 14 22:51:08 workstation64 Built 1 zonelists.  Total pages: 1030023
Aug 14 22:51:08 workstation64 Kernel command line: root=3D/dev/sda2 ro vga=
=3D794=20
Aug 14 22:51:08 workstation64 Initializing CPU#0
Aug 14 22:51:08 workstation64 PID hash table entries: 4096 (order: 12, 3276=
8 bytes)
Aug 14 22:51:08 workstation64 time.c: Detected 3375.045 MHz processor.
Aug 14 22:51:08 workstation64 Console: colour dummy device 80x25
Aug 14 22:51:08 workstation64 Dentry cache hash table entries: 524288 (orde=
r: 10, 4194304 bytes)
Aug 14 22:51:08 workstation64 Inode-cache hash table entries: 262144 (order=
: 9, 2097152 bytes)
Aug 14 22:51:08 workstation64 Checking aperture...
Aug 14 22:51:08 workstation64 Calgary: detecting Calgary via BIOS EBDA area
Aug 14 22:51:08 workstation64 Calgary: Unable to locate Rio Grande table in=
 EBDA - bailing!
Aug 14 22:51:08 workstation64 PCI-DMA: Using software bounce buffering for =
IO (SWIOTLB)
Aug 14 22:51:08 workstation64 Placing software IO TLB between 0x58d0000 - 0=
x98d0000
Aug 14 22:51:08 workstation64 Memory: 4046772k/4980736k available (2728k ke=
rnel code, 145672k reserved, 1021k data, 248k init)
Aug 14 22:51:08 workstation64 SLUB: Genslabs=3D22, HWalign=3D64, Order=3D0-=
1, MinObjects=3D4, CPUs=3D4, Nodes=3D1
Aug 14 22:51:08 workstation64 Calibrating delay using timer specific routin=
e.. 6752.45 BogoMIPS (lpj=3D3376229)
Aug 14 22:51:08 workstation64 Security Framework v1.0.0 initialized
Aug 14 22:51:08 workstation64 Mount-cache hash table entries: 256
Aug 14 22:51:08 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 14 22:51:08 workstation64 CPU: L2 cache: 4096K
Aug 14 22:51:08 workstation64 using mwait in idle threads.
Aug 14 22:51:08 workstation64 CPU: Physical Processor ID: 0
Aug 14 22:51:08 workstation64 CPU: Processor Core ID: 0
Aug 14 22:51:08 workstation64 CPU0: Thermal monitoring enabled (TM1)
Aug 14 22:51:08 workstation64 SMP alternatives: switching to UP code
Aug 14 22:51:08 workstation64 Early unpacking initramfs... done
Aug 14 22:51:08 workstation64 ACPI: Core revision 20070126
Aug 14 22:51:08 workstation64 ACPI: Looking for DSDT in initramfs... error,=
 file /DSDT.aml not found.
Aug 14 22:51:08 workstation64 Using local APIC timer interrupts.
Aug 14 22:51:08 workstation64 result 23437812
Aug 14 22:51:08 workstation64 Detected 23.437 MHz APIC timer.
Aug 14 22:51:08 workstation64 SMP alternatives: switching to SMP code
Aug 14 22:51:08 workstation64 Booting processor 1/4 APIC 0x1
Aug 14 22:51:08 workstation64 Initializing CPU#1
Aug 14 22:51:08 workstation64 Calibrating delay using timer specific routin=
e.. 6749.05 BogoMIPS (lpj=3D3374527)
Aug 14 22:51:08 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 14 22:51:08 workstation64 CPU: L2 cache: 4096K
Aug 14 22:51:08 workstation64 CPU: Physical Processor ID: 0
Aug 14 22:51:08 workstation64 CPU: Processor Core ID: 1
Aug 14 22:51:08 workstation64 CPU1: Thermal monitoring enabled (TM1)
Aug 14 22:51:08 workstation64 Intel(R) Core(TM)2 Quad CPU           @ 2.40G=
Hz stepping 07
Aug 14 22:51:08 workstation64 checking TSC synchronization [CPU#0 -> CPU#1]=
: passed.
Aug 14 22:51:08 workstation64 SMP alternatives: switching to SMP code
Aug 14 22:51:08 workstation64 Booting processor 2/4 APIC 0x3
Aug 14 22:51:08 workstation64 Initializing CPU#2
Aug 14 22:51:08 workstation64 Calibrating delay using timer specific routin=
e.. 6749.14 BogoMIPS (lpj=3D3374574)
Aug 14 22:51:08 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 14 22:51:08 workstation64 CPU: L2 cache: 4096K
Aug 14 22:51:08 workstation64 CPU: Physical Processor ID: 0
Aug 14 22:51:08 workstation64 CPU: Processor Core ID: 3
Aug 14 22:51:08 workstation64 CPU2: Thermal monitoring enabled (TM1)
Aug 14 22:51:08 workstation64 Intel(R) Core(TM)2 Quad CPU           @ 2.40G=
Hz stepping 07
Aug 14 22:51:08 workstation64 checking TSC synchronization [CPU#0 -> CPU#2]=
: passed.
Aug 14 22:51:08 workstation64 SMP alternatives: switching to SMP code
Aug 14 22:51:08 workstation64 Booting processor 3/4 APIC 0x2
Aug 14 22:51:08 workstation64 Initializing CPU#3
Aug 14 22:51:08 workstation64 Calibrating delay using timer specific routin=
e.. 6749.04 BogoMIPS (lpj=3D3374523)
Aug 14 22:51:08 workstation64 CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 14 22:51:08 workstation64 CPU: L2 cache: 4096K
Aug 14 22:51:08 workstation64 CPU: Physical Processor ID: 0
Aug 14 22:51:08 workstation64 CPU: Processor Core ID: 2
Aug 14 22:51:08 workstation64 CPU3: Thermal monitoring enabled (TM1)
Aug 14 22:51:08 workstation64 Intel(R) Core(TM)2 Quad CPU           @ 2.40G=
Hz stepping 07
Aug 14 22:51:08 workstation64 checking TSC synchronization [CPU#0 -> CPU#3]=
: passed.
Aug 14 22:51:08 workstation64 Brought up 4 CPUs
Aug 14 22:51:08 workstation64 migration_cost=3D12,2217
Aug 14 22:51:08 workstation64 NET: Registered protocol family 16
Aug 14 22:51:08 workstation64 ACPI: bus type pci registered
Aug 14 22:51:08 workstation64 PCI: Using MMCONFIG at e0000000 - efffffff
Aug 14 22:51:08 workstation64 ACPI: Interpreter enabled
Aug 14 22:51:08 workstation64 ACPI: (supports S0 S3 S4 S5)
Aug 14 22:51:08 workstation64 ACPI: Using IOAPIC for interrupt routing
Aug 14 22:51:08 workstation64 ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 14 22:51:08 workstation64 PCI: Probing PCI hardware (bus 00)
Aug 14 22:51:08 workstation64 PCI: Transparent bridge - 0000:00:1e.0
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0=
._PRT]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0=
.PEX0._PRT]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0=
.PEX4._PRT]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0=
.HUB0._PRT]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 9=
 *10 11 12)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 9=
 10 11 12) *0, disabled.
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 9=
 *10 11 12)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 9=
 10 *11 12)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 *7 =
9 10 11 12)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNKF] (IRQs *4 5 7 =
9 10 11 12)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNK0] (IRQs 4 *5 7 =
9 10 11 12)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt Link [LNK1] (IRQs 4 5 7 9=
 10 *11 12)
Aug 14 22:51:08 workstation64 Linux Plug and Play Support v0.97 (c) Adam Be=
lay
Aug 14 22:51:08 workstation64 pnp: PnP ACPI init
Aug 14 22:51:08 workstation64 ACPI: bus type pnp registered
Aug 14 22:51:08 workstation64 pnp: PnP ACPI: found 11 devices
Aug 14 22:51:08 workstation64 ACPI: ACPI bus type pnp unregistered
Aug 14 22:51:08 workstation64 SCSI subsystem initialized
Aug 14 22:51:08 workstation64 PCI: Using ACPI for IRQ routing
Aug 14 22:51:08 workstation64 PCI: If a device doesn't work, try "pci=3Drou=
teirq".  If it helps, post a report
Aug 14 22:51:08 workstation64 NetLabel: Initializing
Aug 14 22:51:08 workstation64 NetLabel:  domain hash size =3D 128
Aug 14 22:51:08 workstation64 NetLabel:  protocols =3D UNLABELED CIPSOv4
Aug 14 22:51:08 workstation64 NetLabel:  unlabeled traffic allowed by defau=
lt
Aug 14 22:51:08 workstation64 PCI-GART: No AMD northbridge found.
Aug 14 22:51:08 workstation64 ACPI: RTC can wake from S4
Aug 14 22:51:08 workstation64 pnp: 00:06: ioport range 0x400-0x4bf has been=
 reserved
Aug 14 22:51:08 workstation64 pnp: 00:09: iomem range 0xe0000000-0xefffffff=
 could not be reserved
Aug 14 22:51:08 workstation64 pnp: 00:0a: iomem range 0xf0000-0xfffff could=
 not be reserved
Aug 14 22:51:08 workstation64 pnp: 00:0a: iomem range 0xcff00000-0xcfffffff=
 has been reserved
Aug 14 22:51:08 workstation64 pnp: 00:0a: iomem range 0xcfee0000-0xcfefffff=
 could not be reserved
Aug 14 22:51:08 workstation64 pnp: 00:0a: iomem range 0x0-0x9ffff could not=
 be reserved
Aug 14 22:51:08 workstation64 PCI: Bridge: 0000:00:01.0
Aug 14 22:51:08 workstation64 IO window: a000-afff
Aug 14 22:51:08 workstation64 MEM window: fa000000-fcffffff
Aug 14 22:51:08 workstation64 PREFETCH window: d0000000-dfffffff
Aug 14 22:51:08 workstation64 PCI: Bridge: 0000:00:1c.0
Aug 14 22:51:08 workstation64 IO window: d000-dfff
Aug 14 22:51:08 workstation64 MEM window: fdd00000-fddfffff
Aug 14 22:51:08 workstation64 PREFETCH window: fda00000-fdafffff
Aug 14 22:51:08 workstation64 PCI: Bridge: 0000:00:1c.4
Aug 14 22:51:08 workstation64 IO window: c000-cfff
Aug 14 22:51:08 workstation64 MEM window: fd900000-fd9fffff
Aug 14 22:51:08 workstation64 PREFETCH window: fde00000-fdefffff
Aug 14 22:51:08 workstation64 PCI: Bridge: 0000:00:1e.0
Aug 14 22:51:08 workstation64 IO window: b000-bfff
Aug 14 22:51:08 workstation64 MEM window: fdc00000-fdcfffff
Aug 14 22:51:08 workstation64 PREFETCH window: fdb00000-fdbfffff
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16=
 (level, low) -> IRQ 16
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
01.0 to 64
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16=
 (level, low) -> IRQ 16
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1c.0 to 64
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16=
 (level, low) -> IRQ 16
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1c.4 to 64
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1e.0 to 64
Aug 14 22:51:08 workstation64 NET: Registered protocol family 2
Aug 14 22:51:08 workstation64 Time: tsc clocksource has been installed.
Aug 14 22:51:08 workstation64 IP route cache hash table entries: 131072 (or=
der: 8, 1048576 bytes)
Aug 14 22:51:08 workstation64 TCP established hash table entries: 131072 (o=
rder: 9, 3145728 bytes)
Aug 14 22:51:08 workstation64 TCP bind hash table entries: 65536 (order: 8,=
 1048576 bytes)
Aug 14 22:51:08 workstation64 TCP: Hash tables configured (established 1310=
72 bind 65536)
Aug 14 22:51:08 workstation64 TCP reno registered
Aug 14 22:51:08 workstation64 checking if image is initramfs... it is
Aug 14 22:51:08 workstation64 Freeing initrd memory: 637k freed
Aug 14 22:51:08 workstation64 VFS: Disk quotas dquot_6.5.1
Aug 14 22:51:08 workstation64 Dquot-cache hash table entries: 512 (order 0,=
 4096 bytes)
Aug 14 22:51:08 workstation64 Installing knfsd (copyright (C) 1996 okir@mon=
ad.swb.de).
Aug 14 22:51:08 workstation64 io scheduler noop registered
Aug 14 22:51:08 workstation64 io scheduler anticipatory registered
Aug 14 22:51:08 workstation64 io scheduler deadline registered
Aug 14 22:51:08 workstation64 io scheduler cfq registered (default)
Aug 14 22:51:08 workstation64 Boot video device is 0000:01:00.0
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
01.0 to 64
Aug 14 22:51:08 workstation64 assign_interrupt_mode Found MSI capability
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:01.0:pcie00]
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:01.0:pcie03]
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1c.0 to 64
Aug 14 22:51:08 workstation64 assign_interrupt_mode Found MSI capability
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:1c.0:pcie00]
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:1c.0:pcie02]
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:1c.0:pcie03]
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1c.4 to 64
Aug 14 22:51:08 workstation64 assign_interrupt_mode Found MSI capability
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:1c.4:pcie00]
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:1c.4:pcie02]
Aug 14 22:51:08 workstation64 Allocate Port Service[0000:00:1c.4:pcie03]
Aug 14 22:51:08 workstation64 vesafb: framebuffer at 0xd0000000, mapped to =
0xffffc20010100000, using 5120k, total 131072k
Aug 14 22:51:08 workstation64 vesafb: mode is 1280x1024x16, linelength=3D25=
60, pages=3D1
Aug 14 22:51:08 workstation64 vesafb: scrolling: redraw
Aug 14 22:51:08 workstation64 vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:=
11:5:0
Aug 14 22:51:08 workstation64 Console: switching to colour frame buffer dev=
ice 160x64
Aug 14 22:51:08 workstation64 fb0: VESA VGA frame buffer device
Aug 14 22:51:08 workstation64 ACPI: SSDT CFEE7F80, 022A (r1  PmRef  Cpu0Ist=
     3000 INTL 20041203)
Aug 14 22:51:08 workstation64 ACPI: SSDT CFEE8440, 0152 (r1  PmRef  Cpu1Ist=
     3000 INTL 20041203)
Aug 14 22:51:08 workstation64 ACPI: SSDT CFEE85A0, 0152 (r1  PmRef  Cpu2Ist=
     3000 INTL 20041203)
Aug 14 22:51:08 workstation64 ACPI: SSDT CFEE8700, 0152 (r1  PmRef  Cpu3Ist=
     3000 INTL 20041203)
Aug 14 22:51:08 workstation64 ACPI Error (dswstate-0226): No result objects=
! State=3Dffff81012f8df400 [20070126]
Aug 14 22:51:08 workstation64 ACPI Exception (dsutils-0642): AE_AML_NO_RETU=
RN_VALUE, Missing or null operand [20070126]
Aug 14 22:51:08 workstation64 ACPI Exception (dsutils-0735): AE_AML_NO_RETU=
RN_VALUE, While creating Arg 1 [20070126]
Aug 14 22:51:08 workstation64 ACPI Error (psparse-0537): Method parse/execu=
tion failed [\_TZ_.THRM._TMP] (Node ffff81012fe3c8a0), AE_AML_NO_RETURN_VAL=
UE
Aug 14 22:51:08 workstation64 Real Time Clock Driver v1.12ac
Aug 14 22:51:08 workstation64 Linux agpgart interface v0.102 (c) Dave Jones
Aug 14 22:51:08 workstation64 Serial: 8250/16550 driver $Revision: 1.90 $ 4=
 ports, IRQ sharing disabled
Aug 14 22:51:08 workstation64 RAMDISK driver initialized: 16 RAM disks of 1=
6384K size 1024 blocksize
Aug 14 22:51:08 workstation64 loop: module loaded
Aug 14 22:51:08 workstation64 input: Macintosh mouse button emulation as /c=
lass/input/input0
Aug 14 22:51:08 workstation64 PNP: No PS/2 controller found. Probing ports =
directly.
Aug 14 22:51:08 workstation64 serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 14 22:51:08 workstation64 serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 14 22:51:08 workstation64 mice: PS/2 mouse device common for all mice
Aug 14 22:51:08 workstation64 TCP cubic registered
Aug 14 22:51:08 workstation64 NET: Registered protocol family 1
Aug 14 22:51:08 workstation64 NET: Registered protocol family 17
Aug 14 22:51:08 workstation64 Freeing unused kernel memory: 248k freed
Aug 14 22:51:08 workstation64 libata version 2.21 loaded.
Aug 14 22:51:08 workstation64 ata_piix 0000:00:1f.2: version 2.11
Aug 14 22:51:08 workstation64 ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19=
 (level, low) -> IRQ 19
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1f.2 to 64
Aug 14 22:51:08 workstation64 scsi0 : ata_piix
Aug 14 22:51:08 workstation64 scsi1 : ata_piix
Aug 14 22:51:08 workstation64 ata1: SATA max UDMA/133 cmd 0x000000000001f90=
0 ctl 0x000000000001f802 bmdma 0x000000000001f500 irq 19
Aug 14 22:51:08 workstation64 ata2: SATA max UDMA/133 cmd 0x000000000001f70=
0 ctl 0x000000000001f602 bmdma 0x000000000001f508 irq 19
Aug 14 22:51:08 workstation64 ata1.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P2=
0, max UDMA/133
Aug 14 22:51:08 workstation64 ata1.00: 145226112 sectors, multi 16: LBA48 N=
CQ (not used)
Aug 14 22:51:08 workstation64 ata1.00: configured for UDMA/133
Aug 14 22:51:08 workstation64 ata2.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, ma=
x UDMA7
Aug 14 22:51:08 workstation64 ata2.00: 781422768 sectors, multi 16: LBA48 N=
CQ (depth 0/32)
Aug 14 22:51:08 workstation64 ata2.00: configured for UDMA/133
Aug 14 22:51:08 workstation64 scsi 0:0:0:0: Direct-Access     ATA      WDC =
WD740ADFD-00 20.0 PQ: 0 ANSI: 5
Aug 14 22:51:08 workstation64 scsi 1:0:0:0: Direct-Access     ATA      SAMS=
UNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
Aug 14 22:51:08 workstation64 ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 19=
 (level, low) -> IRQ 19
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1f.5 to 64
Aug 14 22:51:08 workstation64 scsi2 : ata_piix
Aug 14 22:51:08 workstation64 scsi3 : ata_piix
Aug 14 22:51:08 workstation64 ata3: SATA max UDMA/133 cmd 0x000000000001f20=
0 ctl 0x000000000001f102 bmdma 0x000000000001ee00 irq 19
Aug 14 22:51:08 workstation64 ata4: SATA max UDMA/133 cmd 0x000000000001f00=
0 ctl 0x000000000001ef02 bmdma 0x000000000001ee08 irq 19
Aug 14 22:51:08 workstation64 PCI: Enabling device 0000:03:00.1 (0000 -> 00=
01)
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17=
 (level, low) -> IRQ 17
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:03:=
00.1 to 64
Aug 14 22:51:08 workstation64 scsi4 : pata_jmicron
Aug 14 22:51:08 workstation64 scsi5 : pata_jmicron
Aug 14 22:51:08 workstation64 ata5: PATA max UDMA/100 cmd 0x000000000001cf0=
0 ctl 0x000000000001ce02 bmdma 0x000000000001cb00 irq 17
Aug 14 22:51:08 workstation64 ata6: PATA max UDMA/100 cmd 0x000000000001cd0=
0 ctl 0x000000000001cc02 bmdma 0x000000000001cb08 irq 17
Aug 14 22:51:08 workstation64 ata5.00: Host Protected Area detected:
Aug 14 22:51:08 workstation64 	current size: 488395055 sectors
Aug 14 22:51:08 workstation64 	native size: 488397168 sectors
Aug 14 22:51:08 workstation64 ata5.00: ATA-6: HDS722525VLAT80, V36OA6EA, ma=
x UDMA/100
Aug 14 22:51:08 workstation64 ata5.00: 488395055 sectors, multi 0: LBA48=20
Aug 14 22:51:08 workstation64 ata5.01: ATAPI: HL-DT-ST DVDRAM GSA-4160B, A3=
06, max UDMA/66
Aug 14 22:51:08 workstation64 ata5.00: Host Protected Area detected:
Aug 14 22:51:08 workstation64 	current size: 488395055 sectors
Aug 14 22:51:08 workstation64 	native size: 488397168 sectors
Aug 14 22:51:08 workstation64 ata5.00: configured for UDMA/100
Aug 14 22:51:08 workstation64 ata5.01: configured for UDMA/66
Aug 14 22:51:08 workstation64 scsi 4:0:0:0: Direct-Access     ATA      HDS7=
22525VLAT80  V36O PQ: 0 ANSI: 5
Aug 14 22:51:08 workstation64 scsi 4:0:1:0: CD-ROM            HL-DT-ST DVDR=
AM GSA-4160B A306 PQ: 0 ANSI: 5
Aug 14 22:51:08 workstation64 ahci 0000:03:00.0: version 2.2
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16=
 (level, low) -> IRQ 16
Aug 14 22:51:08 workstation64 Uniform Multi-Platform E-IDE driver Revision:=
 7.00alpha2
Aug 14 22:51:08 workstation64 ide: Assuming 33MHz system bus speed for PIO =
modes; override with idebus=3Dxx
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware=
 sectors (74356 MB)
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware=
 sectors (74356 MB)
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 22:51:08 workstation64 sda: sda1 sda2 sda3
Aug 14 22:51:08 workstation64 sd 0:0:0:0: [sda] Attached SCSI disk
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] 781422768 512-byte hardware=
 sectors (400088 MB)
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Write Protect is off
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] 781422768 512-byte hardware=
 sectors (400088 MB)
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Write Protect is off
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 22:51:08 workstation64 sdb: sdb1
Aug 14 22:51:08 workstation64 sd 1:0:0:0: [sdb] Attached SCSI disk
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] 488395055 512-byte hardware=
 sectors (250058 MB)
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Write Protect is off
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] 488395055 512-byte hardware=
 sectors (250058 MB)
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Write Protect is off
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 22:51:08 workstation64 sdc: sdc1
Aug 14 22:51:08 workstation64 sd 4:0:0:0: [sdc] Attached SCSI disk
Aug 14 22:51:08 workstation64 ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 =
ports 3 Gbps 0x3 impl SATA mode
Aug 14 22:51:08 workstation64 ahci 0000:03:00.0: flags: 64bit ncq pm led cl=
o pmp pio slum part=20
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:03:=
00.0 to 64
Aug 14 22:51:08 workstation64 scsi6 : ahci
Aug 14 22:51:08 workstation64 scsi7 : ahci
Aug 14 22:51:08 workstation64 ata7: SATA max UDMA/133 cmd 0xffffc2000004810=
0 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
Aug 14 22:51:08 workstation64 ata8: SATA max UDMA/133 cmd 0xffffc2000004818=
0 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
Aug 14 22:51:08 workstation64 ata7: SATA link down (SStatus 0 SControl 300)
Aug 14 22:51:08 workstation64 ata8: SATA link down (SStatus 0 SControl 300)
Aug 14 22:51:08 workstation64 sr0: scsi3-mmc drive: 40x/40x writer dvd-ram =
cd/rw xa/form2 cdda tray
Aug 14 22:51:08 workstation64 Uniform CD-ROM driver Revision: 3.20
Aug 14 22:51:08 workstation64 sr 4:0:1:0: Attached scsi CD-ROM sr0
Aug 14 22:51:08 workstation64 ReiserFS: sda2: found reiserfs format "3.6" w=
ith standard journal
Aug 14 22:51:08 workstation64 ReiserFS: sda2: using ordered data mode
Aug 14 22:51:08 workstation64 ReiserFS: sda2: journal params: device sda2, =
size 8192, journal first block 18, max trans len 1024, max batch 900, max c=
ommit age 30, max trans age 30
Aug 14 22:51:08 workstation64 ReiserFS: sda2: checking transaction log (sda=
2)
Aug 14 22:51:08 workstation64 ReiserFS: sda2: Using r5 hash to sort names
Aug 14 22:51:08 workstation64 usbcore: registered new interface driver usbfs
Aug 14 22:51:08 workstation64 usbcore: registered new interface driver hub
Aug 14 22:51:08 workstation64 usbcore: registered new device driver usb
Aug 14 22:51:08 workstation64 coretemp coretemp.0: Using undocumented featu=
res, absolute temperature might be wrong!
Aug 14 22:51:08 workstation64 coretemp coretemp.1: Using undocumented featu=
res, absolute temperature might be wrong!
Aug 14 22:51:08 workstation64 coretemp coretemp.2: Using undocumented featu=
res, absolute temperature might be wrong!
Aug 14 22:51:08 workstation64 coretemp coretemp.3: Using undocumented featu=
res, absolute temperature might be wrong!
Aug 14 22:51:08 workstation64 input: Power Button (FF) as /class/input/inpu=
t1
Aug 14 22:51:08 workstation64 ACPI: Power Button (FF) [PWRF]
Aug 14 22:51:08 workstation64 input: Power Button (CM) as /class/input/inpu=
t2
Aug 14 22:51:08 workstation64 ACPI: Power Button (CM) [PWRB]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18=
 (level, low) -> IRQ 18
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1a.7 to 64
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1a.7: EHCI Host Controller
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1a.7: new USB bus registered=
, assigned bus number 1
Aug 14 22:51:08 workstation64 PCI: cache line size of 32 is not supported b=
y device 0000:00:1a.7
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff=
000
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI =
1.00, driver 10 Dec 2004
Aug 14 22:51:08 workstation64 usb usb1: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 1-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 1-0:1.0: 6 ports detected
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23=
 (level, low) -> IRQ 23
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1d.7 to 64
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1d.7: EHCI Host Controller
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1d.7: new USB bus registered=
, assigned bus number 2
Aug 14 22:51:08 workstation64 PCI: cache line size of 32 is not supported b=
y device 0000:00:1d.7
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe=
000
Aug 14 22:51:08 workstation64 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI =
1.00, driver 10 Dec 2004
Aug 14 22:51:08 workstation64 usb usb2: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 2-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 2-0:1.0: 6 ports detected
Aug 14 22:51:08 workstation64 USB Universal Host Controller Interface drive=
r v3.0
Aug 14 22:51:08 workstation64 rtc_cmos 00:03: rtc core: registered rtc_cmos=
 as rtc0
Aug 14 22:51:08 workstation64 rtc_cmos: probe of 00:03 failed with error -16
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16=
 (level, low) -> IRQ 16
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1a.0 to 64
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.0: UHCI Host Controller
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.0: new USB bus registered=
, assigned bus number 3
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000=
ff00
Aug 14 22:51:08 workstation64 usb usb3: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 3-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 3-0:1.0: 2 ports detected
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21=
 (level, low) -> IRQ 21
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1a.1 to 64
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.1: UHCI Host Controller
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.1: new USB bus registered=
, assigned bus number 4
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000=
fe00
Aug 14 22:51:08 workstation64 usb usb4: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 4-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 4-0:1.0: 2 ports detected
Aug 14 22:51:08 workstation64 sd 0:0:0:0: Attached scsi generic sg0 type 0
Aug 14 22:51:08 workstation64 sd 1:0:0:0: Attached scsi generic sg1 type 0
Aug 14 22:51:08 workstation64 sd 4:0:0:0: Attached scsi generic sg2 type 0
Aug 14 22:51:08 workstation64 sr 4:0:1:0: Attached scsi generic sg3 type 5
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1a.2[D] -> GSI 19=
 (level, low) -> IRQ 19
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1a.2 to 64
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.2: UHCI Host Controller
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.2: new USB bus registered=
, assigned bus number 5
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000=
fd00
Aug 14 22:51:08 workstation64 usb usb5: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 5-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 5-0:1.0: 2 ports detected
Aug 14 22:51:08 workstation64 input: PC Speaker as /class/input/input3
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23=
 (level, low) -> IRQ 23
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1d.0 to 64
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.0: UHCI Host Controller
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.0: new USB bus registered=
, assigned bus number 6
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000=
fc00
Aug 14 22:51:08 workstation64 usb usb6: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 6-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 6-0:1.0: 2 ports detected
Aug 14 22:51:08 workstation64 b2c2-flexcop: B2C2 FlexcopII/II(b)/III digita=
l TV receiver chip loaded successfully
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19=
 (level, low) -> IRQ 19
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1d.1 to 64
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.1: UHCI Host Controller
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.1: new USB bus registered=
, assigned bus number 7
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000=
fb00
Aug 14 22:51:08 workstation64 usb usb7: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 7-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 7-0:1.0: 2 ports detected
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18=
 (level, low) -> IRQ 18
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:00:=
1d.2 to 64
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.2: UHCI Host Controller
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.2: new USB bus registered=
, assigned bus number 8
Aug 14 22:51:08 workstation64 uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000=
fa00
Aug 14 22:51:08 workstation64 usb usb8: configuration #1 chosen from 1 choi=
ce
Aug 14 22:51:08 workstation64 hub 8-0:1.0: USB hub found
Aug 14 22:51:08 workstation64 hub 8-0:1.0: 2 ports detected
Aug 14 22:51:08 workstation64 flexcop-pci: will use the HW PID filter.
Aug 14 22:51:08 workstation64 flexcop-pci: card revision 2
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 22=
 (level, low) -> IRQ 22
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:04:=
03.0 to 64
Aug 14 22:51:08 workstation64 DVB: registering new adapter (FlexCop Digital=
 TV device).
Aug 14 22:51:08 workstation64 b2c2-flexcop: MAC address =3D 00:d0:d7:0d:0d:=
9e
Aug 14 22:51:08 workstation64 usb 3-1: new full speed USB device using uhci=
_hcd and address 2
Aug 14 22:51:08 workstation64 b2c2-flexcop: found the stv0299 at i2c addres=
s: 0x68
Aug 14 22:51:08 workstation64 DVB: registering frontend 0 (ST STV0299 DVB-S=
)...
Aug 14 22:51:08 workstation64 b2c2-flexcop: initialization of 'Sky2PC/SkySt=
ar 2 DVB-S' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 18=
 (level, low) -> IRQ 18
Aug 14 22:51:08 workstation64 r8169 Gigabit Ethernet driver 2.2LK loaded
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22=
 (level, low) -> IRQ 22
Aug 14 22:51:08 workstation64 eth0: RTL8169sc/8110sc at 0xffffc20000050000,=
 00:50:8d:9f:9a:05, IRQ 22
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 21=
 (level, low) -> IRQ 21
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:04:=
02.0 to 64
Aug 14 22:51:08 workstation64 gameport: EMU10K1 is pci0000:04:05.1/gameport=
0, io 0xbd00, speed 1041kHz
Aug 14 22:51:08 workstation64 usb 3-1: configuration #1 chosen from 1 choice
Aug 14 22:51:08 workstation64 ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=
=3D[21]  MMIO=3D[fdcfe000-fdcfe7ff]  Max Packet=3D[2048]  IR/IT contexts=3D=
[4/8]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:04:05.2[B] -> GSI 21=
 (level, low) -> IRQ 21
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:04:=
05.2 to 64
Aug 14 22:51:08 workstation64 ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=
=3D[21]  MMIO=3D[fdcfd000-fdcfd7ff]  Max Packet=3D[2048]  IR/IT contexts=3D=
[4/8]
Aug 14 22:51:08 workstation64 ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20=
 (level, low) -> IRQ 20
Aug 14 22:51:08 workstation64 PCI: Setting latency timer of device 0000:04:=
05.0 to 64
Aug 14 22:51:08 workstation64 Linux video capture interface: v2.00
Aug 14 22:51:08 workstation64 usb 4-1: new low speed USB device using uhci_=
hcd and address 2
Aug 14 22:51:08 workstation64 usb 4-1: configuration #1 chosen from 1 choice
Aug 14 22:51:08 workstation64 usb 4-2: new low speed USB device using uhci_=
hcd and address 3
Aug 14 22:51:08 workstation64 usb 4-2: configuration #1 chosen from 1 choice
Aug 14 22:51:08 workstation64 drivers/media/video/stv680.c: [stv680_probe:1=
422] STV(i): STV0680 camera found.
Aug 14 22:51:08 workstation64 drivers/media/video/stv680.c: [stv680_probe:1=
462] STV(i): registered new video device: video0
Aug 14 22:51:08 workstation64 usbcore: registered new interface driver stv6=
80
Aug 14 22:51:08 workstation64 drivers/media/video/stv680.c: [usb_stv680_ini=
t:1543] STV(i): usb camera driver version v0.25 registering
Aug 14 22:51:08 workstation64 drivers/media/video/stv680.c: STV0680 USB Cam=
era Driver v0.25
Aug 14 22:51:08 workstation64 usbcore: registered new interface driver hidd=
ev
Aug 14 22:51:08 workstation64 input: Microsoft Comfort Curve Keyboard 2000 =
as /class/input/input4
Aug 14 22:51:08 workstation64 input: USB HID v1.11 Keyboard [Microsoft Comf=
ort Curve Keyboard 2000] on usb-0000:00:1a.1-1
Aug 14 22:51:08 workstation64 input: Microsoft Comfort Curve Keyboard 2000 =
as /class/input/input5
Aug 14 22:51:08 workstation64 input: USB HID v1.11 Device [Microsoft Comfor=
t Curve Keyboard 2000] on usb-0000:00:1a.1-1
Aug 14 22:51:08 workstation64 input: Logitech USB RECEIVER as /class/input/=
input6
Aug 14 22:51:08 workstation64 input: USB HID v1.11 Mouse [Logitech USB RECE=
IVER] on usb-0000:00:1a.1-2
Aug 14 22:51:08 workstation64 usbcore: registered new interface driver usbh=
id
Aug 14 22:51:08 workstation64 drivers/hid/usbhid/hid-core.c: v2.6:USB HID c=
ore driver
Aug 14 22:51:08 workstation64 ieee1394: Host added: ID:BUS[0-00:1023]  GUID=
[00508d000099f7ea]
Aug 14 22:51:08 workstation64 ieee1394: Host added: ID:BUS[1-01:1023]  GUID=
[00023c0021039053]
Aug 14 22:51:08 workstation64 ReiserFS: sda3: found reiserfs format "3.6" w=
ith standard journal
Aug 14 22:51:08 workstation64 ReiserFS: sda3: using ordered data mode
Aug 14 22:51:08 workstation64 ReiserFS: sda3: journal params: device sda3, =
size 8192, journal first block 18, max trans len 1024, max batch 900, max c=
ommit age 30, max trans age 30
Aug 14 22:51:08 workstation64 ReiserFS: sda3: checking transaction log (sda=
3)
Aug 14 22:51:08 workstation64 ReiserFS: sda3: Using r5 hash to sort names
Aug 14 22:51:08 workstation64 ReiserFS: sdb1: found reiserfs format "3.6" w=
ith standard journal
Aug 14 22:51:08 workstation64 ReiserFS: sdb1: using ordered data mode
Aug 14 22:51:08 workstation64 ReiserFS: sdb1: journal params: device sdb1, =
size 8192, journal first block 18, max trans len 1024, max batch 900, max c=
ommit age 30, max trans age 30
Aug 14 22:51:08 workstation64 ReiserFS: sdb1: checking transaction log (sdb=
1)
Aug 14 22:51:08 workstation64 ReiserFS: sdb1: Using r5 hash to sort names
Aug 14 22:51:08 workstation64 Adding 2000052k swap on /dev/sda1.  Priority:=
-1 extents:1 across:2000052k
Aug 14 22:51:08 workstation64 r8169: eth0: link up
Aug 14 22:51:09 workstation64 ntpd[6342]: ntpd 4.2.4p3@1.1502-o Tue Jul  3 =
17:33:51 UTC 2007 (1)
Aug 14 22:51:09 workstation64 ntpd[6355]: precision =3D 1.000 usec
Aug 14 22:51:09 workstation64 NET: Registered protocol family 10
Aug 14 22:51:09 workstation64 lo: Disabled Privacy Extensions
Aug 14 22:51:09 workstation64 Mobile IPv6
Aug 14 22:51:09 workstation64 ntpd[6355]: ntp_io: estimated max descriptors=
: 1024, initial socket boundary: 16
Aug 14 22:51:09 workstation64 ntpd[6355]: Listening on interface #0 wildcar=
d, 0.0.0.0#123 Disabled
Aug 14 22:51:09 workstation64 ntpd[6355]: Listening on interface #1 wildcar=
d, ::#123 Disabled
Aug 14 22:51:09 workstation64 ntpd[6355]: Listening on interface #2 lo, ::1=
#123 Enabled
Aug 14 22:51:09 workstation64 ntpd[6355]: bind() fd 19, family 10, port 123=
, scope 2, addr fe80::250:8dff:fe9f:9a05, in6_is_addr_multicast=3D0 flags=
=3D0x11 fails: Cannot assign requested address
Aug 14 22:51:09 workstation64 ntpd[6355]: unable to create socket on eth0 (=
3) for fe80::250:8dff:fe9f:9a05#123
Aug 14 22:51:09 workstation64 ntpd[6355]: failed to initialize interface fo=
r address fe80::250:8dff:fe9f:9a05
Aug 14 22:51:09 workstation64 ntpd[6355]: Listening on interface #4 lo, 127=
.0.0.1#123 Enabled
Aug 14 22:51:09 workstation64 ntpd[6355]: Listening on interface #5 eth0, 1=
92.168.0.2#123 Enabled
Aug 14 22:51:09 workstation64 ntpd[6355]: kernel time sync status 0040
Aug 14 22:51:09 workstation64 ntpd[6355]: frequency initialized 4.712 PPM f=
rom /var/lib/ntp/ntp.drift
Aug 14 22:51:10 workstation64 ntpd[6355]: bind() fd 21, family 10, port 123=
, scope 2, addr fe80::250:8dff:fe9f:9a05, in6_is_addr_multicast=3D0 flags=
=3D0x11 fails: Cannot assign requested address
Aug 14 22:51:10 workstation64 ntpd[6355]: unable to create socket on eth0 (=
6) for fe80::250:8dff:fe9f:9a05#123
Aug 14 22:51:10 workstation64 ntpd[6355]: failed to initialize interface fo=
r address fe80::250:8dff:fe9f:9a05
Aug 14 22:51:12 workstation64 acpid: starting up
Aug 14 22:51:12 workstation64 acpid: 1 rule loaded
Aug 14 22:51:13 workstation64 acpid: client connected from 6452[82:82]
Aug 14 22:51:13 workstation64 acpid: 1 client rule loaded
Aug 14 22:51:13 workstation64 clamd[6480]: clamd daemon 0.91.1 (OS: linux-g=
nu, ARCH: x86_64, CPU: x86_64)
Aug 14 22:51:13 workstation64 clamd[6480]: Running as user clamav (UID 64, =
GID 64)
Aug 14 22:51:13 workstation64 clamd[6480]: Log file size limited to 2097152=
 bytes.
Aug 14 22:51:13 workstation64 clamd[6480]: Reading databases from /var/lib/=
clamav
Aug 14 22:51:14 workstation64 postfix/postfix-script[6521]: starting the Po=
stfix mail system
Aug 14 22:51:15 workstation64 postfix/master[6522]: daemon started -- versi=
on 2.4.3, configuration /etc/postfix
Aug 14 22:51:15 workstation64 clamd[6480]: Loaded 147069 signatures.
Aug 14 22:51:15 workstation64 clamd[6480]: Unix socket file /var/lib/clamav=
/clamd.sock
Aug 14 22:51:15 workstation64 clamd[6480]: Setting connection queue length =
to 15
Aug 14 22:51:15 workstation64 clamd[6480]: Archive: Archived file size limi=
t set to 524288000 bytes.
Aug 14 22:51:15 workstation64 clamd[6480]: Archive: Recursion level limit s=
et to 8.
Aug 14 22:51:15 workstation64 clamd[6480]: Archive: Files limit set to 1000.
Aug 14 22:51:15 workstation64 clamd[6480]: Archive: Compression ratio limit=
 set to 250.
Aug 14 22:51:15 workstation64 clamd[6480]: Archive support enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: Algorithmic detection enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: Portable Executable support enab=
led.
Aug 14 22:51:15 workstation64 clamd[6480]: ELF support enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: Mail files support enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: Mail: Recursion level limit set =
to 64.
Aug 14 22:51:15 workstation64 clamd[6480]: OLE2 support enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: PDF support enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: HTML support enabled.
Aug 14 22:51:15 workstation64 clamd[6480]: Self checking every 1800 seconds.
Aug 14 22:51:15 workstation64 freshclam[6527]: freshclam daemon 0.91.1 (OS:=
 linux-gnu, ARCH: x86_64, CPU: x86_64)
Aug 14 22:51:15 workstation64 freshclam[6527]: ClamAV update process starte=
d at Tue Aug 14 22:51:15 2007
Aug 14 22:51:15 workstation64 freshclam[6527]: main.inc is up to date (vers=
ion: 44, sigs: 133163, f-level: 20, builder: sven)
Aug 14 22:51:15 workstation64 freshclam[6527]: daily.inc is up to date (ver=
sion: 3957, sigs: 13906, f-level: 20, builder: ccordes)
Aug 14 22:51:15 workstation64 freshclam[6527]: ----------------------------=
----------
Aug 14 22:51:15 workstation64 acpid: client connected from 6550[0:0]
Aug 14 22:51:15 workstation64 acpid: 1 client rule loaded
Aug 14 22:51:16 workstation64 nvidia: module license 'NVIDIA' taints kernel.
Aug 14 22:51:16 workstation64 ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16=
 (level, low) -> IRQ 16
Aug 14 22:51:16 workstation64 PCI: Setting latency timer of device 0000:01:=
00.0 to 64
Aug 14 22:51:16 workstation64 NVRM: loading NVIDIA UNIX x86_64 Kernel Modul=
e  100.14.11  Wed Jun 13 16:33:22 PDT 2007
Aug 14 22:51:17 workstation64 acpid: client connected from 6550[0:0]
Aug 14 22:51:17 workstation64 acpid: 1 client rule loaded
Aug 14 22:51:18 workstation64 drivers/media/video/stv680.c: [stv_init:374] =
STV(i): CIF is supported
Aug 14 22:51:18 workstation64 drivers/media/video/stv680.c: [stv_init:392] =
STV(i): Camera has 0 pictures.
Aug 14 22:51:18 workstation64 drivers/media/video/stv680.c: [stv_init:419] =
STV(i): Video Mode set to CIF
Aug 14 22:51:20 workstation64 eth0: no IPv6 routers present
Aug 14 22:51:46 gconfd (andyrtr-6636): (Version 2.18.0.1) wird gestartet, P=
rozesskennung 6636, Benutzer =C2=BBandyrtr=C2=AB
Aug 14 22:51:46 gconfd (andyrtr-6636): Die Adresse =C2=BBxml:readonly:/etc/=
gconf/gconf.xml.mandatory=C2=AB wurde an der Position 0 zu einer nur lesbar=
en Konfigurationsquelle aufgel=C3=B6st
Aug 14 22:51:46 gconfd (andyrtr-6636): Die Adresse =C2=BBxml:readwrite:/hom=
e/andyrtr/.gconf=C2=AB wurde an der Position 1 zu einer schreibbaren Konfig=
urationsquelle aufgel=C3=B6st
Aug 14 22:51:46 gconfd (andyrtr-6636): Die Adresse =C2=BBxml:readonly:/etc/=
gconf/gconf.xml.defaults=C2=AB wurde an der Position 2 zu einer nur lesbare=
n Konfigurationsquelle aufgel=C3=B6st
Aug 14 22:55:30 workstation64 ntpd[6355]: synchronized to 141.82.30.251, st=
ratum 3
Aug 14 22:55:29 workstation64 ntpd[6355]: time reset -0.397675 s
Aug 14 22:55:29 workstation64 ntpd[6355]: kernel time sync status change 00=
01
Aug 14 22:56:09 workstation64 ntpd[6355]: Listening on interface #7 eth0, f=
e80::250:8dff:fe9f:9a05#123 Enabled
Aug 14 22:59:36 workstation64 ntpd[6355]: synchronized to 212.82.32.26, str=
atum 2
Aug 14 23:01:08 workstation64 syslog-ng[6304]: Log statistics; processed=3D=
'center(queued)=3D2235', processed=3D'center(received)=3D586', processed=3D=
'destination(console)=3D0', processed=3D'destination(mail)=3D7', processed=
=3D'destination(user)=3D4', processed=3D'destination(uucp)=3D0', processed=
=3D'destination(messages)=3D497', processed=3D'destination(news)=3D0', proc=
essed=3D'destination(iptables)=3D0', processed=3D'destination(everything)=
=3D583', processed=3D'destination(lpr)=3D0', processed=3D'destination(cron)=
=3D0', processed=3D'destination(syslog)=3D1', processed=3D'destination(auth=
log)=3D3', processed=3D'destination(errors)=3D4', processed=3D'destination(=
kernel)=3D521', processed=3D'destination(daemon)=3D29', processed=3D'destin=
ation(console_all)=3D586', processed=3D'source(src)=3D586'
Aug 14 23:06:01 workstation64 ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x=
0 action 0x2
Aug 14 23:06:01 workstation64 ata1.00: (BMDMA stat 0x26)
Aug 14 23:06:01 workstation64 ata1.00: cmd ca/00:08:91:0d:45/00:00:00:00:00=
/e4 tag 0 cdb 0x0 data 4096 out
Aug 14 23:06:01 workstation64 res 51/84:08:91:0d:45/00:00:00:00:00/e4 Emask=
 0x30 (host bus error)
Aug 14 23:06:01 workstation64 ata1: soft resetting port
Aug 14 23:06:01 workstation64 ata1.00: configured for UDMA/133
Aug 14 23:06:01 workstation64 ata1: EH complete
Aug 14 23:06:01 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware=
 sectors (74356 MB)
Aug 14 23:06:01 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 14 23:06:01 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 14 23:06:01 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA
Aug 14 23:07:56 workstation64 ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x=
0 action 0x2
Aug 14 23:07:56 workstation64 ata1.00: (BMDMA stat 0x26)
Aug 14 23:07:56 workstation64 ata1.00: cmd ca/00:08:78:6d:2f/00:00:00:00:00=
/e8 tag 0 cdb 0x0 data 4096 out
Aug 14 23:07:56 workstation64 res 51/84:08:78:6d:2f/00:00:00:00:00/e8 Emask=
 0x30 (host bus error)
Aug 14 23:07:56 workstation64 ata1: soft resetting port
Aug 14 23:07:56 workstation64 ata1.00: configured for UDMA/133
Aug 14 23:07:56 workstation64 ata1: EH complete
Aug 14 23:07:56 workstation64 sd 0:0:0:0: [sda] 145226112 512-byte hardware=
 sectors (74356 MB)
Aug 14 23:07:56 workstation64 sd 0:0:0:0: [sda] Write Protect is off
Aug 14 23:07:56 workstation64 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 14 23:07:56 workstation64 sd 0:0:0:0: [sda] Write cache: enabled, read =
cache: enabled, doesn't support DPO or FUA

--MP_+VLyjDs9LUDe+GNTZ=vYw5m--
