Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZDVWJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZDVWJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZDVWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:08:52 -0400
Received: from cmpxchg.org ([85.214.51.133]:46574 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbZDVWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:08:51 -0400
Date: Thu, 23 Apr 2009 00:07:19 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Coly Li <coly.li@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 7/7] xtensa: add parameter to ccount_read()
Message-ID: <20090422220719.GA3602@cmpxchg.org>
References: <49EF6C16.9020604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF6C16.9020604@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:12:22AM +0800, Coly Li wrote:
> This patch modifies parameter of au1x_counter1_read() from 'void' to 'struct
> clocksource *cs', which fixes compile warning for incompatible parameter type.

Changelog should be adjusted to say 'ccount_read()' here ;)

> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/xtensa/kernel/time.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
> index 8848120..9638641 100644
> --- a/arch/xtensa/kernel/time.c
> +++ b/arch/xtensa/kernel/time.c
> @@ -30,7 +30,7 @@ unsigned long ccount_per_jiffy;		/* per 1/HZ */
>  unsigned long nsec_per_ccount;		/* nsec per ccount increment */
>  #endif
> 
> -static cycle_t ccount_read(void)
> +static cycle_t ccount_read(struct clocksource *cs)
>  {
>  	return (cycle_t)get_ccount();
>  }

Thanks.  Copied Chris as well.
