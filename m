Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZC1Tix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZC1Tix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZC1Tio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:38:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37753 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZC1Tim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:38:42 -0400
Date: Sat, 28 Mar 2009 20:38:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH 47/58] move sharpsl-pm's probe function to .devinit.text
Message-ID: <20090328193839.GC5588@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-47-git-send-email-u.kleine-koenig@pengutronix.de> <f17812d70903280232i12f4ce68h1acff0667212286c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d70903280232i12f4ce68h1acff0667212286c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 05:32:02PM +0800, Eric Miao wrote:
> 2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > A pointer to sharpsl_pm_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> >
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> >
> 
> This one looks OK to me.
I assume this is an Acked-by: you?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
