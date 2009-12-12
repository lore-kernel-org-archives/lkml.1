Return-Path: <linux-kernel-owner+w=401wt.eu-S934493AbZLMBvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493AbZLMBvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934451AbZLMBvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:51:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43568 "HELO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934406AbZLMBuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:50:51 -0500
Date: Sat, 12 Dec 2009 18:11:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20091212181142.GC3092@sirena.org.uk>
References: <1260635829.2054.16.camel@climbing-alby>
 <1260636523.2054.28.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260636523.2054.28.camel@climbing-alby>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
 between read and write value of two bits in POWER_MISCELLANEUS register.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 05:48:43PM +0100, Alberto Panizzo wrote:
> MC13783_REGCTRL_PWGTnSPIEN controls the states of the corresponding
> PWGTn_DRV output.
> Reading 1 on the corresponding bit mean that the output is enabled
> Writing 1 on the corresponding bit disable that output!

> So, if not asked directly to modify those bits, write the inverted
> value.

Some comments in the code explaining what's going on wouild help a lot -
it's not going to be obvious to a reader why the code is doing this and
may well confuse them.
