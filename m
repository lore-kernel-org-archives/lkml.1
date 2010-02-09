Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0BIUnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:43:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab0BIUnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:43:39 -0500
Date: Tue, 9 Feb 2010 15:43:34 -0500
From: Josef Bacik <josef@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sage Weil <sage@newdream.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, jdarcy@redhat.com, rwheeler@redhat.com
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
Message-ID: <20100209204333.GB10045@localhost.localdomain>
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net> <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net> <alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 01:38:00PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 18 Dec 2009, Sage Weil wrote:
> > 
> > I would still like to see ceph merged for 2.6.33.  It's certainly not 
> > production ready, but it would be greatly beneficial to be in mainline for 
> > the same reasons other file systems like btrfs and exofs were merged 
> > early.
> 
> So what happened to ceph is the same thing that happened to the alacrityvm 
> pull request (Greg Haskins added to cc): I pretty much continually had a 
> _lot_ of pull requests, and all the time the priority for the ceph and 
> alactrityvm pull requests were just low enough on my priority list that I 
> never felt I had the reason to look into the background enough to make an 
> even half-assed decision of whether to pull or not.
> 
> And no, "just pull" is not my default answer - if I don't have a reason, 
> the default action is "don't pull".
> 
> I used to say that "my job is to say 'no'", although I've been so good at 
> farming out submaintainers that most of the time my real job is to pull 
> from submaintainers who hopefully know how to say 'no'. But when it comes 
> to whole new driver features, I'm still "no by default - tell me _why_ I 
> should pull".
> 
> So what is a new subsystem person to do?
> 
> The best thing to do is to try to have users that are vocal about the 
> feature, and talk about how great it is. Some advocates for it, in other 
> words. Just a few other people saying "hey, I use this, it's great", is 
> actually a big deal to me. For alacrityvm and cephfs, I didn't have that, 
> or they just weren't loud enough for me to hear.
> 
> So since you mentioned btrfs as an "early merge", I'll mention it too, as 
> a great example of how something got merged early because it had easily 
> gotten past my "people are asking for it" filter, to the point where _I_ 
> was interested in trying it out personally, and asking Chris&co to tell me 
> when it was ready.
> 
> Ok, so that was somewhat unusual - I'm not suggesting you'd need to try to 
> drum up quite _that_ much hype - but it kind of illustrates the opposite 
> extreme of your issue. Get some PR going, get people talking about it, get 
> people testing it out. Get people outside of your area saying "hey, I use 
> it, and I hate having to merge it every release".
> 
> Then, when I see a pull request during the merge window, the pull suddenly 
> has a much higher priority, and I go "Ok, I know people are using this".
> 
> So no astro-turfing, but real grass-roots support really does help (or 
> top-down feedback for that matter - if a _distribution_ says "we're going 
> to merge this in our distro regardless", that also counts as a big hint 
> for me that people actually expect to use it and would like to not go 
> through the pain of merging).
> 

We have had bugzilla's opened with us (Red Hat) requesting that CEPH be included
in Fedora/RHEL, so I'm here to yell loudly that somebody wants it :).

The problem for these particular users is that sucking down a git tree and
applying patches and building a kernel is a very high entry cost to test
something they are very excited about, so they depend on distributions to ship
the new fun stuff for them to start testing.  The problem is the distributions
do not want to ship new fun stuff thats not upstream if at all possible
(especially when it comes to filesystems).  I personally have no issues with
just sucking a bunch of patches into the Fedora kernel so people can start
testing it, but I think that sends the wrong message, since we're supposed to be
following upstream and encouraging people to push their code upstream first.
Not to mention that it makes the actual Fedora kernel team antsy, and I already
bug them enough with what I pull in for btrfs :).

So for the time being I'm just going to pull the userspace stuff into Fedora.
If you still feel that there is not enough users to justify pulling CEPH in I
will probably pull the patches into the rawhide Fedora kernel when F13 branches
off and hopefully that will pull even more users in.  Thanks,

Josef
