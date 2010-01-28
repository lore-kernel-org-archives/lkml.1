Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946Ab0A1XIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0A1XIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291Ab0A1XIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:08:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab0A1XIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:08:36 -0500
Date: Fri, 29 Jan 2010 00:08:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo "definetly" -> "definitely"
In-Reply-To: <1264712983-26901-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1001290008230.356@pobox.suse.cz>
References: <1264712983-26901-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Uwe Kleine-König wrote:

> ---
>  drivers/i2c/algos/i2c-algo-pcf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
> index 7ce7577..6b6bd06 100644
> --- a/drivers/i2c/algos/i2c-algo-pcf.c
> +++ b/drivers/i2c/algos/i2c-algo-pcf.c
> @@ -176,7 +176,7 @@ static int pcf_init_8584 (struct i2c_algo_pcf_data *adap)
>  	 */
>  	if (((temp = get_pcf(adap, 1)) & 0x7f) != (0)) {
>  		DEB2(printk(KERN_ERR "i2c-algo-pcf.o: PCF detection failed -- can't select S0 (0x%02x).\n", temp));
> -		return -ENXIO; /* definetly not PCF8584 */
> +		return -ENXIO; /* definitely not PCF8584 */

Applied. thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
