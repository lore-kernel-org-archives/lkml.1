Return-Path: <linux-kernel-owner+w=401wt.eu-S936102AbXGRSua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936102AbXGRSua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbXGRSuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:50:23 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4197 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761134AbXGRSuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:50:23 -0400
Date: Wed, 18 Jul 2007 20:49:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
Message-ID: <20070718184958.GH11657@kernel.dk>
References: <20070718141533.GA11657@kernel.dk> <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com> <20070718182456.GE11657@kernel.dk> <Pine.LNX.4.64.0707181942140.13919@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707181942140.13919@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, Hugh Dickins wrote:
> On Wed, 18 Jul 2007, Jens Axboe wrote:
> > 
> > OK, you clearly have more knowledge in that area than I, but I do wish
> > that you would have made a note in the code at least to remove things
> > like this. It's pretty ugly to have superflous tests like that,
> > especially since there was not even a comment saying _why_ you could not
> > call set_page_dirty() on a compound page. I see it in the commit text,
> > but nobody looking at fs/bio.c or fs/direct-io.c would directly find any
> > reference of that.
> > 
> > Could you submit a patch removing the tests?
> 
> Okay, I'll do that - once I've reminded myself how to test it and done so!

I'll do a test on this tomorrow and let you know what the results are! I
should be able to do a quick fio job file for this, no need to write
test cases :-)

-- 
Jens Axboe

