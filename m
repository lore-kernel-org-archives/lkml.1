Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbZL3Cdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbZL3Cdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 21:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZL3Cdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 21:33:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZL3Cdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 21:33:35 -0500
Message-ID: <4B3ABBD5.2080302@redhat.com>
Date: Tue, 29 Dec 2009 21:32:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Liming Wang <liming.wang@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf probe: change CONFIG_KPROBE_TRACER to CONFIG_KPROBE_EVENT
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com> <1262075829-16257-2-git-send-email-liming.wang@windriver.com> <1262075829-16257-3-git-send-email-liming.wang@windriver.com>
In-Reply-To: <1262075829-16257-3-git-send-email-liming.wang@windriver.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liming Wang wrote:
> make the config name consistent
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>

Ah, right. Thank you!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  tools/perf/util/probe-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 29465d4..8e532d9 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -368,7 +368,7 @@ static int open_kprobe_events(int flags, int mode)
>  	if (ret < 0) {
>  		if (errno == ENOENT)
>  			die("kprobe_events file does not exist -"
> -			    " please rebuild with CONFIG_KPROBE_TRACER.");
> +			    " please rebuild with CONFIG_KPROBE_EVENT.");
>  		else
>  			die("Could not open kprobe_events file: %s",
>  			    strerror(errno));

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

