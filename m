Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZLULUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZLULUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZLULU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:20:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbZLULU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:20:26 -0500
Date: Mon, 21 Dec 2009 12:20:42 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [linux-pm] Async suspend-resume patch w/ completions (was: Re:
	Async?suspend-resume patch w/ rwsems)
Message-ID: <20091221112042.GA12133@suse.cz>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain> <20091220024142.GC4073@core.coreip.homeip.net> <200912202025.25618.rjw@sisk.pl> <20091221073915.GC3234@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221073915.GC3234@core.coreip.homeip.net>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 11:39:15PM -0800, Dmitry Torokhov wrote:

> > On the nx6325 that appears to reduce the suspend time as much so the effect
> > of async is not visible any more.  On the Wind it decreases the total suspend
> > time almost by half!
> > 
> > Please push this patch to Linus. :-)
> > 
> 
> Let's see if I manage to solicit some testers first. FWIW it seems to be
> working on my boxes.
> 
> But if this works then I am not sure we even want to bother with async
> suspend of i8042 and serios. And serio already does resume
> asynchronously through kseriod.

I'm kind of wondering where this will break, but I don't remember why
the RESET_BAT was put in exactly - the point of making sure the BIOS
doesn't get confused by the advanced modes is correct, and is required
at least when a keyboard is set to "Set 3", but RESET_BAT is a too heavy
hammer anyway - we could just make sure to switch the kbd/mouse to
'default' modes instead of doing a full reset.

-- 
Vojtech Pavlik
Director SuSE Labs
