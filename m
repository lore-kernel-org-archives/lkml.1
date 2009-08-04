Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbZHDRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbZHDRGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933087AbZHDRGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:06:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51435 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889AbZHDRGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:06:18 -0400
Date: Tue, 4 Aug 2009 19:05:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090804170545.GA29369@elte.hu>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <20090803112220.GA22936@elte.hu> <20090803163048.GT14610@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803163048.GT14610@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 03.08.09 13:22:20, Ingo Molnar wrote:
> > 
> > Now i'm also co-maintaining perfcounters and because it's a full 
> > oprofile replacement (which aspect Robert seems to disagree with 
> > ;-)
> 
> I can't imagine a full oprofile replacement. This would require a 
> rewrite of all userland tools and also the complete port of all 
> architectures (which has to be done for each architecture 
> individually). And first of all, I don't think it is necessary to 
> do this, why not keep different interfaces for different purposes?

Perfcounters and tools/perf/ intends to be everything that oprofile 
is - just implemented in a better way. What 'different purposes' do 
you mean?

Lets admit it: the oprofile kernel-side code has been mis-designed 
from the get go and it is unfixable in its current form. The 
mis-design is hardcoded in the oprofile ABIs and into portions of 
the oprofile tooling. If you wanted to fix that you'd have to 
rewrite the whole thing from scratch.

And the thing is, we already did that: the 'fix' for oprofile is 
perfcounters and the perf tool ;-) This is why we developed and 
merged perfcounters upstream and did not extend oprofile to begin 
with.

All in one, Oprofile is largely obsolete and i dont see that 
realization from your patches. I see a lot of ongoing churn coming 
up on the oprofile kernel side and i'm not sure i want to assist 
that, because i think it's stupid and i dont like doing or helping 
stupid things.

So please either convince me that it's not obsolete, or lets state 
it as a fundamental disagreement that you dont think that oprofile 
is obsolete and that you still want to develop it.

	Ingo
