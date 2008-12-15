Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYLOLf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYLOLf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYLOLfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:35:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1996 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYLOLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:35:50 -0500
Date: Mon, 15 Dec 2008 11:35:49 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Liam Girdwood <lrg@simlogic.co.uk>
Subject: Re: [PATCH 7/7] regulator: PCF50633 pmic driver
Message-ID: <20081215113547.GC31145@sirena.org.uk>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110400.3307.57681.stgit@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214110400.3307.57681.stgit@cff.thadambail>
X-Cookie: Knowledge is power.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 04:34:00PM +0530, Balaji Rao wrote:

> +struct regulator_ops pcf50633_regulator_ops = {
> +	.set_voltage = pcf50633_regulator_set_voltage,
> +	.get_voltage = pcf50633_regulator_get_voltage,
> +	.enable = pcf50633_regulator_enable,
> +	.disable = pcf50633_regulator_disable,
> +	.is_enabled = pcf50633_regulator_is_enabled,
> +	.set_suspend_enable = pcf50633_regulator_enable,
> +	.set_suspend_disable = pcf50633_regulator_disable,
> +};

Are you sure that the suspend variants of the operations should be the
same as the regular versions?

> +struct platform_driver pcf50633_regulator_driver = {
> +	.driver = {
> +		.name = "pcf50633-regltr",
> +	},
> +	.probe = pcf50633_regulator_probe,
> +	.remove = __devexit_p(pcf50633_regulator_remove),
> +};

Not that it matters too much but I have a hard time liking "regltr".
