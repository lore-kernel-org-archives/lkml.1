Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYG2Kh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYG2Kh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYG2Kht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:37:49 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55058 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYG2Kht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:37:49 -0400
Date: Tue, 29 Jul 2008 06:36:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
In-Reply-To: <20080728151441.03410ecd.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807290634510.7057@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain> <20080726094718.b617c1e7.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain> <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
 <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain> <20080728103731.7bafd577.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807281437070.10586@localhost.localdomain> <1217282540.22927.13.camel@zem.phub.net.cable.rogers.com>
 <20080728151441.03410ecd.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Randy Dunlap wrote:

> On Mon, 28 Jul 2008 18:02:20 -0400 Calvin Walton wrote:
>
> > On Mon, 2008-07-28 at 14:42 -0400, Robert P. J. Day wrote:
> > > On Mon, 28 Jul 2008, Randy Dunlap wrote:
> > > it strikes me that, at least on x86, MSDOS partition support is so
> > > fundamental that it should take work for someone to turn it *off*.
> > > perhaps simply have it on by default, and force someone to go under
> > > "Configure standard kernel features (for small systems)"
> > > (CONFIG_EMBEDDED) to make it go away?
> > >
> > >   seriously, how often is someone going to build a kernel for x86 and
> > > not need MSDOS partition support?  just curious.
> > >
> > > rday
> >
> > Naturally, on an architecture other than x86 (e.g. sparc) you'll want to
> > ensure that the platform's native partitioning format (for sparc,
> > SUN_PARTITION) is similarly on by default, and difficult to unselect.
> >
> > In this case, you could get by perfectly without msdos partitions
> > enabled (although the default is still to enable them), unless you want
> > to read a usb key or something.
> >
> > This was the point of the original menu, I think - it allowed each
> > partition type to have a default based on arch, but to hide away the
> > mess of other types unless you feel like overriding it.
> >
> > You'll want to make sure in your patch that arches other than x86 don't
> > lose their own native partitioning types :)
>
> Thanks.  I won't bother pushing the latest patch.  :)

so, just to be clear, the consensus is to just leave it alone as it's
more trouble than it's worth to do anything about?

rday

p.s.  and don't get me started on that "CONFIG_EMBEDDED" menu.
grrrrrr ...
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
