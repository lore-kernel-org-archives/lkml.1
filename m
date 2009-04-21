Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZDURIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZDURIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZDURH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:07:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbZDURH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:07:57 -0400
Date: Tue, 21 Apr 2009 13:07:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH 07/14] block: reorganize request fetching functions
Message-ID: <20090421170751.GA21156@infradead.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240331881-28218-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:37:54AM +0900, Tejun Heo wrote:
> Impact: code reorganization
> 
> elv_next_request() and elv_dequeue_request() are public block layer
> interface than actual elevator implementation.  They mostly deal with
> how requests interact with block layer and low level drivers at the
> beginning of rqeuest processing whereas __elv_next_request() is the
> actual eleveator request fetching interface.
> 
> Move the two functions to blk-core.c.  This prepares for further
> interface cleanup.

As a follow-up patch you might want to rename them to have a more
descriptive prefix than elv_ and add some kerneldoc comments for them.

