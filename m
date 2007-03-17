Return-Path: <linux-kernel-owner+w=401wt.eu-S965157AbXCQM3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157AbXCQM3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933706AbXCQM3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:29:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXCQM3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:29:14 -0400
Date: Sat, 17 Mar 2007 13:28:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070317122831.GA28429@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <200703172302.10819.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703172302.10819.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> We're obviously disagreeing on what heuristics are [...]

that could very well be so - it would be helpful if you could provide 
your own rough definition for the term, so that we can agree on how to 
call things?

[ in any case, there's no rush here, please reply at your own pace, as
  your condition allows. I wish you a speedy recovery! ]

> You're simply cashing in on the deep pipes that do kernel work for 
> other tasks. You know very well that I dropped the TASK_NONINTERACTIVE 
> flag from rsdl which checks that tasks are waiting on pipes and you're 
> exploiting it.

Con, i am not 'cashing in' on anything and i'm not 'exploiting' 
anything. The TASK_NONINTERACTIVE flag is totally irrelevant to my 
argument because i was not testing the vanilla scheduler, i was testing 
RSDL. I could have written this test using plain sockets, because i was 
testing RSDL's claim of not having heuristics, i was not testing the 
vanilla scheduler.

I have simply replied to this claim of yours:

> > Despite the claims to the contrary, RSDL does not have _less_ 
> > heuristics, it does not have _any_. [...]

and i showed you a workload under _RSDL_ that clearly shows that RSDL is 
an unfair scheduler too.

my whole point was to counter the myth of 'RSDL has no heuristics'. Of 
course it has heuristics, which results in unfairness. (If it didnt have 
any heuristics that tilt the balance of scheduling towards sleep-intense 
tasks then a default Linux desktop would not be usable at all.)

so the decision is _not_ a puristic "do we want to have heuristics or 
not", the question is a more practical "which heuristics are simpler, 
which heuristics are more flexible, which heuristics result in better 
behavior".

	Ingo
