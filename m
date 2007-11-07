Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbXKGVhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbXKGVhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXKGVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:37:10 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:35747 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXKGVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:37:07 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Mark Lord <liml@rtr.ca>
Cc: James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Wed, 7 Nov 2007 23:36:52 +0200
Message-Id: <20071107212951.M74483@visp.net.lb>
In-Reply-To: <47320E37.8010106@rtr.ca>
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb> <4731D85E.70201@daa.com.au> <20071107160426.M31617@visp.net.lb> <47320E37.8010106@rtr.ca>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is another flash (1GB probably original Sandisk), 16MB one is called 
SHARP, and it is 2-4 years old. Maybe it is some noname with incorrect 
identification data. But it works well in USB card reader.

[   12.434864] ide: Assuming 33MHz system bus speed for PIO modes; override 
with idebus=xx
[   12.459739] SC1200: IDE controller (0x100b:0x0502 rev 0x01) at  PCI slot 
0000:00:12.2
[   12.483360] SC1200: not 100% native mode: will probe irqs later
[   12.501235]     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, 
hdb:pio
[   12.523191]     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, 
hdd:pio
[   12.545128] Probing IDE interface ide0...
[   12.558292] Clocksource tsc unstable (delta = -497091188 ns)
[   12.575348] Time: pit clocksource has been installed.
[   12.593376] hda: SanDisk SDCFH-1024, CFA DISK drive
[   12.608342] hda: applying conservative PIO "downgrade"
[   12.623867] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO1
[   12.624015] hda: selected mode 0x22
[   12.624308] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   12.638802] Probing IDE interface ide1...
[   12.653412] hda: max request size: 128KiB
[   12.665560] hda: 2001888 sectors (1024 MB) w/1KiB Cache, CHS=1986/16/63, 
DMA
[   12.687374]  hda:<4>hda: dma_timer_expiry: dma status == 0x21
[   12.906900] hda: DMA timeout error
[   12.917152]  ide_dma_end dma_stat=21 err=1 newerr=0
[   12.931812] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   12.956039] ide: failed opcode was: unknown
[   12.968807] hda: DMA disabled
[   12.978108] ide0: reset: success
[   12.989416]  hda1
[   12.998883] scx200_wdt: NatSemi SCx200 Watchdog Driver
[   12.998957] scx200_wdt: timer margin 60 seconds
[   13.012656] scx200_wdt: disabling watchdog timer
[   13.013427] cpuidle: using governor ladder
[   13.025906] cpuidle: using governor menu
[   13.037808] enabling scx200 high-res timer (1 MHz +0 ppm)
[   13.054084] Netfilter messages via NETLINK v0.30.
[   13.068256] Time: scx200_hrt clocksource has been installed.
[   13.085331] Switched to high resolution mode on CPU 0
[   13.100573] TCP cubic registered
[   13.110312] NET: Registered protocol family 1
[   13.123516] NET: Registered protocol family 17
[   13.136915] Using IPI Shortcut mode
[   13.154057] Freeing unused kernel memory: 680k freed
[   14.340096] eth0: DSPCFG accepted after 0 usec.
[   14.353718] eth0: link up.
[   14.361893] eth0: Setting full-duplex based on negotiated link capability.

here i am trying to mount partition (1Gb) /dev/hda1 to /mnt

[   14.456362] hda: dma_timer_expiry: dma status == 0x21
[   14.491812] hda: DMA timeout error
[   14.502061]  ide_dma_end dma_stat=21 err=1 newerr=0
[   14.516718] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   14.540944] ide: failed opcode was: unknown
[   14.553712] hda: DMA disabled
[   14.562712] ide0: reset: success
[   14.789644] hda: dma_timer_expiry: dma status == 0x21
[   14.862229] hda: DMA timeout error
[   14.872491]  ide_dma_end dma_stat=21 err=1 newerr=0
[   14.887148] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   14.911375] ide: failed opcode was: unknown
[   14.924143] hda: DMA disabled
[   14.933142] ide0: reset: success
[   14.988000] hda: dma_timer_expiry: dma status == 0x21
[   15.023352] hda: DMA timeout error
[   15.033608]  ide_dma_end dma_stat=21 err=1 newerr=0
[   15.048267] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   15.072494] ide: failed opcode was: unknown
[   15.085261] hda: DMA disabled
[   15.094269] ide0: reset: success

and it is failed.

WRAP ~ #./hdparm -I /dev/hda

/dev/hda:

CompactFlash ATA device, with removable media
        Model Number:       SanDisk SDCFH-1024
        Serial Number:      111718F1705D0016
        Firmware Revision:  HDX 3.07
Standards:
        Supported: 4
        Likely used: 4
Configuration:
        Logical         max     current
        cylinders       1986    1986
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:    2001888
        LBA    user addressable sectors:    2001888
        device size with M = 1024*1024:         977 MBytes
        device size with M = 1000*1000:        1024 MBytes (1 GB)
Capabilities:
        LBA, IORDY(may be)(cannot be disabled)
        Standby timer values: spec'd by Vendor
        R/W multiple sector transfer: Max = 4   Current = 0
        DMA: mdma0 mdma1 mdma2 (?)
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    CFA feature set

WRAP ~ #./hdparm --Istdout /dev/hda

/dev/hda:
848a 07c2 0000 0010 0000 0240 003f 001e
8be0 0000 2020 2020 3131 3137 3138 4631
3730 3544 3030 3136 0002 0002 0004 4844
5820 332e 3037 5361 6e44 6973 6b20 5344
4346 482d 3130 3234 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 0004
0000 0300 0000 0200 0000 0003 07c2 0010
003f 8be0 001e 0100 8be0 001e 0000 0007
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0010 0000 0000 4004 4000 0020 0004 4000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000



On Wed, 07 Nov 2007 14:12:55 -0500, Mark Lord wrote
> > WRAP ~ #./hdparm -I /dev/hda
> > 
> > /dev/hda:
> > 
> > ATAPI Write-once device, with non-removable media
> >         Model Number:       SanDisk SDP3B-16
> >         Serial Number:      24313671615
> >         Firmware Revision:  vdd 1.00
> > Standards:
> >         Likely used: 3
> > Configuration:
> >         DRQ response: 50us.
> >         Packet size: Unknown
> > Capabilities:
> >         LBA, IORDY(may be)(cannot be disabled)
> >         Buffer size: 1.0kB      bytes avail on r/w long: 4
> >         DMA: not supported
> >         PIO: pio0 pio1
> 
> "ATAPI Write-once device"  ???
> 
> That cannot be correct (??).  Is this with hdparm-7.7 (latest 
> sourceforge) ?? Can you show us the "hdparm --Istdout" output as 
> well, please.
> 
> thanks.


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

