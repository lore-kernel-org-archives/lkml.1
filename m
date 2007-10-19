Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbXJSVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbXJSVjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXJSVjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:39:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:13234 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbXJSVjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hqa9AfyKaUtlpOdXsse2zFa7W9RndRSy0zf2vItSfSMnODpOs0EksMFulsxUTaqAwiMOpAxQeFlo00IzF7c2Hp8DH1iEmSqsUnRpGlUD6gM/iWBocB/f2QHZ0EcxFGy74jVKB2LhCaQ/gNeuzqdupNR27SnLxuhLF8NJtzPa1xk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: nick@ukfsn.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Fri, 19 Oct 2007 23:44:27 +0200
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <20071019210743.GI4003@csclub.uwaterloo.ca> <200710192212.30533.nick@ukfsn.org>
In-Reply-To: <200710192212.30533.nick@ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192344.27312.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007, Nick Warne wrote:
> On Friday 19 October 2007 22:07:43 Lennart Sorensen wrote:
> > On Fri, Oct 19, 2007 at 10:03:09PM +0100, Nick Warne wrote:
> > > No change:
> > >
> > > ide_setup: hdd=ide-cd
> > >     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
> > > hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
> > > hdd: drive side 80-wire cable detection failed, limiting max speed to
> > > UDMA33 hdd: selected mode 0x42
> > > hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
> >
> > Did you try another cable?  DId you try using both the old IDE drivers
> > and the new PATA libata drivers?  What is the hdd=ide-cd supposed to
> > do?  Do you have a device present as hdc and if not, then why not?
> > (Hint: ATA spec requires a master before you can have a slave, even
> > though it frequently does work with just a slave.  Of course cable
> > select seems even nicer since then the device at the end of an 80 wire
> > cable is automatically master, and any additional device added to the
> > middle connector on the cable becomes slave, and you should not connect
> > a device to the middle connector without one on the end).
> >
> > Also make sure the right end of the cable is connected to the mainboard,
> > just in case that matters.
> 
> I have (since 2.6.15 at least) hda, hdb, hdc, and hdd.
> 
> hda and hdb are mounted at boot.  hdc is not mounted, as I leave that drive 
> for backups and mount as needed.
> 
> All I done was replace a duff cd/dvd drive (hdd) with a new one.

Ah, so the patch won't help (sorry, I didn't pay enough attention).

Len's advices are worth the try, also please send the output
of hdparm -I /dev/hdd.

Thanks,
Bart
