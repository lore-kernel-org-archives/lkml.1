Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYKQFb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYKQFb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYKQFbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:31:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44075 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYKQFbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:31:17 -0500
Date: Mon, 17 Nov 2008 14:30:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: Fix typo in swap cgroup message
Message-Id: <20081117143035.58e7aa62.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081117044008.GA25269@balbir.in.ibm.com>
References: <20081117044008.GA25269@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 10:10:08 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> There is a typo in the spelling of buffers (buffres) and the message is
> not very clear either. Fix the message and typo (hopefully not introducing
> any new ones ;) )
> 
(>_< thanks, I found my private aspell dict includes "buffres"...

-Kame

> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  mm/page_cgroup.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN mm/page_cgroup.c~fix-typo-swap-cgroup mm/page_cgroup.c
> --- linux-2.6.28-rc4/mm/page_cgroup.c~fix-typo-swap-cgroup	2008-11-16 20:03:28.000000000 +0530
> +++ linux-2.6.28-rc4-balbir/mm/page_cgroup.c	2008-11-17 09:59:43.000000000 +0530
> @@ -423,7 +423,8 @@ int swap_cgroup_swapon(int type, unsigne
>  	mutex_unlock(&swap_cgroup_mutex);
>  
>  	printk(KERN_INFO
> -		"swap_cgroup: uses %ld bytes vmalloc and %ld bytes buffres\n",
> +		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
> +		" and %ld bytes to hold mem_cgroup pointers on swap\n",
>  		array_size, length * PAGE_SIZE);
>  	printk(KERN_INFO
>  	"swap_cgroup can be disabled by noswapaccount boot option.\n");
> _
> 
> -- 
> 	Balbir
> 

