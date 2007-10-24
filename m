Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbXJXOes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbXJXOes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759894AbXJXOdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:33:13 -0400
Received: from smtp01.cdmon.com ([212.36.75.232]:57924 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759887AbXJXOdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:33:08 -0400
Date: Wed, 24 Oct 2007 16:33:40 +0200
From: DervishD <lkml@dervishd.net>
To: Thierry Vignaud <tvignaud@mandriva.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata PATA status for VIA 8237
Message-ID: <20071024143340.GA8895@DervishD>
Mail-Followup-To: Thierry Vignaud <tvignaud@mandriva.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20071024095602.GA2607@DervishD> <m2k5pche63.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m2k5pche63.fsf@vador.mandriva.com>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Thierry :)

 * Thierry Vignaud <tvignaud@mandriva.com> dixit:
> DervishD <lkml@dervishd.net> writes:
> > I'm thinking about switching fully to libata in the near future
> > (currently I'm using CONFIG_IDE for all my PATA drives, both hard disks
> > and DVD recorder), and I was wondering if PATA support for VIA8237 was
> > full or not. For what I've googled, it seems that it is usable both for
> > PATA and for SATA, but I want to be sure.
> > 
> > If I'm asking here is because I have SATA support for my VIA chipset
> > enabled in the kernel (CONFIG_SATA_VIA), but I'm getting these messages:
> > 
> >     sata_via 0000:00:0c.0: version 2.0
> >     sata_via 0000:00:0c.0: routed to hard irq line 10
> >     ata1: SATA max UDMA/133 cmd 0xFE00 ctl 0xFE0A bmdma 0xFA00 irq 10
> >     ata2: SATA max UDMA/133 cmd 0xFD00 ctl 0xFD0A bmdma 0xFA08 irq 10
> >     scsi0 : sata_via
> >     ata1: SATA link down (SStatus 0 SControl 310)
> > >>  ATA: abnormal status 0x7F on port 0xFE07
> >     scsi1 : sata_via
> >     ata2: SATA link down (SStatus 0 SControl 310)
> > >>  ATA: abnormal status 0x7F on port 0xFD07
> >     sata_via 0000:00:0f.0: routed to hard irq line 11
> >     ata3: SATA max UDMA/133 cmd 0xF900 ctl 0xF802 bmdma 0xF500 irq 11
> >     ata4: SATA max UDMA/133 cmd 0xF700 ctl 0xF602 bmdma 0xF508 irq 11
> >     scsi2 : sata_via
> >     ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> > >>  ATA: abnormal status 0x7F on port 0xF907
> >     scsi3 : sata_via
> >     ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> > >>  ATA: abnormal status 0x7F on port 0xF707
> 
> I saw those too from times to times on boot with a VIA VT6421 with no
> consequences.
> So I would say they're non important (but who know for real until you
> test with real disk attached?)

I think I can manage to get a SATA disk to make tests, but the problem
is that I won't be able to make destructive (destroying the data, I
mean, not the hardware XD) tests on it :((

Merci :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
