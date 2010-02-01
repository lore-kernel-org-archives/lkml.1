Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0BAOCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:02:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:26276 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0BAOCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:02:14 -0500
Message-ID: <4B66DE64.8010101@petalogix.com>
Date: Mon, 01 Feb 2010 15:00:04 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       hpa@zytor.com
CC: John Williams <john.williams@petalogix.com>
Subject: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and Linus,

commit 221af7f87b97431e3ee21ce4b0e77d5411cf1549 breaks anything on 
Microblaze. Below is my log.

I reverted this patch in my repo.

Any idea what can be wrong?
None reported any problem that's why I think that is Microblaze related.

Thanks,
Michal



early_printk_console is enabled at 0x84000000
Ramdisk addr 0x00000003, FDT at 0x00000076
<5>Linux version 2.6.33-rc6-00859-gabe94c7-dirty (monstr@monstr.eu) (gcc 
version 4.1.2) #33 Mon Feb 1 14:48:17 CET 2010
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
<6>[    0.000000] setup_memory: max_mapnr: 0x10000
[    0.000000] setup_memory: min_low_pfn: 0x50000
[    0.000000] setup_memory: max_low_pfn: 0x60000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat c026a77c, node_mem_map c0945000
   Normal zone: 512 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line:  console=ttyUL0,115200
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 249984k/262144k available
Hierarchical RCU implementation.
NR_IRQS:32
xlnx,xps-intc-1.00.a #0 at 0xd0000000, num_irq=6, edge=0x2e
xlnx,xps-timer-1.00.a #0 at 0xd0004000, irq=2
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Calibrating delay loop... 59.52 BogoMIPS (lpj=119040)
Mount-cache hash table entries: 512
NET: Registered protocol family 16
XGpio: /plb@0/gpio@81400000: registered
Switching to clocksource microblaze_clocksource
microblaze_timer_set_mode: oneshot
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Skipping unavailable RESET gpio -2 (reset)
GPIO pin is already allocated
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 488
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 5) is a uartlite
console [ttyUL0] enabled
86000000.flash: Found 1 x16 devices at 0x0 in 16-bit bank
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
Using buffer write method
Using auto-unlock on power-up/resume
cfi_cmdset_0001: Erase suspend on write enabled
erase region 0: offset=0x0,size=0x20000,blocks=255
erase region 1: offset=0x1fe0000,size=0x8000,blocks=4
RedBoot partition parsing not available
Creating 6 MTD partitions on "86000000.flash":
0x000000000000-0x000000100000 : "fpga"
0x000000100000-0x000000140000 : "boot"
0x000000140000-0x000000160000 : "bootenv"
0x000000160000-0x000000180000 : "config"
0x000000180000-0x000000980000 : "image"
0x000000980000-0x000002000000 : "spare"
xilinx_emaclite 81000000.ethernet: Device Tree Probing
xilinx_emaclite 81000000.ethernet: MAC address is now  0: a:35: 0:22: 1
xilinx_emaclite 81000000.ethernet: Xilinx EmacLite at 0x81000000 mapped 
to 0xD20A0000, irq=3
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 6928k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting devpts:
/etc/rc.d/S02devpts: line 4: mount: not found
Mounting /etc/config:
Populating /etc/config:
flatfsd: Created 4 configuration files (167 bytes)
Mounting sysfs:
/etc/rc.d/S02sysfs: line 4: /bin/mount: Bad address
Setting hostname:
Bringing up network interfaces:
/etc/rc.d/S40network: line 4: /bin/ifup: Bad address
Starting portmap:
/etc/rc.d/S40network: line 8: /bin/portmap: Bad address
Starting uWeb server:
/etc/rc.d/S90uWeb:
Welcome to
  _____       _           _      _
| ___ \     | |         | |    (_)
| |_/ / ___ | |_   __ _ | |     _  _ __   _   _ __  __
|  __/ / _ \| __| / _` || |    | || '_ \ | | | |\ \/ /
| |   |  __/| |_ | (_| || |____| || | | || |_| | >  <
\_|    \___| \__| \__,_|\_____/|_||_| |_| \__,_|/_/\_\

on ml505-wt-emaclite

line 4: /home/httpd/cgi-bin/petalinux: Bad address

ml505-wt-emaclite login:



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
