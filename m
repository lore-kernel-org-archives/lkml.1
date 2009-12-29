Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZL2MFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZL2MFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZL2MFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:05:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZL2MFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:05:17 -0500
Subject: Re: [PATCH 2/3] perf tools: remove pid option from stat
From: Peter Zijlstra <peterz@infradead.org>
To: Liming Wang <liming.wang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1262075829-16257-2-git-send-email-liming.wang@windriver.com>
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
	 <1262075829-16257-2-git-send-email-liming.wang@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 13:04:11 +0100
Message-ID: <1262088251.7135.131.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 16:37 +0800, Liming Wang wrote:
> pid option is useless for stat, so remove it.

Hmm, it shouldn't be.. and instead of removing it I would suggesting
fixing this.

> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  tools/perf/builtin-stat.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index c70d720..e3b31a3 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -71,7 +71,6 @@ static int			run_idx				=  0;
>  static int			run_count			=  1;
>  static int			inherit				=  1;
>  static int			scale				=  1;
> -static pid_t			target_pid			= -1;
>  static pid_t			child_pid			= -1;
>  static int			null_run			=  0;
>  
> @@ -471,8 +470,6 @@ static const struct option options[] = {
>  		     parse_events),
>  	OPT_BOOLEAN('i', "inherit", &inherit,
>  		    "child tasks inherit counters"),
> -	OPT_INTEGER('p', "pid", &target_pid,
> -		    "stat events on existing pid"),
>  	OPT_BOOLEAN('a', "all-cpus", &system_wide,
>  		    "system-wide collection from all CPUs"),
>  	OPT_BOOLEAN('c', "scale", &scale,


