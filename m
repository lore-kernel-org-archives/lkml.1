Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZJGO2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZJGO2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbZJGO2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:28:31 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:41601 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759268AbZJGO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:28:30 -0400
Date: Wed, 7 Oct 2009 10:21:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <1254920460.26976.241.camel@twins>
Message-ID: <alpine.DEB.1.10.0910071020320.5671@gentwo.org>
References: <20091006233654.815079668@gentwo.org>  <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal>  <1254906707.26976.225.camel@twins>  <20091007124628.GB27363@Krystal> <1254920460.26976.241.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Peter Zijlstra wrote:

> On Wed, 2009-10-07 at 08:46 -0400, Mathieu Desnoyers wrote:
> > * local_irq_restore
> >   -> the interrupt line is low. The scheduler won't be called. There is
> >      no preempt_check_resched() call.
>
> That would be an issue with all irq disable sections, so I don't think
> this is actually true.

This was not true in the past... News to me that an irq enable would not
be a scheduling point.
