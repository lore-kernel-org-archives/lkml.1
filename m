Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYDAL7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYDAL7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbYDAL7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:59:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48046 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYDAL67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:58:59 -0400
Date: Tue, 1 Apr 2008 11:59:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
Message-ID: <20080401095924.GC8247@elf.ucw.cz>
References: <47EBBD57.30902@rtr.ca> <47F11D8F.4020209@rtr.ca> <47F11FC6.8010701@rtr.ca> <200803312005.37804.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803312005.37804.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > But suspend *with* any USB device plugged-in, and it *always* fails resume,
> > even when the USB device is unplugged before hitting the resume button.
> > 
> > Conclusion:   the bug is in the usb SUSPEND code, not the RESUME code.
> 
> I would arrive at the opposite conclusion. Independent from that, loss of
> power is not really supported by USB during STR. Obviously it should not
> hang, but all devices will be disconnected and reconnected.

All devices disconnected / reconnected is expected, but it has to
work. Machines like thinkpad x60 kill USB power during s2ram.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
