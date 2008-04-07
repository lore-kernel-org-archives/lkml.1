Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYDGKvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYDGKvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYDGKvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:51:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYDGKvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:51:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7/8: Another resume regression
Date: Mon, 7 Apr 2008 12:51:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, david-b@pacbell.net,
       oliver@neukum.org, Alan Stern <stern@rowland.harvard.edu>,
       Dave Airlie <airlied@linux.ie>, Jesse Barnes <jesse.barnes@intel.com>,
       Pavel Machek <pavel@ucw.cz>
References: <200803220259.48534.rjw@sisk.pl> <47F52AAC.8090005@rtr.ca> <47F6E393.10904@rtr.ca>
In-Reply-To: <47F6E393.10904@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071251.03147.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of April 2008, Mark Lord wrote:
> Mark Lord wrote:
> > Hi,
> > 
> > Okay, USB now works fine on resume after fixing the iaa_watchdog issue.
> > 
> > But twice now, once before that fix, and again just a minute ago,
> > my machine has failed completely to resume after suspend-to-RAM.
> > 
> > Again, resume here is 100% reliable in 2.6.24 and earlier.
> > 
> > Symptoms: the usual:
> > 
> >  -- 2.6.25-rc8 (and -rc7 earlier), plus USB fix.
> >  -- not reproduceable on demand.
> >  -- black screen of death -- no backlight, no kernel messages.
> >  -- no hard drive activity.
> >  -- no alt-sysrq-anything.
> >  -- 5 second hold of the power button to poweroff and then recover.
> > 
> > Not much info to go on, but it's worth knowing there's an issue here 
> > somewhere.
> ..
> 
> Mmmm... Now that 2.6.25-rc* is usable here, there's another symptom
> that's been happening regularly enough that it's got to be a regression
> of some sort.
> 
> This machine has an ATI X1400 video card, which doesn't work with any
> open source X server that I know of.  Maybe latest RadeonHD would work
> but it didn't when I tried it in January.
> 
> So I'm using the ATI binary fglrx X server, but without their kernel module,
> so no 3D acceleration (fine.. only affects Google Earth, really).
> 
> Now.. on 2.6.25, after a suspend/resume cycle (or three), the framebuffer
> frequently starts going wonky.  "snowy" pixels appear, and stay.
> Just a moment ago here, the entire background changed to zebra stripes.
> 
> And so on..  Peculiar stuff.
> 
> I'm wondering if something to do with video mode switching,
> or video register save/restore, has changed since 2.6.24.
> Because it's broken in 2.6.25, yet works fine in all earlier kernels.

Yes, that's probably related.

However, I'm unable to reproduce the breakage.  If you can do that, it would
probably help a lot if you identified the commit causing that to happen.

I also wonder if this report might be related to it:
http://marc.info/?l=linux-acpi&m=120669137831005&w=4

Thanks,
Rafael
