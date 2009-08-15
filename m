Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZHOJNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZHOJNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZHOJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:13:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34316 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbZHOJNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:13:38 -0400
Date: Sat, 15 Aug 2009 11:13:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] perf_counter: Report the cloning task as parent on
	perf_counter_fork()
Message-ID: <20090815091315.GA8719@elte.hu>
References: <1250155708.6052.2.camel@penberg-laptop> <1250172882.5241.62.camel@twins> <4A8678C4.4060309@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8678C4.4060309@cs.helsinki.fi>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Peter Zijlstra wrote:
>> A bug in (9f498cc: perf_counter: Full task tracing) makes profiling
>> multi-threaded apps it go belly up.
>
> Thanks!
>
> Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> I hope the fix makes it to 2.6.31 final as perf is unusable for 
> multi-threaded applications.

Yeah, the fix is already in -rc6.

	Ingo
