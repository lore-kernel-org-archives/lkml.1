Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbYHNNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbYHNNN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYHNNNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:13:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15529 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYHNNNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X9ubQe3+V4N2fBL2nxxouxj9RRCrkp2+tYl6eZQNnkQzElAv+YQpZT754lOnr2sNzc
         eqvQgqNbvY7T07v7GVoIXEB64pAL02QnA6q8d75WeAJoMvP1wBvrOdrxUgKSRKVKSnnA
         mkk6YLuOxqOYTtBm8asjAtE6XF1flre0NjoGc=
Message-ID: <c62985530808140613n787572d5s3acb1a529285f8f@mail.gmail.com>
Date: Thu, 14 Aug 2008 14:13:16 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: mingo@elte.hu, srostedt@redhat.com
Subject: Re: [PATCH] trace: Fix some mistakes in error messages
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <48A0B7ED.2010705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48A0B7ED.2010705@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/11 Frédéric Weisbecker <fweisbec@gmail.com>
>
> This patch fixes some mistakes on the tracer in warning messages when debugfs fails to create tracing files.
> Kernel version: 2.6.27-rc1
>
> Regards.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff -rup a/kernel/trace/trace.c b/kernel/trace/trace.c
> --- a/kernel/trace/trace.c    2008-08-11 22:44:25.000000000 +0200
> +++ b/kernel/trace/trace.c    2008-08-11 23:10:39.000000000 +0200
> @@ -2881,12 +2881,12 @@ static __init void tracer_init_debugfs(v
>    entry = debugfs_create_file("available_tracers", 0444, d_tracer,
>                    &global_trace, &show_traces_fops);
>    if (!entry)
> -        pr_warning("Could not create debugfs 'trace' entry\n");
> +        pr_warning("Could not create debugfs 'available_tracers' entry\n");
>
>    entry = debugfs_create_file("current_tracer", 0444, d_tracer,
>                    &global_trace, &set_tracer_fops);
>    if (!entry)
> -        pr_warning("Could not create debugfs 'trace' entry\n");
> +        pr_warning("Could not create debugfs 'current_tracer' entry\n");
>
>    entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
>                    &tracing_max_latency,
> @@ -2899,7 +2899,7 @@ static __init void tracer_init_debugfs(v
>                    &tracing_thresh, &tracing_max_lat_fops);
>    if (!entry)
>        pr_warning("Could not create debugfs "
> -               "'tracing_threash' entry\n");
> +               "'tracing_thresh' entry\n");
>    entry = debugfs_create_file("README", 0644, d_tracer,
>                    NULL, &tracing_readme_fops);
>    if (!entry)
> @@ -2909,13 +2909,13 @@ static __init void tracer_init_debugfs(v
>                    NULL, &tracing_pipe_fops);
>    if (!entry)
>        pr_warning("Could not create debugfs "
> -               "'tracing_threash' entry\n");
> +               "'trace_pipe' entry\n");
>
>    entry = debugfs_create_file("trace_entries", 0644, d_tracer,
>                    &global_trace, &tracing_entries_fops);
>    if (!entry)
>        pr_warning("Could not create debugfs "
> -               "'tracing_threash' entry\n");
> +               "'trace_entries' entry\n");
>
> #ifdef CONFIG_DYNAMIC_FTRACE
>    entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,


I said my kernel version was 2.6.27-rc1 but in fact it still applies
on last git tree.
