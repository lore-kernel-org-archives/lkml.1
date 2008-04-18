Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYDRJnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYDRJnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 05:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYDRJm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 05:42:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57489 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbYDRJm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 05:42:57 -0400
Date: Fri, 18 Apr 2008 11:42:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080418094239.GA26393@elte.hu>
References: <20080417002552.5742ad65.akpm@linux-foundation.org> <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com> <20080417012051.ed56f4ab.akpm@linux-foundation.org> <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI> <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com> <20080417014217.ab0453a9.akpm@linux-foundation.org> <20080417114900.GA17033@infradead.org> <20080417110135.08b076ac.akpm@linux-foundation.org> <20080417185158.GA26603@elte.hu> <Pine.BSO.4.63.0804181059090.2102@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0804181059090.2102@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Tomasz Kłoczko <kloczek@rudy.mif.pg.gda.pl> wrote:

>> and you'll see the trace events go by, live. The user-space bits of 
>> sysprof have been ported over to ftrace/sysprof already and it's a 
>> really nice tool that shows a deep stack-trace based hierarchical 
>> "vertical" profile instead of the usual finegrained profile.
>
> Does it meany Linux give up implementing DTrace way of 
> tracing/instrumntation ? In last time I observe more and more signs 
> inroducing parallel ways of tracing/instrumentations infrasctructures 
> in Linux kernel where all this can be rolled into only one .. common. 

the goal of having more generic markers is still possible and being 
aimed for - for in-kernel utilization like SystemTap, lttng, utrace, 
ftrace and similar. The latest iteration of markers looks rather 
promising in terms of giving us near-zero-cost probe points.

(and last i checked dtrace was not capable of doing something like 
mmiotrace - so it's a different thing.)

so dont worry :)

	Ingo
