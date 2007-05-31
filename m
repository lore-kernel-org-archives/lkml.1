Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbXEaM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbXEaM2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbXEaM20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:28:26 -0400
Received: from brick.kernel.dk ([80.160.20.94]:27388 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759938AbXEaM2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:28:25 -0400
Date: Thu, 31 May 2007 14:27:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531122723.GT32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531105543.GA25676@infradead.org> <20070531110550.GR32105@kernel.dk> <18014.48878.442628.260297@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18014.48878.442628.260297@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Neil Brown wrote:
> On Thursday May 31, jens.axboe@oracle.com wrote:
> > On Thu, May 31 2007, Christoph Hellwig wrote:
> > > On Thu, May 31, 2007 at 12:33:16PM +0200, Jens Axboe wrote:
> > > > - nfds: The ->rq_sendfile_ok optimization is gone for now. I can't
> > > >   determine the value of it, but I'm assuming it's there for a reason.
> > > >   Any chance this can be converted to splice, or use something else than
> > > >   ->sendfile()? CC'ed Neil.
> > > 
> > > sendfile useage in nfsd avoids a data copy and allows to use checksum
> > > offloading.  it's quite important for nfs server workloads.
> > 
> > OK, I hope Neil can provide some input on how to convert it. Of course
> > I'm just fishing for Neil to actually do that work :-)
> 
> Well, seeing you did that zero-length-barrier thing for me, how can I
> complain :-)
> 
> I'll have a look in the morning.

Woo, thanks Neil :-)

-- 
Jens Axboe

