Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZHJQbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZHJQbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbZHJQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:31:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbZHJQbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:31:40 -0400
Date: Mon, 10 Aug 2009 09:29:10 -0700
From: Greg KH <gregkh@suse.de>
To: "Emilio G. Cota" <cota@braap.org>
Cc: Martyn Welch <martyn.welch@gefanuc.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090810162910.GB27912@suse.de>
References: <20090803205657.964064732@mini.kroah.org>
 <20090803210116.GC28430@kroah.com>
 <20090808232259.GA29303@braap.org>
 <20090809121715.GA3884@braap.org>
 <4A801D04.6050102@gefanuc.com>
 <20090810152606.GA23319@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810152606.GA23319@braap.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 05:26:06PM +0200, Emilio G. Cota wrote:
> Martyn Welch wrote:
> >>> Instead of using that we implemented a heretic IOCTL-based
> >>> interface for user-space; at least with it you could create a
> [ snip ]
> >>> #define VME_IOCTL_START_DMA             _IOWR('V', 10, struct vme_dma)
> >>>
> > I am moving the interface in that direction, I remain unconvinced about  
> > the contents of your vme_mapping structure, it's too tsi-148 specific.
> 
> Could you please point out why is too tsi148-specific?
> 
> The point here is that the driver should know *nothing* about
> windows, etc. What it should just know is:
> - I want a mapping of a certain size to VME address X
> The struct provides exactly this.

So does the existing UIO interface, right?  Please don't reinvent the
wheel here :)

thanks,

greg k-h
