Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbZLKH4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbZLKH4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbZLKH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:56:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47360 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbZLKH4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:56:14 -0500
Date: Fri, 11 Dec 2009 08:56:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/2] tracing: Define kmem_cache_alloc_notrace ifdef
 CONFIG_TRACING
Message-ID: <20091211075604.GC31149@elte.hu>
References: <4B21F89A.7000801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B21F89A.7000801@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Define kmem_trace_alloc_{,node}_notrace() if CONFIG_TRACING is
> enabled, otherwise perf-kmem will show wrong stats ifndef
> CONFIG_KMEM_TRACE, because a kmalloc() memory allocation may
> be traced by both trace_kmalloc() and trace_kmem_cache_alloc().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/slab_def.h |    4 ++--
>  include/linux/slub_def.h |    4 ++--
>  mm/slab.c                |    6 +++---
>  mm/slub.c                |    4 ++--
>  4 files changed, 9 insertions(+), 9 deletions(-)

Pekka, can i add your Reviewed-by or Acked-by to this v2 version of the 
patch?

Thanks,

	Ingo
