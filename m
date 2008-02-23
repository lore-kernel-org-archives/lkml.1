Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbYBWTMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbYBWTMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761665AbYBWTLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:11:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759442AbYBWTL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:11:27 -0500
Date: Sat, 23 Feb 2008 11:08:59 -0800
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] fuse: fix permission checking
Message-ID: <20080223190859.GB8641@kroah.com>
References: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu> <20080222231934.GA30703@kroah.com> <E1JSqqR-00035e-8N@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JSqqR-00035e-8N@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 10:38:59AM +0100, Miklos Szeredi wrote:
> > On Fri, Feb 15, 2008 at 11:23:47AM +0100, Miklos Szeredi wrote:
> > > This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.
> > > 
> > > Thanks,
> > > Miklos
> > > ----
> > > 
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > I added a nasty local variable shadowing bug to fuse in 2.6.24, with
> > > the result, that the 'default_permissions' mount option is basically
> > > ignored.
> > 
> > When this goes into Linus's tree, can you let us know along with the git
> > commit id?
> 
> I'd really like to see this in 2.6.24.3.  How much time is left?
> Should I bypass Andrew and submit to Linus ASAP?

There will be a .24.4 soon afterward (week or so), so don't feel like
you have to rush.  Unless this is some kind of security issue?

thanks,

greg k-h
