Return-Path: <linux-kernel-owner+w=401wt.eu-S1765599AbYBTPkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765599AbYBTPkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbYBTPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:38:56 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45587 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416AbYBTPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:38:53 -0500
Message-ID: <47BC498C.6000400@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 16:38:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>	<20080212042133.GA4625@kroah.com>	<20080211203146.3d28d1a0@laptopd505.fenrus.org>	<1202791555.20739.6.camel@heimdal.trondhjem.org>	<20080212051136.GA12802@mit.edu>	<20080211221535.bc0dc9cf.akpm@linux-foundation.org>	<20080212225716.cf695fe4.sfr@canb.auug.org.au>	<20080214081405.GA20791@flint.arm.linux.org.uk>	<20080214232229.f7bdc6ac.sfr@canb.auug.org.au>	<alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org> <20080221015511.1b54d4d3.sfr@canb.auug.org.au>
In-Reply-To: <20080221015511.1b54d4d3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Thu, 14 Feb 2008 10:01:14 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> I absolutely have no problem with having a "this is the infrastrcture 
>> changes that will go into the next release". In fact, I can even 
>> *maintain* such a branch. 
>> 
>> I've not wanted to open up a second branch for "this is for next release", 
>> because quite frankly, one of the other problems we have is that people 
>> already spend way too much time on the next release compared to just 
>> looking at regressions in the current one. But especially if we're talking 
>> about _purely_ API changes etc infrastructure, I could certainly do a 
>> "next" branch. 
> 
> So, will you open such a branch?  If so, what would be the mechanics of
> having patches applied to it?  I assume people would have to suggest such
> changes explicitly and have them reviewed (hopefully more thoroughly than
> usual) in that light.  I guess one place these "infrastructure" changes
> may be noticed would be when subsystem maintainers stray outside their
> subsystem in what they submit to the linux-next tree (or break it).

Two things may largely eliminate the need for parallel branches.

1. Do infrastructure changes and whole tree wide refactoring etc. in a
compatible manner with a brief but nonzero transition period.

2. Insert a second merge window right after the usual merge window for
changes which cannot be well done with a transition period.

(I probably missed a number of points why these two things are not
always feasible, because I am just a downstream person.)
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
