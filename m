Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbYEHJqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbYEHJqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYEHJpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:45:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:58376 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753509AbYEHJpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:45:52 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1/fXNQDhYjfuM/lSGOHFzMn4hrHNthT4CWwtIeA9r
	Voyi7SzN3jy0sD
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [git patches] libata updates - (improve post-reset =?iso-8859-1?q?device=09ready?= test) regression
Date: Thu, 8 May 2008 11:45:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
References: <20080506154847.GA15299@havoc.gtf.org> <20080507145616.GA2210@gentoox2.trippelsdorf.de> <s5hod7ixeaj.wl%tiwai@suse.de>
In-Reply-To: <s5hod7ixeaj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081145.46553.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 07 Mai 2008 18:35:48 schrieben Sie:
> At Wed, 7 May 2008 16:56:16 +0200,
> Markus Trippelsdorf wrote:
> > 
> > > 
> > > Tejun Heo (12):
> > >       libata: improve post-reset device ready test
> > 
> > This commit (78ab88f04f44bed566d51dce0c7cbfeff6449a06) causes a long
> > boot delay with my onboard Promise controller. It seems like libata
> > probes for a nonexisting PATA drive...
> > 

Same here :

<6>ata1: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404100 irq 4347
<6>ata2: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404180 irq 4347
<6>ata3: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404200 irq 4347
<6>ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<4>ata1.00: _GTF unexpected object type 0x1
<6>ata1.00: ATA-8: WDC WD2500BEVS-22UST0, 01.01A01, max UDMA/133
<6>ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
<4>ata1.00: _GTF unexpected object type 0x1
<6>ata1.00: configured for UDMA/133
<6>ata2: SATA link down (SStatus 0 SControl 300)
<6>ata3: SATA link down (SStatus 0 SControl 300)
<5>scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500BEVS-2 01.0 PQ: 0 ANSI: 5
<7>PM: Adding info for No Bus:target0:0:0
<7>PM: Adding info for scsi:0:0:0:0
<7>PM: Adding info for No Bus:0:0:0:0
<7>ata_piix 0000:00:1f.1: version 2.12
<6>ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 19 (level, low) -> IRQ 19
<7>PCI: Setting latency timer of device 0000:00:1f.1 to 64
<6>scsi3 : ata_piix
<7>PM: Adding info for No Bus:host3
<7>PM: Adding info for No Bus:host3
<6>scsi4 : ata_piix
<7>PM: Adding info for No Bus:host4
<7>PM: Adding info for No Bus:host4
<6>ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
<6>ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
<6>ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WW01, max UDMA/33
<6>ata4.00: configured for UDMA/33
<4>ata5: link is slow to respond, please be patient (ready=0)
<4>ata5: device not ready (errno=-16), forcing hardreset
<4>ata5: link is slow to respond, please be patient (ready=0)
<3>ata5: SRST failed (errno=-16)
<4>ata5: link is slow to respond, please be patient (ready=0)
<3>ata5: SRST failed (errno=-16)
<4>ata5: link is slow to respond, please be patient (ready=0)
<3>ata5: SRST failed (errno=-16)
<3>ata5: SRST failed (errno=-16)
<3>ata5: reset failed, giving up
<4>isa bounce pool size: 16 pages
<5>scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WW01 PQ: 0 ANSI: 5
<7>PM: Adding info for No Bus:target3:0:0
<7>PM: Adding info for scsi:3:0:0:0
<7>PM: Adding info for No Bus:3:0:0:0
<6>SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
<6>SGI XFS Quota Management subsystem
<6>BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
<6>EDD information not available.
<4>sys_init_module: 'edd'->init suspiciously returned 1, it should follow 0/-E convention
<4>sys_init_module: loading module anyway...
<4>Pid: 554, comm: modprobe Not tainted 2.6.26-rc1-linus.git-00166-gc0a1811 #1
<4>
<4>Call Trace:
<4> [sys_init_module+304/428] sys_init_module+0x130/0x1ac
<4> [system_call_after_swapgs+138/143] system_call_after_swapgs+0x8a/0x8f
<4>
<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
