Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYKMJAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYKMJAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYKMJAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:00:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYKMJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:00:04 -0500
Date: Thu, 13 Nov 2008 09:59:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call
	prepare_ftrace_return by registers
Message-ID: <20081113085949.GG25479@elte.hu>
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu> <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com> <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com> <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com> <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> > 
> > Hmm... The whole thing is splitted in two levels: the infrastructure
> > to trace on call and return (and call
> > a return handler) and the higher level tracer.
> > The first could be called ftrace_exit because it is waht it does.
> > And the second is much more about cost evaluation of functions and so
> > could be named function_cost. Its
> > functions and structures could have this in their name whereas the low
> > level things could have ftrace_exit in
> > their name.
> > 
> > What do you think?
> 
> Yeah, I like that.
> 
> Ingo, what's your thought on that?

hm, function-exit is a quite bad name i think that tells nothing to 
the user. I like "function-cost tracer" because that tells the user 
what it's all about in the end.

Or perhaps we could name it the "callgraph" tracer? (as opposed to the 
simpler function tracer which traces function entries) Note that we 
could use the output to build function call coverage graphs.

It definitely must convey the idea that this is a more capable (and 
also more expensive) form of function tracing.

	Ingo
