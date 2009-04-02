Return-Path: <linux-kernel-owner+w=401wt.eu-S934529AbZDBB6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529AbZDBB6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbZDBB6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:58:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbZDBB6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:58:44 -0400
Date: Thu, 2 Apr 2009 03:58:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: add run-time field descriptions to
	TRACE_EVENT_FORMAT events
Message-ID: <20090402015830.GB12489@elte.hu>
References: <1238390524.6368.64.camel@bookworm> <20090330103808.GB6058@nowhere> <1238474638.10508.51.camel@bookworm> <20090401122516.GH12966@elte.hu> <alpine.DEB.2.00.0904011102421.7942@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904011102421.7942@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Now what I could do, is to add a cmpxchg. If there's no data after 
> the data that we want to discard, then we discard it. Note, this 
> can only happen before the commit is made.
> 
> I'll see if I can implement that.

Great!

I dont think the IRQ race is a common one even with a lot of IRQs, 
so as long as the common case is fine and we let a few holes slip 
through it should be fine.

[ If the IRQ race window is wide then that's a sign of us having too 
  much tracing overhead ;-) ]

	Ingo
