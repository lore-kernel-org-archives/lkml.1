Return-Path: <linux-kernel-owner+w=401wt.eu-S2992654AbXDRUu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992654AbXDRUu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992675AbXDRUu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:50:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57449 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992654AbXDRUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:50:57 -0400
Date: Wed, 18 Apr 2007 21:50:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Len Brown <lenb@kernel.org>, Stephen.Clark@seclark.us,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.21-rc5 from fc7-rc2 problems
Message-ID: <20070418215039.683f80ee@the-village.bc.nu>
In-Reply-To: <46267E38.9020909@garzik.org>
References: <460EC109.5070300@seclark.us>
	<460EFC76.4060808@seclark.us>
	<460FF40D.2060109@seclark.us>
	<200704181612.07257.lenb@kernel.org>
	<46267E38.9020909@garzik.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> scsi0 : pata_ali
> >> PM: Adding info for No Bus:host0
> >> ata1.00: ATA-5: HITACHI_DK23CA-20, 00H1A0A3, max UDMA/100   <========
> >> drive can do 100
> >> ata1.00: 39070080 sectors, multi 16: LBA
> >> ata1.00: configured for UDMA/33    <=============== configured as 33

How is this system actually set up - what cable is used on that drive ?

> >> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >> ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 36 in
> >>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >> ata2: soft resetting port
> 
> It looks like interrupts are not being delivered?

We still have a problem with pata_ali and ATAPI. I'm still trying to work
out wtf is going on there as I can't find any meaningful difference and
even some paranoid 'assume the worst of the comments in the databook'
additional code isn't helping.
