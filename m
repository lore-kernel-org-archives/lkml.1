Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYKRU7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYKRU7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYKRU6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:58:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYKRU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:58:49 -0500
Date: Tue, 18 Nov 2008 12:58:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       g.liakhovetski@gmx.de, nicolas.ferre@atmel.com
Subject: Re: [PATCH 08/13] dmatest: convert to dma_request_channel
Message-Id: <20081118125840.e3c7745d.akpm@linux-foundation.org>
In-Reply-To: <1227032661.15042.10.camel@dwillia2-linux.ch.intel.com>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	<20081114213458.32354.58258.stgit@dwillia2-linux.ch.intel.com>
	<20081114221704.fe9ea599.akpm@linux-foundation.org>
	<1227032661.15042.10.camel@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 11:24:21 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Ok, so I now have:
> # git shortlog `stg id akpm-review-spell-fixes.patch`^..
> Dan Williams (6):
>       dmaengine review: spelling/grammar fixes
>       dmaengine review: dma_wait_for_async_tx clarification
>       dmaengine review: fix up kernel doc for dma_list_mutex usage
>       dmaengine review: propagate alloc_chan_resources error code
>       dmaengine review: return meaningful error code from initcall
>       dmaengine review: dmatest stop on dmatest_add_channel failure
> 
> May I add your Reviewed-by for these and the original 13.

Sure.  Ignorantly-stared-at-by: would be more appropriate though.

>  I could fold
> these into the originals but perhaps it is better to document fixups
> when they are the result of review [1].

I think that a clean commit trail is more important.  One can always
retain documentation/attributions/etc in the changelog when folding.

