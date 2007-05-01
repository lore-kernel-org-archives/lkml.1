Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXEAIC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXEAIC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbXEAIC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:02:29 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5989 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbXEAIC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:02:27 -0400
Date: Tue, 1 May 2007 10:01:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070501080151.GS21015@kernel.dk>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <17973.44824.631204.926723@notabene.brown> <20070430085916.GA31397@infradead.org> <20070430113044.GJ21015@kernel.dk> <17974.31415.121135.794681@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17974.31415.121135.794681@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01 2007, Neil Brown wrote:
> On Monday April 30, jens.axboe@oracle.com wrote:
> > On Mon, Apr 30 2007, Christoph Hellwig wrote:
> > > On Mon, Apr 30, 2007 at 06:55:52PM +1000, Neil Brown wrote:
> > > > On Saturday April 28, zlynx@acm.org wrote:
> > > > > On Sat, 2007-04-28 at 21:19 +0200, Adrian Bunk wrote:
> > > > > > 4k stacks have become a well-tested feature used fore a long time in
> > > > > > Fedora and even in RHEL 4.
> > > > > 
> > > > > So has anyone fixed the bugs involving ext3 and LVM snapshots on top of
> > > > > DM mirror?
> > > > 
> > > > Well -mm has a patch which makes stacked block devices much less of an
> > > > issue, but this hasn't made it -linus yet - I think the dm developer
> > > > isn't happy that dm works properly with it.
> > > 
> > > I get a little tired about this objection.  If the particular dm code
> > > was racy before and this can in theory make it worse it's their problem,
> > > and putting in perfectly fine code will give them an incentive to
> > > fix their year old race.
> > 
> > Agree, Neil would you mind if I merged the patch?
> 
> I am perfectly happy with this patch being merged - yes.

Ok, queued for inclusion.

-- 
Jens Axboe

