Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYCZXwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYCZXwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYCZXvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:51:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41921 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbYCZXvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:51:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: Suspend and hibernation patchset against -rc7
Date: Thu, 27 Mar 2008 00:51:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl>
In-Reply-To: <200803172317.33745.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270051.31778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 17 of March 2008, Rafael J. Wysocki wrote:
> On Wednesday, 12 of March 2008, Rafael J. Wysocki wrote:
> >
> > For everyone interested, I have put together a patchset containing some "fresh"
> > patches related to suspend and hibernation, on top of 2.6.25-rc5, located at:
> > 
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc5/patches/
> 
> There's a new patchset against 2.6.25-rc6 at:
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc6/patches/

There's a new patchset against 2.6.25-rc7 at:

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc7/patches/

It contains some more patches than the previous one.  Most importantly,
there are pm-remove-destroy_suspended_device.patch (from me) and
ACPI-force-acpi_new_pts_ordering-for-ASUS-A6VC-laptop.patch (from Shaohua) in
it.

I still have not decided what to do with patches 01-03.  Patch 03 will probably
be sent upstream soon, as well as patches 12 and 14.

Patch 04 is currently in the "test" branch of the ACPI tree and has been
tested already for some time in -mm and linux-next.

Patches 05-11 are in the Greg's tree and have been tested in -mm and
linux-next.

Patch 13 is in -mm.

Patches 15-17 are new, but they don't crash my box, so hopefully they're not
broken. ;-)
 
Everything has been compiled and (lightly) tested on HP nx6325 (64-bit).

Thanks,
Rafael
