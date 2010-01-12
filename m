Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603Ab0ALAyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0ALAyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373Ab0ALAyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:54:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab0ALAyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:54:06 -0500
Date: Mon, 11 Jan 2010 16:53:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg Ungerer <gerg@snapgear.com>
cc: gerg@uclinux.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: change definitions of __pa() and __va()
In-Reply-To: <201001120039.o0C0dboQ031390@goober.internal.moreton.com.au>
Message-ID: <alpine.LFD.2.00.1001111652500.17145@localhost.localdomain>
References: <201001120039.o0C0dboQ031390@goober.internal.moreton.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jan 2010, Greg Ungerer wrote:
> +#else
> +#define page_to_phys(page)	((page - mem_map) << PAGE_SHIFT)
> +#define page_to_bus(page)	((page - mem_map) << PAGE_SHIFT)
> +#endif

Ok, so the old ones were total crap too, but when moving things around, 
don't just copy the crap like this.

Look at those two #define's for five seconds, and ask yourself what is 
wrong with them. Those macros are not good.

			Linus
