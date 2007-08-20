Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXHTSHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXHTSHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbXHTSGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:06:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41635 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751269AbXHTSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:06:52 -0400
Date: Mon, 20 Aug 2007 11:06:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Perches <joe@perches.com>
cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mm/... convert #include "linux/..." to #include
 <linux/...>
In-Reply-To: <1187561983.4200.145.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708201106230.25248@schroedinger.engr.sgi.com>
References: <1187561983.4200.145.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007, Joe Perches wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index a684778..976aeff 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -334,7 +334,7 @@ static __always_inline int index_of(const size_t size)
>  		return i; \
>  	else \
>  		i++;
> -#include "linux/kmalloc_sizes.h"
> +#include <linux/kmalloc_sizes.h>
>  #undef CACHE
>  		__bad_size();
>  	} else

But I think this was done intentionally to point out that the file 
includes is *not* a regular include file.

