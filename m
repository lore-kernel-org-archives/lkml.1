Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYF1PSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYF1PSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYF1PSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:18:01 -0400
Received: from server.drzeus.cx ([85.8.24.28]:49339 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753091AbYF1PSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:18:00 -0400
Date: Sat, 28 Jun 2008 17:17:57 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: Export internal host state through debugfs
Message-ID: <20080628171757.6f1b9307@mjolnir.drzeus.cx>
In-Reply-To: <20080628164146.094a2c82@hskinnemo-gx745.norway.atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628152856.3ba1c2ff@mjolnir.drzeus.cx>
	<20080628153704.36eda3e6@hskinnemo-gx745.norway.atmel.com>
	<20080628154015.423daf51@mjolnir.drzeus.cx>
	<20080628162312.0f10c6d3@hskinnemo-gx745.norway.atmel.com>
	<20080628164146.094a2c82@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 16:41:46 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > Actually, if debugfs is disabled, debugfs_create_dir() and friends are
> > inline functions which return ERR_PTR(-ENODEV). So if we just remove
> > the whole #ifdef altogether, gcc should be smart enough to optimize
> > away the whole thing if debugfs isn't enabled...
> > 
> > I'll give it a try.
> 
> Yeah, it does seem to work, but it means we'll have to put at least
> debugfs_root into struct mmc_host unconditionally. Assuming we find a
> way to not put all the other stuff in there, is that acceptable?
> 

Sounds good.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
