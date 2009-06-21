Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZFUGqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZFUGqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 02:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZFUGqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 02:46:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41580 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZFUGp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 02:45:59 -0400
Date: Sun, 21 Jun 2009 08:40:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco <marco.stornelli@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090621064040.GC1656@ucw.cz>
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A34A394.5040509@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Why is an entire filesystem needed, instead of simply a block driver
> > if the ramdisk driver cannot be used?
> > 
> 
> >From documentation:
> 
> "A relatively straight-forward solution is to write a simple block
> driver for the non-volatile RAM, and mount over it any disk-based
> filesystem such as ext2/ext3, reiserfs, etc.
> 
> But the disk-based fs over non-volatile RAM block driver approach has
> some drawbacks:
> 
> 1. Disk-based filesystems such as ext2/ext3 were designed for optimum
>    performance on spinning disk media, so they implement features such
>    as block groups, which attempts to group inode data into a contiguous
>    set of data blocks to minimize disk seeking when accessing files. For
>    RAM there is no such concern; a file's data blocks can be scattered
>    throughout the media with no access speed penalty at all. So block
>    groups in a filesystem mounted over RAM just adds unnecessary
>    complexity. A better approach is to use a filesystem specifically
>    tailored to RAM media which does away with these disk-based features.
>    This increases the efficient use of space on the media, i.e. more
>    space is dedicated to actual file data storage and less to meta-data
>    needed to maintain that file data.

So... what is the performance difference between ext2 and your new
filesystem?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
