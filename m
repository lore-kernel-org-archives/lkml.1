Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXKHAYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXKHAYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXKHAYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:24:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:12834 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbXKHAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ZgWshN0SElcibhUoGdchF22u7A2nJMlUK9BVFqtJmKVuMjtWHfM4LdzBotEoskYgUF55ZdeqMQBCKUZaSHEpBP56EarE81HQKRIwT9VOLU+ywfc7hYmNQ+MLVVpttGeq7qN4PYIIobvzws6B7i7DYZLNPFamRFXicK+xjmPnkdk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Thu, 8 Nov 2007 01:30:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
References: <20071101213013.M54162@visp.net.lb> <20071107232045.GA26706@havoc.gtf.org> <20071107235548.M95675@visp.net.lb>
In-Reply-To: <20071107235548.M95675@visp.net.lb>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711080130.54143.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007, Denys Fedoryshchenko wrote:
> 2.6.24-rc2 not working very well
> 
> 
> dmesg
> [   12.386395] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> [   12.405579] ide: Assuming 33MHz system bus speed for PIO modes; override 
> with idebus=xx
> [   12.430441] SC1200: IDE controller (0x100b:0x0502 rev 0x01) at  PCI slot 
> 0000:00:12.2
> [   12.454070] SC1200: not 100% native mode: will probe irqs later
> [   12.471947]     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, 
> hdb:pio
> [   12.493873]     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, 
> hdd:pio
> [   12.515810] Probing IDE interface ide0...
> [   12.528810] Clocksource tsc unstable (delta = -497423729 ns)
> [   12.545888] Time: pit clocksource has been installed.
> [   12.563379] hda: SanDisk SDCFH-1024, CFA DISK drive
> [   12.578340] hda: applying conservative PIO "downgrade"
> [   12.593869] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO1
> [   12.594006] hda: MW DMA 2 mode selected
> [   12.594297] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [   12.608778] Probing IDE interface ide1...
> [   12.623192] hda: max request size: 128KiB
> [   12.635322] hda: 2001888 sectors (1024 MB) w/1KiB Cache, CHS=1986/16/63, 
> DMA
> [   12.657134]  hda:<4>hda: dma_timer_expiry: dma status == 0x21
> [   12.865846] hda: DMA timeout error
> [   12.876092]  ide_dma_end dma_stat=21 err=1 newerr=0
> [   12.890753] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
> DataRequest }
> [   12.914977] ide: failed opcode was: unknown
> [   12.927743] hda: DMA disabled
> [   12.937035] ide0: reset: success
> [   12.948324]  hda1
> 
> Mounting taking long time on 1GB card cause of DMA issues. In dmesg i am not 
> sure about timestamp showing few seconds, in real life it took about 2 
> minutes.

Please try booting with "hda=nodma".

It could be a hardware problem (CF adapter without DMA lines).

Thanks,
Bart
