Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZLZEEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZLZEEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 23:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZLZEEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 23:04:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbZLZEE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 23:04:29 -0500
Message-ID: <4B358B49.7080500@redhat.com>
Date: Fri, 25 Dec 2009 23:04:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kprobetrace: documentation fix
References: <20091224103912.68AC.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091224103912.68AC.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> 
> shell interpret $val is as shell variable. thus we need quote if
> we use echo command.

Right.
Thank you for fixing!

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  Documentation/trace/kprobetrace.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
> index 47aabee..2be6e19 100644
> --- a/Documentation/trace/kprobetrace.txt
> +++ b/Documentation/trace/kprobetrace.txt
> @@ -82,13 +82,13 @@ Usage examples
>  To add a probe as a new event, write a new definition to kprobe_events
>  as below.
>  
> -  echo p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3 > /sys/kernel/debug/tracing/kprobe_events
> +  echo 'p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3' > /sys/kernel/debug/tracing/kprobe_events
>  
>   This sets a kprobe on the top of do_sys_open() function with recording
>  1st to 4th arguments as "myprobe" event. As this example shows, users can
>  choose more familiar names for each arguments.
>  
> -  echo r:myretprobe do_sys_open $retval >> /sys/kernel/debug/tracing/kprobe_events
> +  echo 'r:myretprobe do_sys_open $retval' >> /sys/kernel/debug/tracing/kprobe_events
>  
>   This sets a kretprobe on the return point of do_sys_open() function with
>  recording return value as "myretprobe" event.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

