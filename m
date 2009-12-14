Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZLNLFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZLNLFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbZLNLE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:04:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41499 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756782AbZLNLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:04:59 -0500
Date: Mon, 14 Dec 2009 11:04:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] regulator: add voltage selection capability to
 mc13783 regulators.
Message-ID: <20091214110457.GA21066@rakim.wolfsonmicro.main>
References: <1260635829.2054.16.camel@climbing-alby>
 <1260636523.2054.28.camel@climbing-alby>
 <1260636819.2054.33.camel@climbing-alby>
 <1260636976.2054.36.camel@climbing-alby>
 <20091213200142.GC14024@pengutronix.de>
 <1260787298.2022.55.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260787298.2022.55.camel@climbing-alby>
X-Cookie: Too much is not enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:41:38AM +0100, Alberto Panizzo wrote:

> Maybe the PLL must be initialised and controlled via another driver, 
> in the audio codec?

That would be the normal place to control a PLL used to clock the audio
subsystem, yes.  If it's more generally used then it probably ought to
go in the core driver - something along the lines of the clock API would
be useful for arbitration (the clock API itself can't really be used
since it only really works with on-SoC clocks).
