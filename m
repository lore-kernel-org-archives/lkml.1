Return-Path: <linux-kernel-owner+w=401wt.eu-S1765914AbYARVMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765914AbYARVMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762361AbYARVMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:12:47 -0500
Received: from gw.goop.org ([64.81.55.164]:44980 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761578AbYARVMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:12:42 -0500
Message-ID: <47911646.8030203@goop.org>
Date: Fri, 18 Jan 2008 13:12:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CPA self-test failures
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting under KVM, I get a pile of messages out of the CPA 
self-test.  It makes it to usermode OK though.

    J

Linux version 2.6.24-rc8 (jeremy@ezr) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1879 SMP PREEMPT Fri Jan 18 11:58:38 PST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
 BIOS-e820: 000000002fff0000 - 0000000030000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
767MB LOWMEM available.
Scan SMP from ffd00000 [00000000] for 1024 bytes.
Scan SMP from ffd00c00 [0009fc00] for 1024 bytes.
Scan SMP from ffd00000 [000f0000] for 65536 bytes.
Scan SMP from ffd00c00 [0009fc00] for 1024 bytes.
NX (Execute Disable) protection: active
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   196592
  HighMem    196592 ->   196592
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   196592
DMI not present or invalid.
ACPI: RSDP 000FAE40, 0014 (r0 QEMU  )
ACPI: RSDT 2FFF0000, 002C (r1 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 2FFF002C, 0074 (r2 QEMU   QEMUFACP        1 QEMU        1)
ACPI: DSDT 2FFF0100, 0909 (r1   BXPC   BXDSDT        1 INTL 20061109)
ACPI: FACS 2FFF00C0, 0040
ACPI: APIC 2FFF0A10, 0040 (r1 QEMU   QEMUAPIC        1 QEMU        1)
ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
ACPI: Disabling ACPI support
Allocating PCI resources starting at 40000000 (gap: 30000000:cffc0000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e8000
swsusp: Registered nosave memory region: 00000000000e8000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195057
Kernel command line: console=ttyS0 root=/dev/sda1
Found and enabled local APIC!
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1829.009 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 774132k/786368k available (2823k kernel code, 11680k reserved, 1064k data, 268k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff80000 - 0xfffff000   ( 508 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf0800000 - 0xff9fe000   ( 241 MB)
    lowmem  : 0xc0000000 - 0xefff0000   ( 767 MB)
      .init : 0xc04d2000 - 0xc0515000   ( 268 kB)
      .data : 0xc03c1db1 - 0xc04cbff8   (1064 kB)
      .text : 0xc0100000 - 0xc03c1db1   (2823 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Prune to be done here. max_low_pfn 196592
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3678.38 BogoMIPS (lpj=7356763)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 8K
CPU: L2 cache: 128K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 15k freed
CPU0: Intel QEMU Virtual CPU version 0.9.0 stepping 03
SMP motherboard not detected.
Brought up 1 CPUs
net_namespace: 64 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
No dock devices found.
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
PCI: PCI BIOS revision 2.10 entry at 0xfa8b0, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
PCI quirk: region b000-b03f claimed by PIIX4 ACPI
PCI quirk: region b100-b10f claimed by PIIX4 SMB
PCI: Using IRQ router PIIX/ICH [8086/7000] at 0000:00:01.0
Time: tsc clocksource has been installed.
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
CPA exercising pageattr
CPA mapping 4k 512 large 383 gb 0 x 514[c0000000-c0400000] miss 0
CPA efa2f000: bad pte 800000002fa001e3
CPA efa2f000: unexpected level 2
CPA dfdac000: bad pte 800000001fc001e3
CPA dfdac000: unexpected level 2
CPA e35e8000: bad pte 80000000234001e3
CPA e35e8000: unexpected level 2
CPA ddd06000: bad pte 800000001dc001e3
CPA ddd06000: unexpected level 2
CPA d9459000: bad pte 80000000194001e3
CPA d9459000: unexpected level 2
CPA dbef4000: bad pte 800000001be001e3
CPA dbef4000: unexpected level 2
CPA e85c5000: bad pte 80000000284001e3
CPA e85c5000: unexpected level 2
CPA e362f000: bad pte 80000000236001e3
CPA e362f000: unexpected level 2
CPA d5a5d000: bad pte 8000000015a001e3
CPA d5a5d000: unexpected level 2
CPA dc6cb000: bad pte 800000001c6001e3
CPA dc6cb000: unexpected level 2
CPA dd39a000: bad pte 800000001d2001e3
CPA dd39a000: unexpected level 2
CPA e9f23000: bad pte 8000000029e001e3
CPA e9f23000: unexpected level 2
CPA e86d7000: bad pte 80000000286001e3
CPA e86d7000: unexpected level 2
CPA ef8cf000: bad pte 800000002f8001e3
CPA ef8cf000: unexpected level 2
CPA c9d97000: bad pte 8000000009c001e3
CPA c9d97000: unexpected level 2
CPA eda6b000: bad pte 800000002da001e3
CPA eda6b000: unexpected level 2
CPA ee6d7000: bad pte 800000002e6001e3
CPA ee6d7000: unexpected level 2
CPA c628c000: bad pte 80000000062001e3
CPA c628c000: unexpected level 2
CPA ed7b6000: bad pte 800000002d6001e3
CPA ed7b6000: unexpected level 2
CPA ec2bc000: bad pte 800000002c2001e3
CPA ec2bc000: unexpected level 2
CPA c0940000: bad pte 80000000008001e3
CPA c0940000: unexpected level 2
CPA e1c62000: bad pte 8000000021c001e3
CPA e1c62000: unexpected level 2
CPA e49f5000: bad pte 80000000248001e3
CPA e49f5000: unexpected level 2
CPA dcfdd000: bad pte 800000001ce001e3
CPA dcfdd000: unexpected level 2
CPA eb6fd000: bad pte 800000002b6001e3
CPA eb6fd000: unexpected level 2
CPA d207e000: bad pte 80000000120001e3
CPA d207e000: unexpected level 2
CPA ec8a4000: bad pte 800000002c8001e3
CPA ec8a4000: unexpected level 2
CPA e005d000: bad pte 80000000200001e3
CPA e005d000: unexpected level 2
CPA e50c8000: bad pte 80000000250001e3
CPA e50c8000: unexpected level 2
CPA cf332000: bad pte 800000000f2001e3
CPA cf332000: unexpected level 2
CPA e63df000: bad pte 80000000262001e3
CPA e63df000: unexpected level 2
CPA e6043000: bad pte 80000000260001e3
CPA e6043000: unexpected level 2
CPA e4d76000: bad pte 8000000024c001e3
CPA e4d76000: unexpected level 2
CPA e9011000: bad pte 80000000290001e3
CPA e9011000: unexpected level 2
CPA e3d96000: bad pte 8000000023c001e3
CPA e3d96000: unexpected level 2
CPA e22b8000: bad pte 80000000222001e3
CPA e22b8000: unexpected level 2
CPA de06c000: bad pte 800000001e0001e3
CPA de06c000: unexpected level 2
CPA eedfd000: bad pte 800000002ec001e3
CPA eedfd000: unexpected level 2
CPA cc3f6000: bad pte 800000000c2001e3
CPA cc3f6000: unexpected level 2
CPA ef44e000: bad pte 800000002f4001e3
CPA ef44e000: unexpected level 2
CPA ceaf0000: bad pte 800000000ea001e3
CPA ceaf0000: unexpected level 2
CPA c642e000: bad pte 80000000064001e3
CPA c642e000: unexpected level 2
CPA df8a4000: bad pte 800000001f8001e3
CPA df8a4000: unexpected level 2
CPA dca5c000: bad pte 800000001ca001e3
CPA dca5c000: unexpected level 2
CPA e9c05000: bad pte 8000000029c001e3
CPA e9c05000: unexpected level 2
CPA e54c8000: bad pte 80000000254001e3
CPA e54c8000: unexpected level 2
CPA c6c22000: bad pte 8000000006c001e3
CPA c6c22000: unexpected level 2
CPA c80e9000: bad pte 80000000080001e3
CPA c80e9000: unexpected level 2
CPA e143c000: bad pte 80000000214001e3
CPA e143c000: unexpected level 2
CPA d052f000: bad pte 80000000104001e3
CPA d052f000: unexpected level 2
CPA c769b000: bad pte 80000000076001e3
CPA c769b000: unexpected level 2
CPA c344e000: bad pte 80000000034001e3
CPA c344e000: unexpected level 2
CPA e8f59000: bad pte 8000000028e001e3
CPA e8f59000: unexpected level 2
CPA e396c000: bad pte 80000000238001e3
CPA e396c000: unexpected level 2
CPA debcd000: bad pte 800000001ea001e3
CPA debcd000: unexpected level 2
CPA d95ba000: bad pte 80000000194001e3
CPA d95ba000: unexpected level 2
CPA c836f000: bad pte 80000000082001e3
CPA c836f000: unexpected level 2
CPA d792f000: bad pte 80000000178001e3
CPA d792f000: unexpected level 2
CPA d894c000: bad pte 80000000188001e3
CPA d894c000: unexpected level 2
CPA ee21e000: bad pte 800000002e2001e3
CPA ee21e000: unexpected level 2
CPA c33e9000: bad pte 80000000032001e3
CPA c33e9000: unexpected level 2
CPA c33ad000: bad pte 80000000032001e3
CPA c33ad000: unexpected level 2
CPA cade3000: bad pte 800000000ac001e3
CPA cade3000: unexpected level 2
CPA dddfe000: bad pte 800000001dc001e3
CPA dddfe000: unexpected level 2
CPA eda9b000: bad pte 800000002da001e3
CPA eda9b000: unexpected level 2
CPA e3e9e000: bad pte 8000000023e001e3
CPA e3e9e000: unexpected level 2
CPA d3dd2000: bad pte 8000000013c001e3
CPA d3dd2000: unexpected level 2
CPA c6b27000: bad pte 8000000006a001e3
CPA c6b27000: unexpected level 2
CPA d3b05000: bad pte 8000000013a001e3
CPA d3b05000: unexpected level 2
CPA dc9e1000: bad pte 800000001c8001e3
CPA dc9e1000: unexpected level 2
CPA e5b84000: bad pte 8000000025a001e3
CPA e5b84000: unexpected level 2
CPA d501a000: bad pte 80000000150001e3
CPA d501a000: unexpected level 2
CPA e2dc5000: bad pte 8000000022c001e3
CPA e2dc5000: unexpected level 2
CPA ca5e2000: bad pte 800000000a4001e3
CPA ca5e2000: unexpected level 2
CPA d21ae000: bad pte 80000000120001e3
CPA d21ae000: unexpected level 2
CPA cde96000: bad pte 800000000de001e3
CPA cde96000: unexpected level 2
CPA e3366000: bad pte 80000000232001e3
CPA e3366000: unexpected level 2
CPA d7d5f000: bad pte 8000000017c001e3
CPA d7d5f000: unexpected level 2
CPA d9098000: bad pte 80000000190001e3
CPA d9098000: unexpected level 2
CPA d50e7000: bad pte 80000000150001e3
CPA d50e7000: unexpected level 2
CPA d82b7000: bad pte 80000000182001e3
CPA d82b7000: unexpected level 2
CPA d5a59000: bad pte 8000000015a001e3
CPA d5a59000: unexpected level 2
CPA da2d8000: bad pte 800000001a2001e3
CPA da2d8000: unexpected level 2
CPA d5a23000: bad pte 8000000015a001e3
CPA d5a23000: unexpected level 2
CPA c235c000: bad pte 80000000022001e3
CPA c235c000: unexpected level 2
CPA c484e000: bad pte 80000000048001e3
CPA c484e000: unexpected level 2
CPA d45b1000: bad pte 80000000144001e3
CPA d45b1000: unexpected level 2
CPA dc0db000: bad pte 800000001c0001e3
CPA dc0db000: unexpected level 2
CPA cc06d000: bad pte 800000000c0001e3
CPA cc06d000: unexpected level 2
CPA e29bb000: bad pte 80000000228001e3
CPA e29bb000: unexpected level 2
CPA e22df000: bad pte 80000000222001e3
CPA e22df000: unexpected level 2
CPA c3507000: bad pte 80000000034001e3
CPA c3507000: unexpected level 2
CPA c94fd000: bad pte 80000000094001e3
CPA c94fd000: unexpected level 2
CPA dc41d000: bad pte 800000001c4001e3
CPA dc41d000: unexpected level 2
CPA e9d62000: bad pte 8000000029c001e3
CPA e9d62000: unexpected level 2
CPA c1145000: bad pte 80000000010001e3
CPA c1145000: unexpected level 2
CPA ceb93000: bad pte 800000000ea001e3
CPA ceb93000: unexpected level 2
CPA c4423000: bad pte 80000000044001e3
CPA c4423000: unexpected level 2
CPA eb94b000: bad pte 800000002b8001e3
CPA eb94b000: unexpected level 2
CPA d94fe000: bad pte 80000000194001e3
CPA d94fe000: unexpected level 2
CPA c3dc6000: bad pte 8000000003c001e3
CPA c3dc6000: unexpected level 2
CPA d5e83000: bad pte 8000000015e001e3
CPA d5e83000: unexpected level 2
CPA ee1c5000: bad pte 800000002e0001e3
CPA ee1c5000: unexpected level 2
CPA cc328000: bad pte 800000000c2001e3
CPA cc328000: unexpected level 2
CPA e08bf000: bad pte 80000000208001e3
CPA e08bf000: unexpected level 2
CPA c2afd000: bad pte 8000000002a001e3
CPA c2afd000: unexpected level 2
CPA ede27000: bad pte 800000002de001e3
CPA ede27000: unexpected level 2
CPA df2ed000: bad pte 800000001f2001e3
CPA df2ed000: unexpected level 2
CPA dfb13000: bad pte 800000001fa001e3
CPA dfb13000: unexpected level 2
CPA dd7d1000: bad pte 800000001d6001e3
CPA dd7d1000: unexpected level 2
CPA e94f2000: bad pte 80000000294001e3
CPA e94f2000: unexpected level 2
CPA d9836000: bad pte 80000000198001e3
CPA d9836000: unexpected level 2
CPA d19cd000: bad pte 80000000118001e3
CPA d19cd000: unexpected level 2
CPA dcf30000: bad pte 800000001ce001e3
CPA dcf30000: unexpected level 2
CPA c8a27000: bad pte 8000000008a001e3
CPA c8a27000: unexpected level 2
CPA ea84a000: bad pte 800000002a8001e3
CPA ea84a000: unexpected level 2
CPA d9b39000: bad pte 8000000019a001e3
CPA d9b39000: unexpected level 2
CPA db0c7000: bad pte 800000001b0001e3
CPA db0c7000: unexpected level 2
CPA e0841000: bad pte 80000000208001e3
CPA e0841000: unexpected level 2
CPA c9ac7000: bad pte 8000000009a001e3
CPA c9ac7000: unexpected level 2
CPA e613b000: bad pte 80000000260001e3
CPA e613b000: unexpected level 2
CPA c0e97000: bad pte 8000000000e001e3
CPA c0e97000: unexpected level 2
CPA c1f36000: bad pte 8000000001e001e3
CPA c1f36000: unexpected level 2
CPA d19ef000: bad pte 80000000118001e3
CPA d19ef000: unexpected level 2
CPA d4648000: bad pte 80000000146001e3
CPA d4648000: unexpected level 2
CPA c20af000: bad pte 80000000020001e3
CPA c20af000: unexpected level 2
CPA dda34000: bad pte 800000001da001e3
CPA dda34000: unexpected level 2
CPA d8ca2000: bad pte 8000000018c001e3
CPA d8ca2000: unexpected level 2
CPA cd5b5000: bad pte 800000000d4001e3
CPA cd5b5000: unexpected level 2
CPA eb789000: bad pte 800000002b6001e3
CPA eb789000: unexpected level 2
CPA c36eb000: bad pte 80000000036001e3
CPA c36eb000: unexpected level 2
CPA d7c47000: bad pte 8000000017c001e3
CPA d7c47000: unexpected level 2
CPA ed519000: bad pte 800000002d4001e3
CPA ed519000: unexpected level 2
CPA d01e4000: bad pte 80000000100001e3
CPA d01e4000: unexpected level 2
CPA dbc3d000: bad pte 800000001bc001e3
CPA dbc3d000: unexpected level 2
CPA e0e7b000: bad pte 8000000020e001e3
CPA e0e7b000: unexpected level 2
CPA ee817000: bad pte 800000002e8001e3
CPA ee817000: unexpected level 2
CPA d86ae000: bad pte 80000000186001e3
CPA d86ae000: unexpected level 2
CPA e88b1000: bad pte 80000000288001e3
CPA e88b1000: unexpected level 2
CPA cf2df000: bad pte 800000000f2001e3
CPA cf2df000: unexpected level 2
CPA d3421000: bad pte 80000000134001e3
CPA d3421000: unexpected level 2
CPA ef426000: bad pte 800000002f4001e3
CPA ef426000: unexpected level 2
CPA e3b95000: bad pte 8000000023a001e3
CPA e3b95000: unexpected level 2
CPA c74a2000: bad pte 80000000074001e3
CPA c74a2000: unexpected level 2
CPA c033d000: bad pte 2001e3
CPA c033d000: unexpected level 2
CPA e041b000: bad pte 80000000204001e3
CPA e041b000: unexpected level 2
CPA ccbb1000: bad pte 800000000ca001e3
CPA ccbb1000: unexpected level 2
CPA ce28c000: bad pte 800000000e2001e3
CPA ce28c000: unexpected level 2
CPA dfc83000: bad pte 800000001fc001e3
CPA dfc83000: unexpected level 2
CPA c26a1000: bad pte 80000000026001e3
CPA c26a1000: unexpected level 2
CPA d6f33000: bad pte 8000000016e001e3
CPA d6f33000: unexpected level 2
CPA d4c8c000: bad pte 8000000014c001e3
CPA d4c8c000: unexpected level 2
CPA db901000: bad pte 800000001b8001e3
CPA db901000: unexpected level 2
CPA e15ab000: bad pte 80000000214001e3
CPA e15ab000: unexpected level 2
CPA df470000: bad pte 800000001f4001e3
CPA df470000: unexpected level 2
CPA e0302000: bad pte 80000000202001e3
CPA e0302000: unexpected level 2
CPA c20e8000: bad pte 80000000020001e3
CPA c20e8000: unexpected level 2
CPA ce6e7000: bad pte 800000000e6001e3
CPA ce6e7000: unexpected level 2
CPA d341f000: bad pte 80000000134001e3
CPA d341f000: unexpected level 2
CPA ee7a3000: bad pte 800000002e6001e3
CPA ee7a3000: unexpected level 2
CPA cb235000: bad pte 800000000b2001e3
CPA cb235000: unexpected level 2
CPA d569f000: bad pte 80000000156001e3
CPA d569f000: unexpected level 2
CPA d3abc000: bad pte 8000000013a001e3
CPA d3abc000: unexpected level 2
CPA c9431000: bad pte 80000000094001e3
CPA c9431000: unexpected level 2
CPA e9365000: bad pte 80000000292001e3
CPA e9365000: unexpected level 2
CPA ddf79000: bad pte 800000001de001e3
CPA ddf79000: unexpected level 2
CPA d3803000: bad pte 80000000138001e3
CPA d3803000: unexpected level 2
CPA d21e0000: bad pte 80000000120001e3
CPA d21e0000: unexpected level 2
CPA cfaa7000: bad pte 800000000fa001e3
CPA cfaa7000: unexpected level 2
CPA c941c000: bad pte 80000000094001e3
CPA c941c000: unexpected level 2
CPA dca07000: bad pte 800000001ca001e3
CPA dca07000: unexpected level 2
CPA d9e4c000: bad pte 8000000019e001e3
CPA d9e4c000: unexpected level 2
CPA cc650000: bad pte 800000000c6001e3
CPA cc650000: unexpected level 2
CPA c7466000: bad pte 80000000074001e3
CPA c7466000: unexpected level 2
CPA d34ff000: bad pte 80000000134001e3
CPA d34ff000: unexpected level 2
CPA d15be000: bad pte 80000000114001e3
CPA d15be000: unexpected level 2
CPA c962d000: bad pte 80000000096001e3
CPA c962d000: unexpected level 2
CPA e6732000: bad pte 80000000266001e3
CPA e6732000: unexpected level 2
CPA c242b000: bad pte 80000000024001e3
CPA c242b000: unexpected level 2
CPA ccda6000: bad pte 800000000cc001e3
CPA ccda6000: unexpected level 2
CPA c8a9f000: bad pte 8000000008a001e3
CPA c8a9f000: unexpected level 2
CPA d9aeb000: bad pte 8000000019a001e3
CPA d9aeb000: unexpected level 2
CPA e1a60000: bad pte 8000000021a001e3
CPA e1a60000: unexpected level 2
CPA e10c5000: bad pte 80000000210001e3
CPA e10c5000: unexpected level 2
CPA ebc38000: bad pte 800000002bc001e3
CPA ebc38000: unexpected level 2
CPA ee064000: bad pte 800000002e0001e3
CPA ee064000: unexpected level 2
CPA c86ef000: bad pte 80000000086001e3
CPA c86ef000: unexpected level 2
CPA c1e31000: bad pte 8000000001e001e3
CPA c1e31000: unexpected level 2
CPA ca28c000: bad pte 800000000a2001e3
CPA ca28c000: unexpected level 2
CPA ca644000: bad pte 800000000a6001e3
CPA ca644000: unexpected level 2
CPA c2159000: bad pte 80000000020001e3
CPA c2159000: unexpected level 2
CPA c9c1b000: bad pte 8000000009c001e3
CPA c9c1b000: unexpected level 2
CPA cba9a000: bad pte 800000000ba001e3
CPA cba9a000: unexpected level 2
CPA ef93e000: bad pte 800000002f8001e3
CPA ef93e000: unexpected level 2
CPA cb032000: bad pte 800000000b0001e3
CPA cb032000: unexpected level 2
CPA eaf5e000: bad pte 800000002ae001e3
CPA eaf5e000: unexpected level 2
CPA c306c000: bad pte 80000000030001e3
CPA c306c000: unexpected level 2
CPA efda2000: bad pte 800000002fc001e3
CPA efda2000: unexpected level 2
CPA e61f2000: bad pte 80000000260001e3
CPA e61f2000: unexpected level 2
CPA d2ce2000: bad pte 8000000012c001e3
CPA d2ce2000: unexpected level 2
CPA d9337000: bad pte 80000000192001e3
CPA d9337000: unexpected level 2
CPA edff8000: bad pte 800000002de001e3
CPA edff8000: unexpected level 2
CPA ed390000: bad pte 800000002d2001e3
CPA ed390000: unexpected level 2
CPA e1080000: bad pte 80000000210001e3
CPA e1080000: unexpected level 2
CPA eaa4c000: bad pte 800000002aa001e3
CPA eaa4c000: unexpected level 2
CPA dc37b000: bad pte 800000001c2001e3
CPA dc37b000: unexpected level 2
CPA ea0e7000: bad pte 800000002a0001e3
CPA ea0e7000: unexpected level 2
CPA df12c000: bad pte 800000001f0001e3
CPA df12c000: unexpected level 2
CPA d5465000: bad pte 80000000154001e3
CPA d5465000: unexpected level 2
CPA dec57000: bad pte 800000001ec001e3
CPA dec57000: unexpected level 2
CPA d1325000: bad pte 80000000112001e3
CPA d1325000: unexpected level 2
CPA ed891000: bad pte 800000002d8001e3
CPA ed891000: unexpected level 2
CPA de5eb000: bad pte 800000001e4001e3
CPA de5eb000: unexpected level 2
CPA e4df3000: bad pte 8000000024c001e3
CPA e4df3000: unexpected level 2
CPA c23f2000: bad pte 80000000022001e3
CPA c23f2000: unexpected level 2
CPA ca3d0000: bad pte 800000000a2001e3
CPA ca3d0000: unexpected level 2
CPA dd567000: bad pte 800000001d4001e3
CPA dd567000: unexpected level 2
CPA cf242000: bad pte 800000000f2001e3
CPA cf242000: unexpected level 2
CPA dfa24000: bad pte 800000001fa001e3
CPA dfa24000: unexpected level 2
CPA e1cef000: bad pte 8000000021c001e3
CPA e1cef000: unexpected level 2
CPA df766000: bad pte 800000001f6001e3
CPA df766000: unexpected level 2
CPA c6f0f000: bad pte 8000000006e001e3
CPA c6f0f000: unexpected level 2
CPA c87be000: bad pte 80000000086001e3
CPA c87be000: unexpected level 2
CPA c5381000: bad pte 80000000052001e3
CPA c5381000: unexpected level 2
CPA e8013000: bad pte 80000000280001e3
CPA e8013000: unexpected level 2
CPA dc597000: bad pte 800000001c4001e3
CPA dc597000: unexpected level 2
CPA d61af000: bad pte 80000000160001e3
CPA d61af000: unexpected level 2
CPA da712000: bad pte 800000001a6001e3
CPA da712000: unexpected level 2
CPA cf006000: bad pte 800000000f0001e3
CPA cf006000: unexpected level 2
CPA d51d1000: bad pte 80000000150001e3
CPA d51d1000: unexpected level 2
CPA c4ce6000: bad pte 8000000004c001e3
CPA c4ce6000: unexpected level 2
CPA ec892000: bad pte 800000002c8001e3
CPA ec892000: unexpected level 2
CPA d16f2000: bad pte 80000000116001e3
CPA d16f2000: unexpected level 2
CPA de5af000: bad pte 800000001e4001e3
CPA de5af000: unexpected level 2
CPA de6a3000: bad pte 800000001e6001e3
CPA de6a3000: unexpected level 2
CPA db497000: bad pte 800000001b4001e3
CPA db497000: unexpected level 2
CPA dbf4f000: bad pte 800000001be001e3
CPA dbf4f000: unexpected level 2
CPA cd683000: bad pte 800000000d6001e3
CPA cd683000: unexpected level 2
CPA e0e2c000: bad pte 8000000020e001e3
CPA e0e2c000: unexpected level 2
CPA e4541000: bad pte 80000000244001e3
CPA e4541000: unexpected level 2
CPA ee3fb000: bad pte 800000002e2001e3
CPA ee3fb000: unexpected level 2
CPA cc4fd000: bad pte 800000000c4001e3
CPA cc4fd000: unexpected level 2
CPA c8ba9000: bad pte 8000000008a001e3
CPA c8ba9000: unexpected level 2
CPA ede15000: bad pte 800000002de001e3
CPA ede15000: unexpected level 2
CPA efa1f000: bad pte 800000002fa001e3
CPA efa1f000: unexpected level 2
CPA c5fb6000: bad pte 8000000005e001e3
CPA c5fb6000: unexpected level 2
CPA c7072000: bad pte 80000000070001e3
CPA c7072000: unexpected level 2
CPA d360d000: bad pte 80000000136001e3
CPA d360d000: unexpected level 2
CPA e1738000: bad pte 80000000216001e3
CPA e1738000: unexpected level 2
CPA c8d9c000: bad pte 8000000008c001e3
CPA c8d9c000: unexpected level 2
CPA db381000: bad pte 800000001b2001e3
CPA db381000: unexpected level 2
CPA d13c0000: bad pte 80000000112001e3
CPA d13c0000: unexpected level 2
CPA c800d000: bad pte 80000000080001e3
CPA c800d000: unexpected level 2
CPA cbb86000: bad pte 800000000ba001e3
CPA cbb86000: unexpected level 2
CPA c04db000: bad pte 4001e3
CPA c04db000: unexpected level 2
CPA ede86000: bad pte 800000002de001e3
CPA ede86000: unexpected level 2
CPA ccac5000: bad pte 800000000ca001e3
CPA ccac5000: unexpected level 2
CPA c8915000: bad pte 80000000088001e3
CPA c8915000: unexpected level 2
CPA ccec8000: bad pte 800000000ce001e3
CPA ccec8000: unexpected level 2
CPA e8200000: bad pte 80000000282001e3
CPA e8200000: unexpected level 2
CPA c35e9000: bad pte 80000000034001e3
CPA c35e9000: unexpected level 2
CPA d877b000: bad pte 80000000186001e3
CPA d877b000: unexpected level 2
CPA d17aa000: bad pte 80000000116001e3
CPA d17aa000: unexpected level 2
CPA c0909000: bad pte 80000000008001e3
CPA c0909000: unexpected level 2
CPA e3ca1000: bad pte 8000000023c001e3
CPA e3ca1000: unexpected level 2
CPA d1b1b000: bad pte 8000000011a001e3
CPA d1b1b000: unexpected level 2
CPA e808b000: bad pte 80000000280001e3
CPA e808b000: unexpected level 2
CPA eebe4000: bad pte 800000002ea001e3
CPA eebe4000: unexpected level 2
CPA ddaaa000: bad pte 800000001da001e3
CPA ddaaa000: unexpected level 2
CPA dc840000: bad pte 800000001c8001e3
CPA dc840000: unexpected level 2
CPA d7bd3000: bad pte 8000000017a001e3
CPA d7bd3000: unexpected level 2
CPA c5334000: bad pte 80000000052001e3
CPA c5334000: unexpected level 2
CPA cd73c000: bad pte 800000000d6001e3
CPA cd73c000: unexpected level 2
CPA e4d0d000: bad pte 8000000024c001e3
CPA e4d0d000: unexpected level 2
CPA de81c000: bad pte 800000001e8001e3
CPA de81c000: unexpected level 2
CPA d53f4000: bad pte 80000000152001e3
CPA d53f4000: unexpected level 2
CPA d2b8f000: bad pte 8000000012a001e3
CPA d2b8f000: unexpected level 2
CPA c8d93000: bad pte 8000000008c001e3
CPA c8d93000: unexpected level 2
CPA d3d5f000: bad pte 8000000013c001e3
CPA d3d5f000: unexpected level 2
CPA c5c0d000: bad pte 8000000005c001e3
CPA c5c0d000: unexpected level 2
CPA cffac000: bad pte 800000000fe001e3
CPA cffac000: unexpected level 2
CPA e924d000: bad pte 80000000292001e3
CPA e924d000: unexpected level 2
CPA d288e000: bad pte 80000000128001e3
CPA d288e000: unexpected level 2
CPA e098e000: bad pte 80000000208001e3
CPA e098e000: unexpected level 2
CPA ee947000: bad pte 800000002e8001e3
CPA ee947000: unexpected level 2
CPA d5f9b000: bad pte 8000000015e001e3
CPA d5f9b000: unexpected level 2
CPA cf6e3000: bad pte 800000000f6001e3
CPA cf6e3000: unexpected level 2
CPA ed6f0000: bad pte 800000002d6001e3
CPA ed6f0000: unexpected level 2
CPA e9ca3000: bad pte 8000000029c001e3
CPA e9ca3000: unexpected level 2
CPA ed576000: bad pte 800000002d4001e3
CPA ed576000: unexpected level 2
CPA db288000: bad pte 800000001b2001e3
CPA db288000: unexpected level 2
CPA ea06f000: bad pte 800000002a0001e3
CPA ea06f000: unexpected level 2
CPA dbfcd000: bad pte 800000001be001e3
CPA dbfcd000: unexpected level 2
CPA d9a84000: bad pte 8000000019a001e3
CPA d9a84000: unexpected level 2
CPA c00c8000: bad pte c8163
CPA e8347000: bad pte 80000000282001e3
CPA e8347000: unexpected level 2
CPA c163a000: bad pte 80000000016001e3
CPA c163a000: unexpected level 2
CPA d2499000: bad pte 80000000124001e3
CPA d2499000: unexpected level 2
CPA d8131000: bad pte 80000000180001e3
CPA d8131000: unexpected level 2
CPA ed46f000: bad pte 800000002d4001e3
CPA ed46f000: unexpected level 2
CPA d7359000: bad pte 80000000172001e3
CPA d7359000: unexpected level 2
CPA d3ee5000: bad pte 8000000013e001e3
CPA d3ee5000: unexpected level 2
CPA eecc5000: bad pte 800000002ec001e3
CPA eecc5000: unexpected level 2
CPA d2fe1000: bad pte 8000000012e001e3
CPA d2fe1000: unexpected level 2
CPA c038a000: bad pte 2001e3
CPA c038a000: unexpected level 2
CPA d8183000: bad pte 80000000180001e3
CPA d8183000: unexpected level 2
CPA cdd50000: bad pte 800000000dc001e3
CPA cdd50000: unexpected level 2
CPA cf3a4000: bad pte 800000000f2001e3
CPA cf3a4000: unexpected level 2
CPA c7503000: bad pte 80000000074001e3
CPA c7503000: unexpected level 2
CPA e7933000: bad pte 80000000278001e3
CPA e7933000: unexpected level 2
CPA ce8fc000: bad pte 800000000e8001e3
CPA ce8fc000: unexpected level 2
CPA e1216000: bad pte 80000000212001e3
CPA e1216000: unexpected level 2
CPA ed178000: bad pte 800000002d0001e3
CPA ed178000: unexpected level 2
CPA ef52a000: bad pte 800000002f4001e3
CPA ef52a000: unexpected level 2
CPA c2caa000: bad pte 8000000002c001e3
CPA c2caa000: unexpected level 2
CPA d589d000: bad pte 80000000158001e3
CPA d589d000: unexpected level 2
CPA c43a3000: bad pte 80000000042001e3
CPA c43a3000: unexpected level 2
CPA e8549000: bad pte 80000000284001e3
CPA e8549000: unexpected level 2
CPA d000a000: bad pte 80000000100001e3
CPA d000a000: unexpected level 2
CPA d7a12000: bad pte 8000000017a001e3
CPA d7a12000: unexpected level 2
CPA e6bec000: bad pte 8000000026a001e3
CPA e6bec000: unexpected level 2
CPA d5dc7000: bad pte 8000000015c001e3
CPA d5dc7000: unexpected level 2
CPA c607c000: bad pte 80000000060001e3
CPA c607c000: unexpected level 2
CPA c4a0f000: bad pte 8000000004a001e3
CPA c4a0f000: unexpected level 2
CPA c4d64000: bad pte 8000000004c001e3
CPA c4d64000: unexpected level 2
CPA c7613000: bad pte 80000000076001e3
CPA c7613000: unexpected level 2
CPA d8a0c000: bad pte 8000000018a001e3
CPA d8a0c000: unexpected level 2
CPA d302d000: bad pte 80000000130001e3
CPA d302d000: unexpected level 2
CPA e5b3e000: bad pte 8000000025a001e3
CPA e5b3e000: unexpected level 2
CPA ec41d000: bad pte 800000002c4001e3
CPA ec41d000: unexpected level 2
CPA cf90f000: bad pte 800000000f8001e3
CPA cf90f000: unexpected level 2
CPA cbd2e000: bad pte 800000000bc001e3
CPA cbd2e000: unexpected level 2
CPA d8004000: bad pte 80000000180001e3
CPA d8004000: unexpected level 2
CPA ec036000: bad pte 800000002c0001e3
CPA ec036000: unexpected level 2
CPA d8177000: bad pte 80000000180001e3
CPA d8177000: unexpected level 2
CPA c9b8a000: bad pte 8000000009a001e3
CPA c9b8a000: unexpected level 2
CPA d724f000: bad pte 80000000172001e3
CPA d724f000: unexpected level 2
CPA c1966000: bad pte 80000000018001e3
CPA c1966000: unexpected level 2
CPA c6a7e000: bad pte 8000000006a001e3
CPA c6a7e000: unexpected level 2
CPA ed2d9000: bad pte 800000002d2001e3
CPA ed2d9000: unexpected level 2
CPA dd3fa000: bad pte 800000001d2001e3
CPA dd3fa000: unexpected level 2
CPA d7035000: bad pte 80000000170001e3
CPA d7035000: unexpected level 2
CPA d2530000: bad pte 80000000124001e3
CPA d2530000: unexpected level 2
CPA cdbe1000: bad pte 800000000da001e3
CPA cdbe1000: unexpected level 2
CPA ddcea000: bad pte 800000001dc001e3
CPA ddcea000: unexpected level 2
CPA c3ead000: bad pte 8000000003e001e3
CPA c3ead000: unexpected level 2
CPA c08ce000: bad pte 80000000008001e3
CPA c08ce000: unexpected level 2
CPA ce9c7000: bad pte 800000000e8001e3
CPA ce9c7000: unexpected level 2
CPA c6cd4000: bad pte 8000000006c001e3
CPA c6cd4000: unexpected level 2
CPA eac69000: bad pte 800000002ac001e3
CPA eac69000: unexpected level 2
CPA e911d000: bad pte 80000000290001e3
CPA e911d000: unexpected level 2
CPA c6e76000: bad pte 8000000006e001e3
CPA c6e76000: unexpected level 2
CPA ddbb2000: bad pte 800000001da001e3
CPA ddbb2000: unexpected level 2
CPA df0a4000: bad pte 800000001f0001e3
CPA df0a4000: unexpected level 2
CPA d0cb8000: bad pte 8000000010c001e3
CPA d0cb8000: unexpected level 2
CPA d79f5000: bad pte 80000000178001e3
CPA d79f5000: unexpected level 2
CPA c7035000: bad pte 80000000070001e3
CPA c7035000: unexpected level 2
CPA db128000: bad pte 800000001b0001e3
CPA db128000: unexpected level 2
CPA c46a8000: bad pte 80000000046001e3
CPA c46a8000: unexpected level 2
CPA e413e000: bad pte 80000000240001e3
CPA e413e000: unexpected level 2
CPA c2388000: bad pte 80000000022001e3
CPA c2388000: unexpected level 2
CPA d2243000: bad pte 80000000122001e3
CPA d2243000: unexpected level 2
CPA d233e000: bad pte 80000000122001e3
CPA d233e000: unexpected level 2
CPA d069a000: bad pte 80000000106001e3
CPA d069a000: unexpected level 2
CPA ed915000: bad pte 800000002d8001e3
CPA ed915000: unexpected level 2
CPA cc17e000: bad pte 800000000c0001e3
CPA cc17e000: unexpected level 2
CPA ef4d7000: bad pte 800000002f4001e3
CPA ef4d7000: unexpected level 2
CPA ed104000: bad pte 800000002d0001e3
CPA ed104000: unexpected level 2
CPA e235a000: bad pte 80000000222001e3
CPA e235a000: unexpected level 2
CPA eeee0000: bad pte 800000002ee001e3
CPA eeee0000: unexpected level 2
CPA cab6a000: bad pte 800000000aa001e3
CPA cab6a000: unexpected level 2
CPA d69fa000: bad pte 80000000168001e3
CPA d69fa000: unexpected level 2
CPA c99b8000: bad pte 80000000098001e3
CPA c99b8000: unexpected level 2
CPA cb7be000: bad pte 800000000b6001e3
CPA cb7be000: unexpected level 2
CPA c2613000: bad pte 80000000026001e3
CPA c2613000: unexpected level 2
CPA e5782000: bad pte 80000000256001e3
CPA e5782000: unexpected level 2
CPA e5294000: bad pte 80000000252001e3
CPA e5294000: unexpected level 2
CPA edbec000: bad pte 800000002da001e3
CPA edbec000: unexpected level 2
CPA mapping 4k 512 large 383 gb 0 x 514[c0000000-c0400000] miss 0
CPA reverting everything
CPA mapping 4k 512 large 383 gb 0 x 514[c0000000-c0400000] miss 0
CPA selftests NOT PASSED. Please report.
Total HugeTLB memory allocated, 0
SGI XFS with no debug enabled
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
PCI: PIIX3: Enabling Passive Release on 0000:00:01.0
Activating ISA DMA hang workarounds.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
8139too Fast Ethernet driver 0.9.28
8139too 0000:00:03.0: This (id 10ec:8139 rev 20) is an enhanced 8139C+ chip
8139too 0000:00:03.0: Use the "8139cp" driver for improved performance and stability.
PCI: Found IRQ 11 for device 0000:00:03.0
eth0: RealTek RTL8139 at 0xd000, 52:54:00:12:34:56, IRQ 11
Driver 'sd' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
ata1.00: ATA-7: QEMU HARDDISK, 0.9.0, max UDMA/100
ata1.00: 8388608 sectors, multi 16: LBA48 
ata1.00: configured for MWDMA2
ata2.00: ATAPI: QEMU CD-ROM, 0.9.0, max UDMA/100
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.9. PQ: 0 ANSI: 5
usbmon: debugfs is not available
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
/home/jeremy/hg/xen/paravirt/linux/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Debug warning: early ioremap leak of 1 areas detected.
please boot with early_ioremap_debug and report the dmesg.
------------[ cut here ]------------
WARNING: at /home/jeremy/hg/xen/paravirt/linux/arch/x86/mm/ioremap_32.c:345 check_early_ioremap_leak+0x33/0x3d()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-rc8 #1879
 [<c01269ec>] warn_on_slowpath+0x41/0x51
 [<c0126f74>] ? __call_console_drivers+0x4e/0x5a
 [<c03c0b02>] ? _spin_lock_irqsave+0x27/0x41
 [<c03c0e31>] ? _spin_unlock_irqrestore+0x1b/0x2f
 [<c01271ac>] ? release_console_sem+0x1a0/0x1a8
 [<c01275cb>] ? vprintk+0x2a0/0x2ee
 [<c01275dd>] ? vprintk+0x2b2/0x2ee
 [<c0246a97>] ? __next_cpu+0x15/0x25
 [<c03c0b02>] ? _spin_lock_irqsave+0x27/0x41
 [<c031b30b>] ? unlock_policy_rwsem_write+0x2c/0x2e
 [<c031b345>] ? __cpufreq_remove_dev+0x38/0x19a
 [<c012762e>] ? printk+0x15/0x17
 [<c04e0fbb>] check_early_ioremap_leak+0x33/0x3d
 [<c04d24b8>] kernel_init+0x14f/0x2a5
 [<c0107cae>] ? ret_from_fork+0x6/0x1c
 [<c04d2369>] ? kernel_init+0x0/0x2a5
 [<c04d2369>] ? kernel_init+0x0/0x2a5
 [<c0108a8f>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace cc6c2dd4e14a9e4f ]---
Using IPI No-Shortcut mode
registered taskstats version 1
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 268k freed
modprobe: FATAL: Could not load /lib/modules/2.6.24-rc8/modules.dep: No such file or directory

INIT: version 2.86 booting
                Welcome to Fedora 
                Press 'I' to enter interactive startup.
modprobe: FATAL: Could not load /lib/modules/2.6.24-rc8/modules.dep: No such file or directory

Setting clock : Fri Jan 18 21:10:05 PST 2008 [  OK  ]
Starting udev:

