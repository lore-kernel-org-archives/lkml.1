Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZK0LkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZK0LkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZK0LkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:40:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZK0LkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:40:15 -0500
Date: Fri, 27 Nov 2009 06:40:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] writeback: remove unused nonblocking and
	congestion checks (xfs)
Message-ID: <20091127114014.GA5132@infradead.org>
References: <20091127105908.944744141@intel.com> <20091127110407.781077241@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127110407.781077241@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 06:59:12PM +0800, Wu Fengguang wrote:
> No one is calling wb_writeback and write_cache_pages with
> wbc.nonblocking=1 any more. And lumpy pageout will want to do
> nonblocking writeback without the congestion wait.

Please, just fold this into one big patch removing the flag.  Splitting
this into multiple patches is just a real pain in the neck.

