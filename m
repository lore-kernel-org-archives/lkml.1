Return-Path: <linux-kernel-owner+w=401wt.eu-S1423360AbXDYSJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423360AbXDYSJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161808AbXDYSJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:09:03 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4867 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161800AbXDYSJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:09:01 -0400
Date: Wed, 25 Apr 2007 20:05:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070425180528.GH4730@kernel.dk>
References: <20070424222105.883597089@sgi.com> <20070425113530.GX9715@kernel.dk> <Pine.LNX.4.64.0704250833240.24452@schroedinger.engr.sgi.com> <20070425175335.GG4730@kernel.dk> <Pine.LNX.4.64.0704251101490.21918@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704251101490.21918@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Christoph Lameter wrote:
> On Wed, 25 Apr 2007, Jens Axboe wrote:
> 
> > > Impossible. page is not dereferenced. Cannot cause a NULL pointer 
> > > deference.
> > 
> > Sure I know that, hence the oops happening there is likely fallout from
> > something scribbling where it should not have.
> 
> Hmmm... Must be a big scribble. And you are sure that no bouncing or 
> highmem stuff is done? Any way to figure out what that is?

2038MB LOWMEM available.

All of memory is lowmem. There are no bounces going on, for sure.

-- 
Jens Axboe

