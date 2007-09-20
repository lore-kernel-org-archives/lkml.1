Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXITKF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXITKF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbXITKFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:05:51 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42517 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbXITKFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:05:51 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 06:05:50 EDT
To: akpm@linux-foundation.org
CC: haveblue@us.ibm.com, hch@infradead.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <20070919150659.597f0d8b.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 19 Sep 2007 15:06:59 -0700)
Subject: Re: [PATCH 00/24] Read-only bind mounts
References: <20070917182718.70494C9B@kernel>
	<20070919174418.GA22982@infradead.org>
	<20070919142437.7490b219.akpm@linux-foundation.org>
	<1190238987.26982.119.camel@localhost> <20070919150659.597f0d8b.akpm@linux-foundation.org>
Message-Id: <E1IYInb-0000hR-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 Sep 2007 11:58:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 19 Sep 2007 14:56:27 -0700
> Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> > On Wed, 2007-09-19 at 14:24 -0700, Andrew Morton wrote:
> > > On Wed, 19 Sep 2007 18:44:18 +0100
> > > Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > > On Mon, Sep 17, 2007 at 11:27:18AM -0700, Dave Hansen wrote:
> > > > > If we can't pull the entire series into -mm, can we just put the
> > > > > first three patches for now?  They can stand on their own.
> > > > 
> > > > Yes, they're kinda a series of their own.  But I still think we really
> > > > want this in -mm.  As we've seen on the kernel summit there's a pretty
> > > > desparate need for it.  And there's not many changes in this area in
> > > > -mm, maybe the unprivilegued mounts.  I'd personally prioritize the
> > > > r/o bindmounts over them as they're more needed and we need more reviewing
> > > > of the unprivilegued mounts (I'll try to come back to that soon).
> > > 
> > > What's the situation on unprivileged mounts?  iirc, it's all a bit stuck.
> > > 
> > > If unpriv-mounts code isn't going to go into mainline ahead of r/o bind
> > > mounts then it'd make a big mess to prepare the r/o bind mount patches on
> > > top of unprivileged mounts.
> > > 
> > > It sounds like a better approach would be for me to merge the r/o bind
> > > mounts code and to drop (or maybe rework) the unprivileged mounts patches
> > 
> > I actually don't think they collided too much.  There were a couple of
> > patches, like maybe 2 or 3 that needed any futzing at all.  
> > 
> > I'll cook up a set straight on top of mainline if that helps.
> > 
> 
> That sounds good, thanks.

I agree, that per mount r/o is more important than unprivileged
mounts.  Especially because fixing up mount(8) and option showing in
/proc/mounts is really nowhere yet, both of which are needed to make
unprivileged mounting really useful.

So if that's convenient for you, just drop the unpriv mount patches,
and I'll resubmit sometime later.

Miklos
