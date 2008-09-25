Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYIYU4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYIYU4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYIYU4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:56:36 -0400
Received: from mail.suse.de ([195.135.220.2]:38163 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYIYU4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:56:35 -0400
Date: Thu, 25 Sep 2008 13:48:00 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080925204800.GA11225@suse.de>
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925052725.GA5739@linux-sh.org> <20080925074923.4845005b.randy.dunlap@oracle.com> <20080925105320.ef70065b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925105320.ef70065b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:53:20AM -0700, Randy Dunlap wrote:
> On Thu, 25 Sep 2008 07:49:23 -0700 Randy Dunlap wrote:
> 
> > On Thu, 25 Sep 2008 14:27:26 +0900 Paul Mundt wrote:
> > 
> > > On Wed, Sep 24, 2008 at 10:59:03PM -0400, Parag Warudkar wrote:
> > > > On Wed, Sep 24, 2008 at 10:06 PM, Greg KH <gregkh@suse.de> wrote:
> > > > > No, this is much different from EXPERIMENTAL.  That flag is pretty much
> > > > > useless right now.  This is for a temporary landing place for drivers
> > > > > that are not good enough to be merged, yet are useful enough for some
> > > > > people to use.
> > > > 
> > > > How? TAINT_EXPERIMENTAL (I'll stick to that, thanks :) and
> > > > CONFIG_EXPERIMENTAL are no different - neither to users nor to
> > > > developers. Here is why -
> > > > Both try to do the same thing - let people use the drivers on their
> > > > own risk (as if the stable ones are developer's risk - but let's keep
> > > > it aside for the moment) and give developers a chance to keep the code
> > > > in sync with mainline and improve it per user problem reports or
> > > > generally make it better.
> > > > 
> > > Uhm.. not quite. As the one that proposed the flag in the first place,
> > > perhaps it helps to cover the rationale (although Greg seems to have
> > > mostly covered that already).
> > > 
> > > EXPERIMENTAL today is pretty damn meaningless. What it tends to mean in
> > 
> > then it would be better if Greg/someone cleaned up the current tree's
> > problems instead of introducing more CRAP under a different name.
> > Oh well, his mind is already made up and I know how difficult it is to
> > change it.
> 
> I shouldn't have said that last sentence.  I apologize to Greg.

Heh, no problem, normally my problem is that I change my mind too often,
or so my kids complain :)

> ISTM that the real problems are (a) it's easier to introduce new staging/crap
> than it is to fix EXPERIMENTAL and (b) no one wants to try to fix EXPERIMENTAL.

The whole EXPERIMENTAL issue hasn't come up in years, I'm supprised that
people even consider it a valid option these days.

I'm all for fixing it up, but as Paul so well described, the code I'm
talking about is WAY worse than a mere "experimental" marking, it needs
to be explicitly pointed out that this is not even up to that level at
all.

And as was also pointed out, the EXPERIMENTAL marking cleanup is totally
orthogonal to the main goal here, and that is getting code into the tree
that is not up to our "normal" merge quality levels, in order to get a
wider audience of users and developers working on it, and using it.

Hey, if people want me to name it TAINT_GREGKH, I can do that, I thought
I was being nice by picking TAINT_CRAP...

thanks,

greg k-h
