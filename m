Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZJFP1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZJFP1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZJFP1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:27:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757848AbZJFP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:27:21 -0400
Date: Tue, 6 Oct 2009 08:24:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <20091006144449.GA23078@elte.hu>
Message-ID: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Ingo Molnar wrote:
> 
> We can ignore that and say "hehe, you dont understand non-linear trees 
> and ran git remote update blindly, too bad for you", or we might do 
> something to make things more transparent and reduce the confusion. 

You are missing the point.

The only thing we can do is to teach people that the Makefile version 
isn't too important, and that it really doesn't tell very much.

Trying to tweak it to make it somehow "more meaningful" is a BAD THING, 
because it continues to spoon-feed people a lie. 

The cake is a lie. In between kernel versions, you can't rely on the 
Makefile.  You should teach yourself (and others) THAT, rather than trying 
to teach people to believe the lie even more.

Once you start believing the lie, suddenly all the subtrees will start 
thinking that now _their_ kernel versions are bad, so now they'll start to 
want to make the same idiotic changes to their Makefiles, or maybe 
they'll decide that they don't want to pull tagged releases, but the "one 
after the tag so that they'll get the updated Makefile".

And even if they don't do that idiocy, the whole "the version number is 
meaningful outside of releases" thing leads to brain damage. 

> One option would be to make LOCALVERSION_AUTO compulsory.

Yes, I could live with that. If you're compiling from a git tree, we migth 
as well show the real version.

It's the "let's make that meaningful and misleading number be even _more_ 
misleading by making people think it has meaning" magical thinking that I 
hate.

It's wrong, and it leads people to believe in things that aren't true. I 
refuse to cater to that kind of wrongheaded thinking.

I'd much rather screw up the version number entirely and add a _random_ 
number to it (so that the Makefile would say "2.6.18" after I have 
released 2.6.32) just so that people would be forced to _understand_ that 
the version number isn't as meaningful as you seem to think it is.

For example, let's take Arjan's request, that kerneloops should get -rc0.

Think about that for a few minutes. Really THINK about it. What happens?

[ Spend some time really thinking here. ]

What about people like all the networking guys who are running their 
development kernels that haven't been merged yet? Their kernels won't say 
-rc0. Are you going to ask them to do it too?

Or would you be better off teaching kerneloops about local versions?

		Linus
