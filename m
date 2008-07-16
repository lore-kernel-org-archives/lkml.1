Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYGPAJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYGPAJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGPAJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:09:46 -0400
Received: from r00tworld.com ([212.85.137.21]:59138 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYGPAJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:09:45 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jul 2008 02:04:25 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D5729.14854.1CA5C3EB@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D3C17.31467.1C3C0441@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 02:05:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 16:28, Linus Torvalds wrote:

> On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
> >
> > you should check out the last few -stable releases then and see how
> > the announcement doesn't ever mention the word 'security' while fixing
> > security bugs
> 
> Umm. What part of "they are just normal bugs" did you have issues with?

oh, we're back to that. i told you that already, here it is again (just
quoting myself back):

  when you fix a bug, the commit describes what it fixes without omitting
  anything relevant. when you fix a security bug, its commit doesn't say
  what it fixes (not even that it's a security fix, never mind actual
  impact information), that is, you omit relevant information (based on
  some ill-conceived argument that i deconstructed at the beginning). in
  other words, you're *not* treating security bugs as normal bugs. for
  all intents and purposes, you cover them up. i *wish* you did treat
  them as normal bugs however.

we went through this and you yourself said that security bugs are *not*
treated as normal bugs because you do omit relevant information from such
commits whereas you do *not* omit relevant information from normal commits.
for security bugs the fact that they fix a security issue is relevant
information.

> I expressly told you that security bugs should not be marked as such, 
> because bugs are bugs. 

repeating the same thing doesn't make the self-contradiction above go
away. bugs are properly described in the commits, security bugs aren't
(you said so yourself), therefore they can't be of the same category.

what you're still trying to justify is why you are covering up security
bugs, plain and simple.

> > > I'm just saying that why mark things, when the marking have no meaning? 
> > > People who believe in them are just _wrong_.
> > 
> > what is wrong in particular?
> 
> You have two cases:
> 
>  - people think the marking is somehow trustworthy.
> 
>    People are WRONG, and are misled by the partial markings, thinking that 
>    unmarked bugfixes are "less important". They aren't.

why would people think that unmarked bugfixes are less important? who are
you to make that judgement for them anyway? the importance of bugs is
*orthogonal* to their classification (security, etc). it's up to the people
and their decision making processes to deal with that. all you should do
is help them by not withholding relevant information. in case it wasn't
clear, i'm not talking about just about any person like my grandma, but
people whose work involves following kernel development, who can use all
the extra information to make judgement calls about what to prioritize.
they're certainly not dumb and would not think that only commits marked
as such are security related.

>  - People don't think it matters
> 
>    People are right, and the marking is pointless.

you have yet to prove why it's pointless. the above attempt failed to do so.

> In either case it's just stupid to mark them. I don't want to do it, 
> because I don't want to perpetuate the myth of "security fixes" as a 
> separate thing from "plain regular bug fixes".

it's not a myth, it's called reality. a bugfix that gets my pc speaker beep
again is very different from a fix that stops the tcp/ip stack sending out
random kernel memory to the net (just made them up, before anyone starts
looking). you're desperately trying to ignore the importance of security
bugs but you're failing. the world has decided that security bugs *are*
important and deserve special attention. and it's not as if you had to do
any extra work, you already have the information, you should just not
*withhold* it.

> They're all fixes. They're all important. As are new features, for that 
> matter.

'importance' is not a big grey goo that applies equally to all fixes. you
want to make it appear so, but that doesn't make it so.

> > when you know that you're about to commit a patch that fixes a security 
> > bug, why is it wrong to say so in the commit?
> 
> It's pointless and wrong because it makes people think that other bugs 
> aren't potential security fixes.

why does it make people think that? did you ask them? what if you told them
as i suggested (and you conveniently skipped) what to expect? do you think
people dealing with kernel maintenance at companies, distros, etc are that
dumb?

cheers,
  PaX Team

