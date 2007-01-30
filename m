Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXA3Rp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXA3Rp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965649AbXA3Rp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:45:59 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27003 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965646AbXA3Rp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:45:58 -0500
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 09:45:50 -0800
In-Reply-To: <20070130012904.GA9617@kroah.com> (Greg KH's message of "Mon, 29 Jan 2007 17:29:04 -0800")
Message-ID: <ada8xfks90x.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 17:45:50.0980 (UTC) FILETIME=[7B6BE440:01C74496]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > All that is needed is some kind of specification that describes how your
 > device works, or the email address of an engineer that is willing to
 > answer questions every once in a while.  A few sample devices might be
 > good to have so that debugging doesn't have to be done by email, but if
 > necessary, that can be done.

 > This driver will work with all[1] of the different
 > CPU types supported by Linux, the largest number of CPU types supported
 > by any operating system ever before in the history of computing.

 > As for support, the driver will be supported through email by the
 > original developers, when they can help out, and by the "enterprise"
 > Linux distributors as part of their service agreements with their
 > customers.

I'm all for openness of device programming specs, but I think it's a
bit disingenous to suggest that all a company has to do to get a
driver written and supported is throw some documentation over the
wall.  And it's crazy to suggest that the driver will work on every
platform and be supported by enterprise distros.

Just look at the in-tree drivers: there are tons of them that don't
work on big-endian platforms, or have 64-bit problems, or have no SMP
support.  And that doesn't even count drivers that are so bitrotted
they won't even build any more.  And there are plenty of documented
devices that no one cares enough about to submit a driver for.

In the real world, a vendor that wants to make sure a device is
supported by Linux had better pay someone to write the driver and keep
it working.  Of course, if the device is popular enough or simple
enough, docs are all that's needed, but in many cases no one competent
to write the driver is going to volunteer to do it.

 - R.
