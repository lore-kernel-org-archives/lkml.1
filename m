Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXHFSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXHFSkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXHFSkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:40:37 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21353 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbXHFSke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:40:34 -0400
X-IronPort-AV: E=Sophos;i="4.19,225,1183359600"; 
   d="scan'208";a="89579030"
Subject: Re: NFSv4 poops itself
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070806134030.GA5990@fieldses.org>
References: <46A9EAB0.3090306@garzik.org>
	 <1185543187.6586.10.camel@localhost> <1185556178.6586.40.camel@localhost>
	 <46AA2872.9040800@garzik.org> <1185557340.6586.51.camel@localhost>
	 <20070803191336.GA14682@fieldses.org>  <20070806134030.GA5990@fieldses.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Mon, 06 Aug 2007 14:40:32 -0400
Message-Id: <1186425632.6616.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 06 Aug 2007 18:40:33.0007 (UTC) FILETIME=[455277F0:01C7D859]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 09:40 -0400, J. Bruce Fields wrote:
> On Fri, Aug 03, 2007 at 03:13:36PM -0400, J. Bruce Fields wrote:
> > On Fri, Jul 27, 2007 at 01:29:00PM -0400, Trond Myklebust wrote:
> > > On Fri, 2007-07-27 at 13:16 -0400, Jeff Garzik wrote:
> > > > Trond Myklebust wrote:
> > > > > Jeff and Bruce, could you please try to reproduce the problem after
> > > > > either applying patches 001 to 004 or just the single NFS_ALL patch
> > > > > from 
> > > > > 
> > > > >    http://client.linux-nfs.org/Linux-2.6.x/2.6.23-rc1/
> > > > 
> > > > 
> > > > It's not easily reproducible here.  Any hints on triggering the behavior?
> > > 
> > > I suspect that the problem may involve mixing O_RDWR with O_RDONLY
> > > and/or O_WRONLY file access. Bruce might have a better suggestion,
> > > though.
> > 
> > I haven't done any more work to identify when exactly the problem is
> > triggered, but I did confirm that I could reproduce the problem reliably
> > with current git, but *not* with current git plus your 4-patch nfs-all.
> 
> And that result still holds after using the patched kernel for several
> more hours.

Thanks Bruce!
  Trond
