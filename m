Return-Path: <linux-kernel-owner+w=401wt.eu-S933255AbXBETIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbXBETIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933375AbXBETIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:08:39 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33254 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255AbXBETIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:08:37 -0500
Date: Mon, 5 Feb 2007 11:15:36 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       agruen@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070205191536.GR10475@sequoia.sous-sol.org>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <20070205184410.GA20672@infradead.org> <1170701906.5934.41.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170701906.5934.41.camel@lade.trondhjem.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> On Mon, 2007-02-05 at 18:44 +0000, Christoph Hellwig wrote:
> > Just FYI:  Al was very opposed to the idea of passing the vfsmount to
> > the vfs_ helpers, so you should discuss this with him.
> > 
> > Looking at the actual patches I see you're lazy in a lot of places.
> > Please make sure that when you introduce a vfsmount argument somewhere
> > that it is _always_ passed and not just when it's conveniant.  Yes, that's
> > more work, but then again if you're not consistant anyone half-serious
> > will laught at a security model using this infrasturcture.
> 
> nfsd in particular tends to be a bit lazy about passing around vfsmount
> info. Forcing it to do so should not be hard since the vfsmount is
> already cached in the "struct export" (which can be found using the
> filehandle). It will take a bit of re-engineering in order to pass that
> information around inside the nfsd code, though.

Yeah, last time I looked at that it was always available, just a bit ugly
to go digging for the vfsmount.
