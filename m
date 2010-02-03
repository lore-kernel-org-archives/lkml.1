Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0BCTPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:15:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1834 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab0BCTPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:15:36 -0500
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
From: Joe Perches <joe@perches.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
In-Reply-To: <4B69B0A0.2040701@teksavvy.com>
References: <cover.1265095093.git.joe@perches.com>
	 <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>
	 <4B69B0A0.2040701@teksavvy.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 11:15:35 -0800
Message-ID: <1265224535.24887.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 12:21 -0500, Mark Lord wrote:
> Joe Perches wrote:
> > String constants that are continued on subsequent lines with \
> > are not good.
[]
> > -		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
> > -				set PIO_0 timing\n", ret);
> > +		dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0 timing\n",
> > +			 ret);
> NAK.  Just stick the ret); part onto the same line and be done with it.

:resend that I mistakenly sent only to Mark, with a couple more comments

I disagree.

Look at the long line wrapping style of the rest of the file
and most of the kernel source.  No additional arguments to
functions are generally used after column 80.

If it's ever agreed that all lines > 80 cols are OK or
new args after column 80 are OK, then sure.  Until then,
if you want it, you should do it.

cheers, Joe

$ grep -A 1 "\bdev_" drivers/ata/pata_at91.c 
	dev_dbg(dev, "ATA timings: nrd_setup = %lu nrd_pulse = %lu nrd_cycle = %lu\n",
			nrd_setup, nrd_pulse, read_cycle);
	dev_dbg(dev, "ATA timings: nwe_setup = %lu nwe_pulse = %lu nwe_cycle = %lu\n",
			nwe_setup, nwe_pulse, write_cycle);
	dev_dbg(dev, "ATA timings: ncs_read_setup = %lu ncs_read_pulse = %lu\n",
			ncs_read_setup, ncs_read_pulse);
	dev_dbg(dev, "ATA timings: ncs_write_setup = %lu ncs_write_pulse = %lu\n",
			ncs_write_setup, ncs_write_pulse);
--
		dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0 timing\n",
			 ret);
--
		dev_err(&pdev->dev, "invalid number of resources\n");
		return -EINVAL;
--
		dev_err(dev, "failed to get mem resource\n");
		return -EINVAL;
--
		dev_err(dev, "failed to allocate memory for private data\n");
		return -ENOMEM;
--
		dev_err(dev, "failed to get access to mck clock\n");
		return -ENODEV;
--
		dev_err(dev, "failed to map IO base\n");
		ret = -ENOMEM;
--
		dev_err(dev, "failed to map CTL base\n");
		ret = -ENOMEM;
--
	struct ata_host *host = dev_get_drvdata(&pdev->dev);
	struct at91_ide_info *info;



