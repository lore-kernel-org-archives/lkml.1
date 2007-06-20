Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXFTOFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXFTOFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXFTOFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:05:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbXFTOFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:05:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Date: Wed, 20 Jun 2007 16:12:09 +0200
User-Agent: KMail/1.9.5
Cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0706200959090.3311-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706200959090.3311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201612.10584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 June 2007 16:01, Alan Stern wrote:
> On Wed, 20 Jun 2007, Mattia Dongili wrote:
> 
> > On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > 
> > Hello,
> > on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
> > is becoming troublesome as different sets have slightly different
> > problems.
> > At one point (with the GREGKH usb stuff built) I had the kernel
> > reporting it cannot stop the usb-storage thread so I guess that
> > something later in the series made things worse (freezable workqueues?).
> > 
> > Clues?
> 
> The usb-storage thread is supposed to be unfreezable.  Recent changes 
> may have messed up the code that checks for which threads need to be 
> frozen and which don't.

I don't really think so, but well ...

That's why I asked Mattia to test the hibernation/suspend patches without
the rest of -mm.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
