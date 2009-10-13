Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZJMBmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZJMBmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZJMBmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:42:10 -0400
Received: from verein.lst.de ([213.95.11.210]:51418 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbZJMBmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:42:10 -0400
Date: Tue, 13 Oct 2009 03:41:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: flush disk cache on ->fsync
Message-ID: <20091013014128.GB7931@lst.de>
References: <20090820182432.GA31520@lst.de> <20091010161531.GA30289@lst.de> <20091012150713.GM9228@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012150713.GM9228@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 05:07:13PM +0200, Jens Axboe wrote:
> On Sat, Oct 10 2009, Christoph Hellwig wrote:
> > Is anyone going to pick up this patch?
> 
> I can pick it up for .33. I think it looks good, but it's probably
> something we should add up front.

Given that it's impossible to get data to a raw block device reliably
without this I think it's .32 material.  Especially given how small
the patch is and how long it's been out there..

