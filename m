Return-Path: <linux-kernel-owner+w=401wt.eu-S934221AbZDATr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbZDATr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbZDATrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:47:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759316AbZDATrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:47:47 -0400
Date: Wed, 1 Apr 2009 12:45:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] Align cache_clean work
Message-Id: <20090401124516.40968848.akpm@linux-foundation.org>
In-Reply-To: <20090401104518.GG27084@kryten>
References: <20090401104518.GG27084@kryten>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] Align cache_clean work

better titles, please.  Of the form

	subsystem-identifier: what-i-did-to-it

On Wed, 1 Apr 2009 21:45:18 +1100
Anton Blanchard <anton@samba.org> wrote:

> 
> Align cache_clean work.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: linux-2.6/net/sunrpc/cache.c
> ===================================================================
> --- linux-2.6.orig/net/sunrpc/cache.c	2009-04-01 15:47:38.000000000 +1100
> +++ linux-2.6/net/sunrpc/cache.c	2009-04-01 16:32:44.000000000 +1100
> @@ -488,7 +488,7 @@
>  {
>  	int delay = 5;
>  	if (cache_clean() == -1)
> -		delay = 30*HZ;
> +		delay = round_jiffies_relative(30*HZ);
>  
>  	if (list_empty(&cache_list))
>  		delay = 0;

the people who will merge this patch (nfs/net) will be wondering why
they were asked to do so.

iow: better changelogs please ;)
