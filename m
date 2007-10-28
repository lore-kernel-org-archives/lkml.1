Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbXJ1NMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbXJ1NMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXJ1NMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:12:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48882 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXJ1NMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:12:31 -0400
Date: Sun, 28 Oct 2007 15:12:29 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 07/10] SLUB: Avoid referencing kmem_cache structure in
 __slab_alloc
In-Reply-To: <20071028033259.992768446@sgi.com>
Message-ID: <Pine.LNX.4.64.0710281512160.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033259.992768446@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Christoph Lameter wrote:
> There is the need to use the objects per slab in the first part of
> __slab_alloc() which is still pretty hot. Copy the number of objects
> per slab into the kmem_cache_cpu structure. That way we can get the
> value from a cache line that we already need to touch. This brings
> the kmem_cache_cpu structure up to 4 even words.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
