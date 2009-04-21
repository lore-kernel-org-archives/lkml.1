Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZDUIE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZDUIE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZDUIEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:04:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43112 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZDUIEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:04:06 -0400
Subject: Re: [PATCH 24/25] Re-sort GFP flags and fix whitespace alignment
 for easier reading.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-25-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-25-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 11:04:03 +0300
Message-Id: <1240301043.771.56.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:20 +0100, Mel Gorman wrote:
> Resort the GFP flags after __GFP_MOVABLE got redefined so how the bits
> are used are a bit cleared.

I'm confused. AFAICT, this patch just fixes up some whitespace issues
but doesn't actually "sort" anything?

> 
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The "From" tag should be the first line of the patch.

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/linux/gfp.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index c7429b8..cfc1dd3 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -47,11 +47,11 @@ struct vm_area_struct;
>  #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
>  #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
>  #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
> -#define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
> -#define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
> -#define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
> +#define __GFP_NOMEMALLOC  ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
> +#define __GFP_HARDWALL    ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
> +#define __GFP_THISNODE	  ((__force gfp_t)0x40000u) /* No fallback, no policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
> -#define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> +#define __GFP_MOVABLE	  ((__force gfp_t)0x100000u)/* Page is movable */
>  
>  #define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))

