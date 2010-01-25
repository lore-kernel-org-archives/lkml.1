Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AYOXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AYOXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632Ab0AYOXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:23:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0AYOXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:23:09 -0500
Date: Mon, 25 Jan 2010 15:21:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/1] kernel/exit.c: fix shadows sparse warning.
Message-ID: <20100125142152.GA4316@redhat.com>
References: <9695506b784c54436f40b4c21ce2d7e6965b7aee.1264257828.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9695506b784c54436f40b4c21ce2d7e6965b7aee.1264257828.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Thiago Farina wrote:
>
> kernel/exit.c:1183:26: warning: symbol 'status' shadows an earlier one
> kernel/exit.c:1173:21: originally declared here
>
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  kernel/exit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 546774a..2e72b3f 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1180,7 +1180,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>
>  	if (unlikely(wo->wo_flags & WNOWAIT)) {
>  		int exit_code = p->exit_code;
> -		int why, status;
> +		int why;

Looks good, thanks.

Oleg.

