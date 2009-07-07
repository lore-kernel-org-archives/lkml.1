Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZGGNz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZGGNz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZGGNzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:55:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbZGGNzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:55:48 -0400
Date: Tue, 7 Jul 2009 09:55:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20090707135541.GA4997@infradead.org>
References: <20090707134908.e81b1556.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707134908.e81b1556.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 01:49:08PM +1000, Stephen Rothwell wrote:
> interacting with commit 3beab0b42413e83a7907db7176b54c840fc75a81
> ("sys_sync(): fix 16% performance regression in ffsb create_4k test")
> from Linus' tree.

Where the fuck is that patch coming from?  For one that's a horrible
patch subject and second I can't see it anywhere on -fsdevel.  We
removed that bdflush wakeup for a reason, and if it causes problems
those need to be discussed and fixed properly instead of papering over
it.

