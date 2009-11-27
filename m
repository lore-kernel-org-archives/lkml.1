Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZK0MIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZK0MIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZK0MIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:08:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZK0MIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:08:53 -0500
Date: Fri, 27 Nov 2009 07:08:56 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] writeback: remove unused nonblocking and
	congestion checks (xfs)
Message-ID: <20091127120856.GA22611@infradead.org>
References: <20091127105908.944744141@intel.com> <20091127110407.781077241@intel.com> <20091127114014.GA5132@infradead.org> <20091127115029.GA20166@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127115029.GA20166@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 07:50:29PM +0800, Wu Fengguang wrote:
> writeback: remove unused nonblocking and congestion checks
> 
> - no one is calling wb_writeback and write_cache_pages with
>   wbc.nonblocking=1 any more
> - lumpy pageout will want to do nonblocking writeback without the
>   congestion wait
> 
> So remove the congestion checks as suggested by Chris.

Looks good to me, thanks.

