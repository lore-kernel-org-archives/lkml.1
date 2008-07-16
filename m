Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYGPR1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYGPR1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYGPR06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:26:58 -0400
Received: from r00tworld.com ([212.85.137.21]:37103 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYGPR05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:26:57 -0400
From: pageexec@freemail.hu
To: Greg KH <greg@kroah.com>
Date: Wed, 16 Jul 2008 19:25:17 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Tiago Assumpcao <tiago@assumpcao.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487E4B1D.24359.205EB2E5@pageexec.freemail.hu>
In-reply-to: <20080716162949.GA7480@kroah.com>
References: <20080716144347.GB13253@kroah.com>, <487E3333.30028.20014B8F@pageexec.freemail.hu>, <20080716162949.GA7480@kroah.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 19:26:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 9:29, Greg KH wrote:

> On Wed, Jul 16, 2008 at 05:43:15PM +0200, pageexec@freemail.hu wrote:
> > exploiting local bugs has nothing to do with having untrusted users in
> > the age of client side exploits. due to your completely
> > mischaracterized description, individual home users may very well feel
> > that they do not need to upgrade, to the delight of the next malware
> > owning their browser. you can congratulate yourself Greg, you
> > successfully misled a whole class of users.
> 
> No, I do not believe this is true, for this bug, sorry.

what do you not believe in? that a task refcount leak can be exploited
for privilege elevation?

>  If you disagree, please feel free to post such an exploit.

i never post exploits. however spender did write at least a proof-of-concept
that triggers it and proves that it's potentially exploitable. writing a
weaponized version takes a whole lot more effort than it's worth for us
(though i bet others have been working on it ever since if they didn't
already write one when the bug got introduced).

>  Such a problem
> would be a browser issue, and totally out of scope for a kernel issue.

what i said was *not* specific to this bug at all, any local privilege
elevation bug can be used to, well, elevate privileges, regardless of
how one gets into a box. the browser example was just that, to highlight
that even single home user systems may very well be affected. sure, the
browser bug is not your problem, but the local privilege elevation due
to kernel bugs *is*. your wording was wrong, untrusted users are only
*one* potential kind of threat therefore if only such systems update,
many others will remain vulnerable.

> > > then they need to rely on a company
> > > to provide updates for them, and not be running their own kernels
> > > because they really have no clue about system management.
> > 
> > you conveniently failed to respond to the rest of my mail where i showed
> > that Chris Wright, heck, even yourself did announce security fixes as such
> > in the past. how do you explain that?
> 
> I am human and as such, word things differently at times.  Based on crap
> like this thread, and from discussions with Linus and others, trying to
> classify such things as "security fixes" all the time isn't useful or
> helpful.

why isn't it useful? i've been asking every one of you who said so and
have yet to receive a reasonable justification. remember, your own
employers do it 'all the time', it must be useful to someone.

and what's with this 'all the time'? if you guys fix security bugs all
the time, then yes, you are expected to announce them all the time. if
you think that reflects badly on the quality of the kernel code, then
maybe you should think over your development process that results in
security fixes 'all the time'.

> Again, I still feel my original wording was sufficent.  If you disagree,
> feel free to start releasing your own kernels with whatever wording you
> like.  If people find them useful, perhaps they will use them instead of
> the ones I do at times.

if you are not qualified to do this job then don't do it. noone forced
you to accept this task. look at Chris Wright, he has no problems with
disclosing the security issues and he actually publicly pledged to do
his best to do so (and i hope he won't revert his position now).

cheers,
  PaX Team

