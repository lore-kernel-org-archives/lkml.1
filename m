Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYDBMMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYDBMMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYDBMLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:11:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4357 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753866AbYDBMLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:11:52 -0400
Date: Tue, 1 Apr 2008 21:37:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Didier Raboud <didier@raboud.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org
Subject: Re: 2.6.25-rc7
Message-ID: <20080401193753.GB4251@ucw.cz>
References: <200803311823.36693.didier@raboud.com> <200803312303.19623.didier@raboud.com> <200804010818.59269.didier@raboud.com> <200804010841.45623.didier@raboud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804010841.45623.didier@raboud.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> > > I do (Debian default option)... I will build a kernel without it and
> > > retry.
> >
> > I compiled the same kernel with CONFIG_USB_SUSPEND not set. After 6
> > hibernations, I haven't had a problem for now.
> >

> It hung after the 10th hibernation...
> 
> I wonder if the problem would not be of Debian's uswsusp binary, because tty1 
> tells me that the image is successfully loaded but I just can't act on my box 
> afterwards.
> 
> There is a bug open in the Debian BTS requesting a packaging of the new 
> upstream version (0.8) but the maintainer is told to be too busy to handle it 
> for now.
> 
> Don't know...

Just do echo disk > /sys/power/state to use swsusp and bypass uswsusp?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
