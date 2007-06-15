Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbXFORTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbXFORTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXFORTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:19:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbXFORTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:19:10 -0400
Date: Fri, 15 Jun 2007 10:18:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Greaves <david@dgreaves.com>
cc: Daniel Hazelton <dhazelton@enter.net>, Michael Gerdau <mgd@technosis.de>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <46726793.1020206@dgreaves.com>
Message-ID: <alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <200706142049.41819.dhazelton@enter.net> <200706150825.15491.mgd@technosis.de>
 <200706150520.15086.dhazelton@enter.net> <46726793.1020206@dgreaves.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, David Greaves wrote:
> 
> Surely it's more:
>   bad == go away and don't use future improvements to our software anymore
> please.
> ??

Well, with the understanding that I don't think that what Tivo did was bad 
in the first place, let me tackle that question *anyway*.

The answer is: Not necessarily.

Some people can be "bad" for the community. They may simply be disruptive 
and not productive at all. They may troll the mailing lists without 
actually ever doing something good, or they may do other "bad" things.

In fact, let's make it *very* specific: let's say that the bad person is a 
cracker, and specializes in finding security holes, and writing exploits 
for them, and selling those exploits to spammers.

Most of us might agree that that is a "bad" person for the community, no?

Now, by your own logic, let's look at what that means for the license. 
Should we write into our copyright license that you cannot try to find 
security holes? Would that be a good addition to the GPLv2?

Now, I stated that in a way where the answer is obvious: that would be a 
*horrible* addition to the GPLv2. I think everybody can agree on that. It  
would be really stupid to say "you cannot look for security holes" just 
because *some* people who do it are bad.

Now, think about that for a moment, and then go back to your question 
about whether Tivo is bad for the community, and whether being bad for the 
community should mean that the license should be written to say "go away 
and don't use future improvements to our software".

See where I'm trying to take you?

I think that even people who *do* think that what Tivo did was "bad", 
should think very deeply about the issue whether you should try to lock 
out "bad uses" in your license. Yes, the answer may be "yes, you should". 
But I'm arguing that the answer _may_ also be: "No, you shouldn't, becasue 
it turns out that you might lock out _good_ people too".

So in my cracker/spammer example, by trying to lock out the bad people, 
the obvious (and _stupid_ - don't get me wrong, I'm not at *all* 
suggesting anything like that should ever be done) license addition of 
"don't expose security problems" actually just causes more problems than 
it solves (if it solves anything at all - really bad people don't actually 
tend to even care about the license!).

It makes it harder for *valid* uses of security problem discovery. It 
makes it potentially illegal to try to do security research. And don't 
tell me stupid licenses and laws like that don't happen: people really 
*do* make these kinds of shortsighted decisions, to "protect" themselves 
from bad people.

I personally think that the same is true of the GPLv3 anti-tivoization 
clauses. Even if you don't like Tivo, you may well recognize that there 
are lots of *other* reasons for lock-down. Maybe you hate Tivo, and the 
RIAA and the MPAA. Fine. What about the FCC? Or what about secure 
terminals? What about any number of *other* reasons to use validated 
kernel images?

Now, I cannot speak for Alan Cox (he can speak damn well for himself), but 
I think Alan is an example of a person who actually really detests what 
Tivo did. But I also am pretty sure that he's also quite smart enough to 
see that the GPLv3 anti-tivoization clauses may stop *other* uses that he 
doesn't dislike and he doesn't think are "wrong", and even though he 
dislikes what Tivo does, as far as I know, I think his stance on the GPLv3 
is that it's actually wrong for Linux.

See? You don't actually have to like Tivo to see downsides to trying to 
stop them. Because these kinds of things have consequences *outside* of 
just stopping Tivo.

			Linus
