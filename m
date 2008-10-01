Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYJAUeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYJAUeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYJAUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:34:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57149 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYJAUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:34:08 -0400
Date: Wed, 1 Oct 2008 22:33:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       carbonated beverage <ramune@net-ronin.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
Message-ID: <20081001203346.GB1613@elf.ucw.cz>
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org> <20081001095322.GA27987@srcf.ucam.org> <48E3C152.1000102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3C152.1000102@goop.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-01 11:28:34, Jeremy Fitzhardinge wrote:
> Matthew Garrett wrote:
>> On Tue, Sep 30, 2008 at 05:59:06PM -0700, Jeremy Fitzhardinge wrote:
>>
>>   
>>> On my shiny new X200 running Fedora Rawhide, I'm finding that the  
>>> brightness control keys work OK, but the backlight remains stuck off  
>>> after a resume.  The machine is working fine but the backlight is 
>>> just off; I can see the display under a bright light.  Switching 
>>> consoles and poking about in /sys/class/backlight/acpi_video?/ didn't 
>>> help.
>>>     
>>
>> Intel graphics, right?
>
> Yes.  The new, erm , X4500?
>
>>  The DRM layer should handle full resume on modern Intel hardware, but 
>> there's the potential for bugs. This is entirely unrelated to ACPI, 
>> though.
>>   
>
> OK, that's a good clue.  I poke at acpi to change the brightness, so I'd  
> assumed that acpi would also handle turning the backlight on/off.
>
> I'm using the rawhide rather than standard kernel, but I'd thought they  
> were fairly similar.

I believe vanilla and rawhide kernels are _very_ different in this
area.

On your config, s2ram -f -a 3 may be the right thing after all ;-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
