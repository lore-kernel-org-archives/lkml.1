Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYLPLGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYLPLGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYLPLG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:06:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbYLPLG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:06:27 -0500
Date: Tue, 16 Dec 2008 12:06:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: sched: trace: update trace_sched_wakeup()
Message-ID: <20081216110614.GA4299@elte.hu>
References: <1229411223.14605.48.camel@twins> <1229414244.14605.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229414244.14605.50.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2008-12-16 at 08:07 +0100, Peter Zijlstra wrote:
> > Add the information needed to distinguish 'real' wakeups from 'false'
> > wakeups.
> 
> I don't seem to be doing so well this morning...
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks Dhaval!

applied to tip/tracing/ftrace, thanks Peter!

I suspect you'll also then use this bit in the ftrace scheduler records? 
This extension is pretty orphaned right now.

	Ingo
