Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYDAMV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYDAMV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYDAMVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:21:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3455 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbYDAMVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:21:18 -0400
Date: Tue, 1 Apr 2008 13:20:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Pete MacKay <linux01@architechnical.net>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: WM97xx touchscreen drivers
Message-ID: <20080401122057.GB9391@sirena.org.uk>
Mail-Followup-To: Dmitry <dbaryshkov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Pete MacKay <linux01@architechnical.net>,
	Ian Molton <spyro@f2s.com>, Vince Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <20080401102825.GA30868@rakim.wolfsonmicro.main> <bc64b4640804010442k458bdd10jef0bc722ec25efd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804010442k458bdd10jef0bc722ec25efd1@mail.gmail.com>
X-Cookie: Ring around the collar.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 03:42:26PM +0400, Dmitry wrote:
> 2008/4/1, Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > This patch series adds support for the touchscreen controllers found in
> >  WM97xx devices.  This revision of the series fixes some races when
> >  closing an active device and fixes a shadowed variable.

> Changelog since last repost?

Unfortunately this gets mostly lost due to squashing the changes down (I
don't immediately resend due to the amount of noise created by
repeatedly sending the series.

This should be approximately it.

Lars Munch (1):
      wm971x: Check for pen up on both axes

Mark Brown (5):
      wm9712: Return 0 rather than RC_PENUP on error
      wm9713: Return 0 rather than RC_PENUP on error
      wm9713: Fix shadowed variable name
      wm97xx-core: Balance enable/disable interrupt calls
      wm97xx-core: Disable interrupts on the chip prior to freeing IRQ

For what it's worth you can track the changes in the dev branch of

   git://opensource.wolfsonmicro.com/linux-2.6-touch

and via gitweb at:

   http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-touch.git;a=log;h=dev

This should all get a lot easier once the driver has been merged...
