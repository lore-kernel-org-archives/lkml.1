Return-Path: <linux-kernel-owner+w=401wt.eu-S971234AbXEIAdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971234AbXEIAdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXEIAdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:33:32 -0400
Received: from waste.org ([66.93.16.53]:60380 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXEIAdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:33:32 -0400
Date: Tue, 8 May 2007 19:33:23 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509003323.GX11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <20070509013220.02093f2e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509013220.02093f2e@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:32:20AM +0100, Alan Cox wrote:
> > (without SLAB emulation) and fragmentation was not the driving force
> > for replacement. Small Linux 1.x machines frequently had uptimes of 1+
> > years without fragmenting to death. Instead, it was performance with
> 
> 8MB for a bit over 3 years.... (1.2.13lmp)
> 
> The fragmentation issue I think is overbaked. A lot of the academic work
> argues that there is pretty much no long term difference between first
> fit, best fit, and most of the clever algorithms (obviously stupid ones
> like "take the middle out of the biggest space allocator" do perform
> worse). For MMUless boxes fragmentation is a big issue but not for normal
> systems.

Further, the received wisdom that fragmentation of SLAB-like systems
is better is not above doubt. Our own issues with dcache fragmentation
suggest it's far from perfect.

-- 
Mathematics is the supreme nostalgia of our time.
