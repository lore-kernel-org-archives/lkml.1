Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXCUDmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXCUDmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXCUDmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:42:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXCUDmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:42:09 -0400
Date: Tue, 20 Mar 2007 20:39:38 -0700
From: Greg KH <gregkh@suse.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/31] 2.6.20-stable review
Message-ID: <20070321033938.GA4907@suse.de>
References: <20070319213647.GB9261@kroah.com> <200703201559.29508.gene.heskett@gmail.com> <46004021.7040202@linuxtv.org> <200703202304.44388.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703202304.44388.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 11:04:43PM -0400, Gene Heskett wrote:
> On Tuesday 20 March 2007, Michael Krufky wrote:
> >Gene Heskett wrote:
> >> On Tuesday 20 March 2007, Greg KH wrote:
> >>> On Tue, Mar 20, 2007 at 01:15:02AM -0400, Gene Heskett wrote:
> >>>> In any event, something tickled the monster, and its hungry.  This
> >>>> is a full-stop, show-stopper AFAIAC.
> >>>>
> >>>> I'll cut that patch-2.6.20.4-rc1 in halves, and build 2 more test
> >>>> kernels tomorrow to start a bisect if no one has any better idea
> >>>> before then.
> >>>
> >>> I'd recommend using the quilt tree of patches to do this, it will be
> >>> easier than trying to split the larger patch up into pieces by hand.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> I don't have quilt installed, and no idea how to use it if it was,
> >> Greg. Even my git is now pushing a year old.
> >
> >Gene-
> >
> >quilt is a very easy tool to use...  Here is a quick run-down.
> >
> >#1) remove the stable -rc patch from the tree
> >
> >#2) install quilt
> >
> >#3) go to your source tree, and create a directory called "patches"
> >
> >#4) copy all of the patches from Greg's queue into that "patches"
> > directory, including the "series" file.
> >
> >#5) quilt push, to apply the first patch
> >    quilt push, to apply the second patch (you get the idea)
> >    quilt push -a , to apply all patches in the series
> >
> >#6) quilt pop, to back out the most recent patch pushed in
> >    quilt pop -a to back out the entire series.
> >
> >If a patch doesnt apply, quilt will let you know about it, and present
> > you with the option to force the patch to apply.  This is highly
> > unlikely to occur, since Greg has already done what needs to be done to
> > make these patches apply to the source.
> >
> >For a better explanation, see "man quilt".  Using quilt, when you have a
> > list of patches and a series file containing the merge order is *much*
> > easier that a git bisection, and can help you to find the problem patch
> > much quicker.
> >
> >I hope this helps...
> >
> It looks like, from the series files contents, that I grabbed the 
> wrong 'queue', its all 2.6.21 stuff.  url please.

The patch queue can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

All of the patches and the series file are in the review-2.6.20/
directory.

thanks,

greg k-h
