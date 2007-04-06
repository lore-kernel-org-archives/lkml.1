Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbXDFTUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbXDFTUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXDFTUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:20:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53488 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXDFTUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:20:11 -0400
Date: Fri, 6 Apr 2007 21:19:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406191945.GA18255@elte.hu>
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com> <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
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


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > > Ohhh, the "signal" struct! Funny name for something that nowadays 
> > > has probably no more than a 5% affinity with signal-related tasks 
> > > :/
> > 
> > Hmm.  I wonder if we should just rename it the struct thread_group, 
> > or struct task_group.  Those seem slightly more accurate names.
> 
> Almost *anything* is better than "signal_struct" ;) A task_group could 
> be fine, so something on the line of task_shared_ctx.

or lets just face it and name it what it is: process_struct ;-)

	Ingo
