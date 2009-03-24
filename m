Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZCXIaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZCXIaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZCXIaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:30:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:57094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZCXI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cIm0dElq0HcVny3+r459tD/SqrClaHqAaX2ZQE8NIDaI9Poi2Nou5z5PYblr+HL9KY
         kgJiF0qemugG0O3nSwwy59Z1rB5dzyTUl6QBWMmlue/dgJFjgWGYQRS4QO1NIFkKm6gv
         Nc7LS3rlDVphojXSCWNnoKk/X1qRwmh+cW6+s=
Date: Tue, 24 Mar 2009 10:30:32 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/kmemtrace] kmemtrace: fix tracepoint declarations
Message-ID: <20090324083032.GA5383@localhost>
References: <1237882470.25315.30.camel@penberg-laptop> <tip-9d47aa18654e4344b1d20b14463addee676e9ea4@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-9d47aa18654e4344b1d20b14463addee676e9ea4@git.kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 08:21:28AM +0000, Pekka Enberg wrote:
> Commit-ID:  9d47aa18654e4344b1d20b14463addee676e9ea4
> Gitweb:     http://git.kernel.org/tip/9d47aa18654e4344b1d20b14463addee676e9ea4
> Author:     Pekka Enberg <penberg@cs.helsinki.fi>
> AuthorDate: Tue, 24 Mar 2009 10:14:30 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 24 Mar 2009 09:19:52 +0100
> 
> kmemtrace: fix tracepoint declarations
> 
> Impact: build fix
> 
> Use the new TP_PROTO and TP_ARGS to fix the build.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> LKML-Reference: <1237882470.25315.30.camel@penberg-laptop>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/trace/kmemtrace.h |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
> index 9e28ae1..7514476 100644
> --- a/include/trace/kmemtrace.h
> +++ b/include/trace/kmemtrace.h
> @@ -15,41 +15,41 @@
>  extern void kmemtrace_init(void);
>  
>  DECLARE_TRACE(kmalloc,
> -	      TPPROTO(unsigned long call_site,
> +	      TP_PROTO(unsigned long call_site,
>  		      const void *ptr,
>  		      size_t bytes_req,
>  		      size_t bytes_alloc,
>  		      gfp_t gfp_flags),
> -	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
> +	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
>  DECLARE_TRACE(kmem_cache_alloc,
> -	      TPPROTO(unsigned long call_site,
> +	      TP_PROTO(unsigned long call_site,
>  		      const void *ptr,
>  		      size_t bytes_req,
>  		      size_t bytes_alloc,
>  		      gfp_t gfp_flags),
> -	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
> +	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
>  DECLARE_TRACE(kmalloc_node,
> -	      TPPROTO(unsigned long call_site,
> +	      TP_PROTO(unsigned long call_site,
>  		      const void *ptr,
>  		      size_t bytes_req,
>  		      size_t bytes_alloc,
>  		      gfp_t gfp_flags,
>  		      int node),
> -	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
> +	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
>  DECLARE_TRACE(kmem_cache_alloc_node,
> -	      TPPROTO(unsigned long call_site,
> +	      TP_PROTO(unsigned long call_site,
>  		      const void *ptr,
>  		      size_t bytes_req,
>  		      size_t bytes_alloc,
>  		      gfp_t gfp_flags,
>  		      int node),
> -	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
> +	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
>  DECLARE_TRACE(kfree,
> -	      TPPROTO(unsigned long call_site, const void *ptr),
> -	      TPARGS(call_site, ptr));
> +	      TP_PROTO(unsigned long call_site, const void *ptr),
> +	      TP_ARGS(call_site, ptr));
>  DECLARE_TRACE(kmem_cache_free,
> -	      TPPROTO(unsigned long call_site, const void *ptr),
> -	      TPARGS(call_site, ptr));
> +	      TP_PROTO(unsigned long call_site, const void *ptr),
> +	      TP_ARGS(call_site, ptr));
>  
>  #endif /* __KERNEL__ */
>  

Thanks, I was clueless. I thought the problem was similar to the RCU
stuff.


	Eduard

