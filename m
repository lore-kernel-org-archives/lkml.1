Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXCWH27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXCWH27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934037AbXCWH27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:28:59 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3123 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934024AbXCWH26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:28:58 -0400
Date: Fri, 23 Mar 2007 08:27:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm try#2] Blackfin: on-chip Two Wire Interface I2C
 driver
Message-Id: <20070323082719.82c02731.khali@linux-fr.org>
In-Reply-To: <1174628817.18866.21.camel@roc-desktop>
References: <1174471688.5648.56.camel@roc-desktop>
	<20070321202231.2eac1cf9.khali@linux-fr.org>
	<8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
	<20070322084806.8bf0f231.khali@linux-fr.org>
	<8bd0f97a0703220112y7d6cef2ax612ea5ece3df9740@mail.gmail.com>
	<20070322102431.b55f7ecd.khali@linux-fr.org>
	<1174628817.18866.21.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Fri, 23 Mar 2007 13:46:57 +0800, Wu, Bryan wrote:
> Changlogs:
> 
> a) Fixed issues according to Jean's review.
> b) Add MAINTAINS infomation
> c) add I2C_HW_B_BLACKFIN to i2c-id.h

I2C_HW_B_* is traditionally used for drivers built on top of the
i2c-algo-bit driver, which isn't the case of your driver, so it's a bit
confusing. Please instead use:

#define I2C_HW_BLACKFIN		0x190001

I hope we'll be able to get rid of these IDs soon, so we no longer have
to care about this mess.

Other than that I'm OK with the patch this time, I'll push it on my
stack. I'll fix the ID issue myself, no need to resend. This also means
that, from now on, any change to this driver should be provided as an
incremental patch on top of this version.

Thanks,
-- 
Jean Delvare
