Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbXIZC0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbXIZC0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXIZC0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:26:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:32884 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbXIZC0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=EKdPYaF4tNdLFcKdU3zFKcl7dSZMjC1V8QH5xh68dc1RM2j0E4lQeB2wijj5GTdptru0rPC5kKXbnLkhzUKPCSnVl1g+QaVef4qEPpMR4IN4TkxkNvhTWsqBXSUqi3TBcFqxRSY5BNXr0RxbaxrNTy14Cles9J0zqrETCzEQXb0=
Message-ID: <46F9C336.3010005@gmail.com>
Date: Tue, 25 Sep 2007 20:25:58 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F9617F.1010508@gmail.com> <46F9B3FE.1060905@garzik.org>
In-Reply-To: <46F9B3FE.1060905@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------060702030609080608070802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060702030609080608070802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Does the attached patch change behavior at all?  You should be able to
> apply it on top of libata-dev.git#upstream or -mm.

Still broken, dmesg with ATA_DEBUG defined, attached.

--------------060702030609080608070802
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] Linux version 2.6.23-rc8-mm1 (root@luna) (gcc version 4.2.1 (Debian 4.2.1-5)) #1 SMP Tue Sep 25 20:11:10 MDT 2007
[    0.000000] Command line: root=/dev/sde1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff80000 (usable)
[    0.000000]  BIOS-e820: 000000003ff80000 - 000000003ff8e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff8e000 - 000000003ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3FF80100, 0064 (r1 NEC              3000707 MSFT       97)
[    0.000000] ACPI: FACP 3FF80290, 00F4 (r3 A_M_I_ OEMFACP   3000707 MSFT       97)
[    0.000000] ACPI: DSDT 3FF80590, 9560 (r1  A0543 A0543000        0 INTL 20060113)
[    0.000000] ACPI: FACS 3FF8E000, 0040
[    0.000000] ACPI: APIC 3FF80390, 0080 (r1 A_M_I_ OEMAPIC   3000707 MSFT       97)
[    0.000000] ACPI: SLIC 3FF80410, 0176 (r1 NEC              3000707 MSFT       97)
[    0.000000] ACPI: OEMB 3FF8E040, 0066 (r1 A_M_I_ AMI_OEM   3000707 MSFT       97)
[    0.000000] ACPI: HPET 3FF89AF0, 0038 (r1 A_M_I_ OEMHPET   3000707 MSFT       97)
[    0.000000] ACPI: MCFG 3FF89B30, 003C (r1 A_M_I_ OEMMCFG   3000707 MSFT       97)
[    0.000000] ACPI: SSDT 3FF8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
[    0.000000] ACPI: SSDT 3FF8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262016
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bfb00000)
[    0.000000] .eh_frame_hdr for 'kernel' present but unusable
[    0.000000] PERCPU: Allocating 28328 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257187
[    0.000000] Kernel command line: root=/dev/sde1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against HPET
[    0.000000] time.c: Detected 2564.906 MHz processor.
[    0.006666] Console: colour VGA+ 80x25
[    0.006666] console [tty0] enabled
[    0.009999] console [ttyS0] enabled
[    0.013333] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.016666] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.019999] Checking aperture...
[    0.029999] Memory: 1026692k/1048064k available (2448k kernel code, 20804k reserved, 1590k data, 224k init)
[    0.116666] Calibrating delay using timer specific routine.. 5134.53 BogoMIPS (lpj=8554463)
[    0.123333] Mount-cache hash table entries: 256
[    0.129999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.133333] CPU: L2 cache: 2048K
[    0.136666] using mwait in idle threads.
[    0.139999] CPU: Physical Processor ID: 0
[    0.143333] CPU: Processor Core ID: 0
[    0.146666] CPU0: Thermal monitoring enabled (TM2)
[    0.149999] Freeing SMP alternatives: 27k freed
[    0.153333] ACPI: Core revision 20070126
[    0.196666] Using local APIC timer interrupts.
[    0.203333] Detected 22.900 MHz APIC timer.
[    0.206666] Booting processor 1/2 APIC 0x1
[    0.219999] Initializing CPU#1
[    0.303333] Calibrating delay using timer specific routine.. 5131.57 BogoMIPS (lpj=8549719)
[    0.303333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.303333] CPU: L2 cache: 2048K
[    0.303333] CPU: Physical Processor ID: 0
[    0.303333] CPU: Processor Core ID: 1
[    0.303333] CPU1: Thermal monitoring enabled (TM2)
[    0.303333] Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[    0.303333] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.306666] Brought up 2 CPUs
[    0.309999] net_namespace: 112 bytes
[    0.313531] NET: Registered protocol family 16
[    0.318112] ACPI: bus type pci registered
[    0.322207] PCI: Using configuration type 1
[    0.337398] ACPI: Interpreter enabled
[    0.341098] ACPI: Using IOAPIC for interrupt routing
[    0.346136] PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 63
[    0.355363] PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
[    0.363718] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.374808] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.379945] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.386433] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.392739] PCI: Transparent bridge - 0000:00:1e.0
[    0.400270] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.407971] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.415675] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.423374] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.431067] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.438758] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.451973] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.459665] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.467354] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  1B, should be 12 [20070126]
[    0.477153] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.482867] pnp: PnP ACPI init
[    0.485963] ACPI: bus type pnp registered
[    0.492544] pnp: PnP ACPI: found 15 devices
[    0.496765] ACPI: ACPI bus type pnp unregistered
[    0.501556] SCSI subsystem initialized
[    0.505409] PCI: Using ACPI for IRQ routing
[    0.509635] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.531058] DMAR:No DMAR devices found
[    0.534852] PCI-GART: No AMD northbridge found.
[    0.539423] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.544509] hpet0: 3 64-bit timers, 14318180 Hz
[    0.551056] Time: tsc clocksource has been installed.
[    0.556149] Switched to high resolution mode on CPU 1
[    0.556152] Switched to high resolution mode on CPU 0
[    0.571142] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.578140] pnp: 00:07: ioport range 0x290-0x297 has been reserved
[    0.584355] pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.591351] pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.598350] pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.605348] pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.612707] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.619701] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.627058] pnp: 00:0d: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.634055] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.640531] pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved
[    0.647009] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.653827] pnp: 00:0e: iomem range 0x100000-0x3fffffff could not be reserved
[    0.661200] PCI: Bridge: 0000:00:01.0
[    0.664902]   IO window: disabled.
[    0.668341]   MEM window: faa00000-feafffff
[    0.672557]   PREFETCH window: cff00000-efefffff
[    0.677210] PCI: Bridge: 0000:00:1c.0
[    0.680907]   IO window: disabled.
[    0.684347]   MEM window: disabled.
[    0.687872]   PREFETCH window: cfe00000-cfefffff
[    0.692524] PCI: Bridge: 0000:00:1c.3
[    0.696222]   IO window: c000-cfff
[    0.699955]   MEM window: fa900000-fa9fffff
[    0.704174]   PREFETCH window: disabled.
[    0.708132] PCI: Bridge: 0000:00:1c.5
[    0.711830]   IO window: b000-bfff
[    0.715269]   MEM window: fa800000-fa8fffff
[    0.719488]   PREFETCH window: disabled.
[    0.723446] PCI: Bridge: 0000:00:1e.0
[    0.727144]   IO window: a000-afff
[    0.730583]   MEM window: fa600000-fa7fffff
[    0.734800]   PREFETCH window: 50000000-500fffff
[    0.739459] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.746952] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.754445] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.761939] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
[    0.769452] NET: Registered protocol family 2
[    0.804350] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.811710] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[    0.820186] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.827405] TCP: Hash tables configured (established 131072 bind 65536)
[    0.834057] TCP reno registered
[    0.845147] audit: initializing netlink socket (disabled)
[    0.850593] audit(1190751453.800:1): initialized
[    0.855405] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.862753] io scheduler noop registered
[    0.866727] io scheduler cfq registered (default)
[    0.872372] assign_interrupt_mode Found MSI capability
[    0.877636] assign_interrupt_mode Found MSI capability
[    0.882944] assign_interrupt_mode Found MSI capability
[    0.888226] assign_interrupt_mode Found MSI capability
[    0.893583] input: Power Button (FF) as /class/input/input0
[    0.899191] ACPI: Power Button (FF) [PWRF]
[    0.903393] input: Power Button (CM) as /class/input/input1
[    0.909004] ACPI: Power Button (CM) [PWRB]
[    0.913359] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._OSC] (Node ffff810002057b30), AE_ALREADY_EXISTS
[    0.925187] ACPI: Marking method _OSC as Serialized
[    0.930227] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PDC] (Node ffff810002057b50), AE_ALREADY_EXISTS
[    0.942060] ACPI: Marking method _PDC as Serialized
[    0.947284] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.953680] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._OSC] (Node ffff810002057a10), AE_ALREADY_EXISTS
[    0.965508] ACPI: Marking method _OSC as Serialized
[    0.970543] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PDC] (Node ffff810002057a30), AE_ALREADY_EXISTS
[    0.982371] ACPI: Marking method _PDC as Serialized
[    0.987582] ACPI: Processor [CPU2] (supports 8 throttling states)
[    1.021742] Real Time Clock Driver v1.12ac
[    1.026375] intel_rng: FWH not detected
[    1.030595] Linux agpgart interface v0.102
[    1.034742] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    1.042728] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.049102] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.054977] ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    1.272479] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[    1.272480]         <Adaptec 2940 Ultra2 SCSI adapter>
[    1.272481]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[    1.272482] 
[    1.293422] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
[    1.301271] ata_host_alloc: ENTER
[    1.304634] ata_port_alloc: ENTER
[    1.307989] ata_port_alloc: ENTER
[    1.311343] ata_port_alloc: ENTER
[    1.314704] ata_port_alloc: ENTER
[    1.553158] scsi 0:0:1:0: Direct-Access     IBM-PCCO ST39102LC     !# B219 PQ: 0 ANSI: 2
[    1.561296] scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
[    1.566782]  target0:0:1: Beginning Domain Validation
[    1.578308]  target0:0:1: wide asynchronous
[    1.587229]  target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    1.598475]  target0:0:1: Domain Validation skipping write tests
[    1.604520]  target0:0:1: Ending Domain Validation
[    1.612367] scsi 0:0:2:0: Direct-Access     SGI      SEAGATE ST39102L 2702 PQ: 0 ANSI: 2
[    1.620506] scsi0:A:2:0: Tagged Queuing enabled.  Depth 8
[    1.625990]  target0:0:2: Beginning Domain Validation
[    1.636363]  target0:0:2: wide asynchronous
[    1.644463]  target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    1.654889]  target0:0:2: Domain Validation skipping write tests
[    1.660932]  target0:0:2: Ending Domain Validation
[    2.316829] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.324959] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    2.331805] __ata_port_freeze: ata4294967295 port frozen
[    2.337168] __ata_port_freeze: ata4294967295 port frozen
[    2.342539] __ata_port_freeze: ata4294967295 port frozen
[    2.347909] __ata_port_freeze: ata4294967295 port frozen
[    2.353278] scsi1 : ahci
[    2.355887] scsi2 : ahci
[    2.358500] scsi3 : ahci
[    2.361107] scsi4 : ahci
[    2.363708] ata1: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfb900 irq 315
[    2.371238] ata2: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfb980 irq 315
[    2.378762] ata3: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfba00 irq 315
[    2.386290] ata4: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfba80 irq 315
[    2.393817] ata_host_register: probe begin
[    2.397952] ata_port_schedule_eh: port EH scheduled
[    2.402872] ata_scsi_error: ENTER
[    2.406223] ata_port_flush_task: ENTER
[    2.410011] ata_eh_link_autopsy: ENTER
[    2.413794] ata_eh_recover: ENTER
[    2.417145] __ata_port_freeze: ata1 port frozen
[    2.733272] ahci_do_softreset: ENTER
[    2.896512] ata_dev_classify: found ATA device by sig
[    2.901597] ahci_do_softreset: EXIT, class=1
[    2.905901] ata_std_postreset: ENTER
[    2.909513] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.915725] ata_std_postreset: EXIT
[    2.919248] ata_eh_thaw_port: ata1 port thawed
[    2.923727] ata_eh_revalidate_and_attach: ENTER
[    2.928314] ata_sg_setup: 1 sg elements mapped
[    2.933522] ata_port_flush_task: ENTER
[    2.937369] ata_port_flush_task: ENTER
[    2.941155] ata1.00: ATA-7: ST3250823AS, 3.03, max UDMA/133
[    2.946760] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.953660] ata_dev_set_xfermode: set features - xfer mode
[    2.959279] ata_port_flush_task: ENTER
[    2.963069] ata_dev_set_xfermode: EXIT, err_mask=0
[    2.967914] ata_sg_setup: 1 sg elements mapped
[    2.973100] ata_port_flush_task: ENTER
[    2.976950] ata_port_flush_task: ENTER
[    2.980738] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[    2.991591] ata1.00: configured for UDMA/133
[    2.995896] ata_eh_recover: EXIT, rc=0
[    2.999680] ata_scsi_error: EXIT
[    3.002946] ata_port_schedule_eh: port EH scheduled
[    3.002947] ata_scsi_error: ENTER
[    3.002949] ata_port_flush_task: ENTER
[    3.014992] ata_eh_link_autopsy: ENTER
[    3.018779] ata_eh_recover: ENTER
[    3.022130] __ata_port_freeze: ata2 port frozen
[    3.339623] ahci_do_softreset: ENTER
[    3.502887] ata_dev_classify: fod_ ATA device by sig
[    3.507977] ahci_do_softreset: EXIT, class=1
[    3.512280] ata_std_postreset: ENTER
[    3.515893] ata2: SATA link up 3.0 Gbps (SStatus 123 SCont 3300)
[    3.522105] ata_std_postreset: EXIT
[    3.525628] ata_eh_thaw_port: ata2 port thawed
[    3.530106] ata_eh_revalidate_an_0attach: ENTER
[    3.534695] ata_sg_setup: 1 sg elements mapped
[    4.751938] sd 0:0:1:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
[    4.760821] sd 0:0:1:0: [sda] Write Protect is off
[    4.767221] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.776605] sd 0:0:1:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
[    4.785488] sd 0:0:1:0: [sda] Write Protect is off
[    4.791900] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.800470]  sda: sda1 sda2
[    4.811450] sd 0:0:1:0: [sda] Attached SCSI disk
[    4.816162] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    4.822332] sd 0:0:2:0: [sdb] 17781520 512-byte hardware sectors (9104 MB)
[    4.832615] sd 0:0:2:0: [sdb] Write Protect is off
[    4.841211] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.850578] sd 0:0:2:0: [sdb] 17781520 512-byte hardware sectors (9104 MB)
[    4.860855] sd 0:0:2:0: [sdb] Write Protect is off
[    4.869451] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.878017]  sdb: sdb1
[    4.890330] sd 0:0:2:0: [sdb] Attached SCSI disk
[    4.895028] sd 0:0:2:0: Attached scsi generic sg1 type 0
[   33.520602] ata_port_flush_task: ENTER
[   33.524392] __ata_port_freeze: ata2 port frozen
[   33.528953] ata2.00: qc timeout (cmd 0xec)
[   33.533087] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   33.539210] ata_eh_revalidate_and_attach: EXIT rc=-5
[   33.544207] ata2: failed to recover some devices, retrying in 5 secs
[   38.551318] __ata_port_freeze: ata2 port frozen
[   38.555888] ahci_hardreset: ENTER
[   38.559240] sata_std_hardreset: ENTER
[   38.562937] sata_link_hardreset: ENTER
[   38.884474] sata_link_hardreset: EXIT, rc=0
[   44.051785] ata2: port is slow to respond, please be patient (Status 0x80)
[   48.589425] ata2: COMRESET failed (errno=-16)
[   48.593817] ahci_hardreset: EXIT, rc=-16, class=5
[   48.598554] ahci_hardreset: ENTER
[   48.601905] sata_std_hardreset: ENTER
[   48.605604] sata_link_hardreset: ENTER
[   48.925920] sata_link_hardreset: EXIT, rc=0
[   49.295725] ata_dev_classify: found ATA device by sig
[   49.300810] sata_std_hardreset: EXIT, class=1
[   49.305201] ata_dev_classify: found ATA device by sig
[   49.310285] ahci_hardreset: EXIT, rc=0, class=1
[   49.314849] ata_std_postreset: ENTER
[   49.318461] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   49.324673] ata_std_postreset: EXIT
[   49.328196] ata_eh_thaw_port: ata2 port thawed
[   49.332674] ata_eh_revalidate_and_attach: ENTER
[   49.337262] ata_sg_setup: 1 sg elements mapped
[   49.341772] ata_port_flush_task: ENTER
[   49.345571] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
[   49.351609] ata2.00: 640 sectors, multi 1: LBA 
[   49.356173] ata_dev_set_xfermode: set features - xfer mode
[   49.361710] ata_port_flush_task: ENTER
[   49.365493] ata_dev_set_xfermode: EXIT, err_mask=0
[   49.370341] ata_sg_setup: 1 sg elements mapped
[   49.374850] ata_port_flush_task: ENTER
[   49.378639] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   49.384246] ata2.00: configured for UDMA/133
[   49.388549] ata_eh_recover: EXIT, rc=0
[   49.392337] ata_eh_link_autopsy: ENTER
[   49.396120] ata_eh_link_autopsy: EXIT
[   49.399817] ata_eh_recover: ENTER
[   49.403169] ata_eh_revalidate_and_attach: ENTER
[   49.407734] ata_eh_recover: EXIT, rc=0
[   49.411522] ata_scsi_error: EXIT
[   49.422330] ata_port_schedule_eh: port EH scheduled
[   49.427244] ata_scsi_error: ENTER
[   49.430592] ata_port_flush_task: ENTER
[   49.434378] ata_eh_link_autopsy: ENTER
[   49.438163] ata_eh_recover: ENTER
[   49.441516] __ata_port_freeze: ata3 port frozen
[   49.758820] ahci_do_softreset: ENTER
[   49.922059] ata_dev_classify: found ATA device by sig
[   49.927144] ahci_do_softreset: EXIT, class=1
[   49.931450] ata_std_postreset: ENTER
[   49.935060] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   49.941272] ata_std_postreset: EXIT
[   49.944795] ata_eh_thaw_port: ata3 port thawed
[   49.949273] ata_eh_revalidate_and_attach: ENTER
[   49.953861] ata_sg_setup: 1 sg elements mapped
[   49.960662] ata_port_flush_task: ENTER
[   49.965491] ata_port_flush_task: ENTER
[   49.969276] ata3.00: ATA-6: WDC WD360GD-00FLA2, 31.08F31, max UDMA/133
[   49.975833] ata3.00: 72303840 sectors, multi 16: LBA48 
[   49.981088] ata_dev_set_xfermode: set features - xfer mode
[   49.987646] ata_port_flush_task: ENTER
[   49.991430] ata_dev_set_xfermode: EXIT, err_mask=0
[   49.996278] ata_sg_setup: 1 sg elements mapped
[   50.003075] ata_port_flush_task: ENTER
[   50.007870] ata_port_flush_task: ENTER
[   50.011657] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   50.017259] ata3.00: configured for UDMA/133
[   50.021564] ata_eh_recover: EXIT, rc=0
[   50.025349] ata_scsi_error: EXIT
[   50.028613] ata_port_schedule_eh: port EH scheduled
[   50.029498] ata_scsi_error: ENTER
[   50.029499] ata_port_flush_task: ENTER
[   50.040660] ata_eh_link_autopsy: ENTER
[   50.044448] ata_eh_recover: ENTER
[   50.047799] __ata_port_freeze: ata4 port frozen
[   50.365172] ahci_do_softreset: ENTER
[   50.528411] ata_dev_classify: found ATAPI device by sig
[   50.533670] ahci_do_softreset: EXIT, class=3
[   50.537976] ata_std_postreset: ENTER
[   50.541588] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   50.547800] ata_std_postreset: EXIT
[   50.551333] ata_eh_thaw_port: ata4 port thawed
[   50.555809] ata_eh_revalidate_and_attach: ENTER
[   50.711667] ata_sg_setup: 1 sg elements mapped
[   50.716623] ata_port_flush_task: ENTER
[   50.720423] ata4.00: ATAPI: Optiarc DVD RW AD-7170S, 1.00, max UDMA/66
[   50.726983] ata_dev_set_xfermode: set features - xfer mode
[   50.732645] ata_port_flush_task: ENTER
[   50.736430] ata_dev_set_xfermode: EXIT, err_mask=0
[   50.891575] ata_sg_setup: 1 sg elements mapped
[   50.896532] ata_port_flush_task: ENTER
[   50.900325] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x44
[   50.905928] ata4.00: configured for UDMA/66
[   50.910146] ata_eh_recover: EXIT, rc=0
[   50.913931] ata_scsi_error: EXIT
[   50.924880] ata_host_register: host probe begin
[   50.929464] ata_scsi_dump_cdb: CDB (1:0,0,0) 12 00 00 00 24 00 00 00 00
[   50.936130] ata_scsi_dump_cdb: CDB (1:0,0,0) 12 00 00 00 60 00 00 00 00
[   50.942788] scsi 1:0:0:0: Direct-Access     ATA      ST3250823AS      3.03 PQ: 0 ANSI: 5
[   50.950993] ata_scsi_dump_cdb: CDB (1:0,0,0) 00 00 00 00 00 00 00 00 00
[   50.957784] ata_scsi_dump_cdb: CDB (1:0,0,0) 25 00 00 00 00 00 00 00 00
[   50.964435] sd 1:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[   50.971605] ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 3f 00 00 00 00 00 08
[   50.978256] sd 1:0:0:0: [sdc] Write Protect is off
[   50.983088] ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 08
[   50.989743] ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 24
[   50.996395] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   51.005495] ata_scsi_dump_cdb: CDB (1:0,0,0) 00 00 00 00 00 00 00 00 24
[   51.012196] ata_scsi_dump_cdb: CDB (1:0,0,0) 25 00 00 00 00 00 00 00 00
[   51.018847] sd 1:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[   51.026016] ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 3f 00 00 00 00 00 08
[   51.032669] sd 1:0:0:0: [sdc] Write Protect is off
[   51.037502] ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 08
[   51.044155] ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 24
[   51.050806] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   51.059894]  sdc:<3>ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 00 00 00 00 00 00 08
[   51.067292] ata_sg_setup: 1 sg elements mapped
[   51.089928]  sdc1 sdc2
[   51.092504] sd 1:0:0:0: [sdc] Attached SCSI disk
[   51.097208] sd 1:0:0:0: Attached scsi generic sg2 type 0
[   51.102573] ata_scsi_dump_cdb: CDB (2:0,0,0) 12 00 00 00 24 00 00 00 00
[   51.109231] ata_scsi_dump_cdb: CDB (2:0,0,0) 12 00 00 00 60 00 00 00 00
[   51.115889] scsi 2:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 ANSI: 5
[   51.124126] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.130784] ata_scsi_timed_out: ENTER
[   51.134485] ata_scsi_timed_out: EXIT, ret=0
[   51.138706] ata_scsi_error: ENTER
[   51.142058] ata_port_flush_task: ENTER
[   51.145849] ata_eh_link_autopsy: ENTER
[   51.149639] ata_eh_link_autopsy: EXIT
[   51.158588] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.165065] ata2.00: irq_stat 0x40000001
[   51.169023] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.169024]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.184496] ata2.00: status: {DRDY ERR }
[   51.188458] ata2.00: error: {ABRT }
[   51.191982] ata_eh_recover: ENTER
[   51.195335] ata_eh_revalidate_and_attach: ENTER
[   51.199923] ata_sg_setup: 1 sg elements mapped
[   51.204434] ata_port_flush_task: ENTER
[   51.208234] ata_dev_set_xfermode: set features - xfer mode
[   51.213770] ata_port_flush_task: ENTER
[   51.217555] ata_dev_set_xfermode: EXIT, err_mask=0
[   51.222400] ata_sg_setup: 1 sg elements mapped
[   51.226910] ata_port_flush_task: ENTER
[   51.230699] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   51.236306] ata2.00: configured for UDMA/133
[   51.240611] ata_eh_recover: EXIT, rc=0
[   51.244397] ata2: EH complete
[   51.247401] ata_scsi_error: EXIT
[   51.250666] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.257319] ata_scsi_timed_out: ENTER
[   51.261017] ata_scsi_timed_out: EXIT, ret=0
[   51.265238] ata_scsi_error: ENTER
[   51.268586] ata_port_flush_task: ENTER
[   51.272374] ata_eh_link_autopsy: ENTER
[   51.276156] ata_eh_link_autopsy: EXIT
[   51.279857] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.286329] ata2.00: irq_stat 0x40000001
[   51.290286] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.290287]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.305758] ata2.00: status: {DRDY ERR }
[   51.309721] ata2.00: error: {ABRT }
[   51.313245] ata_eh_recover: ENTER
[   51.316597] ata_eh_revalidate_and_attach: ENTER
[   51.321185] ata_sg_setup: 1 sg elements mapped
[   51.325695] ata_port_flush_task: ENTER
[   51.329488] ata_dev_set_xfermode: set features - xfer mode
[   51.335023] ata_port_flush_task: ENTER
[   51.338808] ata_dev_set_xfermode: EXIT, err_mask=0
[   51.343653] ata_sg_setup: 1 sg elements mapped
[   51.348163] ata_port_flush_task: ENTER
[   51.351955] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   51.357563] ata2.00: configured for UDMA/133
[   51.361872] ata_eh_recover: EXIT, rc=0
[   51.365657] ata2: EH complete
[   51.368659] ata_scsi_error: EXIT
[   51.371929] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.378581] ata_scsi_timed_out: ENTER
[   51.382279] ata_scsi_timed_out: EXIT, ret=0
[   51.386500] ata_scsi_error: ENTER
[   51.389848] ata_port_flush_task: ENTER
[   51.393636] ata_eh_link_autopsy: ENTER
[   51.397419] ata_eh_link_autopsy: EXIT
[   51.401118] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.407590] ata2.00: irq_stat 0x40000001
[   51.411547] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.411548]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.427020] ata2.00: status: {DRDY ERR }
[   51.430982] ata2.00: error: {ABRT }
[   51.434508] ata_eh_recover: ENTER
[   51.437858] ata_eh_revalidate_and_attach: ENTER
[   51.442448] ata_sg_setup: 1 sg elements mapped
[   51.446959] ata_port_flush_task: ENTER
[   51.450758] ata_dev_set_xfermode: set features - xfer mode
[   51.456294] ata_port_flush_task: ENTER
[   51.460079] ata_dev_set_xfermode: EXIT, err_mask=0
[   51.464924] ata_sg_setup: 1 sg elements mapped
[   51.469434] ata_port_flush_task: ENTER
[   51.473225] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   51.478832] ata2.00: configured for UDMA/133
[   51.483134] ata_eh_recover: EXIT, rc=0
[   51.486921] ata2: EH complete
[   51.489924] ata_scsi_error: EXIT
[   51.493190] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.499842] ata_scsi_timed_out: ENTER
[   51.503540] ata_scsi_timed_out: EXIT, ret=0
[   51.507761] ata_scsi_error: ENTER
[   51.511111] ata_port_flush_task: ENTER
[   51.514899] ata_eh_link_autopsy: ENTER
[   51.518683] ata_eh_link_autopsy: EXIT
[   51.522380] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.528853] ata2.00: irq_stat 0x40000001
[   51.532810] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.532811]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.548282] ata2.00: status: {DRDY ERR }
[   51.552245] ata2.00: error: {ABRT }
[   51.555769] ata_eh_recover: ENTER
[   51.559122] ata_eh_revalidate_and_attach: ENTER
[   51.563710] ata_sg_setup: 1 sg elements mapped
[   51.568220] ata_port_flush_task: ENTER
[   51.572020] ata_dev_set_xfermode: set features - xfer mode
[   51.577555] ata_port_flush_task: ENTER
[   51.581340] ata_dev_set_xfermode: EXIT, err_mask=0
[   51.586186] ata_sg_setup: 1 sg elements mapped
[   51.590700] ata_port_flush_task: ENTER
[   51.594496] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   51.600102] ata2.00: configured for UDMA/133
[   51.604405] ata_eh_recover: EXIT, rc=0
[   51.608190] ata2: EH complete
[   51.611194] ata_scsi_error: EXIT
[   51.614461] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.621114] ata_scsi_timed_out: ENTER
[   51.624810] ata_scsi_timed_out: EXIT, ret=0
[   51.629033] ata_scsi_error: ENTER
[   51.632389] ata_port_flush_task: ENTER
[   51.636178] ata_eh_link_autopsy: ENTER
[   51.639960] ata_eh_link_autopsy: EXIT
[   51.643658] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.650132] ata2.00: irq_stat 0x40000001
[   51.654090] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.654090]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.669572] ata2.00: status: {DRDY ERR }
[   51.673531] ata2.00: error: {ABRT }
[   51.677058] ata_eh_recover: ENTER
[   51.680408] ata_eh_revalidate_and_attach: ENTER
[   51.684998] ata_sg_setup: 1 sg elements mapped
[   51.689509] ata_port_flush_task: ENTER
[   51.693308] ata_dev_set_xfermode: set features - xfer mode
[   51.698843] ata_port_flush_task: ENTER
[   51.702628] ata_dev_set_xfermode: EXIT, err_mask=0
[   51.707474] ata_sg_setup: 1 sg elements mapped
[   51.711983] ata_port_flush_task: ENTER
[   51.715775] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   51.721381] ata2.00: configured for UDMA/133
[   51.725684] ata_eh_recover: EXIT, rc=0
[   51.729469] ata2: EH complete
[   51.732475] ata_scsi_error: EXIT
[   51.735740] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.742394] ata_scsi_timed_out: ENTER
[   51.746091] ata_scsi_timed_out: EXIT, ret=0
[   51.750312] ata_scsi_error: ENTER
[   51.753660] ata_port_flush_task: ENTER
[   51.757450] ata_eh_link_autopsy: ENTER
[   51.761239] ata_eh_link_autopsy: EXIT
[   51.764937] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.771411] ata2.00: irq_stat 0x40000001
[   51.775368] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.775369]          res 51/04:00:01:01:80/00:00:00:00:00/a0  error: {ABRT }
[   51.798329] ata_eh_recover: ENTER
[   51.801679] ata_eh_revalidate_and_attach: ENTER
[   51.806269] ata_s_xfermode: set features - xfer mode
[   51.820114] ata_port_flush_task: ENTER
[   51.823898] ata_dev_set_xfermode: EXIT, err_
[   51.846963] ata_eh_recover: EXIT, rc=0
[   51.850749] ata2: EH complete
[   51.853753] ata_scsi_error: EXIT
[   51.8570NTER
[   51.867370] ata_scsi_timed_out: EXIT, ret=0
[   51.871591] ata_scsi_error: ENTER
[   51.874940] ata_port_flush_task: ENTER
[   51.878727] ata_eh_link_autopsy: ENTER
[   51.882509] ata_eh_link_autopsy: EXIT
[   51.886209] ata2.00: exception 1/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.917364] ata2.00: status: {DRDY ERR }
[   51.921322] ata2.0recover: ENTER
[   51.928199] ata_eh_revalidate_and_attach: ENTER
[   51.932789] ata_sg_setup: 1 sg elements mapped
[   51.9  51.946633] ata_port_flush_task: ENTER
[   51.950418] ata_dev_set_xfermode: EXIT, err_mask=0
[   51.955266] ata_sg_setup: 1 _shift=12, xfer_mode=0x46
[   51.969181] ata2.00: configured for UDMA/133
[   51.973483] ata_eh_recover: EXIT, rc=0
[   51.9 (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   51.990193] ata_scsi_timed_out: ENTER
[   51.993889] ata_scsi_timed_out: EXIT, ret=0a_eh_link_autopsy: ENTER
[   52.009030] ata_eh_link_autopsy: EXIT
[   52.012728] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0k 0x1 (device error)
[   52.038640] ata2.00: status: {DRDY ERR }
[   52.042603] ata2.00: error: {ABRT }
[   52.046126] ata_e sg elements mapped
[   52.058580] ata_port_flush_task: ENTER
[   52.062376] ata_dev_set_xfermode: set features - xfer mode
  52.076544] ata_sg_setup: 1 sg elements mapped
[   52.081054] ata_port_flush_task: ENTER
[   52.084852] ata_dev_set_mode: xfrecover: EXIT, rc=0
[   52.098549] ata2: EH complete
[   52.101550] ata_scsi_error: EXIT
[   52.104820] ata_scsi_dump_cdb: Ca_scsi_timed_out: EXIT, ret=0
[   52.119389] ata_scsi_error: ENTER
[   52.122737] ata_port_flush_task: ENTER
[   52.126527] on Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.140479] ata2.00: irq_stat 0x40000001
[   52.144440] ata2.00: cmd e5/00:00:00{ABRT }
[   52.167405] ata_eh_recover: ENTER
[   52.170758] ata_eh_revalidate_and_attach: ENTER
[   52.175346] ata_sg_setup:e: set features - xfer mode
[   52.189183] ata_port_flush_task: ENTER
[   52.192968] ata_dev_set_xfermode: EXIT, err_mask=0
216034] ata_eh_recover: EXIT, rc=0
[   52.219819] ata2: EH complete
[   52.222823] ata_scsi_error: EXIT
[   52.226090] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   52.232743] ata_scsi_timed_out: ENTER
[   52.236438] ata_scsi_timedata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.261752] ata2.00: irq_stat 0x40000001
[   52.265709] ata2.00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.281190] ata2.00: status: {DRDY ERR }
[   52.285152] ata2.00: error[   52.296617] ata_sg_setup: 1 sg elements mapped
[   52.301129] ata_port_flush_task: ENTER
[   52.304926] ata_dev_set_xfermoxfermode: EXIT, err_mask=0
[   52.319093] ata_sg_setup: 1 sg elements mapped
[   52.323604] ata_port_flush_task: ENTER
[   5or: EXIT
[   52.347360] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   52.354013] ata_scsi_timed_out: ENTER
[   52.357710] ata_scsi_timed_out: EXIT, ret=0
[   52.361930] ata_scsi_error: ENTER
[   52.365280] ata_port_flush_task: ENTE001
[   52.386988] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.386989]          res 51/04:0[   52.406434] ata2.00: error: {ABRT }
[   52.409955] ata_eh_recover: ENTER
[   52.413308] ata_eh_revalidate_and_attach: ENTE 52.426207] ata_dev_set_xfermode: set features - xfer mode
[   52.431743] ata_port_flush_task: ENTER
[   52.435526] ata_dev_s_port_flush_task: ENTER
[   52.448682] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   52.454289] ata2.00: configured for1] ata_scsi_error: EXIT
[   52.468649] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   52.475304] ata_scsi_ti_autopsy: EXIT
[   52.497855] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.504327] ata2.00: irq_stat 0x40000001
[   52.508284] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.508285]          res 51/0h_revalidate_and_attach: ENTER
[   52.539185] ata_sg_setup: 1 sg elements mapped
[   52.543696] ata_port_flush_task: ENTER
[ER
[   52.556815] ata_dev_set_xfermode: EXIT, err_mask=0
[   52.561661] ata_sg_setup: 1 sg elements mapped
[   52.566170] at
[   52.586659] ata_scsi_error: EXIT
[   52.589928] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   52.59658417] ata_eh_link_autopsy: EXIT
[   52.619115] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.625590] ata2.00: irq_stat 0x40000001
[   52.629547] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.629548]  .655866] ata_eh_revalidate_and_attach: ENTER
[   52.660455] ata_sg_setup: 1 sg elements mapped
[   52.664964] ata_port_flush_task: ENTER
[   52.674003] ata_dev_set_xfermode: set features - xfer mode
[   52.679540] ata_port_flush_task: ENTER
[   52.6
[   52.696480] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   52.702086] ata2.00: configured for UDMA/133
[   52.706391
[   52.716448] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[   52.723098] ata_scsi_timed_out: ENTER
[   52.7t_flush_task: ENTER
[   52.738156] ata_eh_link_autopsy: ENTER
[   52.741945] ata_eh_link_autopsy: EXIT
[   52.745643] ata2.0  52.756083] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.756084]          res 51/04:00:01:015518] ata2.00: error: {ABRT }
[   52.779042] ata_eh_recover: ENTER
[   52.782395] ata_eh_revalidate_and_attach: ENTER
[   52dev_set_xfermode: EXIT, err_mask=0
[   52.809451] ata_sg_setup: 1 sg elements mapped
[   52.813962] ata_port_flush_task: ENTEd for UDMA/133
[   52.827670] ata_eh_recover: EXIT, rc=0
[   52.831455] ata2: EH complete
[   52.834458] ata_scsi_error: EXIsi_timed_out: ENTER
[   52.848075] ata_scsi_timed_out: EXIT, ret=0
[   52.852297] ata_scsi_error: ENTER
[   52.855646] ata_p EXIT
[   52.866925] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.873399] ata2.00: irq_stat 0x40000001
[          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.892845] ata2.00: status: {DRDY ERR }
[   52ate_and_attach: ENTER
[   52.908272] ata_sg_setup: 1 sg elements mapped
[   52.912782] ata_port_flush_task: ENTER
[   52.916265] ata_port_flush_task: ENTER
[   52.939057] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   52.944663] ata2.00: configured for UDMA/133
[   52.948965] ata_eh_recover: EXIT, rc=0
[   52.952751] ata2: EH complete
[   52.955755] ata_scsi_error:  ENTER
[   52.976943] ata_port_flush_task: ENTER
[   52.980730] ata_eh_link_autopsy: ENTER
[   52.984512] ata_eh_link_autopsa2.00: irq_stat 0x40000001
[   52.998642] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.99864 status: {DRDY ERR }
[   53.018086] ata2.00: error: {ABRT }
[   53.021610] ata_eh_recover: ENTER
[   53.024963] ata_eh_revalflush_task: ENTER
[   53.037852] ata_dev_set_xfermode: set features - xfer mode
[   53.043387] ata_port_flush_task: ENTER
[ ed
[   53.056530] ata_port_flush_task: ENTER
[   53.060326] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   53.065932] a0 00 00
[   53.086945] ata_scsi_timed_out: ENTER
[   53.090641] ata_scsi_timed_out: EXIT, ret=0
[   53.094864] ata_scsi_erro53.105784] ata_eh_link_autopsy: EXIT
[   53.109482] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   53.115955] db 0x0 data 0 
[   53.119913]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   53.135385] ata2.00: status: {DRDY ERR }
[   53.139347] ata2.00: error: {ABRT }
[   53.142871] ata_eh_recover: ENTER
[   53.146223] ata_eh_revta_port_flush_task: ENTER
[   53.168433] ata_dev_set_xfermode: EXIT, err_mask=0
[   53.173281] ata_sg_setup: 1 sg elements mapped
[   53.177791] ata_port_flush_task: ENTER
[   53.181590] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   53.187199]5293] ata2: EH complete
[   53.198297] ata_scsi_error: EXIT
[   53.201565] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00psy: ENTER
[   53.227054] ata_eh_link_autopsy: EXIT
[   53.230752] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x00:00/a0 tag 0 cdb 0x0 data 0 
[   53.241193]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   53_recover: ENTER
[   53.267503] ata_eh_revalidate_and_attach: ENTER
[   53.272091] ata_sg_setup: 1 sg elements mapped
[   53.[   53.285929] ata_port_flush_task: ENTER
[   53.289712] ata_dev_set_xfermode: EXIT, err_mask=0
[   53.294560] ata_sg_setup: r_shift=12, xfer_mode=0x46
[   53.308475] ata2.00: configured for UDMA/133
[   53.312777] ata_eh_recover: EXIT, rc=0
[   53.IT
[   53.326350] ata_scsi_dump_cdb: CDB (2:0,0,0) 1b 01 00 00 01 00 00 00 00
[   53.333004] ata_scsi_timed_out: ENTER
[   5port_flush_task: ENTER
[   53.348059] ata_eh_link_autopsy: ENTER
[   53.351842] ata_eh_link_autopsy: EXIT
[   53.355540] ata 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   53.381460] ata2.00: status: {DRDY ERR }
[   53.385422] ata2h: ENTER
[   53.396889] ata_sg_setup: 1 sg elements mapped
[   53.401399] ata_port_flush_task: ENTER
[   53.405196] ata_dev__flush_task: ENTER
[   53.427673] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   53.438570] ata2.00: configured for UDMA, rc=0
[   53.446660] ata2: EH complete
[   53.449664] ata_scsi_error: EXIT
[   53.452931] ata_scsi_dump_cdb: CDB (2:0,0,0)  ata_eh_link_autopsy: ENTER
[   53.478431] ata_eh_link_autopsy: EXIT
[   53.482129] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   53.488601] ata2.00: irq_stat 0x40000001
[   53.492559] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 53.515519] ata_eh_recover: ENTER
[   53.518871] ata_eh_revalidate_and_attach: ENTER
[   53.523460] ata_sg_setup: 1 sg elementes - xfer mode
[   53.537314] ata_port_flush_task: ENTER
[   53.541099] ata_dev_set_xfermode: EXIT, err_mask=0
[   53.545945_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   53.559859] ata2.00: configured for UDMA/133
[   53.564163] ata_eh_recover: Escsi_dump_cdb: CDB (2:0,0,0) 1b 01 00 00 01 00 00 00 00
[   53.580873] ata_scsi_timed_out: ENTER
[   53.584566] ata_scsi_time
[   53.595927] ata_eh_link_autopsy: ENTER
[   53.599709] ata_eh_link_autopsy: EXIT
[   53.603409] ata2.00: exception Emask 00:00:00:00/a0 Emask 0x1 (device error)
[   53.629311] ata2.00: status: {DRDY ERR }
[   53.633274] ata2.00: error: {ABRT }
[   53.636798] ata_eh_recover: ENTER
[   53.640151] ata_eh_revalidate_and_attach: ENTER
[   53.644739] ata_sg_setup: 1 sg eleme[   54.165122] __ata_port_freeze: ata2 port frozen
[   54.169686] ata_port_flush_task: ENTER
[   54.173477] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[   54.179691] ata2.00: revalidation failed (errno=-5)
[   54.184601] ata_eh_revalidate_and_attach: EXIT rc=-5
[   54.189598] ata2: failed to recover some devices, retrying in 5 secs
[   59.193927] __ata_port_freeze: ata2 port frozen
[   61.399434] ata2: soft resetting link
[   61.403135] ahci_do_softreset: ENTER
[   61.406746] ahci_do_softreset: PHY reports no device
[   61.411746] ata_std_postreset: ENTER
[   61.415358] ata2: SATA link down (SStatus 21 SControl 300)
[   61.420876] ata_std_postreset: EXIT
[   61.424401] ata_eh_thaw_port: ata2 port thawed
[   61.428879] ata_eh_revalidate_and_attach: ENTER
[   61.433442] ata_eh_revalidate_and_attach: EXIT rc=-5
[   61.438442] ata2: limiting SATA link speed to 1.5 Gbps
[   61.443613] ata2.00: limiting speed to UDMA/133:PIO3
[   61.448610] ata2: failed to recover some devices, retrying in 5 secs
[   62.235364] ata_port_schedule_eh: port EH scheduled
[   62.240275] __ata_port_freeze: ata2 port frozen
[   66.453467] __ata_port_freeze: ata2 port frozen
[   66.458039] ata2: hard resetting link
[   66.461734] ahci_hardreset: ENTER
[   66.465088] sata_std_hardreset: ENTER
[   66.468785] sata_link_hardreset: ENTER
[   66.789964] sata_link_hardreset: EXIT, rc=0
[   67.159769] ata_dev_classify: found ATA device by sig
[   67.164857] sata_std_hardreset: EXIT, class=1
[   67.169248] ata_dev_classify: found ATA device by sig
[   67.174332] ahci_hardreset: EXIT, rc=0, class=1
[   67.178898] ata_std_postreset: ENTER
[   67.182510] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   67.188722] ata_std_postreset: EXIT
[   67.192254] ata_eh_thaw_port: ata2 port thawed
[   67.196732] ata_eh_revalidate_and_attach: ENTER
[   67.201317] ata_sg_setup: 1 sg elements mapped
[   67.205832] ata_port_flush_task: ENTER
[   67.209627] ata_dev_set_xfermode: set features - xfer mode
[   67.215163] ata_port_flush_task: ENTER
[   67.218947] ata_dev_set_xfermode: EXIT, err_mask=0
[   67.223795] ata_sg_setup: 1 sg elements mapped
[   67.228307] ata_port_flush_task: ENTER
[   67.232103] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   67.237710] ata2.00: configured for UDMA/133
[   67.242012] ata_eh_recover: EXIT, rc=0
[   67.245799] ata_eh_link_autopsy: ENTER
[   67.249584] ata_eh_link_autopsy: EXIT
[   67.253282] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x3 t4
[   67.260361] ata2: irq_stat 0x00000040, connection status changed
[   67.266397] ata2: SError: {PHYRdyChg DevExch }
[   67.270873] ata_eh_recover: ENTER
[   67.274224] __ata_port_freeze: ata2 port frozen
[   67.989339] ata2: soft resetting link
[   67.993040] ahci_do_softreset: ENTER
[   68.155912] ata_dev_classify: unknown device
[   68.160218] ahci_do_softreset: EXIT, class=0
[   68.164523] ata_std_postreset: ENTER
[   68.168136] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   68.174348] ata_std_postreset: EXIT
[   68.177871] ata_eh_thaw_port: ata2 port thawed
[   68.182349] ata_eh_revalidate_and_attach: ENTER
[   68.186935] ata_sg_setup: 1 sg elements mapped
[   98.173658] ata_port_flush_task: ENTER
[   98.177448] __ata_port_freeze: ata2 port frozen
[   98.182009] ata2.00: qc timeout (cmd 0xec)
[   98.186145] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   98.192277] ata2.00: revalidation failed (errno=-5)
[   98.197194] ata_eh_revalidate_and_attach: EXIT rc=-5
[   98.202194] ata2: failed to recover some devices, retrying in 5 secs
[  103.207688] __ata_port_freeze: ata2 port frozen
[  103.212254] ata2: hard resetting link
[  103.215949] ahci_hardreset: ENTER
[  103.219303] sata_std_hardreset: ENTER
[  103.223000] sata_link_hardreset: ENTER
[  103.544187] sata_link_hardreset: EXIT, rc=0
[  108.711513] ata2: port is slow to respond, please be patient (Status 0x80)
[  113.249138] ata2: COMRESET failed (errno=-16)
[  113.253536] ahci_hardreset: EXIT, rc=-16, class=5
[  113.258273] ata2: hard resetting link
[  113.261970] ahci_hardreset: ENTER
[  113.265321] sata_std_hardreset: ENTER
[  113.269018] sata_link_hardreset: ENTER
[  113.592295] sata_link_hardreset: EXIT, rc=0
[  113.962100] ata_dev_classify: found ATA device by sig
[  113.967187] sata_std_hardreset: EXIT, class=1
[  113.971579] ata_dev_classify: found ATA device by sig
[  113.976662] ahci_hardreset: EXIT, rc=0, class=1
[  113.981228] ata_std_postreset: ENTER
[  113.984840] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  113.991052] ata_std_postreset: EXIT
[  113.994582] ata_eh_thaw_port: ata2 port thawed
[  113.999060] ata_eh_revalidate_and_attach: ENTER
[  114.003648] ata_sg_setup: 1 sg elements mapped
[  114.008160] ata_port_flush_task: ENTER
[  114.011958] ata_dev_set_xfermode: set features - xfer mode
[  114.017492] ata_port_flush_task: ENTER
[  114.021278] ata_dev_set_xfermode: EXIT, err_mask=0
[  114.026126] ata_sg_setup: 1 sg elements mapped
[  114.030639] ata_port_flush_task: ENTER
[  114.034434] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  114.040041] ata2.00: configured for UDMA/133
[  114.044343] ata_eh_recover: EXIT, rc=0
[  114.048129] ata_eh_link_autopsy: ENTER
[  114.051914] ata_eh_link_autopsy: EXIT
[  114.055611] ata_eh_recover: ENTER
[  114.058963] ata_eh_revalidate_and_attach: ENTER
[  114.063529] ata_eh_recover: EXIT, rc=0
[  114.067314] ata2: EH complete
[  114.070318] ata_scsi_error: EXIT
[  114.073586] ata_scsi_dump_cdb: CDB (2:0,0,0) 1b 01 00 00 01 00 00 00 00
[  114.080240] ata_scsi_timed_out: ENTER
[  114.083941] ata_scsi_timed_out: EXIT, ret=0
[  114.088162] ata_scsi_error: ENTER
[  114.091513] ata_port_flush_task: ENTER
[  114.095302] ata_eh_link_autopsy: ENTER
[  114.099085] ata_eh_link_autopsy: EXIT
[  114.102783] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.109255] ata2.00: irq_stat 0x40000001
[  114.113213] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[  114.113214]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.128686] ata2.00: status: {DRDY ERR }
[  114.132648] ata2.00: error: {ABRT }
[  114.136172] ata_eh_recover: ENTER
[  114.139525] ata_eh_revalidate_and_attach: ENTER
[  114.144114] ata_sg_setup: 1 sg elements mapped
[  114.148627] ata_port_flush_task: ENTER
[  114.157668] ata_dev_set_xfermode: set features - xfer mode
[  114.163207] ata_port_flush_task: ENTER
[  114.166991] ata_dev_set_xfermode: EXIT, err_mask=0
[  114.171839] ata_sg_setup: 1 sg elements mapped
[  114.176353] ata_port_flush_task: ENTER
[  114.180148] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  114.185754] ata2.00: configured for UDMA/133
[  114.190057] ata_eh_recover: EXIT, rc=0
[  114.193842] ata2: EH complete
[  114.196846] ata_scsi_error: EXIT
[  114.200114] ata_scsi_dump_cdb: CDB (2:0,0,0) 1b 01 00 00 01 00 00 00 00
[  114.206768] ata_scsi_timed_out: ENTER
[  114.210469] ata_scsi_timed_out: EXIT, ret=0
[  114.214690] ata_scsi_error: ENTER
[  114.218041] ata_port_flush_task: ENTER
[  114.221830] ata_eh_link_autopsy: ENTER
[  114.225613] ata_eh_link_autopsy: EXIT
[  114.229311] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.235783] ata2.00: irq_stat 0x40000001
[  114.239741] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[  114.239742]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.255213] ata2.00: status: {DRDY ERR }
[  114.259176] ata2.00: error: {ABRT }
[  114.262700] ata_eh_recover: ENTER
[  114.266052] ata_eh_revalidate_and_attach: ENTER
[  114.270641] ata_sg_setup: 1 sg elements mapped
[  114.275154] ata_port_flush_task: ENTER
[  114.278951] ata_dev_set_xfermode: set features - xfer mode
[  114.284487] ata_port_flush_task: ENTER
[  114.288271] ata_dev_set_xfermode: EXIT, err_mask=0
[  114.293119] ata_sg_setup: 1 sg elements mapped
[  114.297631] ata_port_flush_task: ENTER
[  114.301427] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  114.307033] ata2.00: configured for UDMA/133
[  114.311336] ata_eh_recover: EXIT, rc=0
[  114.315121] ata2: EH complete
[  114.318125] ata_scsi_error: EXIT
[  114.321392] ata_scsi_dump_cdb: CDB (2:0,0,0) 1b 01 00 00 01 00 00 00 00
[  114.328046] ata_scsi_timed_out: ENTER
[  114.331740] ata_scsi_timed_out: EXIT, ret=0
[  114.335966] ata_scsi_error: ENTER
[  114.339322] ata_port_flush_task: ENTER
[  114.343109] ata_eh_link_autopsy: ENTER
[  114.346891] ata_eh_link_autopsy: EXIT
[  114.350589] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.357064] ata2.00: irq_stat 0x40000001
[  114.361028] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[  114.361029]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.376501] ata2.00: status: {DRDY ERR }
[  114.380464] ata2.00: error: {ABRT }
[  114.383988] ata_eh_recover: ENTER
[  114.387340] ata_eh_revalidate_and_attach: ENTER
[  114.391931] ata_sg_setup: 1 sg elements mapped
[  114.396443] ata_port_flush_task: ENTER
[  114.400238] ata_dev_set_xfermode: set features - xfer mode
[  114.405775] ata_port_flush_task: ENTER
[  114.409560] ata_dev_set_xfermode: EXIT, err_mask=0
[  114.414405] ata_sg_setup: 1 sg elements mapped
[  114.418920] ata_port_flush_task: ENTER
[  114.422714] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  114.428320] ata2.00: configured for UDMA/133
[  114.432623] ata_eh_recover: EXIT, rc=0
[  114.436412] ata2: EH complete
[  114.439413] ata_scsi_error: EXIT
[  115.437997] .<3>ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  115.445060] ata_scsi_timed_out: ENTER
[  115.448757] ata_scsi_timed_out: EXIT, ret=0
[  115.452976] ata_scsi_error: ENTER
[  115.456327] ata_port_flush_task: ENTER
[  115.460115] ata_eh_link_autopsy: ENTER
[  115.463897] ata_eh_link_autopsy: EXIT
[  115.467595] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  115.474067] ata2.00: irq_stat 0x40000001
[  115.478025] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  115.478026]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  115.493499] ata2.00: status: {DRDY ERR }
[  115.497459] ata2.00: error: {ABRT }
[  115.500986] ata_eh_recover: ENTER
[  115.504336] ata_eh_revalidate_and_attach: ENTER
[  115.508926] ata_sg_setup: 1 sg elements mapped
[  115.513438] ata_port_flush_task: ENTER
[  115.517237] ata_dev_set_xfermode: set features - xfer mode
[  115.522772] ata_port_flush_task: ENTER
[  115.526554] ata_dev_set_xfermode: EXIT, err_mask=0
[  115.531402] ata_sg_setup: 1 sg elements mapped
[  115.535915] ata_port_flush_task: ENTER
[  115.539711] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  115.545317] ata2.00: configured for UDMA/133
[  115.549620] ata_eh_recover: EXIT, rc=0
[  115.553406] ata2: EH complete
[  115.556409] ata_scsi_error: EXIT
[  115.559677] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  115.566340] ata_scsi_timed_out: ENTER
[  115.570032] ata_scsi_timed_out: EXIT, ret=0
[  115.574254] ata_scsi_error: ENTER
[  115.577604] ata_port_flush_task: ENTER
[  115.581394] ata_eh_link_autopsy: ENTER
[  115.585186] ata_eh_link_autopsy: EXIT
[  115.588884] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  115.595357] ata2.00: irq_stat 0x40000001
[  115.599322] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  115.599323]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  115.614795] ata2.00: status: {DRDY ERR }
[  115.618757] ata2.00: error: {ABRT }
[  115.622281] ata_eh_recover: ENTER
[  115.625634] ata_eh_revalidate_and_attach: ENTER
[  115.630222] ata_sg_setup: 1 sg elements mapped
[  115.634735] ata_port_flush_task: ENTER
[  115.638532] ata_dev_set_xfermode: set features - xfer mode
[  115.644067] ata_port_flush_task: ENTER
[  115.647853] ata_dev_set_xfermode: EXIT, err_mask=0
[  115.652699] ata_sg_setup: 1 sg elements mapped
[  115.657211] ata_port_flush_task: ENTER
[  115.661007] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  115.666614] ata2.00: configured for UDMA/133
[  115.670917] ata_eh_recover: EXIT, rc=0
[  115.674703] ata2: EH complete
[  115.677704] ata_scsi_error: EXIT
[  115.680975] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  115.687627] ata_scsi_timed_out: ENTER
[  115.691320] ata_scsi_timed_out: EXIT, ret=0
[  115.695542] ata_scsi_error: ENTER
[  115.698892] ata_port_flush_task: ENTER
[  115.702682] ata_eh_link_autopsy: ENTER
[  115.706472] ata_eh_link_autopsy: EXIT
[  115.710172] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  115.716644] ata2.00: irq_stat 0x40000001
[  115.720601] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  115.720602]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  115.736074] ata2.00: status: {DRDY ERR }
[  115.740037] ata2.00: error: {ABRT }
[  115.743562] ata_eh_recover: ENTER
[  115.746912] ata_eh_revalidate_and_attach: ENTER
[  115.751501] ata_sg_setup: 1 sg elements mapped
[  115.756013] ata_port_flush_task: ENTER
[  115.759810] ata_dev_set_xfermode: set features - xfer mode
[  115.765347] ata_port_flush_task: ENTER
[  115.769132] ata_dev_set_xfermode: EXIT, err_mask=0
[  115.773977] ata_sg_setup: 1 sg elements mapped
[  115.778490] ata_port_flush_task: ENTER
[  115.782286] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  115.787892] ata2.00: configured for UDMA/133
[  115.792195] ata_eh_recover: EXIT, rc=0
[  115.795982] ata2: EH complete
[  115.798986] ata_scsi_error: EXIT
[  115.802253] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  115.808916] ata_scsi_timed_out: ENTER
[  115.812609] ata_scsi_timed_out: EXIT, ret=0
[  115.816830] ata_scsi_error: ENTER
[  115.820180] ata_port_flush_task: ENTER
[  115.823970] ata_eh_link_autopsy: ENTER
[  115.827759] ata_eh_link_autopsy: EXIT
[  115.831460] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  115.837932] ata2.00: irq_stat 0x40000001
[  115.841889] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  115.841890]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  115.857362] ata2.00: status: {DRDY ERR }
[  115.861325] ata2.00: error: {ABRT }
[  115.864849] ata_eh_recover: ENTER
[  115.868201] ata_eh_revalidate_and_attach: ENTER
[  115.872789] ata_sg_setup: 1 sg elements mapped
[  115.877302] ata_port_flush_task: ENTER
[  115.881099] ata_dev_set_xfermode: set features - xfer mode
[  115.886633] ata_port_flush_task: ENTER
[  115.890419] ata_dev_set_xfermode: EXIT, err_mask=0
[  115.895265] ata_sg_setup: 1 sg elements mapped
[  115.899782] ata_port_flush_task: ENTER
[  115.903575] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  115.914433] ata2.00: configured for UDMA/133
[  115.918741] ata_eh_recover: EXIT, rc=0
[  115.922528] ata2: EH complete
[  115.925532] ata_scsi_error: EXIT
[  115.928799] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  115.935454] ata_scsi_timed_out: ENTER
[  115.939154] ata_scsi_timed_out: EXIT, ret=0
[  115.943375] ata_scsi_error: ENTER
[  115.946726] ata_port_flush_task: ENTER
[  115.950516] ata_eh_link_autopsy: ENTER
[  115.954305] ata_eh_link_autopsy: EXIT
[  115.958005] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  115.964478] ata2.00: irq_stat 0x40000001
[  115.968437] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  115.968437]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  115.983925] ata2.00: status: {DRDY ERR }
[  115.987887] ata2.00: error: {ABRT }
[  115.991411] ata_eh_recover: ENTER
[  115.994764] ata_eh_revalidate_and_attach: ENTER
[  115.999352] ata_sg_setup: 1 sg elements mapped
[  116.003864] ata_port_flush_task: ENTER
[  116.007662] ata_dev_set_xfermode: set features - xfer mode
[  116.013196] ata_port_flush_task: ENTER
[  116.016982] ata_dev_set_xfermode: EXIT, err_mask=0
[  116.021828] ata_sg_setup: 1 sg elements mapped
[  116.026343] ata_port_flush_task: ENTER
[  116.030136] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  116.035745] ata2.00: configured for UDMA/133
[  116.040047] ata_eh_recover: EXIT, rc=0
[  116.043833] ata2: EH complete
[  116.046838] ata_scsi_error: EXIT
[  116.050103] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  116.056765] ata_scsi_timed_out: ENTER
[  116.060460] ata_scsi_timed_out: EXIT, ret=0
[  116.064681] ata_scsi_error: ENTER
[  116.068032] ata_port_flush_task: ENTER
[  116.071823] ata_eh_link_autopsy: ENTER
[  116.075612] ata_eh_link_autopsy: EXIT
[  116.079310] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.085782] ata2.00: irq_stat 0x40000001
[  116.089740] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.089741]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.105213] ata2.00: status: {DRDY ERR }
[  116.109175] ata2.00: error: {ABRT }
[  116.112699] ata_eh_recover: ENTER
[  116.116052] ata_eh_revalidate_and_attach: ENTER
[  116.120641] ata_sg_setup: 1 sg elements mapped
[  116.125155] ata_port_flush_task: ENTER
[  116.128950] ata_dev_set_xfermode: set features - xfer mode
[  116.134485] ata_port_flush_task: ENTER
[  116.138269] ata_dev_set_xfermode: EXIT, err_mask=0
[  116.143117] ata_sg_setup: 1 sg elements mapped
[  116.147631] ata_port_flush_task: ENTER
[  116.151425] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  116.157032] ata2.00: configured for UDMA/133
[  116.161334] ata_eh_recover: EXIT, rc=0
[  116.165123] ata2: EH complete
[  116.168123] ata_scsi_error: EXIT
[  116.171391] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  116.178053] ata_scsi_timed_out: ENTER
[  116.181748] ata_scsi_timed_out: EXIT, ret=0
[  116.185969] ata_scsi_error: ENTER
[  116.189319] ata_port_flush_task: ENTER
[  116.193109] ata40000001
[  116.211029] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.211029]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.226510] ata2.00: status: {DRDY ERR }
[  116.230473] ata2.00
[  116.250246] ata_dev_set_xfermode: set features - xfer mode
[  116.255782] ata_port_flush_task: ENTER
[  116.259566] ata_] ata_port_flush_task: ENTER
[  116.272721] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  116.278328] ata2.00: configure299351] ata_scsi_timed_out: ENTER
[  116.303044] ata_scsi_timed_out: EXIT, ret=0
[  116.307265] ata_scsi_error: ENTER
[  116.310616] ata_port_flush_task: ENTER
[  116.314406] ata_eh_link_autopsy: ENTER
[  116.318195] ata_eh_link_autopsy: EXIT
[  11  116.332326]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.347798] ata2.00: status: {DRDY ta_eh_revalidate_and_attach: ENTER
[  116.363226] ata_sg_setup: 1 sg elements mapped
[  116.367739] ata_port_flush_task: ENTE: ENTER
[  116.380854] ata_dev_set_xfermode: EXIT, err_mask=0
[  116.385702] ata_sg_setup: 1 sg elements mapped
[  116.3902116.399617] ata2.00: configured for UDMA/133
[  116.403920] ata_eh_recover: EXIT, rc=0
[  116.407705] ata2: EH complete
[  1100 00
[  116.420639] ata_scsi_timed_out: ENTER
[  116.424331] ata_scsi_timed_out: EXIT, ret=0
[  116.428553] ata_scsi_error:116.449647] ata2.00: irq_stat 0x40000001
[  116.453612] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 085] ata2.00: status: {DRDY ERR }
[  116.473047] ata2.00: error: {ABRT }
[  116.476571] ata_eh_recover: ENTER
[  116.479923]024] ata_port_flush_task: ENTER
[  116.492821] ata_dev_set_xfermode: set features - xfer mode
[  116.498359] ata_port_flush_telements mapped
[  116.511503] ata_port_flush_task: ENTER
[  116.515299] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[   00 00 00 00 00 00 00
[  116.541927] ata_scsi_timed_out: ENTER
[  116.545620] ata_scsi_timed_out: EXIT, ret=0
[  116.549841] ata_scsi_error: ENTER
[  116.553193] ata_port_flush_task: ENTER
[  116.556981] ata_eh_link_autopsy: ENTER
[  116.560763] at:00/a0 tag 0 cdb 0x0 data 0 
[  116.574901]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.590373] ata2.00: status: {DRDY ERR }
[  116.594335] ata2.00: error: {ABRT }
[  116.597861] ata_eh_recover: ENTER
[  116.6012 116.619647] ata_port_flush_task: ENTER
[  116.623430] ata_dev_set_xfermode: EXIT, err_mask=0
[  116.628278] ata_sg_setup: 1 _shift=12, xfer_mode=0x46
[  116.642193] ata2.00: configured for UDMA/133
[  116.646495] ata_eh_recover: EXIT, rc=0
[  116.6[  116.672151] ata_scsi_timed_out: EXIT, ret=0
[  116.676370] ata_scsi_error: ENTER
[  116.679720] ata_port_flush_task: ENTERutopsy: EXIT
[  116.690998] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.697472] ata2.00: irq_stat 0x40000001
[  116.701429] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.701430]          res 51/04:DRDY ERR }
[  116.720872] ata2.00: error: {ABRT }
[  116.724396] ata_eh_recover: ENTER
[  116.727748] ata_eh_revalidate_and_
[  116.750011] ata_dev_set_xfermode: EXIT, err_mask=0
[  116.754859] ata_sg_setup: 1 sg elements mapped
[  116.759372] ata_72] ata2.00: configured for UDMA/133
[  116.773077] ata_eh_recover: EXIT, rc=0
[  116.776862] ata2: EH complete
[  116.77986[  116.789787] ata_scsi_timed_out: ENTER
[  116.793488] ata_scsi_timed_out: EXIT, ret=0
[  116.797709] ata_scsi_error: ENTER] ata_eh_link_autopsy: EXIT
[  116.812330] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.818802] ata2.00: ta2.00: status: {DRDY ERR }
[  116.842195] ata2.00: error: {ABRT }
[  116.845719] ata_eh_recover: ENTER
[  116.849072] ata_e_port_flush_task: ENTER
[  116.861970] ata_dev_set_xfermode: set features - xfer mode
[  116.867505] ata_port_flush_task: ENTs mapped
[  116.880650] ata_port_flush_task: ENTER
[  116.884446] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  116.8902: EH complete
[  116.901144] ata_scsi_error: EXIT
[  116.904412] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  116.929920] ata_eh_link_autopsy: EXIT
[  116.933618] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.94ag 0 cdb 0x0 data 0 
[  116.944048]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.959520] ENTER
[  116.970359] ata_eh_revalidate_and_attach: ENTER
[  116.974948] ata_sg_setup: 1 sg elements mapped
[  116.979460] atup: 1 sg elements mapped
[  117.001937] ata_port_flush_task: ENTER
[  117.005733] ata_dev_set_mode: xfer_shift=12, xfer_mode= 117.019429] ata2: EH complete
[  117.022432] ata_scsi_error: EXIT
[  117.025699] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 0ret=0
[  117.040278] ata_scsi_error: ENTER
[  117.043628] ata_port_flush_task: ENTER
[  117.047416] ata_eh_link_autopsy: ENT00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  117.065329]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  117.080801] ata2.00: status: {DRDY ERR }
[  117.084763] ata2.00: error: {ABRT }
[  117.088287] ata_eh_recover: ENTER
[  nts mapped
[  117.100741] ata_port_flush_task: ENTER
[  117.104538] ata_dev_set_xfermode: set features - xfer mode
[  117.11de: xfer_shift=12, xfer_mode=0x46
[  117.132619] ata2.00: configured for UDMA/133
[  117.136921] ata_eh_recover: EXIT, rc=0
db: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  117.153632] ata_scsi_timed_out: ENTER
[  117.157327] ata_scsi_timed_out: EXIT686] ata_eh_link_autopsy: ENTER
[  117.172469] ata_eh_link_autopsy: EXIT
[  117.176169] ata2.00: exception Emask 0x0 SAct 0x000:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  117.186599]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 [  117.209557] ata_eh_recover: ENTER
[  117.212910] ata_eh_revalidate_and_attach: ENTER
[  117.217498] ata_sg_setup: 1 sg eleatures - xfer mode
[  117.231343] ata_port_flush_task: ENTER
[  117.235129] ata_dev_set_xfermode: EXIT, err_mask=0
[  117.23 ata_eh_recover: EXIT, rc=0
[  117.261979] ata2: EH complete
[  117.264982] ata_scsi_error: EXIT
[  117.268250] ata_scsi_dum605] ata_scsi_timed_out: EXIT, ret=0
[  117.282827] ata_scsi_error: ENTER
[  117.286177] ata_port_flush_task: ENTER
[  117.2 exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  117.303920] ata2.00: irq_stat 0x40000001
[  117.307877] ata2.00: cmd e5/error: {ABRT }
[  117.330839] ata_eh_recover: ENTER
[  117.334190] ata_eh_revalidate_and_attach: ENTER
[  117.338778] ata_sgxfermode: set features - xfer mode
[  117.352623] ata_port_flush_task: ENTER
[  117.356407] ata_dev_set_xfermode: EXIT, err_m
[  117.369563] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  117.375170] ata2.00: configured for UDMA/133
[  117.379473
[  117.389529] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  117.396192] ata_scsi_timed_out: ENTER
[  117.3t_flush_task: ENTER
[  117.411246] ata_eh_link_autopsy: ENTER
[  117.415028] ata_eh_link_autopsy: EXIT
[  117.418726] ata2.0[  117.430451] ata2.00: irq_stat 0x40000001
[  117.434415] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 datarecover: ENTER
[  117.460734] ata_eh_revalidate_and_attach: ENTER
[  117.465322] ata_sg_setup: 1 sg elements mapped
[  117.469836] ata_port_flush_task: ENTER
[  117.473633] ata_dev_set_xfermode: set features - xfer mode
[  117.479168] ata_port_flush_shift=12, xfer_mode=0x46
[  117.501715] ata2.00: configured for UDMA/133
[  117.506017] ata_eh_recover: EXIT, rc=0
[  117.5(2:0,0,0) 00 00 00 00 00 00 00 00 00
[  117.522728] ata_scsi_timed_out: ENTER
[  117.526422] ata_scsi_timed_out: EXIT, ret=0
[  117.530644] ata_scsi_error: ENTER
[  117.533995] ata_port_flush_task: ENTER
[  117.537782] ata_eh_link_autopsy: ENTER
[ 0:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  117.555702]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device578662] ata_eh_recover: ENTER
[  117.582012] ata_eh_revalidate_and_attach: ENTER
[  117.586603] ata_sg_setup: 1 sg elements m xfer mode
[  117.600448] ata_port_flush_task: ENTER
[  117.604233] ata_dev_set_xfermode: EXIT, err_mask=0
[  117.609078] at_set_mode: xfer_shift=12, xfer_mode=0x46
[  117.622993] ata2.00: configured for UDMA/133
[  117.627298] ata_eh_recover: EXIT,[  118.633003] .<3>ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  118.640061] ata_scsi_timed_out: ENTER
[  118.643757] ata_scsi_timed_out: EXIT, ret=0
[  118.647979] ata_scsi_error: ENTER
[  118.651327] ata_port_flush_task: ENTER
[  118.655117] ata_eh_link_autopsy: ENTER
[  118.658899] ata_eh_link_autopsy: EXIT
[  118.662597] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  118.669070] ata2.00: irq_stat 0x40000001
[  118.673027] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  118.673028]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  118.688500] ata2.00: status: {DRDY ERR }
[  118.692462] ata2.00: error: {ABRT }
[  118.695986] ata_eh_recover: ENTER
[  118.699339] ata_eh_revalidate_and_attach: ENTER
[  118.703927] ata_sg_setup: 1 sg elements mapped
[  118.708441] ata_port_flush_task: ENTER
[  118.712236] ata_dev_set_xfermode: set features - xfer mode
[  118.717773] ata_port_flush_task: ENTER
[  118.721557] ata_dev_set_xfermode: EXIT, err_mask=0
[  118.726405] ata_sg_setup: 1 sg elements mapped
[  118.730917] ata_port_flush_task: ENTER
[  118.734713] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  118.740320] ata2.00: configured for UDMA/133
[  118.744622] ata_eh_recover: EXIT, rc=0
[  118.748408] ata2: EH complete
[  118.751411] ata_scsi_error: EXIT
[  118.754679] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  118.761342] ata_scsi_timed_out: ENTER
[  118.765034] ata_scsi_timed_out: EXIT, ret=0
[  118.769258] ata_scsi_error: ENTER
[  118.772608] ata_port_flush_task: ENTER
[  118.776396] ata_eh_link_autopsy: ENTER
[  118.780178] ata_eh_link_autopsy: EXIT
[  118.783876] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  118.790351] ata2.00: irq_stat 0x40000001
[  118.794315] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  118.794316]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  118.809788] ata2.00: status: {DRDY ERR }
[  118.813750] ata2.00: error: {ABRT }
[  118.817274] ata_eh_recover: ENTER
[  118.820626] ata_eh_revalidate_and_attach: ENTER
[  118.825215] ata_sg_setup: 1 sg elements mapped
[  118.829728] ata_port_flush_task: ENTER
[  118.833525] ata_dev_set_xfermode: set features - xfer mode
[  118.839060] ata_port_flush_task: ENTER
[  118.842846] ata_dev_set_xfermode: EXIT, err_mask=0
[  118.847692] ata_sg_setup: 1 sg elements mapped
[  118.852205] ata_port_flush_task: ENTER
[  118.856001] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  118.861607] ata2.00: configured for UDMA/133
[  118.865910] ata_eh_recover: EXIT, rc=0
[  118.869695] ata2: EH complete
[  118.872699] ata_scsi_error: EXIT
[  118.875967] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  118.882630] ata_scsi_timed_out: ENTER
[  118.886322] ata_scsi_timed_out: EXIT, ret=0
[  118.890546] ata_scsi_error: ENTER
[  118.893896] ata_port_flush_task: ENTER
[  118.897684] ata_eh_link_autopsy: ENTER
[  118.901466] ata_eh_link_autopsy: EXIT
[  118.905164] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  118.911637] ata2.00: irq_stat 0x40000001
[  118.915594] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  118.915595]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  118.931069] ata2.00: status: {DRDY ERR }
[  118.935029] ata2.00: error: {ABRT }
[  118.938555] ata_eh_recover: ENTER
[  118.941905] ata_eh_revalidate_and_attach: ENTER
[  118.946495] ata_sg_setup: 1 sg elements mapped
[  118.951009] ata_port_flush_task: ENTER
[  118.954803] ata_dev_set_xfermode: set features - xfer mode
[  118.960341] ata_port_flush_task: ENTER
[  118.964125] ata_dev_set_xfermode: EXIT, err_mask=0
[  118.968972] ata_sg_setup: 1 sg elements mapped
[  118.973485] ata_port_flush_task: ENTER
[  118.977281] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  118.982887] ata2.00: configured for UDMA/133
[  118.987190] ata_eh_recover: EXIT, rc=0
[  118.990975] ata2: EH complete
[  118.993979] ata_scsi_error: EXIT
[  118.997246] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  119.003901] ata_scsi_timed_out: ENTER
[  119.007602] ata_scsi_timed_out: EXIT, ret=0
[  119.011825] ata_scsi_error: ENTER
[  119.015176] ata_port_flush_task: ENTER
[  119.018963] ata_eh_link_autopsy: ENTER
[  119.022745] ata_eh_link_autopsy: EXIT
[  119.026445] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  119.032917] ata2.00: irq_stat 0x40000001
[  119.036875] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  119.036876]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  119.052357] ata2.00: status: {DRDY ERR }
[  119.056317] ata2.00: error: {ABRT }
[  119.059843] ata_eh_recover: ENTER
[  119.063193] ata_eh_revalidate_and_attach: ENTER
[  119.067784] ata_sg_setup: 1 sg elements mapped
[  119.072298] ata_port_flush_task: ENTER
[  119.076095] ata_dev_set_xfermode: set features - xfer mode
[  119.081629] ata_port_flush_task: ENTER
[  119.085414] ata_dev_set_xfermode: EXIT, err_mask=0
[  119.090259] ata_sg_setup: 1 sg elements mapped
[  119.094773] ata_port_flush_task: ENTER
[  119.098567] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  119.104174] ata2.00: configured for UDMA/133
[  119.108479] ata_eh_recover: EXIT, rc=0
[  119.112264] ata2: EH complete
[  119.115267] ata_scsi_error: EXIT
[  119.118535] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  119.125189] ata_scsi_timed_out: ENTER
[  119.128892] ata_scsi_timed_out: EXIT, ret=0
[  119.133113] ata_scsi_error: ENTER
[  119.136464] ata_port_flush_task: ENTER
[  119.140251] ata_eh_link_autopsy: ENTER
[  119.144033] ata_eh_link_autopsy: EXIT
[  119.147731] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  119.154206] ata2.00: irq_stat 0x40000001
[  119.158170] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  119.158171]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  119.173643] ata2.00: status: {DRDY ERR }
[  119.182856] ata2.00: error: {ABRT }
[  119.186380] ata_eh_recover: ENTER
[  119.189730] ata_eh_revalidate_and_attach: ENTER
[  119.194321] ata_sg_setup: 1 sg elements mapped
[  119.198833] ata_port_flush_task: ENTER
[  119.202630] ata_dev_set_xfermode: set features - xfer mode
[  119.208165] ata_port_flush_task: ENTER
[  119.211950] ata_dev_set_xfermode: EXIT, err_mask=0
[  119.216797] ata_sg_setup: 1 sg elements mapped
[  119.221310] ata_port_flush_task: ENTER
[  119.225106] ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
[  119.230710] ata2.00: configured for UDMA/133
[  119.235015] ata_eh_recover: EXIT, rc=0
[  119.238801] ata2: EH complete
[  119.241805] ata_scsi_error: EXIT
[  119.245072] ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
[  119.251726] ata_scsi_timed_out: ENTER
[  119.255427] ata_scsi_timed_out: EXIT, ret=0
[  119.259648] ata_scsi_error: ENTER
[  119.262999] ata_port_flush_task: ENTER
[  119.266788] ata_eh_link_autopsy: ENTER
[  119.270571] ata_eh_link_autopsy: EXIT
[  119.274269] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  119.280741] ata2.00: irq_stat 0x40000001
[  119.284699] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  119.284700]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  119.300174] ata2.00: status: {DRDY ERR }
[  119.304134] ata2.00: error: {ABRT }
[  119.307658] ata_eh_recover: ENTER
[  119.311010] ata_eh_revalidate_and_attach: ENTER
[  119.315598] ata_sg_setup: 1 sg elements mapped
[  119.835981] __ata_port_freeze: ata2 port frozen
[  119.840544] ata_port_flush_task: ENTER
[  119.844336] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[  119.850553] ata2.00: revalidation failed (errno=-5)
[  119.855470] ata_eh_revalidate_and_attach: EXIT rc=-5
[  119.860467] ata2: failed to recover some devices, retrying in 5 secs
[  124.866425] __ata_port_freeze: ata2 port frozen
[  127.071953] ata2: soft resetting link
[  127.075650] ahci_do_softreset: ENTER
[  127.079263] ahci_do_softreset: PHY reports no device
[  127.084260] ata_std_postreset: ENTER
[  127.087872] ata2: SATA link down (SStatus 11 SControl 310)
[  127.093390] ata_std_postreset: EXIT
[  127.096915] ata_eh_thaw_port: ata2 port thawed
[  127.101393] ata_eh_revalidate_and_attach: ENTER
[  127.105959] ata_eh_revalidate_and_attach: EXIT rc=-5
[  127.110957] ata2.00: limiting speed to UDMA/133:PIO2
[  127.115953] ata2: failed to recover some devices, retrying in 5 secs

--------------060702030609080608070802--
