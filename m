Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbXBWOwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbXBWOwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbXBWOwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:52:38 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2845 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbXBWOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:52:37 -0500
Date: Fri, 23 Feb 2007 09:39:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] dma-mapping-broken.h: flesh-out DMA API stubs
Message-ID: <20070223143938.GA5815@tuxdriver.com>
References: <20070223005945.GA13084@tuxdriver.com> <20070223034243.GA7988@osiris.ibm.com> <20070223061332.GB27126@osiris.ibm.com> <20070223135740.GA28270@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223135740.GA28270@athena.road.mcmartin.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 08:57:41AM -0500, Kyle McMartin wrote:
> On Fri, Feb 23, 2007 at 07:13:32AM +0100, Heiko Carstens wrote:
> > How about this for telling that an architecture doesn't support DMA?
> > At least we could get rid of dma-mapping-broken.h and don't need to
> > compile some afterwards dead code.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This like a lot better of an idea than stubbing out things which should never
> be built in the first place...

My only thought was that the intent must have been to allow compilation of a driver
that checks for DMA at runtime (via dma_supported).  But, I guess dma_supported is intended
as a platform-level check?

If the DMA availability is at the arch level then such a driver could
use (albeit ugly) compile flags to cover that situation...?

Well, either way is fine with me.

John
-- 
John W. Linville
linville@tuxdriver.com
