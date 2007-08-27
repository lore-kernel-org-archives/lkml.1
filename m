Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXH0Vss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXH0Vss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbXH0Vdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:33:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:28569 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbXH0Vdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Euv8+laIUD5UlxucGfoAEmN8lq4tnid6mpzVynh9O+gxkC9z184Ufnx0GLEUg2WFBS3gNQd60tBe9BSia1i+lutVSKOffJBsOSypfb4qpcfOGchleeYZCPnm9xQz/9hTmEaMwNxkx068HS5slgkxaG8wEEsGuGXQKOKHWyKYNeM=
Date: Tue, 28 Aug 2007 01:33:23 +0400
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
Message-ID: <20070827213323.GA1759@martell.zuzino.mipt.ru>
References: <1188247231.18004.129.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188247231.18004.129.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 01:40:31PM -0700, Joe Perches wrote:
> Add const to some struct task_struct * uses

Why, oh, why? This way code there are more characters on screen and zero
change in vmlinux, at least here.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1222,22 +1222,22 @@ static inline int rt_prio(int prio)
>  	return 0;
>  }
>  
> -static inline int rt_task(struct task_struct *p)
> +static inline int rt_task(const struct task_struct *p)
>  {
>  	return rt_prio(p->prio);
>  }
	...
