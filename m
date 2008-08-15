Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYHOQym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYHOQym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYHOQye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:54:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbYHOQyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:54:33 -0400
Date: Fri, 15 Aug 2008 18:54:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: merge fix up
Message-ID: <20080815165419.GC29956@elte.hu>
References: <alpine.DEB.1.10.0808151244430.2188@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808151244430.2188@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Somehow we got two calls to ftrace_init.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  init/main.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-tip.git/init/main.c
> ===================================================================
> --- linux-tip.git.orig/init/main.c	2008-08-15 11:22:19.000000000 -0400
> +++ linux-tip.git/init/main.c	2008-08-15 12:43:41.000000000 -0400
> @@ -824,8 +824,6 @@ asmlinkage void __init start_kernel(void
>  
>  	ftrace_init();
>  
> -	ftrace_init();
> -

ah, in tip/master - that's a conflict resolution artifact i suspect. 
Thx.

	Ingo
