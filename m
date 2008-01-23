Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbYAWVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbYAWVcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYAWVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:32:05 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:32935 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYAWVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:32:03 -0500
Date: Wed, 23 Jan 2008 22:32:29 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: mel@csn.ul.ie, clameter@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] slab: fix bootstrap on memoryless node
Message-ID: <20080123213229.GA21045@aepfle.de>
References: <Pine.LNX.4.64.0801232119140.11343@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801232119140.11343@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, Pekka J Enberg wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> If the node we're booting on doesn't have memory, bootstrapping kmalloc()
> caches resorts to fallback_alloc() which requires ->nodelists set for all
> nodes.  Fix that by calling set_up_list3s() for CACHE_CACHE in
> kmem_cache_init().
> 
> Tested-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> Olaf, can you please test this against a clean git head with this revert 
> applied before this patch:

Yes, the system boots with both patches applied.
Thanks.
