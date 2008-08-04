Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYHDSjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYHDSjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbYHDSik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:38:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715AbYHDSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:38:37 -0400
Date: Mon, 4 Aug 2008 11:36:23 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: oliver.pntr@gmail.com, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [RFC, 2.6.26.2-rc1] NFS: Ensure we call
	nfs_sb_deactive() after releasing the directory inode
Message-ID: <20080804183623.GC20191@kroah.com>
References: <ec5c3df63eafa2691665b95e989d7c3c@zipernowsky.hu> <20080802174220.GF615@1wt.eu> <20080804183444.GB20191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804183444.GB20191@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 11:34:44AM -0700, Greg KH wrote:
> On Sat, Aug 02, 2008 at 07:42:20PM +0200, Willy Tarreau wrote:
> > Oliver,
> > 
> > most of your mails are line-wrapped at some locations :
> > 
> > > diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
> > > index 3adf8b2..f089e58 100644
> > > --- a/fs/nfs/unlink.c
> > > +++ b/fs/nfs/unlink.c
> > > @@ -95,10 +95,11 @@ static void nfs_async_unlink_done(struct rpc_task
> > > *task, void *calldata)
> > ^^^^^^^^
> > see here.
> > 
> > You may have to fix your mailer (or use another one).
> 
> {sigh}
> 
> Yes, all of these patches are linewrapped.

Ok, I take that back, only half of them are linewrapped :)

But it would be easier for you to just resend them all, as that way I
know which ones have already been rejected by people much easier and I
can take the proper ones.

thanks,

greg k-h
