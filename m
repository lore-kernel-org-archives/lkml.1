Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbXISV4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbXISV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXISV4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:56:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47400 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbXISV4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:56:30 -0400
Subject: Re: [PATCH 00/24] Read-only bind mounts
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <20070919142437.7490b219.akpm@linux-foundation.org>
References: <20070917182718.70494C9B@kernel>
	 <20070919174418.GA22982@infradead.org>
	 <20070919142437.7490b219.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 14:56:27 -0700
Message-Id: <1190238987.26982.119.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 14:24 -0700, Andrew Morton wrote:
> On Wed, 19 Sep 2007 18:44:18 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Sep 17, 2007 at 11:27:18AM -0700, Dave Hansen wrote:
> > > If we can't pull the entire series into -mm, can we just put the
> > > first three patches for now?  They can stand on their own.
> > 
> > Yes, they're kinda a series of their own.  But I still think we really
> > want this in -mm.  As we've seen on the kernel summit there's a pretty
> > desparate need for it.  And there's not many changes in this area in
> > -mm, maybe the unprivilegued mounts.  I'd personally prioritize the
> > r/o bindmounts over them as they're more needed and we need more reviewing
> > of the unprivilegued mounts (I'll try to come back to that soon).
> 
> What's the situation on unprivileged mounts?  iirc, it's all a bit stuck.
> 
> If unpriv-mounts code isn't going to go into mainline ahead of r/o bind
> mounts then it'd make a big mess to prepare the r/o bind mount patches on
> top of unprivileged mounts.
> 
> It sounds like a better approach would be for me to merge the r/o bind
> mounts code and to drop (or maybe rework) the unprivileged mounts patches

I actually don't think they collided too much.  There were a couple of
patches, like maybe 2 or 3 that needed any futzing at all.  

I'll cook up a set straight on top of mainline if that helps.

-- Dave

