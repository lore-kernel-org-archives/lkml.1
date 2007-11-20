Return-Path: <linux-kernel-owner+w=401wt.eu-S1763163AbXKTWYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163AbXKTWYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbXKTWYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:24:11 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:54895 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbXKTWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:24:10 -0500
Subject: Re: [patch] 0/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <474359E3.2020603@gmail.com>
References: <1195591234.2329.52.camel@wirenth>  <474359E3.2020603@gmail.com>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 22:20:52 +0000
Message-Id: <1195597252.2329.70.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 01:04 +0300, Dmitry Baryshkov wrote:
> Just to note, that there is an alternative implementation for at least
> the tc6393 chip devices. Most current version of those patches can be 
> found in the OpenEmbedded monotone. 

Yes, this is true. The core code in both cases originates from my and
Dirks work.

I'd just like to get something pushed up to mainline so that work can
begin on expanding the number of chips supported.

This would include the ASICs found in many iPAQ PDAs (their MMC module
seems to be an IRQ-less TMIO chip).

I havent submitted the subdevice drivers yet, only the base/core
drivers.

The OE versions probably have better USB and video subdevice support
(which I shall evaluate as I go on), wheras the NAND flash and MMC
drivers in hh.org are probably more up to date (I run root on SD usinf
the hh.org tmio_mmc driver on all three of the MFD chips in this patch
series on a daily basis).

merging the best of these patch series is my goal and it shouldnt be too
hard.



