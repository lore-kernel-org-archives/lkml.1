Return-Path: <linux-kernel-owner+w=401wt.eu-S1765607AbYARTHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765607AbYARTHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763581AbYARTHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:07:11 -0500
Received: from waste.org ([66.93.16.53]:58971 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbYARTHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:07:08 -0500
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
From: Matt Mackall <mpm@selenic.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       daniel.ritz-ml@swissonline.ch, randy.dunlap@oracle.com, jeff@garzik.org,
       linux-ide@vger.kernel.org
In-Reply-To: <20080118184457.GC20490@parisc-linux.org>
References: <1200445210549-git-send-email-htejun@gmail.com>
	 <1200681668.25782.9.camel@cinder.waste.org>
	 <20080118184457.GC20490@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 13:06:23 -0600
Message-Id: <1200683183.25782.15.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 11:44 -0700, Matthew Wilcox wrote:
> On Fri, Jan 18, 2008 at 12:41:08PM -0600, Matt Mackall wrote:
> > On Wed, 2008-01-16 at 10:00 +0900, Tejun Heo wrote:
> > > And mprintk the following.
> > > 
> > >  code:
> > >   DEFINE_MPRINTK(mp, 2 * 80);
> > > 
> > >   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
> > >   mprintk_push(&mp, "ATA %d", 7);
> > >   mprintk_push(&mp, ", %u sectors\n", 1024);
> > >   mprintk(&mp, "everything seems dandy\n");
> > 
> > I prefer Matthew Wilcox's stringbuf approach which does proper memory
> > management and isn't specific to printk:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/0517.html
> 
> Do you have any strong feelings whether we should merge my stringbufs or
> rusty's version?  I have no particular preference.

My vague recollection was that I preferred Rusty's. But it's been a
while.

-- 
Mathematics is the supreme nostalgia of our time.

