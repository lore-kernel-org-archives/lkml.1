Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZEQXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZEQXOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZEQXOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:14:00 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46777 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZEQXN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=dbFlI07nVF3G1GLymk8xoDHjfLKI7yyDGqTwFdGC7BKZz2i9hvS7AbNBr0+O+VySOQ
         mp9oJY0qrDd7TyAutmTA8HULPf7wrVQc14/yLUYeZs0iztHC56otDxOyobut+VHRn8IC
         R+ir+Vxsei3K8zGxvRX1O2WoCDipZKMjvHg2M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Mon, 18 May 2009 00:48:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>,
       linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <200905172218.01606.bzolnier@gmail.com> <20090517203033.GB5142@liondog.tnic>
In-Reply-To: <20090517203033.GB5142@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905180048.36483.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009 22:30:33 Borislav Petkov wrote:
> Hi,
> 
> On Sun, May 17, 2009 at 10:18:01PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 May 2009 21:50:51 Borislav Petkov wrote:
> > > On Sun, May 17, 2009 at 09:45:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Sunday 17 May 2009 21:34:09 Borislav Petkov wrote:
> > > > > (adding Bart to CC)
> > > > > 
> > > > > Hi Bart,
> > > > > 
> > > > > please take a look at the OOPS below, seems like we BUG() in ide_intr() at
> > > > > BUG_ON(!hwif->handler) which shouldn't happen. Full message is at:
> > > > > 
> > > > > http://www.gossamer-threads.com/lists/linux/kernel/1077445.
> > > > > 
> > > > > It is 2.6.29.3 with both PIIX_IDE and ata_piix compiled and it could be
> > > > > that those two step on each other's toes, but this is only wild stab in
> > > > > the dark.
> > > > > 
> > > > > I'm sure you have more ideas.
> > > > 
> > > > Yes, see my other mail.
> > > 
> > > Saw it right after hitting send.
> > > 
> > > > [ After writing "I will cc: linux-ide on IDE/ATA problems" 100x times
> > > >   on the whiteboard... ;-) ]
> > > 
> > > And I CC'ed you instead, this has even bigger effect :)
> > 
> > Actually no.
> > 
> > I'm following all IDE discussions on linux-ide anyway and whenever I see
> > that I can help immediately I do it (and if I can't the issue gets its
> > priority level according to which it will be looked at later).  CC:ing me
> > on not fully debugged problems is not helping anything.  More likely that
> > it disrupts the work-flow since people are waiting on me instead of just
> > pushing for the solution harder...
> 
> In this case, however, it made more sense to CC you - you know that code
> better than me, you have the bunch of experience while I have to read
> a ton of stuff before I get up to speed with the problem. You, on the
> other hand, have seen similar errors like that before and can at least

You seem to forget that I'm not reading LKML regularly but I do linux-ide
(I know that the same is true for some other people) so I would have helped
much earlier if I had noticed the *initial* mail instead of the most recent
at the time...

> have a hunch - and you did. Besides, it's not like I'm waiting for you
> - I have other things on my plate which I could tackle while you handle
> the case you're more knowledgeable at. It is simple as that.

That is missing the point -- we are not the only knowledgeable ones here
and we definitely want to encourage other people to attack the problems.

[ Please read my mail again.  I explicitly said "people" not "you" there. ]

> But I'll start CCing linux-ide if that's your preference.

Thanks but my preferences are not the point here.  That is just the most
efficient way for everybody: IDE/ATA problems should be handled at linux-ide
mailing list.  You can still cc: me but cc:ing linux-ide takes priority.

Thanks.
Bart
