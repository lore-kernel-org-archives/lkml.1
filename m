Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbXE2Jzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbXE2Jzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXE2Jzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:55:41 -0400
Received: from verein.lst.de ([213.95.11.210]:39806 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbXE2Jzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:55:40 -0400
Date: Tue, 29 May 2007 11:55:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linuxppc-dev@ozlabs.org, Olaf Hering <olaf@aepfle.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Message-ID: <20070529095508.GB29351@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com> <20070525112414.GA32336@aepfle.de> <1180133119.19517.11.camel@localhost.localdomain> <Pine.LNX.4.62.0705261052110.2657@pademelon.sonytel.be> <1180217923.19517.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180217923.19517.42.camel@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 08:18:43AM +1000, Benjamin Herrenschmidt wrote:
> > > > linux/highmem.h is not included to get the kmap_* prototypes.
> > > 
> > > Beside, I don't see the point of using kmap on ppc64...
> > 
> > So what should I use instead?
> 
> you don't need to map ... the linear mapping is there.... page_address()
> should just work. But then, kmap will resolve to just that anyway so I
> suppose it doesn't matter.

Generally I'd prefer to use kmap everywhere, to keep code future-proof.
Similar to how I advocate using spinlocks even in drivers for UP-only
architectures.
