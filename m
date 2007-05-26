Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbXEZWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbXEZWT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXEZWTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:19:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:46495 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXEZWTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:19:21 -0400
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Olaf Hering <olaf@aepfle.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0705261052110.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.677742000@sonycom.com> <20070525112414.GA32336@aepfle.de>
	 <1180133119.19517.11.camel@localhost.localdomain>
	 <Pine.LNX.4.62.0705261052110.2657@pademelon.sonytel.be>
Content-Type: text/plain
Date: Sun, 27 May 2007 08:18:43 +1000
Message-Id: <1180217923.19517.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 10:52 +0200, Geert Uytterhoeven wrote:
> On Sat, 26 May 2007, Benjamin Herrenschmidt wrote:
> > On Fri, 2007-05-25 at 13:24 +0200, Olaf Hering wrote:
> > > On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:
> > > 
> > > > +++ b/drivers/scsi/ps3rom.c
> > > 
> > > > +			kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > > 
> > > linux/highmem.h is not included to get the kmap_* prototypes.
> > 
> > Beside, I don't see the point of using kmap on ppc64...
> 
> So what should I use instead?

you don't need to map ... the linear mapping is there.... page_address()
should just work. But then, kmap will resolve to just that anyway so I
suppose it doesn't matter.

Ben.


