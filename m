Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbYEXVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbYEXVBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761621AbYEXVBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:01:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759710AbYEXVBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:01:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Suspend to memory is freezing my machine
Date: Sat, 24 May 2008 23:01:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com> <200805041240.52988.rjw@sisk.pl> <c4e36d110805220240n2f11d6cbnefc9893ab0330211@mail.gmail.com>
In-Reply-To: <c4e36d110805220240n2f11d6cbnefc9893ab0330211@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805242301.25695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of May 2008, Zdenek Kabelac wrote:
> Hello Rafael
> 
> 2008/5/4 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
> >> Hello
> >
> > Hi,
> >
> >> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
> >> complete freeze of my T61 during suspend. (dual core, 2GB).
> >
> > How reproducible is this?
> >
> 
> The problem happens still even with -rc3. Now I've an update:
> 
> Usually I've to run the machine for couple hours to actually be able
> to hit this lock.
> (Usually after a day work when I want to leave)
> 
> I've also noticed that when I run the suspend after the reboot I
> usually cannot see the suspend freeze - mostly because either the
> mashine crashes from other ooops or I do another reboot.
> 
> 
> >> I'm running kernel with no_console_suspend - but all I can see is
> >> blinking cursor on an empty screen - thus even when I run kernel with
> >> most debug options turned on, I can't pass more details so far.  I run
> 
> I've figured out, it was caused by some weird Fedora setting, so
> adding  kernel.printk = 8  to sysctl.conf  fixed the issue for me.
> 
> >> suspend with with SD card in - so maybe some update in the MMC driver
> >> might be responsible for this ?
> > (1) The problem occurs without no_console_suspend.
> > (2) The problem occurs without the SD card.
> 
> SD card or no_console_suspend option doesn't matter
> 
> This is what I've seen as the last thing on the screen when deadlock
> appeared this time:
> (no SD card inserted)
> 
> ====
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> PM: Entering mem sleep
> drm card0: class suspend
> drm_sysfs_suspend

Hm, what kind of graphics adapter is there in your box?

Rafael
