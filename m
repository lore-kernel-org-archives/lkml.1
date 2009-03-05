Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZCEJQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZCEJQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZCEJQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:16:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48179 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZCEJQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:16:37 -0500
Date: Thu, 5 Mar 2009 10:16:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces
Message-ID: <20090305091611.GB16026@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044333.GM17747@in.ibm.com> <20090305063703.GB5359@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305063703.GB5359@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Mar 05, 2009 at 10:13:33AM +0530, prasad@linux.vnet.ibm.com wrote:
> > This patch adds an ftrace plugin to detect and profile memory access over
> > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > ---
> 
> 
> Hi,
> 
> Nice feature. And moreover the standardized hardware 
> breakpoints could be helpful for tracing.

yeah. The feature is much more alive now.

> Just some comments below.

One other thing:

+#ifdef CONFIG_FTRACE_SELFTEST
+int trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
+{
+       /* TODO: Will be implemented later */
+       return 0;
+}
+#endif /* CONFIG_FTRACE_SELFTEST */

This needs to be implemented before i can pick the code up into 
tip:tracing, as otherwise we will not notice it fast enough if 
some of this stuff breaks.

Basically the ftrace plugin will be the main usage vector of 
this facility, so the self-test is a must-have.

Looks very nice otherwise.

	Ingo
