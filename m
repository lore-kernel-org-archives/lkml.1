Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZCVXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZCVXqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZCVXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:46:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38956 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZCVXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:46:12 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/3] mm: decouple unevictable lru from mmu
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <1237752784-1989-1-git-send-email-hannes@cmpxchg.org>
References: <20090321102044.GA3427@cmpxchg.org> <1237752784-1989-1-git-send-email-hannes@cmpxchg.org>
Message-Id: <20090323084423.490C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 08:46:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -206,7 +206,6 @@ config VIRT_TO_BUS
>  config UNEVICTABLE_LRU
>  	bool "Add LRU list to track non-evictable pages"
>  	default y
> -	depends on MMU
>  	help
>  	  Keeps unevictable pages off of the active and inactive pageout
>  	  lists, so kswapd will not waste CPU time or have its balancing
> diff --git a/mm/internal.h b/mm/internal.h
> index 478223b..ceaa629 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h

David alread made this portion and it already merged in mmotm.
Don't you work on mmotm?




