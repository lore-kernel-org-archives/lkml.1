Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZHCFVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZHCFVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZHCFVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:21:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZHCFVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:21:04 -0400
Message-ID: <4A767359.3030405@cn.fujitsu.com>
Date: Mon, 03 Aug 2009 13:19:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/5] tracing/filters: Cleanup useless headers
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1249111408-8657-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15:23, Frederic Weisbecker wrote:
> Cleanup remaining headers inclusion that were only useful when
> the filter framework and its tracing related filesystem user interface
> weren't yet separated.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events_filter.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index b9aae72..a2f8bef 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -18,9 +18,6 @@
>   * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
>   */
>  
> -#include <linux/debugfs.h>
> -#include <linux/uaccess.h>
> -#include <linux/module.h>

But module.h is needed for the use of EXPORT_SYMBOL_GPL().

>  #include <linux/ctype.h>
>  #include <linux/mutex.h>
>  
