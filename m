Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYE3IYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYE3IYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYE3IX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:23:28 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43606 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYE3IXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:23:25 -0400
Date: Fri, 30 May 2008 01:23:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/9] Fix a printk call
Message-ID: <20080530082321.GG4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080507113553.395937000@bull.net> <20080507113735.952179000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113735.952179000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:35:56PM +0200, Nadia.Derbey@bull.net wrote:
> [PATCH 03/09]
> 
> This is a trivial patch that fixes the printk incomplete call.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  lib/idr.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.25-mm1/lib/idr.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 17:24:15.000000000 +0200
> +++ linux-2.6.25-mm1/lib/idr.c	2008-05-06 17:26:41.000000000 +0200
> @@ -325,7 +325,8 @@ EXPORT_SYMBOL(idr_get_new);
> 
>  static void idr_remove_warning(int id)
>  {
> -	printk("idr_remove called for id=%d which is not allocated.\n", id);
> +	printk(KERN_WARNING
> +		"idr_remove called for id=%d which is not allocated.\n", id);
>  	dump_stack();
>  }
> 
> 
> --
