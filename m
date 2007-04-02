Return-Path: <linux-kernel-owner+w=401wt.eu-S1767659AbXDFOUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767659AbXDFOUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 10:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767660AbXDFOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 10:20:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48065 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767659AbXDFOUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 10:20:32 -0400
Date: Mon, 2 Apr 2007 21:36:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, David Zeuthen <davidz@redhat.com>,
       Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       gregkh@suse.de, Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-ID: <20070402193606.GA3576@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org> <46114DAD.3060100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46114DAD.3060100@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > But you're still likely to run into trouble if you unplug a storage
> > device, move it to another system and write on it, then plug it back into
> > the original system.  The PLVM would somehow have to recognize that the
> > data had been changed.  I don't know a foolproof way of doing that.
> > 
> 
> Mark the filesystem as in-use with a one-time UUID in the superblock at
> mount time. If one moved the drive to another system it would require
> an fsck to clear the UUID before the other system could use it; then
> the original machine would refuse to use the drive when the UUID didn't
> match on resume.

You still need fs-specific code, I'm afraid... plus userland tool
to reset signatures back.

Patches welcome. 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
