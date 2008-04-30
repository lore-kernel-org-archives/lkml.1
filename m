Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbYD3U6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbYD3U6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933289AbYD3U6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:58:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933355AbYD3U6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:58:30 -0400
Date: Wed, 30 Apr 2008 13:54:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430135405.ddc42075.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 13:31:08 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
> > 
> > <jumps up and down>
> > 
> > There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> 
> The problem I see with both -mm and linux-next is that they tend to be 
> better at finding the "physical conflict" kind of issues (ie the merge 
> itself fails) than the "code looks ok but doesn't actually work" kind of 
> issue.
> 
> Why?
> 
> The tester base is simply too small.
> 
> Now, if *that* could be improved, that would be wonderful, but I'm not 
> seeing it as very likely.
> 
> I think we have fairly good penetration these days with the regular -git 
> tree, but I think that one is quite frankly a *lot* less scary than -mm or 
> -next are, and there it has been an absolutely huge boon to get the kernel 
> into the Fedora test-builds etc (and I _think_ Ubuntu and SuSE also 
> started something like that).
> 
> So I'm very pessimistic about getting a lot of test coverage before -rc1.
> 
> Maybe too pessimistic, who knows?
> 

Well.  We'll see.

linux-next is more than another-tree-to-test.  It is (or will be) a change
in our processes and culture.  For a start, subsystem maintainers can no
longer whack away at their own tree as if the rest of use don't exist. 
They now have to be more mindful of merge issues.

Secondly, linux-next is more accessible than -mm: more releases, more
stable, better tested by he-who-releases it, available via git:// etc.  It
should be very easy for developers to do their weekly "does linux-next
boot" test.

Plus, of course, people who complain about merge-window breakage only to
find that the breakage was already in linux-next except they didn't test it
will not have a leg to stand on.


I feared that linux-next wouldn't work: that Stephen would stomp off in
disgust at all the crap people send at him.  But in fact it seems to be
going very well from that POV.

I get the impression that we're seeing very little non-Stephen testing of
linux-next at this stage.  I hope we can ramp that up a bit, initially by
having core developers doing at least some basic sanity testing.



linux-next does little to address our two largest (IMO) problems:
inadequate review and inadequate response to bug and regression reports. 
But those problems are harder to fix..

