Return-Path: <linux-kernel-owner+w=401wt.eu-S934876AbXGRSqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876AbXGRSqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXGRSqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:46:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51742 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXGRSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:46:08 -0400
Date: Wed, 18 Jul 2007 19:45:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
In-Reply-To: <20070718182456.GE11657@kernel.dk>
Message-ID: <Pine.LNX.4.64.0707181942140.13919@blonde.wat.veritas.com>
References: <20070718141533.GA11657@kernel.dk>
 <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
 <20070718182456.GE11657@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAamVucy5heGJvZUBvcmFjbGUuY29tAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Jens Axboe wrote:
> 
> OK, you clearly have more knowledge in that area than I, but I do wish
> that you would have made a note in the code at least to remove things
> like this. It's pretty ugly to have superflous tests like that,
> especially since there was not even a comment saying _why_ you could not
> call set_page_dirty() on a compound page. I see it in the commit text,
> but nobody looking at fs/bio.c or fs/direct-io.c would directly find any
> reference of that.
> 
> Could you submit a patch removing the tests?

Okay, I'll do that - once I've reminded myself how to test it and done so!

Hugh
