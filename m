Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZHKMHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZHKMHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZHKMGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:06:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42843 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753190AbZHKMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:06:49 -0400
Date: Tue, 11 Aug 2009 11:12:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/5] drivers/mfd: Add Freescale MC13783 driver
Message-ID: <20090811101240.GA7572@rakim.wolfsonmicro.main>
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

> +/*
> + * Register a client device.  This is non-fatal since there is no need to
> + * fail the entire device init due to a single platform device failing.
> + */
> +static void mc13783_client_dev_register(struct mc13783 *mc13783,
> +				       const char *name,
> +				       struct platform_device **pdev)

Some of this code is looking distinctly familiar :)

> +#define	SW_SW1A		0
> +#define	SW_SW1B		1

This and the other defines following look like they should probably be
namespaced.
