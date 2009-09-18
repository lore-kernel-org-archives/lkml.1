Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZIRUML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZIRUML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZIRUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:12:03 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:45140 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbZIRUMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:12:02 -0400
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
In-Reply-To: <20090918200530.GL23126@kernel.dk>
References: <20090917194027.GS23126@kernel.dk>
	 <1253229410.2783.16.camel@heimdal.trondhjem.org>
	 <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk>
	 <1253290790.3183.14.camel@heimdal.trondhjem.org>
	 <20090918173608.GD23126@kernel.dk> <20090918183203.GG23126@kernel.dk>
	 <1253299218.3183.84.camel@heimdal.trondhjem.org>
	 <20090918184602.GJ23126@kernel.dk> <20090918200157.GK23126@kernel.dk>
	 <20090918200530.GL23126@kernel.dk>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 16:11:58 -0400
Message-Id: <1253304721.3183.97.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 1487 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 68B8F310380CDE25D35D0E7DDA57B133C91519EE
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 27 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 22:05 +0200, Jens Axboe wrote:
> On Fri, Sep 18 2009, Jens Axboe wrote:
> > On Fri, Sep 18 2009, Jens Axboe wrote:
> > > On Fri, Sep 18 2009, Trond Myklebust wrote:
> > > > On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> > > > > How does this look? It compiles, but I cannot test before sunday. It
> > > > > would be great if you (or someone else) could :-). Peter, if you have
> > > > > the time, it would be nice if you could check whether this one works for
> > > > > you too.
> > > > > 
> > > > > diffstat is tasty, too:
> > > > > 
> > > > >  client.c |    4 ----
> > > > >  super.c  |   53 ++++++++++++++++++++++++++---------------------------
> > > > >  2 files changed, 26 insertions(+), 31 deletions(-)
> > > > 
> > > > Yep! The patch looks good to me. I'll see if I can find the time to test
> > > > it tomorrow.
> > > 
> > > Thanks a lot! I'll try nfs over wifi on the laptop now, since the test
> > > boxes are off.
> > 
> > Took a little longer than it should have, since latest -git breaks my
> > iwl3945. Anyway, it works fine for me. The patch is tentatively
> > committed as:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0841ff4261ae91b01c923be97843753c56a6613a
> 
> Trond, OK if I commit this? It works here, and it definitely doesn't
> make things worse :-)
> 

That would be fine by me.

Cheers
  Trond

