Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYKLSWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYKLSWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYKLSVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:21:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYKLSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:21:52 -0500
Date: Wed, 12 Nov 2008 19:21:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2] unlikely profiler and tracer
Message-ID: <20081112182131.GB4562@elte.hu>
References: <20081112051438.843792214@goodmis.org> <20081112105314.GB31958@elte.hu> <alpine.DEB.1.10.0811120800140.2529@gandalf.stny.rr.com> <20081112130714.GA24472@elte.hu> <alpine.DEB.1.10.0811121035180.2529@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811121035180.2529@gandalf.stny.rr.com>
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
> On Wed, 12 Nov 2008, Ingo Molnar wrote:
> > two more small details i noticed:
> > 
> >  - does it do proper self-test? It doesnt seem so at first sight.
> 
> Hmm, no. The problem is that it is a switch to be added to other 
> tracers. There's not a branch profiling tracer itself. I could add 
> one that just does that, and that could do the self test.

i know that it's an iter_ctrl detail, but nevertheless the branch 
tracer (which is how people will be using this) should have some 
self-test.

it might also make sense to just have a standalone 'branch' tracer 
plugin as well. We have all the callbacks in place already, and people 
might be interested in just that info - not in some other tracing 
output.

	Ingo
