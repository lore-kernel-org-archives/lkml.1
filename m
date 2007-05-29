Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbXE2KwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbXE2KwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764846AbXE2KwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:52:04 -0400
Received: from verein.lst.de ([213.95.11.210]:42744 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764836AbXE2KwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:52:01 -0400
Date: Tue, 29 May 2007 12:51:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] ps3: FLASH ROM Storage Driver
Message-ID: <20070529105135.GE29351@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.815300000@sonycom.com> <20070529095355.GA29351@lst.de> <Pine.LNX.4.62.0705291157260.7698@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705291157260.7698@pademelon.sonytel.be>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 11:57:52AM +0200, Geert Uytterhoeven wrote:
> On Tue, 29 May 2007, Christoph Hellwig wrote:
> > On Fri, May 25, 2007 at 10:36:14AM +0200, Geert.Uytterhoeven@sonycom.com wrote:
> > > Add a FLASH ROM Storage Driver for the PS3:
> > >   - Implemented as a misc character device driver
> > >   - Uses a fixed 256 KiB buffer allocated from boot memory as the hypervisor
> > >     requires the writing of aligned 256 KiB blocks
> > 
> > Looks good, but please either make the driver aware of multiple devices
> > even if they can't happen currently, or alternatively error out in
> > ->probe if of some reason it's called for a second device.
> 
> ps3flash_probe() does return -EBUSY when called for a second device.

You're right, I missed that bit.
