Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbXJBQWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbXJBQWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXJBQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:22:30 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55186 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXJBQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:22:29 -0400
Date: Tue, 2 Oct 2007 17:21:53 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: new aops merge [was Re: -mm merge plans for 2.6.24]
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710021706280.4916@blonde.wat.veritas.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andrew Morton wrote:
> fs-introduce-write_begin-write_end-and-perform_write-aops.patch
> introduce-write_begin-write_end-aops-important-fix.patch
> introduce-write_begin-write_end-aops-fix2.patch
> deny-partial-write-for-loop-dev-fd.patch
> mm-restore-kernel_ds-optimisations.patch
> implement-simple-fs-aops.patch
> implement-simple-fs-aops-fix.patch
> ...
> fs-remove-some-aop_truncated_page.patch
> 
>   Merge

Good, fine by me; but forces me to confess, with abject shame,
that I still haven't sent you some shmem/tmpfs fixes/cleanups
(currently intermingled with some other stuff in my tree, I'm
still disentangling).  Nothing so bad as to mess up a bisection,
but my loop-over-tmpfs tests hang without passing gfp_mask down
and down to add_to_swap_cache; and a few other bits.  I'll get
back on to it.

Hugh
