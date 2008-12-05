Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYLEMNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYLEMNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLEMNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:13:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYLEMNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:13:24 -0500
Date: Fri, 5 Dec 2008 13:13:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205121308.GB28662@elte.hu>
References: <20081205082431.GD2030@elte.hu> <20081205.002701.172921476.davem@davemloft.net> <20081205084233.GE2030@elte.hu> <20081205.004922.244597525.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205.004922.244597525.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 5 Dec 2008 09:42:33 +0100
> 
> > Please let me repeat: it's a _fundamental_ thesis of performance 
> > instrumentation to not disturb the monitored context. Your insistence 
> > on _stopping_ the monitored task breaks that fundamental axiom!
> 
> This is only a problem if you make your measurement quantums too small.

But if you make the measurement long enough - say we make it 100,000 
usecs, then 0.2 usecs of delay between two read()s is insignificant 
statistically, right? It's a 1:500,000 ratio.

Scheduling out a task and back is far more drastic of an effect than any 
new events in 0.2 usecs.

	Ingo
