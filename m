Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZIYDKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZIYDKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZIYDKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:10:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48611 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZIYDKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:10:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Sep 2009 12:08:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] nommu: Correct is_vmamloc_or_module_addr() definition.
Message-Id: <20090925120830.c010bc71.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090925030706.GE12099@linux-sh.org>
References: <20090925030706.GE12099@linux-sh.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 12:07:06 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> Commit 81ac3ad9061dd9cd490ee92f0c5316a14d77ce18 broke the nommu build
> due to is_vmalloc_or_module_addr() not being marked inline. Fix it up.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Ah, sorry. I think Andrew queues the same patch.

Thanks,
-Kame


> ---
> 
>  include/linux/mm.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b6eae5e..23e7fd6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -288,7 +288,7 @@ static inline int is_vmalloc_addr(const void *x)
>  #ifdef CONFIG_MMU
>  extern int is_vmalloc_or_module_addr(const void *x);
>  #else
> -static int is_vmalloc_or_module_addr(const void *x)
> +static inline int is_vmalloc_or_module_addr(const void *x)
>  {
>  	return 0;
>  }
> 

