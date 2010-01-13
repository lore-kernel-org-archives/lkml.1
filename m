Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0AMMDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0AMMDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967Ab0AMMDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:03:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44160 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752885Ab0AMMD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:03:29 -0500
Date: Wed, 13 Jan 2010 12:03:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Roger Quadros <ext-roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage
 regulators
Message-ID: <20100113120327.GB27473@rakim.wolfsonmicro.main>
References: <4B4DB562.2080601@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DB562.2080601@nokia.com>
X-Cookie: Kiss me twice.  I'm schizophrenic.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 01:58:26PM +0200, Adrian Hunter wrote:

> Add a field to specify a delay for the start-up time of
> a fixed voltage regulator.

> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but...

> #include <linux/regulator/driver.h>
> #include <linux/regulator/fixed.h>
> #include <linux/gpio.h>
> +#include <linux/delay.h>

I think your MUA may have eaten the patch - it looks like the leading
spaces got stripped which is liable to confuse things.

> --- a/include/linux/regulator/fixed.h
> +++ b/include/linux/regulator/fixed.h
> @@ -25,6 +25,7 @@ struct regulator_init_data;
>  * @microvolts:		Output voltage of regulator
>  * @gpio:		GPIO to use for enable control
>  * 			set to -EINVAL if not used
> + * @delay:		Start-up time in microseconds

startup_delay?  Just in case we think of another delay, though I'm
struggling to think of one right now so I'm not too worried.
