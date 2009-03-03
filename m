Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZCCAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZCCAhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZCCAhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:37:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZCCAhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:37:43 -0500
Date: Mon, 2 Mar 2009 16:37:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] byteorder: add load/store_{endian} API
In-Reply-To: <1236039944.5756.19.camel@brick>
Message-ID: <alpine.LFD.2.00.0903021632320.3111@localhost.localdomain>
References: <1236038817.5756.11.camel@brick>  <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain> <1236039944.5756.19.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Harvey Harrison wrote:
>
> Although gcc (4.4) grew support for __builtin_constant_p in static 
> inlines, older gcc's don't, so we would lose that with essentially all 
> current compilers.

We've used __builtin_constant_p in inline functions for a long time.

Look at kmalloc() in <linux/slab_dev.h>.

I do agree that it's a "new" feature, but I don't think it's _that_ new. I 
think it goes back to something like 3.2 rather than 4.4.

Although I also would not be surprised if this is one of those "gcc 
version of the day" things, where some versions do it, others don't.

So it's quite possible that it depends a bit on just how many dead cats 
you have offered, and whether you ran widdershins or turnwise around the 
computer when you turned it on.

		Linus
