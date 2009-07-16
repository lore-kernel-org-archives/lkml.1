Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZGPOt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZGPOt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZGPOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:49:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:27102 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbZGPOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cfQfLXYk0Lc6K2ckyJnUbcCPec9IEAGDLvsD6jBZsWkyU5UeG+/xg9kW0IcA5+xGJ4
         /kySZ7aHwTjnqnlpFjFg2mboAYjiC2S2XE947Lu14HNDsnZk/ZnQ0ULRFe2sJBGDo/Ni
         R/fRkSRsDZu/IJeKf48GG2GxoUdEk6ByZCupw=
Date: Thu, 16 Jul 2009 10:49:39 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] perf_counter: Make call graph option consistent
Message-ID: <20090716144932.GB8043@nowhere>
References: <20090716104247.536695580@samba.org> <20090716104817.803604373@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716104817.803604373@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:42:52PM +1000, Anton Blanchard wrote:
> perf record uses -g for logging call graph data but perf report uses -c
> to print call graph data. Be consistent and use -g everywhere for call graph
> data.
> 
> Also update the help text to reflect the current default - fractal,0.5
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>


Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
> 
> Im not sure if it's too late to make this change, but I've tripped
> up a number of times when I cycle between perf record and perf report.
> 
> Index: linux.trees.git/tools/perf/builtin-report.c
> ===================================================================
> --- linux.trees.git.orig/tools/perf/builtin-report.c	2009-07-16 19:41:41.000000000 +1000
> +++ linux.trees.git/tools/perf/builtin-report.c	2009-07-16 19:41:49.000000000 +1000
> @@ -2005,9 +2005,9 @@
>  		   "regex filter to identify parent, see: '--sort parent'"),
>  	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
>  		    "Only display entries with parent-match"),
> -	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type,min_percent",
> +	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
>  		     "Display callchains using output_type and min percent threshold. "
> -		     "Default: flat,0", &parse_callchain_opt, callchain_default_opt),
> +		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
>  	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
>  		   "only consider symbols in these dsos"),
>  	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
> 
> -- 
> 

