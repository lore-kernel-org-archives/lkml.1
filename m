Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZBNBsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZBNBsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbZBNBez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:34:55 -0500
Received: from tundra.namei.org ([65.99.196.166]:2803 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbZBNBey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:34:54 -0500
Date: Sat, 14 Feb 2009 12:33:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
In-Reply-To: <200902130700.n1D70wFI085999@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.1.10.0902141233520.862@tundra.namei.org>
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org> <200902120653.n1C6rc9u027772@www262.sakura.ne.jp> <alpine.LRH.1.10.0902122024130.18751@tundra.namei.org>
 <200902130700.n1D70wFI085999@www262.sakura.ne.jp>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009, Tetsuo Handa wrote:

> Hello.
> 
> I made a mistake when converting to use standard doubly linked list.
> Please apply this patch.
> ----------
> Subject: TOMOYO: Fix exception policy read failure.
> 
> Due to wrong initialization, "cat /sys/kernel/security/tomoyo/exception_policy"
> returned nothing.
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>

Applied.

> ---
>  security/tomoyo/domain.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- security-testing-2.6.git.orig/security/tomoyo/domain.c
> +++ security-testing-2.6.git/security/tomoyo/domain.c
> @@ -376,7 +376,7 @@ int tomoyo_write_domain_keeper_policy(ch
>  bool tomoyo_read_domain_keeper_policy(struct tomoyo_io_buffer *head)
>  {
>  	struct list_head *pos;
> -	bool done = false;
> +	bool done = true;
>  
>  	down_read(&tomoyo_domain_keeper_list_lock);
>  	list_for_each_cookie(pos, head->read_var2,
> 

-- 
James Morris
<jmorris@namei.org>
