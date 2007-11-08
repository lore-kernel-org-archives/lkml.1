Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbXKHQo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbXKHQo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbXKHQot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:44:49 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:60764 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760053AbXKHQor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:44:47 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Thu, 8 Nov 2007 18:44:31 +0200
Message-Id: <20071108164320.M82021@visp.net.lb>
In-Reply-To: <20071108104813.78ca4d65@the-village.bc.nu>
References: <20071101213013.M54162@visp.net.lb> <20071107232045.GA26706@havoc.gtf.org> <20071107235548.M95675@visp.net.lb> <200711080130.54143.bzolnier@gmail.com> <20071108071204.M66693@visp.net.lb> <20071108104813.78ca4d65@the-village.bc.nu>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doesn't help

WRAP ~ #cat /proc/cmdline
console=ttyS0,38400n8 libata.dma_mask=3

and in dmesg

[    8.601592] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-10 HDX  
PQ: 0 ANSI: 5
[    8.627943] sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
[    8.648634] sd 0:0:0:0: [sda] Write Protect is off
[    8.663129] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.663605] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    8.691824] sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
[    8.712512] sd 0:0:0:0: [sda] Write Protect is off
[    8.726982] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.727462] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    8.754700]  sda:<4>Clocksource tsc unstable (delta = 140275209 ns)
[    8.774136] Time: pit clocksource has been installed.
[    8.979224] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[    9.000527] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[    9.000581]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[    9.046810] ata1.00: status: { DRDY }
[    9.057903] ata1: soft resetting link
[    9.071700] ata1.00: configured for MWDMA2
[    9.084159] ata1: EH complete
[    9.283365] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[    9.304673] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[    9.304728]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[    9.350958] ata1.00: status: { DRDY }
[    9.362046] ata1: soft resetting link
[    9.375830] ata1.00: configured for MWDMA2
[    9.388276] ata1: EH complete
[    9.587493] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[    9.608806] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[    9.608861]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[    9.655090] ata1.00: status: { DRDY }
[    9.666182] ata1: soft resetting link
[    9.679975] ata1.00: configured for MWDMA2
[    9.692423] ata1: EH complete
[    9.891737] ata1.00: limiting speed to MWDMA1:PIO4
[    9.906214] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[    9.927483] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[    9.927526]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[    9.973754] ata1.00: status: { DRDY }
[    9.984844] ata1: soft resetting link
[    9.998623] ata1.00: configured for MWDMA1
[   10.011068] ata1: EH complete
[   10.210291] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   10.231591] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   10.231634]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   10.277850] ata1.00: status: { DRDY }
[   10.288943] ata1: soft resetting link
[   10.302724] ata1.00: configured for MWDMA1
[   10.315174] ata1: EH complete
[   10.514480] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   10.535774] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   10.535818]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   10.582034] ata1.00: status: { DRDY }
[   10.593124] ata1: soft resetting link
[   10.606903] ata1.00: configured for MWDMA1
[   10.619335] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[   10.638312] sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
[   10.657784] Descriptor sense data with sense descriptors (in hex):
[   10.676411]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   10.696558]         00 00 00 00
[   10.706601] sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
[   10.720127] end_request: I/O error, dev sda, sector 0
[   10.735360] Buffer I/O error on device sda, logical block 0
[   10.752212] ata1: EH complete
[   10.951561] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   10.972864] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   10.972907]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   11.019124] ata1.00: status: { DRDY }
[   11.030214] ata1: soft resetting link
[   11.044001] ata1.00: configured for MWDMA1
[   11.056439] ata1: EH complete
[   11.255766] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   11.277057] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   11.277100]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   11.323315] ata1.00: status: { DRDY }
[   11.334406] ata1: soft resetting link
[   11.348187] ata1.00: configured for MWDMA1
[   11.360617] ata1: EH complete
[   11.559852] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   11.581152] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   11.581195]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   11.627411] ata1.00: status: { DRDY }
[   11.638503] ata1: soft resetting link
[   11.652281] ata1.00: configured for MWDMA1
[   11.664726] ata1: EH complete
[   11.864037] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   11.885338] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   11.885382]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   11.931623] ata1.00: status: { DRDY }
[   11.942712] ata1: soft resetting link
[   11.956488] ata1.00: configured for MWDMA1
[   11.968934] ata1: EH complete
[   12.168151] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   12.189442] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   12.189485]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   12.235701] ata1.00: status: { DRDY }
[   12.246790] ata1: soft resetting link
[   12.260575] ata1.00: configured for MWDMA1
[   12.273015] ata1: EH complete
[   12.472358] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[   12.493668] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[   12.493712]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[   12.539929] ata1.00: status: { DRDY }
[   12.551019] ata1: soft resetting link
[   12.564802] ata1.00: configured for MWDMA1
[   12.577247] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[   12.596225] sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
[   12.615694] Descriptor sense data with sense descriptors (in hex):
[   12.634324]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   12.654472]         00 00 00 00
[   12.664516] sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
[   12.678039] end_request: I/O error, dev sda, sector 0
[   12.693273] Buffer I/O error on device sda, logical block 0
[   12.710123] ata1: EH complete
[   12.719187]  unable to read partition table
[   12.732602] sd 0:0:0:0: [sda] Attached SCSI removable disk



On Thu, 8 Nov 2007 10:48:13 +0000, Alan Cox wrote
> On Thu, 8 Nov 2007 09:16:35 +0200
> "Denys Fedoryshchenko" <denys@visp.net.lb> wrote:
> 
> > Does it work as kernel parameter?
> > 
> > I tried libata_dma_mask=0x4 and to set 0xf or 0xff - doesn't help. How to 
> > disable DMA in libata, if it is compiled in kernel?
> 
> libata.dma_mask=3
> 
> will leave you with CD and disk DMA but not CF DMA
> 
> (Note libata[DOT] not underscore)


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

