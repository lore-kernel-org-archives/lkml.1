Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZA3Nkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZA3Nkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZA3Nkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:40:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZA3Nkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:40:45 -0500
Date: Fri, 30 Jan 2009 14:40:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [trival patch] x86: remove unless include and comments
Message-ID: <20090130134025.GA16068@elte.hu>
References: <20090130092115.GB16225@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090130092115.GB16225@hack.private>
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


* Américo Wang <xiyou.wangcong@gmail.com> wrote:

> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> 
> ---
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index a546f55..e306105 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -9,8 +9,6 @@
>   * This file handles the architecture-dependent parts of process handling..
>   */
>  
> -#include <stdarg.h>
> -

i've applied this bit to tip/x86/cleanups, thanks!

> @@ -631,9 +629,6 @@ asmlinkage int sys_vfork(struct pt_regs regs)
>  	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
>  }
>  
> -/*
> - * sys_execve() executes a new program.
> - */
>  asmlinkage int sys_execve(struct pt_regs regs)
>  {
>  	int error;

That's not really useless so i left it out.

	Ingo
