Return-Path: <linux-kernel-owner+w=401wt.eu-S934712AbZLMBwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbZLMBwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934582AbZLMBvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:51:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43568 "HELO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934381AbZLMBuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:50:50 -0500
Date: Sat, 12 Dec 2009 18:23:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Message-ID: <20091212182356.GE3092@sirena.org.uk>
References: <1260635829.2054.16.camel@climbing-alby>
 <1260636523.2054.28.camel@climbing-alby>
 <1260636819.2054.33.camel@climbing-alby>
 <1260636976.2054.36.camel@climbing-alby>
 <1260637577.2054.43.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260637577.2054.43.camel@climbing-alby>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] regulator: mc13783 change to
 platform_driver_register.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 06:06:17PM +0100, Alberto Panizzo wrote:
> Change the instant when regulator driver is probed. 
> To have a correct regulators initialisation (enable, disable and voltages 
> selection), the driver must have access to mc13783 registers and so 
> mc13783-core must be loaded before this.
> 
> With this patch mc13783_regulator_probe is called when mc13783-core
> register the regulator subsystem.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I think this one ought to go into 2.6.33 as a fix.
