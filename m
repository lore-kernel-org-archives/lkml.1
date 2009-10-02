Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZJBJ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZJBJ72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZJBJ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:59:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbZJBJ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:59:26 -0400
Date: Fri, 2 Oct 2009 11:59:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 02/20] this_cpu: X86 optimized this_cpu
	operations
Message-ID: <20091002095916.GA26201@elte.hu>
References: <20091001212521.123389189@gentwo.org> <20091001212557.963565363@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001212557.963565363@gentwo.org>
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

> Basically the existing percpu ops can be used for this_cpu variants 
> that allow operations also on dynamically allocated percpu data. 
> However, we do not pass a reference to a percpu variable in. Instead a 
> dynamically or statically allocated percpu variable is provided.
> 
> Preempt, the non preempt and the irqsafe operations generate the same 
> code. It will always be possible to have the requires per cpu 
> atomicness in a single RMW instruction with segment override on x86.
> 
> 64 bit this_cpu operations are not supported on 32 bit.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
