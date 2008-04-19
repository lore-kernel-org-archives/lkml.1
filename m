Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYDSLJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYDSLJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYDSLJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:09:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53263
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbYDSLJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:09:44 -0400
Date: Sat, 19 Apr 2008 04:09:45 -0700 (PDT)
Message-Id: <20080419.040945.13369499.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
 latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080419103942.GA13599@elte.hu>
References: <20080419100034.GA9475@elte.hu>
	<20080419.030337.244502148.davem@davemloft.net>
	<20080419103942.GA13599@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 19 Apr 2008 12:39:42 +0200

I knew you were going to make a stink about this, and frankly Ingo I'm
starting to get extremely irritated about your persistant nagging
about how people should do this or that wrt. kernel development.

I seem to see a lot of it because 1) I don't think pushing everything
to lkml is the answer to everything and 2) I think the trees like -mm
and linux-next take care of the scalability issues of watching the
state of trees that will be merged to Linus in the future.

You haven't cared about how I push my trees to Linus for years, why is
it a problem all of a sudden?

Different people operate differently, and might have alternate
approaches to insuring quality and smooth merging of the changes they
manage.  The only thing that really matters is that the people who
push directly to Linus are trusted by him, and they won't disappear
right after he pulls their changes in.

You got a bug fix in 5 minutes after sending your email to the lists,
and since you sent it to lkml anybody can find it, so I don't see what
the big deal is.

> do you find this practice of private pull requests important? If not, 
> would it be difficult to Cc: lkml to routine pull requests?

Ingo, I don't tell you how to effectively do your job with x86
development.  So why don't we leave it at that, ok?

> > I always send my pull requests directly to Linus, CC:'ing Andrew.
> 
> that makes bugs harder to report and makes the flow of patches harder to 
> follow as well. Often (like in this case) i see it when a bug comes in 
> via a specific group of commits but i have no time to do a bisection. In 
> that case i'd like to report it to that pull request so i'd like to 
> reply to that pull on lkml.

Ingo, get off your high holy horse already.  It is your opinion that
bugs are harder to report.  You got a bug fix in 5 minutes by sending
it the people in the group of singoffs and CC:'ing lkml.  What the
heck more do you want? :-/

The way you see as the ideal isn't something you can just start
demanding of other people because it doesn't work optimally for you.

All of this networking stuff has been in linux-next and -mm for
several months.  And frankly it doesn't help anyone to spam ~5000 lkml
subscribers with a 128K sized merge request, which is how big this one
was.  In fact, as list owner for all of the vger lists, I'd probably
be processing a bunch of bounces as a result of such a posting.

If you want to start running your randconfig machinery on the
linux-next tree and -mm, that would be a great contribution for
keeping build regressions down to a healthy minimum before the merge
window opens up.

> As the number of subsystems increases, i suspect you agree with 
> me that this does not scale very well for bug reporters, correct?

That's why we have -mm and linux-next, to make it scale.

I'm not hiding anything, or operating in secrecy in an attempt to
thwart the productivity of other kernel developers.  My trees sync
daily into Andrew and Stephen Rothwell's trees, and every networking
patch goes through netdev.  Bugs aren't hard to report, send them
to the patch author and signoff emails, CC:'ing lkml and any other
list as you deem appropriate.

Ingo, I can't have a healthy relationship with you a fellow kernel
developer if every interaction we have with eachother these days is
about how you want me to change how I do my work.
