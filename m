Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbXLCN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbXLCN6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXLCN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:58:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXLCN6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:58:04 -0500
Date: Mon, 3 Dec 2007 14:57:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203135741.GB4245@elte.hu>
References: <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <84144f020712030550x1cb4dac7q8eeb111f7784590d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712030550x1cb4dac7q8eeb111f7784590d@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi,
> 
> On Mon, Dec 03, 2007 at 12:59:00PM +0100, Ingo Molnar wrote:
> > > "audit thousands of callsites in 8 million lines of code first" is a
> > > nice euphemism for hiding from the blame forever. We had 10 years for it
> 
> On Dec 3, 2007 2:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Ok your approach is then to "let's warn about it and hope
> > it will go away"
> 
> It's more like "lets warn about it and fix the problems when we find 
> some." Btw, how is this different from how the lockdep patches went 
> in?

yeah, it's quite similar. (in fact this feature is expected to have a 
false positive rate lower than that of lockdep) The backtraces are 
essential as well, they help kernel developer find the bugs.

	Ingo
