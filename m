Return-Path: <linux-kernel-owner+w=401wt.eu-S1946409AbXBQE4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946409AbXBQE4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 23:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946408AbXBQE4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 23:56:11 -0500
Received: from mail.suse.de ([195.135.220.2]:50408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946409AbXBQE4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 23:56:10 -0500
Date: Fri, 16 Feb 2007 20:54:51 -0800
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all modules' causes hard hang on boot
Message-ID: <20070217045451.GA20407@kroah.com>
References: <1171619710.6828.24.camel@Homer.simpson.net> <20070216223609.GA6165@kroah.com> <1171676288.6448.9.camel@Homer.simpson.net> <20070217015048.GB18591@kroah.com> <d9def9db0702161821t737ef824p8d96ef5b3632acaa@mail.gmail.com> <d9def9db0702161904p68d72cc7ka2f2bd5c9d50e0a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0702161904p68d72cc7ka2f2bd5c9d50e0a2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 04:04:52AM +0100, Markus Rechberger wrote:
> On 2/17/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> >On 2/17/07, Greg KH <greg@kroah.com> wrote:
> >> On Sat, Feb 17, 2007 at 02:38:08AM +0100, Mike Galbraith wrote:
> >> > On Fri, 2007-02-16 at 14:36 -0800, Greg KH wrote:
> >> > > On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> >> > > > Greetings,
> >> > > >
> >> > > > Per $subject, git.yesterday hangs hard on boot here. A git bisect
> >> > > > fingered the commit below, which I verified via git bisect reset;
> >git
> >> > > > revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> >> > > > boots fine.  (well, I hope I verified... i'm git-ignorant)
> >> > >
> >> > > If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the
> >problem?
> >> >
> >> > It's already set.
> >>
> >> It's not set in the config file you sent to me and the list :)
> >>
> >
> >I'm having a hard lockup to when I fire up xmms in X (maybe some other
> >apps too) I'm bisecting at the moment.
> >CONFIG_SYSFS_DEPRECIATED is set to Y here too, so I might have another
> >problem here.. let's see what bisecting will show up..
> >
> 
> seems to be a "wrong" alarm here, it was caused by a new xorg.conf and
> an intel 855gm chipset.

That's good, thanks for letting us know.

greg k-h
