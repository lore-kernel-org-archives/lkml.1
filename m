Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXFNMeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXFNMeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXFNMeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:34:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31566 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXFNMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:34:13 -0400
Date: Thu, 14 Jun 2007 08:30:53 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, snitzer@gmail.com
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070614123053.GL28279@think.oraclecorp.com>
References: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com> <20070613120037.GA28279@think.oraclecorp.com> <787b0d920706130914l676a24cau62525e90a90b5839@mail.gmail.com> <20070613165706.GF28279@think.oraclecorp.com> <787b0d920706132359h17531f57gdc4ed01724e53361@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706132359h17531f57gdc4ed01724e53361@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:59:23AM -0400, Albert Cahalan wrote:
> On 6/13/07, Chris Mason <chris.mason@oracle.com> wrote:

[ secure deletion in btrfs ]

> >
> >Right about here is where I would insert a long story about ecryptfs, or
> >encryption solutions that happen all in userland.  At any rate, it is
> >outside the scope of v1.0, even though I definitely agree it is an
> >important problem for some people.
> 
> I'm sure you do have a nice long story, and I'm sure it seems
> correct, but there is something not quite right about the add-on
> hacks.
> 
> BTW, I'm suggesting that this be about deletion, not protection
> of data you wish to keep. It covers more than just file bodies.
> It covers inode data, block allocations, etc.

Sorry, it's still way outside the scope of v1.0.

> 
> >> >> * atomic creation of copy-on-write directory trees
> >> >
> >> >Do you mean something more fine grained than the current snapshotting
> >> >system?
> >>
> >> I believe so. Example: I have a linux-2.6 directory. It's not
> >> a mount point or anything special like that. I want to copy
> >> it to a new directory called wip, without actually copying
> >> all the blocks. To all the normal POSIX API stuff, this copy
> >> should look like the result of "cp -a", not hard links.
> >
> >This would be a snapshot, which has to be done on a subvolume right now.
> >It is not as nice as being able to pick a random directory, but I've
> >only been able to get this far by limiting the feature scope
> >significantly.  What I did do was make subvolumes very cheap...just make
> >a bunch of them.
> 
> Can a regular user create and use a subvolume? If not, then
> this doesn't work. (if so, then I have other concerns...)

That's the long term goal, but I'll have to reorganize things such that
subvolumes created by a user can all fall under sane accounting.

-chris

