Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbZHJSSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbZHJSSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZHJSR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:17:59 -0400
Received: from fieldses.org ([174.143.236.118]:60823 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZHJSR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:17:58 -0400
Date: Mon, 10 Aug 2009 14:17:56 -0400
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Subject: Re: linux-next: manual merge of the nfsd tree with the nfs tree
Message-ID: <20090810181756.GB6723@fieldses.org>
References: <20090810105851.80333493.sfr@canb.auug.org.au> <20090810160537.GD3401@fieldses.org> <1249927732.21816.5.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249927732.21816.5.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 02:08:52PM -0400, Trond Myklebust wrote:
> On Mon, 2009-08-10 at 12:05 -0400, J. Bruce Fields wrote:
> > On Mon, Aug 10, 2009 at 10:58:51AM +1000, Stephen Rothwell wrote:
> > > Hi Bruce,
> > > 
> > > Today's linux-next merge of the nfsd tree got a conflict in
> > > net/sunrpc/cache.c between commit
> > > 173912a6add00f4715774dcecf9ee53274c5924c ("SUNRPC: Move procfs-specific
> > > stuff out of the generic sunrpc cache code") from the nfs tree and commit
> > > f866a8194f7cbabb9135b98b9ac7d26237b88367 ("sunrpc/cache: rename
> > > queue_loose to cache_dequeue") from the nfsd tree.
> > 
> > OK, thanks.
> > 
> > Looks like there may be some less trivial conflicts now, though.  Trond,
> > maybe you could rebase the cache stuff against my latest for-2.6.32?
> 
> I've merged your for-2.6.32 into a dedicated sunrpc_cache-for_next topic
> branch and pushed that out as part of the NFS client linux-next.

Yup, that works for me.  Thanks.

Note I'm no longer messing with the for-2.6.x branches (like
for-2.6.32)--so those will only ever fast-forward.

--b.
