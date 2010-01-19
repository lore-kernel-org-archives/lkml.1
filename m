Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679Ab0ASEUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0ASEUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 23:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608Ab0ASEUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 23:20:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0ASEUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 23:20:05 -0500
Message-ID: <4B553383.9070107@redhat.com>
Date: Mon, 18 Jan 2010 23:22:27 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -tip 2/2] kprobetrace,	doc: Add the explanation to remove
 probe points
References: <20100117071411.GD19512@elte.hu> <20100119023512.31880.35535.stgit@localhost6.localdomain6>
In-Reply-To: <20100119023512.31880.35535.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> From: Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>
> 
> Latest kprobetrace can remove probe points selectively. thus
> documentation should be updated too.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Since I've delivered this patch.:-)

> ---
> 
>  Documentation/trace/kprobetrace.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
> index ab57f02..a9100b2 100644
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
> @@ -122,6 +123,12 @@ REC->dfd, REC->filename, REC->flags, REC->mode
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

