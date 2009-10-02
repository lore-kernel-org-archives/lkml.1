Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZJBJax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZJBJax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZJBJaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:30:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390AbZJBJav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:30:51 -0400
Date: Fri, 2 Oct 2009 11:29:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
       rusty@rustcorp.com.au, davem@davemloft.net,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [this_cpu_xx V3 00/19] Introduce per cpu atomic operations and
	avoid per cpu address arithmetic
Message-ID: <20091002092954.GA20779@elte.hu>
References: <20091001174033.576397715@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001174033.576397715@gentwo.org>
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


* cl@linux-foundation.org <cl@linux-foundation.org> wrote:

> V2->V3:
> - Available via git tree against latest upstream from
> 	 git://git.kernel.org/pub/scm/linux/kernel/git/christoph/percpu.git linus
> - Rework SLUB per cpu operations. Get rid of dynamic DMA slab creation
>   for CONFIG_ZONE_DMA
> - Create fallback framework so that 64 bit ops on 32 bit platforms
>   can fallback to the use of preempt or interrupt disable. 64 bit
>   platforms can use 64 bit atomic per cpu ops.

I'm going to ask you (again...) to post future versions of this patchset 
to lkml.

linux-mm is a limited forum and a lot of people who might be interested 
in percpu matters simply wont know about your patch-set. per-cpu is not 
just a VM matter, obviously - it affects architectures, core kernel 
code, etc. etc.

I happened to see your patch-set and have a couple of comments about it 
but i will wait with discussing the issues until you submit these 
patches properly.

Thanks,

	Ingo
