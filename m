Return-Path: <linux-kernel-owner+w=401wt.eu-S936555AbXJSTt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936555AbXJSTt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934340AbXJSTtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:49:12 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:56075 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934018AbXJSTtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:49:10 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: linux-kernel@vger.kernel.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Fri, 19 Oct 2007 20:49:07 +0100
User-Agent: KMail/1.9.7
References: <200710181832.42906.nick@ukfsn.org>
In-Reply-To: <200710181832.42906.nick@ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192049.07877.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 18:32:42 Nick Warne wrote:
> Hi all,
>
> Please CC, not subscribed.
>
> kernel 2.6.23
>
> My DVD/CDrom stopped reading DVD's, so I purchased a new one today.
>
> Old:
> Oct 10 21:01:01 linuxamd kernel:     ide0: BM-DMA at 0xd000-0xd007, BIOS
> settings: hda:DMA, hdb:DMA
> Oct 10 21:01:01 linuxamd kernel:     ide1: BM-DMA at 0xd008-0xd00f, BIOS
> settings: hdc:DMA, hdd:DMA
>
> Oct 10 21:01:01 linuxamd kernel: hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW
> drive, 2048kB Cache, UDMA(66)
> Oct 10 21:01:01 linuxamd kernel: Uniform CD-ROM driver Revision: 3.20
>
> New:
> Oct 18 17:32:20 linuxamd kernel:     ide0: BM-DMA at 0xd000-0xd007, BIOS
> settings: hda:DMA, hdb:DMA
> Oct 18 17:32:20 linuxamd kernel:     ide1: BM-DMA at 0xd008-0xd00f, BIOS
> settings: hdc:DMA, hdd:DMA
>
> Oct 18 17:32:20 linuxamd kernel: hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW
> drive, 2048kB Cache, UDMA(33)
> Oct 18 17:32:20 linuxamd kernel: Uniform CD-ROM driver Revision: 3.20
>
> For some reason the new drive produces:
>
> hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
> hdd: drive side 80-wire cable detection failed, limiting max speed to
> UDMA33
>
> I boot with hdd=ide-cd
>
> How to debug this to find out what is going on?
>
> Thanks,
>
> Nick

No help anyone?  Did I buy a taboo drive?  

nick@linuxamd:nick$ /usr/sbin/hdparm -i /dev/hdd

/dev/hdd:

 Model=TSSTcorp CDDVDW SH-S202J, FwRev=SB00, SerialNo=
 Config={ Fixed Removeable DTR<=5Mbs DTR>10Mbs nonMagnetic }
 RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=0kB, MaxMultSect=0
 (maybe): CurCHS=0/0/0, CurSects=0, LBA=yes, LBAsects=0
 IORDY=yes, tPIO={min:383,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 *udma2 udma3 udma4
 AdvancedPM=no
 Drive conforms to: unknown:

 * signifies the current active mode


Any help to get this fixed (by me) would be welcome.  I cannot find any 
information on why this happens (or rather why the 'drive side') refuses to 
see 80-wire ide cable.

Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
