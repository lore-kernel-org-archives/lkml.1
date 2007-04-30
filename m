Return-Path: <linux-kernel-owner+w=401wt.eu-S1946833AbXD3V1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946833AbXD3V1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946832AbXD3V1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:27:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946586AbXD3V1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:27:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22
Date: Mon, 30 Apr 2007 23:31:42 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miles Lane <miles.lane@gmail.com>, lollul@wp.pl,
       Helge Hafting <helgehaf@aitel.hist.no>
References: <200704290102.33533.lenb@kernel.org> <200704302203.31757.rjw@sisk.pl> <20070430200524.GA11115@waste.org>
In-Reply-To: <20070430200524.GA11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704302331.43934.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 April 2007 22:05, Matt Mackall wrote:
> On Mon, Apr 30, 2007 at 10:03:30PM +0200, Rafael J. Wysocki wrote:
> > > > > > These are older and might have been fixed:
> > > > > > 
> > > > > > - Mat Mackall's "Thinkpads not waking up on lid open with -rc6-mm1"
> > > > > 
> > > > > This seems to be related to suspend to disk. After the first suspend
> > > > > to disk/resume, suspend to ram stops resuming from lid open and needs
> > > > > me to hit the power button. As I just started using suspend to disk in
> > > > > the past couple weeks, this may be a long-standing bug.
> > > > > 
> > > > > I think it's still present in -rc7-mm1 but I don't have my laptop
> > > > > handy to double-check.
> > > > 
> > > > Can you please check if the appended debug patch helps?
> > > 
> > > Nope.
> > > 
> > > boot into new kernel
> > > lid switch -> suspend
> > > lid switch -> resume
> > > power button -> hibernate
> > > power button -> resume
> > > lid switch -> suspend
> > > lid switch -> nothing
> > > power button -> resume
> > > echo LID > /proc/acpi/wakeup -> "*disabled"
> > > echo LID > /proc/acpi/wakeup -> "*enabled"
> > > lid switch -> suspend
> > > lid switch -> nothing
> > 
> > Then this is unrelated.
> > 
> > What does 'cat /sys/power/disk' show?
> 
> $ cat /sys/power/disk
> [platform] shutdown reboot test testproc

Can you please do 'echo shutdown > /sys/power/disk' before the hibernation
and see what happens?

Rafael
