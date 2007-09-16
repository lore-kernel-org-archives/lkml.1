Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbXIPUyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbXIPUyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXIPUyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:54:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXIPUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:54:04 -0400
Message-ID: <46ED97D0.1090608@zytor.com>
Date: Sun, 16 Sep 2007 13:53:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ACPI video mode patch review
References: <46E9AD88.7070400@zytor.com> <200709162208.03768.rjw@sisk.pl>
In-Reply-To: <200709162208.03768.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 13 September 2007 23:37, H. Peter Anvin wrote:
>> Pavel, want to look at the patch before sending it to Linus?
> 
> Many thanks for taking care of this!
> 
> We already have a patch in -mm, s2ram-kill-old-debugging-junk.patch from Pavel
> (http://marc.info/?l=linux-mm-commits&m=118737955611331&w=1), that removes the
> #ifdefed blocks and it clashes with your first patch a bit.
> 
> FYI, I have rebased your first patch on top of the Pavel's patch:
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc6/patches/39-acpi-video-mode-fix.patch
> 

Thanks Rafael,

However, I need to send something upstream to Linus for this kernel
cycle, so I don't want to base it on an -mm patch.  There are two
alternatives, obviously: 1. send my patch in now based on the "change as
little as necessary to fix the immediate problem" and then rebase
Pavel's patch on top of mine, or 2. for me to send both Pavel's patch
and the rebased patch upstream.

Personally, I would prefer to avoid strategy 2 at this late stage in the
2.6.23-rc series.

Please let me know what you think.

	-hpa
