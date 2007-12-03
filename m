Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXLCOOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXLCOOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXLCOOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:14:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53608 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXLCOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:14:39 -0500
Date: Mon, 3 Dec 2007 15:14:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203141437.GA4719@one.firstfloor.org>
References: <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <84144f020712030550x1cb4dac7q8eeb111f7784590d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712030550x1cb4dac7q8eeb111f7784590d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's more like "lets warn about it and fix the problems when we find
> some." 

It is already known there are lots of problems. I won't repeat
them because I already wrote too much about them. Feel free
to read back in the thread.

Now if all the known problems are fixed and only some hard to know
hidden ones remain it might make sense to enable (but even then
a little dubious considering how important error handling robustness
is), but not at the current state (at least with the full default
backtraces) 

> Btw, how is this different from how the lockdep patches went
> in?

lockdep is clearly a "only enable if you're developing the kernel" 
feature (just alone because of its overhead and other problems).
So side effects etc. are expected.

Softlockup previously (before this patch) was a "can be always safely 
enabled" feature.  

Now Ingo's latest unreleased version with single
line messages might be actually ok if he turns off the backtraces
by default. Unfortunately I wasn't able to find out so far if he 
has done that or not, he always cuts away these parts of the emails.

-Andi

