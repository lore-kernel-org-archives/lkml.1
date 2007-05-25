Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXEYMCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXEYMCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXEYMCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:02:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbXEYMCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:02:36 -0400
Date: Fri, 25 May 2007 14:02:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525120228.GA7186@elte.hu>
References: <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu> <20070525115544.GP8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525115544.GP8094@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > find below the cleanups from my first patch that didnt make it into 
> > your cleanups. (plus one more cleanup i noticed while merging the 
> > missing bits from my first patch) Goes after the bugfix i just sent. 
> > Please apply.
> 
> I cannot apply it as is because it changes code from the paravirtops 
> patch too.

ok - then please merge that single hunk into the paravirtops patch - and 
leave the other 6 hunks in this patch.

> BTW to nitpick the original formattings you changed are all probably 
> standard code style and the new comment is a classical i++; /* 
> Increase i */

could you please quote the portion from my patch that you are talking 
about?

	Ingo
