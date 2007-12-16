Return-Path: <linux-kernel-owner+w=401wt.eu-S935012AbXLPRHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbXLPRHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933926AbXLPRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:07:32 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:34553 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752483AbXLPRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:07:30 -0500
X-Trace: 648709807-mk-filter-2.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.89.91
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAD7qZEdRAVlb/2dsb2JhbACBV6Yk
Subject: Re: [PATCH 0/3] Add GD-Rom support to the SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, axboe@kernel.dk, linux-ide@vger.kernel.org
In-Reply-To: <20071216041348.GB11113@linux-sh.org>
References: <8b67d60712151620s331281f4s7e150aacacff4400@mail.gmail.com>
	 <20071216041348.GB11113@linux-sh.org>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 17:06:46 +0000
Message-Id: <1197824806.6254.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-16 at 13:13 +0900, Paul Mundt wrote:
> On Sun, Dec 16, 2007 at 12:20:54AM +0000, Adrian McMenamin wrote:
> > This device is electrically compatible with ATA-3 IDE CD drives but
> > implements a proprietary packet interface. There have been previous
> > Dreamcast CD drivers around but this is new code and uses DMA as
> > opposed to PIO for reads.
> > 
> > It also supports reading the proprietary GD Rom format disks.
> > 
> > The driver will live as drivers/sh/gdrom/gdrom.c
> > 
> No, the driver will live in drivers/cdrom if that's the API that you
> depend on. The only things in drivers/sh are SH-specific bus support
> code, it is not a dumping ground for unrelated drivers.


Well, the other cd drives exist in mainline outside that directory eg
drivers/block/paride/pcd.c  drivers/ide/ide-cd.c drivers/scsi/sr.c 

As far as I can see if this joins mainline it will be the only
proprietary CD device - there were six others which were
in /drivers/cdrom but they were purged recently.

I'm not bothered where it goes, though.

