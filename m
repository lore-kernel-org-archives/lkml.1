Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZLBMkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZLBMkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZLBMkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:40:12 -0500
Received: from ns0.datapatterns.co.in ([121.242.18.2]:52506 "EHLO
	ns0.datapatterns.co.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZLBMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:40:10 -0500
Message-ID: <9A81E1C4C3C843378F526EF718CD7B07@itd210>
From: "Thirumalai" <thirumalai.p@datapatterns.co.in>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <u-boot@lists.denx.de>
Subject: MPC8640D second core initialization
Date: Wed, 2 Dec 2009 18:09:53 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6001.18000
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6001.18049
X--MailScanner-Information: Please contact your system administrator for more information
X-DataPatterns-MailScanner-ID: nB2CdT4W007662
X--MailScanner: Found to be clean
X--MailScanner-From: thirumalai.p@datapatterns.co.in
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Kumar,
        I am using 2009-06 u-boot for MPC8640D based custom board. I just 
want to know whether the second core of MPC8640D is kicked off automatically 
or will it required by the user to kick[like mpc85xx/mp.c].  Also if am 
enabling the CONFIG_MP macro and  CONFIG_NUM_CPUS as 2, then the reset 
command of the target is not  working(means board is getting hanged). I have 
mentioned the value of CONFIG_SYS_SCRATCH_VA as 0xf5000000.


Also when i try to boot linux using this configuration i was getting into 
kernel panic.

 ## Current stack ends at 0x3fa91a08
## Booting kernel from Legacy Image at 00400000 ...
   Image Name:   Linux-2.6.30-dpvpx0689
   Created:      2009-12-01   4:45:09 UTC
   Image Type:   PowerPC Linux Kernel Image (gzip compressed)
   Data Size:    2307361 Bytes =  2.2 MB
   Load Address: 00000000
   Entry Point:  00000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 04000000
   Booting using the fdt blob at 0x4000000
   Uncompressing Kernel Image ... OK
   Loading Device Tree to 007fa000, end 007ff150 ... OK
## Transferring control to Linux (at address 00000000) ...
   Booting using OF flat tree...
Using DPVPX0689 machine description
Total memory = 1024MB; using 2048kB for hash table (at afe00000)
Linux version 2.6.30-dpvpx0689 (root@localhost.localdomain) (gcc version 
4.0.0 (DENX ELDK 4.0 4.0.0)) #70 SMP Tue Dec 1 10:14:07 IST 2009
Found legacy serial port 0 for /soc@f6000000/serial@4500
  mem=f6004500, taddr=f6004500, irq=0, clk=400000000, speed=0
Found legacy serial port 1 for /soc@f6000000/serial@4600
  mem=f6004600, taddr=f6004600, irq=0, clk=400000000, speed=0
CPU maps initialized for 1 thread per core
 (thread shift is 0)
console [udbg0] enabled
setup_arch: bootmem
dpvpx0689_setup_arch()
Found FSL PCI host bridge at 0x00000000f6008000. Firmware bus number: 0->15
PCI host bridge /pcie@f6008000  ranges:
 MEM 0x0000000080000000..0x000000009fffffff -> 0x0000000080000000
  IO 0x00000000f8000000..0x00000000fbffffff -> 0x0000000000000000
Single Board Computers from Data Patterns
Ported & Developed By COTS DIVISION
arch: exit
Top of RAM: 0x40000000, Total RAM: 0x40000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA      0x00000000 -> 0x00030000
  Normal   0x00030000 -> 0x00030000
  HighMem  0x00030000 -> 0x00040000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00040000
On node 0 totalpages: 262144
free_area_init_node: node 0, pgdat a047d1c0, node_mem_map a07fd000
  DMA zone: 1536 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 195072 pages, LIFO batch:31
  HighMem zone: 512 pages used for memmap
  HighMem zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096
Kernel command line: root=/dev/nfs rw nfsroot=10.5.18.3:/ppc/netfs/fc5fs/ 
ip=10.5.18.230:10.5.18.3:10.5.18.3:255.0.0.0:DPVPX0689:eth0:off 
console=ttyS0,115200
NR_IRQS:512
mpic: Setting up MPIC " MPIC     " version 1.2 at f6040000, max 2 CPUs
mpic: ISU size: 256, shift: 8, mask: ff
mpic: Initializing for 256 sources
PID hash table entries: 4096 (order: 12, 16384 bytes)
time_init: decrementer frequency = 100.000000 MHz
time_init: processor frequency   = 800.000000 MHz
clocksource: timebase mult[2800000] shift[22] registered
clockevent: decrementer mult[1999] shift[16] cpu[0]
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
High memory: 262140k
Memory: 1031504k/1048576k available (4444k kernel code, 16252k reserved, 
160k data, 169k bss, 200k init)
Kernel virtual memory layout:
  * 0xfffe0000..0xfffff000  : fixmap
  * 0xff800000..0xffc00000  : highmem PTEs
  * 0xfe7ed000..0xff800000  : early ioremap
  * 0xd1000000..0xfe7ed000  : vmalloc & ioremap
Calibrating delay loop... 199.68 BogoMIPS (lpj=99840)
Mount-cache hash table entries: 512
mpic: requesting IPIs ...
Processor 1 found.
clockevent: decrementer mult[1999] shift[16] cpu[1]
Brought up 2 CPUs
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xa0023e10
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2 DPVPX0689
Modules linked in:
NIP: a0023e10 LR: a0023dd0 CTR: 00000000
REGS: cf841e90 TRAP: 0300   Not tainted  (2.6.30-dpvpx0689)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24004028  XER: 20000000
DAR: 00000004, DSISR: 40000000
TASK = cf83f930[1] 'swapper' THREAD: cf840000 CPU: 0
GPR00: 00000000 cf841f40 cf83f930 00000000 00000000 00000000 cf841f50 
00000000
GPR08: 00000000 00000000 00000002 a10018f4 22004082 ffffffff 3fee6c00 
3ff94000
GPR16: ffffffbf ffbf7bff 00000000 00000000 00000000 cf83a800 a10018e8 
a0491224
GPR24: a0490000 a04558f8 00000000 cf801f20 a1006070 a10018e8 a10018f8 
00000000
NIP [a0023e10] __build_sched_domains+0x354/0x464
LR [a0023dd0] __build_sched_domains+0x314/0x464
Call Trace:
[cf841f40] [a0023b98] __build_sched_domains+0xdc/0x464 (unreliable)
[cf841f90] [a04326ec] sched_init_smp+0x88/0x1e8
[cf841fc0] [a0425a40] kernel_init+0x148/0x1f0
[cf841ff0] [a00131f8] kernel_thread+0x4c/0x68
Instruction dump:
813e0008 2f9c0000 90090004 419e00d4 801e0034 70090100 40820010 801c0034
70090280 408200bc 83fc0008 83be0008 <807f0004> 801d0004 7c630214 907d0004
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill init!
Rebooting in 180 seconds..
 Kindly suggest me what might be the error.

 Thank you,
 T.

