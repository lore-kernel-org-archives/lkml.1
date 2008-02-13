Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbYBMKLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbYBMKLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYBMKL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:11:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38609 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755552AbYBMKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:11:24 -0500
Date: Wed, 13 Feb 2008 10:11:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pete MacKay <linux01@architechnical.net>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Message-ID: <20080213101122.GB31617@rakim.wolfsonmicro.main>
Mail-Followup-To: Pete MacKay <linux01@architechnical.net>,
	Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Mike Arthur <mike.arthur@wolfsonmicro.com>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	Stanley Cai <stanley.cai@intel.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
	Vincent Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <20080212101738.GB21039@rakim.wolfsonmicro.main> <1202811705-2303-1-git-send-email-broonie@opensource.wolfsonmicro.com> <65343.69.30.58.166.1202876923.squirrel@architechnical.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65343.69.30.58.166.1202876923.squirrel@architechnical.net>
X-Cookie: HUGH BEAUMONT died in 1982!!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:28:43PM -0500, Pete MacKay wrote:

> We're using the wm9712 codec with the sound/soc/pxa code configured in and
> came across this build error:

Which kernel version are you building against?  I've been testing with
v2.6.24 (and have just updated to v2.6.25-rc1 which is also building
fine for me) and...

>  #ifndef _LINUX_WM97XX_H
>  #define _LINUX_WM97XX_H
> 
> +#include <sound/driver.h>

...this header is deprecated so should never need to be included (yes,
there are other instances in there which need to be cleaned up) so I'm a
bit mystified as to what's going wrong for you here.  Which kernel
version are you using?
