Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbXEXBlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbXEXBlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762345AbXEXBk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:40:57 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:4554 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761637AbXEXBk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:40:56 -0400
X-Greylist: delayed 2504 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 21:40:56 EDT
Message-Id: <200705240059.l4O0x9Dr004898@www262.sakura.ne.jp>
Subject: [2.6.22-rc2] BUG message during boot.
From: "\"\\\"Tetsuo Handa\\\"\"" <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 May 2007 09:59:09 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I ran 2.6.22-rc2 on Debian Sarge / VMware 5.5.4 / ThinkPad X60
and found a BUG message on startup.
It seems it is harmless because the system can continue running,
but may be something bad?

Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.22-rc2

Thanks.

----- dmesg -----
Linux version 2.6.22-rc2 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Thu May 24 09:33:50 JST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
 BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
512MB LOWMEM available.
found SMP MP-table at 000f6ce0
Entering add_active_range(0, 0, 131072) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131072
  HighMem    131072 ->   131072
early_node_map[1] active PFN ranges
    0:        0 ->   131072
On node 0 totalpages: 131072
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 992 pages used for memmap
  Normal zone: 125984 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI present.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
Processor #0 6:15 APIC version 17
Processor #1 6:15 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists.  Total pages: 130048
Kernel command line: root=/dev/sda1 ro noapic nolapic init=/.init 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1994.933 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514508k/524288k available (2034k kernel code, 9156k reserved, 851k data, 308k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc03d8000 - 0xc0425000   ( 308 kB)
      .data : 0xc02fcb36 - 0xc03d1944   ( 851 kB)
      .text : 0xc0100000 - 0xc02fcb36   (2034 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4010.91 BogoMIPS (lpj=8021837)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0febfbff 20000000 00000000 00000000 0000a215 00000000 00000001
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: After all inits, caps: 0febfbff 20000000 00000000 00003940 0000a215 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
BUG: at mm/slab.c:777 __find_general_cachep()
 [<c015442d>] __kmalloc+0x4d/0xc8
 [<c03e2395>] init_table+0x19/0x4a
 [<c010addb>] mtrr_bp_init+0x176/0x18e
 [<c03e048c>] check_bugs+0x5/0x3b
 [<c03d89f0>] start_kernel+0x1e2/0x1eb
 [<c03d83ec>] unknown_bootoption+0x0/0x181
 =======================
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 15k freed
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3989.33 BogoMIPS (lpj=7978674)
CPU: After generic identify, caps: 0febfbff 20000000 00000000 00000000 0000a215 00000000 00000001
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: After all inits, caps: 0febfbff 20000000 00000000 00003940 0000a215 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Total of 2 processors activated (8000.25 BogoMIPS).
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=2050
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-103f claimed by PIIX4 ACPI
PCI quirk: region 1040-104f claimed by PIIX4 SMB
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 786432 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
Freeing initrd memory: 1076k freed
