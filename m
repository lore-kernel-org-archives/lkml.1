Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZFVVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZFVVCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbZFVVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:02:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42459 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbZFVVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:02:36 -0400
Date: Mon, 22 Jun 2009 23:02:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090622210231.GC24236@elf.ucw.cz>
References: <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FD388.6040801@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FD388.6040801@am.sony.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 11:55:04, Tim Bird wrote:
> Pavel Machek wrote:
> > On Mon 2009-06-22 10:31:28, Tim Bird wrote:
> >> Pavel Machek wrote:
> >>> I did not see that in the changelog. If it is not general purpose
> >>> filesystem, it is lot less interesting.
> >> PRAMFS is not a general purpose filesystem. Please read
> >> the introductory post to this thread, or look at
> >> http://pramfs.sourceforge.net/ for more information.
> > 
> > Yeah, I seen that. It directly contradicts what you say.
> 
> Could you be more specific?  In what way does the
> description on the website contradict what I said?

You are saying top goal is robustness, while the web page says (home
page, stop using frames!):

"embedded systems have a block of non-volatile RAM seperate from
normal system memory, i.e. of which the kernel maintains no memory
page descriptors. For such systems it would be beneficial to mount a
fast read/write filesystem over this "I/O memory", for storing
frequently accessed data that must survive system reboots and power
cycles"

Note the "frequently accessed" and "fast".

IOW the web page is confusing. It does not talk about robustness at
all.


> >> Since the purpose of PRAMFS is to provide a filesystem
> >> that is persistent across kernel instantions, it is not
> >> designed for high speed.  Robustness in the face of
> >> kernel crashes or bugs is the highest priority, so
> >> PRAMFS has significant overhead to make the window
> >> of writability to the filesystem RAM as small as possible.
> > 
> > Really? So why don't you use well known, reliable fs like ext3?
> 
> Are you sure you read the web site?  It directly addresses this
> question.  From the web site: "1. Disk-based filesystems such as

No, it does not. It explains that ext2 would be too slow on this, and
explains that it will eat too much disk space. Please back that claims
with numbers.

If reliability is top concern, explain how you get away w/o
journalling.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
