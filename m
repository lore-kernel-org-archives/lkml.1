Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXCEFfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXCEFfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 00:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXCEFfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 00:35:50 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:33567 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbXCEFft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 00:35:49 -0500
Message-ID: <45EBAC73.7010600@drzeus.cx>
Date: Mon, 05 Mar 2007 06:36:51 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca>
In-Reply-To: <45EB9E72.6040107@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Another regression, for Pierre Ossman this time.
> 
> My syslog gets spammed like this (below) on suspend/resume (to RAM) cycles.
> Worked fine, without all of the noise, in all previous kernels up to
> 2.6.20+.
> 

This looks like a PCI configuration issue. Can you bisect which commit caused
the issue? And what's the PCI address of the device?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
