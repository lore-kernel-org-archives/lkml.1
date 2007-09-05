Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXIEQyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXIEQyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXIEQyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:54:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbXIEQyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:54:43 -0400
Date: Wed, 5 Sep 2007 09:53:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Stardom SATA HSM violation
Message-Id: <20070905095327.6277d054.akpm@linux-foundation.org>
In-Reply-To: <46DBCB6C.8080206@gmail.com>
References: <46CFA08E.6090604@arbores.ca>
	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>
	<46DBCB6C.8080206@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 03 Sep 2007 17:53:00 +0900 Tejun Heo <htejun@gmail.com> wrote:
> Michal Piotrowski wrote:
> > Hi,
> > 
> > [Adding linux-ide to CC]
> > 
> > On 25/08/07, Bryan Woods <bryan@arbores.ca> wrote:
> >> Hi KML
> >>
> >> I am installing gentoo 2007.0 (kernel 2.6.19) on a dual AMD Opteron server (total of 4 cores). The hard disk is a Stardom 2611-2S-S1 device: actually two 250GB drives in a RAID0 config managed by the device itself - it should appear to the kernel as one SATA drive. If it matters, the underlying HDs are "Seagate Barracuda 7200 10"s. Here's the device:
> >>
> >>  http://www.synetic.net/Synetic-Products/Stardoms/SR-2611-SA/Stardom-2611.htm
> >>
> >> During the install and at different points in the process I get an "HSM violation" and the system becomes unresponsive. It looks like a similar situation to:
> >>
> >>   http://lkml.org/lkml/2007/6/6/195
> >>
> >> Will more recent kernels work with this hardware (should I keep it and try the install again) or should I switch hardware to something more compatible (like an Adaptec card)?
> >>
> >> Thanks!
> >> Bryan
> >>
> >> --
> >> console output:
> >>
> >> tag 0 cmd 0x39 Emask 0x2 stat 0x58 err 0x0 (HSM violation)
> >> exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>
> >> --
> >> Output from hdparm -I /dev/sda:
> >>
> >> /dev/sda:
> >>
> >> ATA device, with non-removable media
> >>         Model Number:   STARDOM V.36.A0B
> >>         Serial Number:
> >>         Firmware Revision:      V.36.A0B
> >> Standards:
> >>         Used: ATA/ATAPI-6 T13 1410D revision 0
> >>
> >> [snip]
> >>
> >> Commands/features:
> >>         Enabled Supported:
> >>         *       SMART feature set
> >>         *       Power Management feature set
> >>         *       Advanced Power Management feature set
> >>         *       48-bit Address feature set
> >>         *       Mandatory FLUSH_CACHE
> >>         *       SATA-I signaling speed (1.5 Gb/s)
> >>         *       SATA-II signaling speed (3.0 Gb/s)
> >>
> >> --
> >> Parts of dmesg:
> >> libata version 2.00 loaded
> >> sata_nv 0000:00:05.0: version 2.0
> >> ata1: SATA max UDMA/133 cmd 0xD480 ctl 0xD402 bmdma 0xCC00 irq 21
> >> ata2: SATA max UDMA/133 cmd 0xD080 ctl 0xD002 bmdma 0xCC08 irq 21
> >> scsi0 : sata_nv
> >> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >> ata1.00: ATA-6, max UDMA/133,976794112 sectors: LBA48
> >> ata1.00: ata1: dev 0 multi count 1
> >> ata1.00: applying bridge limits
> >> ata1.00: configured for UDMA/100
> 
> Please post full dmesg and full 'hdparm -I' result.  Also, if possible,
> please try 2.6.22.5.  Even if it doesn't fix the problem, it would
> report error conditions better.

Presumably in the week and a half between Bryan's report and your request,
Bryan has gone off and got an adaptec card.  Bryan, it would be helpful if
you could rebuild the original systam and help us get to the bottom of this
bug, thanks.

