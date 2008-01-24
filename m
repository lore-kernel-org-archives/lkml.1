Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYAXSQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYAXSQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYAXSQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:16:16 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39016 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbYAXSQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:16:15 -0500
Date: Thu, 24 Jan 2008 20:14:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <davidn@davidnewall.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080124181442.GE4476@does.not.exist>
References: <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist> <4798D10C.6090109@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4798D10C.6090109@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 04:25:24AM +1030, David Newall wrote:
> Adrian Bunk wrote:
> > Removing dead code makes:
> > - the kernel smaller,
> > - the kernel faster and
> > - makes it easier to maintain the non-dead code.
> 
> The performance benefit is trivial, and the improvement to
> maintainability is even less.

The effects become bigger when you realize that there are many such 
places in the kernel.

And the benefit of keeping it is zero.

Even in the hypothetical case that someone would use it, he could simply 
re-add it.

> > All of these are considered useful by the people who actually 
> > contribute to the Linux kernel.
> 
> Contributions to the kernel take forms other than just code.  I'm
> contributing in this very instance by putting the argument against
> removal of code.  Once removed it'll be much harder to re-insert than to
> repair in-situ.

What you are doing is not contributing but wasting other people's time.

The only thing you could ever achieve with this kind of "contribution" 
is to end up in some killfiles.

> >> At one stage iBCS2 support DID work.  Now it doesn't.  Now there's an
> >> argument that the remaining infrastructure should be removed.  This is
> >> the wrong direction to take.
> >>     
> >
> > When did iBCS2 support work in a plain ftp.kernel.org kernel?
> >   
> I don't know when.  Are you disputing that it ever did?  I think it's a
> given that once it worked.

AFAIK the kernel never shipped with iBCS2 support.

Which kernels under ftp://ftp.kernel.org/pub/linux/kernel/v*.*/ fulfill 
your claim?

> > And if you consider iBCS2 support that important I can only repeat that 
> > the language on Linux kernel are patches, not hot air.
> 
> Fools believe that code is the only acceptable offering, and you, by
> reputation, are not a fool.  There are plenty of examples where
> suggestions made on list have value far exceeding a lot of the code. 
> For that matter, some of the code that's offered is crap.  For that
> matter, good contributed code too often (and in some cases famously)
> gets ignored or rejected for reasons of ego.  You diminish yourself by
> implying that code is the only thing that matters, and present the
> impression that you know little about good development practice, in
> which design effort exceeds that of coding.  I do not believe you are a
> cowboy; stop talking like one.
> 
> Look at the merits of iBCS2 support.  Is it desirable?  Yes.  Is it
> useful to remove what support remains?  Not particularly.  Does it
> improve performance?  Trivially; almost immeasurably.   Does it improve
> clarity?  No.  Does the code serve any useful purpose?  Yes, by acting
> as a reminder of work still be done.  It's like the /* XXX */ comments
> that are widely sprinkled through the system, only more concrete.  The
> benefits of removing it do not outweigh the benefits of leaving it.

The point is that ideas do not turn themselves into code.

And there are far too many people who want to see their great ideas 
implemented without implementing it themselves.

Talking about a feature without having anyone willing to implement it 
simply has no value.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

