Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbXA3Vqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbXA3Vqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXA3Vqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:46:42 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:17499 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbXA3Vql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:46:41 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="761083302:sNHT45626452"
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<20070130195445.GE22022@kroah.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 13:46:38 -0800
In-Reply-To: <20070130195445.GE22022@kroah.com> (Greg KH's message of "Tue, 30 Jan 2007 11:54:45 -0800")
Message-ID: <adazm80p4qp.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 21:46:40.0601 (UTC) FILETIME=[20111490:01C744B8]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > OK, but why isn't your army of volunteers fixing them?
 > 
 > They don't know about them, or they don't have the hardware to test?
 > Seriously, let the kernel-janitor's project know about any issues you
 > have and they will be glad to jump on it.  Those people are just
 > chomping a the bit to do something a bit bigger than "compiler warning
 > cleanups" :)

I thought you said hardware to test wasn't necessary?

It's not particularly hard to find drivers that need work -- just
looking at everything protected by CONFIG_BROKEN would find plenty of
things to jump on.  Or do "git grep 'cli(' drivers/".

 > > I have a Cisco USB webcam that supposedly conforms to the "USB Video
 > > Device Class", but nothing happens when I plug it into my Linux box.
 > > I assume the device class is specified as part of the USB spec...
 > 
 > Are you sure?  That spec just came out not so long ago and I haven't
 > seen any real devices support it just yet.  That said, I do know of a
 > few people who are working on implementing the standard, try asking on
 > the linux-usb-devel mailing list to find out what their status is.

A quick web search finds http://linux-uvc.berlios.de/ but I don't see
any signs that anyone plans to submit it upstream.

 > > I'm disagreeing with a stronger assertion -- your original email said
 > > that if a vendor just dumps out hardware documentation and donates a
 > > few devices, then that vendor will definitely get a driver that will
 > > be picked up by enterprise distros and run on every Linux platform.
 > > And that just isn't true, or at least experience shows it hasn't been
 > > true until now.

 > Um, that's how Linux has gotten to where it is today and continues to
 > grow. Just because none of us wanted to do IB drivers, doesn't mean that
 > the model doesn't work for devices that are actually sane :)

I disagree -- Linux today gets drivers not just from volunteers
writing drivers from specs, but also from vendors writing drivers and
volunteers writing drivers via reverse engineering.  And many of those
drivers don't work on every platform and aren't supported by
enterprise distros.  And when the community loses interest, drivers
are left to bitrot.

Hardware specs help.  They help a lot.  But they're neither necessary
nor sufficient for getting a high-quality Linux driver written.  And
they definitely don't guarantee continuing maintenance.

 - R.
