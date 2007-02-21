Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXBUQLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXBUQLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422647AbXBUQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:11:55 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:60989 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422646AbXBUQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:11:54 -0500
Date: Wed, 21 Feb 2007 17:12:10 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Message-ID: <20070221161210.GL4641@enneenne.com>
References: <20070221145353.GA23916@enneenne.com> <1056908425.20070221180037@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1056908425.20070221180037@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 06:00:37PM +0200, Paul Sokolovsky wrote:
> 
>   On the other hand, there's already
> drivers/video/backlight/backlight.c which provides generic BL support,
> implemented using notifier callback for FB core. Moreover, there's

My patch _uses_ that support.

> corgi_bl.c driver which, contrary to its name is a generic driver for
> embedded/PDA device backlight. It essentially subclassses pretty
> abstract backlight.c, and provides good implementation for most BL
> implementation. What you really need to do to use it, is to supply
> single machine-dependent method, set_bl_intensity(). That method is
> usually <10 lines.

I see, but in this manner you need to make a complete file for each
board, while with my patch you can just put few lines into machine's
definition file (a struct and 2 functions).

>   With this in mind, adhoc backlight handlers in pxafb and few other
> drivers are artifacts of older times. And it's sad they are tried to
> be resurrected instead of being removed.

IMHO, the actual backlight support is not so much, infact I'd like to
generalize it to support also backlighted keyboards (or input
devices). :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
