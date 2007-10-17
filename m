Return-Path: <linux-kernel-owner+w=401wt.eu-S935269AbXJQPzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269AbXJQPzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbXJQPz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:55:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36133 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760852AbXJQPz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:55:26 -0400
Date: Wed, 17 Oct 2007 16:55:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] nfs: fix nfs_writepage()
Message-ID: <20071017155524.GA7090@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1192628458.27435.119.camel@twins> <1192634702.7573.10.camel@heimdal.trondhjem.org> <1192635028.27435.137.camel@twins> <1192635917.7573.24.camel@heimdal.trondhjem.org> <1192636074.7573.27.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192636074.7573.27.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 11:47:54AM -0400, Trond Myklebust wrote:
> Put differently:
>       * _who_ is dirtying the page when the swapper is trying to write
>         the page out?
>       * why are they not calling either page_mkwrite() or
>         commit_write()?

Apparently Peter has some broken patches in his tree that cause this.
It can for sure not happen in mainline and that's absolutely intentional.
