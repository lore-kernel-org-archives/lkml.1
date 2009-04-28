Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbZD1RBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbZD1RBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760854AbZD1RBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:01:15 -0400
Received: from mail.fieldses.org ([141.211.133.115]:48970 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922AbZD1RBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:01:14 -0400
Date: Tue, 28 Apr 2009 13:01:13 -0400
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc/svc_xprt.c: fix sparse warnings
Message-ID: <20090428170113.GT17891@fieldses.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090165F128@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090165F128@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 08:18:19PM -0400, H Hartley Sweeten wrote:
> Fix the following sparse warnings in net/sunrpc/svc_xprt.c.
> 
>   warning: symbol 'svc_recv' was not declared. Should it be static?
>   warning: symbol 'svc_drop' was not declared. Should it be static?
>   warning: symbol 'svc_send' was not declared. Should it be static?
>   warning: symbol 'svc_close_all' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks, applied for 2.6.31.--b.

> 
> ---
> 
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index c200d92..f200393 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -11,6 +11,7 @@
>  #include <net/sock.h>
>  #include <linux/sunrpc/stats.h>
>  #include <linux/sunrpc/svc_xprt.h>
> +#include <linux/sunrpc/svcsock.h>
>  
>  #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
