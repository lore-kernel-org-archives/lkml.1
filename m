Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZCELiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZCELiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZCELin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:38:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZCELim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:38:42 -0500
Date: Thu, 5 Mar 2009 12:38:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
	lightweight local clock
Message-ID: <20090305113828.GA9548@elte.hu>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com> <20090305110433.GH32407@elte.hu> <20090305112322.GH5359@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305112322.GH5359@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > There will be one problem though: function trace elapsed 
> > time measurements across idle. Those are not correctly 
> > measured by the local clock.
> 
> Oh, why? If I'm not wrong it uses sched_clock() which uses tsc 
> on x86. And this register always goes forward at the same 
> rate. Unless some Cpu decrease their frequency while beeing 
> idle for some time and then become unreliable?

TSC stops in idle on many CPUs.

	Ingo
