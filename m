Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXLCNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXLCNAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLCNAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:00:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLCNAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:00:39 -0500
Date: Mon, 3 Dec 2007 14:00:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203130003.GA26372@elte.hu>
References: <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <20071203122833.GA20232@elte.hu> <20071203124144.GC2986@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203124144.GC2986@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > you are over-designing it way too much - a backtrace is obviously 
> > very helpful and it must be printed by default. There's enough 
> > configurability in it already so that you can turn it off if you 
> > want.
> 
> So it will hit everybody first before they can figure out how to get 
> rid of it? That was the part I was objecting too.

you are apparently arguing in a circle. This is a debug mechanism. It 
goes the normal upstream acceptance process. I have booted this patch a 
few hundred times on a number of boxes and got not a single false 
positive so far. While this is in no way an exhaustive test, only more 
testing (in -mm, etc.) will tell us more, one way or another. Your 
negative feedback about an impending catastrophy has been duly noted 
(which vision of yours has not been shared by anyone else in this thread 
so far), and is given its due weight. Can we now please move on to a 
more productive stage?

	Ingo
