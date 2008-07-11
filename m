Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbYGKMkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbYGKMkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbYGKMkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:40:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbYGKMkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:40:22 -0400
Message-ID: <48775402.4060605@redhat.com>
Date: Fri, 11 Jul 2008 08:37:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Daniel Guilak <guilak@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       daniel@danielguilak.com
Subject: Re: [PATCH] kernel/kprobes.c: Made kprobe_blacklist static.
References: <1215707899.6497.2.camel@dguilak-desk>
In-Reply-To: <1215707899.6497.2.camel@dguilak-desk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Guilak wrote:
> Signed-off-by: Daniel Guilak <daniel@danielguilak.com>

Thank you for cleaning up.
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  kernel/kprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index d4998f8..1485ca8 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -79,7 +79,7 @@ static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
>   *
>   * For such cases, we now have a blacklist
>   */
> -struct kprobe_blackpoint kprobe_blacklist[] = {
> +static struct kprobe_blackpoint kprobe_blacklist[] = {
>  	{"preempt_schedule",},
>  	{NULL}    /* Terminator */
>  };

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

