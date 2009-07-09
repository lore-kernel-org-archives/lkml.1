Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbZGIOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbZGIOCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbZGIOCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:02:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbZGIOCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:02:09 -0400
Date: Thu, 9 Jul 2009 10:02:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, chris.mason@oracle.com
Subject: Re: [PATCH] Fix congestion_wait() sync/async vs read/write
	confusion
Message-ID: <20090709140205.GA4828@infradead.org>
References: <20090708184703.GW23611@kernel.dk> <1247092504.9223.6.camel@heimdal.trondhjem.org> <1247093091.9223.10.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247093091.9223.10.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Oh, great...
> > 
> > This particular change will affect _all_ users of
> > set_bdi_congested(WRITE)/clear_bdi_congested(WRITE). If you're going to
> > do this, then you had better be prepared to change them all. There's one
> > in fs/nfs/write.c...
> 
> More specifically, you need to audit and fix:

Please stop quoting 250+ lines of patch for a couple of lines reply.
Seriously that's just extremly rude and annoying.

