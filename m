Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbXJBF7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbXJBF7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXJBF7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:59:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:52959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbXJBF67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:58:59 -0400
Subject: Re: [PATCH v2 2/6] Sysace: Use the established platform bus api
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Christoph Hellwig <hch@infradead.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071001115954.GD5303@kernel.dk>
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
	 <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
	 <20070930230557.GA17654@infradead.org>
	 <fa686aa40709301633q32c7bd9epf07b5a78acb4380e@mail.gmail.com>
	 <20071001115954.GD5303@kernel.dk>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 15:58:30 +1000
Message-Id: <1191304710.6310.97.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-01 at 13:59 +0200, Jens Axboe wrote:
> On Sun, Sep 30 2007, Grant Likely wrote:
> > On 9/30/07, Christoph Hellwig <hch@infradead.org> wrote:
> > > On Sun, Sep 30, 2007 at 04:57:09PM -0600, Grant Likely wrote:
> > > > +     if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
> > > > +             goto err_plat;
> > >
> > >         rc = platform_driver_register(&ace_platform_driver);
> > >         if (rc)
> > >                  goto err_plat;
> > >
> > > please.
> > 
> > Okay, will do.
> > 
> > >
> > > > +      err_plat:
> > > > +     unregister_blkdev(ace_major, "xsysace");
> > > > +      err_blk:
> > >
> > > labels should be indented zero or one space, but not more.
> > 
> > scripts/Lindent does this.  Originally, I *didn't* have my labels
> > indented.  :-)   Does Lindent need to be fixed?
> 
> Seems so, if it idents labels.
> 
> Just send a fixup patch for that, I'll add your series to the block tree
> for 2.6.24.

It's actually better off living in the powerpc tree I think as it's
really about adding support for a new powerpc platform and somewhat
needs to sync with other things in there. Unless you really want the
whole thing in your tree :-)

Cheers
Ben.


