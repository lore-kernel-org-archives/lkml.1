Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbXGYBQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbXGYBQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbXGYBQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:16:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:58233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361AbXGYBQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j6TvK3jBCakKP266hQ1ANcojMPZg39Vg8zcCo2FZDlFEYdWPGIuU7aFZcnINWem4qhDW4yJKKofnK9kB2r6O67BWsJq1pf/1SqawYYlyfxottEu3VT5qTPtMo1xX37J9hXiEiXDlchJkR2oVzXxssrSg9fGi+lpD3ByzNGTLE1c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Date: Wed, 25 Jul 2007 03:14:18 +0200
User-Agent: KMail/1.9.6
Cc: "Eric Sesterhenn / Snakebyte" <snakebyte@gmx.de>,
       linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <20070723221630.GA28951@alice> <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com> <200707250240.49867.bzolnier@gmail.com>
In-Reply-To: <200707250240.49867.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707250314.19232.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday 25 July 2007, Michal Piotrowski wrote:
> > Hi,
> > 
> > On 24/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
> > > hi,
> > >
> > > seems like the clock got screwed or something similar. During bootup the
> > > computer hangs (no response on keyboard leds when pressing caps lock),
> > > the only way to make sure it resumes booting is by repeatedly pressing
> > > the power switch,
> > 
> > :)
> > 
> > > see second 13 to 510, after pressing it about ten
> > > times, it continues booting.
> > 
> > Probing IDE interface...
> > 
> > [   13.867939] VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on
> > pci0000:00:04.1
> > [   13.868062]     ide0: BM-DMA at 0xd800-0xd807, BIOS settings:
> > hda:DMA, hdb:pio
> > [   13.868268]     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings:
> > hdc:DMA, hdd:DMA
> > [   13.868574] Probing IDE interface ide0...
> > [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
> > [  496.200082] hda: ST340823A, ATA DISK drive
> > [  510.264511] hda: selected mode 0x44
> > [  510.264826] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > 
> > Could you please try to revert these commits
> 
> It doesn't seem like a IDE bug et all, rather seems to be some issue
> related to the recent "lack of the proper clocksource fallback" bug...

or ACPI

> > > [   13.506890] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
> > > [   13.507101] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]

Bart
