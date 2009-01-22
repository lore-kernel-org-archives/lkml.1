Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZAVJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZAVJa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZAVJaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:30:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49736 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbZAVJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:30:11 -0500
Date: Thu, 22 Jan 2009 10:29:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] trace: do not disable wake up tracer on output of
	trace
Message-ID: <20090122092942.GA30467@elte.hu>
References: <20090121235306.224764198@goodmis.org> <20090121235805.771064570@goodmis.org> <20090122084105.GD7438@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122084105.GD7438@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> auto-disabling latency tracing while the trace is being output is 
> essential. Measurement should never impact the workload that is being 
> measured.

On the other hand - the latencies caused by tracing output itself should be 
quite low, correct? If not then that needs fixing too. So i've picked up 
your change - lets see how useful the result is.

But "if it hurts, disable tracing before reading the tracing result" method 
you expressed is really not acceptable.

	Ingo
