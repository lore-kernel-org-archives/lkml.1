Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbXICNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbXICNES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXICNEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:04:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXICNEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lH1yBrcrJW1EPqYWK12+FirgzYjq/Qx+3y+Cdu/JXpNXc2l+VbMWCqSUOaTr+lzpW6K4V1ewqrZBAIIYfhcIaWiOf3Pv+A/F2ADQl5MF/ERB3Kshh1TIAnp9RYtOWVotFdWkUVZ+RmdBOM9Gg6K0nrrh4+Qifh1d/LLth30foB4=
Message-ID: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com>
Date: Mon, 3 Sep 2007 15:04:04 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ramdisk
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I want to use ramdisk to boot my filesystem, as I can't use NFS and harddisk.

I have load the ramdisk into the ram memory (start address :0x4000000)

and in the boot options I specified : root =dev/ram0 initrd=0x4000000

but the kernel said it can not find any file system on it.

Here is the information I can supply :
U-Boot 1.2.0 (Aug 31 2007 - 20:54:55)

***  Auto-detects ethernet chip ***



DRAM:   0 kB
## Unknown FLASH on Bank 1 - Size = 0x00000000 = 0 MB
Flash:  0 kB
*** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial

Hit any key to stop autoboot:  0
## Booting image at 00007fc0 ...
   Image Name:   Linux-2.6.19-arm2
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    740372 Bytes = 723 kB
   Load Address: 00008000
   Entry Point:  00008000
OK


## Loading Ramdisk Image at 04000000 ...
   Image Name:   ramdisc
   Image Type:   ARM Linux RAMDisk Image (gzip compressed)
   Data Size:    12582962 Bytes = 12 MB
   Load Address: 04000000
   Entry Point:  04000000

Starting kernel ...


.........................................................................................

RAMDISK driver initialized: 16 RAM disks of 10240K size 1024 blocksize
<6>loop: loaded (max 8 devices)
<6>mice: PS/2 mouse device common for all mice
<6>VFP support v0.3: implementor 41 architecture 1 part 20 variant b rev 3
No filesystem could mount root, tried:  ext2 cramfs vfat
<0>Kernel panic - not syncing: VFS: Unable to mount root fs on
unknown-block(1,0)


Who can give me some hints ? or point me some direction to handle this.

I appreciate this very much.

regards,

Yang
