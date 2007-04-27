Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbXD0Syj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbXD0Syj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXD0Syi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:54:38 -0400
Received: from dns1.vpop.net ([216.193.240.2]:64020 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbXD0Syc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:54:32 -0400
In-Reply-To: <74d0deb30704270052w1b6e2b92t590368936e711d6d@mail.gmail.com>
References: <20070424100203.GB16473@2ka.mipt.ru> <20070425174643.f1fc189d.akpm@linux-foundation.org> <50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net> <74d0deb30704270052w1b6e2b92t590368936e711d6d@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <D11FE199-C939-4B8D-BA09-2884BE537410@vpop.net>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Matt Reimer <mreimer@vpop.net>
Subject: Re: [2/2] Driver for the Maxim DS1WM, a 1-wire bus master ASIC core.
Date: Fri, 27 Apr 2007 11:54:23 -0700
To: pHilipp Zabel <philipp.zabel@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 27, 2007, at 12:52 AM, pHilipp Zabel wrote:

> diff --git a/drivers/w1/masters/Makefile b/drivers/w1/masters/Makefile
> index 4cee256..a9e45fb 100644
> --- a/drivers/w1/masters/Makefile
> +++ b/drivers/w1/masters/Makefile
> @@ -5,4 +5,4 @@
> obj-$(CONFIG_W1_MASTER_MATROX)		+= matrox_w1.o
> obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
> obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
> -
> +obj-$(CONFIG_W1_DS1WM)                  += ds1wm.o
>
> Wouldn't it be better to call the config option CONFIG_W1_MASTER_DS1WM
> for consistency?

Yes it would. I've made this change. Thanks for the suggestion.

Matt

