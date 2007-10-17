Return-Path: <linux-kernel-owner+w=401wt.eu-S966338AbXJQQGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966338AbXJQQGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935778AbXJQQFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:05:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44326 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935943AbXJQQFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:05:21 -0400
Date: Wed, 17 Oct 2007 17:05:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] nfs: fix nfs_writepage()
Message-ID: <20071017160519.GA9488@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1192628458.27435.119.camel@twins> <1192634702.7573.10.camel@heimdal.trondhjem.org> <1192635028.27435.137.camel@twins> <1192635917.7573.24.camel@heimdal.trondhjem.org> <1192636074.7573.27.camel@heimdal.trondhjem.org> <20071017155524.GA7090@infradead.org> <1192636965.27435.152.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192636965.27435.152.camel@twins>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 06:02:45PM +0200, Peter Zijlstra wrote:
> > Apparently Peter has some broken patches in his tree that cause this.
> > It can for sure not happen in mainline and that's absolutely intentional.
> 
> Yeah, I got fooled by thinking swapper_space was 'proper' usage.

The swapper space is and always has been special because it's not owned
by a filesystem but rather the VM, so it can be sloppy about some things.

