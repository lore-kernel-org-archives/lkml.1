Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbZHXLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbZHXLcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZHXLcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:32:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZHXLcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:32:18 -0400
Date: Mon, 24 Aug 2009 13:32:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824113201.GB10215@elte.hu>
References: <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org> <20090824095652.GC25267@elte.hu> <20090824103251.GA18106@linux-sh.org> <20090824110040.GA4050@elte.hu> <20090824111501.GB18420@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824111501.GB18420@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> On Mon, Aug 24, 2009 at 01:00:40PM +0200, Ingo Molnar wrote:
>
> > And the thing is, s390 was always a pleasure to deal with. I 
> > cannot say the same about anything SH. SH always was a huge PITA 
> > to deal with (to me at least), mainly because you seem to have a 
> > false sense of entitlement: you think everyone else must be 
> > perfect and must not affect you while you can sit on your own 
> > little island not worrying about the rest of the world - who 
> > develops and tests core kernel facilities for you. It doesnt 
> > work like that.
> 
> If you had bothered to read any of my earlier mail you would 
> realize that this is complete and utter nonsense.

first you say it's nonsense, then you basically back up my points:

> [...] I expect there to be breakage, and I expect that I will be 
> the one fixing it up (even when most of the time that breakage is 
> not even in my own tree). Unsurprisingly, this is largely a result 
> of SH being one of the first architectures testing these new core 
> kernel facilities, which is something you seem intent on just 
> writing off completely. [...]

... the thing is, you didnt Cc: any of the tracing commits in the SH 
tree either to lkml or to the tracing folks who are developing those 
facilities:

  c652d78: sh: Add ftrace syscall tracing support

  From: Matt Fleming <matt@console-pimps.org>
  Date: Mon, 6 Jul 2009 20:16:33 +0900
  Subject: [PATCH] sh: Add ftrace syscall tracing support

  [...]

  Signed-off-by: Matt Fleming <matt@console-pimps.org>
  Signed-off-by: Paul Mundt <lethal@linux-sh.org>

That 'could' have been Cc:-ed to Frederic and Steve, perhaps Jason 
and me as well.

You basically treat SH as your own private tree, with little need to 
communicate with anyone outside the SH hackers. Which is fine, as 
long as you are willing to deal with the other side of the coin: 
that others wont be aware of your changes.

Or, at minimum, to not scream loudly when the flip side beats you.

	Ingo
