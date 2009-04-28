Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZD1T1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZD1T1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZD1T1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:27:35 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54694 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZD1T1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:27:34 -0400
Date: Tue, 28 Apr 2009 21:27:14 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make mmci-omap using platform_driver_probe
Message-ID: <20090428212714.3c9bbc3d@mjolnir.ossman.eu>
In-Reply-To: <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <200903280927.32786.david-b@pacbell.net>
	<1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Apr 2009 19:47:41 +0200
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> A pointer to mmc_omap_probe which lives in .init.text is passed to the
> core via platform_driver_register and so the kernel might oops if probe
> is called after the init code is discarded.
> 
> As requested by David Brownell platform_driver_probe is used instead of
> moving the probe function to .devinit.text.  This saves some memory, but
> might have the downside that a device being registered after the call to
> mmc_omap_init but before the init sections are discarded will not be
> bound anymore to the driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Grazvydas Ignotas <notasas@gmail.com>
> Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> ---

Queued.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
