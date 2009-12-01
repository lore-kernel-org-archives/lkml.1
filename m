Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZLAQYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZLAQYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZLAQYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:24:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbZLAQYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:24:06 -0500
Date: Tue, 1 Dec 2009 17:23:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
Message-ID: <20091201162359.GA1079@elte.hu>
References: <20091201141642.398e7b7d@sripathi>
 <20091201103351.GA6685@elte.hu>
 <1259664883.1697.28.camel@laptop>
 <20091201125537.GA23382@elte.hu>
 <4B15414A.9040405@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B15414A.9040405@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhltc@us.ibm.com> wrote:

> I don't think the "butt-ugly" argument is enough to reject the patch. 

It is in my book - i dont ever apply ugly patches intentionally.

> It's a fairly subjective metric and I don't think the proposed 
> solution results in "pretty" code either. In fact the super long 
> function names and multi-line conditionals are arguably "ugly" (maybe 
> not "butt-ugly" though). :-)
>
> However, the arguments are solid and I understand wanting to introduce 
> a new feature in a particular way. Has there been any work done on 
> perf event injection up to this point or would this be a completely 
> new perf feature?

Yeah, it would be a brand new one.

There's a couple of other usecases as well:

 - User space logging: apps want to define tracepoints and want to
   inject events as they happen - mixed properly into the regular perf
   events flow.

 - MCE logging: hw faults are so rare that injection is desired to make
   sure the policy action chain is working properly.

 - Some of the other fault injection sites could be converted to
   tracepoints + injection-conditions as well, perhaps. That would give
   a more programmable interface and a generic event logging framework.

So it's nice and important work (and by no means trivial - that comes 
with the territory) - in case you are interested.

Thanks,

	Ingo
