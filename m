Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZEVITY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZEVITY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZEVITP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:19:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55694 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZEVITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:19:13 -0400
Date: Fri, 22 May 2009 17:17:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: remove forward declaration from sched.h
Message-Id: <20090522171737.e9916d1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A1645D4.5010001@cn.fujitsu.com>
References: <4A1645D4.5010001@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 14:27:32 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> This forward declaration seems pointless.
> 
> compile tested.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Nice catch. (but I don't know why this sneaked into..)
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  sched.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/include/linux/sched.h	2009-05-22 13:43:01.000000000 +0800
> +++ b/include/linux/sched.h	2009-05-22 13:38:59.000000000 +0800
> @@ -93,7 +93,6 @@ struct sched_param {
>  
>  #include <asm/processor.h>
>  
> -struct mem_cgroup;
>  struct exec_domain;
>  struct futex_pi_state;
>  struct robust_list_head;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

