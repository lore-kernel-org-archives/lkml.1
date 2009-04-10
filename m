Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZDJAua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZDJAua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZDJAuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:50:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65410 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZDJAuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:50:19 -0400
Message-ID: <49DE97EF.7080208@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 08:50:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Pekka Paalanen <pq@iki.fi>,
       eduard.munteanu@linux360.ro, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix document references
References: <49DE9764.1090004@cn.fujitsu.com>
In-Reply-To: <49DE9764.1090004@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: LKML

Li Zefan wrote:
> When moving documents to Documentation/trace/, I forgot to
> grep Kconfig to find out those references.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 2246141..417d198 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -312,7 +312,7 @@ config KMEMTRACE
>  	  and profile kernel code.
>  
>  	  This requires an userspace application to use. See
> -	  Documentation/vm/kmemtrace.txt for more information.
> +	  Documentation/trace/kmemtrace.txt for more information.
>  
>  	  Saying Y will make the kernel somewhat larger and slower. However,
>  	  if you disable kmemtrace at run-time or boot-time, the performance
> @@ -403,7 +403,7 @@ config MMIOTRACE
>  	  implementation and works via page faults. Tracing is disabled by
>  	  default and can be enabled at run-time.
>  
> -	  See Documentation/tracers/mmiotrace.txt.
> +	  See Documentation/trace/mmiotrace.txt.
>  	  If you are not helping to develop drivers, say N.
>  
>  config MMIOTRACE_TEST

