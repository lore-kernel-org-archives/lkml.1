Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZKKOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZKKOLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZKKOLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:11:50 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:59745 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbZKKOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:11:50 -0500
Subject: Re: [PATCH 2/2] regulator/mc13783: various cleanups
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091106002847.GC22366@sortiz.org>
	 <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 14:11:48 +0000
Message-ID: <1257948708.3089.101.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 09:18 +0100, Uwe Kleine-König wrote:
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
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---

I assume the new mc13783 function and type definitions are in mfd-next ?

  CC [M]  drivers/regulator/mc13783-regulator.o
drivers/regulator/mc13783-regulator.c: In function ‘mc13783_regulator_enable’:
drivers/regulator/mc13783-regulator.c:116: error: implicit declaration of function ‘mc13783_lock’
drivers/regulator/mc13783-regulator.c:117: error: implicit declaration of function ‘mc13783_reg_rmw’
drivers/regulator/mc13783-regulator.c:120: error: implicit declaration of function ‘mc13783_unlock’
drivers/regulator/mc13783-regulator.c: In function ‘mc13783_regulator_is_enabled’:
drivers/regulator/mc13783-regulator.c:148: error: implicit declaration of function ‘mc13783_reg_read’
drivers/regulator/mc13783-regulator.c: In function ‘mc13783_regulator_probe’:
drivers/regulator/mc13783-regulator.c:175: error: dereferencing pointer to incomplete type
drivers/regulator/mc13783-regulator.c:182: error: dereferencing pointer to incomplete type
drivers/regulator/mc13783-regulator.c:183: error: dereferencing pointer to incomplete type
drivers/regulator/mc13783-regulator.c: In function ‘mc13783_regulator_remove’:
drivers/regulator/mc13783-regulator.c:215: error: dereferencing pointer to incomplete type
make[1]: *** [drivers/regulator/mc13783-regulator.o] Error 1
make: *** [drivers/regulator/mc13783-regulator.o] Error 2


Liam

