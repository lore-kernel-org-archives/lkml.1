Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbXEYTPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbXEYTPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXEYTO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:14:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbXEYTOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:14:55 -0400
Date: Fri, 25 May 2007 21:14:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525191447.GA19412@elte.hu>
References: <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu> <20070525115544.GP8094@one.firstfloor.org> <20070525120228.GA7186@elte.hu> <alpine.LFD.0.98.0705250946120.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705250946120.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ingo: to make things easier, the _best_ split-up would be not "this is 
> the historical series of patches leading up to CFS v15" or something 
> like that, but it would be nice to get that final CFS version as a 
> series of patches that do some specific things rather than as one 
> final one. Is there any possibility that could happen?

sure enough, i'll work something sane out - i already have it partly 
split up. It will probably be something along the lines of: 'remove 
stuff that we can remove and still have functional scheduling' followed 
by an 'add minimal CFS patch' and then nicely split up 'CFS related 
add-ons' (like the task-stats accounting things, debugging, etc). Do you 
think i should try to split up the core CFS bits some more beyond this 
level? (that would be quite nontrivial i suspect)

	Ingo
