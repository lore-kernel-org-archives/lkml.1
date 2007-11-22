Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXKVQZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXKVQZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXKVQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:25:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXKVQZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:25:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tomas Carnecky <tom@dbservice.com>
Subject: Re: laptop reboots right after hibernation
Date: Thu, 22 Nov 2007 17:43:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>
References: <473730F6.2010900@dbservice.com> <200711182333.52669.rjw@sisk.pl> <47456F28.3070307@dbservice.com>
In-Reply-To: <47456F28.3070307@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221743.24286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of November 2007, Tomas Carnecky wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 18 of November 2007, Tomas Carnecky wrote:
> >> Pavel Machek wrote:
> >>> Hi!
> >>>
> >>>> echo disk > /sys/power/state
> >>>>
> >>>> successfully saves that state to the disk, but just as the laptop is
> >>>> about to turn itself off, it reboots (successfully, so the
> >>>> hibernation/resume process works well, even with X running! which is
> >>>> awesome :) ). But I'd rather like the computer turned off after I
> >>>> hibernate it. Where could the problem be?
> >>>>
> >>>> It's a new laptop, TP X61 tablet, I tried ubuntu (7.10, gutsy) for a few
> >>>> days, both suspend and hibernate worked there (with one or two crashes,
> >>>> probably due to X, I've read that the intel driver got some
> >>>> suspend/resume improvements recently). Now I'm running gentoo, kernel
> >>>> 2.6.24-rc2. I'm using newer versions of almost all software now compared
> >>>> to the ubuntu system.
> >>> If it works in older ubuntu, you can probably do bisect. Does normal
> >>> shutdown work? You can try platform vs. shutdown mode...
> >> I forgot, normal shutdown (init 0) works, the 'shutdown' command fails
> >> somewhere in the gentoo init scripts, but that has nothing to do with
> >> the kernel. 'init 6' also works. Both regardless of where the notebook
> >> is (dock or outside).
> > 
> > Please verify if you have the ehci_hcd driver loaded when the box is in the
> > dock.  If so, please try to unload it before hibernation and see if the box
> > will reboot.
> 
> I had to recompile the kernel because I have a monolithic kernel with as
> many components as possible compiled in. But after I disabled the whole
> USB subsystem, the laptop doesn't reboot anymore after hibernation. Is
> that a bug in the usb driver

Well, I suspect so.  We've already had a similar report and there are some
problems that seem to be related to it with some boxes.  Still, nobody knows
what the problem really is so far.

> or are users supposed to unload ehci_hcd each time before hibernation?

As a (hopefully temporary) workaround.

> In the former case, I'd be willing to help debug.

We have yet to figure out how to do that. :-)

Greetings,
Rafael
