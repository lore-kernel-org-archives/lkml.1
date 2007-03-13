Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbXCMTHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbXCMTHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXCMTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:07:19 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51549 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbXCMTHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:07:17 -0400
Message-ID: <45F6F677.1070302@drzeus.cx>
Date: Tue, 13 Mar 2007 20:07:35 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] 2.6.21-rc3: known regressions
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313124957.GR18731@stusta.de> <45F6A240.3090601@drzeus.cx> <200703131436.15586.oneukum@suse.de> <20070313181147.GA12224@elf.ucw.cz>
In-Reply-To: <20070313181147.GA12224@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> Uhuh. User error, lets close the report.
> 
> mmc changed the major to 
> 
> 236 mmc
> 
> ... while it was something else in 2.6.20. Can we get stable device
> allocation for mmc?

What kind of savages do not use udev these days?! ;)

I don't have the time and energy to jump through all the hoops required to get
an official number right now. Most users use udev and those that don't can use
the "major" parameter for mmc_block.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
