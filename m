Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZJCLdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZJCLdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 07:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZJCLdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 07:33:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:55618 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZJCLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 07:33:17 -0400
Subject: Re: [patch] procfs: provide stack information for threads
From: Stefani Seibold <stefani@seibold.net>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <m263axq8ie.fsf@whitebox.home>
References: <1238511505.364.61.camel@matrix>
	 <20090401193135.GA12316@elte.hu> <1244146873.20012.6.camel@wall-e>
	 <m2eipl7axx.fsf@igel.home> <m2ws3djwrr.fsf@igel.home>
	 <m263axq8ie.fsf@whitebox.home>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 13:33:31 +0200
Message-Id: <1254569611.18659.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, i missed this. Good job ;-)

Am Samstag, den 03.10.2009, 08:47 +0200 schrieb Andreas Schwab: 
> Here's the patch again properly signed.
> 
> Andreas.
> 
> >From 9da252fd7d9a5cf84a477a35a6b52f927c85b280 Mon Sep 17 00:00:00 2001
> From: Andreas Schwab <schwab@linux-m68k.org>
> Date: Sat, 3 Oct 2009 08:19:43 +0200
> Subject: [PATCH] compat_do_execve: set current->stack_start as in do_execve
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  fs/compat.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/compat.c b/fs/compat.c
> index d576b55..6c19040 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -1532,6 +1532,8 @@ int compat_do_execve(char * filename,
>  	if (retval < 0)
>  		goto out;
>  
> +	current->stack_start = current->mm->start_stack;
> +
>  	/* execve succeeded */
>  	current->fs->in_exec = 0;
>  	current->in_execve = 0;
> -- 
> 1.6.4.4
> 
> 

