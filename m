Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXJLIts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXJLIts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 04:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXJLItk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 04:49:40 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:42770 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXJLItj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 04:49:39 -0400
From: Chr <chunkeey@web.de>
To: "Javier =?iso-8859-15?q?Bola=F1os?= Molina" <javinovich@gmail.com>
Subject: Re: [PATCH] usbhid: add ASUS LCM to the blacklist
Date: Fri, 12 Oct 2007 10:49:33 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-input@atrey.karlin.mff.cuni.cz
References: <200707240228.39421.chunkeey@web.de> <8a1758740710101811q22fc235aifb1edcccd6e98e56@mail.gmail.com>
In-Reply-To: <8a1758740710101811q22fc235aifb1edcccd6e98e56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710121049.34149.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/hDvdPD+7bf5lqJde9ymI5MAGbQsOF/j1TwDNy
	XryzGbVBWZCjRnyroPiNQxan+NbZyrmJpOnmriKD2WHfzL7m2c
	gAkccZ9Ck=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 11. October 2007, Javier Bolaños Molina wrote:
> Hi all,
> [...]
> Well I installed this patch, recompiled my kernel and tried again asusoled
> application in order to test the oled display.
> First time everything seemed as usual as it was with a standard (no patched)
> kernel, asusolded ask me to rmmod  usbhid as it was not able to get control
> on the oled.
> Then I removed the usbhid and tried again, it worked. Nothing new.
> After this I loaded usbhid in order to use my mouse.
> then I tried asusoled  and  fortunately this time it worked  this time with
> usbhid loaded.
> 
> To sum up the patch works fine once I remove and load usbhid once. I tend to
> think this could be a bootstrap bug as it does work well after a manual
> reload of usbhid.
> 

hmm, sounds like the old usbhid module is still around... 
My first guess: Do you use a initrd? Have you updated it, after you recompiled your kernel?

> [...]
> PS.
> I don't know  German so it was difficult to understand the page in
> https://zockertown.de/s9y/archives/882-asusoled-compilieren.html so I would
> suggest to update https://launchpad.net/asusoled/ maybe I could help.
> 
> Regards,
> Javier Bolaños Molina.
> 

The project moved to sourceforge.net. The new maintainer is:

Adilson Oliveira <adilson@linuxembarcado.com.br>

Thanks,
	Chr.
