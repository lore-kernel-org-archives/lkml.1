Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZG1Sxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZG1Sxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZG1Sxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:53:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbZG1Sxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:53:46 -0400
Date: Tue, 28 Jul 2009 11:51:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle Moffett <kyle@moffetthome.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Zachary Amsden <zamsden@redhat.com>,
       Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com, tytso@mit.edu,
       miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
In-Reply-To: <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0907281147280.3186@localhost.localdomain>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins>  <20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org>  <4A6E764E.80805@redhat.com> <20090728112734.5a75752d@lxorguk.ukuu.org.uk> 
 <alpine.LFD.2.01.0907280851360.3186@localhost.localdomain> <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Kyle Moffett wrote:

> On Tue, Jul 28, 2009 at 12:00, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> >
> > I've since learnt to not use DM (and instead doing a very inconvenient
> > "partition everything by hand because the install tool doesn't allow for
> > any simple automated way to make a sane install"), and to just put /home
> > on one disk and / on the other, and then I can way more easily just move
> > my /home disk around, for example.
> 
> That's not so much an argument against LVM as it is an argument for
> fixing those distro installer tools... 

Oh, I agree. I'd love the distros to not force DM on me.

But that wasn't my point. My point was that people who argue for DM (and 
user-space tools for partition detection) always argue without even taking 
the disadvantages into account.

> Using device-mapper to map standard Linux partition-tables has the 
> following benefits:

You're missing the point.

I _know_ the benefits. I'm pointing out the problems and downsides. Which 
too often get ignored, just because people think that the benefits are 
so big, and benefits to everybody. They're not. 

The whole dynamic resizing etc is totally worthless for many users: the 
fact that it is an advantage to _some_ doesn't make it an advantage to 
everybody. And some of the advantages you mention (naming by mount-point 
or UUID or etc) have nothing to do with DM itself, and work fine without 
it.

		Linus
