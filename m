Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXICNf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXICNf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXICNfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:35:47 -0400
Received: from dsl-210-15-216-215-static.VIC.netspace.net.au ([210.15.216.215]:30530
	"EHLO lechuck.goblin.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXICNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:35:46 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 09:35:45 EDT
Date: Mon, 3 Sep 2007 23:25:42 +1000
From: Jonathan Gray <jsg@goblin.cx>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [reyk@openbsd.org: Re: That whole "Linux stealing our code" thing]
Message-ID: <20070903132542.GA902@mail.netspace.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a lot more relevant than much of the ongoing
discussion, so perhaps people could take a moment to read it over.

----- Forwarded message from Reyk Floeter <reyk@openbsd.org> -----

From: Reyk Floeter <reyk@openbsd.org>
Date: Mon, 3 Sep 2007 13:23:04 +0200
To: misc@openbsd.org
Subject: Re: That whole "Linux stealing our code" thing

Hi!

I just returned from vacation where I was offline for about two weeks.
So I totally missed the incidence and all the surrounding discussion.
I'm just digging through many many mails in my inbox from OpenBSD
users and developers, Linux people, GNU/freesoftware people, misc *BSD
people, and obviously from some trolls.

I don't want to restart the discussion but I just want to say and
repeat a few words:

- I will not release or agree to release my code under either the GPL
or any kind of a "dual"-license.

- The ISC-style license must remain including the copyright notice and
even the warranty term.

- Thanks to the OpenBSD community and especially to Theo de Raadt for
entering into it and for defending my rights as the author of the
controversial code.

- This is eating our time. Every few weeks I get a new discussion
about licensing of the atheros driver etc. blah blah. Why can't they
just accept the license as it is and focus on more important things?

I will talk to different people to get the latest state and to think
about the next steps. I don't even know if the issue has been solved
in the linux tree. But PLEASE DON'T SPAM ME with any other mails about
this, even if you want to help/support me, I will talk to the relevant
people in private.

Thanks!
reyk

On Fri, Aug 31, 2007 at 07:40:52PM -0600, Theo de Raadt wrote:
> [bcc'd to Eben Moglen so that people don't flood him]
> 
> I stopped making public statements in the recent controversy because
> Eben Moglen started working behind the scenes to 'improve' what Linux
> people are doing wrong with licensing, and he asked me to give him
> pause, so his team could work.  Honestly, I was greatly troubled by
> the situation, because even people like Alan Cox were giving other
> Linux developers advice to ... break the law.  And furthermore, there
> are even greater potential risks for how the various communities
> interact.
> 
> For the record -- I was right and the Linux developers cannot change
> the licenses in any of those ways proposed in those diffs, or that
> conversation (http://lkml.org/lkml/2007/8/28/157).
> 
> It is illegal to modify a license unless you are the owner/author,
> because it is a legal document.  If there are multiple owners/authors,
> they must all agree.  A person who receives the file under two
> licenses can use the file in either way....  but if they distribute
> the file (modified or unmodified!), they must distribute it with the
> existing license intact, because the licenses we all use have
> statements which say that the license may not be removed.
> 
> It may seem that the licenses let one _distribute_ it under either
> license, but this interpretation of the license is false -- it is
> still illegal to break up, cut up, or modify someone else's legal
> document, and, it cannot be replaced by another license because it may
> not be removed.  Hence, a dual licensed file always remains dual
> licensed, every time it is distributed.
> 
> Now I've been nice enough to give Eben and his team a few days time to
> communicate inside the Linux community, to convince them that what
> they have proposed/discussed is wrong at a legal level.  I think that
> Eben also agrees with me that there are grave concerns about how this
> leads to problems at the ethical and community levels (at some level,
> a ethos is needed for Linux developers to work with *BSD developers).
> And there are possibilities that similar issues could loom in the
> larger open source communities who are writing applications.
> 
> Eben has thus far chosen not to make a public statement, but since
> time is running out on people's memory, I am making one.  Also, I feel
> that a lot of Linux "relicencing" meme-talkin' trolls basically have
> attacked me very unfairly again, so I am not going to wait for Eben to
> say something public about this.
> 
> In http://lkml.org/lkml/2007/8/29/183, Alan Cox managed to summarize
> what Jiri Slaby and Luis Rodriguez were trying to do by proposing a
> modification of a Dual Licenced file without the consent of all the
> authors.  Alan asks "So whats the problem ?".  Well, Alan, I must
> caution you -- your post is advising people to break the law.
> 
> I will attempt to describe in simple terms, based on what I have been
> taught, how one must handle such licenses:
> 
> - If you receive dual licensed code, you may not delete the license
>   you don't like and then distribute it.  It has to stay, because you
>   may not edit someone's else's license -- which is a three-part legal
>   document (For instance: Copyright notice, BSD, followed by GPL).
> 
> - If you receive ISC or BSD licensed code, you may not delete the
>   license.  Same principle, since the notice says so.  It's the law.
>   Really.
> 
> - If you add "large pieces of originality" to the code which are valid
>   for copyright protection on their own, you may choose to put a different
>   and seperate (must be non-conflicting...) license at the top of the file
>   above the existing license.
> 
>     (Warning: things become less clear as to what the combination of
>     licenses mean, though -- there are ethical traps, too).
> 
> - If you wish for everyone to remain friends, you should give code back.
> 
>   That means (at some ethical or friendliness level) you probably do
>   not want to put a GPL at the top of a BSD or ISC file, because you
>   would be telling the people who wrote the BSD or ISC file:
> 
>      "Thanks for what you wrote, but this is a one-way street, you give
>      us code, and we take it, we give you you nothing back.  screw off."
> 
> In either case, I think a valuable lessons has been taught us here in
> the BSD world -- there are many many GPL loving people who are going
> to try to find any way to not give back and share (I will mention one
> name: Luis Rodriguez has been a fanatic pushing us for dual licensed,
> and I feel he is to blame for this particular problem).  Many of those
> same people have been saying for years that BSD code can be stolen,
> and that is why people should GPL their code.
> 
> Well, the lesson they have really taught us is that they consider the
> GPL their best tool to take from us!
> 
> GPL fans said the great problem we would face is that companies would
> take our BSD code, modify it, and not give back.  Nope -- the great
> problem we face is that people would wrap the GPL around our code, and
> lock us out in the same way that these supposed companies would lock
> us out.  Just like the Linux community, we have many companies giving
> us code back, all the time.  But once the code is GPL'd, we cannot get
> it back.
> 
> Ironic.
> 
> I hope some people in the GPL community will give that some thought.
> Your license may benefit you, but you could lose friends you need.
> The GPL users have an opportunity to 'develop community', to keep an
> ethic of sharing alive.
> 
> If the Linux developers wrap GPL's around things we worked very hard
> on, it will definately not be viewed as community development.
> 
> Thank you for thinking about this.
> 
> [I ask that one person make sure that one copy of this ends up on the
> linux kernel mailing list]

----- End forwarded message -----
