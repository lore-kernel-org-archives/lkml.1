Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbZCRWVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbZCRWVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZCRWVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:21:34 -0400
Received: from sdcmail02.amcc.com ([198.137.200.73]:10824 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbZCRWVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:21:32 -0400
X-IronPort-AV: E=Sophos;i="4.38,386,1233561600"; 
   d="scan'208";a="2931977"
Message-ID: <49C173EA.4030904@amcc.com>
Date: Wed, 18 Mar 2009 15:21:30 -0700
From: Feng Kan <fkan@amcc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Cheng Renquan <crquan@gmail.com>
CC: Mark Miesfeld <mmiesfeld@amcc.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: About [AMCC 460EX/canyonlands board] Synopsys DesignWare Cores
 (DWC) SATA host driver
References: <91b13c310903180551j4b86880cr269b01b58055febc@mail.gmail.com>
In-Reply-To: <91b13c310903180551j4b86880cr269b01b58055febc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2009 22:21:29.0627 (UTC) FILETIME=[E29AA6B0:01C9A817]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi RenQuan:

We are aware of the issue, currently the sata is only supported up to 
2.6.25.7. We are working on a patchable version
to submit to main line.

Thanks
Feng Kan

Cheng Renquan wrote:
> Mark,
>   I found that the current sata_dwc can only work on
> DENX-2.6.25-stable, and have problems in DENX-2.6.26, 27, 28,
> 29(master),
> the boot errors is as the following, I hope you and AMCC staff submit
> it into mainline soon, thanks.
>
> there is also some other boot panic kmsg, I will reproduce it tomorrow.
>
> http://git.denx.de/linux-2.6-denx.git/
>
> Synopsys DesignWare Cores (DWC) SATA host driver
>
> linuxppc-dev@ozlabs.org
>
> About AMCC DesignWare Core SATA controller driver:
>
> => boot
> Using ip address 172.16.90.27
> ## Booting kernel from Legacy Image at ff600000 ...
>    Image Name:   Linux-2.6.27.19
>    Created:      2009-03-13  10:18:17 UTC
>    Image Type:   PowerPC Linux Kernel Image (gzip compressed)
>    Data Size:    1574261 Bytes =  1.5 MB
>    Load Address: 00000000
>    Entry Point:  00000000
>    Verifying Checksum ... OK
>    Uncompressing Kernel Image ... OK
> ## Flattened Device Tree blob at fc1e0000
>    Booting using the fdt blob at 0xfc1e0000
> ## Loading init Ramdisk from Legacy Image at fc200000 ...
>    Image Name:   canyonlands ramdisk rev. 001
>    Created:      2008-05-13  11:18:24 UTC
>    Image Type:   PowerPC Linux RAMDisk Image (gzip compressed)
>    Data Size:    18968362 Bytes = 18.1 MB
>    Load Address: 00000000
>    Entry Point:  00000000
>    Verifying Checksum ... OK
>    Loading Device Tree to 007fa000, end 007fffff ... OK
>    Loading Ramdisk to 1ec3d000, end 1fe53f2a ... OK
> Using Canyonlands machine description
> Linux version 2.6.27.19 (fedora@ubox-h1) (gcc version 4.2.2) #1 Fri
> Mar 13 18:18:05 HKT 2009
> Found initrd at 0xdec3d000:0xdfe53f2a
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00020000
>   Normal   0x00020000 -> 0x00020000
>   HighMem  0x00020000 -> 0x00020000
>
>
> scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EVVS-63E 01.0 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda:<3>ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: prereset failed (errno=-16)
> ata1: reset failed, giving up
> ata1.00: disabled
> ata1: EH complete
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
>  unable to read partition table
> sd 0:0:0:0: [sda] Attached SCSI disk
> 4cc000000.nor_flash: Found 1 x16 devices at 0x0 in 16-bit bank
>  Amd/Fujitsu Extended Query Table at 0x0040
> 4cc000000.nor_flash: CFI does not contain boot bank location. Assuming top.
> number of CFI chips: 1
> cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
> RedBoot partition parsing not available
> Creating 7 MTD partitions on "4cc000000.nor_flash":
> 0x00000000-0x001e0000 : "kernel"
> 0x001e0000-0x00200000 : "dtb"
> 0x00200000-0x01600000 : "ramdisk"
> 0x01600000-0x01a00000 : "jffs2"
> 0x01a00000-0x03f60000 : "user"
> 0x03f60000-0x03fa0000 : "env"
> 0x03fa0000-0x04000000 : "u-boot"
> NDFC NAND Driver initialized. Chip-Rev: 0x00000111
> NAND device: Manufacturer ID: 0x20, Chip ID: 0xf1 (ST Micro NAND
> 128MiB 3,3V 8-bit)
> Scanning device for bad blocks
> Number of partitions 3
> Creating 3 MTD partitions on "NAND 128MiB 3,3V 8-bit":
> 0x00000000-0x00100000 : "u-boot"
> 0x00100000-0x00140000 : "env"
> 0x00140000-0x08000000 : "content"
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> dwc_otg: version 2.60a 22-NOV-2006
> TCP cubic registered
> NET: Registered protocol family 17
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> eth0: link is up, 1000 FDX, pause enabled
> IP-Config: Complete:
>      device=eth0, addr=172.16.90.27, mask=255.255.255.0, gw=255.255.255.255,
>      host=canyonlands, domain=, nis-domain=(none),
>      bootserver=172.16.90.26, rootserver=172.16.90.26, rootpath=
> RAMDISK: Compressed image found at block 0
> VFS: Mounted root (ext2 filesystem).
> Freeing unused kernel memory: 156k init
> Startup utility found. Executing...
> AMCC Startup utility launched.
>
>
> BusyBox v1.2.1 (2008.05.13-11:11+0000) Built-in shell (ash)
> Enter 'help' for a list of built-in commands.
>
> ~ # fdisk -l
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 8
> Buffer I/O error on device sda, logical block 1
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 16
> Buffer I/O error on device sda, logical block 2
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 24
> Buffer I/O error on device sda, logical block 3
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 1953525160
> Buffer I/O error on device sda, logical block 244190645
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 1953525160
> Buffer I/O error on device sda, logical block 244190645
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 8
> Buffer I/O error on device sda, logical block 1
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 16
> Buffer I/O error on device sda, logical block 2
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 24
> sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
> end_request: I/O error, dev sda, sector 0
> ~ #
>
>
>   

