Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbYEASvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbYEASvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYEASux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:50:53 -0400
Received: from 1wt.eu ([62.212.114.60]:3682 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYEASux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:50:53 -0400
Date: Thu, 1 May 2008 20:50:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501185032.GA30883@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 10:41:21AM -0700, Linus Torvalds wrote:
> Same goes for "we should all just spend time looking at each others 
> patches and trying to find bugs in them". That's not a solution, that's a 
> drug-induced dream you're living in.

"all" above is the wrong part. Encourage each other into reviewing code
will definitely *help* (and I did not say fix the problem, OK?). There
are persons who regularly spend some time to review code. I'm thinking
about Al, Andrew, Christoph, Arjan, and maybe many other ones I'm missing,
just that I regularly see them give advices to people who post their patches
on the list. And even if only for that, they deserve some respect, and their
efforts must not be dismissed.

Maybe they are more skilled than anyone else for this job. Maybe they're
so much used to do it that it just takes them a few minutes each time, I
don't know. I wish *more* people could be encouraged to do this work,
which is very likely painful but instructive. If the current reviewers
could give hints on how to save a lot of time to them, it may motivate
more to follow them. I suspect that insisting on developers to post their
less obvious work to the list(s) is a first step. Maybe at one point we're
all responsible when we see a mail entitled "[GIT] pull request for XXX",
we should all jump on it and ask "when and where was this code reviewed ?".

Once again, it's not a fix. It's just one small step towards a saner process.

> So do you have any productive *suggestions*? Some that involve more than 
> "let's write less code" or "let's just review each others patches more".

It's not much about reviewing each others' patches, it's about showing
one's work to others first. If our developers are encouraged to work
alone in a cave late at night with itching eyes, and send their work
at once every 2 months in a sealed envelope, we'll not solve anything.

I also proposed a more repressive method incitating the ones with really
bad scores to find crap in other's work in order to remain hidden behind
them. You explained why it would not work. Fine.

I also proposed to group merges by reduced overlapping areas, and to
shorten the merge window and make it (at least) twice as often. Rafael
also proposed to merge core first, then archs, which is a refined variation
on the same principle. I'm not sure I've seen your opinion on this.

Willy

