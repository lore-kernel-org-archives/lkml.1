Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbXLQO7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbXLQO7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXLQO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:59:33 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:63311 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457AbXLQO7b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:59:31 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Mon, 17 Dec 2007 15:59:26 +0100
User-Agent: KMail/1.9.7
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712171559.26834.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I got another crash, now with 2.6.23.11 on logout from KDE (two differences, 
new kernel, 4gb ram instead of 2gb):

[ 1771.063731] Unable to handle kernel paging request at 0000040000000000 RIP:
[ 1771.063735]  [<ffffffff8044256a>] _spin_lock+0x0/0xf
[ 1771.063740] PGD 0
[ 1771.063741] Oops: 0002 [1] SMP
[ 1771.063743] CPU 0
[ 1771.063744] Modules linked in: k8temp w83627ehf hwmon_vid hwmon i2c_core 
snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi 
snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event 
snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd r8169
[ 1771.063756] Pid: 4418, comm: kdm Not tainted 2.6.23.11reiser4 #1
[ 1771.063758] RIP: 0010:[<ffffffff8044256a>]  [<ffffffff8044256a>] 
_spin_lock+0x0/0xf
[ 1771.063760] RSP: 0018:ffff81012937de10  EFLAGS: 00010206
[ 1771.063762] RAX: ffff81012bd78870 RBX: 0000040000000000 RCX: 
0000000000000000
[ 1771.063764] RDX: 0000000000000000 RSI: ffff81012c549e58 RDI: 
0000040000000000
[ 1771.063765] RBP: ffff81012bd78870 R08: 800000012c52c045 R09: 
0000000000000005
[ 1771.063767] R10: ffff8100050df9f8 R11: 0000000000000002 R12: 
ffff8101280c3760
[ 1771.063768] R13: ffff81012f05fac0 R14: ffff81012c549db0 R15: 
ffff81012f05fac0
[ 1771.063770] FS:  00002b438009bb40(0000) GS:ffffffff80533000(0000) 
knlGS:0000000000000000
[ 1771.063772] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1771.063773] CR2: 0000040000000000 CR3: 000000012d689000 CR4: 
00000000000006e0
[ 1771.063775] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1771.063776] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 1771.063778] Process kdm (pid: 4418, threadinfo ffff81012937c000, task 
ffff81012fca7860)
[ 1771.063779] Stack:  ffffffff8026b084 ffff81012ba17138 ffff81012bd78870 
0000000000000000
[ 1771.063782]  ffffffff80230d0c 00002b438009bbd0 0000000000000000 
ffff81012937df58
[ 1771.063785]  00007fff2aa3d9d0 0000000001200011 0000000000000000 
ffff8101280c3760
[ 1771.063787] Call Trace:
[ 1771.063790]  [<ffffffff8026b084>] anon_vma_link+0x1a/0x40
[ 1771.063793]  [<ffffffff80230d0c>] copy_process+0xb03/0x1301
[ 1771.063798]  [<ffffffff80231670>] do_fork+0xb1/0x1fc
[ 1771.063802]  [<ffffffff8023aa56>] recalc_sigpending+0xe/0x25
[ 1771.063804]  [<ffffffff8020b66e>] system_call+0x7e/0x83
[ 1771.063806]  [<ffffffff8020b987>] ptregscall_common+0x67/0xb0
[ 1771.063810]
[ 1771.063811]
[ 1771.063811] Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c3 f0 81 2f 00 
00
[ 1771.063816] RIP  [<ffffffff8044256a>] _spin_lock+0x0/0xf
[ 1771.063819]  RSP <ffff81012937de10>
[ 1771.063820] CR2: 0000040000000000

also I got some strange message yesterday before increasing ramsize:
19546.639528] swap_free: Bad swap offset entry 04000000
[19733.026587] kio_http_cache_[9814] general protection rip:3919ff1fe9 
rsp:7fff7e1b59f0 error:0

I did swapoff - a, mkswap /dev/sda, swapon -a:
[20105.297668] Adding 1951888k swap on /dev/sda2.  Priority:-2 extents:1 
across:1951888k
[21013.797335] kio_http_cache_[10921] general protection rip:3919ff1fe9 
rsp:7fff39a6d2a0 error:0
[22381.409172] kio_http_cache_[11459] general protection rip:3919ff1fe9 
rsp:7fffd84c4d00 error:0
[23877.759927] kio_http_cache_[11959] general protection rip:3919ff1fe9 
rsp:7fff9895c190 error:0
[25080.581142] kio_http_cache_[13146] general protection rip:3919ff1fe9 
rsp:7fff790e0920 error:0
[26483.315522] kio_http_cache_[13746] general protection rip:3919ff1fe9 
rsp:7fff51933170 error:0
[27696.301584] kio_http_cache_[14417] general protection rip:3919ff1fe9 
rsp:7fff8f38abc0 error:0
[27999.370777] swap_free: Bad swap offset entry 04000000
[27999.434282] swap_free: Bad swap offset entry 04000000
[27999.466035] swap_free: Bad swap offset entry 04000000
[27999.521132] swap_free: Bad swap offset entry 04000000
[27999.561621] VM: killing process ld-linux-x86-64
[27999.561719] swap_free: Bad swap offset entry 04000000

complete dmesg:
[    0.000000] Linux version 2.6.23.11reiser4 (root@energy) (gcc version 4.2.2 
(Gentoo 4.2.2 p1.0)) #1 SMP Sun Dec 16 05:14:21 CET 2007
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FA530, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT   9000720 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR1915A      15A INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC   9000720 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG   9000720 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM   9000720 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0  9000720 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1040 pages reserved
[    0.000000]   DMA zone: 2903 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
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
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 29608 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 1030335
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   90.500818] time.c: Detected 3013.888 MHz processor.
[   90.504978] Console: colour VGA+ 80x25
[   90.504980] console [tty0] enabled
[   90.519605] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[   90.522165] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[   90.523063] Checking aperture...
[   90.523222] CPU 0: aperture @ e8c8000000 size 32 MB
[   90.523380] Aperture too small (32 MB)
[   90.529205] No AGP bridge found
[   90.529362] Your BIOS doesn't leave a aperture memory hole
[   90.529521] Please enable the IOMMU option in the BIOS setup
[   90.529681] This costs you 64 MB of RAM
[   90.555047] Mapping aperture over 65536 KB of RAM @ 8000000
[   90.578803] Memory: 4048944k/4980736k available (2324k kernel code, 144432k 
reserved, 950k data, 180k init)
[   90.660617] Calibrating delay using timer specific routine.. 6034.59 
BogoMIPS (lpj=10053750)
[   90.660968] Mount-cache hash table entries: 256
[   90.661195] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   90.661357] CPU: L2 Cache: 1024K (64 bytes/line)
[   90.661516] CPU: Physical Processor ID: 0
[   90.661674] CPU: Processor Core ID: 0
[   90.661847] SMP alternatives: switching to UP code
[   90.662343] ACPI: Core revision 20070126
[   90.697647] Using local APIC timer interrupts.
[   90.730912] result 12557873
[   90.731067] Detected 12.557 MHz APIC timer.
[   90.733849] SMP alternatives: switching to SMP code
[   90.734208] Booting processor 1/2 APIC 0x1
[   90.744513] Initializing CPU#1
[   90.827002] Calibrating delay using timer specific routine.. 6030.06 
BogoMIPS (lpj=10046502)
[   90.827006] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   90.827008] CPU: L2 Cache: 1024K (64 bytes/line)
[   90.827010] CPU: Physical Processor ID: 0
[   90.827010] CPU: Processor Core ID: 1
[   90.827091] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   90.830237] Brought up 2 CPUs
[   90.831824] NET: Registered protocol family 16
[   90.832058] ACPI: bus type pci registered
[   90.832262] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   90.832422] PCI: Not using MMCONFIG.
[   90.832580] PCI: Using configuration type 1
[   90.835108] ACPI: EC: Look up EC in DSDT
[   90.838603] ACPI: Interpreter enabled
[   90.838762] ACPI: (supports S0 S1 S3 S4 S5)
[   90.839049] ACPI: Using IOAPIC for interrupt routing
[   90.839385] Error attaching device data
[   90.839546] Error attaching device data
[   90.839706] Error attaching device data
[   90.839866] Error attaching device data
[   90.845388] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   90.846012] PCI: Transparent bridge - 0000:00:08.0
[   90.846432] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   90.846567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   90.846669] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   90.846726] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   90.846784] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   90.846842] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   90.850940] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *5
[   90.851393] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *10
[   90.851844] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[   90.852320] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[   90.852772] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[   90.853248] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   90.853714] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[   90.854191] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   90.854643] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   90.855094] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[   90.855570] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   90.856022] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[   90.856498] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[   90.856986] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   90.857438] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[   90.857915] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   90.858367] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[   90.858867] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[   90.859344] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[   90.859821] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[   90.860253] Linux Plug and Play Support v0.97 (c) Adam Belay
[   90.860425] pnp: PnP ACPI init
[   90.860586] ACPI: bus type pnp registered
[   90.863337] pnp: PnP ACPI: found 13 devices
[   90.863497] ACPI: ACPI bus type pnp unregistered
[   90.863761] SCSI subsystem initialized
[   90.863940] libata version 2.21 loaded.
[   90.863990] usbcore: registered new interface driver usbfs
[   90.864167] usbcore: registered new interface driver hub
[   90.864345] usbcore: registered new device driver usb
[   90.864536] PCI: Using ACPI for IRQ routing
[   90.864695] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   90.876832] PCI-DMA: Disabling AGP.
[   90.877685] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   90.877849] PCI-DMA: using GART IOMMU.
[   90.878010] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   90.878290] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   90.878547] hpet0: 3 32-bit timers, 25000000 Hz
[   90.880123] Time: hpet clocksource has been installed.
[   90.890149] pnp: 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   90.890309] pnp: 00:05: ioport range 0x800-0x80f has been reserved
[   90.890470] pnp: 00:05: ioport range 0x2000-0x207f has been reserved
[   90.890630] pnp: 00:05: ioport range 0x2080-0x20ff has been reserved
[   90.890791] pnp: 00:05: ioport range 0x2400-0x247f has been reserved
[   90.890952] pnp: 00:05: ioport range 0x2480-0x24ff has been reserved
[   90.891113] pnp: 00:05: ioport range 0x2800-0x287f has been reserved
[   90.891274] pnp: 00:05: ioport range 0x2880-0x28ff has been reserved
[   90.894675] pnp: 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   90.894836] pnp: 00:05: ioport range 0x2c80-0x2cff has been reserved
[   90.894997] pnp: 00:05: iomem range 0x0-0x0 could not be reserved
[   90.895158] pnp: 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   90.895323] pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[   90.895614] pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   90.895908] pnp: 00:0a: ioport range 0x290-0x29f has been reserved
[   90.896071] pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   90.896235] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   90.896396] pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   90.896557] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   90.896718] pnp: 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[   90.896882] pnp: 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[   90.897365] PCI: Bridge: 0000:00:08.0
[   90.897523]   IO window: d000-dfff
[   90.897682]   MEM window: f9f00000-f9ffffff
[   90.897841]   PREFETCH window: f0000000-f00fffff
[   90.898000] PCI: Bridge: 0000:00:0b.0
[   90.898158]   IO window: c000-cfff
[   90.898316]   MEM window: f9e00000-f9efffff
[   90.898475]   PREFETCH window: disabled.
[   90.898633] PCI: Bridge: 0000:00:0c.0
[   90.898790]   IO window: disabled.
[   90.898948]   MEM window: disabled.
[   90.899105]   PREFETCH window: disabled.
[   90.899264] PCI: Bridge: 0000:00:0d.0
[   90.899422]   IO window: e000-efff
[   90.899580]   MEM window: fa000000-febfffff
[   90.899738]   PREFETCH window: d0000000-dfffffff
[   90.899897] PCI: Bridge: 0000:00:0e.0
[   90.900054]   IO window: disabled.
[   90.900214]   MEM window: disabled.
[   90.900371]   PREFETCH window: disabled.
[   90.900535] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   90.900543] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   90.900549] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   90.900553] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   90.900558] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   90.900578] NET: Registered protocol family 2
[   90.933353] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   90.934123] TCP established hash table entries: 131072 (order: 9, 3145728 
bytes)
[   90.935536] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   90.936120] TCP: Hash tables configured (established 131072 bind 65536)
[   90.936281] TCP reno registered
[   90.947470] Total HugeTLB memory allocated, 0
[   90.947710] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   90.948068] io scheduler noop registered
[   90.948235] io scheduler cfq registered (default)
[   90.949046] Boot video device is 0000:04:00.0
[   90.949162] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   90.949177] assign_interrupt_mode Found MSI capability
[   90.949352] Allocate Port Service[0000:00:0b.0:pcie00]
[   90.949395] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   90.949409] assign_interrupt_mode Found MSI capability
[   90.949577] Allocate Port Service[0000:00:0c.0:pcie00]
[   90.949614] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   90.949628] assign_interrupt_mode Found MSI capability
[   90.949796] Allocate Port Service[0000:00:0d.0:pcie00]
[   90.949832] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   90.949846] assign_interrupt_mode Found MSI capability
[   90.950014] Allocate Port Service[0000:00:0e.0:pcie00]
[   90.950188] input: Power Button (FF) as /class/input/input0
[   90.950348] ACPI: Power Button (FF) [PWRF]
[   90.950560] input: Power Button (CM) as /class/input/input1
[   90.950720] ACPI: Power Button (CM) [PWRB]
[   90.950985] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   90.951333] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   90.955438] Real Time Clock Driver v1.12ac
[   90.955675] hpet_resources: 0xfed00000 is busy
[   90.955686] Linux agpgart interface v0.102
[   90.955845] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, 
margin is 60 seconds).
[   90.956137] Hangcheck: Using get_cycles().
[   90.956352] tun: Universal TUN/TAP device driver, 1.6
[   90.956511] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   90.956690] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   90.956853] ide: Assuming 33MHz system bus speed for PIO modes; override 
with idebus=xx
[   90.957166] NFORCE-MCP65: IDE controller at PCI slot 0000:00:09.0
[   90.957335] NFORCE-MCP65: chipset revision 161
[   90.957494] NFORCE-MCP65: not 100% native mode: will probe irqs later
[   90.957658] NFORCE-MCP65: 0000:00:09.0 (rev a1) UDMA133 controller
[   90.957820]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, 
hdb:pio
[   90.958166] Probing IDE interface ide0...
[   91.246150] hda: SAMSUNG SP1213N, ATA DISK drive
[   91.888005] hda: selected mode 0x45
[   91.888070] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   91.890652] hda: max request size: 512KiB
[   91.890861] hda: 234493056 sectors (120060 MB) w/8192KiB Cache, 
CHS=16383/255/63, UDMA(100)
[   91.891601] hda: cache flushes supported
[   91.891777]  hda: hda1 hda2 hda3 < hda5 hda6 hda7 >
[   91.931121] ahci 0000:00:0a.0: version 2.3
[   91.931299] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   91.931465] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   92.935591] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   92.935888] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   92.936049] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   92.936263] scsi0 : ahci
[   92.936486] scsi1 : ahci
[   92.936677] scsi2 : ahci
[   92.936867] scsi3 : ahci
[   92.937048] ata1: SATA max UDMA/133 cmd 0xffffc20000020100 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   92.937342] ata2: SATA max UDMA/133 cmd 0xffffc20000020180 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   92.937636] ata3: SATA max UDMA/133 cmd 0xffffc20000020200 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   92.937930] ata4: SATA max UDMA/133 cmd 0xffffc20000020280 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   93.411080] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   93.411883] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   93.412045] ata1.00: 312581808 sectors, multi 16: LBA48 
[   93.412797] ata1.00: configured for UDMA/133
[   93.727032] ata2: SATA link down (SStatus 0 SControl 300)
[   94.042987] ata3: SATA link down (SStatus 0 SControl 300)
[   94.358941] ata4: SATA link down (SStatus 0 SControl 300)
[   94.359249] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   94.359599] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   94.359765] sd 0:0:0:0: [sda] Write Protect is off
[   94.359925] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   94.359933] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   94.360249] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   94.360414] sd 0:0:0:0: [sda] Write Protect is off
[   94.360573] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   94.360581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   94.360873]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   94.402906] sd 0:0:0:0: [sda] Attached SCSI disk
[   94.403107] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   94.403289] usbmon: debugfs is not available
[   94.403675] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   94.403840] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   94.404361] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   94.404365] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   94.404613] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   94.404924] ehci_hcd 0000:00:02.1: debug port 1
[   94.405084] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   94.405093] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   94.415579] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   94.415978] usb usb1: configuration #1 chosen from 1 choice
[   94.416164] hub 1-0:1.0: USB hub found
[   94.416325] hub 1-0:1.0: 10 ports detected
[   94.522056] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) 
Driver
[   94.522280] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[   94.522446] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21 
(level, low) -> IRQ 21
[   94.522921] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   94.522925] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   94.523165] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
number 2
[   94.523467] ohci_hcd 0000:00:02.0: irq 21, io mem 0xf9dff000
[   94.580626] usb usb2: configuration #1 chosen from 1 choice
[   94.580811] hub 2-0:1.0: USB hub found
[   94.580975] hub 2-0:1.0: 10 ports detected
[   94.685025] Initializing USB Mass Storage driver...
[   94.754717] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   94.889115] usb 1-3: configuration #1 chosen from 1 choice
[   94.889578] hub 1-3:1.0: USB hub found
[   94.890054] hub 1-3:1.0: 4 ports detected
[   95.456567] usb 1-5: new high speed USB device using ehci_hcd and address 4
[   95.595780] usb 1-5: configuration #1 chosen from 1 choice
[   95.835711] usb 2-4: new full speed USB device using ohci_hcd and address 2
[   95.992441] usb 2-4: configuration #1 chosen from 1 choice
[   95.998394] hub 2-4:1.0: USB hub found
[   96.001364] hub 2-4:1.0: 4 ports detected
[   96.342599] usb 2-4.1: new full speed USB device using ohci_hcd and address 
3
[   96.477358] usb 2-4.1: configuration #1 chosen from 1 choice
[   96.701795] usb 2-4.4: new low speed USB device using ohci_hcd and address 
4
[   96.815598] usb 2-4.4: configuration #1 chosen from 1 choice
[   96.822535] usbcore: registered new interface driver usb-storage
[   96.822696] USB Mass Storage support registered.
[   96.822901] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[   96.825753] serio: i8042 KBD port at 0x60,0x64 irq 1
[   96.825915] serio: i8042 AUX port at 0x60,0x64 irq 12
[   96.826150] mice: PS/2 mouse device common for all mice
[   96.832628] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[   96.832827] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on 
usb-0000:00:02.0-4.4
[   96.833173] usbcore: registered new interface driver usbhid
[   96.833333] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   96.833521] TCP cubic registered
[   96.833686] NET: Registered protocol family 1
[   96.833847] NET: Registered protocol family 17
[   96.834019] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.00.00)
[   96.834249] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   96.834410] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   96.837818] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   96.837978] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   96.838138] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   96.838297] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   96.838457] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   96.838616] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   96.851725] input: AT Translated Set 2 keyboard as /class/input/input3
[   96.950416] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   96.950579] ReiserFS: sda3: using ordered data mode
[   96.959961] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   96.961243] ReiserFS: sda3: checking transaction log (sda3)
[   96.995957] ReiserFS: sda3: Using r5 hash to sort names
[   96.996128] VFS: Mounted root (reiserfs filesystem) readonly.
[   96.996299] Freeing unused kernel memory: 180k freed
[  101.654229] ReiserFS: sda3: switching to journaled data mode
[  102.013470] r8169 Gigabit Ethernet driver 2.2LK loaded
[  102.013713] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[  102.013721] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[  102.013734] PCI: Setting latency timer of device 0000:01:00.0 to 64
[  102.013905] eth0: RTL8168b/8111b at 0xffffc20000176000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 19
[  102.427149] reiser4: sda5: found disk format 4.0.0.
[  107.810143] reiser4: sda6: found disk format 4.0.0.
[  109.081151] reiser4: hda7: found disk format 4.0.0.
[  109.782349] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[  112.863597] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[  112.863606] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[  112.866305] Audigy2 value: Special config.
[  115.009319] hda: selected mode 0x45
[  115.033261] w83627ehf: Found W83627EHG chip at 0x290
[  116.395585] r8169: eth0: link up
[  116.395725] r8169: eth0: link up
[  141.354848] usb 2-2: new low speed USB device using ohci_hcd and address 5
[  141.462517] usb 2-2: configuration #1 chosen from 1 choice
[  141.481877] input: Logitech USB Receiver as /class/input/input4
[  141.481969] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.0-2
[  141.490496] input: Logitech USB Receiver as /class/input/input5
[  141.490587] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.0-2
[  143.719023] usb 2-2: USB disconnect, address 5
[  143.728038] hald-addon-keyb[4055]: segfault at 00000000fffffff8 rip 
000000387fa71845 rsp 00007fff9bb8d350 error 4
[  148.917772] usb 2-2: new low speed USB device using ohci_hcd and address 6
[  149.025834] usb 2-2: configuration #1 chosen from 1 choice
[  149.042218] input: Logitech USB Receiver as /class/input/input6
[  149.042262] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.0-2
[  149.053719] input: Logitech USB Receiver as /class/input/input7
[  149.053857] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.0-2
[  149.626175] usb 2-2: USB disconnect, address 6
[  149.634782] hald-addon-keyb[4099]: segfault at 00000000fffffff8 rip 
000000387fa71845 rsp 00007fff75d9e560 error 4
[  151.496394] usb 2-1: new low speed USB device using ohci_hcd and address 7
[  151.604409] usb 2-1: configuration #1 chosen from 1 choice
[  151.618438] input: Logitech USB Receiver as /class/input/input8
[  151.618530] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.0-1
[  151.627073] input: Logitech USB Receiver as /class/input/input9
[  151.627153] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.0-1
[  152.301309] usb 2-1: USB disconnect, address 7
[  152.306039] hald-addon-keyb[4143]: segfault at 00000000fffffff8 rip 
000000387fa71845 rsp 00007fffabc6e430 error 4
[  163.250003] usb 1-3.1: new low speed USB device using ehci_hcd and address 
8
[  163.314229] usb 1-3.1: configuration #1 chosen from 1 choice
[  163.322789] input: Logitech USB Receiver as /class/input/input10
[  163.322704] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[  163.326853] input: Logitech USB Receiver as /class/input/input11
[  163.326877] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[  165.337646] usb 1-3.1: USB disconnect, address 8
[  165.339431] hald-addon-keyb[4188]: segfault at 00000000fffffff8 rip 
000000387fa71845 rsp 00007fff04610df0 error 4
[  168.790680] usb 2-2: new low speed USB device using ohci_hcd and address 8
[  168.898534] usb 2-2: configuration #1 chosen from 1 choice
[  168.912448] input: Logitech USB Receiver as /class/input/input12
[  168.912594] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.0-2
[  168.921142] input: Logitech USB Receiver as /class/input/input13
[  168.921234] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.0-2
[  242.510214] usb 2-4.4: USB disconnect, address 4
[  343.072949] kio_http_cache_[4577] general protection rip:3919ff1fe9 
rsp:7fffb5d915d0 error:0
[ 1771.063731] Unable to handle kernel paging request at 0000040000000000 RIP: 
[ 1771.063735]  [<ffffffff8044256a>] _spin_lock+0x0/0xf
[ 1771.063740] PGD 0 
[ 1771.063741] Oops: 0002 [1] SMP 
[ 1771.063743] CPU 0 
[ 1771.063744] Modules linked in: k8temp w83627ehf hwmon_vid hwmon i2c_core 
snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi 
snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event 
snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd r8169
[ 1771.063756] Pid: 4418, comm: kdm Not tainted 2.6.23.11reiser4 #1
[ 1771.063758] RIP: 0010:[<ffffffff8044256a>]  [<ffffffff8044256a>] 
_spin_lock+0x0/0xf
[ 1771.063760] RSP: 0018:ffff81012937de10  EFLAGS: 00010206
[ 1771.063762] RAX: ffff81012bd78870 RBX: 0000040000000000 RCX: 
0000000000000000
[ 1771.063764] RDX: 0000000000000000 RSI: ffff81012c549e58 RDI: 
0000040000000000
[ 1771.063765] RBP: ffff81012bd78870 R08: 800000012c52c045 R09: 
0000000000000005
[ 1771.063767] R10: ffff8100050df9f8 R11: 0000000000000002 R12: 
ffff8101280c3760
[ 1771.063768] R13: ffff81012f05fac0 R14: ffff81012c549db0 R15: 
ffff81012f05fac0
[ 1771.063770] FS:  00002b438009bb40(0000) GS:ffffffff80533000(0000) 
knlGS:0000000000000000
[ 1771.063772] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1771.063773] CR2: 0000040000000000 CR3: 000000012d689000 CR4: 
00000000000006e0
[ 1771.063775] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1771.063776] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 1771.063778] Process kdm (pid: 4418, threadinfo ffff81012937c000, task 
ffff81012fca7860)
[ 1771.063779] Stack:  ffffffff8026b084 ffff81012ba17138 ffff81012bd78870 
0000000000000000
[ 1771.063782]  ffffffff80230d0c 00002b438009bbd0 0000000000000000 
ffff81012937df58
[ 1771.063785]  00007fff2aa3d9d0 0000000001200011 0000000000000000 
ffff8101280c3760
[ 1771.063787] Call Trace:
[ 1771.063790]  [<ffffffff8026b084>] anon_vma_link+0x1a/0x40
[ 1771.063793]  [<ffffffff80230d0c>] copy_process+0xb03/0x1301
[ 1771.063798]  [<ffffffff80231670>] do_fork+0xb1/0x1fc
[ 1771.063802]  [<ffffffff8023aa56>] recalc_sigpending+0xe/0x25
[ 1771.063804]  [<ffffffff8020b66e>] system_call+0x7e/0x83
[ 1771.063806]  [<ffffffff8020b987>] ptregscall_common+0x67/0xb0
[ 1771.063810] 
[ 1771.063811] 
[ 1771.063811] Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c3 f0 81 2f 00 
00 
[ 1771.063816] RIP  [<ffffffff8044256a>] _spin_lock+0x0/0xf
[ 1771.063819]  RSP <ffff81012937de10>
[ 1771.063820] CR2: 0000040000000000

Glück Auf,
Volker
