Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZCVWNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZCVWNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbZCVWM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:12:29 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51388 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbZCVWM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oG1/gfoWNSjbiw5WBMICAvlKsx1g3t3XCwJCPoinKx1aF8/bS3xg5z90KrOw4vwM+B
         xOYGIcNi33rTJNJ4qhY0x7K8E1Bk6ETs2N/QxFLfVNx8XV4H5xbxVo1IcUiKo8f1L9yS
         jgHI5x+l3Ps2zbZHhnXyACrTQWKBdPxZG9yoI=
Date: Sun, 22 Mar 2009 23:12:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/5] tracing/events: make the filter files writable
Message-ID: <20090322221221.GH6002@nowhere>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 11:10:43PM +0100, Frederic Weisbecker wrote:
> We need the filter files to be writable, the current
> filter file permissions make are only set readable.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_events.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 594d78a..19f61dd 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -706,7 +706,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  
>  	system->preds = NULL;
>  
> -	entry = debugfs_create_file("filter", 0444, system->entry, system,
> +	entry = debugfs_create_file("filter", 0644, system->entry, system,
>  				    &ftrace_subsystem_filter_fops);
>  	if (!entry)
>  		pr_warning("Could not create debugfs "
> @@ -769,7 +769,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
>  		}
>  	}
>  
> -	entry = debugfs_create_file("filter", 0444, call->dir, call,
> +	entry = debugfs_create_file("filter", 0644, call->dir, call,
>  				    &ftrace_event_filter_fops);
>  	if (!entry)
>  		pr_warning("Could not create debugfs "
> -- 
> 1.6.1
> 


Adding Tom Zanussi in Cc.

