Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbZHSIu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbZHSIu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbZHSIu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:50:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45227 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZHSIu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:50:27 -0400
Date: Wed, 19 Aug 2009 10:50:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: w@1wt.eu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] splice: update mtime and atime on files
Message-ID: <20090819085028.GU12579@kernel.dk>
References: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu> <20090815064241.GE12579@kernel.dk> <20090818050027.GE11624@1wt.eu> <20090818083547.GK12579@kernel.dk> <20090818084625.GF18709@1wt.eu> <20090818085051.GM12579@kernel.dk> <E1MdNM6-0003y3-4t@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MdNM6-0003y3-4t@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18 2009, Miklos Szeredi wrote:
> On Tue, 18 Aug 2009, Jens Axboe wrote:
> > I've never heard anyone complain about this, and I suspect that Miklos
> > found it from code inspection rather than experiencing an issue with it.
> 
> Right, I found it by code inspection.
> 
> > So while it can indeed be classified as a bug (and it is), the impact is
> > not huge.
> > 
> > That said, I don't have a huge issue with shoving this in -stable. I
> > just don't think it's a big deal.
> 
> I agree that it's not a huge issue, however it might be worth it to
> add it to -stable for the sake of distro kernels which are usually
> based on the long term stable branch.  If new apps start to use the
> splice interface then we want those to work well on distros as well as
> the latest kernel.org kernels.

As I said, I don't have a problem with adding it to -stable, even if it
isn't a critical issue. The patch is straight forward and fixes a real
issue, so risk is low (and benefit high).

-- 
Jens Axboe

