Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZLNLvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZLNLvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZLNLu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:50:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59838 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbZLNLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:50:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iG8ra2irORABRjK1+orwme+bSEKa47qN7bzyW7utonzZi1Or9Y40Kj6+yRducWapky
         AAM5ItTwyMOVZFJS5aKlG3O+Z9t7nsTWfmJNcV1ABaDnFOwqMGthi0pd+5DzUp5pDADT
         AH8Z6QrgthKs7oZ8jGGD2ZFFZLFr/r0+LgkG8=
Date: Mon, 14 Dec 2009 12:50:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing: remove unnecessary variable in
	print_graph_return
Message-ID: <20091214115051.GF5168@nowhere>
References: <1260769172-16657-1-git-send-email-wenji.huang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260769172-16657-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 01:39:32PM +0800, Wenji Huang wrote:
> Remove the local variable of the same name cpu in branch.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace_functions_graph.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index a43d009..51d071c 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -858,7 +858,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  	int i;
>  
>  	if (data) {
> -		int cpu = iter->cpu;
>  		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
>  
>  		/*


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

