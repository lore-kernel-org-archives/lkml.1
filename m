Return-Path: <linux-kernel-owner+w=401wt.eu-S966088AbXJSVDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966088AbXJSVDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936692AbXJSVDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:03:18 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:36801 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935933AbXJSVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:03:15 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Fri, 19 Oct 2007 22:03:09 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710192049.07877.nick@ukfsn.org> <200710192228.43655.bzolnier@gmail.com>
In-Reply-To: <200710192228.43655.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192203.09835.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

Thanks for assistance.

On Friday 19 October 2007 21:28:43 Bartlomiej Zolnierkiewicz wrote:

> > No help anyone?  Did I buy a taboo drive?
> >
> > nick@linuxamd:nick$ /usr/sbin/hdparm -i /dev/hdd
> >
> > /dev/hdd:
> >
> >  Model=TSSTcorp CDDVDW SH-S202J, FwRev=SB00, SerialNo=
> >  Config={ Fixed Removeable DTR<=5Mbs DTR>10Mbs nonMagnetic }
> >  RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
> >  BuffType=unknown, BuffSize=0kB, MaxMultSect=0
> >  (maybe): CurCHS=0/0/0, CurSects=0, LBA=yes, LBAsects=0
> >  IORDY=yes, tPIO={min:383,w/IORDY:120}, tDMA={min:120,rec:120}
> >  PIO modes:  pio0 pio1 pio2 pio3 pio4
> >  DMA modes:  mdma0 mdma1 mdma2
> >  UDMA modes: udma0 udma1 *udma2 udma3 udma4
> >  AdvancedPM=no
> >  Drive conforms to: unknown:
> >
> >  * signifies the current active mode
> >
> >
> > Any help to get this fixed (by me) would be welcome.  I cannot find any
> > information on why this happens (or rather why the 'drive side') refuses
> > to see 80-wire ide cable.
>
> Please try:
>
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm
>1/broken-out/ide-ide-change-master-slave-identify-order.patch

No change:

ide_setup: hdd=ide-cd
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
hdd: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdd: selected mode 0x42
hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)



Nick
-- 
Free Software Foundation Associate Member 5508
