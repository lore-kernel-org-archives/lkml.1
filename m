Return-Path: <linux-kernel-owner+w=401wt.eu-S1763474AbYHFGDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763474AbYHFGDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYHFGDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:03:12 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:41656 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752075AbYHFGDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:03:11 -0400
Date: Wed, 6 Aug 2008 15:02:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix SH7705_CACHE_32KB compilation
Message-ID: <20080806060219.GA2610@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080805153711.GA22895@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805153711.GA22895@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 06:37:11PM +0300, Adrian Bunk wrote:
> This patches compile errors like the following caused by
> commit 51f3547d619956e9b428bfff17004d8f4d259a02
> (sh: Allow SH-3 and SH-5 to use common headers):
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/mm/init.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/init.c: In function 'mem_init':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/init.c:232: error: implicit declaration of function 'p3_cache_init'
> make[2]: *** [arch/sh/mm/init.o] Error 1
> make[1]: *** [arch/sh/mm] Error 2
> ...
>   CC      kernel/fork.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/fork.c: In function 'dup_mmap':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/fork.c:323: error: implicit declaration of function 'flush_dcache_mmap_lock'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/fork.c:325: error: implicit declaration of function 'flush_dcache_mmap_unlock'
> make[2]: *** [kernel/fork.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Applied, thanks.
