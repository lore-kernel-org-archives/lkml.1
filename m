Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbYGOTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbYGOTGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761824AbYGOTFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:05:24 -0400
Received: from r00tworld.com ([212.85.137.21]:47787 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761476AbYGOTFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:05:23 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jul 2008 21:03:47 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D10B3.5586.1B9284FF@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807150904290.3017@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>, <alpine.LFD.1.10.0807150904290.3017@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 15 Jul 2008 21:04:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 9:07, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> > 
> > by 'cover up' i meant that even when you know better, you quite
> > consciously do *not* report the security impact of said bugs
> 
> Yes. Because the only place I consider appropriate is the kernel 
> changelogs, and since those get published with the sources, there is no 
> way I can convince myself that it's a good idea to say "Hey script 
> kiddies, try this" unless it's already very public indeed.

if you worry about script kiddies (btw, for someone not bothering with
the whole security circus you surely do use their terms as bogeymen
to rationalize your stand) triggering or even exploiting local kernel
bugs then you imply that they're already local users on that box and
that in turn means they have already been having fun all that time.
just remember how Andrew put it:

  But there are so many ways to cripple a Linux box once you have
  local access. (http://lkml.org/lkml/2005/1/12/379)

in other words, try a better argument, possibly without bogeymen.

next, what about, say, sysadmins	, bigger and smaller distro maintainers,
etc trying to figure out whether they need to backport a given fix or
not? do you think you're helping them too?

on a sidenote, what do you know about script kiddies? how do you think
they operate? do you think they're watching a real-time rss from kernel.org
to catch the latest and greatest security fixes? do you think they can
write PoC or actual exploit code based on commits?

last but not least, if i submitted a security fix with the commit message
actually saying that it fixes a security problem, would you remove that
information before committing? based on the above that sounds as a 'yes',
but i'd like to have that explicitly on the record.

> > see my comment about reality above. heck, even linux vendors do track
> > and announce them, it's part of the support they provide to paying
> > customers (and even non-paying users).
> 
> Umm. And they mostly do a crap job at it, only focusing on a small 
> percentage (the ones that were considered to be "big issues"), and because 
> they do the reporting they also feel they have to have embargoes in place.

people consider and backport patches that come to their attention,
which in turn happens by their scanning the changes, following various
threads of discussions (both public and private, depending on what they
have access to), etc. if you withhold security impact information then
you're skewing their 'big issue' detector as well, further reducing
*their* users' security.

> That's why I don't do reporting - it almost inevitably leads to embargoes.

i don't see you embargo normal bug fixes, why would you embargo security
bug fixes? they're just normal bugs, aren't they?

> So as far as I'm concerned, "disclosing" is the fixing of the bug. It's 
> the "look at the source" approach.

when you fix a bug, the commit describes what it fixes without omitting
anything relevant. when you fix a security bug, its commit doesn't say
what it fixes (not even that it's a security fix, never mind actual
impact information), that is, you omit relevant information (based on
some ill-conceived argument that i deconstructed at the beginning). in
other words, you're *not* treating security bugs as normal bugs. for
all intents and purposes, you cover them up. i *wish* you did treat
them as normal bugs however.

cheers,
  Pax Team

