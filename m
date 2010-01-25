Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352Ab0AYRaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0AYRaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858Ab0AYR36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:29:58 -0500
Received: from kroah.org ([198.145.64.141]:58382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0AYR35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:29:57 -0500
Date: Mon, 25 Jan 2010 09:15:24 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Xiaotian Feng <dfeng@redhat.com>, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
Message-ID: <20100125171524.GA17421@kroah.com>
References: <20100123001145.GA7391@kroah.com>
 <20100123232152.4b88d1e3.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 05:29:26PM +0100, Thomas Gleixner wrote:
> On Sat, 23 Jan 2010, Andrew Morton wrote:
> 
> > On Fri, 22 Jan 2010 16:11:45 -0800 Greg KH <gregkh@suse.de> wrote:
> > 
> > > This is the start of the stable review cycle for the 2.6.32.6 release.
> > > There are 29 patches in this series, all will be posted as a response to
> > > this one.  If anyone has any issues with these being applied, please let
> > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > > Responses should be made by Monday, January 24, 00:00:00 UTC.
> > > Anything received after that time might be too late.
> > 
> > 2.6.32.6 will still contain the regression described in (for example)
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=15117 
> > http://bugzilla.kernel.org/show_bug.cgi?id=15005
> > 
> > It's fixed with the below revert which has been in -mm (and only in
> > -mm) for ten days.
> > 
> > I don't what's going on - perhaps we're waiting for Thomas, and he's
> > otherwise engaged.  There's a fix in the lkml thread "Re: [RFC PATCH
> > 0/4] clockevents: fix clockevent_devices list corruption after cpu
> > hotplug" to which Thomas replied
> > 
> >     I just applied your patch, but kept the cpuweight check.  This
> >     is the least intrusive solution for now.  The logic needs an
> >     overhaul, but thats neither rc4 nor stable material"
> 
> Just sent the pull request for it. Sorry for the delay. The patch
> needs to go into 32.6 as well.

So that would be commit id ea9d8e3f45404d411c00ae67b45cc35c58265bb7 ?

Or something else?

I'll queue that one up for the next .32 stable update, but will refrain
from having it in this specific release in an hour, as there has not
been any time to test it all out.  I will start up a round for the next
.32 kernel right afterward, later today, with this patch in it.

thanks,

greg k-h
