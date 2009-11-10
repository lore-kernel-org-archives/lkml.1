Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbZKJNIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbZKJNIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZKJNIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:08:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42075 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756005AbZKJNIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:08:45 -0500
Date: Tue, 10 Nov 2009 13:08:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] regulator/mc13783: various cleanups
Message-ID: <20091110130849.GE16200@rakim.wolfsonmicro.main>
References: <20091106002847.GC22366@sortiz.org>
 <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 09:18:07AM +0100, Uwe Kleine-König wrote:
> - define needed registers and bits in the driver
> - properly namespace functions and structs
> - fix locking as required by patch
>   "mfd/mc13783: near complete rewrite"
> - use platform_data as provided by "mfd/mc13783: near complete rewrite"
>   instead of accessing struct mc13783
> - struct mc13783_regulator_priv.desc is (and was) unused and so can go
>   away
> - use cpp magic to initialize mc13783_regulators
> - bring MODULE_LICENSE in sync with actual copyright
> - minor style fixes
> 
> This allows not including mc13783-private.h which I intend to remove
> soon.

Acked-by: Mark Brown <broonie@opensoruce.wolfsonmicro.com>

It'd have been a bit easier to review if done as more patches - eg, the
change to use macros to define the regulators could've been done as a
separate patch.
