Return-Path: <linux-kernel-owner+w=401wt.eu-S933865AbZJGAwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865AbZJGAwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933802AbZJGAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:52:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50732 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933672AbZJGAwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:52:42 -0400
Date: Wed, 7 Oct 2009 02:51:47 +0200
From: Florian Mickler <florian@mickler.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hohndel@infradead.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091007025147.2690ec23@schatten>
In-Reply-To: <200910062029.09910.elendil@planet.nl>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	<200910061923.00723.elendil@planet.nl>
	<alpine.LFD.2.01.0910061030380.3432@localhost.localdomain>
	<200910062029.09910.elendil@planet.nl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 20:29:08 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Tuesday 06 October 2009, Linus Torvalds wrote:
> > Have you missed the whole discussion about why it doesn't work?
> > Have you missed the point on why it is FUNDAMENTALLY WRONG to do?
> 
> No, I've followed the discussion. I guess I just disagree with you as my 
> perspective is different. I still think there are practical advantages to 
> it, even if it is not 100% theoretically correct from a versioning PoV 
> (which I've already said I agree with).

We shouldn't try to weaken the version-numbering-scheme
more. And every action which only 'suggests' that the version-number
has more weight, than it actually has is just papering over the real
bug. 

It works if you are only some bird sitting at
one branch of the kernel-development-tree (the git DAG, that is)
looking at what he thinks is the tip of the tree. 

But this scheme does not work in the 'decentralised' kernel-scenario.
Because if only one subsystem-maintainer forgets to 'put the zero' into
his branch, anybody who tries that branch is at the same situation
as before.  So it would be useless for any 'colaboration based effort'. 

Nice to have as a bird, but as a ranger you can't expect every tree to
have a tip. ( actually you can .. note to self: ... i'm getting
confused in this alegory... whatever... just relax, refocus and go
on.. ) 

On the other hand, if you could modify the DNA of the trees to make
them 
a) better, so they prevail and other trees extinguish over time and 
b) have him grow 'pluses' at the tip (or whatever distinguishing
feature a released tree exhibits ) the ranger could then wander through 
the forest and just look for pluses to do, whatever he needs to do
with those branches.. aerm trees ... ah whatever. 


i hope you are not lost in the woods, and to sumarize: i've no business
whatsoever in the linux-kernel, but read lkml instead of doing smth
useful. ah, and i think a change in the build-mechanics to distinguish
releases is the way to go, instead of a commit. 

but the problem you noted with the 'export' from git into the ''real
world'' is of course there. 
maybe there is a solution to this? eventually smth like "if you don't
use git you have to always tell the truth? or any other way to 
'dirty' the makefile at export-time ?  in-kernel boot-time checksumming
of the kernel-image? to get at least uname -r right?


dunno,
Florian

-- 
A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?  
>> A: Top-posting.  
>>> Q: What is the most annoying thing in e-mail?
