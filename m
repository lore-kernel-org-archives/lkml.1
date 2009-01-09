Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZAIKQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZAIKQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZAIKQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:16:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40239 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZAIKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:16:34 -0500
Date: Fri, 9 Jan 2009 11:18:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Message-ID: <20090109101840.GD3396@elf.ucw.cz>
References: <200901080835.39639.rjw@sisk.pl> <200901080949.34339.oliver@neukum.org> <200901081736.12926.rjw@sisk.pl> <200901081748.58962.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901081748.58962.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-08 17:48:57, Oliver Neukum wrote:
> Am Thursday 08 January 2009 17:36:12 schrieb Rafael J. Wysocki:
> > > We do support remote wakeup from PS2 keyboards. So you might argue we
> > > should do the same for USB HID devices.
> > 
> > Well, _I_ can live with a few 'echo disabled > /sys/devices/.../power/wakeup'
> > lines in my init scripts, but I'm afraid we're going to get many problem
> > reports related to this.  This means people will likely lose time on trying to
> > debug this problem and someone will have to handle the reports.  Are you
> > volunteering to do that?
> 
> You are making a very persuasive argument for reverting it.
> But what about laptops that only have a USB keyboard?

laptops normally wake up lid open... (and you still have a
powerbutton; plus I'm not aware of any laptops with usb keyboard --
are apples crazy enough to do that?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
