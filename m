Return-Path: <linux-kernel-owner+w=401wt.eu-S965384AbXBFTkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384AbXBFTkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965381AbXBFTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:40:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48598 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965389AbXBFTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:40:50 -0500
Date: Tue, 6 Feb 2007 19:40:43 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Greg KH <greg@kroah.com>
cc: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: gpu sharing layer for kernel
In-Reply-To: <20070124214654.GA30634@kroah.com>
Message-ID: <Pine.LNX.4.64.0702061935300.9224@pentafluge.infradead.org>
References: <1169637623985-git-send-email-airlied@linux.ie>
 <20070124214654.GA30634@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Jan 24, 2007 at 10:20:18PM +1100, airlied@linux.ie wrote:
> > This patch series contains the gpu sharing layer for kernel that I've
> > mentioned before. It should apply against Linus's git tree.
> 
> Yeah!

Finally after all these years!!!! Sorry about the delayed response I was 
busy with work.

> > Why do we want this?
> > 
> > Currently the kernel cannot provide both the fb and drm drivers with
> > access to the device model and this means the drm cannot get any
> > suspend/resume callbacks.  This layer attempts to fix this problem by
> > adding a bus for the gpu drivers to attach to. Currently a lowlevel
> > binding driver is needed along with optional fb and drm components.
> 
> If we were to allow this kind of "sharing" for all PCI devices would
> that work out instead?  Or would this layer still be needed?

Please do this. Its not only fbdev but backlight and display support.
Note display support is not main stream yet. Greg sent me a email about 
the DRM team needing a CRT class as well. That will be a different 
discussion. Plus some cards have tuners as well. So this device sharing is 
needed. It would also be really nice to prevent driver collisions. For 
example vesafb and a fbdev driver controlling the same hardware or acpi 
backlight versus the graphics card backlight support.
