Return-Path: <linux-kernel-owner+w=401wt.eu-S965815AbXBOKhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbXBOKhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965816AbXBOKhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:37:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37364 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965815AbXBOKhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:37:01 -0500
Date: Thu, 15 Feb 2007 11:36:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jan Dittmer <jdi@l4x.org>
Cc: stelian@popies.net, linux-acpi@vger.kernel.org, linux-pm@osdl.org,
       adaplas@pol.net, dawes@xfree86.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Suspend to RAM, Sony Vaio PCG-SRX51P, lcd stays off
Message-ID: <20070215103639.GB27338@elf.ucw.cz>
References: <45D43489.3060409@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D43489.3060409@l4x.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I own an older Sony Vaio SRX51P, European Model, P3 based. s2ram
> identifies it with
> 
>     sys_vendor   = "Sony Corporation    "
>     sys_product  = "PCG-SRX51P(DE)      "
>     sys_version  = "01                  "
>     bios_version = "R0232U2"
> 
> Suspend to RAM by using "s2ram -v -m -f" actually works and the
> laptop comes back to life, is accessible by network, etc. kudos
> so far.
> The only but serious problem is, that the lcd stays off after
> resume. No matter what kind of options for s2ram I try, if I disable

Is the _lcd_ off or the _backlight_ off? Use bright flashlight to
tell.

> framebuffer or suspend from X, the lcd always stays off. Only
> a reboot fixes this. Note that the X driver also cannot dis-/enable
> the lcd (xset dpms force off). It always stays lit. I also tried
> with i810switch, but that also does not affect the lcd.
> spicctrl -b42 neither.
> Latest kernel I tested is 2.6.20-git11 from today.
> 
> So has anyone of you suspend, acpi, sonypi, fb people an idea how to fix
> this? I suspect one has to call some magic ACPI method upon resume? What
> other kind of information would be needed to debug this? Anything more
> to try? Are there some sony people here listening who can fix this?

sonypi people actually might know how to help...

> 00:02.0 VGA compatible controller: Intel Corporation 82815 CGC
[Chipset Graphics Controller] (rev 11)

Wait a moment, did not Intel release nice, commented, GPLed sources
for their graphics cards somewhere? That might help.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
