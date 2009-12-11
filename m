Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZLKIGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZLKIGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbZLKIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:06:14 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34921 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760686AbZLKIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:06:13 -0500
Message-ID: <4B21FD7A.9010006@cs.helsinki.fi>
Date: Fri, 11 Dec 2009 10:06:18 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/2] tracing: Define kmem_cache_alloc_notrace ifdef CONFIG_TRACING
References: <4B21F89A.7000801@cn.fujitsu.com>
In-Reply-To: <4B21F89A.7000801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan kirjoitti:
> Define kmem_trace_alloc_{,node}_notrace() if CONFIG_TRACING is
> enabled, otherwise perf-kmem will show wrong stats ifndef
> CONFIG_KMEM_TRACE, because a kmalloc() memory allocation may
> be traced by both trace_kmalloc() and trace_kmem_cache_alloc().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
