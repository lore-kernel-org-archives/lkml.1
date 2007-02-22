Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbXBVJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbXBVJcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXBVJcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:32:19 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:44835 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbXBVJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:32:18 -0500
Date: Thu, 22 Feb 2007 10:32:38 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Paul Sokolovsky <pmiscml@gmail.com>
Message-ID: <20070222093238.GF13924@enneenne.com>
References: <20070221145353.GA23916@enneenne.com> <1172105946.5790.78.camel@localhost.localdomain> <20070222082848.GM4641@enneenne.com> <1172136430.5837.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172136430.5837.9.camel@localhost.localdomain>
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

On Thu, Feb 22, 2007 at 09:27:09AM +0000, Richard Purdie wrote:
> 
> Yes, my point is that you shouldn't need to touch pxafb if you use the
> backlight class. I know pxafb has backlight hooks but they are probably
> going to get removed at some point as they should no longer be needed.

I see.

> What changes do you need to it to be able to use it as a generic driver?
> 
> The main issue is that the structure definition is in one of the
> sharpsl.h files at the moment so most drivers can't get to it. Fix that
> and it should make a good generic driver.

I'll do as you suggest!

> Ideally I'd prefer to leave the name alone since there is broken
> userspace on the Zaurus that uses that name but I can see why people
> want it renamed if its to be used as a generic driver...

Yes. :)

I'll wait for the 2.6.21 to see what to do... thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
