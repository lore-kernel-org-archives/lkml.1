Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZEGVnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZEGVnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZEGVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:43:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44326 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZEGVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:43:37 -0400
Date: Thu, 7 May 2009 23:42:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: U Kuehn <ukuehn@acm.org>
Cc: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090507214255.GA14611@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <4A03129A.90105@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03129A.90105@acm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> - Support for multiple swap devices
> >> - Support for non-swap (an ordinary file can be used)
> >> - Uses cryptoapi (LZO support, more than 2x speed of uncompressed data!)
> >> - Asynchronous I/O, readahead, multithreaded. Get the maximum throughput
> >>   possible with your hardware.
> >> - Userspace user interface that lets you abort hibernating and abort
> >>   resuming, get nice progress display etc.
> > 
> > All these are either done by uswsusp already, or could be done w/o
> > modifying kernel code.
> 
> Given that tuxonice DOES work reliably with dm-crypt encrypted swap
> partitions, does uswsusp offer this functionality? Looking into the docs
> on the sourceforge site does not give any information about this
> - point.

uswsusp does not care what kind of device it writes on, so yes,
dm-crypt works. IIRC seife was working on some YaST scripts so that
setting it up was easy for users.

> Further, being someone with a crypto background, the userland suspend
> helper does have some issues with the password/key handling:
> 1) no support for keys containing a 0 byte. (cryptsetup can handle
> this)

"passwords containing 0 byte" ? Is that a big deal? How would user
enter such password?

> 2) the rsa functionality seems to use the unsound practice to encrypt
> the symmetric key directly without any padding (aka encoding in libgcrypt).

If this is easy to fix, can you tell me what to do?

Otherwise, can you write a short note to bugtraq? Having bad crypto in
uswsusp would indeed be very very bad.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
