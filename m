Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbZLZEGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbZLZEGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 23:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZLZEGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 23:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZLZEGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 23:06:13 -0500
Message-ID: <4B358BB2.7090700@redhat.com>
Date: Fri, 25 Dec 2009 23:06:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: kprobetrace: Add the explanation to remove probe
 points
References: <20091224103912.68AC.A69D9226@jp.fujitsu.com> <20091224110840.68B2.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091224110840.68B2.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Latest kprobetrace can remove probe points selectively. thus
> documentation should be updated too.

Ah, right.

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you very much!

> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  Documentation/trace/kprobetrace.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
> index 2be6e19..8c88930 100644
> --- a/Documentation/trace/kprobetrace.txt
> +++ b/Documentation/trace/kprobetrace.txt
> @@ -24,6 +24,7 @@ Synopsis of kprobe_events
>  -------------------------
>    p[:[GRP/]EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
>    r[:[GRP/]EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
> +  -:[GRP/]EVENT						: Clear a probe
>  
>   GRP		: Group name. If omitted, use "kprobes" for it.
>   EVENT		: Event name. If omitted, the event name is generated
> @@ -121,6 +122,12 @@ print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->ip, REC->dfd, R
>  
>   This clears all probe points.
>  
> + Or, 
> +
> +  echo -:myprobe >> kprobe_events
> +
> + This clears probe points selectively.
> +
>   Right after definition, each event is disabled by default. For tracing these
>  events, you need to enable it.
>  

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

