Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXBVI2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXBVI2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXBVI2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:28:33 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:43849 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXBVI2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:28:32 -0500
Date: Thu, 22 Feb 2007 09:28:49 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Paul Sokolovsky <pmiscml@gmail.com>
Message-ID: <20070222082848.GM4641@enneenne.com>
References: <20070221145353.GA23916@enneenne.com> <1172105946.5790.78.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172105946.5790.78.camel@localhost.localdomain>
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

On Thu, Feb 22, 2007 at 12:59:06AM +0000, Richard Purdie wrote:
> 
> Reading through the patch its:
> 
> 1) Not against any mainline kernel
> 2) Not against a recent kernel

I'm sorry, but the patch applay against the latest kernel. Please, try
it.

> There were a number of backlight class changes just merged into mainline
> and you need to sync up any patch against them.

My patch uses current backlight class support in the kernel.

> As mentioned by others, there is no need to tie the backlight driver
> into the framebuffer any more. Have a look at
> drivers/video/backlight/corgi_bl.c for an example (its used by PXA
> devices).

That driver uses the backlight class support as my patch does into
pxafb.

> I have said elsewhere I will take patches to make corgi_bl a more
> generic driver (or maybe create a simple generic backlight driver) along
> the lines of what Paul mentioned.

I see.

I suppose you are the backlight support mantainer, so what do you
suggest to do to "make corgi_bl a more generic driver"?

I have to rename and modify it? Or just copy it to have backward
compatibility and the modify the new file?

I should mv backlight directory from the video one?

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
