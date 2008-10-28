Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYJ1PLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYJ1PLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYJ1PKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:10:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYJ1PKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:10:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Tue, 28 Oct 2008 16:15:19 +0100
User-Agent: KMail/1.9.9
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Len Brown <len.brown@intel.com>,
       toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809061108.34877.arvidjaar@mail.ru> <200810271953.04764.arvidjaar@mail.ru> <200810281426.53499.trenn@suse.de>
In-Reply-To: <200810281426.53499.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281615.19894.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 of October 2008, Thomas Renninger wrote:
> On Monday 27 October 2008 17:52:55 Andrey Borzenkov wrote:
> > On Monday 08 September 2008, Thomas Renninger wrote:
> > > On Saturday 06 September 2008 09:19:59 am Andrey Borzenkov wrote:
> > > > On Saturday 06 September 2008, Andrey Borzenkov wrote:
> > > > > I have now two different devices that refer to the same hardware:
> > > > >
> > > > > lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 ->
> > > > > ../../devices/virtual/backlight/acpi_video0/ lrwxrwxrwx 1 root root 0
> > > > > 2008-09-06 11:04 toshiba -> ../../devices/virtual/backlight/toshiba/
> > > > >
> > > > > Unfortunately, due to ACPI implementation the acpi_video0 one is much
> > > > > inferior (as it provides only effectively two levels instead of 8);
> > > > > and user level tools are apparently quite confused which one to
> > > > > select.
> > > > >
> > > > > Is there any mechanism that would allow tochiba_acpi to claim
> > > > > brightness for internal LCD screen that video would not attempt to
> > > > > grab it too?
> > > > >
> > > > > Of course manually disabling brightness handling in video is always
> > > > > possible,
> > > >
> > > > Actually it is not. brightness_switch_enabled only disables event
> > > > handling; it still resets actual brightness on loading and creates
> > > > sysfs files to confuse user space.
> > > >
> > > > > still is nice for this to be handled automatically.
> > >
> > > It is in latest ACPI test branch queued for 2.6.28.
> >
> > It is still not in rc2; is it scheduled for 2.6.28 or delayed further?
> 
> Right, it's not there.
> Len, what happened with the:
> "Check for ACPI backlight support otherwise use vendor ACPIdrivers - version 4"
> patches?
> 
> They are pretty essential for video.ko.
> Otherwise graphics devices may get double poked (through vendor_acpi.ko drivers)
> or may register for graphics cards which are not there.

Do you have a pointer to those patches?

Thanks,
Rafael
