Return-Path: <linux-kernel-owner+w=401wt.eu-S937890AbZLHXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937890AbZLHXdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937002AbZLHXdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:33:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937001AbZLHXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:33:16 -0500
Date: Tue, 8 Dec 2009 15:32:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       Sascha Hauer <s.hauer@pengutronix.de>, Daniel Mack <daniel@caiaq.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/5] spi-imx: some updates
Message-Id: <20091208153239.af0b5bb8.akpm@linux-foundation.org>
In-Reply-To: <20091208211258.GA13706@pengutronix.de>
References: <20091208211258.GA13706@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009 22:12:58 +0100
Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> this series depends on "spi: drain MXC SPI transfer buffer when probing
> device" which is currently in -mm and also included in my spi-imx branch
> (see below).  IMHO at least my first patch should go into .33 as it
> fixes an oops.

I queued all five for 2.6.33.


Once I've merged up the current -mm patch queue:

atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch
spi-controller-driver-for-designware-spi-core.patch
#
spi-add-pci-interface-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
#
spidev-add-proper-section-markers.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch
spi-nuc900-add-arm-driver-support-for-nuc900.patch
spi-fix-spidev-compilation-failure-when-verbose-is-defined.patch
#
spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch
spi-imx-correct-check-for-platform_get_irq-failing.patch
spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch
spi-imx-add-mx25-support.patch
spi-imx-dont-access-struct-device-directly-but-use-dev_get_platdata.patch


I shall stop sending SPI patches to Linus.  I'll send any which I
accumulate to Grant instead.


