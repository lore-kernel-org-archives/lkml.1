Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbYBVMXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbYBVMXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbYBVMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:22:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4940 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755215AbYBVMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:22:43 -0500
Date: Mon, 18 Feb 2008 06:31:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org, Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Message-ID: <20080218063146.GB3940@ucw.cz>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org> <b6a2187b0802200954p1cccb01aqbc48c865797f0af1@mail.gmail.com> <alpine.LFD.1.00.0802201007300.7833@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802201007300.7833@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It's "snapshot-and-restore", and my opinion is that:
> 
>  - it should *never* call "suspend()"/"resume()" at all (that should be
>    reserved purely for suspend-to-RAM and has real power management 
>    issues!)

Hmm, entering S4 seems like good place to call suspend() for... unless
you want separate freeze()/unfreeze(), suspend()/resume(),
suspend_s4() and halt() callbacks.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
