Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990Ab0ARTEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0ARTEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931Ab0ARTEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:04:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52990 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0ARTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:04:51 -0500
Date: Mon, 18 Jan 2010 20:04:46 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
	regulators.
Message-ID: <20100118190445.GA16989@pengutronix.de>
References: <1263830523.3632.22.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1263830523.3632.22.camel@realization>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alberto,

Can you post an updated patch addressing the discussion with Mark,
please?

>From the first look I don't like the name
MC13783_REG_POWERMISC_PWGTSPI_M as I don't understand it's purpose
without going through mc13783_reg_rmw_powermisc (which I didn't do yet).

What is the base for your patch?  (Hm, it seems next could work.
mc13783-regulator seems to have gotten some more #defines ending in _M.
You seem to mean "mask".  IMHO it's a bit unfortunate, because the
nameing scheme doesn't match the already existing names :-()

Shouldn't mc13783_state_powermisc_pwgt be a per-device variable instead
of a static variable?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
