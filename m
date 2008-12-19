Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYLSXHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYLSXHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLSXHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:07:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:17527 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYLSXH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:07:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gnGnCakL3p59ZbG7Nhoi8f0VI4UnFyaEXsuBcJW/jl5d+kd4PZXBkRxU5xZoDO0Kf7
         0fQvj4Q+y1GmJnWHaNPmRfiTiCMFrjSx0Xi/CaZIIhjL8y2QHXP+VwHJS1qq24vWUWET
         afxRguGSCS0VHV85hcWaE7TGUPb71XRaJoTFA=
Message-ID: <494C2929.1010008@gmail.com>
Date: Fri, 19 Dec 2008 19:07:21 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Re: linux-next: Tree for December 17 (Radeon DRM BUG)
References: <20081217232536.0b18f4a7.sfr@canb.auug.org.au>	 <494995D7.6090009@gmail.com> <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
In-Reply-To: <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Thu, Dec 18, 2008 at 10:14 AM, Kevin Winchester
> <kjwinchester@gmail.com> wrote:
>   
>> Stephen Rothwell wrote:
>>     
>>> Hi all,
>>>
>>>
>>>       
>> I get the following BUG in the radeon drm code with today's linux-next when
>> I run "startx".  I have not built or tested linux-next in a while, but the
>> problem definitely does not occur in mainline.
>>     
>
> Do you have another X server running or just console?
>   
Just console.
> can you get a full dmesg with
>
> echo 1 > /sys/module/drm/parameters/debug
>
>   
[    0.000000] Linux version 2.6.28-rc8-next-20081217 (kevin@winchester) 
(gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #192 Wed Dec 17 17:04:30 AST 2008
[    0.000000] Command line: root=/dev/sda1 hpet=force
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000004fff0000 (usable)
[    0.000000]  BIOS-e820: 000000004fff0000 - 000000004fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000004fff8000 - 0000000050000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it 
around.
[    0.000000] last_pfn = 0x4fff0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000004fff0000
[    0.000000]  0000000000 - 004fe00000 page 2M
[    0.000000]  004fe00000 - 004fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 4fff0000 @ 10000-14000
[    0.000000] last_map_addr: 4fff0000 end: 4fff0000
[    0.000000] ACPI: RSDP 000FA0C0, 0014 (r0 AMI   )
[    0.000000] ACPI: RSDT 4FFF0000, 002C (r1 AMIINT VIA_K8         10 
MSFT       97)
[    0.000000] ACPI: FACP 4FFF0030, 0081 (r1 AMIINT VIA_K8         11 
MSFT       97)
[    0.000000] ACPI: DSDT 4FFF0120, 36C5 (r1    VIA   VIA_K8     1000 
MSFT  100000D)
[    0.000000] ACPI: FACS 4FFF8000, 0040
[    0.000000] ACPI: APIC 4FFF00C0, 0054 (r1 AMIINT VIA_K8          9 
MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 004fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> 
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000078c910]    TEXT DATA BSS ==> 
[0000200000 - 000078c910]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #4 [0000010000 - 0000012000]          PGTABLE ==> 
[0000010000 - 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000fba70] 000fba70
[    0.000000]  [ffffe20000000000-ffffe200011fffff] PMD -> 
[ffff880001200000-ffff8800023fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0004fff0
[    0.000000] On node 0 totalpages: 327551
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1523 pages reserved
[    0.000000]   DMA zone: 2404 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4424 pages used for memmap
[    0.000000]   DMA32 zone: 319144 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 
50000000:aec00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 321548
[    0.000000] Kernel command line: root=/dev/sda1 hpet=force
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 1800.008 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 
2097152 bytes)
[    0.000999] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.000999] Checking aperture...
[    0.000999] AGP bridge at 00:00:00
[    0.000999] Aperture from AGP @ d0000000 old size 32 MB
[    0.000999] Aperture from AGP @ d0000000 size 128 MB (APSIZE f20)
[    0.000999] Node 0: aperture @ d0000000 size 128 MB
[    0.000999] Memory: 1282288k/1310656k available (2672k kernel code, 
452k absent, 27308k reserved, 2032k data, 260k init)
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=1
[    0.001024] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3600.01 BogoMIPS (lpj=1800008)
[    0.001173] Mount-cache hash table entries: 256
[    0.001538] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.001589] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001637] tseg: 0000000000
[    0.001674] CPU: AMD Athlon(tm) 64 Processor 2800+ stepping 0a
[    0.001802] ACPI: Core revision 20081031
[    0.010007] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.010070] ftrace: allocating 15382 entries in 122 pages
[    0.013765] Setting APIC routing to flat
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997]   alloc irq_2_pin on cpu 0 node 0
[    0.013997] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.023996] net_namespace: 576 bytes
[    0.023996] NET: Registered protocol family 16
[    0.024021] node 0 link 0: io port [0, ffffff]
[    0.024025] TOM: 0000000050000000 aka 1280M
[    0.024074] node 0 link 0: mmio [a0000, bffff]
[    0.024077] node 0 link 0: mmio [50000000, ffffffff]
[    0.024081] bus: [00,ff] on node 0 link 0
[    0.024083] bus: 00 index 0 io port: [0, ffff]
[    0.024086] bus: 00 index 1 mmio: [a0000, bffff]
[    0.024088] bus: 00 index 2 mmio: [50000000, fcffffffff]
[    0.024098] ACPI: bus type pci registered
[    0.024160] PCI: Using configuration type 1 for base access
[    0.028819] bio: create slab <bio-0> at 0
[    0.029724] ACPI: EC: Look up EC in DSDT
[    0.032014] ACPI Warning (dsobject-0501): Package List length (65) 
larger than NumElements count (2), truncated
[    0.032110]  [20081031]
[    0.036779] ACPI: Interpreter enabled
[    0.036829] ACPI: (supports S0 S1 S3 S5)
[    0.036997] ACPI: Using IOAPIC for interrupt routing
[    0.042058] ACPI: No dock devices found.
[    0.042126] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.042289] pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    0.042376] pci 0000:00:01.0: supports D1
[    0.042407] pci 0000:00:06.0: reg 10 io port: [0xec00-0xecff]
[    0.042413] pci 0000:00:06.0: reg 14 32bit mmio: [0xcfffff00-0xcfffffff]
[    0.042432] pci 0000:00:06.0: reg 30 32bit mmio: [0xcff80000-0xcffbffff]
[    0.042447] pci 0000:00:06.0: supports D1 D2
[    0.042450] pci 0000:00:06.0: PME# supported from D1 D2 D3hot D3cold
[    0.042502] pci 0000:00:06.0: PME# disabled
[    0.042577] pci 0000:00:0b.0: reg 10 io port: [0xe800-0xe8ff]
[    0.042583] pci 0000:00:0b.0: reg 14 32bit mmio: [0xcffffe00-0xcffffeff]
[    0.042602] pci 0000:00:0b.0: reg 30 32bit mmio: [0xcffc0000-0xcffdffff]
[    0.042617] pci 0000:00:0b.0: supports D1 D2
[    0.042620] pci 0000:00:0b.0: PME# supported from D1 D2 D3hot D3cold
[    0.042671] pci 0000:00:0b.0: PME# disabled
[    0.042759] pci 0000:00:0f.0: reg 20 io port: [0xfc00-0xfc0f]
[    0.042820] pci 0000:00:10.0: reg 20 io port: [0xd800-0xd81f]
[    0.042842] pci 0000:00:10.0: supports D1 D2
[    0.042845] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.042896] pci 0000:00:10.0: PME# disabled
[    0.042979] pci 0000:00:10.1: reg 20 io port: [0xdc00-0xdc1f]
[    0.043022] pci 0000:00:10.1: supports D1 D2
[    0.043024] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.043076] pci 0000:00:10.1: PME# disabled
[    0.043160] pci 0000:00:10.2: reg 20 io port: [0xe000-0xe01f]
[    0.043182] pci 0000:00:10.2: supports D1 D2
[    0.043184] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.043236] pci 0000:00:10.2: PME# disabled
[    0.043319] pci 0000:00:10.3: reg 20 io port: [0xe400-0xe41f]
[    0.043341] pci 0000:00:10.3: supports D1 D2
[    0.043343] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.043395] pci 0000:00:10.3: PME# disabled
[    0.043772] pci 0000:00:10.4: reg 10 32bit mmio: [0xcffffc00-0xcffffcff]
[    0.043806] pci 0000:00:10.4: supports D1 D2
[    0.043808] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.043859] pci 0000:00:10.4: PME# disabled
[    0.043959] pci 0000:00:11.0: Force enabled HPET at 0xfed00000
[    0.044010] pci 0000:00:11.5: reg 10 io port: [0xd400-0xd4ff]
[    0.044046] pci 0000:00:11.5: supports D1 D2
[    0.044144] pci 0000:01:00.0: reg 10 32bit mmio: [0xb0000000-0xbfffffff]
[    0.044149] pci 0000:01:00.0: reg 14 io port: [0xc800-0xc8ff]
[    0.044154] pci 0000:01:00.0: reg 18 32bit mmio: [0xcfef0000-0xcfefffff]
[    0.044163] pci 0000:01:00.0: reg 30 32bit mmio: [0xcfec0000-0xcfedffff]
[    0.044175] pci 0000:01:00.0: supports D1 D2
[    0.044196] pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
[    0.044200] pci 0000:00:01.0: bridge 32bit mmio: [0xcfe00000-0xcfefffff]
[    0.044204] pci 0000:00:01.0: bridge 32bit mmio pref: 
[0xafd00000-0xcfcfffff]
[    0.044211] pci 0000:00: bus on NUMA node 0
[    0.044220] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.063160] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.063692] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.064218] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 
14 15)
[    0.064744] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.065271] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.066221] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.066818] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.067403] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.068029] ACPI: Power Resource [URP1] (off)
[    0.068113] ACPI: Power Resource [URP2] (off)
[    0.068197] ACPI: Power Resource [FDDP] (off)
[    0.068280] ACPI: Power Resource [LPTP] (off)
[    0.068739] SCSI subsystem initialized
[    0.068838] libata version 3.00 loaded.
[    0.069007] usbcore: registered new interface driver usbfs
[    0.069098] usbcore: registered new interface driver hub
[    0.069201] usbcore: registered new device driver usb
[    0.069434] PCI: Using ACPI for IRQ routing
[    0.069494] pci 0000:00:00.0: BAR 0: can't allocate resource
[    0.073101] agpgart-amd64 0000:00:00.0: AGP bridge [1106:3188]
[    0.083981] agpgart-amd64 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[    0.084201] hpet clockevent registered
[    0.084209] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.084378] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.088994] pnp: PnP ACPI init
[    0.089049] ACPI: bus type pnp registered
[    0.091981] pnp: PnP ACPI: found 6 devices
[    0.092033] ACPI: ACPI bus type pnp unregistered
[    0.092094] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.092144] system 00:01: ioport range 0x3f0-0x3f1 has been reserved
[    0.092194] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.092244] system 00:01: ioport range 0x400-0x40f has been reserved
[    0.092294] system 00:01: ioport range 0x820-0x821 has been reserved
[    0.092345] system 00:01: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.097682] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.097733] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
[    0.097783] pci 0000:00:01.0:   MEM window: 0xcfe00000-0xcfefffff
[    0.097834] pci 0000:00:01.0:   PREFETCH window: 
0x000000afd00000-0x000000cfcfffff
[    0.097907] pci 0000:00:01.0: setting latency timer to 64
[    0.097912] pci 0000:00: bus resource 0 io:  [0x00-0xffff]
[    0.097915] pci 0000:00: bus resource 1 mem: 
[0x000000-0xffffffffffffffff]
[    0.097918] pci 0000:01: bus resource 0 io:  [0xc000-0xcfff]
[    0.097920] pci 0000:01: bus resource 1 mem: [0xcfe00000-0xcfefffff]
[    0.097923] pci 0000:01: bus resource 2 mem: [0xafd00000-0xcfcfffff]
[    0.097926] pci 0000:01: bus resource 3 mem: [0x0-0x0]
[    0.097973] NET: Registered protocol family 2
[    0.109032] IP route cache hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.110146] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.118296] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.119398] TCP: Hash tables configured (established 262144 bind 65536)
[    0.119449] TCP reno registered
[    0.122093] NET: Registered protocol family 1
[    0.127358] alg: No test for stdrng (krng)
[    0.127546] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.127610] io scheduler noop registered
[    0.127729] io scheduler cfq registered (default)
[    0.127793] PCI: VIA PCI bridge detected. Disabling DAC.
[    0.127963] pci 0000:01:00.0: Boot video device
[    0.128186] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.128249] ACPI: Power Button (FF) [PWRF]
[    0.128414] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.128477] ACPI: Power Button (CM) [PWRB]
[    0.128659] input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.128728] ACPI: Sleep Button (CM) [SLPB]
[    0.129298] processor ACPI_CPU:00: registered as cooling_device0
[    0.142204] Linux agpgart interface v0.103
[    0.142301] [drm] Initialized drm 1.1.0 20060810
[    0.142711]   alloc irq_2_pin on cpu 0 node 0
[    0.142724] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.143012] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[    0.143532] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.143606] r8169 0000:00:0b.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    0.143671] r8169 0000:00:0b.0: PCI: Disallowing DAC for device
[    0.143729] r8169 0000:00:0b.0: no PCI Express capability
[    0.143950] eth0: RTL8110s at 0xffffc2000001ee00, 00:11:09:e8:d8:73, 
XID 04000000 IRQ 16
[    0.147372] Driver 'sd' needs updating - please use bus_type methods
[    0.149500] Driver 'sr' needs updating - please use bus_type methods
[    0.149633] pata_via 0000:00:0f.0: version 0.3.3
[    0.149649]   alloc irq_2_pin on cpu 0 node 0
[    0.149655] pata_via 0000:00:0f.0: PCI INT A -> GSI 20 (level, low) 
-> IRQ 20
[    0.149971] scsi0 : pata_via
[    0.150206] scsi1 : pata_via
[    0.153808] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 
irq 14
[    0.153859] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 
irq 15
[    0.311432] ata1.00: HPA detected: current 156299375, native 156301488
[    0.311486] ata1.00: ATA-6: WDC WD800JB-00JJC0, 05.01C05, max UDMA/100
[    0.311536] ata1.00: 156299375 sectors, multi 16: LBA
[    0.311729] ata1.01: ATA-6: WDC WD800JB-00JJA0, 05.01C05, max UDMA/100
[    0.311779] ata1.01: 156301488 sectors, multi 16: LBA
[    0.315304] ata1.00: configured for UDMA/100
[    0.318295] ata1.01: configured for UDMA/100
[    0.491281] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A104, max UDMA/33
[    0.491361] ata2.01: ATAPI: HL-DT-STDVD-ROM GDR8163B, 0L23, max UDMA/33
[    0.513166] ata2.00: configured for UDMA/33
[    0.535162] ata2.01: configured for UDMA/33
[    0.537923] isa bounce pool size: 16 pages
[    0.538137] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JB-00JJ 
05.0 PQ: 0 ANSI: 5
[    0.538395] sd 0:0:0:0: [sda] 156299375 512-byte hardware sectors: 
(80.0 GB/74.5 GiB)
[    0.538478] sd 0:0:0:0: [sda] Write Protect is off
[    0.538527] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.538557] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.538698] sd 0:0:0:0: [sda] 156299375 512-byte hardware sectors: 
(80.0 GB/74.5 GiB)
[    0.538774] sd 0:0:0:0: [sda] Write Protect is off
[    0.538822] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.538851] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.538922]  sda: sda1 sda2 sda3
[    0.545579] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.545759] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.545957] scsi 0:0:1:0: Direct-Access     ATA      WDC WD800JB-00JJ 
05.0 PQ: 0 ANSI: 5
[    0.546207] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors: 
(80.0 GB/74.5 GiB)
[    0.546284] sd 0:0:1:0: [sdb] Write Protect is off
[    0.546331] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.546359] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.546483] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors: 
(80.0 GB/74.5 GiB)
[    0.546558] sd 0:0:1:0: [sdb] Write Protect is off
[    0.546606] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.546633] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.546698]  sdb: sdb1 sdb2 < sdb5<7>Switched to high resolution mode 
on CPU 0
[    0.587465]  sdb6 >
[    0.587880] sd 0:0:1:0: [sdb] Attached SCSI disk
[    0.588043] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    0.591926] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B 
A104 PQ: 0 ANSI: 5
[    0.604515] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    0.604577] Uniform CD-ROM driver Revision: 3.20
[    0.604765] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    0.604864] sr 1:0:0:0: Attached scsi generic sg2 type 5
[    0.613074] scsi 1:0:1:0: CD-ROM            HL-DT-ST DVD-ROM GDR8163B 
0L23 PQ: 0 ANSI: 5
[    0.620399] sr1: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
[    0.620585] sr 1:0:1:0: Attached scsi CD-ROM sr1
[    0.620691] sr 1:0:1:0: Attached scsi generic sg3 type 5
[    0.620861] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.620952]   alloc irq_2_pin on cpu 0 node 0
[    0.620963] ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) 
-> IRQ 21
[    0.621065] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    0.621168] ehci_hcd 0000:00:10.4: new USB bus registered, assigned 
bus number 1
[    0.621318] ehci_hcd 0000:00:10.4: irq 21, io mem 0xcffffc00
[    0.627007] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[    0.627192] usb usb1: configuration #1 chosen from 1 choice
[    0.627302] hub 1-0:1.0: USB hub found
[    0.627376] hub 1-0:1.0: 8 ports detected
[    0.627653] uhci_hcd: USB Universal Host Controller Interface driver
[    0.627819] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[    0.627877] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    0.627974] uhci_hcd 0000:00:10.0: new USB bus registered, assigned 
bus number 2
[    0.628075] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d800
[    0.628265] usb usb2: configuration #1 chosen from 1 choice
[    0.628372] hub 2-0:1.0: USB hub found
[    0.628433] hub 2-0:1.0: 2 ports detected
[    0.628627] uhci_hcd 0000:00:10.1: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[    0.628681] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    0.628785] uhci_hcd 0000:00:10.1: new USB bus registered, assigned 
bus number 3
[    0.628865] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000dc00
[    0.629057] usb usb3: configuration #1 chosen from 1 choice
[    0.629161] hub 3-0:1.0: USB hub found
[    0.629217] hub 3-0:1.0: 2 ports detected
[    0.629412] uhci_hcd 0000:00:10.2: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[    0.629467] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    0.629564] uhci_hcd 0000:00:10.2: new USB bus registered, assigned 
bus number 4
[    0.629645] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
[    0.629835] usb usb4: configuration #1 chosen from 1 choice
[    0.629938] hub 4-0:1.0: USB hub found
[    0.629995] hub 4-0:1.0: 2 ports detected
[    0.630191] uhci_hcd 0000:00:10.3: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[    0.630245] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    0.630341] uhci_hcd 0000:00:10.3: new USB bus registered, assigned 
bus number 5
[    0.630423] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e400
[    0.630613] usb usb5: configuration #1 chosen from 1 choice
[    0.630725] hub 5-0:1.0: USB hub found
[    0.630796] hub 5-0:1.0: 2 ports detected
[    0.631117] usbcore: registered new interface driver usblp
[    0.631166] Initializing USB Mass Storage driver...
[    0.631282] usbcore: registered new interface driver usb-storage
[    0.631331] USB Mass Storage support registered.
[    0.642090] rtc_cmos 00:03: RTC can wake from S4
[    0.642192] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.642278] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    0.642424] ACPI: I/O resource vt596_smbus [0x400-0x407] conflicts 
with ACPI region SMOV [0x400-0x406]
[    0.642487] ACPI: Device needs an ACPI driver
[    0.642643] cpuidle: using governor ladder
[    0.642690] cpuidle: using governor menu
[    0.642871] usbcore: registered new interface driver usbhid
[    0.642920] usbhid: v2.6:USB HID core driver
[    0.643059] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    0.643475]   alloc irq_2_pin on cpu 0 node 0
[    0.643484] VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, 
low) -> IRQ 22
[    0.643697] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[    1.135012] usb 5-1: new low speed USB device using uhci_hcd and 
address 2
[    1.158129] ALSA device list:
[    1.158184]   #0: VIA 8237 with ALC655 at 0xd400, irq 22
[    1.158272] TCP cubic registered
[    1.158320] NET: Registered protocol family 17
[    1.158388] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 2800+ 
processors (1 cpu cores) (version 2.20.00)
[    1.158528] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x2
[    1.158576] powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
[    1.159128] rtc_cmos 00:03: setting system clock to 2008-12-19 
20:00:06 UTC (1229716806)
[    1.171597] kjournald starting.  Commit interval 5 seconds
[    1.171657] EXT3-fs: mounted filesystem with ordered data mode.
[    1.171719] VFS: Mounted root (ext3 filesystem) readonly.
[    1.171784] Freeing unused kernel memory: 260k freed
[    1.172218] Write protecting the kernel read-only data: 1536k
[    1.295600] usb 5-1: configuration #1 chosen from 1 choice
[    1.314287] input: Logitech USB Mouse as 
/devices/pci0000:00/0000:00:10.3/usb5/5-1/5-1:1.0/input/input3
[    1.317076] generic-usb 0003:046D:C00C.0001: input: USB HID v1.10 
Mouse [Logitech USB Mouse] on usb-0000:00:10.3-1/input0
[    1.523025] usb 5-2: new low speed USB device using uhci_hcd and 
address 3
[    1.693636] usb 5-2: configuration #1 chosen from 1 choice
[    1.711019] input: Microsoft Microsoft® Digital Media Pro Keyboard as 
/devices/pci0000:00/0000:00:10.3/usb5/5-2/5-2:1.0/input/input4
[    1.719101] generic-usb 0003:045E:00B0.0002: input: USB HID v1.11 
Keyboard [Microsoft Microsoft® Digital Media Pro Keyboard] on 
usb-0000:00:10.3-2/input0
[    1.748587] input: Microsoft Microsoft® Digital Media Pro Keyboard as 
/devices/pci0000:00/0000:00:10.3/usb5/5-2/5-2:1.1/input/input5
[    1.754101] generic-usb 0003:045E:00B0.0003: input: USB HID v1.11 
Device [Microsoft Microsoft® Digital Media Pro Keyboard] on 
usb-0000:00:10.3-2/input1
[    2.024888] Marking TSC unstable due to cpufreq changes
[    2.584024] Clocksource tsc unstable (delta = -222214091 ns)
[    4.281970] EXT3 FS on sda1, internal journal
[    4.743154] kjournald starting.  Commit interval 5 seconds
[    4.743171] EXT3-fs warning: maximal mount count reached, running 
e2fsck is recommended
[    4.743441] EXT3 FS on sda3, internal journal
[    4.743451] EXT3-fs: mounted filesystem with ordered data mode.
[    4.791567] Adding 987988k swap on /dev/sda2.  Priority:-1 extents:1 
across:987988k
[   15.790778] r8169: eth0: link up

