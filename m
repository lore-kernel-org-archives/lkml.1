Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYLBJGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYLBJGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYLBJFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:05:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51312 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYLBJFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:05:54 -0500
Date: Tue, 2 Dec 2008 18:05:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 10/11] memcg: show inactive_ratio
Message-Id: <20081202180502.10ad4b42.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201211817.1CE8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081201211817.1CE8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Dec 2008 21:19:08 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> add inactive_ratio field to memory.stat file.
> it is useful for memcg reclam debugging.
> 
Hmm...it seems no requirement for showing this in usual use.
I'll put this under CONFIG_DEBUG_VM.

Thanks,
-Kame

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: b/mm/memcontrol.c
> ===================================================================
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1796,6 +1796,9 @@ static int mem_control_stat_show(struct 
>  		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
>  
>  	}
> +
> +	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
> +
>  	return 0;
>  }
>  
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

