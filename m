Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXEMK4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXEMK4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 06:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXEMKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 06:55:59 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46813 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbXEMKz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 06:55:58 -0400
Message-ID: <4646EE93.8090307@drzeus.cx>
Date: Sun, 13 May 2007 12:55:15 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tobias Bengtsson <tobbe@tobbe.nu>
CC: linux-kernel@vger.kernel.org
Subject: Re: SDHCI issues on Ricoh in 2.6.20, 21 and 21-rc7-mm2
References: <4639D927.4080406@tobbe.nu>
In-Reply-To: <4639D927.4080406@tobbe.nu>
X-Mime-Autoconverted: from 8bit to 7bit by courier 0.53
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Bengtsson wrote:
> Hi,
> 
> Inserting a SD card after bootup does not work.
> Please cc any response to me personally as I'm not on the list.
> 

Very odd. And unfortunately I do not know what the problem might be.

>From your testing we can conclude two things:

- The controller has no problem detecting the device (the difference in the
"Present" register shows that).

- Interrupts work just fine, as it can properly communicate with the card.

And since the problem is normally one of those two, I have no idea what the hell
is going on here. Ricoh is also one of the Linux-unfriendly vendors so no hope
of getting them to cough up some info.

We could do some silly polling hack. It isn't clean, but it might get things
somewhat working at least.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
