Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYA1UXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYA1UXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYA1UW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:22:57 -0500
Received: from rtr.ca ([76.10.145.34]:2888 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYA1UW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:22:56 -0500
Message-ID: <479E399C.1030409@rtr.ca>
Date: Mon, 28 Jan 2008 15:22:52 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <479E24F7.4090502@rtr.ca> <200801281404.12937.gene.heskett@gmail.com>
In-Reply-To: <200801281404.12937.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
>..
> And so far no one has tried to comment on those 2 dmesg lines I've quoted a 
> couple of times now, here's another:
> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
> [    0.000000] If you got timer trouble try acpi_use_timer_override
> what the heck is that trying to tell me to do, in some sort of broken english?
..

I think it says this:

  "If your system is misbehaving, then try adding the acpi_use_timer_override
   keyword to your kernel command line (/boot/grub/menu.lst) and see if it helps."

So, you can either hardcode it in /boot/grub/menu.lst (just add it to the end
of the first line you see there that begins with the word "kernel".

Or you can just try it temporarily at boot time (safer, but tricker),
by catching GRUB (the bootloader) before it actually loads Linux.

Usually there's some key or something it says you have 3 seconds to hit for a "menu",
so do that, and then use the cursor keys to find the first "kernel" line in that menu
and hit "e" (edit) to go and add the acpi_use_timer_override keyword to the end of
that line (same as above).

Hit enter when done, and then the letter b (boot) to load Linux with that option.

Clear as mud, right?  :)

