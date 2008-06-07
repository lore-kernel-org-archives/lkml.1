Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbYFGW05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbYFGW05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYFGW0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:26:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbYFGW0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:26:49 -0400
Date: Sat, 7 Jun 2008 15:26:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linuxfoundation.org>, gregkh@suse.de,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <20080607195221.GB11109@ucw.cz>
Message-ID: <alpine.LFD.1.10.0806071525030.3473@woody.linux-foundation.org>
References: <20080606092546.GA2596@elf.ucw.cz> <Pine.LNX.4.44L0.0806061030210.2354-100000@iolanthe.rowland.org> <20080607195221.GB11109@ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Jun 2008, Pavel Machek wrote:
> 
> Well, not-usb-persists means we force-unplug disks during suspend,
> after syncing them. Not _too_ bad.
> 
> If you unplug disk while hibernated, modify it, and plug it back,
> youget _silent_ filesystem corruption. I call that bad.

.. and if the USB layer unplugs them unconditionally while the filesystem 
is mounted, you _unconditionally_ get a system that doesn't work.

I call that worse.

Much worse.

			Linus
