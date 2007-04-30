Return-Path: <linux-kernel-owner+w=401wt.eu-S1946742AbXD3UHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946742AbXD3UHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423662AbXD3UHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:07:41 -0400
Received: from waste.org ([66.93.16.53]:36849 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423657AbXD3UHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:07:39 -0400
Date: Mon, 30 Apr 2007 15:05:24 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miles Lane <miles.lane@gmail.com>, lollul@wp.pl,
       Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22
Message-ID: <20070430200524.GA11115@waste.org>
References: <200704290102.33533.lenb@kernel.org> <200704291417.02362.rjw@sisk.pl> <20070430153304.GT11115@waste.org> <200704302203.31757.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704302203.31757.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:03:30PM +0200, Rafael J. Wysocki wrote:
> > > > > These are older and might have been fixed:
> > > > > 
> > > > > - Mat Mackall's "Thinkpads not waking up on lid open with -rc6-mm1"
> > > > 
> > > > This seems to be related to suspend to disk. After the first suspend
> > > > to disk/resume, suspend to ram stops resuming from lid open and needs
> > > > me to hit the power button. As I just started using suspend to disk in
> > > > the past couple weeks, this may be a long-standing bug.
> > > > 
> > > > I think it's still present in -rc7-mm1 but I don't have my laptop
> > > > handy to double-check.
> > > 
> > > Can you please check if the appended debug patch helps?
> > 
> > Nope.
> > 
> > boot into new kernel
> > lid switch -> suspend
> > lid switch -> resume
> > power button -> hibernate
> > power button -> resume
> > lid switch -> suspend
> > lid switch -> nothing
> > power button -> resume
> > echo LID > /proc/acpi/wakeup -> "*disabled"
> > echo LID > /proc/acpi/wakeup -> "*enabled"
> > lid switch -> suspend
> > lid switch -> nothing
> 
> Then this is unrelated.
> 
> What does 'cat /sys/power/disk' show?

$ cat /sys/power/disk
[platform] shutdown reboot test testproc

-- 
Mathematics is the supreme nostalgia of our time.
