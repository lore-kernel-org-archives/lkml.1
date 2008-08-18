Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYHRW0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYHRW0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHRWZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:25:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:49062 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYHRWZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:25:51 -0400
Date: Tue, 19 Aug 2008 08:23:12 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Cordelia <cordsam@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] audit: Moved variable declaration to beginning of
 function
In-Reply-To: <48A9A73F.9060400@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0808190822350.24485@tundra.namei.org>
References: <48A9A73F.9060400@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Cordelia wrote:

> got rid of compilation warning:
> ISO C90 forbids mixed declarations and code
> 
> Signed-off-by: Cordelia Sam <cordesam@gmail.com>
> ---
>  kernel/auditsc.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 972f8e6..59cedfb 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -243,10 +243,11 @@ static inline int open_arg(int flags, int mask)
>  
>  static int audit_match_perm(struct audit_context *ctx, int mask)
>  {
> +	unsigned n;
>  	if (unlikely(!ctx))
>  		return 0;
>  
> -	unsigned n = ctx->major;
> +	n = ctx->major;
>  	switch (audit_classify_syscall(ctx->arch, n)) {
>  	case 0:	/* native */
>  		if ((mask & AUDIT_PERM_WRITE) &&


Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
