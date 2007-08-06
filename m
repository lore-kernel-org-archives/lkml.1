Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXHFNko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXHFNko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760255AbXHFNkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:40:36 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58273 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760302AbXHFNkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:40:36 -0400
Date: Mon, 6 Aug 2007 09:40:30 -0400
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: NFSv4 poops itself
Message-ID: <20070806134030.GA5990@fieldses.org>
References: <46A9EAB0.3090306@garzik.org> <1185543187.6586.10.camel@localhost> <1185556178.6586.40.camel@localhost> <46AA2872.9040800@garzik.org> <1185557340.6586.51.camel@localhost> <20070803191336.GA14682@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803191336.GA14682@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 03:13:36PM -0400, J. Bruce Fields wrote:
> On Fri, Jul 27, 2007 at 01:29:00PM -0400, Trond Myklebust wrote:
> > On Fri, 2007-07-27 at 13:16 -0400, Jeff Garzik wrote:
> > > Trond Myklebust wrote:
> > > > Jeff and Bruce, could you please try to reproduce the problem after
> > > > either applying patches 001 to 004 or just the single NFS_ALL patch
> > > > from 
> > > > 
> > > >    http://client.linux-nfs.org/Linux-2.6.x/2.6.23-rc1/
> > > 
> > > 
> > > It's not easily reproducible here.  Any hints on triggering the behavior?
> > 
> > I suspect that the problem may involve mixing O_RDWR with O_RDONLY
> > and/or O_WRONLY file access. Bruce might have a better suggestion,
> > though.
> 
> I haven't done any more work to identify when exactly the problem is
> triggered, but I did confirm that I could reproduce the problem reliably
> with current git, but *not* with current git plus your 4-patch nfs-all.

And that result still holds after using the patched kernel for several
more hours.

--b.
