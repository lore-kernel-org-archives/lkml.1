Return-Path: <linux-kernel-owner+w=401wt.eu-S1763392AbYGOUbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763392AbYGOUbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYGOUaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:30:35 -0400
Received: from r00tworld.com ([212.85.137.21]:56274 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762987AbYGOUae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:30:34 -0400
From: pageexec@freemail.hu
To: Theodore Tso <tytso@mit.edu>
Date: Tue, 15 Jul 2008 22:28:44 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Message-ID: <487D249C.19043.1BE04D4D@pageexec.freemail.hu>
In-reply-to: <20080715183351.GF8185@mit.edu>
References: <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>, <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>, <20080715183351.GF8185@mit.edu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 15 Jul 2008 22:29:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On 15 Jul 2008 at 14:33, Theodore Tso wrote:

> On Tue, Jul 15, 2008 at 05:31:09PM +0200, pageexec@freemail.hu wrote:
> > obviously there *is* a policy, it's just not what you guys declared
> > earlier in Documentation/SecurityBugs. would you care to update it
> > or, more properly, remove it altogether as it currently says:
> 
> Hi, so I'm guessing you're new to the Linux kernel.

not that new, just not a subscriber, but i've been following it on and
off for many years now. just a few comments below:

>  What you are
> missing is while *Linus* is unwilling to play the disclosure game,
> there are kernel developers (many of whom work for distributions, and
> who *do* want some extra time to prepare a package for release to
> their customers) who do.  So what Linus has expressed is his personal
> opinion, and he is simply is not on any of the various mailing lists
> that receive limited-disclosure information, such as the general
> vendor-sec@lst.de mailing list, or the security@kernel.org list
> mentioned in Documentation/SecurityBugs.

he's on security@kernel.org i think.

> Both vendor-sec and security@kernel.org are not formal organizations,
> so they can not sign NDAs, but they will honor non disclosure
> requests, and the subscription list for both lists is carefully
> controlled.
> 
> People like Linus who have a strong, principled stand for Full
> Disclosure simply choose not to request to be placed on those mailing
> lists.

Linus has just explained that he does *not* have any stand on full
disclosure in fact, he prefers no disclosure.

>  And if Linus finds out about a security bug, he will fix it
> and check it into the public git repository right away.

yes, he does that. what he doesn't do is mention the fact that he's
just fixed a security bug.

> The arguments about whether or not Full Disclosure is a good idea or
> not, and whether or not the "black hat" and "grey hat" and "white hat"
> security research firms are unalloyed forces for good, or whether they
> have downsides (and some might say very serious downsides) have been
> arguments that I have personally witnessed for over two decades
> (Speaking as someone who helped to dissect the Robert T. Morris
> Internet Worm in 1988, led the Kerberos development team at MIT for
> many years, and chaired the IP SEC Working Group for the IETF, I have
> more than my fair share of experience).  It is clear that we're not
> going settle this debate now, and certainly not on the Linux Kernel
> Mailing List.

Ted, the discussion is *not* about what the best disclosure policy
would be for the kernel. the problem i raised was that there's one
declared policy in Documentation/SecurityBugs (full disclosure) yet
actual actions are completely different and now Linus even admitted
it. the problem arising from such inconsistency is that people relying
on the declared disclosure policy will make bad decisions and potentially
endanger their users. there're two ways out of this sitution: either
follow full disclosure in practice or let the world at large know
that you (well, Linus) don't want to. in either case people will adjust
their security bug handling processes and everyone will be better off.

cheers,
  PaX Team

