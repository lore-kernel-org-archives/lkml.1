Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZKRRWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZKRRWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbZKRRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:22:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59645 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbZKRRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:22:41 -0500
Date: Wed, 18 Nov 2009 18:22:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: -rc6: something (probably active usb bluetooth) blocks suspend
Message-ID: <20091118172211.GC25150@elf.ucw.cz>
References: <20091116112254.GB12315@elf.ucw.cz>
 <200911161248.29924.oliver@neukum.org>
 <20091114111021.GA1378@ucw.cz>
 <200911161447.51651.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911161447.51651.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Why is the device autoresumed here? Are you using autosuspend?
> > > This is odd, as the freezer should block the send path and remote
> > > wakeups should be deferred.
> > 
> > I believe I have it enabled in kconfig but not during runtime.
> 
> Please check.

CONFIG_USB_SUSPEND=y

I'm not aware of  boot scripts enabling anything.

> > (Another problem is that I need to turn the kill switch on/off to get
> > my bt usb after resume. That used not be the case long time ago.)
> 
> That is possibly another problem.

Yes, I guess so. With those many USB experts around, I thought I'd
mention it :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
