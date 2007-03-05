Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXCEP7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXCEP7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbXCEP7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:59:09 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:52684 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569AbXCEP7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:59:06 -0500
Message-ID: <45EC3E8C.6000102@drzeus.cx>
Date: Mon, 05 Mar 2007 17:00:12 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca> <45EBAC73.7010600@drzeus.cx> <45EC2851.7020905@rtr.ca> <45EC352C.4070508@drzeus.cx> <45EC3609.4030809@drzeus.cx> <45EC38C5.1060600@rtr.ca>
In-Reply-To: <45EC38C5.1060600@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Pierre Ossman wrote:
>>
>> Hmm... I guess it can't be as the interrupt handler isn't associated
>> with a
>> device, just a random pointer.
>>
>> So either release the interrupt (which seems a bit unsafe as then we
>> might not
>> get it back), or handle states at the start of the isr.
>
> From linux/Documentation/power/pci.txt:
>

That conveniently leaves out the part of how to handle when we're not
getting our stuff back. ;)

But it seems to be the easier route anyway... I'll whip up a patch.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

