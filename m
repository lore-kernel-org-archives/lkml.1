Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZHMRIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZHMRIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZHMRIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:08:35 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:63712 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbZHMRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:08:29 -0400
Date: Thu, 13 Aug 2009 19:08:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: inlined spinlocks on sparc64
Message-ID: <20090813170818.GA5117@osiris.boeblingen.de.ibm.com>
References: <20090813082058.GX12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813082058.GX12579@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:20:58AM +0200, Jens Axboe wrote:
> Hi,
> 
> I deleted the original thread, so I can't reply there. Just a heads up
> on the spinlock inlining on sparc64. I decided to give your patches a
> shot, since one of my IO benchmarks here basically degenerates into a
> spinlock microbenchmark with > 50% time spent there (unlock part,
> according to perf). Some of that is surely caching effects, but still.
> 
> For this particular workload, I get a net improvement of about 3.5% with
> the inlined functions. Not bad.

That sounds good! Btw. Andrew added the patches to his -mm tree, so it
looks like the patches will be merged during the next merge window.
