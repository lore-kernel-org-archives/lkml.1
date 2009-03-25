Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZCYDWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZCYDWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZCYDWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:22:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41418 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbZCYDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:22:10 -0400
Date: Wed, 25 Mar 2009 12:21:21 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: ftrace not working?
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>, rusty@rustcorp.com.au,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200903242253.36794.knikanth@suse.de>
References: <20090323143226.GA18439@elte.hu> <200903242253.36794.knikanth@suse.de>
Message-Id: <20090325121906.D2D6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 17bb88d..98f609d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3887,6 +3887,7 @@ __init static int tracer_alloc_buffers(void)
>  
>  	register_die_notifier(&trace_die_notifier);
>  	ret = 0;
> +	goto out;
>  
>  out_free_cpumask:
>  	free_cpumask_var(tracing_cpumask);

Good catch!

I think this patch should send to 2.6.29.1 :)



