Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXCWHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXCWHgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXCWHgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:36:21 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:33675 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbXCWHgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:36:21 -0400
X-IronPort-AV: i="4.14,317,1170651600"; 
   d="scan'208"; a="25253731:sNHT23345609"
Subject: Re: [PATCH -mm try#2] Blackfin: on-chip Two Wire Interface I2C
	driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jean Delvare <khali@linux-fr.org>
Cc: Bryan Wu <bryan.wu@analog.com>, Mike Frysinger <vapier.adi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070323082719.82c02731.khali@linux-fr.org>
References: <1174471688.5648.56.camel@roc-desktop>
	 <20070321202231.2eac1cf9.khali@linux-fr.org>
	 <8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
	 <20070322084806.8bf0f231.khali@linux-fr.org>
	 <8bd0f97a0703220112y7d6cef2ax612ea5ece3df9740@mail.gmail.com>
	 <20070322102431.b55f7ecd.khali@linux-fr.org>
	 <1174628817.18866.21.camel@roc-desktop>
	 <20070323082719.82c02731.khali@linux-fr.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 23 Mar 2007 15:36:30 +0800
Message-Id: <1174635390.18866.28.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 08:27 +0100, Jean Delvare wrote:
> Hi Bryan,
> 
> On Fri, 23 Mar 2007 13:46:57 +0800, Wu, Bryan wrote:
> > Changlogs:
> > 
> > a) Fixed issues according to Jean's review.
> > b) Add MAINTAINS infomation
> > c) add I2C_HW_B_BLACKFIN to i2c-id.h
> 
> I2C_HW_B_* is traditionally used for drivers built on top of the
> i2c-algo-bit driver, which isn't the case of your driver, so it's a bit
> confusing. Please instead use:
> 
> #define I2C_HW_BLACKFIN		0x190001
> 
> I hope we'll be able to get rid of these IDs soon, so we no longer have
> to care about this mess.

Thanks, I appreciate. When you want to get rid of these IDs, I will do
the removing ID job related to this patch.

> 
> Other than that I'm OK with the patch this time, I'll push it on my
> stack. I'll fix the ID issue myself, no need to resend. This also means
> that, from now on, any change to this driver should be provided as an
> incremental patch on top of this version.
> 
> Thanks,

OK, I will follow this rule definitely.
Thanks again
-Bryan Wu
