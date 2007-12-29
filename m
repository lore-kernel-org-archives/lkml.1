Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXL2Uk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXL2Uk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXL2Ukt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:40:49 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:39509 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXL2Uks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:40:48 -0500
Date: Sat, 29 Dec 2007 12:40:47 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: David Newall <david@davidnewall.com>
cc: Mark Lord <lkml@rtr.ca>, Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <4776AF82.6010808@davidnewall.com>
Message-ID: <alpine.DEB.0.999999.0712291239360.5207@twinlark.arctic.org>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
 <47760578.2090305@davidnewall.com> <alpine.DEB.0.999999.0712290754230.5207@twinlark.arctic.org> <4776AF82.6010808@davidnewall.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Dec 2007, David Newall wrote:

> dean gaudet wrote:
> > > Pffuff.  That's what volume managers are for!  You do have (at least) two
> > > independent spindles in your RAID1 array, which give you less need to
> > > worry
> > > about head-stack contention.
> > >     
> > 
> > this system is write intensive and writes go to all spindles, so you're
> > assertion is wrong.
> 
> I don't know what you think I was asserting, but you were wrong.  Of course
> I/O is distributed across both spindles.  You would expect no less.  THAT is
> what I was telling you.

are you on crack?

it's a raid1.  writes go to all spindles.  they have to.  by definition.  
reads can be spread around, but writes are mirrored.

> 
> > the main worry i have is some user maliciously hardlinks everything
> > under /var/log somewhere else and slowly fills up the file system with
> > old rotated logs.  the users otherwise have quotas so they can't fill
> > things up on their own.  i could probably set up XFS quota trees (aka
> > "projects") but haven't gone to this effort yet.
> >   
> 
> See, this is where you show that you don't understand the system.  I'll
> explain it, just once.  /var/home contains  home directories.  /var/log and
> /var/home are on the same filesystem.  So /var/log/* can be linked to
> /var/home/malicious, and that's just one of your basic misunderstandings.

yes you are on crack.

i told you i understand this exactly.  it's right there in the message 
sent.

> No.  Look, you obviously haven't read what I've told you.  I mean, it's very
> obvious you haven't.  I'm wasting my time on you and I'm now out of
> generosity.  Good luck to you.  I think you need it.

you're the idiot not actually reading my messages.

-dean
