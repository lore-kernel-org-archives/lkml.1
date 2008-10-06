Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYJGNGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYJGNGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYJGNGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:06:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56572 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753384AbYJGNGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:43 -0400
Date: Mon, 6 Oct 2008 17:11:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] PM: use pm_op methods for device types
Message-ID: <20081006151127.GC1380@ucw.cz>
References: <20080925220635.GA12175@kroah.com> <Pine.LNX.4.44L0.0809260948580.2395-100000@iolanthe.rowland.org> <20080926175922.GA767@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926175922.GA767@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Okay, I was confused too.  Looking more closely, it's apparent that 
> > mainline is okay and the problem was introduced by Hannes Reinecke's 
> > 
> > driver-core-remove-suspend-resume-callbacks-for-device-type.patch
> > 
> > which states that the suspend/resume callbacks in struct device_type
> > are unused.  It may be true that the legacy suspend/resume methods are
> > unused, but the new pm_ops methods definitely are used.
> > 
> > Therefore part or all of Hannes patch should be reverted.  And the 
> > mainline is okay as it stands.
> 
> Ah, ick.
> 
> Hannes, care to respin this patch based on this information?

I guess Hannes patch shoud simply be dropped....

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
