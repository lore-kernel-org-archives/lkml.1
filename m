Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZEQUN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZEQUN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZEQUNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:13:47 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:51849 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZEQUNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=F8P3H5w7EiVsq2g+p1VOhkM+E57qmR7PA+MrY+JPj7FmQU1P47bC3IPsSKFd+JnXDk
         ZrKCiJ1W6hEqq4eECPMf5lSqRWVCy9+8qJj3nG9byxcGuFiWicsaWTCp+9rOz2aDnqNL
         HZRCgjFpVNerEcFoAbfXYrfTsTWSGL3MFTzc0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Sun, 17 May 2009 22:18:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>,
       linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <200905172145.45756.bzolnier@gmail.com> <20090517195051.GA5142@liondog.tnic>
In-Reply-To: <20090517195051.GA5142@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905172218.01606.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009 21:50:51 Borislav Petkov wrote:
> On Sun, May 17, 2009 at 09:45:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 May 2009 21:34:09 Borislav Petkov wrote:
> > > (adding Bart to CC)
> > > 
> > > Hi Bart,
> > > 
> > > please take a look at the OOPS below, seems like we BUG() in ide_intr() at
> > > BUG_ON(!hwif->handler) which shouldn't happen. Full message is at:
> > > 
> > > http://www.gossamer-threads.com/lists/linux/kernel/1077445.
> > > 
> > > It is 2.6.29.3 with both PIIX_IDE and ata_piix compiled and it could be
> > > that those two step on each other's toes, but this is only wild stab in
> > > the dark.
> > > 
> > > I'm sure you have more ideas.
> > 
> > Yes, see my other mail.
> 
> Saw it right after hitting send.
> 
> > [ After writing "I will cc: linux-ide on IDE/ATA problems" 100x times
> >   on the whiteboard... ;-) ]
> 
> And I CC'ed you instead, this has even bigger effect :)

Actually no.

I'm following all IDE discussions on linux-ide anyway and whenever I see
that I can help immediately I do it (and if I can't the issue gets its
priority level according to which it will be looked at later).  CC:ing me
on not fully debugged problems is not helping anything.  More likely that
it disrupts the work-flow since people are waiting on me instead of just
pushing for the solution harder...
