Return-Path: <linux-kernel-owner+w=401wt.eu-S1765026AbYA2RFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765026AbYA2RFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbYA2REy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:04:54 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:55047 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYA2REv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:04:51 -0500
Date: Tue, 29 Jan 2008 12:04:43 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <18335.22763.625990.528217@alkaid.it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Richard Heck <rgheck@bobjweil.com>,
       Daniel Barkalow <barkalow@iabervon.org>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801291204.44671.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801291132.41657.gene.heskett@gmail.com>
 <18335.22763.625990.528217@alkaid.it.uu.se>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Mikael Pettersson wrote:
>Gene Heskett writes:
> > On Tuesday 29 January 2008, Alan Cox wrote:
> > >> As slight change here, I was going to use the same .config as
> > >> 2.6.24-rc8, but just discovered that neither rc8 nor final is finding
> > >> the drivers for my
> > >
> > >If it is not finding a driver that is nothing to do with libata. It
> > > means it's not being loaded by the distribution, or the distribution
> > > kernel is too old (2.6.22) for the hardware - in which case see the
> > > Fedora respins which are on 2.6.23.something right now.
> > >
> > >Alan
> >
> > Home built kernel Alan.  But you are as good as anyone to tell me what I
> > need to turn on in order for this dvdwriter to be enabled:
> > [   28.862478] ata2.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS06, max
> > UDMA/66 ....
> > [   28.908647] ata2.00: limited to UDMA/33 due to 40-wire cable
> > [   29.081253] ata2.00: configured for UDMA/33
> > ....
> > it has had several 80 wire cables tried, hasn't fixed this, and does not
> > seem to effect its operation when it does work.
> > ....
> > [   29.132405] scsi 1:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S
> > HS06 PQ: 0 ANSI: 5 ....
> > [   43.450795] scsi 1:0:0:0: Attached scsi generic sg1 type 5
> > -------
> > No further mention of it in dmesg, and k3b cannot find the drive at any
> > /dev/sgX address.
> >
> > .config attached, what else do I need to turn on?
>
>...
>
> > # CONFIG_BLK_DEV_SR is not set
>
>For starters, enable CONFIG_BLK_DEV_SR.

That could stand to be moved or renamed, it is well buried in the menu for the 
REAL scsi stuffs, which I don't have any of.  Enabled & building now.  
Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
An air of FRENCH FRIES permeates my nostrils!!
