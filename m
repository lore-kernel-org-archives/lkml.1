Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYJQWEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYJQWEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYJQWER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:04:17 -0400
Received: from kroah.org ([198.145.64.141]:40160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753835AbYJQWEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:04:15 -0400
Date: Fri, 17 Oct 2008 15:00:54 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6.28
Message-ID: <20081017220054.GB3659@kroah.com>
References: <20081010224130.GA30117@kroah.com> <20081013213651.GA8338@kroah.com> <alpine.LFD.2.00.0810171332240.3438@nehalem.linux-foundation.org> <20081017213816.GA20423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017213816.GA20423@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 02:38:16PM -0700, Greg KH wrote:
> On Fri, Oct 17, 2008 at 01:34:42PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 13 Oct 2008, Greg KH wrote:
> > > 
> > > I've now added 2 more patches to this tree, fixing a build error if you
> > > did not build any staging drivers into your tree (the normal mode of
> > > building), and added an additional wireless driver that came from the
> > > Fedora kernel trees.
> > 
> > Greg - I finally got around to merging this tree, and it got some 
> > conflicts with the changes/cleanups to taint handling (and due to the 
> > MAINTAINERS file cleanups/alphasort). They conflicts weren't all that 
> > nasty, and I think they're all resolved correctly, but it might be worth 
> > testing the TAINT_CRAP flag in particular. I tested the build in the 
> > normal config, but didn't actually bother to test any tainted drivers.
> 
> Thanks for letting me know, I'll go build and test this right now.

Yes, this seems to be working just fine, my kernel is properly tainted
with crap now :)

thanks,

greg k-h
