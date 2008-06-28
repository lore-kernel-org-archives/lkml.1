Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYF1Nk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYF1Nk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYF1NkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:40:19 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33057 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753097AbYF1NkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:40:18 -0400
Date: Sat, 28 Jun 2008 15:40:15 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: Export internal host state through debugfs
Message-ID: <20080628154015.423daf51@mjolnir.drzeus.cx>
In-Reply-To: <20080628153704.36eda3e6@hskinnemo-gx745.norway.atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628152856.3ba1c2ff@mjolnir.drzeus.cx>
	<20080628153704.36eda3e6@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 15:37:04 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > 
> > In the other places we have conditional function, it is done by
> > ifdef:ing the calls instead. There are just two of them, so it should
> > be less mess.
> 
> Hmm. You mean it's better with three #ifdefs than one?
> 

Fewer lines though. Those dummy function stick out like a sore thumb.
It's a decent trade-off when you have multiple callers, but here we have
just the one.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
