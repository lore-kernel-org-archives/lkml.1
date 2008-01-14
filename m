Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYANOnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYANOnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYANOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:42:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38382 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbYANOmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:42:53 -0500
Date: Mon, 14 Jan 2008 14:42:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 5/6] Driver for WM97xx touchscreens in streaming mode
	on PXA2xx systems
Message-ID: <20080114144250.GA7443@rakim.wolfsonmicro.main>
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
	Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>, Ian Molton <spyro@f2s.com>,
	Vince Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <1199965870-4629-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com> <478B31B6.3050406@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B31B6.3050406@pengutronix.de>
X-Cookie: Apply only to affected area.
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:56:06AM +0100, Marc Kleine-Budde wrote:
> reMark Brown wrote:

> > Cc: Marc Kleine-Budde <mkl@penugtronix.de>
>                                 ^^
> it's mkl@pengutronix.de

Fixed, sorry about that.

> > +			/* use PEN_DOWN GPIO 13 to assert IRQ on GPIO line 2 */
> > +			wm->pen_irq = MAINSTONE_AC97_IRQ;

> I'm missing some kind of abstraction here, what about non mainstone
> boards with the pen irq wired to some other gpio?

The driver really isn't intended to cope with them.  As you say, other
boards may have things wired up differently and therefore require
different configuration of the wm97xx and other bits of the system.  The
expectation is that other systems will have their own driver.

My initial thought is that the most straightforward way of handling this
would be to rename the driver to mainstone-wm97xx or similar to make it
clear that the driver is only intended to handle Mainstone as-is.  Does
that seem reasonable?
