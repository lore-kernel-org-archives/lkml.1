Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYIHBCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYIHBCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYIHBBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:01:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:57232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbYIHBBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:01:52 -0400
From: Thomas Renninger <trenn@suse.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Mon, 8 Sep 2008 03:01:24 +0200
User-Agent: KMail/1.9.9
Cc: toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809061108.34877.arvidjaar@mail.ru> <200809061120.00224.arvidjaar@mail.ru>
In-Reply-To: <200809061120.00224.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809080301.24907.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008 09:19:59 am Andrey Borzenkov wrote:
> On Saturday 06 September 2008, Andrey Borzenkov wrote:
> > I have now two different devices that refer to the same hardware:
> >
> > lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 ->
> > ../../devices/virtual/backlight/acpi_video0/ lrwxrwxrwx 1 root root 0
> > 2008-09-06 11:04 toshiba -> ../../devices/virtual/backlight/toshiba/
> >
> > Unfortunately, due to ACPI implementation the acpi_video0 one is much
> > inferior (as it provides only effectively two levels instead of 8);
> > and user level tools are apparently quite confused which one to select.
> >
> > Is there any mechanism that would allow tochiba_acpi to claim brightness
> > for internal LCD screen that video would not attempt to grab it too?
> >
> > Of course manually disabling brightness handling in video is always
> > possible,
>
> Actually it is not. brightness_switch_enabled only disables event handling;
> it still resets actual brightness on loading and creates sysfs files to
> confuse user space.
>
> > still is nice for this to be handled automatically.
It is in latest ACPI test branch queued for 2.6.28.
The problem in bug:
http://bugzilla.kernel.org/show_bug.cgi?id=9614
is another. But the patchset pointed to in comment #43 should fix several, 
also your problem.

If not, please tell me and open a new bug.

Thanks,

       Thomas
