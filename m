Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbXD2MGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbXD2MGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbXD2MGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:06:34 -0400
Received: from waste.org ([66.93.16.53]:42660 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394AbXD2MGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:06:33 -0400
Date: Sun, 29 Apr 2007 06:52:44 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miles Lane <miles.lane@gmail.com>, lollul@wp.pl,
       Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22
Message-ID: <20070429115244.GE11115@waste.org>
References: <200704290102.33533.lenb@kernel.org> <20070429010104.68c51d1a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429010104.68c51d1a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 01:01:04AM -0700, Andrew Morton wrote:
> On Sun, 29 Apr 2007 01:02:33 -0400 Len Brown <lenb@kernel.org> wrote:
> 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> > 
> > This batch mostly updates the platform-specific drivers that use ACPI.
> > The EC and sbs changes are primarily cleanups.
> > There are no changes to the ACPICA core, except a single bugfix
> > that was related to a 2.6.21 boot regression on some older machines.
> > And then the usual mix of random tweaks.
> 
> There might still be a few regressions in this lot:
> 
> - Miles Lane's "2.6.21-rc7-mm2 -- gnome-power-manager always shows the
>   power as coming from AC"
> 
> - "battery caching introduces a lock up"
>   http://bugzilla.kernel.org/show_bug.cgi?id=8351
> 
> These are older and might have been fixed:
> 
> - Mat Mackall's "Thinkpads not waking up on lid open with -rc6-mm1"

This seems to be related to suspend to disk. After the first suspend
to disk/resume, suspend to ram stops resuming from lid open and needs
me to hit the power button. As I just started using suspend to disk in
the past couple weeks, this may be a long-standing bug.

I think it's still present in -rc7-mm1 but I don't have my laptop
handy to double-check.

-- 
Mathematics is the supreme nostalgia of our time.
