Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYHSRvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYHSRvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbYHSRvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:51:40 -0400
Received: from xenotime.net ([66.160.160.81]:45778 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751746AbYHSRvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:51:36 -0400
Date: Tue, 19 Aug 2008 10:51:32 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       rdunlap@xenotime.net, mpm@selenic.com, tglx@linutronix.de,
       rostedt@goodmis.org, cl@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
In-Reply-To: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
Message-ID: <Pine.LNX.4.64.0808191049260.7877@shark.he.net>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Eduard - Gabriel Munteanu wrote:

> This reverts commit 79cf3d5e207243eecb1c4331c569e17700fa08fa.
> 
> The reverted commit, while it fixed printk format warnings, it resulted in
> marker-probe format mismatches. Another approach should be used to fix
> these warnings.

Such as what?

Can marker probes be fixed instead?

After seeing & fixing lots of various warnings in the last few days,
I'm thinking that people don't look at/heed warnings nowadays.  Sad.
Maybe there are just so many that they are lost in the noise.


> ---
>  include/linux/kmemtrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
> index a865064..2c33201 100644
> --- a/include/linux/kmemtrace.h
> +++ b/include/linux/kmemtrace.h
> @@ -31,7 +31,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
>  					     int node)
>  {
>  	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
> -		   "bytes_req %zu bytes_alloc %zu gfp_flags %lu node %d",
> +		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
>  		   type_id, call_site, (unsigned long) ptr,
>  		   bytes_req, bytes_alloc, (unsigned long) gfp_flags, node);
>  }
> 

-- 
~Randy
