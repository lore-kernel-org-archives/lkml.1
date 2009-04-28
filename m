Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZD1IXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZD1IXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbZD1IXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:23:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48225 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932130AbZD1IXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:23:03 -0400
Date: Tue, 28 Apr 2009 09:23:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: eric.miao@marvell.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: Patch to add mioa701 glue for voltage regulation
Message-ID: <20090428082301.GD20027@rakim.wolfsonmicro.main>
References: <87iqkvp6i3.fsf@free.fr> <1240566136.27410.3291.camel@vega.slimlogic.co.uk> <87d4ax7qf3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4ax7qf3.fsf@free.fr>
X-Cookie: Process promptly.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 11:11:28PM +0200, Robert Jarzmik wrote:

> +static struct regulator_init_data max1586_v6_info = {
> +	.constraints = {
> +		.name = "vcc_usim range",
> +		.min_uV = 1,
> +		.max_uV = 3000000,
> +		.always_on = 1,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +	},
> +	.num_consumer_supplies = 0,
> +};

I'd still prefer to omit this for now due to the use of 1uV to mean
disabling the regulator - there are no consumers so it won't make any
practical difference.
