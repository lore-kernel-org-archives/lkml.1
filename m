Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZEJIt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZEJIt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 04:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZEJItr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 04:49:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:53627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZEJItq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 04:49:46 -0400
Subject: Re: dma-debug: add a check dma memory leaks
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, benh@kernel.crashing.org
In-Reply-To: <20090510020911.GA4722@kroah.com>
References: <200903302101.n2UL1O1n011970@hera.kernel.org>
	 <1240005065.19059.19.camel@macbook.infradead.org>
	 <20090421092016.GH17438@amd.com>
	 <1241913552.24436.113.camel@macbook.infradead.org>
	 <20090510020911.GA4722@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 May 2009 09:49:39 +0100
Message-Id: <1241945379.24436.130.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-09 at 19:09 -0700, Greg KH wrote:
> On Sun, May 10, 2009 at 12:59:12AM +0100, David Woodhouse wrote:
> > Subject: Add BUS_NOTIFY_UNBOUND_DRIVER callback after driver removal
> > 
> > This adds a notifier callback which happens _after_ the driver has been
> > unbound from the device, needed for things like the DMA debugging API
> > which want to check that all DMA mappings have been correctly torn down.
> > 
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> I don't understand.  Who wrote this patch, Joerg or you?  I have this in
> my tree already as written by Joerg.

In that case we probably both did it, independently. I did it last night
after finally catching up with Ben and talking about the possibility of
moving the existing notifiers. Jörg may have done it sooner.

You can drop my version, then.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

