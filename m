Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXETMw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXETMw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 08:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXETMwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 08:52:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbXETMwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 08:52:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc2: make -j makes it unresponsive
Date: Sun, 20 May 2007 14:57:26 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201457.26716.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 19 May 2007 07:17, Linus Torvalds wrote:
> 
> It's out there, both patches/tarballs and git trees are updated (although 
> mirroring might still be ongoing)
> 
> Various random fixes all over - the shortlog (appended) is fairly 
> readable. The most notable ones are probably more SLUB fixes, and the 
> epoll optimizations and cleanups.
> 
> But there's stuff in architectures (ia64, SH, AVR32, POWER), libata, 
> network drivers, sound.. Give it a try.
> 
> I've been telling some people off on merging stuff, and I'll get even more 
> hard-nosed about it after -rc2, so please don't even try to send anything 
> but real fixes.
> 
> I think the current situation looks reasonably good for 2.6.22, but I hope 
> everybody will take a good look at the regression lists (whether they 
> _think_ they are affected or not), and spend some time wondering "was that 
> anything I did, or is it something I can look at". Ok?

Running 'make -j' kernel compilation on my test box (Athlon64 X2, 2 SATA drives
with 6 software RAID1 ext3 and reiserfs partitions, 2 GB of RAM) makes it
completely unresponsive.  I can't even move the mouse pointer when it's
running, I can't log to the box from the network etc.

The anticipatory IO scheduler is used.

Greetings,
Rafael
