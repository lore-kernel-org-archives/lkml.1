Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbXDOJrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbXDOJrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXDOJrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:47:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:42025 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751701AbXDOJrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:47:10 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX1/UnE4aK6rUnDUOiKHrnRTMaelPBLoWcaJsfsxOqb
	LwBTSAKwmyuLRO
Date: Sun, 15 Apr 2007 11:47:05 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.21-rc6 USB Keyboard hangs (EHCI/UHCI/HID)
Message-ID: <20070415094705.GA9594@merlin.emma.line.org>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <20070414163319.GA17102@merlin.emma.line.org> <Pine.LNX.4.44L0.0704142203560.11828-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0704142203560.11828-100000@netrider.rowland.org>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007, Alan Stern wrote:

> On Sat, 14 Apr 2007, Matthias Andree wrote:
> 
> > I arrived at the computer today, to find khubd in D state again, but
> > unfortunately, it does not show up in Alt-SysRq-T output. Do kernel
> > threads show up there at all? 2.6.18.8-0.1 with SUSE patches on openSUSE
> > 10.2.
> 
> As far as I know, all tasks including kernel threads should show up.  They 
> certainly do on my machine.  However you're the second person to report 
> that khubd doesn't appear after getting stuck in a D state.
> 
> Clearly something strange is going on.  I wish I knew what it was...

Me too. Thanks for your patience. We'll track this down. A german
proverb is "Mühsam ernährt sich das Eichhörnchen" which means we're
collecting our pieces (literally food), but very slowly and hard.

> > I had stopped usbmon before however, so I don't know what the events
> > have been leading to this lockup. Sorry. I'll leave usbmon running now.
> 
> Something else you can do is turn on CONFIG_USB_DEBUG and then check the
> dmesg log for anything significant.

That would require recompiling a production kernel, but I've now
backgrounded usbmon spamming my disk, with just the keyboard attached to
the external USB2.0 hub (the other device would have been my Eizo
FlexScan L768 19" TFT) in the hope that it will come up with something,
should khubd hang again before Friday...

Best regards,

-- 
Matthias Andree
