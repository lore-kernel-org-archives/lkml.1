Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZAVXfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZAVXfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZAVXff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:35:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbZAVXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:35:34 -0500
Date: Thu, 22 Jan 2009 18:34:40 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: kyle@infradead.org, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, J?rn Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122233439.GB21879@bombadil.infradead.org>
Reply-To: kyle@infradead.org
References: <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122215817.GA27609@suse.de> <20090122225025.GA21879@bombadil.infradead.org> <20090122230457.GA24745@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122230457.GA24745@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:04:57PM -0800, Greg KH wrote:
> > Why does it need to be upstream for someone to cut their teeth helping
> > out?
> Because people don't know where to look if it is out-of-the tree.
> Seriously, if it can't be easily found, it's not fixed up.  Proof of
> that is the hundreds of out-of-tree drivers that I have found over the
> past months.

What about the hundreds of utterly crap drivers we have *right now* in
the kernel? Just because something is distributed with the kernel does
*not* mean it will get cleaned up. There's hundreds of counterexamples
to that. If you think moving some of them to drivers/staging to increase
the "visibility" to people looking for low hanging fruit, I can generate
a list...

> > What concerns me is the precedent this sets. If "getting something
> > upstream" now means "getting something into staging" then we've failed
> > our users since there's no longer any motivation for a vendor to invest
> > in all but the most cursory work on a Linux driver.
> 
> Woah, you are changing the conversation here totally.
> 

What if vendor X has decided that they can now save some money by simply
dumping the code at the "hey, I'll take anything" tree instead of
continuing to work with the community, or following the example of people
who do. They can still tell their users "we're upstream, just enable
this CONFIG option and our stuff will work."

> This has nothing to do with "put pressure on a vendor to get their code
> into upstream so that a distro will enable it."  We have vendors today
> working with the staging tree to get their code cleaned up better to get
> it into mergable shape to move over to the main portion of the kernel
> tree.
> 
> Other vendors throw us code and run away.  We handle that as well, by
> doing the work on our own, taking our time.  While that cleanup happens,
> users can use their hardware with Linux without having to find the
> latest version of a driver on a random google code site, and figure out
> how to patch things to handle api changes that have happened since then
> (true story for one of the drivers in staging right now.)
> 

My concern is what was stated above, that vendors who have historically
done the right thing may have less motivation to continue in the future.

I defer to your judgement though.

> > I think we have higher standards to live up to than that.
> 
> The staging tree has NOTHING to do with our coding and acceptance
> standards.  And anyone that thinks otherwise is totally mistaken.
> 

I don't know how you can say this, given. Nothing in there would
make the cut at all... obviously it has a lower barrier to entry. Is
there a maintenance burden imposed on someone for staging? I mean, to
get something in there is someone agreeing to take point on all the
issues?

If its purpose isn't "the staging point for things to get (in theory)
cleaned up because people want convenience now" then what is it?

> > In summary, I don't know, this is one of those damned if you do, damned
> > if you don't paradoxes. ;-) But if you suck in a driver that barfs all
> > over your filesystem, because it was allowed to be turned in with zero
> > review, are you going to be the one to tell the user "ha ha, sucks to be
> > you?" I sure wouldn't want to be.
> 
> I'll take responsibility if such a thing happens.  Fear of such a thing
> is no reason to prevent users from having their hardware work properly
> with Linux.
> 
> Again, I'll point to Linus's laptop that now works properly due to the
> drivers/staging/ tree as a very visible example of this effort actually
> working properly.
> 

I assume this is the eee wireless?

As I said, I'm not (deliberately) trying to be negative. I'm simply
trying to understand the rationale. I'm sorry if I sound that way, but
working on distros has made me horribly pragmatic about these things.

I guess time will tell.

cheers, Kyle

> thanks,
> 
> greg k-h
> 
