Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYIZUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYIZUdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYIZUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:33:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:37587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYIZUdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:33:01 -0400
Date: Fri, 26 Sep 2008 13:19:17 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080926201917.GA2591@suse.de>
References: <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925042108.GA3931@suse.de> <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com> <20080925205328.GB11225@suse.de> <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com> <20080925220454.GA12116@suse.de> <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com> <48DD2BA3.7050808@s5r6.in-berlin.de> <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 04:11:49PM -0400, Parag Warudkar wrote:
> On Fri, Sep 26, 2008 at 2:36 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > It _is_ necessary.  I for one don't want to have to remember that driver
> > foobar was in "staging" state in kernel 2.6.31-rc5, but not anymore in
> > 2.6.32-rc1.
> 
> Just name the staging modules with _stg prefix like I said - easier to
> spot _stg in the module list than decoding the taint.

Um, it's the same, the taint is decoded automatically for you, no need
to strain any brain cells trying to figure it out :)

If people really want a prefix, sure, I have no objection, that's simple
to add.

> Whenever (doubtful tone here) it graduates, remove the suffix.

5 drivers "graduated" last release cycle, so it will happen.

> Driver modules load automatically any way so the name change is not
> going to make a difference.

Agreed.

> It is nice to not have to change core kernel code and annoy users with
> warnings for the staging crap even if it is just 24 lines or whatever
> - if we can - and I don't see why we cannot. Staging, just like
> crapping, has to be a totally isolated, zero side effect, zero
> annoyance (to others) type thing :) So let's please get rid of that
> taint and warning already :)

No, that was one of the requirements that came out of the discussions at
the kernel summit, I'm going to leave both the warning and the modalias
and taint flag there, sorry.

If you really don't like it, just never enable any of these modules,
you'll never be bothered by it.

thanks,

greg k-h
