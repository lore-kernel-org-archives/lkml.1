Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZKOG7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZKOG7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 01:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZKOG7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 01:59:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52628 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZKOG7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 01:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xb/XM5MFyBZDhPc/e+3RlwrUBiokqqskwjN46J2UMV1GM7hS/bcvqA3J+o1xRNvQKg
         ih85I0r30y/qhcQEwh/S6JiMtovFQjxMIrFqS/tKaTVitnyIPhlkpTUm2mocgwiJKdG0
         jpCiPnUZnVKuIzrH1PoLaqAOUXkWDe4xEeoEU=
Date: Sun, 15 Nov 2009 14:59:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
	&proc_dointvec,
Message-ID: <20091115065958.GA2459@hack>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258249925.16857.198.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
>Seems to be a typo.
>

Well, in this case, proc_dointvec == &proc_dointvec,
both of them are the same function pointer.

But yes, &proc_dointvec looks more readable.

>Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
>diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>index 0d949c5..d0bf4eb 100644
>--- a/kernel/sysctl.c
>+++ b/kernel/sysctl.c
>@@ -1605,7 +1605,7 @@ static struct ctl_table debug_table[] = {
> 		.data		= &show_unhandled_signals,
> 		.maxlen		= sizeof(int),
> 		.mode		= 0644,
>-		.proc_handler	= proc_dointvec
>+		.proc_handler	= &proc_dointvec,
> 	},
> #endif
> 	{ .ctl_name = 0 }
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
