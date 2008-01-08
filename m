Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbYAHQHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbYAHQHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYAHQHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:07:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4264 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751039AbYAHQHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:07:00 -0500
Date: Tue, 8 Jan 2008 16:06:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Andi Kleen <andi@firstfloor.org>,
       Bernd Schubert <bernd-schubert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: sleep before boot panic
Message-ID: <20080108160645.GA4574@ucw.cz>
References: <200801061908.43010.bernd-schubert@gmx.de> <p731w8ts70k.fsf@bingen.suse.de> <200801080717.03467.ioe-lkml@rameria.de> <47831D97.7040908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47831D97.7040908@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>I just switched to libata (pata) on my laptop and the 
> >>>immediate panic made it impossible to figure out why 
> >>>my boot partition wasn't available.
> >>>After applying this little patch I could check boot 
> >>>printk output and then saw everything was properly 
> >>>recognized and only scsi-disk support was missing.
> >>The correct fix would be to make scroll back (and 
> >>sysrq) still work
> >>after panic.  It's a little more complicated, but 
> >>possible (essentially
> >>it needs a polled keyboard handler)
> >
> >Customer: "This system could not find the root fs."
> >Support: "Oh, yeah, just connect a (USB-) keyboard and 
> >scroll back."
> >
> >Hmm, device detection works after panic?
> >
> >I really like the "soft" panic better, where you still 
> >can operate the kernel debugging features, but just 
> >have no user space supporting it.

ACK. 'scheduling in interrupt' is very different from 'cant mount
root'.

> Of course, if we'd been using kinit, "soft panic" would 
> have been done exclusively in userspace...

What's the status of kinit, btw?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
