Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbXGQFhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbXGQFhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXGQFhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:37:22 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38145 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbXGQFhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:37:20 -0400
Date: Tue, 17 Jul 2007 11:09:14 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [PATCH] Kprobes - Declare kprobe_mutex static
Message-ID: <20070717053914.GC7033@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca> <20070714104914.GB7358@infradead.org> <20070714195241.GN6975@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714195241.GN6975@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 03:52:41PM -0400, Mathieu Desnoyers wrote:
> Kprobes - Declare kprobe_mutex static
> 
> Since it will not be used by other kernel objects, it makes sense to declare it
> static.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Mathieu

> CC: hch@infradead.org
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  kernel/kprobes.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kprobes.c	2007-07-14 15:49:17.000000000 -0400
> +++ linux-2.6-lttng/kernel/kprobes.c	2007-07-14 15:49:27.000000000 -0400
> @@ -69,7 +69,7 @@ static atomic_t kprobe_count;
>  /* NOTE: change this value only with kprobe_mutex held */
>  static bool kprobe_enabled;
> 
> -DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
> +static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
>  DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
>  static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
