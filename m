Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZKCTUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZKCTUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZKCTUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:20:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39289 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZKCTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:20:53 -0500
Date: Tue, 3 Nov 2009 20:20:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH] [RTC] Add Freescale MC13783 RTC driver
Message-ID: <20091103192025.GA20260@pengutronix.de>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de> <1256373342-5294-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256373342-5294-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Oct 24, 2009 at 10:35:42AM +0200, Uwe Kleine-König wrote:
> This driver provides support for the RTC part integrated into the
> Freescale MC13783 PMIC and bases on patch created earlier by Sascha
> Hauer.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Uwe Kleine-König <u.kleine-könig@pengutronix.de>
> Cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com
> ---
> Hello,
> 
> this patch depends on
> 
> 	mfd/mc13783: near complete rewrite
> 
> sent earlier on lkml[1].  Compared to the earlier version of rtc support
> on mc13783 as sent by Sascha, this driver got reset detection and
> therefore depends on the patch above.
> 
> A tree runnable on Phytec's PCM038 is available in my git tree
> 
> 	git://git.pengutronix.de/git/ukl/linux-2.6.git mc13783
> 
> .  (Maybe I will rewrite these commits, so please expect it might change
> in a non-fast-forward manner.)
This happend now.  Based on feed-back for the mc13783-core driver I had
to modify the rtc-driver to.  Only the signature of the irq handler
function changed.

I don't consider that change worth to repost, so if you're interested
please check out my branch.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
