Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004Ab0AYGKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0AYGKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589Ab0AYGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:10:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44536 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab0AYGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:10:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH 1/1] kernel/exit.c: fix shadows sparse warning.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <9695506b784c54436f40b4c21ce2d7e6965b7aee.1264257828.git.tfransosi@gmail.com>
References: <9695506b784c54436f40b4c21ce2d7e6965b7aee.1264257828.git.tfransosi@gmail.com>
Message-Id: <20100125150956.BDAF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Jan 2010 15:10:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
>  
>  		get_task_struct(p);
>  		read_unlock(&tasklist_lock);

Looks good to me.




