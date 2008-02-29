Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbYB2QTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbYB2QTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbYB2QSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:18:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44685 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759866AbYB2QSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:18:53 -0500
Date: Fri, 29 Feb 2008 16:18:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Pete MacKay <linux01@architechnical.net>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 5/6] Driver for WM97xx touchscreens in streaming mode
	on Mainstone
Message-ID: <20080229161850.GA11451@rakim.wolfsonmicro.main>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Mike Arthur <mike.arthur@wolfsonmicro.com>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	Stanley Cai <stanley.cai@intel.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Pete MacKay <linux01@architechnical.net>,
	Ian Molton <spyro@f2s.com>, Vince Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com> <12040332181161-git-send-email-broonie@opensource.wolfsonmicro.com> <12040332181394-git-send-email-broonie@opensource.wolfsonmicro.com> <12040332182008-git-send-email-broonie@opensource.wolfsonmicro.com> <12040332181746-git-send-email-broonie@opensource.wolfsonmicro.com> <20080227230941.f0885763.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227230941.f0885763.akpm@linux-foundation.org>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:09:41PM -0800, Andrew Morton wrote:

> If the calling process happens to have a signal pending then the
> schedule_timeout() becomes a no-op.  Will the driver still function
> correctly?

No, it doesn't.  Changed to be non-interruptible - thanks!
