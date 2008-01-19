Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbYASRlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbYASRlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 12:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYASRlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 12:41:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4702 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYASRlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 12:41:05 -0500
X-Greylist: delayed 2431 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2008 12:41:05 EST
Date: Sat, 19 Jan 2008 17:00:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       liam.girdwood@wolfsonmicro.com
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
Message-ID: <20080119170030.GA469@sirena.org.uk>
Mail-Followup-To: Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	liam.girdwood@wolfsonmicro.com
References: <20080118162627.GA28974@rakim.wolfsonmicro.main> <1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080118120148.ZZRA012@mailhub.coreip.homeip.net> <fmqq50$te0$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fmqq50$te0$1@ger.gmane.org>
X-Cookie: Live Free or Live in Massachusetts.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:11:45PM +0000, Dmitry Baryshkov wrote:
> Dmitry Torokhov wrote:

> > I will need some more time to review and understand the need for the new
> > bus in the driver.

> Most likely this can be converted to platform_bus. Maybe this can also get

Could you expand on how you see that being implemented, please?  It
doesn't feel entirely comfortable to me - providing a bus for the chip
seems more direct and the platform bus not what I'd think of using for
something hanging off another bus - but I think I'm just not visualising
what you're thinking of properly.

> help from soon-to-be posted MFD (multi function devices) helpers.

The multi-function device support does feel like it could be a good fit.
I'd seen it discussed sometime last year but don't recall seeing
anything for quite a while.  Like Ben said, any pointers to current work
would be appreciated.

It's probably worth mentioning that in addition to what is in the
current patch series these chips all also provide an audio codec which
requires a reasonably substantial driver for full support.
