Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZBFOrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZBFOrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZBFOq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:46:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbZBFOq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:46:56 -0500
Date: Fri, 6 Feb 2009 15:46:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
Message-ID: <20090206144609.GB18368@elte.hu>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <1233912891.4731.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233912891.4731.1.camel@laptop>
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

> On Fri, 2009-02-06 at 01:53 -0500, Steven Rostedt wrote:
> 
> > This code adds an in_nmi() macro that uses the current tasks preempt count
> > to track when it is in NMI context. Other parts of the kernel can
> > use this to determine if the context is in NMI context or not.
> > 
> > This code was inspired by the -rt patch in_nmi version that was
> > written by Peter Zijlstra.
> 
> Which in turn I borrowed from Mathieu.

Steve, could you please fix the attribution?

	Ingo
