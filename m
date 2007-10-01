Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXJANVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXJANVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbXJANRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:17:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:14751 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbXJANRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:17:07 -0400
Message-ID: <fa686aa40710010617r1c28bef7u41f7da749c361bcb@mail.gmail.com>
Date: Mon, 1 Oct 2007 07:17:06 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH v2 2/6] Sysace: Use the established platform bus api
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
In-Reply-To: <20071001115954.GD5303@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
	 <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
	 <20070930230557.GA17654@infradead.org>
	 <fa686aa40709301633q32c7bd9epf07b5a78acb4380e@mail.gmail.com>
	 <20071001115954.GD5303@kernel.dk>
X-Google-Sender-Auth: 233eb44863134cd3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/07, Jens Axboe <jens.axboe@oracle.com> wrote:
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

Cool, thanks Jens.  I'll generate a patch to unindent the labels this afternoon.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
