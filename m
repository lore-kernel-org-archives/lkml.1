Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZJAHFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZJAHFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZJAHFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:05:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35293 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbZJAHFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:05:46 -0400
Date: Thu, 1 Oct 2009 09:05:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block updates for 2.6.32-rc
Message-ID: <20091001070549.GI14918@kernel.dk>
References: <20090930174109.GD14918@kernel.dk> <20090930193911.GA14391@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930193911.GA14391@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30 2009, Christoph Hellwig wrote:
> On Wed, Sep 30, 2009 at 07:41:10PM +0200, Jens Axboe wrote:
> > Hi Linus,
> > 
> > This looks huge, but it's mostly a cciss driver update and the addition
> > of drbd. I would have submitted this before -rc1, but Plumbers got in
> > the way.
> 
> And DRBD is defintively not ready.  Even if people want to merge another
> duplicate RAID driver including another crappy user interface it has
> tracing stuff of a form that would let Ingo go beserk and also uses the
> stupid connector.

Can we get rid of the connector? Didn't look very closely, but looks
kinda stuck with it. I killed the tracing bits, agree on that.

-- 
Jens Axboe

