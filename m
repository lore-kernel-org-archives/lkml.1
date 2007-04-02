Return-Path: <linux-kernel-owner+w=401wt.eu-S965685AbXDBS2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965685AbXDBS2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965672AbXDBS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:28:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3339 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965668AbXDBS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:28:36 -0400
Date: Mon, 2 Apr 2007 18:28:24 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: David Zeuthen <davidz@redhat.com>, Maxim <maximlevitsky@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-ID: <20070402182824.GA4345@ucw.cz>
References: <200703271824.46804.maximlevitsky@gmail.com> <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org> <20070327110524.975e7113.zaitcev@redhat.com> <200703280129.10197.maximlevitsky@gmail.com> <20070401152957.GA5068@ucw.cz> <1175449366.3008.120.camel@zelda.fubar.dk> <20070401175020.GE11146@elf.ucw.cz> <461117E4.3060504@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461117E4.3060504@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Problem is that suspending _with_ removable mass 
> >storage devices
> >attached just will not work. User will unplug them, 
> >then complain
> >about corruption. Advanced user will unplug them, work 
> >with them
> >somewhere else, replug them, then loose filesystem.
> >
> >Feel free to send patch to teach filesystems to handle 
> >this.
> 
> People have already fixed this:  sync() before suspend,
> and use a journalling filesystem.  Problem solved.

Does not solve the 'user removed it and mounted it somewhere else in
the meantime' problem.

Alan proposed one possible solution....
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
