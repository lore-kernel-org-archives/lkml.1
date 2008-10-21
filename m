Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYJUDkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYJUDkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 23:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYJUDkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 23:40:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45340 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJUDka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 23:40:30 -0400
Date: Tue, 21 Oct 2008 12:40:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_cgroup needs linux/vmalloc.h for
 vmalloc_node()/vfree().
Message-Id: <20081021124001.20cd3a8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081021033623.GA29105@linux-sh.org>
References: <20081021033623.GA29105@linux-sh.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 12:36:23 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> Trivial build fix for:
> 
>   CC      mm/page_cgroup.o
> mm/page_cgroup.c: In function 'init_section_page_cgroup':
> mm/page_cgroup.c:111: error: implicit declaration of function 'vmalloc_node'
> mm/page_cgroup.c:111: warning: assignment makes pointer from integer without a cast
> mm/page_cgroup.c: In function '__free_page_cgroup':
> mm/page_cgroup.c:140: error: implicit declaration of function 'vfree'
> make[1]: *** [mm/page_cgroup.o] Error 1
> make: *** [mm/page_cgroup.o] Error 2
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
Oh, thanks

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> 
>  mm/page_cgroup.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 5d86550..78242b4 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -5,6 +5,7 @@
>  #include <linux/page_cgroup.h>
>  #include <linux/hash.h>
>  #include <linux/memory.h>
> +#include <linux/vmalloc.h>
>  
>  static void __meminit
>  __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
> 

