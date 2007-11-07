Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbXKGP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbXKGP4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXKGP4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:56:13 -0500
Received: from quoll.daa.com.au ([203.17.251.1]:52459 "EHLO quoll.daa.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbXKGP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:56:12 -0500
X-Greylist: delayed 1980 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 10:56:12 EST
Message-ID: <4731D85E.70201@daa.com.au>
Date: Thu, 08 Nov 2007 00:23:10 +0900
From: James Andrewartha <jamesa@daa.com.au>
Organization: Data Analysis Australia
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb>
In-Reply-To: <20071107132630.M65286@visp.net.lb>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote:
> On Tue, 6 Nov 2007 22:15:21 -0800, Andrew Morton wrote
>>> On Thu, 1 Nov 2007 23:30:13 +0200 "Denys" <denys@visp.net.lb> wrote:
>>> Finally i got full DMESG with 1GB card till end. Seems not readable too.
>>> scsi0 : sc1200
>>> scsi1 : sc1200
>>> ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
>>> ata2: DUMMY
>>> ata1.00: CFA: SanDisk SDCFH-1024, HDX 3.07, max MWDMA2
>>> ata1.00: 2001888 sectors, multi 0: LBA
>>> ata1.00: configured for MWDMA2
>>> scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-10 HDX  PQ: 0 
> ANSI: 5
>>> sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
>>> sd 0:0:0:0: [sda] Write Protect is off
>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support 
>>> DPO or FUA
>>> sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
>>> sd 0:0:0:0: [sda] Write Protect is off
>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support 
>>> DPO or FUA
>>>  sda:<4>Clocksource tsc unstable (delta = -334501841 ns)
>>> Time: pit clocksource has been installed.
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA2
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA2
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA2
>>> ata1: EH complete
>>> ata1.00: limiting speed to MWDMA1:PIO4
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
>>> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
>>> Descriptor sense data with sense descriptors (in hex):
>>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>>         00 00 00 00
>>> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
>>> end_request: I/O error, dev sda, sector 0
>>> Buffer I/O error on device sda, logical block 0
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> ata1: EH complete
>>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
> in
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> ata1.00: status: { DRDY }
>>> ata1: soft resetting link
>>> ata1.00: configured for MWDMA1
>>> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
>>> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
>>> Descriptor sense data with sense descriptors (in hex):
>>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>>         00 00 00 00
>>> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
>>> end_request: I/O error, dev sda, sector 0
>>> Buffer I/O error on device sda, logical block 0
>>> ata1: EH complete
>>>  unable to read partition table
>>> sd 0:0:0:0: [sda] Attached SCSI removable disk
>>> scx200_wdt: timer margin 60 seconds
>>> cpuidle: using governor ladder
>>> enabling scx200 high-res timer (1 MHz +0 ppm)
>>> TCP cubic registered
>>> Time: scx200_hrt clocksource has been installed.
>>> NET: Registered protocol family 1
>>> NET: Registered protocol family 17
>>> Using IPI Shortcut mode
>>> VFS: Cannot open root device "<NULL>" or unknown-block(8,18)
>>> Please append a correct "root=" boot option; here are the available 
>>> partitions:
>>> 0800    1000944 sda driver: sd
>>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-
>>> block(8,18)
>>>
>> (+linux-ide)
(+alan, tejun)
>> So this has never worked on any known kernel?
> 
> It is working now on old ide code (not libata).

Can you post the dmesg and hdparm -I of a working boot using the old ide
code? The thing that stuck out to me (as just a reader of linux-ide) was
that the problem involves MWDMA and CF, which have had problems (although
not the same as this one) in the past:
http://thread.gmane.org/gmane.linux.ide/22058 and
http://thread.gmane.org/gmane.linux.ide/22400

-- 
James Andrewartha
