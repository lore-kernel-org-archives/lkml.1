Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYJWTxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYJWTxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYJWTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:52:51 -0400
Received: from kroah.org ([198.145.64.141]:42825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753499AbYJWTwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:52:50 -0400
Date: Thu, 23 Oct 2008 12:49:24 -0700
From: Greg KH <greg@kroah.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Message-ID: <20081023194924.GA10531@kroah.com>
References: <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org> <20081023032833.GK26094@parisc-linux.org> <20081023064412.GD31186@colo.lackof.org> <20081023153923.GB4011@kroah.com> <20081023193652.GC8060@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023193652.GC8060@colo.lackof.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 01:36:52PM -0600, Grant Grundler wrote:
> On Thu, Oct 23, 2008 at 08:39:23AM -0700, Greg KH wrote:
> > On Thu, Oct 23, 2008 at 12:44:12AM -0600, Grant Grundler wrote:
> > > 
> > > Lastly, /sys seems to have over run even /proc. On an rx2600 (ia64):
> > > grundler@gsyprf3:/usr/src/linux-2.6$ find /sys ! -type d | wc
> > >    6288    6296  264893
> > 
> > Is this causing some kind of problem for your systems?
> 
> Nope. Just an observation on the "forest" (vs individual "trees").
> 
> > /sys shows far more information than /proc does, so of course it would
> > be larger in quantity.
> 
> Yes - and /sys is better organized (hierarchial in general).
> But it's getting harder to find stuff because there is so much now.
> Any comments on adding DMA attributes (e.g. dma_mask_bits) to /sys?

Sorry, wasn't paying attention.  All I ask is that if you do add new
sysfs files, you document them in the proper format in
Documentation/ABI/

thanks,

greg k-h
