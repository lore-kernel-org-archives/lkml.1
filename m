Return-Path: <linux-kernel-owner+w=401wt.eu-S1763203AbYBVRqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763203AbYBVRqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbYBVRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:45:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbYBVRpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:45:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Fri, 22 Feb 2008 18:44:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802221802.18640.rjw@sisk.pl> <47BF071C.6040308@rtr.ca>
In-Reply-To: <47BF071C.6040308@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221844.31579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Mark Lord wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 22 of February 2008, Mark Lord wrote:
> >> david@lang.hm wrote:
> >> ..
> >>> I've been watching for kexec hibernate for a little while now, and the 
> >>> last I saw was that acpi was incompatible with the kexec hibernate (but 
> >>> the suspend folks were still claiming that devices needed to be put in 
> >>> the 'right mode' not just powered off. I've been waiting to see this 
> >>> resolved.
> >> ..
> >>
> >> Yeah, exactly.  What's so special about poweroff on hibernation?
> >> Why even bother with the special "S4" state there?
> > 
> > (1) To be able to wake up with the help of devices that can't wake
> >     the system up from S5 (power off)
> > (2) To handle some platform devices appropriately over the cycle
> ..
> 
> That's the theory.  I've read about it, but have yet to imagine
> any real-life situation where it applies.
> 
> But this isn't my speciality, so.. do you have experience with any real examples?

Yup.  The fan in my notebook behaves incorrectly after a resume from
hibernation if S5 is entered instead of S4 during it.

I don't know why exactly it happens, but that's how it goes.

Also, some machines are reported to behave incorrectly after a "shutdown"
mode hibernation, while the same machines work just fine after a "platform"
mode hibernation.  So at least for these machines it seems to matter.

Thanks,
Rafael
