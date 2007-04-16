Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbXDPEqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbXDPEqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 00:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXDPEqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 00:46:32 -0400
Received: from hoemail2.lucent.com ([192.11.226.163]:53530 "EHLO
	hoemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXDPEqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 00:46:31 -0400
Message-ID: <4622FFA2.9070805@alcatel-lucent.com>
Date: Mon, 16 Apr 2007 12:46:26 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: gshan <gshan@alcatel-lucent.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Unable to mount root fs on unknown-block(1,0)
References: <4622FA61.4000901@alcatel-lucent.com>
In-Reply-To: <4622FA61.4000901@alcatel-lucent.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2007 04:45:55.0980 (UTC) FILETIME=[1ED28CC0:01C77FE2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the version of linux should be 2.6.15 for MPC8xx, which is 
included in ELDK.

gshan wrote:
> Hi Folks,
>
> I got problem to boot linux 2.6.25 using u-boot-1.1.4, any ideas?
>
> -------------------------
>
> U-Boot 1.1.4 (Apr 14 2007 - 00:57:01)
>
> CPU:   XPC850xxZTB at 50 MHz: 2 kB I-Cache 1 kB D-Cache
> Board: ### No HW ID - assuming TQM8xxL
> DRAM:   8 MB
> FLASH:  4 MB
> In:    serial
> Out:   serial
> Err:   serial
> Net:   SCC ETHERNET
> Hit any key to stop autoboot:  0
> Using SCC ETHERNET device
> TFTP from server 90.0.0.1; our IP address is 90.0.0.2
> Filename 'uImage'.
> Load address: 0x100000
> Loading: 
> #################################################################
>         #################################################################
>         ################################
> done
> Bytes transferred = 825541 (c98c5 hex)
>
> => printenv
> bootdelay=5
> baudrate=9600
> loads_echo=1
> ethact=SCC ETHERNET
> netmask=0xff000000
> vlan=0xffff
> nvlan=0xffff
> clocks_in_mhz=1
> bootcmd=tftp 0x100000 uImage
> autostart=no
> filesize=c98c5
> fileaddr=100000
> ipaddr=90.0.0.2
> serverip=90.0.0.1
> bootargs=root=/dev/ram rw
> stdin=serial
> stdout=serial
> stderr=serial
>
> Environment size: 293/16380 bytes
> => bdinfo
> memstart    = 0x00000000
> memsize     = 0x00800000
> flashstart  = 0x10000000
> flashsize   = 0x00400000
> flashoffset = 0x00021000
> sramstart   = 0x00000000
> sramsize    = 0x00800000
> immr_base   = 0xFFF00000
> bootflags   = 0x00000001
> intfreq     =     50 MHz
> busfreq     =     50 MHz
> ethaddr     = 00:00:00:00:00:00
> IP addr     = 90.0.0.2
> baudrate    =   9600 bps
>
>
> => tftp 0x200000 aaa
> Using SCC ETHERNET device
> TFTP from server 90.0.0.1; our IP address is 90.0.0.2
> Filename 'aaa'.
> Load address: 0x200000
> Loading: #
> done
> Bytes transferred = 776 (308 hex)
> => bootm 0x100000 0x200000
> ## Booting image at 00100000 ...
>   Image Name:   Linux-2.6.15
>   Created:      2007-04-15  16:56:44 UTC
>   Image Type:   PowerPC Linux Kernel Image (gzip compressed)
>   Data Size:    825477 Bytes = 806.1 kB
>   Load Address: 00000000
>   Entry Point:  00000000
>   Verifying Checksum ... OK
>   Uncompressing Kernel Image ... OK
> ## Loading RAMDisk Image at 00200000 ...
>   Image Name:   ramdisk
>   Created:      2007-04-15  17:31:31 UTC
>   Image Type:   PowerPC Linux RAMDisk Image (gzip compressed)
>   Data Size:    712 Bytes =  0.7 kB
>   Load Address: 00000000
>   Entry Point:  00000000
>   Verifying Checksum ... OK
>   Loading Ramdisk to 007b8000, end 007b82c8 ... OK
> Linux version 2.6.15 (root@localhost.localdomain) (gcc version 4.0.0 
> (DENX ELDK 4.0 4.0.0)) #182 Mon Apr 16 00:56:43 CST 2007
> Built 1 zonelists
> Kernel command line: root=/dev/ram rw
> PID hash table entries: 64 (order: 6, 1024 bytes)
> 50
> Decrementer Frequency = 187500000/60
> Console: colour dummy device 80x25
> Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
> Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
> Memory: 6236k available (1408k kernel code, 364k data, 84k init, 0k 
> highmem)
> Mount-cache hash table entries: 512
> checking if image is initramfs...it isn't (no cpio magic); looks like 
> an initrd
> Freeing initrd memory: 0k freed
> NET: Registered protocol family 16
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered
> Generic RTC Driver v1.07
> Serial: CPM driver $Revision: 0.01 $
> ttyCPM0 at MMIO 0xfff00a80 (irq = 20) is a CPM UART
> RAMDISK driver initialized: 2 RAM disks of 1024K size 1024 blocksize
> loop: loaded (max 8 devices)
> eth0: CPM ENET Version 0.2 on SCC1, 00:00:00:00:00:00
> NET: Registered protocol family 2
> IP route cache hash table entries: 128 (order: -3, 512 bytes)
> TCP established hash table entries: 512 (order: -1, 2048 bytes)
> TCP bind hash table entries: 512 (order: -1, 2048 bytes)
> TCP: Hash tables configured (established 512 bind 512)
> TCP reno registered
> TCP bic registered
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> RAMDISK: Compressed image found at block 0
> Kernel panic - not syncing: VFS: Unable to mount root fs on 
> unknown-block(1,0)
> <0>Rebooting in 180 seconds..
>
> Thanks,
> Gavin
>
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

