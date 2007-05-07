Return-Path: <linux-kernel-owner+w=401wt.eu-S966807AbXEGUsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966807AbXEGUsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966549AbXEGUsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:48:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:12639 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966454AbXEGUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=B6kybf8H+z4ZwZifJ9xagDRnuUcj4m1SZSUWbuJcUreA06KA048MFzZRbF6Gy8QQFF5wkNORrX768H1wZZsbxzEpt3dpGzdLvm+nFnDWdVEDU85NtehSZqHBDCWF3QnqeJKq0G8qafKWA2SsODr6aflOLQ63JeBzAh1hNe55DGg=
Message-ID: <9b5c9bb30705071348x6e7c0badodb74d6c27c2a81e5@mail.gmail.com>
Date: Tue, 8 May 2007 04:48:12 +0800
From: "Teck Choon Giam" <giamteckchoon@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel panic - not syncing: Attempted to kill the idle task! EIP is at uart_console_write+0x21/0x40
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following is the boot message prior to kernel panic:

Linux version 2.6.21.1 (root@XXXX.XXX) (gcc version 3.4.6 20060404
(Red Hat 3.4.6-3)) #1 SMP Mon May 7 04:01:09 SGT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000e6000 size: 000000000001a000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007fd30000 end:
000000007fe30000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007fe30000 size: 00000000000114a0 end:
000000007fe414a0 type: 4
copy_e820_map() start: 000000007fe414a0 size: 00000000000eeb60 end:
000000007ff30000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007ff30000 size: 0000000000010000 end:
000000007ff40000 type: 3
copy_e820_map() start: 000000007ff40000 size: 00000000000b0000 end:
000000007fff0000 type: 4
copy_e820_map() start: 000000007fff0000 size: 0000000000010000 end:
0000000080000000 type: 2
copy_e820_map() start: 00000000fecf0000 size: 0000000000001000 end:
00000000fecf1000 type: 2
copy_e820_map() start: 00000000fed20000 size: 0000000000080000 end:
00000000feda0000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe30000 (usable)
 BIOS-e820: 000000007fe30000 - 000000007fe414a0 (ACPI NVS)
 BIOS-e820: 000000007fe414a0 - 000000007ff30000 (usable)
 BIOS-e820: 000000007ff30000 - 000000007ff40000 (ACPI data)
 BIOS-e820: 000000007ff40000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524080
early_node_map[1] active PFN ranges
    0:        0 ->   524080
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F61A0, 0014 (r0 ACPIAM)
ACPI: RSDT 7FF30000, 0030 (r1 INTEL  S875PWP3 20040429 MSFT       97)
ACPI: FACP 7FF30200, 0081 (r2 INTEL  S875PWP3 20040429 MSFT       97)
ACPI: DSDT 7FF30370, 424E (r1 INTEL  S875PWP3        1 MSFT  100000D)
ACPI: FACS 7FF40000, 0040
ACPI: APIC 7FF30300, 0068 (r1 INTEL  S875PWP3 20040429 MSFT       97)
ACPI: WDDT 7FF345C0, 0040 (r1 INTEL  OEMWDDT         1 MSFT  100000D)
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ecf0000)
Built 1 zonelists.  Total pages: 518963
Kernel command line: ro root=/dev/md1 console=tty0 console=ttyS0,9600
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2793.071 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2069164k/2096320k available (2373k kernel code, 25904k
reserved, 871k data, 252k init, 1178744k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0431000 - 0xc0470000   ( 252 kB)
      .data : 0xc0351766 - 0xc042b3d4   ( 871 kB)
      .text : 0xc0100000 - 0xc0351766   (2373 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5590.57 BogoMIPS (lpj=11181148)
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.44 BogoMIPS (lpj=11172882)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
Total of 2 processors activated (11177.01 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=142
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Firmware left 0000:03:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:0c: ioport range 0x400-0x47f has been reserved
Time: tsc clocksource has been installed.
pnp: 00:0c: ioport range 0x680-0x6ff has been reserved
pnp: 00:0c: ioport range 0x500-0x53f has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0c: iomem range 0xfed20000-0xfed9ffff could not be reserved
pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0d: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: a000-afff
  MEM window: fc900000-fc9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: fca00000-feafffff
  PREFETCH window: 88000000-880fffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 552k freed
audit: initializing netlink socket (disabled)
audit(1178514622.244:1): initialized
audit: cannot initialize inotify handle
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports<1>BUG: unable to handle kernel NULL
pointer dereference at virtual address 00000000
 printing eip:
c0261401
*pde = 00471001
Oops: 0000 [#1]
SMP
Modules linked in:
CPU:    0
EIP:    0020:[<c0261401>]    Not tainted VLI
EFLAGS: 00002710   (2.6.21.1 #1)
EIP is at uart_console_write+0x21/0x40
eax: c026473c   ebx: 00000296   ecx: f7fff280   edx: c18bc900
esi: 00000020   edi: 00000000   ebp: 00000000   esp: f7f01dd4
ds: 0e4a   es: 0002   fs: 0020  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=f7f00000 task=c03ecd40 task.ti=c042c000)
Stack: c04c15e0 00000012 c0264830 c0264720 00000001 00000000 c0403ae0 c02647b0
       00002b49 00000020 c012230e 00002b69 00002b46 00000046 ffffd497 c0122a1a
       00000001 00000000 c047de63 c03fd7f0 c01227a3 f7f01ea8 c03b30ab 00000000
Call Trace:
 [<c0264830>] serial8250_console_write+0x80/0x150
 [<c0264720>] serial8250_console_putchar+0x0/0x90
 [<c02647b0>] serial8250_console_write+0x0/0x150
 [<c012230e>] __call_console_drivers+0x5e/0x70
 [<c0122a1a>] release_console_sem+0x4a/0xb0
 [<c01227a3>] vprintk+0x1b3/0x2a0
 [<c01e431a>] idr_get_new+0xa/0x30
 [<c01aec27>] get_inode_number+0x47/0x70
 [<c01aefc6>] proc_register+0x36/0xc0
 [<c01af363>] create_proc_entry+0x63/0xb0
 [<c044f5fa>] acpi_processor_power_init+0x138/0x168
 [<c01225e7>] printk+0x17/0x20
 [<c044f3ff>] acpi_processor_start+0xc7/0xf2
 [<c0224865>] acpi_start_single_object+0x21/0x3d
 [<c022445e>] acpi_device_probe+0x34/0x41
 [<c02695b4>] really_probe+0xb4/0x170
 [<c0269749>] driver_probe_device+0xc9/0xd0
 [<c02698a1>] __driver_attach+0xc1/0xd0
 [<c02687ea>] bus_for_each_dev+0x3a/0x60
 [<c02698c6>] driver_attach+0x16/0x20
 [<c02697e0>] __driver_attach+0x0/0xd0
 [<c0268e12>] bus_add_driver+0x62/0x110
 [<c044f497>] acpi_processor_init+0x6d/0x98
 [<c0431e11>] do_initcalls+0x41/0x130
 [<c01510bc>] register_irq_proc+0x9c/0xc0
 [<c01af2d2>] proc_mkdir_mode+0x42/0x60
 [<c0431f30>] init+0x0/0xa0
 [<c0431f7c>] init+0x4c/0xa0
 [<c0104a07>] kernel_thread_helper+0x7/0x10
 =======================
Code: 83 c4 24 5b 5e 5f 5d c3 89 f6 55 89 c5 57 89 cf 56 31 f6 53 89
d3 eb 14 89 f6 0f b6 03 3c 0a 74 19 0f be d0 89 e8 46 ff 54 24 14 <43>
EIP: [<c0261401>] uart_console_write+0x21/0x40 SS:ESP 0068:f7f01dd4
Kernel panic - not syncing: Attempted to kill the idle task!


ksymoops output as below:

# ksymoops -o /lib/modules/2.6.21.1/ -m
/usr/src/linux-2.6.21.1/System.map < oops.file
ksymoops 2.4.11 on i686 2.6.20.11.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.21.1/ (specified)
     -m /usr/src/linux-2.6.21.1/System.map (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
1151MB HIGHMEM available.
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: Processor [CPU2] (supports<1>BUG: unable to handle kernel NULL
pointer dereference at virtual address 00000000
c0261401
*pde = 00471001
Oops: 0000 [#1]
CPU:    0
EIP:    0020:[<c0261401>]    Not tainted VLI
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00002710   (2.6.21.1 #1)
eax: c026473c   ebx: 00000296   ecx: f7fff280   edx: c18bc900
esi: 00000020   edi: 00000000   ebp: 00000000   esp: f7f01dd4
ds: 0e4a   es: 0002   fs: 0020  gs: 0000  ss: 0068
Stack: c04c15e0 00000012 c0264830 c0264720 00000001 00000000 c0403ae0 c02647b0
       00002b49 00000020 c012230e 00002b69 00002b46 00000046 ffffd497 c0122a1a
       00000001 00000000 c047de63 c03fd7f0 c01227a3 f7f01ea8 c03b30ab 00000000
Call Trace:
 [<c0264830>] serial8250_console_write+0x80/0x150
 [<c0264720>] serial8250_console_putchar+0x0/0x90
 [<c02647b0>] serial8250_console_write+0x0/0x150
 [<c012230e>] __call_console_drivers+0x5e/0x70
 [<c0122a1a>] release_console_sem+0x4a/0xb0
 [<c01227a3>] vprintk+0x1b3/0x2a0
 [<c01e431a>] idr_get_new+0xa/0x30
 [<c01aec27>] get_inode_number+0x47/0x70
 [<c01aefc6>] proc_register+0x36/0xc0
 [<c01af363>] create_proc_entry+0x63/0xb0
 [<c044f5fa>] acpi_processor_power_init+0x138/0x168
 [<c01225e7>] printk+0x17/0x20
 [<c044f3ff>] acpi_processor_start+0xc7/0xf2
 [<c0224865>] acpi_start_single_object+0x21/0x3d
 [<c022445e>] acpi_device_probe+0x34/0x41
 [<c02695b4>] really_probe+0xb4/0x170
 [<c0269749>] driver_probe_device+0xc9/0xd0
 [<c02698a1>] __driver_attach+0xc1/0xd0
 [<c02687ea>] bus_for_each_dev+0x3a/0x60
 [<c02698c6>] driver_attach+0x16/0x20
 [<c02697e0>] __driver_attach+0x0/0xd0
 [<c0268e12>] bus_add_driver+0x62/0x110
 [<c044f497>] acpi_processor_init+0x6d/0x98
 [<c0431e11>] do_initcalls+0x41/0x130
 [<c01510bc>] register_irq_proc+0x9c/0xc0
 [<c01af2d2>] proc_mkdir_mode+0x42/0x60
 [<c0431f30>] init+0x0/0xa0
 [<c0431f7c>] init+0x4c/0xa0
 [<c0104a07>] kernel_thread_helper+0x7/0x10
Code: 83 c4 24 5b 5e 5f 5d c3 89 f6 55 89 c5 57 89 cf 56 31 f6 53 89
d3 eb 14 89 f6 0f b6 03 3c 0a 74 19 0f be d0 89 e8 46 ff 54 24 14 <43>


>>EIP; c0261401 <uart_read_proc+e1/100>   <=====

>>eax; c026473c <serial8250_verify_port+3c/40>

Trace; c0264830 <serial8250_console_write+40/150>
Trace; c0264720 <serial8250_verify_port+20/40>
Trace; c02647b0 <serial8250_console_putchar+50/90>
Trace; c012230e <__call_console_drivers+5e/70>
Trace; c0122a1a <release_console_sem+4a/b0>
Trace; c01227a3 <vprintk+1b3/2a0>
Trace; c01e431a <idr_get_new+a/30>
Trace; c01aec27 <get_inode_number+47/70>
Trace; c01aefc6 <proc_register+36/c0>
Trace; c01af363 <create_proc_entry+63/b0>
Trace; c044f5fa <acpi_processor_power_init+138/168>
Trace; c01225e7 <printk+17/20>
Trace; c044f3ff <acpi_processor_start+c7/f2>
Trace; c0224865 <acpi_start_single_object+21/3d>
Trace; c022445e <acpi_device_probe+34/41>
Trace; c02695b4 <really_probe+74/170>
Trace; c0269749 <driver_probe_device+89/d0>
Trace; c02698a1 <__driver_attach+81/d0>
Trace; c02687ea <next_device+1a/20>
Trace; c02698c6 <__driver_attach+a6/d0>
Trace; c02697e0 <device_attach+40/80>
Trace; c0268e12 <bus_add_driver+22/110>
Trace; c044f497 <acpi_processor_init+6d/98>
Trace; c0431e11 <do_initcalls+41/130>
Trace; c01510bc <register_irq_proc+9c/c0>
Trace; c01af2d2 <proc_mkdir_mode+42/60>
Trace; c0431f30 <init+0/a0>
Trace; c0431f7c <init+4c/a0>
Trace; c0104a07 <kernel_thread_helper+7/10>

This architecture has variable length instructions, decoding before eip
is unreliable, take these instructions with a pinch of salt.

Code;  c02613d6 <uart_read_proc+b6/100>
00000000 <_EIP>:
Code;  c02613d6 <uart_read_proc+b6/100>
   0:   83 c4 24                  add    $0x24,%esp
Code;  c02613d9 <uart_read_proc+b9/100>
   3:   5b                        pop    %ebx
Code;  c02613da <uart_read_proc+ba/100>
   4:   5e                        pop    %esi
Code;  c02613db <uart_read_proc+bb/100>
   5:   5f                        pop    %edi
Code;  c02613dc <uart_read_proc+bc/100>
   6:   5d                        pop    %ebp
Code;  c02613dd <uart_read_proc+bd/100>
   7:   c3                        ret
Code;  c02613de <uart_read_proc+be/100>
   8:   89 f6                     mov    %esi,%esi
Code;  c02613e0 <uart_read_proc+c0/100>
   a:   55                        push   %ebp
Code;  c02613e1 <uart_read_proc+c1/100>
   b:   89 c5                     mov    %eax,%ebp
Code;  c02613e3 <uart_read_proc+c3/100>
   d:   57                        push   %edi
Code;  c02613e4 <uart_read_proc+c4/100>
   e:   89 cf                     mov    %ecx,%edi
Code;  c02613e6 <uart_read_proc+c6/100>
  10:   56                        push   %esi
Code;  c02613e7 <uart_read_proc+c7/100>
  11:   31 f6                     xor    %esi,%esi
Code;  c02613e9 <uart_read_proc+c9/100>
  13:   53                        push   %ebx
Code;  c02613ea <uart_read_proc+ca/100>
  14:   89 d3                     mov    %edx,%ebx
Code;  c02613ec <uart_read_proc+cc/100>
  16:   eb 14                     jmp    2c <_EIP+0x2c>
Code;  c02613ee <uart_read_proc+ce/100>
  18:   89 f6                     mov    %esi,%esi
Code;  c02613f0 <uart_read_proc+d0/100>
  1a:   0f b6 03                  movzbl (%ebx),%eax
Code;  c02613f3 <uart_read_proc+d3/100>
  1d:   3c 0a                     cmp    $0xa,%al
Code;  c02613f5 <uart_read_proc+d5/100>
  1f:   74 19                     je     3a <_EIP+0x3a>
Code;  c02613f7 <uart_read_proc+d7/100>
  21:   0f be d0                  movsbl %al,%edx
Code;  c02613fa <uart_read_proc+da/100>
  24:   89 e8                     mov    %ebp,%eax
Code;  c02613fc <uart_read_proc+dc/100>
  26:   46                        inc    %esi
Code;  c02613fd <uart_read_proc+dd/100>
  27:   ff 54 24 14               call   *0x14(%esp)

This decode from eip onwards should be reliable

Code;  c0261401 <uart_read_proc+e1/100>
00000000 <_EIP>:
Code;  c0261401 <uart_read_proc+e1/100>
   0:   43                        inc    %ebx

EIP: [<c0261401>] uart_console_write+0x21/0x40 SS:ESP 0068:f7f01dd4
Kernel panic - not syncing: Attempted to kill the idle task!
Warning (Oops_read): Code line not seen, dumping what data is available


>>EIP; c0261401 <uart_read_proc+e1/100>   <=====


1 warning and 1 error issued.  Results may not be reliable.


lspci -vv output as below:
# lspci -vv
00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller
Hub (rev 02)
        Subsystem: Intel Corporation 82875P/E7210 Memory Controller Hub
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [e4] Vendor Specific Information
        Capabilities: [a0] AGP version 3.0
                Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
FW- Rate=<none>

00:01.0 PCI bridge: Intel Corporation 82875P Processor to AGP
Controller (rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:03.0 PCI bridge: Intel Corporation 82875P/E7210 Processor to PCI to
CSA Bridge (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: fc900000-fc9fffff
        Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at cc00 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at d000 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 16
        Region 4: I/O ports at d400 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at d800 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2
EHCI Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 19
        Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fca00000-feafffff
        Prefetchable memory behind bridge: 88000000-880fffff
        Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
Interface Bridge (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]
        Region 5: Memory at 88100000 (32-bit, non-prefetchable) [size=1K]

00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA
Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at ec00 [size=8]
        Region 1: I/O ports at e800 [size=4]
        Region 2: I/O ports at e400 [size=8]
        Region 3: I/O ports at e000 [size=4]
        Region 4: I/O ports at dc00 [size=16]

00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus
Controller (rev 02)
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 18
        Region 4: I/O ports at c800 [size=32]

02:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit
Ethernet Controller (LOM)
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (63750ns min), Cache Line Size 10
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc9e0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at ac00 [size=32]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-

03:06.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev
27) (prog-if 00 [VGA])
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), Cache Line Size 10
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at b800 [size=256]
        Region 2: Memory at feaff000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at 88000000 [disabled] [size=128K]
        Capabilities: [5c] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:08.0 Ethernet controller: Intel Corporation 82562EZ 10/100 Ethernet
Controller (rev 01)
        Subsystem: Intel Corporation S875WP1-E mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), Cache Line Size 10
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at feafe000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at bc00 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-


I have tried the below two patches:

http://bugzilla.kernel.org/attachment.cgi?id=11331&action=view
http://bugzilla.kernel.org/attachment.cgi?id=11332&action=view

Although able to boot but it hang/crash after sometime between few
minutes to couple hours which I do not have null modem connect to the
server thus unable to get any messages during it crashed.

Thanks for any help to fix this bug.

Kindest regards,
Choon
