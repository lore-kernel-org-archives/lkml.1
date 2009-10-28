Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbZJ1JHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbZJ1JHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932756AbZJ1JHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:07:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932747AbZJ1JHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:07:36 -0400
Message-ID: <4AE80993.5000300@cn.fujitsu.com>
Date: Wed, 28 Oct 2009 17:06:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de
Subject: Re: [tip:perf/core] tracing/filters: Refactor subsystem filter code
References: <4AD69502.8060903@cn.fujitsu.com> <tip-fce29d15b59245597f7f320db4a9f2be0f5fb512@git.kernel.org> <20091015103614.GA20291@elte.hu>
In-Reply-To: <20091015103614.GA20291@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Commit-ID:  fce29d15b59245597f7f320db4a9f2be0f5fb512
>> Gitweb:     http://git.kernel.org/tip/fce29d15b59245597f7f320db4a9f2be0f5fb512
>> Author:     Li Zefan <lizf@cn.fujitsu.com>
>> AuthorDate: Thu, 15 Oct 2009 11:20:34 +0800
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Thu, 15 Oct 2009 11:35:22 +0200
> 
> the filter variable was not initialized here - i have applied the fix 
> below.
> 

I sent out the patchset and then went for a travel, and came back
to found this fixup is wrong..

I'll send out the correct fix soon.

> 	Ingo
> 
> Index: linux/kernel/trace/trace_events_filter.c
> ===================================================================
> --- linux.orig/kernel/trace/trace_events_filter.c
> +++ linux/kernel/trace/trace_events_filter.c
> @@ -1230,8 +1230,8 @@ static int replace_system_preds(struct e
>  				struct filter_parse_state *ps,
>  				char *filter_string)
>  {
> +	struct event_filter *filter = system->filter;
>  	struct ftrace_event_call *call;
> -	struct event_filter *filter;
>  	int err;
>  	bool fail = true;
>  
> 
> 
