Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbXCTQhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbXCTQhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXCTQhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:37:00 -0400
Received: from smtp.ono.com ([62.42.230.12]:30909 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbXCTQg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:36:59 -0400
Date: Tue, 20 Mar 2007 17:36:57 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070320173657.09a13940@werewolf-wl>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1cvs22 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 

(oops, I forgot LKML)

I have no udev events for my dvd-rw...
When I insert a disc in the dvd reader:

werewolf:~# udevmonitor
udevmonitor prints the received event from the kernel [UEVENT]
and the event which udev sends out after rule processing [UDEV]

UEVENT[1174385162.607021] mount    /block/sr1 (block)
UDEV  [1174385162.610056] mount    /block/sr1 (block)

If I insert it in the dvd-rw drive, nothing happens.

extracts from dmesg:
(I have just noticed the message for the 40 wire cable, I will check)
(btw, why the h**l ata busses start nubering in 1 and scsi ones in 0 :((((,
it ata also begun in 0 life will be much easier...)

ata_piix 0000:00:1f.1: version 2.10ac1
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
scsi0 : ata_piix
ata1.00: ATAPI, max UDMA/33
ata1.01: ATAPI, max MWDMA0, CDB intr
ata1.00: configured for UDMA/33
ata1.01: configured for PIO3
scsi1 : ata_piix
ata2.00: ATA-6: ST3120022A, 3.06, max UDMA/100
ata2.00: 234441648 sectors, multi 16: LBA48 
ata2.01: ATAPI, max UDMA/33
ata2.00: limited to UDMA/33 due to 40-wire cable
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H10N  JL10 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
scsi 0:0:1:0: Direct-Access     IOMEGA   ZIP 250          51.G PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] Attached SCSI removable disk
scsi 1:0:0:0: Direct-Access     ATA      ST3120022A       3.06 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 1:0:1:0: CD-ROM            TOSHIBA  DVD-ROM SD-M1712 1004 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ata3: SATA max UDMA/133 cmd 0x0001c000 ctl 0x0001c402 bmdma 0x0001d000 irq 18
ata4: SATA max UDMA/133 cmd 0x0001c800 ctl 0x0001cc02 bmdma 0x0001d008 irq 18
scsi2 : ata_piix
ata3.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata3.00: 390721968 sectors, multi 16: LBA48 
ata3.00: configured for UDMA/133
scsi3 : ata_piix
ATA: abnormal status 0x7F on port 0x0001c807
scsi 2:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3
sd 2:0:0:0: [sdc] Attached SCSI disk

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
