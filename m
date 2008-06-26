Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYFZCAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYFZCAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFZCAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:00:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34983 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYFZCAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:00:07 -0400
Date: Thu, 26 Jun 2008 10:57:01 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make register_page_bootmem_info_section() static
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080625162540.GI10285@cs181140183.pp.htv.fi>
References: <20080625162540.GI10285@cs181140183.pp.htv.fi>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080626105530.E3A0.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch makes the needlessly global 
> register_page_bootmem_info_section() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Ah, yes. Thanks!

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> ---
> 
> This patch has been sent on:
> - 5 May 2008
> 
> 070dc3db481a222a79755b6a06fb300f022ff56e diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index b3fd604..6a9a28a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -86,7 +86,7 @@ void put_page_bootmem(struct page *page)
>  
>  }
>  
> -void register_page_bootmem_info_section(unsigned long start_pfn)
> +static void register_page_bootmem_info_section(unsigned long start_pfn)
>  {
>  	unsigned long *usemap, mapsize, section_nr, i;
>  	struct mem_section *ms;
> 

-- 
Yasunori Goto 


