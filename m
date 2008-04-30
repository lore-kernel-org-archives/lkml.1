Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbYD3WKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbYD3WKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbYD3WKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:10:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757272AbYD3WK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:10:29 -0400
Date: Wed, 30 Apr 2008 15:10:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430151007.0ace4fa2.akpm@linux-foundation.org>
In-Reply-To: <4818E7E3.7080705@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080430135405.ddc42075.akpm@linux-foundation.org>
	<4818E7E3.7080705@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 01:42:59 +0400
Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Andrew Morton __________:
> > On Wed, 30 Apr 2008 13:31:08 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >>
> >> On Wed, 30 Apr 2008, Andrew Morton wrote:
> >>> <jumps up and down>
> >>>
> >>> There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> >> The problem I see with both -mm and linux-next is that they tend to be 
> >> better at finding the "physical conflict" kind of issues (ie the merge 
> >> itself fails) than the "code looks ok but doesn't actually work" kind of 
> >> issue.
> >>
> >> Why?
> >>
> >> The tester base is simply too small.
> >>
> >> Now, if *that* could be improved, that would be wonderful, but I'm not 
> >> seeing it as very likely.
> >>
> >> I think we have fairly good penetration these days with the regular -git 
> >> tree, but I think that one is quite frankly a *lot* less scary than -mm or 
> >> -next are, and there it has been an absolutely huge boon to get the kernel 
> >> into the Fedora test-builds etc (and I _think_ Ubuntu and SuSE also 
> >> started something like that).
> >>
> >> So I'm very pessimistic about getting a lot of test coverage before -rc1.
> >>
> >> Maybe too pessimistic, who knows?
> >>
> > 
> > Well.  We'll see.
> > 
> > linux-next is more than another-tree-to-test.  It is (or will be) a change
> > in our processes and culture.  For a start, subsystem maintainers can no
> > longer whack away at their own tree as if the rest of use don't exist. 
> > They now have to be more mindful of merge issues.
> > 
> > Secondly, linux-next is more accessible than -mm: more releases, more
> > stable, better tested by he-who-releases it, available via git:// etc.
> 
> Andrew, the latter thing is a very good point. For me personally, the fact
> that -mm is not available via git is the major obstacle for trying your
> tree more frequently than just a few times per year.

Every -mm release if available via git://, as described in the release
announcements.

The scripts which do this are a bit cantankerous but I believe they do
work.

<tests it>

yup, 2.6.25-mm1 is there.

> How difficult it
> would be to switch to git for you?

Fatal, I expect.  A tool which manages source-code files is just the wrong
paradigm.  I manage _changes_ against someone else's source files.

> I guess there are good reasons for still
> using the source code management system from the last century; please
> correct me if I'm wrong, but I believe that using a modern SCM system could
> make life easier for you and your testers, no?
> 
> > 
> > I get the impression that we're seeing very little non-Stephen testing of
> > linux-next at this stage.  I hope we can ramp that up a bit, initially by
> > having core developers doing at least some basic sanity testing.
> > 
> 
> For busy (or lazy) people like myself, the big problem with linux-next are
> the frequent merge breakages, when pulling the tree stops with "you are in
> the middle of a merge conflict".

Really?  Doesn't Stephen handle all those problems?  It should be a clean
fetch each time?


> Perhaps, there is a better way to resolve
> this without just removing the whole repo and cloning it once again - this
> is what I'm doing, please flame me for stupidity or ignorance if I simply
> am not aware of some git feature that could be useful in such cases.
> 
> Finally, while the list is at it, I'd like to make another technical comment.
> My development zoo is a pretty fast 4-way Xeon server, where I keep a handful
> of trees, a few cross-toolchains, Qemu, etc. The network setup in our
> organization is such that I can use git only over http from that server.

Don't know what to do about that, sorry.  An off-site git->http proxy might
work, but I doubt if anyone has written the code.

