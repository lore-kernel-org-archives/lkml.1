Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYIZWHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYIZWHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYIZWHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:07:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:46271 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYIZWHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:07:44 -0400
Date: Fri, 26 Sep 2008 15:03:51 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080926220351.GA9762@suse.de>
References: <20080925042108.GA3931@suse.de> <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com> <20080925205328.GB11225@suse.de> <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com> <20080925220454.GA12116@suse.de> <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com> <48DD2BA3.7050808@s5r6.in-berlin.de> <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com> <20080926201917.GA2591@suse.de> <f7848160809261356p1268f251pfc5bc8477862723@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809261356p1268f251pfc5bc8477862723@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 04:56:19PM -0400, Parag Warudkar wrote:
> On Fri, Sep 26, 2008 at 4:19 PM, Greg KH <gregkh@suse.de> wrote:
> 
> > If you really don't like it, just never enable any of these modules,
> > you'll never be bothered by it.
> 
> So you are saying if a distro ships allmodconfig kernels or ships the
> crap modules in the hope that people will find them useful and I have
> one of the devices in my machine that I don't care about - I should
> just let the crap module autoload and crash/taint my kernel or take
> the special step of blacklisting all of them or build my own kernel -
> as unreasonable as ever.

If your distro does this, then they will have their own rules in place
for supporting this.  Take it up with them if they decide to enable
this.

> Or  are you saying distros should not build the crap modules - that
> doesn't make sense since it will drastically reduce the usage and
> delay the identification of problems until later.

I'm saying distros need to evaluate this based on their own usage /
support model, just like they do so for all other config options.

As an example, for a distro that I know a bit about, I can see openSUSE
enabling this option and supporting these drivers the best that they
can, but for the SLES product line, which doesn't even load any modules
that are not fully L3 supported, these drivers would not be included.

As others have raised, the issue, I'll leave the driver names alone, it
would just confuse people even more if they changed, the modalias flag
is good enough to mark them by for now.

thanks,

greg k-h
