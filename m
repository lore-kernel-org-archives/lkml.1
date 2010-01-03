Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825Ab0ACLxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0ACLxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 06:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629Ab0ACLxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 06:53:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0ACLxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 06:53:00 -0500
Date: Sun, 3 Jan 2010 06:51:05 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] sunrpc: fix build-time warning
Message-ID: <20100103065105.54bba3e8@tlielax.poochiereds.net>
In-Reply-To: <20100101182514.cb1f49ef.randy.dunlap@oracle.com>
References: <1262226195-27733-1-git-send-email-jlayton@redhat.com>
	<20091231091815.a1ea7e51.rdunlap@xenotime.net>
	<20091231205454.0f84f091@tupile.poochiereds.net>
	<20100101182514.cb1f49ef.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jan 2010 18:25:14 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix auth_gss printk format warning:
> 
> net/sunrpc/auth_gss/auth_gss.c:660: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Jeff Layton <jlayton@redhat.com>

> ---
>  net/sunrpc/auth_gss/auth_gss.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20091229.orig/net/sunrpc/auth_gss/auth_gss.c
> +++ linux-next-20091229/net/sunrpc/auth_gss/auth_gss.c
> @@ -657,7 +657,7 @@ gss_pipe_downcall(struct file *filp, con
>  			break;
>  		default:
>  			printk(KERN_CRIT "%s: bad return from "
> -				"gss_fill_context: %ld\n", __func__, err);
> +				"gss_fill_context: %zd\n", __func__, err);
>  			BUG();
>  		}
>  		goto err_release_msg;
> ---


-- 
Jeff Layton <jlayton@redhat.com>
