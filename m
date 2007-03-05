Return-Path: <linux-kernel-owner+w=401wt.eu-S1751161AbXCEPTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbXCEPTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbXCEPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:19:12 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46669 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbXCEPTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:19:11 -0500
Message-ID: <45EC352C.4070508@drzeus.cx>
Date: Mon, 05 Mar 2007 16:20:12 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca> <45EBAC73.7010600@drzeus.cx> <45EC2851.7020905@rtr.ca>
In-Reply-To: <45EC2851.7020905@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>
> But.. in the middle of all of this, we now see the SHDCI code
> trying to talk to its as-yet-not-restored device, and being rather
> noisy about it all:
>

Not quite. I'd say it's the kernel calling the interrupt handler of a
currently sleeping device. Since we're seeing this problem I assume the
kernel's interrupt code isn't aware of PM states?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

