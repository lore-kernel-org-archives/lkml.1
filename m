Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYKJJzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYKJJzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYKJJzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:55:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbYKJJzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:55:37 -0500
Date: Mon, 10 Nov 2008 01:55:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
Message-Id: <20081110015511.453a801e.akpm@linux-foundation.org>
In-Reply-To: <20081110094033.GL22392@elte.hu>
References: <20081106101715.GA4022@elte.hu>
	<4913B45C.1000009@kernel.org>
	<20081107081249.GB4435@elte.hu>
	<4913F9AA.80500@kernel.org>
	<20081107084240.GG4435@elte.hu>
	<491434FB.2050904@kernel.org>
	<20081107124957.GA21709@elte.hu>
	<49168BD3.5010204@kernel.org>
	<20081109073813.GA17180@elte.hu>
	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	<20081110094033.GL22392@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 10:40:33 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> > >> @@ -987,6 +988,8 @@ void __init mem_init(void)
> > >>
> > >>       set_highmem_pages_init();
> > >>
> > >> +     after_bootmem = 1;
> > >
> > > this hack can go away once we have a proper percpu_alloc() that can be
> > > used early enough.
> > 
> > where is that fancy patch? current percpu_alloc(), will keep big 
> > pointer in array..., instead of put that pointer in percpu_area
> > 
> > 64bit has that after_bootmem already.
> 
> or at least introduce a "bootmem agnostic" allocator instead of 
> open-coding the after_bootmem flag.
> 
> Something like:
> 
>   early_kzalloc()
> 
> ?
> 
> Andrew, any preferences?

My mind reading ain't what it was, and this after_bootmem flag is
write-only in this patch.

So what's all this about?
