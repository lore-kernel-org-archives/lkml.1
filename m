Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYF1QL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYF1QL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYF1QLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:11:49 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39584 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928AbYF1QLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:11:49 -0400
Date: Sat, 28 Jun 2008 18:11:45 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628181145.60c55ea0@mjolnir.drzeus.cx>
In-Reply-To: <20080628173637.53e3279f@hskinnemo-gx745.norway.atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153745.027b0817@mjolnir.drzeus.cx>
	<20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
	<20080628160110.41ec91f7@mjolnir.drzeus.cx>
	<20080628161524.5c3fd45f@hskinnemo-gx745.norway.atmel.com>
	<20080628172205.430b35b2@mjolnir.drzeus.cx>
	<20080628173637.53e3279f@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 17:36:37 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > 
> > An alternative to sticking it into mmc.c is to create a debugfs.c that
> > contains all the uglyness. Debugging code isn't quite as important to
> > keep crystal clear.
> 
> But if we're going to rely on gcc optimizing the whole thing away when
> debugfs is disabled, we must keep these buggers in the same file as its
> caller...
> 
> Though I suppose an extra function call that does nothing at host and
> card registration time isn't a very high price to pay for cleaner code.
> 

This is in the device addition/removal code as well. Hardly a hotpath.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
