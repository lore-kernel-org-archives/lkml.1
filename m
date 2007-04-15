Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXDOT6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXDOT6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXDOT6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:58:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3850 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753539AbXDOT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:57:43 -0400
Date: Sun, 15 Apr 2007 19:23:46 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 1/7] [RFC] External power framework
Message-ID: <20070415192346.GE10097@ucw.cz>
References: <20070411232446.GA20095@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411232446.GA20095@zarina>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> External power framework - power supplies and power supplicants.
> 
> Supplicants (batteries so far) may ask to notify they when power supply
> arrive/gone. This framework used by battery class (next patches).
> 
> It's permitted for supply to be bound to several supplicants (think main
> and backup batteries).
> 
> It's also permitted for supplicants to consume power from several
> external supplies (say AC and USB).
> 
> Here is how it look like from userspace:
> 
> 	# pwd
> 	/sys/class/power_supply
> 	# ls
> 	ac  usb
> 	# cat ac/online usb/online
> 	1
> 	0

Looks nice to me.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
