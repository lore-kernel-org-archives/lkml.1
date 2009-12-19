Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZLSUSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZLSUSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 15:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZLSUSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 15:18:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44986 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZLSUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 15:18:21 -0500
Date: Sat, 19 Dec 2009 21:18:17 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783
	before subsystems initialisation.
Message-ID: <20091219201816.GA28742@pengutronix.de>
References: <1260808880.2022.98.camel@climbing-alby> <1260810776.2022.130.camel@climbing-alby> <1260811085.2022.135.camel@climbing-alby> <1261152746.3356.72.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1261152746.3356.72.camel@climbing-alby>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 18, 2009 at 05:12:26PM +0100, Alberto Panizzo wrote:
> Ping :)
> 
> PATCH 1 & 2 are fixes that can go to .33
I don't like patch 1.  I'd prefer that drivers touching
MC13783_REG_POWER_MISCELLANEOUS are aware of the bit in question and
wouldn't rely on mc13783-core.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
