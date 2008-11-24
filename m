Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbYKXHyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbYKXHyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 02:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKXHy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 02:54:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46266 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYKXHy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 02:54:27 -0500
Subject: Re: [PATCH] Update the kmem_cache_create documentation regarding
	the name parameter
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <20081121125622.11468.97451.stgit@pc1117.cambridge.arm.com>
References: <20081121125622.11468.97451.stgit@pc1117.cambridge.arm.com>
Date: Mon, 24 Nov 2008 09:56:04 +0200
Message-Id: <1227513364.3718.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Fri, 2008-11-21 at 12:56 +0000, Catalin Marinas wrote:
> kmem_cache implementations like slub are allowed to merge multiple
> caches but only the initial name is preserved. Therefore,
> kmem_cache_name() is not guaranteed to return the same pointer passed to
> the former function. This patch updates the documentation to make this
> clearer.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Applied, thanks!

> ---
>  mm/slab.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 4887f1b..8924a03 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2124,6 +2124,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
>   *
>   * @name must be valid until the cache is destroyed. This implies that
>   * the module calling this has to destroy the cache before getting unloaded.
> + * Note that kmem_cache_name() is not guaranteed to return the same pointer,
> + * therefore applications must manage it themselves.
>   *
>   * The flags are
>   *
> 

