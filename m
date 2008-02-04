Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYBDWbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYBDWbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYBDWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:30:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbYBDWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:30:58 -0500
Date: Mon, 4 Feb 2008 14:30:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [git pull] SLUB updates for 2.6.25
Message-Id: <20080204143053.9fac9eac.akpm@linux-foundation.org>
In-Reply-To: <20080204142845.4c734f94.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com>
	<20080204142845.4c734f94.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 14:28:45 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > root (1):
> >       SLUB: Do not upset lockdep
> > 
> 
> err, what?  I though I was going to merge these:
> 
> slub-move-count_partial.patch
> slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
> slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
> slub-use-non-atomic-bit-unlock.patch
> slub-fix-coding-style-violations.patch
> slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
> slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
> slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
> slub-__slab_alloc-exit-path-consolidation.patch
> slub-provide-unique-end-marker-for-each-slab.patch
> slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
> slub-optional-fast-path-using-cmpxchg_local.patch
> slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
> slub-restructure-slab-alloc.patch
> slub-comment-kmem_cache_cpu-structure.patch
> slub-fix-sysfs-refcounting.patch
> 
> before you went and changed things under my feet.

erk, sorry, I misremembered.   I was about to merge all the patches we
weren't going to merge.  oops.

Linus, please proceed with this merge.
