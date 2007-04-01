Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXDAS35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXDAS35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933816AbXDAS35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:29:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58327 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933814AbXDAS34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:29:56 -0400
Date: Sun, 1 Apr 2007 20:29:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Zeuthen <davidz@redhat.com>
Cc: Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-ID: <20070401182945.GA11239@elf.ucw.cz>
References: <200703271824.46804.maximlevitsky@gmail.com> <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org> <20070327110524.975e7113.zaitcev@redhat.com> <200703280129.10197.maximlevitsky@gmail.com> <20070401152957.GA5068@ucw.cz> <1175449366.3008.120.camel@zelda.fubar.dk> <20070401175020.GE11146@elf.ucw.cz> <1175450490.3008.128.camel@zelda.fubar.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175450490.3008.128.camel@zelda.fubar.dk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Problem is that suspending _with_ removable mass storage devices
> > attached just will not work. User will unplug them, then complain
> > about corruption. Advanced user will unplug them, work with them
> > somewhere else, replug them, then loose filesystem.
> > 
> > Feel free to send patch to teach filesystems to handle this.
> 
> I was suggesting in the Bugzilla that the file system should actually do
> this. I don't have a patch for this, sorry. 

Unfortunately it is a _lot_ of work, so noone has time for that :-(.

> > Check your facts. Laptops do not melt. I know, I put them into my bed,
> > covered with pillow, and let them complain (evo 560c). ACPI thermals
> > can handle that.
> 
> Some laptops may severely overheat especially if the backlight is not
> turned off (See: Apple hardware). Pretending that all hardware "just
> works" or that all drivers "just work" is nice but not really useful in
> the real life especially when we're talking about damaging hardware.

Apple should fix their hardware, then. And you should not run Linux
there, because their hardware is broken; they assume OS X.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
