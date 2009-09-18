Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZIRUIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZIRUIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbZIRUIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:08:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52236 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbZIRUIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:08:00 -0400
Date: Fri, 18 Sep 2009 22:08:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle Moffett <kyle@moffetthome.net>, Lars Marowsky-Bree <lmb@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090918200803.GM23126@kernel.dk>
References: <200909151645.14256.philipp.reisner@linbit.com> <20090915231931.GB7636@infradead.org> <20090917081251.GC8045@barkeeper1-xen.linbit> <1253203365.7845.14.camel@mulgrave.site> <20090917161108.GA3361@infradead.org> <19122.65335.126937.476968@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19122.65335.126937.476968@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Neil Brown wrote:
> On Thursday September 17, hch@infradead.org wrote:
> > On Thu, Sep 17, 2009 at 10:02:45AM -0600, James Bottomley wrote:
> > > So I think Christoph's NAK is rooted in the fact that we have a
> > > proliferation of in-kernel RAID implementations and he's trying to
> > > reunify them all again.
> > > 
> > > As part of the review, reusing the kernel RAID (and actually logging)
> > > logic did come up and you added it to your todo list.  Perhaps expanding
> > > on the status of that would help, since what's being looked for is that
> > > you're not adding more work to the RAID reunification effort and that
> > > you do have a plan and preferably a time frame for coming into sync with
> > > it.
> > 
> > Yes.  RDBD has spend tons of time out of tree, and if they want to put
> > it in now I think requiring them to do their homework is a good idea.
> 
> What homework?
> 
> If there was a sensible unifying framework in the kernel that they
> could plug in to, then requiring them do to that might make sense.  But
> there isn't.  You/I/We haven't created a solution (i.e. there is no
> equivalent of the VFS for virtual block devices) and saying that
> because we haven't they cannot merge DRBD hardly seems fair.
> 
> Indeed, merging DRBD must be seen as a *good* thing as we then have
> more examples of differing requirements against which a proposed
> solution can be measured and tested.
> 
> I thought the current attitude was "merge then fix".  That is what the
> drivers/staging tree seems to be all about.  Maybe you could argue
> that DRBD should go in to 'staging' first (though I don't think that
> is appropriate or require myself), but keeping it out just seems
> wrong.

FWIW, I agree with Neil here. If drbd is merge clean, lets go ahead and
merge it. While it would be nice to offload the raid unification onto
drbd, it's not exactly fair.

-- 
Jens Axboe

