Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYFIPkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYFIPkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYFIPkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:40:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYFIPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:40:42 -0400
Date: Mon, 9 Jun 2008 08:35:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <20080609080052.GA27899@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0806090831550.3473@woody.linux-foundation.org>
References: <20080606092546.GA2596@elf.ucw.cz> <Pine.LNX.4.44L0.0806061030210.2354-100000@iolanthe.rowland.org> <20080607195221.GB11109@ucw.cz> <alpine.LFD.1.10.0806071525030.3473@woody.linux-foundation.org> <20080609080052.GA27899@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jun 2008, Pavel Machek wrote:
> 
> If your device did not loose power during s2ram, it should just work.

Tough. And if pigs had wings, they could fly. What's your point?

> There's a tweak you can set in /sys you can set if your device is not
> removable, you can set it for non-removable devices that _do_ loose
> power.

Yes, and it's totally pointless. I had this whole discussion already. 
That flag is too hard to find for any normal person to be useful, and the 
fact is, if you hold the device mounted over a suspend, it should be set 
by default anyway.

> Besides, it seems to break suspend/resume of printers, and probably
> all the drivers that do not have reset_resume() method. That's
> actually a regression.
> 
> https://bugzilla.novell.com/show_bug.cgi?id=394820

So printers shouldn't do it, since they aren't mounted. Neither should 
mice etc things. What does that have to do with block devices?

		Linus
