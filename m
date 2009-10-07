Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbZJGM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbZJGM6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933097AbZJGM6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:58:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103AbZJGM6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:58:39 -0400
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
In-Reply-To: <20091007124628.GB27363@Krystal>
References: <20091006233654.815079668@gentwo.org>
	 <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal>
	 <1254906707.26976.225.camel@twins>  <20091007124628.GB27363@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Oct 2009 15:01:00 +0200
Message-Id: <1254920460.26976.241.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 08:46 -0400, Mathieu Desnoyers wrote:
> * local_irq_restore
>   -> the interrupt line is low. The scheduler won't be called. There is
>      no preempt_check_resched() call.

That would be an issue with all irq disable sections, so I don't think
this is actually true.

I tried to find the actual code, but frigging paravirt crap obfuscated
the code enough that I actually gave up.
