Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYCTTEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYCTTEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYCTTEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:04:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbYCTTEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:04:35 -0400
Date: Thu, 20 Mar 2008 20:03:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       David Smith <dsmith@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/4] Markers - depends on not PREEMPT_RCU
Message-ID: <20080320190335.GA12770@elte.hu>
References: <20080320002737.918213455@polymtl.ca> <20080320002834.448782178@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320002834.448782178@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> +++ linux-2.6-lttng/init/Kconfig	2008-03-19 18:27:43.000000000 -0400
> @@ -742,6 +742,7 @@ config PROFILING
>  
>  config MARKERS
>  	bool "Activate markers"
> +	depends on !PREEMPT_RCU
>  	help

Ugh, NACK. Please solve this properly... What kind of kernel 
infrastructure is it what disables itself in the presence of another 
piece of kernel infrastructure?

	Ingo
