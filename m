Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYLILDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYLILDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYLILDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:03:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbYLILDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:03:16 -0500
Date: Tue, 9 Dec 2008 12:02:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081209110246.GC21618@elte.hu>
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> > There's also more generic x86 support: all 4 generic PMCs of Nehalem 
> > / Core i7 are supported - i've run 4 instances of KernelTop and they 
> > used up four separate PMCs.
>
> Core/Atom have 5 counters, Nehalem has 7. Why are you not using all of 
> them already?

no, Nehalem has 4 generic purpose PMCs and 3 fixed-purpose PMCs (7 
total), Core/Atom has 2 generic PMCs and 3 fixed-purpose PMCs (5 total). 
Saying that it has 7 is misleading. (and even the generic PMCs have 
constraints)

	Ingo
