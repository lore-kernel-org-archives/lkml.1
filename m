Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbZICR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbZICR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZICR4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:56:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43322 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZICR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:56:16 -0400
Date: Thu, 3 Sep 2009 11:56:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca,
       jens.axboe@oracle.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/7] Make DISCARD_BARRIER and DISCARD_NOBARRIER writes
	instead of reads
Message-ID: <20090903175617.GA26346@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.144124147@bombadil.infradead.org> <1252000340.4483.529.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252000340.4483.529.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 06:52:20PM +0100, David Woodhouse wrote:
> On Sat, 2009-08-29 at 19:03 -0400, Christoph Hellwig wrote:
> > 
> > The commands are conceptually writes, and in the case of IDE and SCSI
> > commands actually are writes.  They were only reads because we thought
> > that would interact better with the elevators.  Now the elevators know
> > about discard requests, that advantage no longer exists.
> 
> Can you drop the final sentence of that? It isn't true, and I never said
> it.

No, but you wouldn't give me a changelog entry, so I had to make
something up.

> s/.  Now.*/, but that isn't necessary, and making them writes makes it
> easier for the low-level IDE and SCSI code to cope with the fact that
> the command has to be sent with a payload./

Thanks.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
