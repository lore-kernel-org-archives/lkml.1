Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZKZHYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZKZHYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZKZHYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:24:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51160 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZKZHYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:24:37 -0500
Message-ID: <4B0E2D3A.1030509@cs.helsinki.fi>
Date: Thu, 26 Nov 2009 09:24:42 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/9] tracing: Convert some kmem events to DEFINE_EVENT
References: <4B0E2807.4060102@cn.fujitsu.com> <4B0E286A.2000405@cn.fujitsu.com>
In-Reply-To: <4B0E286A.2000405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan kirjoitti:
> Use TRACE_EVENT_TEMPLATE to remove duplicate code:
> 
>    text    data     bss     dec     hex filename
>  333987   69800   27228  431015   693a7 mm/built-in.o.old
>  330030   69800   27228  427058   68432 mm/built-in.o
> 
> 8 events are converted:
> 
>   kmem_alloc: kmalloc, kmem_cache_alloc
>   kmem_alloc_node: kmalloc_node, kmem_cache_alloc_node
>   kmem_free: kfree, kmem_cache_free
>   mm_page: mm_page_alloc_zone_locked, mm_page_pcpu_drain
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I have no idea what TRACE_EVENT_TEMPLATE is but the space savings are 
convincing enough! I assume this is going into -tip?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
