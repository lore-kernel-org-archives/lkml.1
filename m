Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZI2QDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZI2QDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZI2QDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:03:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57998 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZI2QDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:03:15 -0400
Date: Tue, 29 Sep 2009 18:03:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: booting on a PIII Celeron?
Message-ID: <20090929160312.GA14405@elf.ucw.cz>
References: <4AC0D59F.8000502@msgid.tls.msk.ru> <4AC0D651.7030009@msgid.tls.msk.ru> <20090928163617.GA25503@atrey.karlin.mff.cuni.cz> <4AC20CD0.8030801@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC20CD0.8030801@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> So the celeron machine lacks "apic" flag.  And in my
>>> kernel config, apic is enabled:
>>>  CONFIG_X86_LOCAL_APIC=y
>>>  CONFIG_X86_IO_APIC=y
>>> (but not on the command line like apic=force)
>> try 'noapic nolapic' to see if it helps?
>
> Neither (nor both) changes anything.  It just reboots
> instantly right after "Loading initrd..." message from
> the bootloader.

Ok, you may want to try bisection...

> Ok, one more thing to mention.  2.6.31 introduced a
> somewhat annoying feature, -- the screen (console)
> blinks at the very start of the boot process (I mean
> text mode, no any framebuffers or the like).  Here,
> the screen blinks as usual for .31, I can see everything
> back including that "Loading initrd" line, and only
> after this the system reboots.  No more messages
> gets printed, including "kernel command line:",
> "Initializing cgroup subsys" or "Linux version ...".
> I switched CPU clock to 200MHz (minimum clock rate
> this motherboard supports using jumpers) and I can
> see the whole thing like in slow motion.

Hmm, can you try enabling earlyprintk?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
