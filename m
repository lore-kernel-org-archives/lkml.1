Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZKKOQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZKKOQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZKKOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:16:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZKKOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:16:50 -0500
Date: Wed, 11 Nov 2009 15:16:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] regulator/mc13783: various cleanups
Message-ID: <20091111141623.GB1849@pengutronix.de>
References: <20091106002847.GC22366@sortiz.org> <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de> <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de> <1257948708.3089.101.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1257948708.3089.101.camel@odin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 11, 2009 at 02:11:48PM +0000, Liam Girdwood wrote:
> On Tue, 2009-11-10 at 09:18 +0100, Uwe Kleine-König wrote:
> > - define needed registers and bits in the driver
> > - properly namespace functions and structs
> > - fix locking as required by patch
> >   "mfd/mc13783: near complete rewrite"
> > - use platform_data as provided by "mfd/mc13783: near complete rewrite"
> >   instead of accessing struct mc13783
> > - struct mc13783_regulator_priv.desc is (and was) unused and so can go
> >   away
> > - use cpp magic to initialize mc13783_regulators
> > - bring MODULE_LICENSE in sync with actual copyright
> > - minor style fixes
> > 
> > This allows not including mc13783-private.h which I intend to remove
> > soon.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> 
> I assume the new mc13783 function and type definitions are in mfd-next ?
Yes, it's 3a69e7d9f6b1fb6c6db7f23e22351e3db7d55ebb in todays linux-next.
 
Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
