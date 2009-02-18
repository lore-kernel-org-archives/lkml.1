Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZBRUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZBRUWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZBRUWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:22:41 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:39138 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZBRUWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:22:40 -0500
Date: Wed, 18 Feb 2009 21:22:37 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: [patch 2.6.29-rc5] MMC: omap_hsmmc: only MMC1 allows HCTL.SDVS
 != 1.8V
Message-ID: <20090218212237.4cc73890@mjolnir.ossman.eu>
In-Reply-To: <200902171449.01646.david-b@pacbell.net>
References: <200902171449.01646.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 14:49:01 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Based on a patch from Tony Lindgren ... after initialization,
> never change HCTL.SDVS except for MMC1.  The other controller
> instances only support 1.8V in that field, although they can
> suport other card/SDIO/eMMC/... voltages with level shifting
> solutions such as external transceivers.
> 
> MMC2 behavior sanity tested on Overo/WLAN, OMAP3430 SDP, and
> custom hardware.  MMC1 also sanity tested on those platforms
> plus Beagle.  This also fixes a bug preventing MMC2 (and also
> presumably MMC3) from powering down when requested.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

This suffers from the same problem as all other omap_hsmmc patches. Who
claims ownership of that driver?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
