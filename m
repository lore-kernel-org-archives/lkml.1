Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbZCXLY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbZCXLY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZCXLYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:24:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35193 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664AbZCXLYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:24:45 -0400
Date: Tue, 24 Mar 2009 12:24:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Constantine Sapuntzakis <csapuntz@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, nikanth@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Block - Honour barrier requests in loop driver
Message-ID: <20090324112443.GI27476@kernel.dk>
References: <200903171417.16760.knikanth@suse.de> <20090317190905.GA28816@infradead.org> <200903181028.20689.knikanth@suse.de> <200903241124.36223.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903241124.36223.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24 2009, Nikanth Karthikesan wrote:
> On Wednesday 18 March 2009 10:28:20 Nikanth Karthikesan wrote:
> > On Wednesday 18 March 2009 00:39:05 Christoph Hellwig wrote:
> > > On Tue, Mar 17, 2009 at 05:39:49PM +0530, Nikanth Karthikesan wrote:
> > > > +			if (!file->f_op || !file->f_op->fsync) {
> > > > +				ret = -EOPNOTSUPP;
> > > > +				goto out;
> > > > +			}
> > >
> > > file->f_op is never zero, so you can remove the checks for that.
> > > Otherwise looks good.
> >
> > Thanks for reviewing. I've removed that check.
> >
> > Jens, Can you merge this?
> >
> Hi Jens
> 
> Did you get to look at this? Can you merge this?

Yep, I'll merge it. Thanks!
 

-- 
Jens Axboe

