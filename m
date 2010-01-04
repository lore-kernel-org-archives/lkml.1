Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680Ab0ADR1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0ADR1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421Ab0ADR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:27:14 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:50241 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0ADR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:27:13 -0500
Date: Mon, 4 Jan 2010 11:27:07 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] slab: initialize unused alien cache entry as NULL at
 alloc_alien_cache().
In-Reply-To: <4B31E9C3.6010109@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001041126340.7191@router.home>
References: <4B30BDA8.1070904@linux.intel.com> <1261521485.3000.1692.camel@calx> <4B31E9C3.6010109@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009, Haicheng Li wrote:

> @@ -966,18 +966,16 @@ static void *alternate_node_alloc(struct kmem_cache *,
> gfp_t);
>  static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
>  {
>  	struct array_cache **ac_ptr;
> -	int memsize = sizeof(void *) * nr_node_ids;
> +	int memsize = sizeof(void *) * MAX_NUMNODES;
>  	int i;

Remove this change and I will ack the patch.

