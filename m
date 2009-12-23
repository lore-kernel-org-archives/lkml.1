Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZLWAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZLWAz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZLWAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:55:27 -0500
Received: from kroah.org ([198.145.64.141]:45008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZLWAz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:55:26 -0500
Date: Tue, 22 Dec 2009 16:54:47 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Staging tree status for the .33 kernel merge
Message-ID: <20091223005447.GA28941@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a summary of the state of the drivers/staging/ tree, basically
what will be coming in the 2.6.33 merge, and what the status of the
different drivers are so far.

Sorry it's late (after the merge), but hey, better late than never.

Again, drivers/staging/ is NOT a dumping ground for dead code.  If no
one steps up to maintain and work to get the code merged into the main
portion of the kernel, the drivers will be removed.

Also, drivers can now be merged from mainling into the staging
directory, providing a path out of the kernel for some obsolete and/or
broken drivers.

So, here's some drivers that will be removed in the 2.6.33 kernel:
  - android drivers.  Google and no one else stepped up to maintain
    them, so they will be dropped.  So sad...
  - dst.  The developer isn't working on this anymore and recommended
    that it be removed as no one is using it.

Here is some new drivers that will show up in .33:
  - arlan, netwave, strip, wavelan - wireless drivers that are on
    their way out of the kernel.  If anyone is actually using this old,
    obsolete hardware, speak up soon, otherwise they will be removed in
    a few kernel releases.
  - ramzswap - a compressed ram driver
  - rtl8192u - yet another wireless driver
  - samsung-laptop - laptop for the N128 Samsung laptop
  - batman-adv - a network protocol
  - dt3155 - a frame grabber driver
  - sm7xx - another frame buffer driver

Here's the list of drivers that have had work done on them that will
show up in the .33 release:
  - comedi - lots of development effort happened here, mostly all
    cleanups, but there are some logic changes.  More is needed, and
    it's moving along nicely.
  - line6 - lots of work happening, very nice to see
  - rt* - loads of cleanups and other merges.  Will be obsolete soon due
    to a "real" wireless driver being worked on, but it's still nice to
    have these be a working alternative until then.
  - rtl* - more wireless driver work, horrible code, but it seems to
    work for the users.  Hopefully more development time can be spent
    here in the new year.
  - dream - here's the platform specific code for the Android G1
    platform.  This might be the way the android code sneaks back into
    the kernel, as there is developers trying to get this to work.  Of
    course, it's all happening without Google's help. {sigh}
  - et131x - loads of cleanups, more left to do.  Good solid progress
    happening here.
  - iio - a new driver added to this subsystem, along with other fixes
    and cleanups.  Looking nice.
  - poch - still some work happening, nice to see it pick back up.
  - panel - minor cleanups.
  - vme - cleanups and minor tweaks, still alive and kicking
  - vt66* - more wireless drivers, will be obsoleted by a "real" driver
    again.
  - wlags49 - more cleanup work as well.

Here's some drivers not listed so far, that have had work done recently,
after the 2.6.33-rc1 merge happened, so it has to wait for the .34
kernel release:
  - wlan-ng
  - slicoss
  - mimo
  - asus_oled
  - udlfb
  - w35und

Hm, so, what's up with all of the other staging drivers, and why have
they not had any development?  What is the status of them?  They are now
on the short list to be deleted in 2 kernel releases, unless some _real_
development happens on them.

This means, unless someone steps up and starts doing real work (not
trivial spelling fixes) on the following drivers, they will be removed
in the future kernel releases.

 - arlan, netwave, strip, wavelan - wireless drivers mentioned above
   that are on the way out.  Slated for removal in 2.6.35
 - hv - Microsoft Hyper V drivers.  The developers again seem to have
   disappeared, this is getting old. Slated for removal in 2.6.35
 - p9auth - this will be removed in .34 unless someone steps up.
 - frontier - slated for removal in .35.  Will be easy for someone to
   pick up if they want to (hint, hint, hint)
 - altpciechdma - this will be removed in .34 unless someone steps up.
 - b3dfg - this will be removed in .34 unless someone steps up.
 - pohmelfs - filesystem under development out of tree, would be nice
   to get the patches merged back into here
 - quatech_usb2 and serqt_usb2 - usb to serial drivers that need to get
   merged into mainline.
 - rar and sep - Intel needs to step up here and get this code cleaned
   up properly, or it too will be removed.

Again, if someone is looking for some kernel development work to do,
picking any of the above drivers up to get them merged into mainline,
would be a great thing to do.

And, on a final, and sadder note, I'd like to announce the failure of
the driver project to complete a driver for a company that requested it.
This was totally my fault, and I would publically like to apologize
about my lack of getting a SCSI driver written in time for a company
that had asked for it.  So, while the Linux driver project is doing
great work for a large number of companies, every once in a while we do
fail, we are only human.

thanks,

greg k-h
