Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYGJFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYGJFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 01:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYGJFQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 01:16:19 -0400
Received: from eazy.amigager.de ([213.239.192.238]:33744 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYGJFQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 01:16:18 -0400
Date: Thu, 10 Jul 2008 07:16:14 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Theodore Tso <tytso@mit.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
Message-ID: <20080710051614.GA12477@dose.home.local>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	Felipe Balbi <felipebalbi@users.sourceforge.net>,
	Theodore Tso <tytso@mit.edu>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com> <20080705133601.GA20240@mit.edu> <31e679430807050700q765dc45ft198fcf1c0b91a9cc@mail.gmail.com> <20080709202920.GE11006@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709202920.GE11006@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 22:29:20 +0200, Pavel Machek wrote:

[...]

> > Anyways, it's bad that we have to manually unload several modules,
> > specially usb. I'm sure windows reaches 9 watts consumption without
> > breaking functionality. And that's the big thing. I think that's something
> > we should be aiming. Dontcha think?
> 
> Can you test Ted's suggestion to see if we have nailed the problem,
> first?
> 
> 9W vs. 15W does not explain 1h30 vs 3h30 difference, afaict.
> 
> (Of course, we are working on usb autosuspend. Try 2.6.26).

FWIW, with dimmed display, hard disk spun down, USB autosuspend enabled
for all devices (I have to enable it from userspace for the fingerprint
reader), and some other tricks [*], I get slightly below 9W on my X61s
with uhci_hcd and ehci_hcd loaded and active WLAN, using kernel
2.6.25.9.

I also tried 2.6.26-rc to see if PCIE ASPM can save some power, but I
didn't see a difference after I set it to "powersave". It looks like
the BIOS already set sane values.

Regards,
Tino

[*]: SATA link power management, HDA sound power saving, wireless LAN
power saving, Ethernet speed set to 100 MBit/s, some other modules like
yenta_socket unloaded
