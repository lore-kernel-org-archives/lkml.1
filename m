Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbYEAADi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbYEAADi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbYEAAAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:00:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761582AbYEAAAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:00:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 01:59:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080430135405.ddc42075.akpm@linux-foundation.org> <200805010039.02451.rjw@sisk.pl> <20080430231221.GP8474@1wt.eu>
In-Reply-To: <20080430231221.GP8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010159.51492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Willy Tarreau wrote:
> On Thu, May 01, 2008 at 12:39:01AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 1 of May 2008, David Miller wrote:
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Date: Thu, 1 May 2008 00:19:36 +0200
> > > 
> > > > The same goes in the other direction as well - you were just hit by 
> > > > scheduler tree related regressions that were only triggered on your 
> > > > 128-way sparc64, but not on our 64way x86 and smaller boxes.
> > > 
> > > You keep saying this over and over again, but the powerpc folks hit
> > > this stuff too.
> > 
> > Well, I think that some changes need some wider testing anyway.
> > 
> > They may be correct from the author's point of view and even from the knowledge
> > and point of view of the maintainer who takes them into his tree.  That's
> > because no one knows everything and it'll always be like this.
> > 
> > Still, with the current process such "suspicious" changes go in as parts of
> > large series of commits and need to be "rediscovered" by the affected testers
> > with the help of bisection.  Moreover, many changes of this kind may go in from
> > many different sources at the same time and that's really problematic.
> 
> That's very true IMHO and is the thing which has been progressively
> appearing since we merge large amounts of code at once. In the "good
> old days", something did not work, the first one to discover it could
> quickly report it on LKML : "hey, my 128-way sparc64 does not boot
> anymore, anybody has any clue", and another one immediately found
> this mail (better signal/noise ratio on LKML at this time) and say
> "oops, I suspect that change, try to revert it".
> 
> Now, it's close to impossible. Maintainers frequently ask for bisection,
> in part because nobody knows what code is merged, and they have to pull
> Linus' tree to know when their changes have been pulled. That may be
> part of the "fun" aspect that Davem is seeing going away in exchange
> for more administrative relations. But if we agree that nobody knows
> all the changes, we must agree that we need tools to track them, and
> tools are fundamentally incompatible with smart human relations.
> 
> > In fact, so many changes go in at a time during a merge window, that we often
> > can't really say which of them causes the breakage observed by testers and
> > bisection, that IMO should really be a last-resort tool, is used on the main
> > debugging techinque.
> 
> Maybe we could slightly improve the process by releasing more often, but
> based on topics. Small sets of minimally-overlapping topics would get
> merged in each release, and other topics would only be allowed to pull
> fixes. That way everybody still gets some work merged, everybody tests
> and problems are more easily spotted.

I like this idea.

> I know this is in part what Andrew tries to do when proposing to
> integrate trees, but maybe some approximate rules should be proposed
> in order for developers to organize their works. This would begin
> with announcing topics to be considered for next branch very early.
> This would also make it more natural for developers to have creation
> and bug-tracking phases.

Yes, that's reasonable.

Thanks,
Rafael
