Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYKARK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYKARK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 13:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYKARKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 13:10:17 -0400
Received: from colo.lackof.org ([198.49.126.79]:47508 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYKARKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 13:10:15 -0400
Date: Sat, 1 Nov 2008 11:10:03 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Message-ID: <20081101171003.GD13302@colo.lackof.org>
References: <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org> <20081023032833.GK26094@parisc-linux.org> <20081023064412.GD31186@colo.lackof.org> <87zlku8dy3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlku8dy3.fsf@basil.nowhere.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 12:50:12PM +0200, Andi Kleen wrote:
> Grant Grundler <grundler@parisc-linux.org> writes:
> 
> > On Wed, Oct 22, 2008 at 09:28:33PM -0600, Matthew Wilcox wrote:
> >> On Wed, Oct 22, 2008 at 06:45:10PM -0700, Yinghai Lu wrote:
> >> > Grant prefer to add it /sys instead of showing in bootlog
> >> > 
> >> > so could catch if the driver set the correct dma_mask.
> >> 
> >> I still don't think this is useful information to be exposing.
> >
> > It's useful for anyone involved with device drivers - we agree that's
> > a very limited subset of users.  I certainly get fed up with trying
> > to figure out which dma_mask each driver is using since in some
> 
> One simple way that doesn't need any kernel changes is to use
> crash on the running kernel.

I would agree if someone can show me how to script crash to dump
all the struct pci_dev DMA masks and associate that output with
a driver and device instance.

> I personally just stuck in printks
> when I needed that, but it doesn't strike me as something that 
> is generally useful in standard kernels (agreeing with Willy)

Ok.

thanks,
grant
