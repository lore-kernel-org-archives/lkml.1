Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbXB0V64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbXB0V64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXB0V64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:58:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43351 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751834AbXB0V6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:58:55 -0500
Date: Tue, 27 Feb 2007 22:58:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org
Subject: Re: 2.6.20-almost-rc1: usb oops during resume
Message-ID: <20070227215846.GD4519@elf.ucw.cz>
References: <20070224115137.GA8658@elf.ucw.cz> <20070225053746.GA25058@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225053746.GA25058@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...is it "use after free"?
> > 
> > Greg, could we reduce verbosity of driver model? "PM: Adding info for
> > No Bus:vcs*" is not very useful.
> 
> Maybe for you it isn't, but then again, you did enable
> CONFIG_DEBUG_DRIVER to see that, so you will get a lot of stuff in your
> logs :)

I went on to disable that config option, but...

CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

...it was disabled.

Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17_ep01
Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17_ep82
Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17_ep83
Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17

What is going on?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
