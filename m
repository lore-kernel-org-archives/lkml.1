Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZDVKJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZDVKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZDVKJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:09:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54076 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZDVKJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:09:17 -0400
Date: Wed, 22 Apr 2009 12:09:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com
Subject: Re: [PATCH 07/14] block: reorganize request fetching functions
Message-ID: <20090422100916.GZ4593@kernel.dk>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-8-git-send-email-tj@kernel.org> <20090421170751.GA21156@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421170751.GA21156@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21 2009, Christoph Hellwig wrote:
> On Wed, Apr 22, 2009 at 01:37:54AM +0900, Tejun Heo wrote:
> > Impact: code reorganization
> > 
> > elv_next_request() and elv_dequeue_request() are public block layer
> > interface than actual elevator implementation.  They mostly deal with
> > how requests interact with block layer and low level drivers at the
> > beginning of rqeuest processing whereas __elv_next_request() is the
> > actual eleveator request fetching interface.
> > 
> > Move the two functions to blk-core.c.  This prepares for further
> > interface cleanup.
> 
> As a follow-up patch you might want to rename them to have a more
> descriptive prefix than elv_ and add some kerneldoc comments for them.

Hmm dunno, elv_ is fine with me. kerneldoc is always nice, though.

-- 
Jens Axboe

