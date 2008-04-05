Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYDES1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYDES1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYDES1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:27:39 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:34603 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYDES1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:27:39 -0400
Date: Sat, 5 Apr 2008 20:27:09 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080405202709.2cd03212@mjolnir.drzeus.cx>
In-Reply-To: <20080405171209.GA28388@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	<20080404210132.GA14418@suse.de>
	<20080405115727.1265e8a9@mjolnir.drzeus.cx>
	<20080405155323.GA27252@suse.de>
	<20080405185501.41ec42a7@mjolnir.drzeus.cx>
	<20080405171209.GA28388@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008 10:12:09 -0700
Greg KH <gregkh@suse.de> wrote:

> On Sat, Apr 05, 2008 at 06:55:01PM +0200, Pierre Ossman wrote:
> > If I do this threaded, I'd have to return success to the driver core
> > and then act like a possum later.
> 
> Yes.
> 
> > Doable, but not very clean.
> 
> Hey, take it up with the hardware designers compensating for an
> "unclean" operating system :)
> 

I have. And unfortunately that other operating system is just too big
of a market to ignore. :/

This is a cooperating vendor though, which is why I'm trying to put a
bit more extra effort into actually getting their devices fully
supported. Telling them to ditch Windows support is asking too much.

Anyway, a big part of my reluctance to go this route is that this chip
is just one of many the driver supports. So I'm not thrilled to do some
funky architecture for this device as it'll most certainly cause me
pain for the others...

> I don't think that a time-out would be a big deal, it shouldn't be very
> long (a second or two).  Also note that all distros would not have this
> problem as they do pci discovery first, and then start loading all of
> the modules in the initramfs after the pci tree has been properly
> scanned.  So the very large majority of users would not have a problem.
> 
> Or are you doing this on an embedded system?
> 

No, it's primarily desktop. But these chips are available as
ExpressCards, so I'm trying to get them to work when hot-plugged as
opposed to when permantently wired into the machine.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
