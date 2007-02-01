Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXBAPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXBAPpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXBAPpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:45:39 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:35349 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXBAPph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:45:37 -0500
Date: Thu, 1 Feb 2007 16:45:34 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Martin Klejch <martin.klejch@seznam.cz>
Cc: linux-kernel@vger.kernel.org
Subject: PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0b) (try 'pci=assign-busses')
Message-ID: <20070201154534.GA6430@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Martin Klejch <martin.klejch@seznam.cz>, linux-kernel@vger.kernel.org
References: <45C1F4F7.70100@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C1F4F7.70100@seznam.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 03:11:03PM +0100, Martin Klejch wrote:

>    I am a linux user (distro Ubuntu 6.10) with a 2.6.17.10-generic 
> kernel running on my Acer TravelMate 4672LMi.
> I found a line "Please report the result to linux-kernel to fix this 
> permanently" in my /var/log/kern.log but have no idea where the problem 

Martin - I updated the topic so it better describes the problem you are
reporting, so the people who can fix it can see it.

You might want to see if a newer kernel removes that warning though.

good luck!

> Feb  1 13:10:26 localhost kernel: [17179570.264000] PCI: Probing PCI hardware (bus 00)
> Feb  1 13:10:26 localhost kernel: [17179570.272000] Boot video device is 0000:00:02.0
> Feb  1 13:10:26 localhost kernel: [17179570.272000] PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.2
> Feb  1 13:10:26 localhost kernel: [17179570.272000] PCI: Transparent bridge - 0000:00:1e.0
> Feb  1 13:10:26 localhost kernel: [17179570.272000] PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0b) (try 'pci=assign-busses')
> Feb  1 13:10:26 localhost kernel: [17179570.272000] Please report the result to linux-kernel to fix this permanently
> Feb  1 13:10:26 localhost kernel: [17179570.272000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> Feb  1 13:10:26 localhost kernel: [17179570.280000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> Feb  1 13:10:26 localhost kernel: [17179570.280000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> Feb  1 13:10:26 localhost kernel: [17179570.280000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
> Feb  1 13:10:26 localhost kernel: [17179570.280000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> Feb  1 13:10:26 localhost kernel: [17179570.280000] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> Feb  1 13:10:26 localhost kernel: [17179570.280000] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> Feb  1 13:10:26 localhost kernel: [17179570.284000] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
> Feb  1 13:10:26 localhost kernel: [17179570.284000] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
> Feb  1 13:10:26 localhost kernel: [17179570.284000] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
> Feb  1 13:10:26 localhost kernel: [17179570.284000] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.284000] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
> Feb  1 13:10:26 localhost kernel: [17179570.284000] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> Feb  1 13:10:26 localhost kernel: [17179570.288000] ACPI: Embedded Controller [EC0] (gpe 23) interrupt mode.
> Feb  1 13:10:26 localhost kernel: [17179570.312000] Linux Plug and Play Support v0.97 (c) Adam Belay
> Feb  1 13:10:26 localhost kernel: [17179570.312000] pnp: PnP ACPI init
> Feb  1 13:10:26 localhost kernel: [17179570.320000] pnp: PnP ACPI: found 12 devices
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PnPBIOS: Disabled by ACPI PNP
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Using ACPI for IRQ routing
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.1
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.1
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.1
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.2
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.2
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.2
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.3
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.3
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.3
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Bridge: 0000:00:1c.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   MEM window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   PREFETCH window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Bridge: 0000:00:1c.1
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   MEM window: 32000000-320fffff
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   PREFETCH window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Bridge: 0000:00:1c.2
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   MEM window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   PREFETCH window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Bridge: 0000:00:1c.3
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   MEM window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   PREFETCH window: disabled.
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Bus 11, cardbus bridge: 0000:0a:09.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: 00002000-000020ff
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: 00002400-000024ff
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   PREFETCH window: 30000000-31ffffff
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   MEM window: 34000000-35ffffff
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Bridge: 0000:00:1e.0
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   IO window: 2000-2fff
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   MEM window: b0300000-b03fffff
> Feb  1 13:10:26 localhost kernel: [17179570.320000]   PREFETCH window: 30000000-31ffffff
> Feb  1 13:10:26 localhost kernel: [17179570.320000] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 169
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.320000] PCI: Enabling device 0000:00:1c.1 (0000 -> 0002)
> Feb  1 13:10:26 localhost kernel: [17179570.320000] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 177
> Feb  1 13:10:26 localhost kernel: [17179570.324000] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.324000] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 185
> Feb  1 13:10:26 localhost kernel: [17179570.324000] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.324000] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 193
> Feb  1 13:10:26 localhost kernel: [17179570.324000] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.324000] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.324000] ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 20 (level, low) -> IRQ 201
> Feb  1 13:10:26 localhost kernel: [17179570.324000] NET: Registered protocol family 2
> Feb  1 13:10:26 localhost kernel: [17179570.376000] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] TCP: Hash tables configured (established 16384 bind 8192)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] TCP reno registered
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Simple Boot Flag at 0x3e set to 0x1
> Feb  1 13:10:26 localhost kernel: [17179570.376000] audit: initializing netlink socket (disabled)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] audit(1170335394.376:1): initialized
> Feb  1 13:10:26 localhost kernel: [17179570.376000] VFS: Disk quotas dquot_6.5.1
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Initializing Cryptographic API
> Feb  1 13:10:26 localhost kernel: [17179570.376000] io scheduler noop registered
> Feb  1 13:10:26 localhost kernel: [17179570.376000] io scheduler anticipatory registered
> Feb  1 13:10:26 localhost kernel: [17179570.376000] io scheduler deadline registered
> Feb  1 13:10:26 localhost kernel: [17179570.376000] io scheduler cfq registered (default)
> Feb  1 13:10:26 localhost kernel: [17179570.376000] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 169
> Feb  1 13:10:26 localhost kernel: [17179570.376000] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.376000] assign_interrupt_mode Found MSI capability
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Allocate Port Service[0000:00:1c.0:pcie00]
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Allocate Port Service[0000:00:1c.0:pcie02]
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Allocate Port Service[0000:00:1c.0:pcie03]
> Feb  1 13:10:26 localhost kernel: [17179570.376000] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 177
> Feb  1 13:10:26 localhost kernel: [17179570.376000] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.376000] assign_interrupt_mode Found MSI capability
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Allocate Port Service[0000:00:1c.1:pcie00]
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Allocate Port Service[0000:00:1c.1:pcie02]
> Feb  1 13:10:26 localhost kernel: [17179570.376000] Allocate Port Service[0000:00:1c.1:pcie03]
> Feb  1 13:10:26 localhost kernel: [17179570.376000] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 185
> Feb  1 13:10:26 localhost kernel: [17179570.380000] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.380000] assign_interrupt_mode Found MSI capability
> Feb  1 13:10:26 localhost kernel: [17179570.380000] Allocate Port Service[0000:00:1c.2:pcie00]
> Feb  1 13:10:26 localhost kernel: [17179570.380000] Allocate Port Service[0000:00:1c.2:pcie02]
> Feb  1 13:10:26 localhost kernel: [17179570.380000] Allocate Port Service[0000:00:1c.2:pcie03]
> Feb  1 13:10:26 localhost kernel: [17179570.380000] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 193
> Feb  1 13:10:26 localhost kernel: [17179570.380000] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> Feb  1 13:10:26 localhost kernel: [17179570.380000] assign_interrupt_mode Found MSI capability
> Feb  1 13:10:26 localhost kernel: [17179570.380000] Allocate Port Service[0000:00:1c.3:pcie00]
> Feb  1 13:10:26 localhost kernel: [17179570.380000] Allocate Port Service[0000:00:1c.3:pcie02]
> Feb  1 13:10:26 localhost kernel: [17179570.380000] Allocate Port Service[0000:00:1c.3:pcie03]
> Feb  1 13:10:26 localhost kernel: [17179570.380000] isapnp: Scanning for PnP cards...
> Feb  1 13:10:26 localhost kernel: [17179570.736000] isapnp: No Plug & Play device found
> Feb  1 13:10:26 localhost kernel: [17179570.756000] Real Time Clock Driver v1.12ac
> Feb  1 13:10:26 localhost kernel: [17179570.756000] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> Feb  1 13:10:26 localhost kernel: [17179570.756000] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Feb  1 13:10:26 localhost kernel: [17179570.756000] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> Feb  1 13:10:26 localhost kernel: [17179570.756000] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Feb  1 13:10:26 localhost kernel: [17179570.756000] mice: PS/2 mouse device common for all mice
> Feb  1 13:10:26 localhost kernel: [17179570.756000] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
> Feb  1 13:10:26 localhost kernel: [17179570.760000] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> Feb  1 13:10:26 localhost kernel: [17179570.760000] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> Feb  1 13:10:26 localhost kernel: [17179570.760000] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> Feb  1 13:10:26 localhost kernel: [17179570.760000] i8042.c: Detected active multiplexing controller, rev 1.1.
> Feb  1 13:10:26 localhost kernel: [17179570.760000] serio: i8042 AUX0 port at 0x60,0x64 irq 12
> Feb  1 13:10:26 localhost kernel: [17179570.760000] serio: i8042 AUX1 port at 0x60,0x64 irq 12
> Feb  1 13:10:26 localhost kernel: [17179570.784000] serio: i8042 AUX2 port at 0x60,0x64 irq 12
> Feb  1 13:10:26 localhost kernel: [17179570.804000] serio: i8042 AUX3 port at 0x60,0x64 irq 12
> Feb  1 13:10:26 localhost kernel: [17179570.804000] serio: i8042 KBD port at 0x60,0x64 irq 1
> Feb  1 13:10:26 localhost kernel: [17179570.804000] EISA: Probing bus 0 at eisa.0
> Feb  1 13:10:26 localhost kernel: [17179570.804000] Cannot allocate resource for EISA slot 1
> Feb  1 13:10:26 localhost kernel: [17179570.804000] Cannot allocate resource for EISA slot 2
> Feb  1 13:10:26 localhost kernel: [17179570.804000] EISA: Detected 0 cards.
> Feb  1 13:10:26 localhost kernel: [17179570.808000] TCP bic registered
> Feb  1 13:10:26 localhost kernel: [17179570.808000] NET: Registered protocol family 1
> Feb  1 13:10:26 localhost kernel: [17179570.808000] NET: Registered protocol family 8
> Feb  1 13:10:26 localhost kernel: [17179570.808000] NET: Registered protocol family 20
> Feb  1 13:10:26 localhost kernel: [17179570.808000] Starting balanced_irq
> Feb  1 13:10:26 localhost kernel: [17179570.808000] Using IPI No-Shortcut mode
> Feb  1 13:10:26 localhost kernel: [17179570.808000] ACPI: (supports S0 S3 S4 S5)
> Feb  1 13:10:26 localhost kernel: [17179570.808000] Freeing unused kernel memory: 308k freed
> Feb  1 13:10:26 localhost kernel: [17179570.852000] Capability LSM initialized
> Feb  1 13:10:26 localhost kernel: [17179570.884000] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu0Ist] [20060707]
> Feb  1 13:10:26 localhost kernel: [17179570.884000] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu0Cst] [20060707]
> Feb  1 13:10:26 localhost kernel: [17179570.884000] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> Feb  1 13:10:26 localhost kernel: [17179570.884000] ACPI: Processor [CPU0] (supports 8 throttling states)
> Feb  1 13:10:26 localhost kernel: [17179570.884000] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu1Ist] [20060707]
> Feb  1 13:10:26 localhost kernel: [17179570.888000] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu1Cst] [20060707]
> Feb  1 13:10:26 localhost kernel: [17179570.888000] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> Feb  1 13:10:26 localhost kernel: [17179570.888000] ACPI: Processor [CPU1] (supports 8 throttling states)
> Feb  1 13:10:26 localhost kernel: [17179570.900000] ACPI: Thermal Zone [THRM] (47 C)
> Feb  1 13:10:26 localhost kernel: [17179570.936000] input: AT Translated Set 2 keyboard as /class/input/input0
> Feb  1 13:10:26 localhost kernel: [17179571.176000] SCSI subsystem initialized
> Feb  1 13:10:26 localhost kernel: [17179571.180000] libata version 1.20 loaded.
> Feb  1 13:10:26 localhost kernel: [17179571.184000] ata_piix 0000:00:1f.2: version 1.05
> Feb  1 13:10:26 localhost kernel: [17179571.184000] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 193
> Feb  1 13:10:26 localhost kernel: [17179571.184000] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> Feb  1 13:10:26 localhost kernel: [17179571.184000] ata1: SATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0x18B0 irq 14
> Feb  1 13:10:26 localhost kernel: [17179571.348000] ata1: dev 0 cfg 49:2f00 82:746b 83:7d09 84:6023 85:7469 86:3d09 87:6023 88:203f
> Feb  1 13:10:26 localhost kernel: [17179571.348000] ata1: dev 0 ATA-6, max UDMA/100, 156301488 sectors: LBA48
> Feb  1 13:10:26 localhost kernel: [17179571.356000] ata1: dev 0 configured for UDMA/100
> Feb  1 13:10:26 localhost kernel: [17179571.356000] scsi0 : ata_piix
> Feb  1 13:10:26 localhost kernel: [17179571.356000]   Vendor: ATA       Model: TOSHIBA MK8032GS  Rev: AS11
> Feb  1 13:10:26 localhost kernel: [17179571.356000]   Type:   Direct-Access                      ANSI SCSI revision: 05
> Feb  1 13:10:26 localhost kernel: [17179571.356000] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x18B8 irq 15
> Feb  1 13:10:26 localhost kernel: [17179571.676000] ata2: dev 0 cfg 49:0f00 82:0000 83:0000 84:0000 85:0000 86:0000 87:0000 88:0407
> Feb  1 13:10:26 localhost kernel: [17179571.676000] ata2: dev 0 ATAPI, max UDMA/33
> Feb  1 13:10:26 localhost kernel: [17179571.676000] ata2(0): applying bridge limits
> Feb  1 13:10:26 localhost kernel: [17179571.840000] ata2: dev 0 configured for UDMA/33
> Feb  1 13:10:26 localhost kernel: [17179571.840000] scsi1 : ata_piix
> Feb  1 13:10:26 localhost kernel: [17179571.840000]   Vendor: MATSHITA  Model: DVD-RAM UJ-850S   Rev: 1.50
> Feb  1 13:10:26 localhost kernel: [17179571.840000]   Type:   CD-ROM                             ANSI SCSI revision: 05
> Feb  1 13:10:26 localhost kernel: [17179571.848000] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> Feb  1 13:10:26 localhost kernel: [17179571.848000] sda: Write Protect is off
> Feb  1 13:10:26 localhost kernel: [17179571.848000] sda: Mode Sense: 00 3a 00 00
> Feb  1 13:10:26 localhost kernel: [17179571.848000] SCSI device sda: drive cache: write back
> Feb  1 13:10:26 localhost kernel: [17179571.848000] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> Feb  1 13:10:26 localhost kernel: [17179571.848000] sda: Write Protect is off
> Feb  1 13:10:26 localhost kernel: [17179571.848000] sda: Mode Sense: 00 3a 00 00
> Feb  1 13:10:26 localhost kernel: [17179571.848000] SCSI device sda: drive cache: write back
> Feb  1 13:10:26 localhost kernel: [17179571.848000]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
> Feb  1 13:10:26 localhost kernel: [17179571.928000] sd 0:0:0:0: Attached scsi disk sda
> Feb  1 13:10:26 localhost kernel: [17179572.392000] ide0: I/O resource 0x1F0-0x1F7 not free.
> Feb  1 13:10:26 localhost kernel: [17179572.392000] ide0: ports already in use, skipping probe
> Feb  1 13:10:26 localhost kernel: [17179572.392000] ide1: I/O resource 0x170-0x177 not free.
> Feb  1 13:10:26 localhost kernel: [17179572.392000] ide1: ports already in use, skipping probe
> Feb  1 13:10:26 localhost kernel: [17179572.420000] usbcore: registered new driver usbfs
> Feb  1 13:10:26 localhost kernel: [17179572.420000] usbcore: registered new driver hub
> Feb  1 13:10:26 localhost kernel: [17179572.420000] USB Universal Host Controller Interface driver v3.0
> Feb  1 13:10:26 localhost kernel: [17179572.420000] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 58
> Feb  1 13:10:26 localhost kernel: [17179572.420000] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> Feb  1 13:10:26 localhost kernel: [17179572.420000] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> Feb  1 13:10:26 localhost kernel: [17179572.420000] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> Feb  1 13:10:26 localhost kernel: [17179572.420000] uhci_hcd 0000:00:1d.0: irq 58, io base 0x00001820
> Feb  1 13:10:26 localhost kernel: [17179572.424000] usb usb1: configuration #1 chosen from 1 choice
> Feb  1 13:10:26 localhost kernel: [17179572.424000] hub 1-0:1.0: USB hub found
> Feb  1 13:10:26 localhost kernel: [17179572.424000] hub 1-0:1.0: 2 ports detected
> Feb  1 13:10:26 localhost kernel: [17179572.452000] ieee1394: Initialized config rom entry `ip1394'
> Feb  1 13:10:26 localhost kernel: [17179572.528000] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 193
> Feb  1 13:10:26 localhost kernel: [17179572.528000] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> Feb  1 13:10:26 localhost kernel: [17179572.528000] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> Feb  1 13:10:26 localhost kernel: [17179572.528000] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> Feb  1 13:10:26 localhost kernel: [17179572.528000] uhci_hcd 0000:00:1d.1: irq 193, io base 0x00001840
> Feb  1 13:10:26 localhost kernel: [17179572.528000] usb usb2: configuration #1 chosen from 1 choice
> Feb  1 13:10:26 localhost kernel: [17179572.528000] hub 2-0:1.0: USB hub found
> Feb  1 13:10:26 localhost kernel: [17179572.528000] hub 2-0:1.0: 2 ports detected
> Feb  1 13:10:26 localhost kernel: [17179572.632000] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 185
> Feb  1 13:10:26 localhost kernel: [17179572.632000] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> Feb  1 13:10:26 localhost kernel: [17179572.632000] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> Feb  1 13:10:26 localhost kernel: [17179572.632000] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> Feb  1 13:10:26 localhost kernel: [17179572.632000] uhci_hcd 0000:00:1d.2: irq 185, io base 0x00001860
> Feb  1 13:10:26 localhost kernel: [17179572.632000] usb usb3: configuration #1 chosen from 1 choice
> Feb  1 13:10:26 localhost kernel: [17179572.632000] hub 3-0:1.0: USB hub found
> Feb  1 13:10:26 localhost kernel: [17179572.632000] hub 3-0:1.0: 2 ports detected
> Feb  1 13:10:26 localhost kernel: [17179572.736000] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 177
> Feb  1 13:10:26 localhost kernel: [17179572.736000] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> Feb  1 13:10:26 localhost kernel: [17179572.736000] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> Feb  1 13:10:26 localhost kernel: [17179572.736000] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> Feb  1 13:10:26 localhost kernel: [17179572.736000] uhci_hcd 0000:00:1d.3: irq 177, io base 0x00001880
> Feb  1 13:10:26 localhost kernel: [17179572.736000] usb usb4: configuration #1 chosen from 1 choice
> Feb  1 13:10:26 localhost kernel: [17179572.736000] hub 4-0:1.0: USB hub found
> Feb  1 13:10:26 localhost kernel: [17179572.736000] hub 4-0:1.0: 2 ports detected
> Feb  1 13:10:26 localhost kernel: [17179572.768000] usb 1-2: new low speed USB device using uhci_hcd and address 2
> Feb  1 13:10:26 localhost kernel: [17179572.840000] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 58
> Feb  1 13:10:26 localhost kernel: [17179572.840000] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> Feb  1 13:10:26 localhost kernel: [17179572.840000] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> Feb  1 13:10:26 localhost kernel: [17179572.840000] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> Feb  1 13:10:26 localhost kernel: [17179572.840000] ehci_hcd 0000:00:1d.7: debug port 1
> Feb  1 13:10:26 localhost kernel: [17179572.840000] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> Feb  1 13:10:26 localhost kernel: [17179572.840000] ehci_hcd 0000:00:1d.7: irq 58, io mem 0xb0004000
> Feb  1 13:10:26 localhost kernel: [17179572.844000] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> Feb  1 13:10:26 localhost kernel: [17179572.844000] usb usb5: configuration #1 chosen from 1 choice
> Feb  1 13:10:26 localhost kernel: [17179572.844000] hub 5-0:1.0: USB hub found
> Feb  1 13:10:26 localhost kernel: [17179572.844000] hub 5-0:1.0: 8 ports detected
> Feb  1 13:10:26 localhost kernel: [17179572.948000] ACPI: PCI Interrupt 0000:0a:09.1[A] -> GSI 20 (level, low) -> IRQ 201
> Feb  1 13:10:26 localhost kernel: [17179572.996000] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[201]  MMIO=[b0315000-b03157ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> Feb  1 13:10:26 localhost kernel: [17179573.256000] kjournald starting.  Commit interval 5 seconds
> Feb  1 13:10:26 localhost kernel: [17179573.256000] EXT3-fs: mounted filesystem with ordered data mode.
> Feb  1 13:10:26 localhost kernel: [17179573.300000] usb 1-2: device not accepting address 2, error -71
> Feb  1 13:10:26 localhost kernel: [17179574.028000] usb 1-2: new low speed USB device using uhci_hcd and address 4
> Feb  1 13:10:26 localhost kernel: [17179574.204000] usb 1-2: configuration #1 chosen from 1 choice
> Feb  1 13:10:26 localhost kernel: [17179574.268000] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00c09f0000967293]
> Feb  1 13:10:26 localhost kernel: [17179587.132000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> Feb  1 13:10:26 localhost kernel: [17179587.204000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> Feb  1 13:10:26 localhost kernel: [17179587.212000] Linux agpgart interface v0.101 (c) Dave Jones
> Feb  1 13:10:26 localhost kernel: [17179587.216000] agpgart: Detected an Intel 945GM Chipset.
> Feb  1 13:10:26 localhost kernel: [17179587.220000] agpgart: Detected 7932K stolen memory.
> Feb  1 13:10:26 localhost kernel: [17179587.236000] agpgart: AGP aperture is 256M @ 0xc0000000
> Feb  1 13:10:26 localhost kernel: [17179587.308000] hw_random hardware driver 1.0.0 loaded
> Feb  1 13:10:26 localhost kernel: [17179587.324000] parport: PnPBIOS parport detected.
> Feb  1 13:10:26 localhost kernel: [17179587.324000] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
> Feb  1 13:10:26 localhost kernel: [17179587.420000] ieee80211_crypt: registered algorithm 'NULL'
> Feb  1 13:10:26 localhost kernel: [17179587.568000] ieee80211: 802.11 data/management/control stack, git-1.1.13
> Feb  1 13:10:26 localhost kernel: [17179587.568000] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> Feb  1 13:10:26 localhost kernel: [17179587.664000] irda_init()
> Feb  1 13:10:26 localhost kernel: [17179587.664000] NET: Registered protocol family 23
> Feb  1 13:10:26 localhost kernel: [17179587.712000] ACPI: PCI Interrupt 0000:0a:09.2[A] -> GSI 20 (level, low) -> IRQ 201
> Feb  1 13:10:26 localhost kernel: [17179587.976000] ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.1.0mp
> Feb  1 13:10:26 localhost kernel: [17179587.976000] ipw3945: Copyright(c) 2003-2006 Intel Corporation
> Feb  1 13:10:26 localhost kernel: [17179587.976000] PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
> Feb  1 13:10:26 localhost kernel: [17179587.976000] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 169
> Feb  1 13:10:26 localhost kernel: [17179587.976000] PCI: Setting latency timer of device 0000:03:00.0 to 64
> Feb  1 13:10:26 localhost kernel: [17179587.976000] ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> Feb  1 13:10:26 localhost kernel: [17179588.252000] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x12a0b1, caps: 0xa04713/0x204000
> Feb  1 13:10:26 localhost kernel: [17179588.296000] input: SynPS/2 Synaptics TouchPad as /class/input/input1
> Feb  1 13:10:26 localhost kernel: [17179588.324000] tg3.c:v3.59.1 (August 25, 2006)
> Feb  1 13:10:26 localhost kernel: [17179588.324000] ACPI: PCI Interrupt 0000:0a:00.0[A] -> GSI 17 (level, low) -> IRQ 169
> Feb  1 13:10:26 localhost kernel: [17179588.392000] eth0: Tigon3 [partno(BCM95705A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000BaseT Ethernet 00:16:36:3d:ec:d0
> Feb  1 13:10:26 localhost kernel: [17179588.392000] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[0] TSOcap[1] 
> Feb  1 13:10:26 localhost kernel: [17179588.392000] eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
> Feb  1 13:10:26 localhost kernel: [17179588.392000] ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 20 (level, low) -> IRQ 201
> Feb  1 13:10:26 localhost kernel: [17179588.392000] Yenta: CardBus bridge found at 0000:0a:09.0 [1025:0094]
> Feb  1 13:10:26 localhost kernel: [17179588.392000] Yenta: Using CSCINT to route CSC interrupts to PCI
> Feb  1 13:10:26 localhost kernel: [17179588.392000] Yenta: Routing CardBus interrupts to PCI
> Feb  1 13:10:26 localhost kernel: [17179588.392000] Yenta TI: socket 0000:0a:09.0, mfunc 0x01321b22, devctl 0x66
> Feb  1 13:10:26 localhost kernel: [17179588.480000] PM: Writing back config space on device 0000:0a:00.0 at offset c (was bfff0000, writing 0)
> Feb  1 13:10:26 localhost kernel: [17179588.480000] PM: Writing back config space on device 0000:0a:00.0 at offset b (was 165314e4, writing 941025)
> Feb  1 13:10:26 localhost kernel: [17179588.480000] PM: Writing back config space on device 0000:0a:00.0 at offset 3 (was 0, writing 2010)
> Feb  1 13:10:26 localhost kernel: [17179588.480000] PM: Writing back config space on device 0000:0a:00.0 at offset 2 (was 2000000, writing 2000003)
> Feb  1 13:10:26 localhost kernel: [17179588.480000] PM: Writing back config space on device 0000:0a:00.0 at offset 1 (was 2b00000, writing 2b00006)
> Feb  1 13:10:26 localhost kernel: [17179588.480000] PM: Writing back config space on device 0000:0a:00.0 at offset 0 (was 165314e4, writing 165414e4)
> Feb  1 13:10:26 localhost kernel: [17179588.624000] Yenta: ISA IRQ mask 0x0c78, PCI irq 201
> Feb  1 13:10:26 localhost kernel: [17179588.624000] Socket status: 30000006
> Feb  1 13:10:26 localhost kernel: [17179588.624000] Yenta: Raising subordinate bus# of parent bus (#0a) from #0b to #0e
> Feb  1 13:10:26 localhost kernel: [17179588.624000] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
> Feb  1 13:10:26 localhost kernel: [17179588.624000] cs: IO port probe 0x2000-0x2fff: clean.
> Feb  1 13:10:26 localhost kernel: [17179588.624000] pcmcia: parent PCI bridge Memory window: 0xb0300000 - 0xb03fffff
> Feb  1 13:10:26 localhost kernel: [17179588.624000] pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x31ffffff
> Feb  1 13:10:26 localhost kernel: [17179588.788000] ts: Compaq touchscreen protocol output
> Feb  1 13:10:26 localhost kernel: [17179588.808000] sd 0:0:0:0: Attached scsi generic sg0 type 0
> Feb  1 13:10:26 localhost kernel: [17179588.808000] sr 1:0:0:0: Attached scsi generic sg1 type 5
> Feb  1 13:10:26 localhost kernel: [17179588.828000] usbcore: registered new driver hiddev
> Feb  1 13:10:26 localhost kernel: [17179588.844000] input: Genius       Optical Mouse as /class/input/input2
> Feb  1 13:10:26 localhost kernel: [17179588.844000] input: USB HID v1.10 Mouse [Genius       Optical Mouse] on usb-0000:00:1d.0-2
> Feb  1 13:10:26 localhost kernel: [17179588.844000] usbcore: registered new driver usbhid
> Feb  1 13:10:26 localhost kernel: [17179588.844000] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> Feb  1 13:10:26 localhost kernel: [17179588.896000] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> Feb  1 13:10:26 localhost kernel: [17179588.896000] Uniform CD-ROM driver Revision: 3.20
> Feb  1 13:10:26 localhost kernel: [17179588.896000] sr 1:0:0:0: Attached scsi CD-ROM sr0
> Feb  1 13:10:26 localhost kernel: [17179589.000000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 66
> Feb  1 13:10:26 localhost kernel: [17179589.000000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> Feb  1 13:10:26 localhost kernel: [17179589.172000] cs: IO port probe 0x100-0x3af: excluding 0x370-0x37f
> Feb  1 13:10:26 localhost kernel: [17179589.172000] cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3ff 0x4d0-0x4d7
> Feb  1 13:10:26 localhost kernel: [17179589.172000] cs: IO port probe 0x820-0x8ff: clean.
> Feb  1 13:10:26 localhost kernel: [17179589.176000] cs: IO port probe 0xc00-0xcf7: clean.
> Feb  1 13:10:26 localhost kernel: [17179589.176000] cs: IO port probe 0xa00-0xaff: clean.
> Feb  1 13:10:26 localhost kernel: [17179589.688000] lp0: using parport0 (interrupt-driven).
> Feb  1 13:10:26 localhost kernel: [17179589.716000] ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
> Feb  1 13:10:26 localhost kernel: [17179589.716000] ieee1394: sbp2: Try serialize_io=0 for better performance
> Feb  1 13:10:26 localhost kernel: [17179589.736000] ieee1394: raw1394: /dev/raw1394 device initialized
> Feb  1 13:10:26 localhost kernel: [17179589.828000] Adding 1052216k swap on /dev/disk/by-uuid/ebfac705-4c90-47b1-8e58-5e27c8f2aec5.  Priority:-1 extents:1 across:1052216k
> Feb  1 13:10:26 localhost kernel: [17179589.864000] NET: Registered protocol family 17
> Feb  1 13:10:26 localhost kernel: [17179590.092000] EXT3 FS on sda5, internal journal
> Feb  1 13:10:26 localhost kernel: [17179590.264000] md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
> Feb  1 13:10:26 localhost kernel: [17179590.264000] md: bitmap version 4.39
> Feb  1 13:10:26 localhost kernel: [17179590.424000] tg3: eth0: Link is up at 100 Mbps, full duplex.
> Feb  1 13:10:26 localhost kernel: [17179590.424000] tg3: eth0: Flow control is off for TX and off for RX.
> Feb  1 13:10:26 localhost kernel: [17179590.584000] device-mapper: 4.6.0-ioctl (2006-02-17) initialised: dm-devel@redhat.com
> Feb  1 13:10:26 localhost kernel: [17179590.588000] ipw3945: Radio Frequency Kill Switch is On:
> Feb  1 13:10:26 localhost kernel: [17179590.588000] Kill switch must be turned off for wireless networking to work.
> Feb  1 13:10:26 localhost kernel: [17179590.888000] NET: Registered protocol family 10
> Feb  1 13:10:26 localhost kernel: [17179590.888000] lo: Disabled Privacy Extensions
> Feb  1 13:10:26 localhost kernel: [17179590.888000] IPv6 over IPv4 tunneling driver
> Feb  1 13:10:26 localhost kernel: [17179592.376000] kjournald starting.  Commit interval 5 seconds
> Feb  1 13:10:26 localhost kernel: [17179592.384000] EXT3 FS on sda7, internal journal
> Feb  1 13:10:26 localhost kernel: [17179592.384000] EXT3-fs: mounted filesystem with ordered data mode.
> Feb  1 13:10:26 localhost kernel: [17179596.456000] ip_tables: (C) 2000-2006 Netfilter Core Team
> Feb  1 13:10:26 localhost kernel: [17179601.260000] ACPI: AC Adapter [ACAD] (on-line)
> Feb  1 13:10:26 localhost kernel: [17179601.300000] ACPI: Battery Slot [BAT1] (battery absent)
> Feb  1 13:10:26 localhost kernel: [17179601.300000] ACPI: Battery Slot [BAT2] (battery absent)
> Feb  1 13:10:26 localhost kernel: [17179601.316000] ACPI: Power Button (FF) [PWRF]
> Feb  1 13:10:26 localhost kernel: [17179601.316000] ACPI: Lid Switch [LID]
> Feb  1 13:10:26 localhost kernel: [17179601.316000] ACPI: Power Button (CM) [PWRB]
> Feb  1 13:10:26 localhost kernel: [17179601.316000] ACPI: Sleep Button (CM) [SLPB]
> Feb  1 13:10:26 localhost kernel: [17179601.320000] eth0: no IPv6 routers present
> Feb  1 13:10:26 localhost kernel: [17179601.352000] ACPI: ACPI Dock Station Driver 
> Feb  1 13:10:26 localhost kernel: [17179601.432000] ibm_acpi: ec object not found
> Feb  1 13:10:26 localhost kernel: [17179601.476000] pcc_acpi: loading...
> Feb  1 13:10:26 localhost kernel: [17179601.532000] wmi_add device=df4bc400
> Feb  1 13:10:26 localhost kernel: [17179601.532000] calling WQBA
> Feb  1 13:10:26 localhost kernel: [17179601.592000] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> Feb  1 13:10:28 localhost kernel: [17179603.804000] [drm] Initialized drm 1.0.1 20051102
> Feb  1 13:10:28 localhost kernel: [17179603.804000] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 177
> Feb  1 13:10:28 localhost kernel: [17179603.804000] [drm] Initialized i915 1.5.0 20060119 on minor 0
> Feb  1 13:10:28 localhost kernel: [17179604.460000] apm: BIOS not found.
> Feb  1 13:10:40 localhost kernel: [17179615.932000] Bluetooth: Core ver 2.8
> Feb  1 13:10:40 localhost kernel: [17179615.932000] NET: Registered protocol family 31
> Feb  1 13:10:40 localhost kernel: [17179615.932000] Bluetooth: HCI device and connection manager initialized
> Feb  1 13:10:40 localhost kernel: [17179615.932000] Bluetooth: HCI socket layer initialized
> Feb  1 13:10:40 localhost kernel: [17179615.964000] Bluetooth: L2CAP ver 2.8
> Feb  1 13:10:40 localhost kernel: [17179615.964000] Bluetooth: L2CAP socket layer initialized
> Feb  1 13:10:40 localhost kernel: [17179616.020000] Bluetooth: HIDP (Human Interface Emulation) ver 1.1-mh1
> Feb  1 13:10:40 localhost kernel: [17179616.052000] Bluetooth: RFCOMM socket layer initialized
> Feb  1 13:10:40 localhost kernel: [17179616.052000] Bluetooth: RFCOMM TTY layer initialized
> Feb  1 13:10:40 localhost kernel: [17179616.052000] Bluetooth: RFCOMM ver 1.7
> Feb  1 13:10:46 localhost kernel: [17179621.984000] eth0: no IPv6 routers present
> 
> 
> !DSPAM:45c1f71039252073178845!


-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
