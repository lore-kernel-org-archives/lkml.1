Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYJaUlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYJaUlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYJaUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:41:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42863 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYJaUlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:41:12 -0400
Date: Fri, 31 Oct 2008 16:40:24 -0400
From: Jason Baron <jbaron@redhat.com>
To: Johann Felix Soden <johfel@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Use 'ret' variable in
	unregister_dynamic_debug_module
Message-ID: <20081031204024.GB3109@redhat.com>
References: <1225403079.7328.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225403079.7328.7.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:44:39PM +0100, Johann Felix Soden wrote:
> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> The 'ret' variable is assigned, but not used in the return statement. Fix this.
> 
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
> CC: Jason Baron <jbaron@redhat.com>
> ---
>  lib/dynamic_printk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
> index d83660f..d0fd0e4 100644
> --- a/lib/dynamic_printk.c
> +++ b/lib/dynamic_printk.c
> @@ -135,7 +135,7 @@ int unregister_dynamic_debug_module(char *mod_name)
>  	nr_entries--;
>  out:
>  	up(&debug_list_mutex);
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(unregister_dynamic_debug_module);
>  

looks good to me.

Acked-by: Jason Baron <jbaron@redhat.com>

thanks,

-Jason
