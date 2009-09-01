Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZIANsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZIANsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZIANsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:48:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40583 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbZIANsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:48:03 -0400
Date: Tue, 1 Sep 2009 14:47:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
Message-ID: <20090901134751.GR19719@n2100.arm.linux.org.uk>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 11:29:09PM +0200, Linus Walleij wrote:
> This adds support for the regulators found in the AB3100
> Mixed-Signal IC.

Not sure why I was cc'd on this, but only one comment from me...

> +/* Preset (hardware defined) voltages for these regulators */
> +#define LDO_A_VOLTAGE 2750000
> +#define LDO_C_VOLTAGE 2650000
> +#define LDO_D_VOLTAGE 2650000
> +
> +int ldo_e_buck_typ_voltages[] = {
> +	1800000,
> +	1400000,
> +	1300000,
> +	1200000,
> +	1100000,
> +	1050000,
> +	900000,
> +};
> +
> +int ldo_f_typ_voltages[] = {
> +	1800000,
> +	1400000,
> +	1300000,
> +	1200000,
> +	1100000,
> +	1050000,
> +	2500000,
> +	2650000,
> +};
> +
> +int ldo_g_typ_voltages[] = {
> +	2850000,
> +	2750000,
> +	1800000,
> +	1500000,
> +};
> +
> +int ldo_h_typ_voltages[] = {
> +	2750000,
> +	1800000,
> +	1500000,
> +	1200000,
> +};
> +
> +int ldo_k_typ_voltages[] = {
> +	2750000,
> +	1800000,
> +};

Is there a reason for these to be globally visible?
