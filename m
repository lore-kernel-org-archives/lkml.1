Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbXJXSS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbXJXSS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXJXSSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:18:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51316 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554AbXJXSSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:18:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/proc/proc_net.c: make a struct static
References: <20071024162329.GQ30533@stusta.de>
Date: Wed, 24 Oct 2007 12:18:22 -0600
In-Reply-To: <20071024162329.GQ30533@stusta.de> (Adrian Bunk's message of
	"Wed, 24 Oct 2007 18:23:29 +0200")
Message-ID: <m1bqao8jgx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> Struct proc_net_ns_ops can become static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Don't have a clue why I didn't make it static originally.



> ---
> 5ae49d45bc25eed356ecbe3592db270bfa1d9b73 
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 2e91fb7..4edaad0 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -185,7 +185,7 @@ static __net_exit void proc_net_ns_exit(struct net *net)
>  	kfree(net->proc_net_root);
>  }
>  
> -struct pernet_operations __net_initdata proc_net_ns_ops = {
> +static struct pernet_operations __net_initdata proc_net_ns_ops = {
>  	.init = proc_net_ns_init,
>  	.exit = proc_net_ns_exit,
>  };
