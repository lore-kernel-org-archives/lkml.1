Return-Path: <linux-kernel-owner+w=401wt.eu-S1031195AbXD1TdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031195AbXD1TdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031200AbXD1TdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:33:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031195AbXD1TdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:33:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Lang <david.lang@digitalinsight.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 21:37:19 +0200
User-Agent: KMail/1.9.5
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704281235.37102.rjw@sisk.pl> <Pine.LNX.4.63.0704281139500.11638@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704281139500.11638@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282137.20632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 20:43, David Lang wrote:
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> > On Friday, 27 April 2007 12:12, Pekka J Enberg wrote:
> >> The problem with writing in the kernel is obvious: we need to add new code
> >> to the kernel for compression, encryption, and userspace interaction
> >> (graphical progress bar) that are important for user experience.
> >
> > Yes, and that's why we wanted to introduce the userland part.  The problem
> > with this approach, as it's turned out, is that the userland part must be a
> > very specialized piece of software, really careful of what it's doing, mainly
> > because of the inability to checkpoint filesystems.  If we could checkpoint
> > filesystems and were able to unfreeze the user space after creating the
> > snapshot without the risk of corrupting filesystems in the restore phase,
> > the userland part could be much simpler (even as simple as Linus suggested).
> 
> this sounds like a really good argument for having a useable userspace running. 
> we already have the LVM snapshot code in the kernel, so we have the pieces 
> available to protect the filesystems, we just need to figure out how to put them 
> togeather. (the simpliest way would be to make a new suspend package that 
> required the user to use LVM so that snapshots are available, but this is also 
> the most disruptive approach)

Yes.  I personally know very little about the LVM snapshot code and I wasn't
aware of its capabilities.  If we can make it possible to run the user space
safely after we've created the memory snapshot, I'm all for it.

As far as the package is concerned, we can just add the new user space tools
to the suspend package containing our existing userland part.

Greetings,
Rafael
