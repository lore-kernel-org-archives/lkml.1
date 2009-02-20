Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbZBTH31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbZBTH31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZBTH3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:29:17 -0500
Received: from brick.kernel.dk ([93.163.65.50]:7351 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZBTH3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:29:17 -0500
Date: Fri, 20 Feb 2009 08:26:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090220072635.GR29783@kernel.dk>
References: <20090218144105.GZ30821@kernel.dk> <20090219185434.GB24117@infradead.org> <20090219185539.GI29783@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219185539.GI29783@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19 2009, Jens Axboe wrote:
> On Thu, Feb 19 2009, Christoph Hellwig wrote:
> > On Wed, Feb 18, 2009 at 03:41:06PM +0100, Jens Axboe wrote:
> > > Hi Linus,
> > > 
> > > One trivial patch, otherwise it's all bug fixes or regressions. Please
> > > pull.
> > 
> > Any chance you could look into the barrier fail warning spew regression
> > introduced early in the 2.6.29 circle?
> 
> Yep, will get fixed in the next round. There were just a few important
> fixes queued up that I wanted in -rc6.

It seems to work fine for me, tested with a modified sd that doesn't
have barrier support and loop:

Filesystem "sdc1": Disabling barriers, trial barrier write failed
XFS mounting filesystem sdc1

and

Filesystem "loop0": Disabling barriers, trial barrier write failed
XFS mounting filesystem loop0

No extra failure warnings on the barrier IO itself. What device do you
see this on?

-- 
Jens Axboe

