Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXAXKEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXAXKEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 05:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXAXKEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 05:04:10 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41018 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXAXKEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 05:04:08 -0500
Message-ID: <45B72F13.4040707@drzeus.cx>
Date: Wed, 24 Jan 2007 11:04:03 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: au1xmmc R6 response support
References: <20070123100814.GA5001@roarinelk.homelinux.net> <45B65A73.90308@drzeus.cx> <20070124055202.GA6446@roarinelk.homelinux.net>
In-Reply-To: <20070124055202.GA6446@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> 
> not in my version of 2.6.20-rc5 (and 2.6.19):
> 

HEAD has this fixed. Every spec I can get my hands on states that R1 and
R6 have the same format. So it sounds like this controller is doing
something stupid.

> 
> Without the patch, SD card detection stops with CMD7 returning error.
> 

Can I see a dump with MMC_DEBUG enabled?

On a related note... Would you, or anyone else you know, be willing to
sign up as official maintainer of this driver? Otherwise I'll have to
mark it as unmaintained.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
