Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZENJRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZENJRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZENJRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:17:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44466 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZENJQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:16:59 -0400
Date: Thu, 14 May 2009 11:16:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090514091616.GB6417@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905090046.21282.rjw@sisk.pl> <20090509132711.GD10859@elf.ucw.cz> <200905092132.11138.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905092132.11138.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > And we have different ideas about how things should be done. Userspace
> > > > vs kernel space. Providing tuning knobs vs not. And so on.
> > > 
> > > This isn't _that_ important.  Actually, I'm not against an entirely in-kernel
> > > solution, as there are some clear benefits of doing it this way.  We only
> > > need to be careful enough not to break the existing setups.
> > 
> > Would you elaborate?
> 
> One benefit is that we need not anything in the initrd for hibernation to work.
> Another one is that we can get superior performance, for obvious reasons
> (less copying of data, faster I/O).   Yet another is simpler configuration and
> no need to maintain a separate set of user space tools.  I probably could
> find more.
>  
> > I would really hate to put progressbar painting into kernel; and if
> > that's in userspace, we can do compression/encryption there too as
> > well....
> 
> That's correct, we can.  But since we have LZO in the kernel now, we can use
> it for compression just as well, can't we?

Yes, but we do not have progressbar painting in the kernel -- yet --
so users will still need initrd etc.

Yes, we can move LZO into kernel pretty cheaply, and it will have
minor benefit of slightly faster reguler swsusp, but...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
