Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbZHJSKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbZHJSKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZHJSKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:10:03 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10591 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZHJSKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:10:01 -0400
X-IronPort-AV: E=Sophos;i="4.43,354,1246863600"; 
   d="scan'208";a="221986987"
Subject: Re: linux-next: manual merge of the nfsd tree with the nfs tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
In-Reply-To: <20090810160537.GD3401@fieldses.org>
References: <20090810105851.80333493.sfr@canb.auug.org.au>
	 <20090810160537.GD3401@fieldses.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 10 Aug 2009 14:08:52 -0400
Message-Id: <1249927732.21816.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 10 Aug 2009 18:08:54.0089 (UTC) FILETIME=[9F18D390:01CA19E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 12:05 -0400, J. Bruce Fields wrote:
> On Mon, Aug 10, 2009 at 10:58:51AM +1000, Stephen Rothwell wrote:
> > Hi Bruce,
> > 
> > Today's linux-next merge of the nfsd tree got a conflict in
> > net/sunrpc/cache.c between commit
> > 173912a6add00f4715774dcecf9ee53274c5924c ("SUNRPC: Move procfs-specific
> > stuff out of the generic sunrpc cache code") from the nfs tree and commit
> > f866a8194f7cbabb9135b98b9ac7d26237b88367 ("sunrpc/cache: rename
> > queue_loose to cache_dequeue") from the nfsd tree.
> 
> OK, thanks.
> 
> Looks like there may be some less trivial conflicts now, though.  Trond,
> maybe you could rebase the cache stuff against my latest for-2.6.32?

I've merged your for-2.6.32 into a dedicated sunrpc_cache-for_next topic
branch and pushed that out as part of the NFS client linux-next.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
