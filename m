Return-Path: <linux-kernel-owner+w=401wt.eu-S1946109AbXBBV5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946109AbXBBV5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946110AbXBBV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:57:15 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:33050 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946109AbXBBV5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:57:14 -0500
Message-ID: <45C3B3B0.9010902@drzeus.cx>
Date: Fri, 02 Feb 2007 22:57:04 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
CC: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx
Subject: Re: [Sdhci-devel] [PATCH 2.6.20-rc2] Add a quirk to allow ENE PCI
 SD
References: <4E9DA5E8EB%linux@youmustbejoking.demon.co.uk> <4597A791.60007@drzeus.cx> <4E9DE7C297%linux@youmustbejoking.demon.co.uk>  <4E9DF295D4%linux@youmustbejoking.demon.co.uk> <45C2EE52.4020103@drzeus.cx> <4EAF02D488%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4EAF02D488%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Salt wrote:
> 
> Your patch was mangled by Thunderbird. IME, it always does this; you should
> attach patches, not include them inline.
> 
> Still, it was easy enough to apply the patch manually.
> 

It's braindead, I was lazy and hoping it wouldn't crap things up too
badly. (it usually works if the lines are short enough)

>> I'd appreciate if you could test this sooner rather than later as the merge
>> window is just around the corner.
> 
> It doesn't work.
> 
> After applying my patch and fixing up the rejects, it still doesn't work. I
> need to disable the first of the writeb() calls mentioned in the last hunk of
> your patch for it to work again. I have the impression that the hardware
> doesn't like the power-on bit not being set :-|
> 

Now this isn't good. It means that I have to controllers that require
conflicting deviations from the standard. What a pain.

> ... hmm, it looks like there's a small bug in my patch: the label "out" needs
> to be before the last writeb() otherwise, if power is -1, no write will
> happen regardless. I'm attaching a fixed version along with an adapted
> version of your patch.
> 

I already fixed up that before I committed it to my tree, so no sweat. )

> Pierre, if you're happy to sign off the modified version of your patch, feel
> free to convert my not-yet-signed-off-by into a normal signed-off-by.
> 

I'll rework that into a separate quirk to indicate it's because of
broken hardware. It's only for unreleased hw so it's no rush. I just
wanted to see if it was related to your problem.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
