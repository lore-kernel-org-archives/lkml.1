Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZCQH01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZCQH01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZCQH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:26:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40872 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZCQH0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:26:16 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>
Date: Tue, 17 Mar 2009 12:55:14 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Index: AcmmZqoCMt1OKqVoQb27UHR6scfHFAAVW0Xg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CC30E0D1@dbde02.ent.ti.com>
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
 <200903161140.01121.david-b@pacbell.net>
In-Reply-To: <200903161140.01121.david-b@pacbell.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> And there are other DaVinci chips that support MMC too ...
> some are compatible with those two chips, some not, all
> should use a version of this driver.  (And OMAP-L137 too,
> same tech family but with a different marketing label.)
> 
> So I'd remove the implication that DaVinci == DM6446, or
> that this driver is specific to that SoC.

I will update the description as suggested by you when I will re-submit.


> > +config MMC_DAVINCI
> > +        tristate "TI DAVINCI Multimedia Card Interface support"
> > +        depends on MMC
> 
> Everything in that menu depends on MMC.  This should
> depend on ARCH_DAVINCI instead.  :)

I will add "depends on ARCH_DAVINCI"


> > +       host->clk = clk_get(&pdev->dev, NULL);
> 
> The NULL won't work with the clock code currently
> included in mainline ... "MMCSDCLK" will though.

I will take care of this by changing to "MMCSDCLK" from NULL.



> > +       if (pdata->max_freq)
> > +               mmc->f_max = pdata->max_freq;
> > +       if (pdata->caps)
> > +               mmc->caps |= pdata->caps;
> 
> A build-time issue is that "struct davinci_mmc_config"
> is missing.  You could update this patch to include
> "arch/arm/mach-davinci/include/mach/mmc.h" too.

I will add in the patch as well.
- Purushotam

