Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZAVXGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZAVXGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZAVXGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:06:24 -0500
Received: from ns.suse.de ([195.135.220.2]:43932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZAVXGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:23 -0500
Date: Thu, 22 Jan 2009 15:04:57 -0800
From: Greg KH <gregkh@suse.de>
To: kyle@infradead.org
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, J?rn Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122230457.GA24745@suse.de>
References: <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122215817.GA27609@suse.de> <20090122225025.GA21879@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122225025.GA21879@bombadil.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 05:50:26PM -0500, Kyle McMartin wrote:
> Playing devil's advocate here...
> 
> On Thu, Jan 22, 2009 at 01:58:17PM -0800, Greg KH wrote:
> > > * The fallout of staging is already starting to drift into distros.
> > >   Within a week of Fedora shipping a kernel that had staging/
> > >   we had requests to enable drivers from it.
> > >   And of course, those drivers were garbage.
> > >   This is only going to increase as time goes on.
> > 
> > That's up to you as a distro to handle, not much I can do there.
> > 
> > But, if you want a recommendation, some of the drivers in staging came
> > from the Fedora kernel tree, so you should be enabling them :)
> > 
> 
> Just at76, I think.

Yes.

> > What is wrong with it?  Bugs are getting fixed, people are getting use
> > out of their hardware (hell, Linus is even using one of the drivers),
> > and lots of developers are cutting their teeth on helping out.
> > 
> 
> Why does it need to be upstream for someone to cut their teeth helping
> out?

Because people don't know where to look if it is out-of-the tree.
Seriously, if it can't be easily found, it's not fixed up.  Proof of
that is the hundreds of out-of-tree drivers that I have found over the
past months.

> > If you don't like it, just disable it in your kernel packages, or
> > instantly close out the bugs.  The drivers in staging has already helped
> > out some distros by virtue of including newer drivers than they were
> > mistakenly using at the time (Ubuntu, I'm looking at you...)
> > 
> > And again, it's helped out users, which is the most important thing
> > here.
> > 
> 
> What concerns me is the precedent this sets. If "getting something
> upstream" now means "getting something into staging" then we've failed
> our users since there's no longer any motivation for a vendor to invest
> in all but the most cursory work on a Linux driver.

Woah, you are changing the conversation here totally.

This has nothing to do with "put pressure on a vendor to get their code
into upstream so that a distro will enable it."  We have vendors today
working with the staging tree to get their code cleaned up better to get
it into mergable shape to move over to the main portion of the kernel
tree.

Other vendors throw us code and run away.  We handle that as well, by
doing the work on our own, taking our time.  While that cleanup happens,
users can use their hardware with Linux without having to find the
latest version of a driver on a random google code site, and figure out
how to patch things to handle api changes that have happened since then
(true story for one of the drivers in staging right now.)

> I think we have higher standards to live up to than that.

The staging tree has NOTHING to do with our coding and acceptance
standards.  And anyone that thinks otherwise is totally mistaken.

> (I also think TAINT_CRAP is kind of an insulting name for things which
> are really Linux-targetted features that just haven't had thorough
> enough review. Evgeniy Polyakov's work comes to mind... it's really
> comparing apples to a bunch of festering pieces of turd.

It was his choice to put the code into there, I'll let him handle the
mental issues of having that taint flag associated with it for a few
releases :)

> In summary, I don't know, this is one of those damned if you do, damned
> if you don't paradoxes. ;-) But if you suck in a driver that barfs all
> over your filesystem, because it was allowed to be turned in with zero
> review, are you going to be the one to tell the user "ha ha, sucks to be
> you?" I sure wouldn't want to be.

I'll take responsibility if such a thing happens.  Fear of such a thing
is no reason to prevent users from having their hardware work properly
with Linux.

Again, I'll point to Linus's laptop that now works properly due to the
drivers/staging/ tree as a very visible example of this effort actually
working properly.

thanks,

greg k-h
