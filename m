Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbZJMOvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbZJMOvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbZJMOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:50:59 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43607 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758721AbZJMOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:50:58 -0400
Date: Tue, 13 Oct 2009 10:43:03 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910131041450.21608@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, David Rientjes wrote:

> I ran 60-second netperf TCP_RR benchmarks with various thread counts over
> two machines, both four quad-core Opterons.  I ran the trials ten times
> each with both vanilla per-cpu#for-next at 9288f99 and with v6 of this
> patchset.  The transfer rates were virtually identical showing no
> improvement or regression with this patchset in this benchmark.
>
>  [ As I reported in http://marc.info/?l=linux-kernel&m=123839191416472,
>    this benchmark continues to be the most significant regression slub has
>    compared to slab. ]

Hmmm... Last time I ran the in kernel benchmarks this showed a reduction
in cycle counts. Did not get to get my tests yet.

Can you also try the irqless hotpath?

