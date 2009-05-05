Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZEEIZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZEEIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZEEIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:25:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbZEEIZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:25:45 -0400
Date: Tue, 5 May 2009 10:25:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLQB: Coding style cleanups
Message-ID: <20090505082545.GE30220@wotan.suse.de>
References: <Pine.LNX.4.64.0905031514330.32397@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905031514330.32397@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 03:15:10PM +0300, Pekka Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch cleans up SQLB to make the code checkpatch clean.

Thanks!

> 
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slqb.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> index f538f2c..44a91c0 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -59,7 +59,7 @@ static inline void struct_slqb_page_wrong_size(void)
>  /*
>   * slqb_min_order: minimum allocation order for slabs
>   */
> -static int slqb_min_order = 0;
> +static int slqb_min_order;

I actually like explicit zero initializers. I think it has been
a long time since this actually saved any memory with gcc.

Yes yes, I know that anybody who can "read C" will read the
implicit zero initializer anyway... however I just think it is
a stupid thing for checkpatch to warn against.

