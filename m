Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYGGQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYGGQad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYGGQaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:30:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbYGGQaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:30:21 -0400
Message-ID: <48724413.8000302@redhat.com>
Date: Mon, 07 Jul 2008 12:28:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [RFC patch 07/12] Traceprobes
References: <20080704235207.147809973@polymtl.ca> <20080704235426.751868080@polymtl.ca>
In-Reply-To: <20080704235426.751868080@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Menu option to activate tracing probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Alexander Viro <viro@zeniv.linux.org.uk>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Masami Hiramatsu <mhiramat@redhat.com>

Thanks, this is good to me. Tested on x86-64.
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  init/Kconfig |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6-lttng/init/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/init/Kconfig	2008-07-04 09:32:52.000000000 -0400
> +++ linux-2.6-lttng/init/Kconfig	2008-07-04 09:33:05.000000000 -0400
> @@ -795,6 +795,15 @@ config MARKERS
>  	  Place an empty function call at each marker site. Can be
>  	  dynamically changed for a probe function.
>  
> +config TRACEPROBES
> +	tristate "Compile generic tracing probes"
> +	depends on MARKERS
> +	default y
> +	help
> +	  Compile generic tracing probes, which connect to the tracepoints when
> +	  loaded and format the information collected by the tracepoints with
> +	  the Markers.
> +
>  source "arch/Kconfig"
>  
>  config PROC_PAGE_MONITOR
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

