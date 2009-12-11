Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZLKDik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZLKDik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZLKDij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:38:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZLKDii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:38:38 -0500
Message-ID: <4B21BEAF.8090402@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 11:38:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing: Define kmem_trace_alloc_notrace unconditionally
References: <4B21BA6F.2080508@cn.fujitsu.com>
In-Reply-To: <4B21BA6F.2080508@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Always define kmem_trace_alloc_{,node}_notrace(), otherwise
> perf-kmem will show wrong stats ifndef CONFIG_KMEMTRACE,
> because a kmalloc() memory allocation may be traced by
> both trace_kmalloc and trace_kmem_cache_alloc.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/slab_def.h |   24 ++----------------------
>  include/linux/slub_def.h |   27 +++------------------------
>  mm/slab.c                |    4 ----
>  mm/slub.c                |    4 ----
>  4 files changed, 5 insertions(+), 54 deletions(-)
> 

Sorry, please ignore this patch. I'll send a v2 soon..

