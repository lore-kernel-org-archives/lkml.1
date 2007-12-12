Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXLLKdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXLLKdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXLLKdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:33:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50547 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbXLLKdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:33:23 -0500
Date: Wed, 12 Dec 2007 11:33:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl : proc_dointvec_minmax() expects int values for
	min/max guard values
Message-ID: <20071212103310.GA1611@elte.hu>
References: <20071212112247.9c30f0d0.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212112247.9c30f0d0.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> min_sched_granularity_ns, max_sched_granularity_ns, 
> min_wakeup_granularity_ns and max_wakeup_granularity_ns are declared 
> "unsigned long".
> 
> This is incorrect since proc_dointvec_minmax() expects plain "int" 
> guard values.
> 
> This bug only triggers on big endian 64 bit arches.

thanks, applied it to the 2.6.24 fixes queue.

	Ingo
