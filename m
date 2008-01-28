Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbYA1Ucn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbYA1Ucn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbYA1Ucb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:32:31 -0500
Received: from rtr.ca ([76.10.145.34]:2604 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYA1Uc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:32:29 -0500
Message-ID: <479E3BDC.2080708@rtr.ca>
Date: Mon, 28 Jan 2008 15:32:28 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <479E24F7.4090502@rtr.ca> <200801281404.12937.gene.heskett@gmail.com> <479E399C.1030409@rtr.ca>
In-Reply-To: <479E399C.1030409@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Gene Heskett wrote:
>> ..
>> And so far no one has tried to comment on those 2 dmesg lines I've quoted a couple of times now, here's another:
>> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
>> [    0.000000] If you got timer trouble try acpi_use_timer_override
>> what the heck is that trying to tell me to do, in some sort of broken english?
> ..
> 
> I think it says this:
> 
>  "If your system is misbehaving, then try adding the acpi_use_timer_override
>   keyword to your kernel command line (/boot/grub/menu.lst) and see if it helps."
> 
> So, you can either hardcode it in /boot/grub/menu.lst (just add it to the end
> of the first line you see there that begins with the word "kernel".
> 
> Or you can just try it temporarily at boot time (safer, but tricker),
> by catching GRUB (the bootloader) before it actually loads Linux.
> 
> Usually there's some key or something it says you have 3 seconds to hit for a "menu",
> so do that, and then use the cursor keys to find the first "kernel" line in that menu
> and hit "e" (edit) to go and add the acpi_use_timer_override keyword to the end of
> that line (same as above).
..

Minor correction (having just tried it here):  once you see the GRUB (boot) menu,
hit the letter e to edit the first entry, then scroll to the "kernel" line,
and hit the letter e again to edit that line.  It should put you at the end of the
line, where you can just type a space and then acpi_use_timer_override and then
hit enter to finish the (temporary) edit.  Then hit b for boot.

-ml
