Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYE2Uk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYE2Uk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYE2UkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:40:11 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50710 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYE2UkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:40:10 -0400
Date: Thu, 29 May 2008 16:40:02 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
Message-ID: <20080529204002.GC24018@fieldses.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu> <20080529124701.GA13147@infradead.org> <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 04:02:39PM +0200, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > Rename nfsd specific MAY_* flags to NFSD_MAY_* to make it clear, that
> > > these are not used outside nfsd, and to avoid namespace conflicts with
> > > the VFS.
> > 
> > But they _are_ in the same namespace as the VFS ones.  This needs to be
> > sorted out by real by understanding what's going on here and either
> > separating this flags out and passing them in a separate argument, or
> > moving them to include/linux/fs.h so it's obvious for anyone adding new
> > flags that they must not collide.
> 
> Neither I think.  What's going on is that nfsd has a private set of
> permission flags, and a private permission checking function, which
> incidentally calls the vfs' permission checking function.
> 
> Does it hurt to share the three base MAY_ flags for this purpose?  I
> don't think it does, but I'm interested in the nfsd maintainers'
> opinions.

This isn't something I've ever had a reason to care about.  What are you
trying to fix exactly?

--b.
