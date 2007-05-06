Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXEFQt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXEFQt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXEFQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:49:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXEFQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:49:56 -0400
Date: Sun, 6 May 2007 17:49:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: Fix indentation in do_path_lookup
Message-ID: <20070506164950.GA7204@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1178405980972-git-send-email-jsipek@cs.sunysb.edu> <11784059803717-git-send-email-jsipek@cs.sunysb.edu> <20070506111124.GA1211@infradead.org> <20070506164323.GA11170@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506164323.GA11170@filer.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 12:43:23PM -0400, Josef Sipek wrote:
> On Sun, May 06, 2007 at 12:11:24PM +0100, Christoph Hellwig wrote:
> > On Sat, May 05, 2007 at 06:59:39PM -0400, Josef 'Jeff' Sipek wrote:
> > > Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> > > ---
> > >  fs/namei.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index 0262594..600a4e7 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -1159,7 +1159,7 @@ out:
> > >  	if (likely(retval == 0)) {
> > >  		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
> > >  				nd->dentry->d_inode))
> > > -		audit_inode(name, nd->dentry->d_inode);
> > > +			audit_inode(name, nd->dentry->d_inode);
> > >  	}
> ...
> > nd is guaranteed to be zero.
>  
> Should that say non-zero?

Yes, sorry.
