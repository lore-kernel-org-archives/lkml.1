Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbZE0GpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbZE0GpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbZE0GpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:45:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51303 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbZE0GpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:45:03 -0400
Date: Wed, 27 May 2009 15:43:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] memcg: fix swap account (26/May)[0/5]
Message-Id: <20090527154327.0926fc23.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 12:12:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> [1/5] change interface of swap_duplicate()/swap_free()
>     Adds an function swapcache_prepare() and swapcache_free().
> 
> [2/5] add SWAP_HAS_CACHE flag to swap_map
>     Add SWAP_HAS_CACHE flag to swap_map array for knowing an information that
>     "there is an only swap cache and swap has no reference" 
>     without calling find_get_page().
> 
> [3/5] Count the number of swap-cache-only swaps
>     After repeating swap-in/out, there are tons of cache-only swaps.
>    (via a mapped swapcache under vm_swap_full()==false)
>     This patch counts the number of entry and show it in debug information.
>    (for example, sysrq-m)
> 
> [4/5] fix memcg's swap accounting.
>     change the memcg's swap accounting logic to see # of references to swap.
> 
> [5/5] experimental garbage collection for cache-only swaps.
>     reclaim swap enty which is not used.
> 

Thank you for all reviews. I'll repost when new mmotm comes. 
maybe
[1/5] ... nochage
[2/5] ... fix the bug Nishimura-san pointed out
[3/5] ... drop
[4/5] ... no change
[5/5] ... will use direct reclaim in get_swap_page().

Thanks,
-Kame

