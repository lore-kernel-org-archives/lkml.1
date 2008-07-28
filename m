Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYG1SwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYG1SwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYG1SwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:52:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16182 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYG1SwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:52:04 -0400
Date: Mon, 28 Jul 2008 11:51:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
Message-Id: <20080728115112.282f3585.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0807281437070.10586@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
	<20080726094718.b617c1e7.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
	<1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
	<alpine.LFD.1.10.0807280531210.3402@localhost.localdomain>
	<20080728103731.7bafd577.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807281437070.10586@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 14:42:47 -0400 (EDT) Robert P. J. Day wrote:

> On Mon, 28 Jul 2008, Randy Dunlap wrote:
> 
> > >   yes, it's nitpicking but, as it's laid out right now, it's
> > > unnecessarily confusing and inconsistent.  but i don't know if
> > > there's a trivial fix for it.
> >
> > Yes, I'd call MSDOS partitions basic, not Advanced, and then put all
> > others under an Advanced menu that can be toggled on/off easily with
> > menuconfig.
> >
> > Not quite trivial, but not messy either.
> >
> > Patch below.  Comments?
> 
> ... patch snipped ...
> 
>   i suspect that's as good as it's going to get, but it's unfortunate
> that it adds yet another level of submenu under "Partition types."

I looked but didn't see a way to avoid that.

> personally, i was pondering a top level submenu entry of "Advanced
> partition types" in which the (non-advanced) MSDOS partition support
> was yanked out of there *entirely*.

I did that first but left MSDOS partitioning in the main FS menu.
I didn't like it being separated from the others.

>   it strikes me that, at least on x86, MSDOS partition support is so
> fundamental that it should take work for someone to turn it *off*.
> perhaps simply have it on by default, and force someone to go under
> "Configure standard kernel features (for small systems)"
> (CONFIG_EMBEDDED) to make it go away?

That could be done, but still, I'd rather have all of the partition types
close together instead of far apart.

>   seriously, how often is someone going to build a kernel for x86 and
> not need MSDOS partition support?  just curious.

since MP3 players & cameras use it?  :)
Other than that, I could do without it for awhile.


Thanks.
---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
