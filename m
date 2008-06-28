Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYF1OBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYF1OBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYF1OBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:01:13 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46751 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753313AbYF1OBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:01:12 -0400
Date: Sat, 28 Jun 2008 16:01:10 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628160110.41ec91f7@mjolnir.drzeus.cx>
In-Reply-To: <20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153745.027b0817@mjolnir.drzeus.cx>
	<20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 15:48:44 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > The status command doesn't work on SDIO cards, so this seems like the
> > wrong place for it.
> 
> Where do you want it then?
> 

drivers/mmc/core/mmc.c seems like the correct place (and some coupling
from sd.c as well). See if you can do something that's similar to how
sysfs nodes are handled by the bus handlers.

> Btw, /sys/class/mmc_host/mmc0/<card>/test doesn't work on SDIO cards
> either:
> 

Ooops. It shouldn't be binding to non-storage cards. I'll make sure to
have that fixed.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
