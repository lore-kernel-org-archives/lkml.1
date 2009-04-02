Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbZDBRwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbZDBRwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZDBRvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:51:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54432 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZDBRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:51:50 -0400
Date: Thu, 2 Apr 2009 19:51:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Grazvydas Ignotas <notasas@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
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
Message-ID: <20090402175148.GA29544@pengutronix.de>
References: <200903280927.32786.david-b@pacbell.net> <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ups, sorry, I got the In-Reply-To wrong.  This should have been a reply
to <1238196439-16535-27-git-send-email-u.kleine-koenig@pengutronix.de>.

Best regards
Uwe

On Thu, Apr 02, 2009 at 07:47:41PM +0200, Uwe Kleine-König wrote:
> A pointer to mmc_omap_probe which lives in .init.text is passed to the
> core via platform_driver_register and so the kernel might oops if probe
> is called after the init code is discarded.
> 
> As requested by David Brownell platform_driver_probe is used instead of
> moving the probe function to .devinit.text.  This saves some memory, but
> might have the downside that a device being registered after the call to
> mmc_omap_init but before the init sections are discarded will not be
> bound anymore to the driver.

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
