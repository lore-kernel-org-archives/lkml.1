Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYAJOCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYAJOCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYAJOCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:02:13 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60835 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbYAJOCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:02:12 -0500
Date: Thu, 10 Jan 2008 09:02:11 -0500
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Matthias Schniedermeyer <ms@citd.de>, Tuomo Valkonen <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080110140211.GK2310@csclub.uwaterloo.ca>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <20080108230600.GA9071@citd.de> <478601D7.90004@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478601D7.90004@aitel.hist.no>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 12:30:31PM +0100, Helge Hafting wrote:
> >- fstab -
> >LABEL=root  /        xfs     defaults,noatime	0 1
> >LABEL=boot  /boot    ext2    defaults,noatime	0 2
> >  
> Would've been nice if they worked, but they don't.
> 
> Disks should be so easy to identify uniquely, because they have
> storage space that can be used for that label.
> 
> So I tried (debian linux, last year).
> 
> Mount by label was fine, of course.
> Until the 33rd reboot, when it was decided that a
> fsck was necessary "just to be safe".  The problem was that fsck
> fail to find the correct device when /etc/fstab specifies a label
> instead of a device. The boot failed, reboot with init=/bin/sh
> and replace the dysfunctional labels with oldfashioned device names.
> 
> I can live with this kind of problem on my desktop, but this machine
> was going to be a internet router for a customer, so occational
> boot failure requiring intervention was not an option.

I use this:
UUID=35963d32-f15e-497e-859a-ed1cb366b0f3 / ext3 defaults        0       1

No problem with fsck or anything on my debian system.  I had problems
trying to use LABELs but UUID always worked when I tried it.  Back under
sarge I had problems getting it to work though.

Works much better than trying to use disk names, since I have 3
different IDE controllers and the modules seem to never quite initialize
in the same order every time from the initramfs.

--
Len Sorensen
