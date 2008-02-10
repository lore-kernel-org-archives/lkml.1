Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYBJHWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYBJHWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYBJHUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58135 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbYBJHUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:30 -0500
Date: Sat, 9 Feb 2008 23:21:16 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080210072116.GA12375@kroah.com>
References: <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 10:25:23PM -0800, Yinghai Lu wrote:
> On Feb 9, 2008 4:41 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Thu, Feb 07, 2008 at 10:54:05AM -0500, Tony Camuso wrote:
> > > Matthew,
> > >
> > > Perhaps I missed it, but did you address Yinghai's concerns?
> >
> > No, I was on holiday.
> >
> > > Yinghai Lu wrote:
> > > >On Jan 28, 2008 7:03 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > > >>
> > > >>-int pci_conf1_write(unsigned int seg, unsigned int bus,
> > > >>+static int pci_conf1_write(unsigned int seg, unsigned int bus,
> > > >>                           unsigned int devfn, int reg, int len, u32
> > > >>                           value)
> > > >
> > > >any reason to change pci_conf1_read/write to static?
> >
> > Yes -- it no longer needs to be called from outside this file.
> >
> > > >>+config ATA_RAM
> > > >>+       tristate "ATA RAM driver"
> > > >>+
> > > >
> > > >related?
> >
> 
> looks good. it should get into -mm or x86/mm for some testing

Can I get a revised version of this, without the incorrect hunk?

thanks,

greg k-h
