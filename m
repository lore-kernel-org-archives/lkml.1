Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYAQSSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYAQSSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYAQSR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:17:56 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43887 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYAQSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:17:54 -0500
X-Auth-Info: Svky5SppToRNS6KQXLtAzTQwkeTND5UlrYwj7px4js4=
X-Auth-Info: Svky5SppToRNS6KQXLtAzTQwkeTND5UlrYwj7px4js4=
X-Auth-Info: Svky5SppToRNS6KQXLtAzTQwkeTND5UlrYwj7px4js4=
X-Auth-Info: Svky5SppToRNS6KQXLtAzTQwkeTND5UlrYwj7px4js4=
X-Auth-Info: Svky5SppToRNS6KQXLtAzTQwkeTND5UlrYwj7px4js4=
X-Auth-Info: Svky5SppToRNS6KQXLtAzTQwkeTND5UlrYwj7px4js4=
Message-ID: <478F9BCE.4030301@grandegger.com>
Date: Thu, 17 Jan 2008 19:17:50 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1
References: <1200544050.318.18.camel@localhost.localdomain>	 <478F2A46.5070506@grandegger.com> <1200586632.18731.141.camel@imap.mvista.com>
In-Reply-To: <1200586632.18731.141.camel@imap.mvista.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: multipart/mixed;
 boundary="------------030205010604090302090508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030205010604090302090508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Daniel Walker wrote:
> On Thu, 2008-01-17 at 11:13 +0100, Wolfgang Grandegger wrote:
>> Steven Rostedt wrote:
>>> We are pleased to announce the 2.6.24-rc8-rt1 tree, which can be
>>> downloaded from the location:
>>>
>>>   http://rt.et.redhat.com/download/
>> It builds and runs fine on my Icecube-MPC5200 board, now also with the
>> latency tracer enabled. That's great. Still, "cyclictest -n -p80 -i1000"
>> reports latencies up to 400 us and therefore I tried to trigger and save
>> a high latency trace using:
> 
> Do you happen to have a boot log (dmesg) for this system?

Yes, of course, see attachment.

Wolfgang.

--------------030205010604090302090508
Content-Type: text/x-log;
 name="boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot.log"

=> boot
Using FEC ETHERNET device
TFTP from server 10.0.30.2; our IP address is 10.0.30.199
Filename 'icecube/uImage-rt-lat'.
Load address: 0x400000
Loading: #################################################################
         ####################################
done
Bytes transferred = 1474093 (167e2d hex)
## Booting image at 00400000 ...
   Image Name:   Linux-2.6.24-rc8-rt1
   Created:      2008-01-17   9:59:11 UTC
   Image Type:   PowerPC Linux Kernel Image (gzip compressed)
   Data Size:    1474029 Bytes =  1.4 MB
   Load Address: 00000000
   Entry Point:  00000000
   Verifying Checksum ... OK
   Uncompressing Kernel Image ... OK
   Booting using the fdt at 0xff850000
   Loading Device Tree to 007fc000, end 007fefff ... OK
[    0.000000] Using lite5200 machine description
[    0.000000] Linux version 2.6.24-rc8-rt1 (wolf@lancy.lan.de) (gcc version 4.0.0 (DENX ELDK 4.1 4.0.0)) #6 PREEMPT RT Thu Jan 17 10:59:02 CET 2008
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->    16384
[    0.000000]   Normal      16384 ->    16384
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    16384
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
[    0.000000] Kernel command line: root=/dev/nfs rw nfsroot=10.0.30.2:/data//ELDK/v4.1/ppc_6xx ip=10.0.30.199:10.0.30.2::255.255.255.0:lite5200:eth0:off console=ttyPSC0,115200
[    0.000000] WARNING: experimental RCU implementation.
[    0.000000] MPC52xx PIC is up and running!
[    0.000000] PID hash table entries: 256 (order: 8, 1024 bytes)
[    0.000019] clocksource: timebase mult[79364d9] shift[22] registered
[    0.000345] console [ttyPSC0] enabled
[    0.098764] num_possible_cpus(): 1
[    0.147047] CPU#0: allocated 2097152 bytes trace buffer.
[    0.197391] CPU#0: allocated 2097152 bytes max-trace buffer.
[    0.248029] allocated 2097152 bytes out-trace buffer.
[    0.253223] tracer: a total of 6291456 bytes allocated.
[    0.258951] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.266485] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.283562] Memory: 55256k/65536k available (3024k kernel code, 10220k reserved, 172k data, 236k bss, 176k init)
[    0.387337] Mount-cache hash table entries: 512
[    0.405903] net_namespace: 76 bytes
[    0.414103] NET: Registered protocol family 16
[    0.458695] PCI: Probing PCI hardware
[    0.468126] DMA: MPC52xx BestComm driver
[    0.473000] DMA: MPC52xx BestComm engine @f0001200 ok !
[    0.499454] SCSI subsystem initialized
[    0.567145] NET: Registered protocol family 2
[    0.715232] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.725291] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.733248] TCP bind hash table entries: 2048 (order: 3, 57344 bytes)
[    0.741132] TCP: Hash tables configured (established 2048 bind 2048)
[    0.747981] TCP reno registered
[    0.805896] krcupreemptd setsched 0
[    0.809657]   prio = 98
[    0.816864] io scheduler noop registered
[    0.821149] io scheduler anticipatory registered (default)
[    0.827137] io scheduler deadline registered
[    0.831849] io scheduler cfq registered
[    1.532740] Serial: MPC52xx PSC UART driver
[    1.539120] f0002000.serial: ttyPSC0 at MMIO 0xf0002000 (irq = 129) is a MPC52xx PSC
[    1.568537] RAMDISK driver initialized: 16 RAM disks of 32768K size 1024 blocksize
[    1.586580] loop: module loaded
[    1.631604] mpc52xx MII bus: probed
[    1.640809] ata: MPC52xx IDE/ATA libata driver
[    1.649069] scsi0 : mpc52xx_ata
[    1.653845] ata1: PATA max PIO4 ata_regs 0xf0003a00 irq 135
[    1.843308] TCP cubic registered
[    1.846923] NET: Registered protocol family 1
[    1.851717] NET: Registered protocol family 17
[    1.858127] RPC: Registered udp transport module.
[    1.863271] RPC: Registered tcp transport module.
[    2.381436] net eth0: attached phy 0 to driver Generic PHY
[    3.392504] IP-Config: Complete:
[    3.395845]       device=eth0, addr=10.0.30.199, mask=255.255.255.0, gw=255.255.255.255,
[    3.404378]      host=lite5200, domain=, nis-domain=(none),
[    3.410215]      bootserver=10.0.30.2, rootserver=10.0.30.2, rootpath=
[    3.419137] Looking up port of RPC 100003/2 on 10.0.30.2
[    5.378639] PHY: f0003000:00 - Link is Up - 100/Full
[    5.427768] Looking up port of RPC 100005/1 on 10.0.30.2
[    5.486821] VFS: Mounted root (nfs filesystem).
[    5.492025] *****************************************************************************
[    5.500722] *                                                                           *
[    5.509440] *  REMINDER, the following debugging options are turned on in your .config: *
[    5.518136] *                                                                           *
[    5.527066] *        CONFIG_CRITICAL_PREEMPT_TIMING                                     *
[    5.535708] *        CONFIG_FUNCTION_TRACE                                              *
[    5.544334] *                                                                           *
[    5.552957] *  they may increase runtime overhead and latencies.                        *
[    5.561574] *                                                                           *
[    5.570202] *****************************************************************************
[    5.578909] Freeing unused kernel memory: 176k init
INIT: version 2.85 booting
                Welcome to DENX Embedded Linux Environment
                Press 'I' to enter interactive startup.
Building the cache [  OK  ]
 storage network audio done[  OK  ]
Cannot access the Hardware Clock via any known method.
Use the --debug option to see the details of our search for an access method.
Setting clock : Thu Jan  1 00:00:11 UTC 1970 [  OK  ]
Setting hostname lite5200:  [  OK  ]
Mounting local filesystems:  [  OK  ]
Enabling swap space:  [  OK  ]
INIT: Entering runlevel: 3
Entering non-interactive startup
Bringing up loopback interface:  [  OK  ]
Starting system logger: [  OK  ]
Starting kernel logger: [  OK  ]
Starting portmap: portmap: fork: No such device[  OK  ]
Mounting NFS filesystems:  [  OK  ]
Mounting other filesystems:  [  OK  ]
Starting xinetd: [  OK  ]

DENX ELDK version 4.1 build 2007-01-19
Linux 2.6.24-rc8-rt1 on a ppc

lite5200 login: 


--------------030205010604090302090508--
