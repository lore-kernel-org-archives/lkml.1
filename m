Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbZLRViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbZLRViK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932735AbZLRViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:38:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932764AbZLRViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:38:05 -0500
Date: Fri, 18 Dec 2009 13:38:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sage Weil <sage@newdream.net>, Gregory Haskins <gregory.haskins@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
In-Reply-To: <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
Message-ID: <alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net> <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Sage Weil wrote:
> 
> I would still like to see ceph merged for 2.6.33.  It's certainly not 
> production ready, but it would be greatly beneficial to be in mainline for 
> the same reasons other file systems like btrfs and exofs were merged 
> early.

So what happened to ceph is the same thing that happened to the alacrityvm 
pull request (Greg Haskins added to cc): I pretty much continually had a 
_lot_ of pull requests, and all the time the priority for the ceph and 
alactrityvm pull requests were just low enough on my priority list that I 
never felt I had the reason to look into the background enough to make an 
even half-assed decision of whether to pull or not.

And no, "just pull" is not my default answer - if I don't have a reason, 
the default action is "don't pull".

I used to say that "my job is to say 'no'", although I've been so good at 
farming out submaintainers that most of the time my real job is to pull 
from submaintainers who hopefully know how to say 'no'. But when it comes 
to whole new driver features, I'm still "no by default - tell me _why_ I 
should pull".

So what is a new subsystem person to do?

The best thing to do is to try to have users that are vocal about the 
feature, and talk about how great it is. Some advocates for it, in other 
words. Just a few other people saying "hey, I use this, it's great", is 
actually a big deal to me. For alacrityvm and cephfs, I didn't have that, 
or they just weren't loud enough for me to hear.

So since you mentioned btrfs as an "early merge", I'll mention it too, as 
a great example of how something got merged early because it had easily 
gotten past my "people are asking for it" filter, to the point where _I_ 
was interested in trying it out personally, and asking Chris&co to tell me 
when it was ready.

Ok, so that was somewhat unusual - I'm not suggesting you'd need to try to 
drum up quite _that_ much hype - but it kind of illustrates the opposite 
extreme of your issue. Get some PR going, get people talking about it, get 
people testing it out. Get people outside of your area saying "hey, I use 
it, and I hate having to merge it every release".

Then, when I see a pull request during the merge window, the pull suddenly 
has a much higher priority, and I go "Ok, I know people are using this".

So no astro-turfing, but real grass-roots support really does help (or 
top-down feedback for that matter - if a _distribution_ says "we're going 
to merge this in our distro regardless", that also counts as a big hint 
for me that people actually expect to use it and would like to not go 
through the pain of merging).

			Linus
