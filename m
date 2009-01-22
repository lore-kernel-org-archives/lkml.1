Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZAVMEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZAVMEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZAVMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:04:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZAVMEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:04:13 -0500
Date: Thu, 22 Jan 2009 13:03:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] trace: do not disable wake up tracer on output of
	trace
Message-ID: <20090122120337.GB22594@elte.hu>
References: <20090121235306.224764198@goodmis.org> <20090121235805.771064570@goodmis.org> <20090122084105.GD7438@elte.hu> <alpine.DEB.1.10.0901220658050.22776@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901220658050.22776@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3387]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Well actually, I don't see the output causing any issues. That's another 
> point. Should we work on adding all this complex code for something that 
> might not every cause an issues?  I added it because it did cause an 
> issue with the irqs off traces, although I'm not sure that is true any 
> more either. I just added it to the wakeup tracer just to be consistent.
> 
> With the new trace_off switch that disables the ring buffer, and the 
> stopping of the swap buffers with the switch off, I do not think that 
> this code is even necessary anymore.
> 
> I think I'll rip out the code from irqsoff and see if it is still an 
> issue there. If not, I think we can get rid of it.

agreed - if the output itself does not disturb max-latency tracing in 
practice then i'm all for ripping it out.

	Ingo
