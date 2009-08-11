Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZHKMnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZHKMnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZHKMnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:43:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37220 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754192AbZHKMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:41:48 -0400
Date: Tue, 11 Aug 2009 11:15:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/5] drivers/mfd: Add Freescale MC13783 driver
Message-ID: <20090811101507.GB7572@rakim.wolfsonmicro.main>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de>
 <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de>
X-Cookie: Beware of geeks bearing graft.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:07:43AM +0200, Sascha Hauer wrote:

> +static int __init pmic_init(void)
> +{
> +	return spi_register_driver(&pmic_driver);
> +}
> +module_init(pmic_init);

This should be subsys_initcall() so that the regulators can come up
early.
