Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXDAPaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXDAPaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbXDAPaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:30:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4651 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933389AbXDAPaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:30:08 -0400
Date: Sun, 1 Apr 2007 15:29:57 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Maxim <maximlevitsky@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       gregkh@suse.de, Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       davidz@redhat.com
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-ID: <20070401152957.GA5068@ucw.cz>
References: <200703271824.46804.maximlevitsky@gmail.com> <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org> <20070327110524.975e7113.zaitcev@redhat.com> <200703280129.10197.maximlevitsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703280129.10197.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > In that case the user would see data corruption - just as if he mounts a piece
> > > of removable media in a USB card reader; yanks out the card and modifies it
> > > elsewhere, and then puts it back in.
> > 
> > > I my opinion we can't really defend ourselves against such users... We can of
> > > course add checks in the file system drivers in the resume hooks to validate the
> > > super block and mount read-only if something change. 
> > 
> > The GNOME hath spoken?

> 	I also thought about that,
> 	
> 	I think that the best solution is still to hide connect/disconnect of usb devices from userspace (now it also causes corruption)
> 	But to refuse suspend with any usb mass storage device connected with mounted systems (and add a module param override
> 	 for users who know what they are doing)
> 
> 	What do you think ?

Agreed... and notice how easy is to do that in userspace :-))).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
