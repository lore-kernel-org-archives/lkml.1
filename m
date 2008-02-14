Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYBNPzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYBNPzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYBNPzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:55:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56310 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753256AbYBNPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:55:45 -0500
Date: Thu, 14 Feb 2008 15:55:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Pete MacKay <linux01@architechnical.net>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Message-ID: <20080214155542.GA10009@rakim.wolfsonmicro.main>
Mail-Followup-To: Dmitry <dbaryshkov@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Mike Arthur <mike.arthur@wolfsonmicro.com>,
	Stanley Cai <stanley.cai@intel.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Pete MacKay <linux01@architechnical.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
	Vincent Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <20080213140648.GD31617@rakim.wolfsonmicro.main> <1202912042-2631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <bc64b4640802140710n697ce2f4l23832bba073169c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640802140710n697ce2f4l23832bba073169c8@mail.gmail.com>
X-Cookie: Sight is a faculty
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 06:10:19PM +0300, Dmitry wrote:
> 2008/2/13, Mark Brown <broonie@opensource.wolfsonmicro.com>:

> >  +#define WM97XX_ADCSEL_X                0x1000  /* x coord measurement */
> >  +#define WM97XX_ADCSEL_Y                0x2000  /* y coord measurement */
> >  +#define WM97XX_ADCSEL_PRES     0x3000  /* pressure measurement */

> shouldn't this be 0x4000 ?

No, these are an enumeration on the chip rather than a bitmask.
