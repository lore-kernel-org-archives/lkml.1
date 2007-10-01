Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXJAL6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXJAL6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXJAL5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:57:52 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10727 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXJAL5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:57:51 -0400
Date: Mon, 1 Oct 2007 13:59:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [PATCH v2 2/6] Sysace: Use the established platform bus api
Message-ID: <20071001115954.GD5303@kernel.dk>
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net> <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net> <20070930230557.GA17654@infradead.org> <fa686aa40709301633q32c7bd9epf07b5a78acb4380e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40709301633q32c7bd9epf07b5a78acb4380e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30 2007, Grant Likely wrote:
> On 9/30/07, Christoph Hellwig <hch@infradead.org> wrote:
> > On Sun, Sep 30, 2007 at 04:57:09PM -0600, Grant Likely wrote:
> > > +     if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
> > > +             goto err_plat;
> >
> >         rc = platform_driver_register(&ace_platform_driver);
> >         if (rc)
> >                  goto err_plat;
> >
> > please.
> 
> Okay, will do.
> 
> >
> > > +      err_plat:
> > > +     unregister_blkdev(ace_major, "xsysace");
> > > +      err_blk:
> >
> > labels should be indented zero or one space, but not more.
> 
> scripts/Lindent does this.  Originally, I *didn't* have my labels
> indented.  :-)   Does Lindent need to be fixed?

Seems so, if it idents labels.

Just send a fixup patch for that, I'll add your series to the block tree
for 2.6.24.

-- 
Jens Axboe

