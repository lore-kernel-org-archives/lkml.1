Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXDASEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXDASEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbXDASEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:04:05 -0400
Received: from smtpout05-04.prod.mesa1.secureserver.net ([64.202.165.221]:39557
	"HELO smtpout05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S933766AbXDASEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:04:00 -0400
Message-ID: <460FF40D.2060109@seclark.us>
Date: Sun, 01 Apr 2007 14:03:57 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.21-rc5 from fc7-rc2 problems
References: <460EC109.5070300@seclark.us> <20070331134610.64a9c410.akpm@linux-foundation.org> <460EFC76.4060808@seclark.us>
In-Reply-To: <460EFC76.4060808@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:

>Andrew Morton wrote:
>
>  
>
>>On Sat, 31 Mar 2007 16:14:01 -0400 Stephen Clark <Stephen.Clark@seclark.us> wrote:
>>
>> 
>>
>>    
>>
>>>Hello,
>>>
>>>I have just tried booting the fc7-rc2 live cd on 2 of my laptops and it 
>>>failed on both.
>>>
>>>Laptop 1 is an asus vbi s96f that get a panic that says exception in 
>>>interrupt routine
>>>for my rtl8139.
>>>
>>>This device works fine in 2.6.20.2
>>>   
>>>
>>>      
>>>
>>That's regression #1.  Are you able to take a photograph of the screen
>>when it has crashed?  Setting the display to 50 rows would make that more
>>useful.  (serial console would be better, but I assume that thing has
>>no serial port).
>>
>> 
>>
>>    
>>
>>>The other laptop is a hp n5430 it fail in the ali-pata driver not being 
>>>able to read the cdrom, timeing out
>>>and dropping into a bash shell telling me to tell it where the root 
>>>filesystem is.
>>>   
>>>
>>>      
>>>
>>That's #2, I guess.
>>
>> 
>>
>>    
>>
>>>Also it sets my hard
>>>drive to udma/33 when it run find at udma/66 under 2.6.20.1.
>>>   
>>>
>>>      
>>>
>>#3.  Hopefully it's related to #2.
>>
>>Please send the full dmesg output for 2.6.20.1 on the n5430.
>>
>> 
>>
>>    
>>
>>>It would 
>>>really be nice if the people makeing
>>>all these changes would at least keep things compatible with what they 
>>>were before. These are regressions
>>>guys!
>>>   
>>>
>>>      
>>>
>>We try ;)
>>
>> 
>>
>>    
>>
>>>This hp n5430 system works fine with 2.6.20.1.
>>>   
>>>
>>>      
>>>
>>Thanks, it helps.
>>
>>
>> 
>>
>>    
>>
>I'll see if I can get a serial port console setup on each laptop, 
>failing that I'll take a
>photo.
>
>Thanks,
>Steve
>
>  
>
First this actually from fc7-rc3 but it is still 2.6.21-rc5

Here is the console output from booting the cd 2.6.21-rc5 on my HP N5430 
laptop
followed by booting fc6 2.6.20.1-2933


Note: From fedora test 3 release anouncement:
System Level Changes
========
    * Fedora 7 Test 3 features a 2.6.21rc5 based kernel. Current release
information is being tracked on the kernel release notes source page.
even though the kernel message below says it is 2.6.20???? maybe fedora 
people can speak to this.

Linux version 2.6.20-1.3023.fc7 
(brewbuilder@ls20-bc1-13.build.redhat.com) (gcc version 4.1.2 20070317 
(Red Hat 4.1.2-5)) #1 SMP Sun Mar 25 22:12:02 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f000 end: 
000000000009f000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f000 size: 0000000000061000 end: 
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 
000000001fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 000000000000f000 end: 
000000001ffff000 type: 3
copy_e820_map() start: 000000001ffff000 size: 0000000000001000 end: 
0000000020000000 type: 4
copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001ffff000 (ACPI data)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 52 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4044 pages, LIFO batch:0
  Normal zone: 1611 pages used for memmap
  Normal zone: 125349 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
Using APIC driver default
ACPI: RSDP 000F7C20, 0014 (r0 PTLTD )
ACPI: RSDT 1FFFCC46, 002C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FFFEF64, 0074 (r1 ALI    M1533     6040000 PTL     F4240)
ACPI: DSDT 1FFFCC72, 22F2 (r1 COMPAL      736  6040000 MSFT  100000D)
ACPI: FACS 1FFFFFC0, 0040
ACPI: BOOT 1FFFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x8008
Allocating PCI resources starting at 30000000 (gap: 20000000:dff80000)
Built 1 zonelists.  Total pages: 129393
Kernel command line: initrd=initrd.img  ro quiet 
root=CDLABEL=Fedora-7-Test3-KDE-Live rootfstype=iso9660 livecd nousb 
console=ttyS0,38400 BOOT_IMAGE=vmlinuz
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0168e000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c079e000 soft=c077e000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 850.084 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1096 kB
 per task-struct memory footprint: 1200 bytes
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 505644k/524224k available (2145k kernel code, 17840k reserved, 
1141k data, 248k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc073b000 - 0xc0779000   ( 248 kB)
      .data : 0xc06185ed - 0xc0735c94   (1141 kB)
      .text : 0xc0400000 - 0xc06185ed   (2145 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1701.44 BogoMIPS 
(lpj=850720)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff c1c7f9ff 00000000 00000000 
00000000 00000000 00000000
Enabling disabled K7/SSE Support.
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 64K (64 bytes/line)
CPU: After all inits, caps: 0383f1ff c1c7f9ff 00000000 00000420 00000000 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0800)
CPU0: AMD mobile AMD Duron(tm) Processor stepping 00
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
sizeof(vma)=84 bytes
sizeof(page)=52 bytes
sizeof(inode)=564 bytes
sizeof(dentry)=156 bytes
sizeof(ext3inode)=800 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=176 bytes
sizeof(task_struct)=2704 bytes
PM: Adding info for No Bus:platform
Time: 17:32:07  Date: 03/01/107
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8b0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0F13:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:power_resource:00
PM: Adding info for acpi:PNP0C0B:00
PM: Adding info for acpi:thermal:01
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 8000-803f claimed by ali7101 ACPI
PCI quirk: region 8040-805f claimed by ali7101 SMB
0000:00:0f.0: cannot adjust BAR0 (not I/O)
0000:00:0f.0: cannot adjust BAR1 (not I/O)
0000:00:0f.0: cannot adjust BAR2 (not I/O)
0000:00:0f.0: cannot adjust BAR3 (not I/O)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:04.0
PM: Adding info for pci:0000:00:04.1
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:07.0
PM: Adding info for pci:0000:00:08.0
PM: Adding info for pci:0000:00:08.1
PM: Adding info for pci:0000:00:0f.0
PM: Adding info for pci:0000:00:10.0
PM: Adding info for pci:0000:01:00.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKU] (IRQs *9)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
pnp: PnP ACPI: found 11 devices
usbcore: USB support disabled
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Time: tsc clocksource has been installed.
pnp: 00:07: ioport range 0x3810-0x381f has been reserved
pnp: 00:07: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:07: ioport range 0x8000-0x805f could not be reserved
pnp: 00:07: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:07: iomem range 0xfffc0000-0xffffffff has been reserved
pnp: 00:07: iomem range 0xfec00000-0xfec00fff has been reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: ea100000-efffffff
  PREFETCH window: 40000000-400fffff
PCI: Bus 2, cardbus bridge: 0000:00:04.0
  IO window: 00002000-000020ff
  IO window: 00002400-000024ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 34000000-37ffffff
PCI: Bus 6, cardbus bridge: 0000:00:04.1
  IO window: 00002800-000028ff
  IO window: 00002c00-00002cff
  PREFETCH window: 38000000-3bffffff
  MEM window: 3c000000-3fffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LNKA] -> GSI 11 (level, 
low) -> IRQ 11
ACPI: PCI Interrupt 0000:00:04.1[A] -> Link [LNKA] -> GSI 11 (level, 
low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 7, 589824 bytes)
TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 4175k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
audit: initializing netlink socket (disabled)
audit(1175448727.052:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 98F5BBBD6BAE5506
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
Activating ISA DMA hang workarounds.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
PM: Adding info for platform:vesafb.0
ACPI: Transitioning device [FAN] to D3
ACPI: Transitioning device [FAN] to D3
ACPI: Fan [FAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (53 C)
Time: acpi_pm clocksource has been installed.
PM: Adding info for No Bus:pnp1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected ALi M1647 chipset
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 64M @ 0xf0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
PM: Adding info for platform:serial8250
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
PM: Removing info for No Bus:ttyS0
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:isa
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
PM: Adding info for No Bus:lo
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:00:04.0 [103c:0018]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:04.0, mfunc 0x009c1b22, devctl 0x66
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000020
PM: Adding info for No Bus:pcmcia_socket0
Yenta: CardBus bridge found at 0000:00:04.1 [103c:0018]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:04.1, mfunc 0x009c1b22, devctl 0x66
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
PM: Adding info for No Bus:pcmcia_socket1
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
mice: PS/2 mouse device common for all mice
pccard: CardBus card inserted into slot 0
PM: Adding info for pci:0000:02:00.0
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow: PowerNOW! Technology present. Can scale: frequency and voltage.
powernow: SGTC: 10000
powernow: Minimum speed 300 MHz. Maximum speed 850 MHz.
powernow-k8: Processor cpuid 670 not supported
Using IPI No-Shortcut mode
  Magic number: 3:342:541
Freeing unused kernel memory: 248k freed
Write protecting the kernel read-only data: 845k
input: PS/2 Generic Mouse as /class/input/input2
SCSI subsystem initialized
libata version 2.20 loaded.
ACPI: Unable to derive IRQ for device 0000:00:0f.0
ACPI: PCI Interrupt 0000:00:0f.0[A]: no GSI
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011000 
irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011008 
irq 15
scsi0 : pata_ali
PM: Adding info for No Bus:host0
ata1.00: ATA-5: HITACHI_DK23CA-20, 00H1A0A3, max UDMA/100   <======== 
drive can do 100
ata1.00: 39070080 sectors, multi 16: LBA
ata1.00: configured for UDMA/33    <=============== configured as 33
scsi1 : pata_ali
PM: Adding info for No Bus:host1
ata2.00: ATAPI, max UDMA/33   <=== cd can't be read now
ata2.00: configured for UDMA/33
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      HITACHI_DK23CA-2 00H1 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
PM: Adding info for No Bus:target1:0:0
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 36 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0xD0 on port 0x00010177
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x2)
ata2.00: revalidation failed (errno=-5)
ata2: failed to recover some devices, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0xd0)
ata2: port failed to respond (30 secs, Status 0xd0)
ata2: soft resetting port
ATA: abnormal status 0xD0 on port 0x00010177
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x2)
ata2.00: revalidation failed (errno=-5)
ata2.00: limiting speed to UDMA/33:PIO3
ata2: failed to recover some devices, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0xd0)
ata2: port failed to respond (30 secs, Status 0xd0)
ata2: soft resetting port
ATA: abnormal status 0xD0 on port 0x00010177
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x2)
ata2.00: revalidation failed (errno=-5)
ata2.00: disabled
ata2: EH complete
PM: Removing info for No Bus:target1:0:0
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda

--------------------------------------
WARNING: Cannot find root file system!
--------------------------------------

Create symlink /dev/root and then exit this shell to continue
the boot sequence.


=============== end of first dmesg =======================
Linux version 2.6.20-1.2933.fc6 
(brewbuilder@hs20-bc2-4.build.redhat.com) (gcc version 4.1.1 20070105 
(Red Hat 4.1.1-51)) #1 SMP Mon Mar 19 11:38:26 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f000 end: 
000000000009f000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f000 size: 0000000000061000 end: 
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 
000000001fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 000000000000f000 end: 
000000001ffff000 type: 3
copy_e820_map() start: 000000001ffff000 size: 0000000000001000 end: 
0000000020000000 type: 4
copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001ffff000 (ACPI data)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 40 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4056 pages, LIFO batch:0
  Normal zone: 1239 pages used for memmap
  Normal zone: 125721 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
Using APIC driver default
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f7c20
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x1fffcc46
ACPI: FADT (v001 ALI    M1533    0x06040000 PTL  0x000f4240) @ 0x1fffef64
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x1fffefd8
ACPI: DSDT (v001 COMPAL      736 0x06040000 MSFT 0x0100000d) @ 0x00000000
ACPI: PM-Timer IO Port: 0x8008
Allocating PCI resources starting at 30000000 (gap: 20000000:dff80000)
Detected 850.074 MHz processor.
Built 1 zonelists.  Total pages: 129777
Kernel command line: ro root=/dev/VolGroup00/LogVol00 nousb ide0=ata66
ide_setup: ide0=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0150c000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c07aa000 soft=c078a000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511544k/524224k available (2188k kernel code, 12068k reserved, 
1157k data, 236k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc074a000 - 0xc0785000   ( 236 kB)
      .data : 0xc0623031 - 0xc0744494   (1157 kB)
      .text : 0xc0400000 - 0xc0623031   (2188 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1700.86 BogoMIPS 
(lpj=850432)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff c1c7f9ff 00000000 00000000 
00000000 00000000 00000000
Enabling disabled K7/SSE Support.
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 64K (64 bytes/line)
CPU: After all inits, caps: 0383f1ff c1c7f9ff 00000000 00000420 00000000 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 0800)
CPU0: AMD mobile AMD Duron(tm) Processor stepping 00
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
sizeof(vma)=84 bytes
sizeof(page)=40 bytes
sizeof(inode)=420 bytes
sizeof(dentry)=144 bytes
sizeof(ext3inode)=596 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=176 bytes
sizeof(task_struct)=1408 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8b0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 8000-803f claimed by ali7101 ACPI
PCI quirk: region 8040-805f claimed by ali7101 SMB
0000:00:0f.0: cannot adjust BAR0 (not I/O)
0000:00:0f.0: cannot adjust BAR1 (not I/O)
0000:00:0f.0: cannot adjust BAR2 (not I/O)
0000:00:0f.0: cannot adjust BAR3 (not I/O)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKU] (IRQs *9)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 11 devices
usbcore: USB support disabled
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:07: ioport range 0x3810-0x381f has been reserved
pnp: 00:07: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:07: ioport range 0x8000-0x805f could not be reserved
pnp: 00:07: ioport range 0x4d6-0x4d6 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: ea100000-efffffff
  PREFETCH window: 40000000-400fffff
PCI: Bus 2, cardbus bridge: 0000:00:04.0
  IO window: 00002000-000020ff
  IO window: 00002400-000024ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 34000000-37ffffff
PCI: Bus 6, cardbus bridge: 0000:00:04.1
  IO window: 00002800-000028ff
  IO window: 00002c00-00002cff
  PREFETCH window: 38000000-3bffffff
  MEM window: 3c000000-3fffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LNKA] -> GSI 11 (level, 
low) -> IRQ 11
ACPI: PCI Interrupt 0000:00:04.1[A] -> Link [LNKA] -> GSI 11 (level, 
low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 6, 327680 bytes)
TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2134k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1175448888.930:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key A99AD4F3D245F54
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
Activating ISA DMA hang workarounds.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Transitioning device [FAN] to D3
ACPI: Transitioning device [FAN] to D3
ACPI: Fan [FAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (48 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected ALi M1647 chipset
agpgart: AGP aperture is 64M @ 0xf0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller at PCI slot 0000:00:0f.0
ACPI: Unable to derive IRQ for device 0000:00:0f.0
ACPI: PCI Interrupt 0000:00:0f.0[A]: no GSI
ALI15X3: chipset revision 195
ALI15X3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: HITACHI_DK23CA-20, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: MATSHITADVD-ROM SR-8175, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide2...
Probing IDE interface ide3...
Probing IDE interface ide4...
Probing IDE interface ide5...
hda: max request size: 128KiB
hda: 39070080 sectors (20003 MB) w/2048KiB Cache, CHS=38760/16/63, UDMA(66)
hda: cache flushes not supported
 hda: hda1 hda2
ide-floppy driver 0.99.newide
Yenta: CardBus bridge found at 0000:00:04.0 [103c:0018]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:04.0, mfunc 0x009c1b22, devctl 0x66
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000020
Yenta: CardBus bridge found at 0000:00:04.1 [103c:0018]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:04.1, mfunc 0x009c1b22, devctl 0x66
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow: PowerNOW! Technology present. Can scale: frequency and voltage.
powernow: SGTC: 10000
powernow: Minimum speed 300 MHz. Maximum speed 850 MHz.
powernow-k8: Processor cpuid 670 not supported
Using IPI No-Shortcut mode
ACPI: (supports S0 S1 S3 S4 S5)
Time: tsc clocksource has been installed.
Freeing unused kernel memory: 236k freed
Write protecting the kernel read-only data: 841k
Time: acpi_pm clocksource has been installed.
pccard: CardBus card inserted into slot 0
USB Universal Host Controller Interface driver v3.0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
input: PS/2 Generic Mouse as /class/input/input2
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1175448899.666:2): selinux=0 auid=4294967295
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
hdc: ATAPI 24X DVD-ROM drive, 512kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Linux Tulip driver version 1.1.14 (May 11, 2002)
PCI: Enabling device 0000:00:10.0 (0010 -> 0013)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
tulip0:  MII transceiver #1 config 3000 status 7849 advertising 01e1.
eth0: ADMtek Comet rev 17 at MMIO 0xea001000, 00:D0:59:5C:E0:EB, IRQ 11.
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
input: PC Speaker as /class/input/input3
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt 
board, set the 'use_gpio' module parameter.
ath_hal: module license 'Proprietary' taints kernel.
ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt 
board, set the 'use_gpio' module parameter.
wlan: 0.8.4.2 (svn r2246)
ath_pci: 0.9.4.5 (svn r2246)
PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, 
low) -> IRQ 11
ath_rate_sample: 1.2 (svn r2246)
wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 
24Mbps 36Mbps 48Mbps 54Mbps
wifi0: H/W encryption support: WEP AES AES_CCM TKIP
wifi0: mac 7.8 phy 4.5 radio 5.6
wifi0: Use hw queue 1 for WME_AC_BE traffic
wifi0: Use hw queue 0 for WME_AC_BK traffic
wifi0: Use hw queue 2 for WME_AC_VI traffic
wifi0: Use hw queue 3 for WME_AC_VO traffic
wifi0: Use hw queue 8 for CAB traffic
wifi0: Use hw queue 9 for beacons
wifi0: Atheros 5212: mem=0x34000000, irq=11
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKC] -> GSI 5 (level, low) 
-> IRQ 5
cs: IO port probe 0x100-0x3af: excluding 0x200-0x207
cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0x48f
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x100-0x3af: excluding 0x200-0x207
cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0x48f
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
lp0: using parport0 (interrupt-driven).
lp0: console ready
sonypi: Sony Programmable I/O Controller Driver v1.26.
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SBTN]
No dock devices found.
ibm_acpi: IBM ThinkPad ACPI Extras v0.13
ibm_acpi: http://ibm-acpi.sf.net/
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 524280k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 
across:524280k
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4095 buckets, 32760 max)
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin 
is 60 seconds).
Hangcheck: Using get_cycles().
ath0: no IPv6 routers present
eth0: no IPv6 routers present



-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



