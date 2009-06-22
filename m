Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZFVRUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZFVRUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZFVRUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:20:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42376 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZFVRUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:20:09 -0400
Date: Mon, 22 Jun 2009 19:20:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090622172003.GB21149@elf.ucw.cz>
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How do you handle hard-links, then?
> 
> Indeed hard-links are not supported :) Due to the design of this fs
> there are some limitations explained in the documentation as not
> hard-link, only private memory mapping and so on. However this
> limitations don't limit the fs itself because you must consider the
> special goal of this fs.

I did not see that in the changelog. If it is not general purpose
filesystem, it is lot less interesting.

> >> >From performance point of view:
> >>
> >> Sometimes ago I uploaded here (http://elinux.org/Pram_Fs) some benchmark
> >> results to compare the performance with and without XIP in a real
> >> embedded environment with bonnie++. You could use it as reference point.
> >
> > Well, so XIP helps. ext2 can do XIP too, IIRC. Is your performance
> > better than ext2?
> >
> > Wait... those numbers you pointed me... claim to be as slow as
> > 13MB/sec. That's very very bad. My harddrive is faster than that.
> 
> As I said I did the test in a real embedded environment so to have
> comparable result you should use the same environmente with the same
> tools, with the same workload and so on.

Even on real embedded hardware you should get better than 13MB/sec
writing to _RAM_. I guess something is seriously wrong with pramfs.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
