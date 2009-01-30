Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZA3FUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZA3FUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 00:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbZA3FUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 00:20:24 -0500
Received: from 1wt.eu ([62.212.114.60]:1907 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZA3FUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 00:20:23 -0500
Date: Fri, 30 Jan 2009 06:20:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jonathan Campbell <jon@nerdgrounds.com>,
       "Peter W. Morreale" <pmorreale@novell.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
Message-ID: <20090130052007.GM5038@1wt.eu>
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com> <497E4C5E.2030201@nerdgrounds.com> <1233248649.7191.130.camel@hermosa.site> <4981E7BD.3040507@nerdgrounds.com> <4981E99F.30001@zytor.com> <498271DF.6090406@nerdgrounds.com> <4982860E.2060605@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4982860E.2060605@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 08:46:06PM -0800, H. Peter Anvin wrote:
> Jonathan Campbell wrote:
> > I don't really see the similarity between the MTD subsystem and dividing
> > vram up by files. Video cards don't have "erase blocks". And MTD is not
> > a filesystem. And the onboard memory mtd driver (map system RAM) only
> > handles one fixed region determined at load time.
> > 
> > Vramfs on the other hand determines what resources to use at mount time.
> > It supports multiple mounts, one per PCI device, if you want the
> > combined VRAM of two VGA cards in your system.
> > 
> > I don't think vramfs would fit well into the MTD subsystem.
> 
> Think about it this way: it is a continuum of facilities.  Why is VRAM
> different than, say, external DRAM that can only be accessed via a DMA
> engine?  Now swap the DRAM with NAND flash and perform the same exercise.
> 
> Perhaps the most important reason is that you want to be able to use
> this as backing store for swap.  Currently the mm doesn't handle swap
> which is much faster than filesystems very well, but that should be
> possible to address.

Also, MTD allows you to map *part* of the VRAM. On my laptop, I only
map 56 MB out of the 64 MB of VRAM, which still allows me to use the
VGA normally. And BTW, I map this VRAM as a fast swap memory.

In fact, I see little use to the VRAMFS for the average user. Still
it might have been a nice coding exercice for Jonathan.

Willy

