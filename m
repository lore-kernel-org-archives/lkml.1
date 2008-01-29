Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbYA2AK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbYA2AK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYA2AKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:10:19 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:62342 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYA2AKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:10:17 -0500
Date: Mon, 28 Jan 2008 19:10:15 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479E399C.1030409@rtr.ca>
To: Mark Lord <liml@rtr.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801281910.15883.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281404.12937.gene.heskett@gmail.com> <479E399C.1030409@rtr.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Mark Lord wrote:
>Gene Heskett wrote:
>>..
>> And so far no one has tried to comment on those 2 dmesg lines I've quoted
>> a couple of times now, here's another:
>> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
>> [    0.000000] If you got timer trouble try acpi_use_timer_override
>> what the heck is that trying to tell me to do, in some sort of broken
>> english?
>
>..
>
>I think it says this:
>
>  "If your system is misbehaving, then try adding the
> acpi_use_timer_override keyword to your kernel command line
> (/boot/grub/menu.lst) and see if it helps."
>
>So, you can either hardcode it in /boot/grub/menu.lst (just add it to the
> end of the first line you see there that begins with the word "kernel".
>
>Or you can just try it temporarily at boot time (safer, but tricker),
>by catching GRUB (the bootloader) before it actually loads Linux.
>
>Usually there's some key or something it says you have 3 seconds to hit for
> a "menu", so do that, and then use the cursor keys to find the first
> "kernel" line in that menu and hit "e" (edit) to go and add the
> acpi_use_timer_override keyword to the end of that line (same as above).
>
>Hit enter when done, and then the letter b (boot) to load Linux with that
> option.
>
>Clear as mud, right?  :)

Precisely Mark.  Thanks, I'm building an ide-ata kernel 2.6.24 now, and I've 
added that to the argument line for 2.6.24-rc8.

Thanks mark.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Of all men's miseries, the bitterest is this:
to know so much and have control over nothing.
		-- Herodotus
