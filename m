Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZD3E6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZD3E6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 00:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZD3E5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 00:57:48 -0400
Received: from kroah.org ([198.145.64.141]:47346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZD3E5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 00:57:48 -0400
Date: Wed, 29 Apr 2009 21:54:19 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090430045419.GA13307@kroah.com>
References: <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> <20090429192309.GA15539@kroah.com> <44275.1241041373@turing-police.cc.vt.edu> <20090429215623.GA27319@kroah.com> <1241056121.18530.31.camel@poy> <8bd0f97a0904291856n66fef7d8sb879e9e02b13a311@mail.gmail.com> <ac3eb2510904291906v6b8524f7j5cb3afa43f6759b8@mail.gmail.com> <8bd0f97a0904291913v58a9b7e3l7f081782cea415cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0904291913v58a9b7e3l7f081782cea415cb@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:13:47PM -0400, Mike Frysinger wrote:
> On Wed, Apr 29, 2009 at 22:06, Kay Sievers wrote:
> > On Thu, Apr 30, 2009 at 03:56, Mike Frysinger wrote:
> >> On Wed, Apr 29, 2009 at 21:48, Kay Sievers wrote:
> >>> On Wed, 2009-04-29 at 14:56 -0700, Greg KH wrote:
> >>>> If youreally want it, you can grab it from the git tree, or wait a day
> >>>> or so for me to implement Mike's changes he so nicely sent me, so I can
> >>>> do a new release.
> >>>
> >>> How about this? It substitutes the script and the man page with the
> >>> given --datadir=.
> >>
> >> i had pretty much the same changes locally, but i was going to let the
> >> discussion on data/multiple paths finish first.  at any rate, comments
> >> below ...
> >>
> >>> --- a/Makefile.am
> >>> +++ b/Makefile.am
> >>>
> >>> +       sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
> >>> +       sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
> >>
> >> $(datadir) too should die ... $(datarootdir) is the right variable name
> >
> > Then you want to specify man pages separately? I wouldn't do that.
> 
> nm me, i confused the stuff i was reading about the
> datadir/datarootdir changes with autoconf-2.60

Heh.

I've merged your changes into my git tree, can someone see what I messed
up on the merge?

thanks,

greg k-h
