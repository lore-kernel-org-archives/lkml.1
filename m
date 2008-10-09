Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYJIAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYJIAna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYJIAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:42:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43745 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbYJIAmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:42:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: righi.andrea@gmail.com
Subject: Re: [PATCH] documentation: clarify dirty_ratio and dirty_background_ratio description
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48EC90EC.8060306@gmail.com>
References: <48EC90EC.8060306@gmail.com>
Message-Id: <20081009094134.DEB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  9 Oct 2008 09:42:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current documentation of dirty_ratio and dirty_background_ratio is a
> bit misleading.
> 
> In the documentation we say that they are "a percentage of total system
> memory", but the current page writeback policy, intead, is to apply the
> percentages to the dirtyable memory, that means free pages + reclaimable
> pages.
> 
> Better to be more explicit to clarify this concept.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

looks good to me.



> ---
>  Documentation/filesystems/proc.txt |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index f566ad9..be69c8b 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -1380,15 +1380,16 @@ causes the kernel to prefer to reclaim dentries and inodes.
>  dirty_background_ratio
>  ----------------------
>  
> -Contains, as a percentage of total system memory, the number of pages at which
> -the pdflush background writeback daemon will start writing out dirty data.
> +Contains, as a percentage of the dirtyable system memory (free pages +
> +reclaimable pages), the number of pages at which the pdflush background
> +writeback daemon will start writing out dirty data.
>  
>  dirty_ratio
>  -----------------
>  
> -Contains, as a percentage of total system memory, the number of pages at which
> -a process which is generating disk writes will itself start writing out dirty
> -data.
> +Contains, as a percentage of the dirtyable system memory (free pages +
> +reclaimable pages), the number of pages at which a process which is generating
> +disk writes will itself start writing out dirty data.
>  
>  dirty_writeback_centisecs
>  -------------------------





