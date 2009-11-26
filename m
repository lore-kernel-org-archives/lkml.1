Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZKZH5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZKZH5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbZKZH5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:57:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37423 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbZKZH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:57:39 -0500
Date: Thu, 26 Nov 2009 08:57:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MXC: set GPIO IRQ handler
Message-ID: <20091126075724.GA12179@pengutronix.de>
References: <807htelb5d.fsf@merkur.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <807htelb5d.fsf@merkur.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

On Wed, Nov 25, 2009 at 07:19:58PM +0100, John Ogness wrote:
> The irq chip function gpio_set_irq_type() correctly sets the i.MX
> registers but does not set the irq handler.
I assume you see some breakage without your patch?  In mainline?

>                                             This means that all
> gpio-based irq's are handled with handle_edge_irq().
This is not true in mainline, until 060d20d (imx/gpio: Use
handle_level_irq) (currently in imx/mxc-master) hits Linus' tree ...

> This patch corrects this by also setting the appropriate handler.
> 
> This patch is against 2.6.32-rc8.
... so there is no hurry.

Can you please test with 060d20d if your breakage still occurs and
if it is still valid report some details (for me and the commit log)?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
