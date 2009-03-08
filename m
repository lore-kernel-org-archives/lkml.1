Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZCHOAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZCHOAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZCHN7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 09:59:55 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50841 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZCHN7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 09:59:55 -0400
Date: Sun, 8 Mar 2009 14:59:51 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Message-ID: <20090308145951.0fdd607a@mjolnir.ossman.eu>
In-Reply-To: <200903031918.07443.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	<20090302224040.5e7ab0b2@mjolnir.ossman.eu>
	<200903021400.50201.david-b@pacbell.net>
	<200903031918.07443.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 19:18:06 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Glue between MMC and regulator stacks ... compiles, and
> mmc_regulator_get_ocrmask() passed sanity testing.
> 
> These calls are intended to be used by MMC host adapters
> using at least one regulator per host.  Examples include
> slots with regulators supporting multiple voltages and
> ones using multiple voltage rails (e.g. DAT4..DAT7 using a
> separate supply, or a split rail chip like certain SDIO
> WLAN or eMMC solutions).
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Changes from previous version:  automagically available if the
> regulator calls are available; callers now pass in host->ios.vdd.
> mmc_regulator_set_ocr() still untested.
> 

Looks good. Now what should I do with it? Merge it in the next window
good enough?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
