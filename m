Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbXCFHWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbXCFHWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXCFHWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:22:03 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50132 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbXCFHWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:22:01 -0500
Message-ID: <45ED16DE.3070700@drzeus.cx>
Date: Tue, 06 Mar 2007 08:23:10 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Lord <lkml@rtr.ca>, sdhci-devel@list.drzeus.cx,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>	<20070305015031.GF3441@stusta.de>	<45EB9DC6.8010403@rtr.ca>	<45EB9E72.6040107@rtr.ca>	<45EBAC73.7010600@drzeus.cx>	<45EC2851.7020905@rtr.ca>	<45EC351B.2020206@rtr.ca>	<20070305201707.8d8a092e.akpm@linux-foundation.org>	<45ED0074.5010606@drzeus.cx> <20070305220938.d68f9368.akpm@linux-foundation.org>
In-Reply-To: <20070305220938.d68f9368.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Oh, it's just a pain in the ass.  Please don't do it lightly - if there's a
> really good reason then OK.
>   

The mmc code is a mess (mostly my fault for the addition of SD support)
and I'm trying to break things apart to clear the code up. That
unfortunately meant moving files around.

> Plus it helps if the massive file move isn't left sitting in some external
> tree for months.  I mean, it's usually a trivial thing, so do it just a
> week before the pull is due.  
>
>   

My goal with putting it in -mm was to give people a chance to cry bloody
murder before I merged the stuff (which I intend to do immediately post
2.6.21). The changes are all over the place, so to ease my mind I prefer
to have it simmer for a while.

As to making your life easier, send patches to the mmc layer my way and
I'll handle the conflicts. I made the mess so it's only fair that I have
to clean it up.

> But whatever.  What are we going to do about $SUBJECT?
>   

It should go in now, along with a fix to unregister the interrupt. I
have a bunch of fixes I intend to push to Linus today and I'll include
this in that group.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

