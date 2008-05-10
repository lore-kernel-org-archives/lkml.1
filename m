Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYEJHuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYEJHuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 03:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYEJHua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 03:50:30 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:13476 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYEJHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 03:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rQLh99ISQn2WTlU/jtWpisLxcqQIyyjUPMqr65e71dS0L6XcVBZbrBTDB3pVKVfk/19Bamo+PObNopowFUrX8i5s4PQMZlxTPBsBZq51lP94XLoNtIermYjEfmGZR5IEUoLOGracWc/O8RkdnJgx4eo+xW1D/FZKY0FCU+5UUqU=
Message-ID: <28c262360805100050m17a302e9xf82139b3d00d489e@mail.gmail.com>
Date: Sat, 10 May 2008 16:50:26 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 07/15] split LRU lists into anon & file sets
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080428181852.790327213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428181835.502876582@redhat.com>
	 <20080428181852.790327213@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6.25-mm1/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/mm/page_alloc.c       2008-04-24 12:00:01.000000000 -0400
> +++ linux-2.6.25-mm1/mm/page_alloc.c    2008-04-24 12:01:36.000000000 -0400
> @@ -1923,10 +1923,13 @@ void show_free_areas(void)
>                }
>        }
>
> -       printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
> +       printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
> +               " inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
>                " free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",

I found typo error.

index 2b2e205..ad84c99 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1932,7 +1932,7 @@ void show_free_areas(void)
                }
        }

-       printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
+       printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
                " inactive_file:%lu"
 //TODO:  check/adjust line lengths
 #ifdef CONFIG_NORECLAIM_LRU


-- 
Kinds regards,
MinChan Kim
