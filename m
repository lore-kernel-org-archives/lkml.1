Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXJ2Twy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXJ2Twy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXJ2Twq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:52:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46433 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXJ2Twp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:52:45 -0400
Date: Mon, 29 Oct 2007 19:52:43 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jesse Barnes <jesse.barnes@intel.com>
cc: dri-devel@lists.sourceforge.net, keithp@keithp.com,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [RFC] AGP initial support for chipset flushing..
In-Reply-To: <200710291247.24791.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0710291951100.1170@skynet.skynet.ie>
References: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie>
 <200710291247.24791.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> In this case, we're performing basically a dma_sync*(...DMA_TO_DEVICE) 
> right?  Can we be sure that a single flush is sufficient?  Is there any 
> window between when we flush and when we start accessing memory with 
> the device that we could get into more caching trouble?

Not that I can think off, but I don't work for the company who screwed up 
the coherency :-), and I don't have the docs, so please investigate for me 
;-)

> Looks reasonable, I'm not sure we can do much better.  The only concern 
> I have is that allocating some more PCI space like that may end up 
> clobbering some *other* hidden BIOS mapping, but there's not a whole 
> lot we can do about that.

Again I'm trying to workaround broken BIOS.. nothing I can do.

Dave.
