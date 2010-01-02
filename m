Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657Ab0ABULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0ABULb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 15:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298Ab0ABULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 15:11:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0ABUL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 15:11:29 -0500
Date: Sat, 2 Jan 2010 21:11:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102201117.GA6971@elte.hu>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
 <87bphc7heo.fsf@basil.nowhere.org>
 <20100102163644.GA5076@nowhere>
 <20100102174311.GA30016@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102174311.GA30016@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.2
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.2 required=5.9 tests=BAYES_00,FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.2 FH_DATE_PAST_20XX      The date is grossly in the future.
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > I only have reiserfs partitions in my laptop and my testbox, nothing else. 
> > And that because I'm now maintaining it de facto.
> 
> AFAIK it's widely used in SUSE installations. It was the default for a long 
> time.

[ Btw., if so then SuSE/Novell should sponsor Frederic's reiserfs maintanence 
  work. ]

> And right now as in 2.6.32 it's in a state of "may randomly 
> explode/deadlock". And no clear path out of it. Not good.

You are quite wrong about that accusation: Frederic's changes are not in 
v2.6.32 - they were merged by Linus in the v2.6.33 cycle so that code cannot 
physicaly have caused any problems in v2.6.32 ...

If there's stability problems with reiserfs in v2.6.32 then it's doubly good 
that Linus merged Frederic's tree in v2.6.33 [beyond the obvious advantage 
that it gets rid of the BKL, which was a serious and oft reported limit to 
reiserfs scalability]: finally there's again reiserfs development activity, 
which might lead to further fixes, and which might solve the v2.6.32 stability 
problems you mention.

In my view this work could have been merged sooner, in v2.6.32 already, maybe 
that way the v2.6.32 reiserfs stability problems you mentioned could have been 
avoided.

Thanks,

	Ingo
