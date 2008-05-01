Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYEAAcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYEAAcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYEAAcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:32:11 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37180 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYEAAcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:32:10 -0400
Date: Thu, 1 May 2008 03:31:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: RFC: starting a kernel-testers group for newbies
Message-ID: <20080501003125.GM29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 01:31:08PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
> > 
> > <jumps up and down>
> > 
> > There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> 
> The problem I see with both -mm and linux-next is that they tend to be 
> better at finding the "physical conflict" kind of issues (ie the merge 
> itself fails) than the "code looks ok but doesn't actually work" kind of 
> issue.
> 
> Why?
> 
> The tester base is simply too small.
> 
> Now, if *that* could be improved, that would be wonderful, but I'm not 
> seeing it as very likely.
> 
> I think we have fairly good penetration these days with the regular -git 
> tree, but I think that one is quite frankly a *lot* less scary than -mm or 
> -next are, and there it has been an absolutely huge boon to get the kernel 
> into the Fedora test-builds etc (and I _think_ Ubuntu and SuSE also 
> started something like that).
> 
> So I'm very pessimistic about getting a lot of test coverage before -rc1.
> 
> Maybe too pessimistic, who knows?

First of all:
I 100% agree with Andrew that our biggest problems are in reviewing code 
and resolving bugs, not in finding bugs (we already have far too many 
unresolved bugs).

But although testing mustn't replace code reviews it is a great help, 
especially for identifying regressions early.

Finding testers should actually be relatively easy since it doesn't 
require much knowledge from the testers.

And it could even solve a second problem:

It could be a way for getting newbies into kernel development.

We actually do only rarely have tasks suitable as janitor tasks for 
newbies, and the results of people who do neither know the kernel
nor know C running checkpatch on files in the kernel have already
been discussed extensively...

I'll try to do this:
- create some Wiki page
- get a mailing list at vger
- point newbies to this mailing list
- tell people there which kernels to test
- figure out and document stuff like how to bisect between -next kernels
- help them to do whatever is required for a proper bug report

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

