Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYJAJjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYJAJjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYJAJjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:39:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47553 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYJAJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:39:05 -0400
Date: Wed, 1 Oct 2008 11:40:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: carbonated beverage <ramune@net-ronin.org>, linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
Message-ID: <20081001094041.GB897@elf.ucw.cz>
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E2CB5A.1050809@goop.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-09-30 17:59:06, Jeremy Fitzhardinge wrote:
> Pavel Machek wrote:
>> Hi!
>>
>>   
>>> I just upgraded from 2.6.25.17 to 2.6.26.5 on my Thinkpad Z61t, and found
>>> the brightness keys will cause the X server to die.  When using the
>>> brightness up/down keys, the screen will go blank -- Control+Alt+F# will
>>> still switch to a different virtual console, but switching back will not
>>> restore the video state.
>>>
>>> After killing the window manager, I was able to bring up X again without
>>> a problem -- but using the brightness keys still causes it to go blank
>>> again within X, while the brightness does get changed correctly on the
>>> console.
>>>
>>> There were no kernel messages, but this appeared in the Xorg log:
>>>     
>>
>> Yes, I had similar problems... for me it blanked screen on closing
>> lid. Problem disappeared after upgrading X...
>>
>>   
>>> .config attached -- is this a known issue?  In the meantime, I'm starting
>>> a bisection to figure out where the problem crops up.
>>>     
>>
>> For me CONFIG_ACPI_VIDEO never really worked...
>>   
>
> On my shiny new X200 running Fedora Rawhide, I'm finding that the 
> brightness control keys work OK, but the backlight remains stuck off after 
> a resume.  The machine is working fine but the backlight is just off; I can 
> see the display under a bright light.  Switching consoles and poking about 
> in /sys/class/backlight/acpi_video?/ didn't help.

What are you using for s2ram? s2ram -f -a 3 normally works on thinkpads...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
