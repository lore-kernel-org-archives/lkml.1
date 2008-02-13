Return-Path: <linux-kernel-owner+w=401wt.eu-S1764693AbYBME2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764693AbYBME2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYBME2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:28:35 -0500
Received: from xerxes.tchmachines.com ([208.76.80.175]:34051 "EHLO
	xerxes.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbYBME2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:28:34 -0500
Message-ID: <65343.69.30.58.166.1202876923.squirrel@architechnical.net>
In-Reply-To: <1202811705-2303-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20080212101738.GB21039@rakim.wolfsonmicro.main>
    <1202811705-2303-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Feb 2008 23:28:43 -0500 (EST)
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
From: "Pete MacKay" <linux01@architechnical.net>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Dmitry Torokhov" <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       "Liam Girdwood" <liam.girdwood@wolfsonmicro.com>,
       "Graeme Gregory" <gg@opensource.wolfsonmicro.com>,
       "Mike Arthur" <mike.arthur@wolfsonmicro.com>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Stanley Cai" <stanley.cai@intel.com>,
       "Rodolfo Giometti" <giometti@enneenne.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Pete MacKay" <linux01@architechnical.net>,
       "Marc Kleine-Budde" <mkl@pengutronix.de>, "Ian Molton" <spyro@f2s.com>,
       "Vincent Sanders" <vince@kyllikki.org>,
       "Andrew Zabolotny" <zap@homelink.ru>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - xerxes.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - architechnical.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch series adds support for the touchscreen controllers provided
> by Wolfson Microelectronics WM97xx series chips in both polled and
> streaming modes.

We're using the wm9712 codec with the sound/soc/pxa code configured in and
came across this build error:

In file included from include/linux/wm97xx.h:9,
                 from drivers/input/touchscreen/wm97xx-core.c:50:
include/sound/core.h:281: error: `SNDRV_CARDS' undeclared here (not in a
function)

I had to apply the following one-line patch to the header:

Index: linux-2.6.24.labquest/include/linux/wm97xx.h
===================================================================
--- linux-2.6.24.labquest.orig/include/linux/wm97xx.h	2008-02-12
20:17:11.000000000 -0800
+++ linux-2.6.24.labquest/include/linux/wm97xx.h	2008-02-12
20:17:39.000000000 -0800
@@ -6,6 +6,7 @@
 #ifndef _LINUX_WM97XX_H
 #define _LINUX_WM97XX_H

+#include <sound/driver.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/ac97_codec.h>

