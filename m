Return-Path: <linux-kernel-owner+w=401wt.eu-S1765880AbXJQQEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765880AbXJQQEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966106AbXJQQD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:03:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940AbXJQQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:02:48 -0400
Subject: Re: [PATCH] nfs: fix nfs_writepage()
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071017155524.GA7090@infradead.org>
References: <1192628458.27435.119.camel@twins>
	 <1192634702.7573.10.camel@heimdal.trondhjem.org>
	 <1192635028.27435.137.camel@twins>
	 <1192635917.7573.24.camel@heimdal.trondhjem.org>
	 <1192636074.7573.27.camel@heimdal.trondhjem.org>
	 <20071017155524.GA7090@infradead.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 18:02:45 +0200
Message-Id: <1192636965.27435.152.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 16:55 +0100, Christoph Hellwig wrote:
> On Wed, Oct 17, 2007 at 11:47:54AM -0400, Trond Myklebust wrote:
> > Put differently:
> >       * _who_ is dirtying the page when the swapper is trying to write
> >         the page out?
> >       * why are they not calling either page_mkwrite() or
> >         commit_write()?
> 
> Apparently Peter has some broken patches in his tree that cause this.
> It can for sure not happen in mainline and that's absolutely intentional.

Yeah, I got fooled by thinking swapper_space was 'proper' usage.


