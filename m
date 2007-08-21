Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXHUESX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXHUESX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXHUESI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:18:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60605 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXHUESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:18:05 -0400
Date: Tue, 21 Aug 2007 09:47:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: Re: [patch 04/11] Kprobes - declare kprobe_mutex static
Message-ID: <20070821041734.GC9226@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070820201902.597091353@polymtl.ca> <20070820202146.263958314@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820202146.263958314@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 04:19:06PM -0400, Mathieu Desnoyers wrote:
> Since it will not be used by other kernel objects, it makes sense to declare it
> static.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

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
> --- linux-2.6-lttng.orig/kernel/kprobes.c	2007-08-19 09:09:15.000000000 -0400
> +++ linux-2.6-lttng/kernel/kprobes.c	2007-08-19 17:18:07.000000000 -0400
> @@ -68,7 +68,7 @@ static struct hlist_head kretprobe_inst_
>  /* NOTE: change this value only with kprobe_mutex held */
>  static bool kprobe_enabled;
> 
> -DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
> +static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
>  DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
>  static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
> 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
