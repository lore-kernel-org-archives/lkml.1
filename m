Return-Path: <linux-kernel-owner+w=401wt.eu-S1946540AbXD3R4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946540AbXD3R4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946541AbXD3R4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:56:33 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5093 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946540AbXD3R4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:56:31 -0400
Date: Mon, 30 Apr 2007 19:52:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: BAD_SG_DMA panic in aha1542
Message-ID: <20070430175208.GQ21015@kernel.dk>
References: <20070427214709.DC44BDBA2@gherkin.frus.com> <1177712499.3688.25.camel@mulgrave.il.steeleye.com> <20070430173243.GP21015@kernel.dk> <20070430173927.GA10522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430173927.GA10522@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30 2007, Christoph Hellwig wrote:
> On Mon, Apr 30, 2007 at 07:32:45PM +0200, Jens Axboe wrote:
> > It's due to the crappy ->generic_packet() ioctl stuff, it bypasses the
> > block layer. So that needs to be converted to use block pc requests and
> > the block layer interface, then things will just work.
> > 
> > Christoph had a sort-of ready patch for that some time ago. Christoph,
> > did that ever materialize into a full blown patch?
> 
> I had a fullblown patch somewhere.  The only drawback was that I didn't
> convert pcd because I neither understand enough of the hardware nor do
> I really understand what's going on there.

Cool, pass the patch and I'll try to see if I can convert pcd.

-- 
Jens Axboe

