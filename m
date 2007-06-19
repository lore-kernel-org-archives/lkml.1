Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXFSRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXFSRU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXFSRUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:20:14 -0400
Received: from verein.lst.de ([213.95.11.210]:51016 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXFSRUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:20:12 -0400
Date: Tue, 19 Jun 2007 19:19:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Message-ID: <20070619171938.GA21935@lst.de>
References: <20070615113919.142332000@pademelon.sonytel.be> <20070615120848.352093000@pademelon.sonytel.be> <20070619054324.GA18542@lst.de> <Pine.LNX.4.62.0706191450120.4069@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0706191450120.4069@pademelon.sonytel.be>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 02:51:25PM +0200, Geert Uytterhoeven wrote:
> On Tue, 19 Jun 2007, Christoph Hellwig wrote:
> > On Fri, Jun 15, 2007 at 01:39:23PM +0200, Geert Uytterhoeven wrote:
> > > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > > 
> > > Add a Disk Storage Driver for the PS3:
> > >   - Implemented as a block device driver with a dynamic major
> > >   - Disk names (and partitions) are of the format ps3d%c(%u)
> > >   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
> > >     doesn't support scatter-gather
> > 
> > Looks good to me.  Only nitpicks are:
> > 
> >  - ps3disk_priv should probably be an inline function instead of a macro
> 
> I used a macro because you can do
> 
>     ps3disk_pri(dev) = ...;

I'm not exactly a fan of macros used as lvalues, but if you really
want this it can go in.

