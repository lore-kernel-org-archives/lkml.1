Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXE3Ntl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXE3Ntl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbXE3Nte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:49:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbXE3Ntd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:49:33 -0400
Date: Wed, 30 May 2007 15:49:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Walker <dwalker@mvista.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070530134907.GA27085@elte.hu>
References: <20070529125248.877196281@chello.nl> <20070529130107.112347096@chello.nl> <1180470525.32594.71.camel@imap.mvista.com> <20070530132431.GA23947@elte.hu> <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [...] We can argue that sched_clock is "good enough".  If someone 
> wants better accounting of locks on some other arch, they can simply 
> change sched_clock to be more precise.

exactly. Imprecise sched_clock() if there's a better fast clock source 
available is a bug in the architecture code. If the only available 
clocksource is 1 msec resolution then there's no solution and nothing to 
talk about - lock statistics will be 1msec granular just as much as 
scheduling.

	Ingo
