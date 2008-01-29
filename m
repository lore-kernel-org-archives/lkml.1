Return-Path: <linux-kernel-owner+w=401wt.eu-S1765896AbYA2Qte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765896AbYA2Qte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbYA2QtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:49:24 -0500
Received: from aun.it.uu.se ([130.238.12.36]:53786 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453AbYA2QtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:49:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18335.22763.625990.528217@alkaid.it.uu.se>
Date: Tue, 29 Jan 2008 17:48:43 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Richard Heck <rgheck@bobjweil.com>,
       Daniel Barkalow <barkalow@iabervon.org>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <200801291132.41657.gene.heskett@gmail.com>
References: <200801272122.21823.gene.heskett@gmail.com>
	<200801290951.55492.gene.heskett@gmail.com>
	<20080129154752.3d7758f1@core>
	<200801291132.41657.gene.heskett@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett writes:
 > On Tuesday 29 January 2008, Alan Cox wrote:
 > >> As slight change here, I was going to use the same .config as 2.6.24-rc8,
 > >> but just discovered that neither rc8 nor final is finding the drivers for
 > >> my
 > >
 > >If it is not finding a driver that is nothing to do with libata. It means
 > >it's not being loaded by the distribution, or the distribution kernel is
 > >too old (2.6.22) for the hardware - in which case see the Fedora respins
 > >which are on 2.6.23.something right now.
 > >
 > >Alan
 > 
 > Home built kernel Alan.  But you are as good as anyone to tell me what I 
 > need to turn on in order for this dvdwriter to be enabled:
 > [   28.862478] ata2.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS06, max UDMA/66
 > ....
 > [   28.908647] ata2.00: limited to UDMA/33 due to 40-wire cable
 > [   29.081253] ata2.00: configured for UDMA/33
 > ....
 > it has had several 80 wire cables tried, hasn't fixed this, and does not
 > seem to effect its operation when it does work.
 > ....
 > [   29.132405] scsi 1:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S HS06 PQ: 0 ANSI: 5
 > ....
 > [   43.450795] scsi 1:0:0:0: Attached scsi generic sg1 type 5
 > -------
 > No further mention of it in dmesg, and k3b cannot find the drive at any 
 > /dev/sgX address.
 > 
 > .config attached, what else do I need to turn on?

...

 > # CONFIG_BLK_DEV_SR is not set

For starters, enable CONFIG_BLK_DEV_SR.
