Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbXJESev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbXJESev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXJESen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:34:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbXJESem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:34:42 -0400
Message-ID: <47068398.9070304@zytor.com>
Date: Fri, 05 Oct 2007 11:34:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: video resume stuff
References: <20071004130513.GA16076@elf.ucw.cz> <470511A9.4060705@zytor.com> <20071005073238.GA19065@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0710051648440.25413@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710051648440.25413@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 5 Oct 2007, Pavel Machek wrote:
> 
>>> I suggest we tackle this *after* the x86 merge.
>> Well, we still have the regression on jikos' strange system, and I would 
>> like to understand what is going on there.
> 
> Sorry for this taking too long. Finally I had the time to play with this 
> again, so here goes the current summary. I have a system here, that:
> 
> - with 1d67953f2bda8876045c24ae58841f27d9bb7572 (just before the setup 
>   code rewrite), resumes nicely in VGA console 
>   (acpi_sleep=s3_bios,s3_mode kernel parameter is needed), everything 
>   works
> 
> - with c39736823232bc3ca113c8228fa852c09fba300e (just after the setup code 
>   rewrite), VGA text console is garbled after resume - looks like the 
>   video RAM contains some strange data (patterns from BIOS post can be 
>   recognized, there are some various-colored stripes across the screen, 
>   etc). The machine also seems to be frozen (no keyboard LEDs working, 
>   etc).
> 
> - with 2.6.23-rc9, the video doesn't come up at all, I can't even see the 
>   garbled picture any more - the display stays blank, the LED diod is 
>   yellow (i.e. looks like completely no signal from VGA card). On the 
>   other hand, the machine seems to work otherwise
> 

Jiri, what particular video mode are you running in?  In other words, 
what is your vga= parameter set to?  In fact, what does your entire 
kernel command line look like?

Also, if you could extract the information requested in:

http://marc.info/?i=46FD802D.2030804@zytor.com

... that would really help.

	-hpa

(who notices we really need to export boot_params to userspace for sanity)
