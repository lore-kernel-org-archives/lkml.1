Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZLOOw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZLOOw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZLOOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:52:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41944 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756587AbZLOOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:52:27 -0500
Date: Tue, 15 Dec 2009 14:52:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>
Subject: Re: [PATCH 4/4] regulator: mc13783-regulator: correct the probing
 time.
Message-ID: <20091215145225.GA29034@rakim.wolfsonmicro.main>
References: <1260808880.2022.98.camel@climbing-alby>
 <1260810776.2022.130.camel@climbing-alby>
 <1260811085.2022.135.camel@climbing-alby>
 <1260811598.2022.144.camel@climbing-alby>
 <1260813215.2022.171.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260813215.2022.171.camel@climbing-alby>
X-Cookie: Put no trust in cryptic comments.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 06:53:35PM +0100, Alberto Panizzo wrote:
> When the mc13783-regulator driver is built in kernel, probing it during
> the regulator subsystem initialisation result in a fault.
> 
> That is because regulator subsystem is planned to be initialised very early
> in the boot process, before the mfd subsystem initialisation.
> 
> The mc12783-regulator probing process need to access to the mc13783-core
> functionality to read/write mc13783 registers and so must be called after
> the mc13783-core driver initialisation.
> 
> The way to do this is to let the kernel probe the mc13783-regulator driver when 
> mc13783-core register his regulator subdevice.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
