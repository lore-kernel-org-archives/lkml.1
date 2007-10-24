Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbXJXNHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbXJXNHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbXJXNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:07:32 -0400
Received: from office-abk.mandriva.com ([84.55.162.90]:58539 "EHLO
	office.mandriva.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbXJXNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:07:30 -0400
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 09:07:30 EDT
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata PATA status for VIA 8237
X-URL: <http://www.mandrivalinux.com/
References: <20071024095602.GA2607@DervishD>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Wed, 24 Oct 2007 14:48:04 +0200
In-Reply-To: <20071024095602.GA2607@DervishD> (DervishD's message of "Wed\, 24 Oct 2007 11\:56\:02 +0200")
Message-ID: <m2k5pche63.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD <lkml@dervishd.net> writes:

> I'm thinking about switching fully to libata in the near future
> (currently I'm using CONFIG_IDE for all my PATA drives, both hard disks
> and DVD recorder), and I was wondering if PATA support for VIA8237 was
> full or not. For what I've googled, it seems that it is usable both for
> PATA and for SATA, but I want to be sure.
> 
> If I'm asking here is because I have SATA support for my VIA chipset
> enabled in the kernel (CONFIG_SATA_VIA), but I'm getting these messages:
> 
>     sata_via 0000:00:0c.0: version 2.0
>     sata_via 0000:00:0c.0: routed to hard irq line 10
>     ata1: SATA max UDMA/133 cmd 0xFE00 ctl 0xFE0A bmdma 0xFA00 irq 10
>     ata2: SATA max UDMA/133 cmd 0xFD00 ctl 0xFD0A bmdma 0xFA08 irq 10
>     scsi0 : sata_via
>     ata1: SATA link down (SStatus 0 SControl 310)
> >>  ATA: abnormal status 0x7F on port 0xFE07
>     scsi1 : sata_via
>     ata2: SATA link down (SStatus 0 SControl 310)
> >>  ATA: abnormal status 0x7F on port 0xFD07
>     sata_via 0000:00:0f.0: routed to hard irq line 11
>     ata3: SATA max UDMA/133 cmd 0xF900 ctl 0xF802 bmdma 0xF500 irq 11
>     ata4: SATA max UDMA/133 cmd 0xF700 ctl 0xF602 bmdma 0xF508 irq 11
>     scsi2 : sata_via
>     ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> >>  ATA: abnormal status 0x7F on port 0xF907
>     scsi3 : sata_via
>     ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> >>  ATA: abnormal status 0x7F on port 0xF707

I saw those too from times to times on boot with a VIA VT6421 with no
consequences.
So I would say they're non important (but who know for real until you
test with real disk attached?)
