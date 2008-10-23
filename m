Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYJWThS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYJWThS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYJWThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:37:05 -0400
Received: from colo.lackof.org ([198.49.126.79]:56588 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbYJWThE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:37:04 -0400
Date: Thu, 23 Oct 2008 13:36:52 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Greg KH <greg@kroah.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Message-ID: <20081023193652.GC8060@colo.lackof.org>
References: <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org> <20081023032833.GK26094@parisc-linux.org> <20081023064412.GD31186@colo.lackof.org> <20081023153923.GB4011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023153923.GB4011@kroah.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:39:23AM -0700, Greg KH wrote:
> On Thu, Oct 23, 2008 at 12:44:12AM -0600, Grant Grundler wrote:
> > 
> > Lastly, /sys seems to have over run even /proc. On an rx2600 (ia64):
> > grundler@gsyprf3:/usr/src/linux-2.6$ find /sys ! -type d | wc
> >    6288    6296  264893
> 
> Is this causing some kind of problem for your systems?

Nope. Just an observation on the "forest" (vs individual "trees").

> /sys shows far more information than /proc does, so of course it would
> be larger in quantity.

Yes - and /sys is better organized (hierarchial in general).
But it's getting harder to find stuff because there is so much now.
Any comments on adding DMA attributes (e.g. dma_mask_bits) to /sys?

Willy has objected and I'm waiting to hear if he's ok with limiting
this to a DEBUG compile time flag.

thanks,
grant
