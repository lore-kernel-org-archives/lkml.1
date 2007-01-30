Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbXA3TaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbXA3TaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXA3TaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:30:06 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:4161 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbXA3TaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:30:04 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="358521212:sNHT98208042"
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 11:29:58 -0800
In-Reply-To: <20070130191020.GF20642@kroah.com> (Greg KH's message of "Tue, 30 Jan 2007 11:10:20 -0800")
Message-ID: <adaodogqpmx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 19:30:00.0521 (UTC) FILETIME=[08702B90:01C744A5]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I'm all for openness of device programming specs, but I think it's a
 > > bit disingenous to suggest that all a company has to do to get a
 > > driver written and supported is throw some documentation over the
 > > wall.  And it's crazy to suggest that the driver will work on every
 > > platform and be supported by enterprise distros.
 > 
 > Why is that crazy, we do that already today with the majority of drivers
 > in Linux.

Well, we can disagree about the majority of drivers.  My feeling is
that most of the drivers that are really used by lots of people get
support beyond just a dump of docs -- in fact often vendors are
maintaining them, eg e1000, tg3, cciss, etc., to pick some running on
the boxes I have around here.

 > > Just look at the in-tree drivers: there are tons of them that don't
 > > work on big-endian platforms, or have 64-bit problems, or have no SMP
 > > support.  And that doesn't even count drivers that are so bitrotted
 > > they won't even build any more.
 > 
 > Like Jeff said, many of these are quite old.

OK, but why isn't your army of volunteers fixing them?

 > > And there are plenty of documented devices that no one cares enough
 > > about to submit a driver for.
 > 
 > Any specific examples?  I have a long list of people who wish to write
 > new drivers but just don't know which hardware is not yet supported.

I have a Cisco USB webcam that supposedly conforms to the "USB Video
Device Class", but nothing happens when I plug it into my Linux box.
I assume the device class is specified as part of the USB spec...

And I seem to recall there's more SATA chipset documentation than Jeff
Garzik has time to implement support for.

 > > In the real world, a vendor that wants to make sure a device is
 > > supported by Linux had better pay someone to write the driver and keep
 > > it working.  Of course, if the device is popular enough or simple
 > > enough, docs are all that's needed, but in many cases no one competent
 > > to write the driver is going to volunteer to do it.
 > 
 > That's not true at all.  We have a whole raft of drivers in the kernel
 > that are supported only by the community (like the whole USB stack for
 > example) that vendors rely on working properly.

Sure, I agree 100% that the community can deliver great drivers when
sufficient interest, documentation, and testing resources are all
available.  And of course sufficient interest and testing resources
can substitute for documentation and vendor support -- cf forcedeth,
which was written with no documentation at all.

I'm disagreeing with a stronger assertion -- your original email said
that if a vendor just dumps out hardware documentation and donates a
few devices, then that vendor will definitely get a driver that will
be picked up by enterprise distros and run on every Linux platform.
And that just isn't true, or at least experience shows it hasn't been
true until now.

 - R.
