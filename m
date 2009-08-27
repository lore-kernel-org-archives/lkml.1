Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZH0PEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZH0PEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZH0PEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZH0PEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:04:41 -0400
Message-ID: <4A96A15C.9020800@redhat.com>
Date: Thu, 27 Aug 2009 11:08:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 20/18] tracing: Remove unneeded pointer casts
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1251344087-28719-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Cleaup uneeded casts from void * to char * in syscalls tracing file.
> 
> Reported-by: Li Zefan<lizf@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com
> Cc: Steven Rostedt<rostedt@goodmis.org>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>   kernel/trace/trace_syscalls.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index a928dd0..e7c676e 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -324,7 +324,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
>   	int num;
>   	char *name;
> 
> -	name = (char *)call->data;
> +	name = call->data;
>   	num = syscall_name_to_nr(name);
>   	if (num<  0 || num>= FTRACE_SYSCALL_MAX)
>   		return -ENOSYS;
> @@ -347,7 +347,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
>   	int num;
>   	char *name;
> 
> -	name = (char *)call->data;
> +	name = call->data;
>   	num = syscall_name_to_nr(name);
>   	if (num<  0 || num>= FTRACE_SYSCALL_MAX)
>   		return;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

